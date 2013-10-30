#= require src/utils/namespacing

browser = \
  document.addEventListener? and document.removeEventListener? and \
  document.evaluate?

namespace "app", (exports) ->
  exports.browser = browser
