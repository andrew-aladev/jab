#= require src/utils/namespacing
#= require src/utils/dom

class Search
  constructor : (parent_element) ->
    @form   = parent_element.search "descendant::form", true
    @query  = @form.search "descendant::*[contains(concat(' ', @class, ' '), ' query ')]", true
    @button = @form.search "descendant::*[contains(concat(' ', @class, ' '), ' submit ')]", true
    return if @query.size() == 0 and @button.size() == 0
    @bind()
  
  bind : ->
    @_submit = @submit.bind this
    @form.bind   "submit", @_submit
    @button.bind "click",  @_submit
    
    @_focus = @focus.bind this
    @_blur  = @blur.bind this
    @query.bind("focus", @_focus).bind("blur", @_blur)
  
  submit : (event) ->
    query = @query.get(0).value.trim()
    if query.length > 0
      query = encodeURIComponent "site:www.puchuu.com " + query
      window.open "https://www.google.com/#q=#{query}", "_blank"
    event.preventDefault()
  
  focus : ->
    @form.add_class "focus"
  
  blur : ->
    @form.del_class "focus"

namespace "app.head", (exports) ->
  exports.Search = Search
