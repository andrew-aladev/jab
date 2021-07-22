#= require src/utils/namespacing
#= require src/utils/dom
#= require src/utils/events

class Pictures
  constructor : ->
    @elements = app.$ "//*[contains(concat(' ', @class, ' '), ' picture ')]"
    @objects  = []
    @init()
  
  init : ->
    @elements.each (element) =>
      @objects.push new Picture(element)

class Picture
  constructor : (box) ->
    @box   = app.$ box
    @image = @box.search "descendant::img", true
    @init()
  
  init : ->
    width = @box.get(0).clientWidth
    image = @image.get 0
    @image_width  = parseInt image.getAttribute("data-width")
    @image_height = parseInt image.getAttribute("data-height")
    if width < @image_width
      @box.add_class "clickable"
      @bind()
  
  bind : ->
    @_click = @click.bind this
    @box.bind "click", @_click
  
  click : ->
    app.popup.set_content @image.clone(), @image_width, @image_height
    app.popup.show()

namespace "app.content", (exports) ->
  exports.Pictures = Pictures
