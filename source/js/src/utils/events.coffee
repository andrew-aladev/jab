#= require src/utils/namespacing

prevent = (event) ->
  event.preventDefault()
  event.stopPropagation()
  return false

namespace "app", (exports) ->
  exports.prevent = prevent
