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

$ = (selector, single) ->
  if single
    new Dom select_single(selector, document)
  else
    new Dom select_multiple(selector, [document])

class Dom
  constructor : (elements) ->
    @elements = elements
  
  search : (selector, single) ->
    if single
      if @elements.length > 0
        new Dom select_single(selector, @elements[0])
      else
        new Dom []
    else
      new Dom select_multiple(selector, @elements)
  
  bind : (event, callback) ->
    for element in @elements
      element.addEventListener event, callback, false
    return this
  
  unbind : (event, callback) ->
    for element in @elements
      element.removeEventListener event, callback, false
    return this
  
  get : (index) ->
    @elements[index]
  
  to_array : ->
    @elements
  
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
    found
  

namespace "app", (exports) ->
  exports.$ = $