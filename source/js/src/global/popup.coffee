#= require src/utils/namespacing
#= require src/utils/events

class Popup
  constructor : ->
  
  ready : ->
    @body    = app.$ document.body
    @overlay = app.$ "//*[contains(concat(' ', @class, ' '), ' popup-overlay ')]", true
    @content = @overlay.search "descendant::*[contains(concat(' ', @class, ' '), ' popup-content ')]", true
    @wrapper = @overlay.search "descendant::*[contains(concat(' ', @class, ' '), ' wrapper ')]", true
    @init()
    return

  init : ->
    @_overlay_click  = app.proxy this, @overlay_click
    @_wrapper_click  = app.proxy this, @wrapper_click
    @_keyup          = app.proxy this, @keyup

  bind : ->
    @overlay.bind "click", @_overlay_click
    @wrapper.bind "click", @_wrapper_click
    @body.bind "keyup", @_keyup
  
  unbind : ->
    @overlay.unbind "click", @_overlay_click
    @wrapper.unbind "click", @_wrapper_click
    @body.unbind "keyup", @_keyup

  wrapper_click : (event) ->
    event.stopPropagation()
  
  overlay_click : (event) ->
    @hide()
  
  keyup : (event) ->
    if event.keyCode is 27
      @hide()

  set_content : (elements, width, height) ->
    @wrapper.empty().append(elements)
    @content.css {
      width         : width + "px"
      height        : height + "px"
      "margin-left" : - width / 2 + "px"
      "margin-top"  : - height / 2 + "px"
    }
  
  show : (callback) ->
    @bind()
    @overlay.css {
      display : "block"
    }
    
    if callback?
      @overlay.one "webkitTransitionEnd", ->
        callback()
    setTimeout =>
      @body.add_class "popup"
    , 0
  
  hide : (callback) ->
    @overlay.one "webkitTransitionEnd", =>
      @overlay.css {
        display : "none"
      }
      callback() if callback?
    @body.del_class "popup"
    @unbind()

namespace "app", (exports) ->
  exports.popup = new Popup()