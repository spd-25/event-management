window.Initializer =
  autoFocus: -> $('[autofocus]').focus()

  initDate: (sel = '') ->
    $("#{sel} input.date").each (i, input) ->
      $input = $(input)
      date = $input.val()
      if date isnt ''
        [year, month, day] = date.split('-')
        $input.val [day, month, year].join('.')

      startView = $input.data().startView or 0
      $input.datepicker
        format: 'dd.mm.yyyy'
        startView: startView
        language: "de"
        todayHighlight: true
        autoclose: true
        zIndexOffset: 1151

  initWysihtml5: ->
    $('.editor').wysihtml5
      toolbar:
        fa: true
        html: true
        link: false
      locale: "de-DE"

  initSelect2: ->
    $(".select2").each (i, input) ->
      $input = $(input)
      placeholder = $input.data().placeholder
      $input.select2
        width: '100%'
        theme: "bootstrap"
        placeholder: placeholder

  initAll: ->
#    Initializer.initWysihtml5()
    Initializer.initDate()
    Initializer.autoFocus()
    Initializer.initSelect2()

$(document).on 'turbolinks:load', ->  Initializer.initAll()
