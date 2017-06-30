$(document).on 'turbolinks:load', ->
  $('.nav-tabs').each (i, nav) ->
    if $(nav).find('li.active').length == 0
      $(nav).find('li > a').first().tab('show')

  if document.location.hash isnt ''
    $('.nav-tabs a[href="' + document.location.hash + '"]').tab('show')

  $('.nav-tabs a').on 'shown.bs.tab', (e) ->
    window.location.hash = e.target.hash
    window.scrollTo(0, 0)
