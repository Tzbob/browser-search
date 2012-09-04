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

  # index()
  # ###########################################################################

  describe "#index()", ->
    it "should error out on something that isn't an object", ->
      assert.throws ->
        indexer.index "rawtext"

    it "should return an indexed object", ->
      test = indexer.index
        one: one
        two: two
      assert.deepEqual test.data, result

    it "should return an indexed object without doubles", ->
      test = indexer.index
        one: doubleOne
        two: two
      assert.deepEqual test.data, result


    it "should create an indexed object using just one property", ->
      test = indexer.index
        one:
          text: one
        two:
          text: two
      , "text"
      assert.deepEqual test.data, result

    it "should find both documents when searching for This", ->
      test = indexer.index
        one:
          text: one
        two:
          text: two
      , "text"
      result = test.query "This"

      assert.deepEqual result, ["one", "two"]

    it "should create an indexed object using multiple properties", ->
      test = indexer.index
        one:
          textOne: one
          textTwo: two
      , ["textOne", "textTwo"]
      assert.deepEqual test.data, altResult

  # indexFile()
  # ###########################################################################

  testFile = "./test/articles/benchmarker"
  fileResult =
    benchmarker: [
      'JF',
      'BNKSHMRKNK',
      'SNKLTN',
      'AN',
      'ES',
      'US',
      'TMNK',
      'KLS',
      'PSBL',
      'IMPRFMNTS',
      'KRT',
      'BNKSHMRK',
      'PRFTR',
      'SFRL',
      'UNK',
      'INSTNSS'
    ]

  describe "#indexFile()", ->
    it "should process file title/info with extension", (done) ->
      indexer.indexFile testFile+".json", ["title", "info"], (contents) ->
        assert.deepEqual contents.data, fileResult
        done()

    it "should query processed file title/info without extension", (done) ->
      indexer.indexFile testFile+".json", ["title", "info"], (contents) ->
        assert.deepEqual contents.query("benchmark"), ["benchmarker"]
        done()

    it "should process file title/info without extension", (done) ->
      indexer.indexFile testFile, ["title", "info"], (contents) ->
        assert.deepEqual contents.data, fileResult
        done()

    it "should query processed file title/info without extension", (done) ->
      indexer.indexFile testFile, ["title", "info"], (contents) ->
        assert.deepEqual contents.query("benchmark"), ["benchmarker"]
        done()
