assert = require "assert"
indexer = require "../src/indexer"
fs = require "fs"

describe "indexer", ->

  # index()
  # ###########################################################################

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
        indexer.indexText "rawtext"

    it "should error out on something that is not a proper key/value object", ->
      assert.throws ->
        indexer.indexText
          key:
            value: test

    it "should return an indexed object", ->
      test = indexer.indexText
        one: one
        two: two
      assert.deepEqual test.data, result

    it "should return an indexed object without doubles", ->
      test = indexer.indexText
        one: doubleOne
        two: two
      assert.deepEqual test.data, result


    it "should create an indexed object using just one property", ->
      test = indexer.indexText
        one:
          text: one
        two:
          text: two
      , "text"
      assert.deepEqual test.data, result

    it "should find both documents when searching for This", ->
      test = indexer.indexText
        one:
          text: one
        two:
          text: two
      , "text"
      result = test.query "This"

      assert.deepEqual result, ["one", "two"]

    it "should create an indexed object using multiple properties", ->
      test = indexer.indexText
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
      "JF",
      "BNKSHMRKNK",
      "SNKLTN",
      "AN",
      "ES",
      "US",
      "TMNK",
      "KLS",
      "PSBL",
      "IMPRFMNTS",
      "KRT",
      "BNKSHMRK",
      "PRFTR",
      "SFRL",
      "UNK",
      "INSTNSS"
    ]

  describe "#indexFile()", ->
    it "should process file title/info with extension", (done) ->
      indexer.indexFile testFile+".json", ["title", "info"], (contents) ->
        assert.deepEqual contents.data, fileResult
        done()

    it "should query processed file title/info with extension", (done) ->
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

  # indexDir()
  # ###########################################################################

  testBenchmarkerPythonConfig =
    pythonconfig: [ "P0N", "KLBL", "KNFKRXN" ]
    benchmarker: [
      "JF",
      "BNKSHMRKNK",
      "SNKLTN",
      "AN",
      "ES",
      "US",
      "TMNK",
      "KLS",
      "PSBL",
      "IMPRFMNTS",
      "KRT",
      "BNKSHMRK",
      "PRFTR",
      "SFRL",
      "UNK",
      "INSTNSS"
    ]
 
  describe "#indexDir()", ->
    it "should process dir", (done) ->
      indexer.indexDir "./test/articles/", ["title", "info"], (contents) ->
        # order is not guaranteed so a direct assert on contents.data may fail
        for key, value of contents.data
          assert.deepEqual contents.data[key], testBenchmarkerPythonConfig[key]
        done()
 
  # save()
  # ###########################################################################
 
  test = indexer.indexText
    one: one
    two: two

  testResultFile = "./test/articles/indexed/benchmarker.json"
  testCorrectFile = "./test/articles/indexed/benchmarker.json"

  describe "#save()", ->
    it "should error out when you try to save a non-Index", ->
      assert.throws ->
        indexer.save "rawtext"

    it "should save the indexed data", (done) ->
      indexer.save test, testResultFile, (stringified) ->
        fs.readFile testCorrectFile, "utf-8", (err, data) ->
          throw err if err?
          fs.readFile testResultFile, "utf-8", (err, processedData) ->
            throw err if err?
            assert.equal data, processedData
            fs.unlinkSync testResultFile
            done()
