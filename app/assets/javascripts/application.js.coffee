#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap-sprockets
#= require_tree .

ready = ->
  # smooth scroll to top
  $(".navbar-brand").on 'click', (e) ->
    e.preventDefault()
    hash = this.hash
    $('html, body').animate {
      scrollTop: $(hash).offset().top
    }, 300, ->
      window.location.hash = hash
    false

$(document).ready(ready)
$(document).on('page:load', ready)


