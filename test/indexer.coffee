assert = require "assert"
indexer = require "../src/indexer"

describe "indexer", ->

  doubleOne = "This is one one one one small test"
  one = "This is one small test"
  two = "This is one small test again"

  result =
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

  altResult =
    one: [
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
      assert.deepEqual test, result

    it "should return an indexed object without doubles", ->
      test = indexer.index
        one: doubleOne
        two: two
      assert.deepEqual test, result


    it "should create an indexed object using just one property", ->
      test = indexer.index
        one:
          text: one
        two:
          text: two
      , "text"
      assert.deepEqual test, result

    it "should create an indexed object using multiple properties", ->
      test = indexer.index
        one:
          textOne: one
          textTwo: two
      , ["textOne", "textTwo"]
      assert.deepEqual test, altResult
