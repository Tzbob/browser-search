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

indexFile = (file, toIndex, callback) ->
  file += ".json" if !file.match /.json$/
  fs.readFile file, "utf-8", (err, contents) ->
    throw err if err?

    # from last "/" to length - 5 ".json"
    filename = file.substring(1+file.lastIndexOf("/"), file.length - 5)

    raw = {}
    raw[filename] = JSON.parse contents

    processed = index raw, toIndex

    callback processed

index = (raw, toIndex) ->
  throw new Error "must pass an object" if typeof raw != 'object'

  results = {}

  for key, object of raw

    # Nothing toIndex -> index object
    if !toIndex?
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

module.exports.index = index
module.exports.indexFile = indexFile
