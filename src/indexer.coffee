natural = require "natural"
metaphone = natural.Metaphone
metaphone.attach()

index = (raw, toIndex) ->
  throw new Error "must pass an object" if typeof raw != 'object'

  results = {}

  for key, object of raw
    if toIndex?
      results[key] = object[toIndex].tokenizeAndPhoneticize()
    else
      results[key] = object.tokenizeAndPhoneticize()

  return results

    #for key, value of asarray
    #print key if metaphone.process("screen") in value

exports.index = index
