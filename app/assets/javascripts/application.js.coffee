#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap-sprockets
#= require jquery-smooth-scroll
#= require_tree .

ready = ->
  $('.navbar-brand').on 'click', ->
    $.smoothScroll()
    false

$(document).ready(ready)
$(document).on('page:load', ready)
