Index = require "./index"
natural = require "natural"
fs = require "fs"

metaphone = natural.Metaphone
metaphone.attach()

removeDuplicates = (array) ->
  output = {}

  # Create an object in the form of: 
  #   value -> value
  # This makes duplicate values overwrite each other
  for i in [0..array.length-1]
    output[array[i]] = array[i]

  return (value for key, value of output)

indexText = (raw, toIndex) ->
  throw new Error "must pass an object" if typeof raw != "object"

  results = {}

  for key, object of raw

    # Nothing toIndex -> index object
    if !toIndex?
      if typeof object != "string"
        throw new Error """
          Problem while indexing your data.
          #{JSON.stringify object, null, 2} 
          Can not be tokenized because it is not a string.
          Try providing the keys to-be-indexed.
        """

      results[key] = object.tokenizeAndPhoneticize()

    # Multiple toIndex properties -> index all
    else if toIndex instanceof Array
      buffer = []
      for target in toIndex
        buffer = buffer.concat object[target].tokenizeAndPhoneticize()
      results[key] = buffer

    # One index property -> index it
    else
      results[key] = object[toIndex].tokenizeAndPhoneticize()

    results[key] = removeDuplicates results[key]

  return new Index results

indexFile = (file, toIndex, callback) ->
  file += ".json" if !file.match /.json$/
  fs.readFile file, "utf-8", (err, contents) ->
    throw err if err?

    # from last "/" to length - 5 ".json"
    filename = file.substring(1+file.lastIndexOf("/"), file.length - 5)

    raw = {}
    raw[filename] = JSON.parse contents

    processed = indexText raw, toIndex

    callback processed

indexDir = (dir, toIndex, callback) ->
  fs.readdir dir, (err, files) ->
    throw err if err?

    files = files.filter (file) -> file.match /.json$/

    index = new Index {}

    indexRecursive = (i) ->
      fullPath = dir+"/"+files[i]

      indexFile fullPath, toIndex, (contents) ->
        index.extend contents
        callback index if i >= files.length - 1

      indexRecursive i+1 if i < files.length - 1

    indexRecursive 0

save = (index, file, callback) ->
  throw new Error "must pass an object" if index !instanceof Index

  stringified = index.stringify true

  file = file+".json" if !file.match /.json$/

  fs.writeFile file, stringified, (err) ->
    throw err if err?
    callback stringified

module.exports.indexText = indexText
module.exports.indexFile = indexFile
module.exports.indexDir = indexDir
module.exports.save = save
