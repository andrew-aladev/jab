#= require src/utils/namespacing

checks = [
  document.addEventListener?, document.removeEventListener?
  document.evaluate?
  String.prototype.trim?
  Array.prototype.indexOf?
  Function.prototype.bind?
  window.encodeURI?, window.encodeURIComponent?
  window.getComputedStyle?
]
browser = true
for check in checks
  unless check
    browser = false
    break

namespace "app", (exports) ->
  exports.browser = browser
