#= require src/utils/namespacing
#= require src/utils/domready
#= require src/utils/browser
#= require src/gag
#= require src/head/main

class Application
  constructor : ->
  
  load : (callback) ->
    app.dom_ready =>
      @ready()
      if callback?
        callback()
    return
  
  ready : ->
    if app.browser
      @init()
    else
      new app.Gag().show()
    return
  
  init : ->
    @head = new app.Head()
    return

namespace "app", (exports) ->
  exports.instance = new Application()