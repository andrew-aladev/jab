#= require src/utils/namespacing

ua      = navigator.userAgent
chrome  = /chrome/i.test ua
safari  = /safari/i.test ua
opera   = /opera/i.test ua or /opr/i.test ua
firefox = /firefox/i.test ua
gecko   = /gecko\//i.test ua

if chrome or firefox or gecko or opera or safari
  browser = true
else
  browser = false

namespace "app", (exports) ->
  exports.browser = browser