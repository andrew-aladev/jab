#= require src/utils/namespacing

proxy = (context, callback) ->
  return ->
    callback.apply context, arguments

prevent = (event) ->
  event.preventDefault()
  event.stopPropagation()
  return false

namespace "app", (exports) ->
  exports.prevent = prevent
  exports.proxy   = proxy