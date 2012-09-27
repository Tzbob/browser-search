exportModule = (root, name, factory) ->
  if typeof define is "function" and define.amd
    define [], factory
  else
    root[name] = factory()
 
exportModule window, "Index", ->
  Index = require "./index"
