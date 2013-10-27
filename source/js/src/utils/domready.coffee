#= require src/utils/namespacing

is_loaded = false
callbacks = []

loaded = ->
  is_loaded = true
  for i in [0...callbacks.length]
    callbacks[i].call document
  callbacks = []
  return

content_loaded = ->
  document.removeEventListener "DOMContentLoaded", content_loaded, true
  loaded()
  return

state_changed = ->
  if document.readyState is "complete"
    document.detachEvent "onreadystatechange", state_changed
    loaded()
  return

if !!document.addEventListener
  document.addEventListener "DOMContentLoaded", content_loaded, true
else
  document.attachEvent "onreadystatechange", state_changed

dom_ready = (callback) ->
  return unless callback?

  if is_loaded
    callback.call document
  else
    callbacks.push callback
  return

namespace "app", (exports) ->
  exports.dom_ready = dom_ready