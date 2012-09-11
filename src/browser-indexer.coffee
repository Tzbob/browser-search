indexer = require "./indexer"

exports.process = (program) ->
  indexer.indexDir program.args[0], program.toIndex, (index) ->
    if program.print
      console.log index.stringify true
    else
      console.log """
      Completed the indexing for #{program.args[0]}
      """

    if program.output?
      indexer.save index, program.output, ->
        console.log """
        Saved the indexed data to #{program.output}
        """
