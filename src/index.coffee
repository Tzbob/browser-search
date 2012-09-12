{Metaphone} = require "natural"
metaphone = Metaphone

class Index
  constructor: (@data) ->

  extend: (index) ->
    for key, value of index.data
      if index.data.hasOwnProperty key
        @data[key] = value

  query: (word) ->
    processedWord = metaphone.process word
    results = []

    for key, value of @data
      if processedWord in value
        results.push key

    return results

  stringify: (format) ->
    if !format
      return JSON.stringify @data
    else
      return JSON.stringify @data, null, 2

module.exports = Index
