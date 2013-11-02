class window.ga
  constructor : ->
    @q = [] unless @q?
    @q.push arguments
    @l = new Date().valueOf()

window.GoogleAnalyticsObject = "ga"
ga "create", "UA-45386945-1", "puchuu.com"
ga "send", "pageview"