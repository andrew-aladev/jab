#= require src/utils/namespacing

extend = (dst, src) ->
  for property of src
    if src.hasOwnProperty(property)
      dst[property] = src[property]
  return

namespace "app", (exports) ->
  exports.extend = extend