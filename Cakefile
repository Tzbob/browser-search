{exec} = require "child_process"

run = (command) ->
  exec command, (err, stdout, stderr) ->
    throw err if err?
    console.log stdout, stderr

task "build", "Build src/*.coffee to lib/*js", ->
  run "./node_modules/.bin/coffee -c -o lib/ src/"

task "watch", "Build src/*.coffee to lib/*js", ->
  run "./node_modules/.bin/coffee -w -c -o lib/ src/"

task "test", "Run test/*", ->
  run "./node_modules/.bin/mocha test/*.coffee"
