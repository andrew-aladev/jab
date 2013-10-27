#= require src/utils/namespacing

class Gag
  constructor : ->
    @el = document.getElementById "gag"
  
  show : ->
    @el.className = @el.className + " visible"

namespace "app", (exports) ->
  exports.Gag = Gag