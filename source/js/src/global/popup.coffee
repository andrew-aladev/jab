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
    @_overlay_click  = @overlay_click.bind this
    @_wrapper_click  = @wrapper_click.bind this
    @_keyup          = @keyup.bind this

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
    @hide()
  
  overlay_click : (event) ->
    @hide()
  
  keyup : (event) ->
    if event.keyCode is 27
      @hide()

  set_content : (elements, width, height) ->
    @wrapper.empty().append(elements)
    @content.css {
      width      : width + "px"
      height     : height + "px"
      marginLeft : - width / 2 + "px"
      marginTop  : - height / 2 + "px"
    }
  
  show : (callback) ->
    @bind()
    @overlay.css({
      display : "block"
    })
    .render ["display"]
    
    if callback?
      @overlay.one ["webkitTransitionEnd", "transitionend"], ->
        callback()
    @body.add_class "popup"
  
  hide : (callback) ->
    @overlay.one ["webkitTransitionEnd", "transitionend"], =>
      @overlay.css {
        display : "none"
      }
      callback() if callback?
    @body.del_class "popup"
    @unbind()

namespace "app", (exports) ->
  exports.popup = new Popup()
