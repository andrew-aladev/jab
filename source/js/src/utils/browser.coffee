#= require src/utils/namespacing

checks = [
  document.addEventListener?, document.removeEventListener?
  document.evaluate?
  String.prototype.trim?
  Array.prototype.indexOf?
  window.encodeURI?, window.encodeURIComponent?
]
browser = true
for check in checks
  unless check
    browser = false
    break

namespace "app", (exports) ->
  exports.browser = browser
