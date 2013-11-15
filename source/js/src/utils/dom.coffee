#= require src/utils/namespacing
#= require src/utils/events

select_single = (selector, parent) ->
  result  = document.evaluate selector, parent, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null
  element = result.singleNodeValue
  if element?
    [element]
  else
    []

select_multiple = (selector, parents) ->
  elements = []
  for parent in parents
    result  = document.evaluate selector, parent, null, XPathResult.UNORDERED_NODE_ITERATOR_TYPE, null
    element = result.iterateNext()
    while element?
      elements.push element
      element = result.iterateNext()
  elements

$ = (selector, is_single) ->
  if typeof(selector) is "string"
    if is_single
      new Dom select_single(selector, document)
    else
      new Dom select_multiple(selector, [document])
  else
    new Dom [selector]

class Dom
  constructor : (elements) ->
    @elements = elements
  
  search : (selector, is_single) ->
    if is_single
      if @elements.length > 0
        new Dom select_single(selector, @elements[0])
      else
        new Dom []
    else
      new Dom select_multiple(selector, @elements)
  
  bind : (events, callback) ->
    if typeof(events) is "string"
      events = [events]
    for element in @elements
      for event in events
        element.addEventListener event, callback, false
    return this
  
  one : (events, callback) ->
    self = this
    callback_wrapper = ->
      callback.apply this, arguments
      self.unbind events, callback_wrapper
    
    @bind events, callback_wrapper
  
  unbind : (events, callback) ->
    if typeof(events) is "string"
      events = [events]
    for element in @elements
      for event in events
        element.removeEventListener event, callback, false
    return this
  
  get : (index) ->
    @elements[index]
  
  each : (callback) ->
    for index in [0...@elements.length]
      callback @elements[index], index
    return this
  
  size : ->
    @elements.length
  
  add_class : (klass) ->
    for element in @elements
      element.classList.add(klass)
    return this
  
  del_class : (klass) ->
    for element in @elements
      element.classList.remove(klass)
    return this
  
  has_class : (klass) ->
    found = false
    for element in @elements
      if element.classList.contains(klass)
        found = true
        break
    return found
  
  clone : (deep) ->
    elements = []
    for element in @elements
      elements.push element.cloneNode(deep)
    return new Dom elements
  
  empty : ->
    for element in @elements
      element.innerHTML = ""
    return this
  
  append : (dom) ->
    for element in @elements
      for child_element in dom.elements
        element.appendChild child_element
    return this
  
  css : (hash) ->
    for element in @elements
      for key of hash
        element.style[key] = hash[key]
    return this

  # http://stackoverflow.com/questions/19895932/callback-after-the-style-has-been-rendered
  render : (styles) ->
    for element in @elements
      for style in styles
        getComputedStyle(element)[style]
    return this

namespace "app", (exports) ->
  exports.$ = $
