#= require src/utils/namespacing

browser = \
  document.addEventListener? and \
  document.evaluate? and false

namespace "app", (exports) ->
  exports.browser = browser