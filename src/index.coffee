natural = require "natural"
metaphone = natural.Metaphone

class Index
  constructor: (@data) ->
  query: (word) ->
    processedWord = metaphone.process word
    results = []

    for key, value of @data
      if processedWord in value
        results.push key

    return results

module.exports = Index
