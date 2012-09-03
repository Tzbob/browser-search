assert = require "assert"
indexer = require "../src/indexer"

describe "indexer", ->

  one = "This is one small test"
  two = "This is one small test again"

  smallResult =
    one: [
      "0S"
      , "ON"
      , "SML"
      , "TST"
    ]
    two: [
      "0S"
      , "ON"
      , "SML"
      , "TST"
      , "AKN"
    ]

  describe "#index()", ->
    it "should error out on something that isn't an object", ->
      assert.throws ->
        indexer.index "rawtext"

    it "should return an indexed object", ->
      test = indexer.index
        one: one
        two: two
      assert.deepEqual test, smallResult

    it "should create an indexed object using just one property", ->
      test = indexer.index
        one:
          text: one
        two:
          text: two
      , "text"
      assert.deepEqual test, smallResult
