natural = require "natural"
metaphone = natural.Metaphone
metaphone.attach()

removeDuplicates = (array) ->
  output = {}

  for i in [0..array.length-1]
    output[array[i]] = array[i]

  return (value for key, value of output)

index = (raw, toIndex) ->
  throw new Error "must pass an object" if typeof raw != 'object'

  results = {}

  for key, object of raw

    if !toIndex?
      results[key] = object.tokenizeAndPhoneticize()

    else if toIndex instanceof Array
      buffer = []
      for index in toIndex
        buffer = buffer.concat object[index].tokenizeAndPhoneticize()
      results[key] = buffer

    else
      results[key] = object[toIndex].tokenizeAndPhoneticize()

    results[key] = removeDuplicates results[key]

  return results

    #for key, value of asarray
    #print key if metaphone.process("screen") in value

exports.index = index
