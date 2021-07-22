#= require src/utils/namespacing
#= require src/head/search

class Head
  constructor : ->
    @element = app.$ "//*[contains(concat(' ', @class, ' '), ' head ')]", true
    @search  = new app.head.Search(@element)

namespace "app", (exports) ->
  exports.Head = Head