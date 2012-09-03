assert = require "assert"

describe "Array", ->
  describe "#indexOf()", ->
    it "should return -1 when the array does not contain the element", ->
      assert.equal -1, [1,2,3].indexOf 5
