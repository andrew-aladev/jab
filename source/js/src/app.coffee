#= require src/utils/namespacing
#= require src/utils/domready
#= require src/utils/browser
#= require src/gag

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
      ;
    else
      new app.Gag().show()
    return

namespace "app", (exports) ->
  exports.instance = new Application()