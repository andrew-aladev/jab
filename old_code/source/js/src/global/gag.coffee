#= require src/utils/namespacing

class Gag
  constructor : ->
    @el = document.documentElement
  
  show : ->
    @el.className = @el.className + " gag-visible"
    return

namespace "app", (exports) ->
  exports.Gag = Gag