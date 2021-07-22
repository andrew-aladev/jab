#= require src/utils/namespacing
#= require src/content/pictures

class Content
  constructor : ->
    @pictures = new app.content.Pictures()

namespace "app", (exports) ->
  exports.Content = Content