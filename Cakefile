{exec, spawn} = require "child_process"

build = (watch) ->
  opts = ["-c", "-o", "lib/", "src/"]
  opts.unshift "-w" if watch

  coffee = spawn "./node_modules/.bin/coffee", opts
  coffee.stdout.on "data", (data) -> console.log data.toString()
  coffee.stderr.on "data", (data) -> console.log data.toString()

run = (command) ->
  exec command, (err, stdout, stderr) ->
    console.log stdout if stdout?
    console.log stderr if stderr?

# Tasks
# ##############################################################################

task "build", "Build src/*.coffee to lib/*js", ->
  build false
  invoke "build:browserindex"

task "build:browserindex", "Build src/*.coffee to lib/*js", ->
  run "browserify ./lib/index.browserwrap.js -o ./build/browserindex.js" +
      "&& uglifyjs -o ./build/browserindex.min.js ./build/browserindex.js"

task "watch", "Build src/*.coffee to lib/*js", ->
  build true

task "test", "Run test/*", ->
  run "./node_modules/.bin/mocha test/*.coffee"
