class Panel
  @init: -> $('.panel').each (i, panel) -> new Panel(panel)

  constructor: (panel) ->
    @panel = $(panel)
    @panel.on 'ajax:success', @successEdit
    @modal = $('#modal')

  showModal: (title, body) =>
    @modal.find('.modal-title').html title
    @modal.find('.modal-body').html body
    @modal.modal('show')
    Initializer.initAll()
    @modal.find('.modal-footer button.save').off('click').click @save

  successEdit: (e, data) =>
    @showModal(@panel.find('.panel-title').text(), data) if $(e.target).is('a.edit')

  save: =>
    form = @modal.find(".modal-body form[data-remote]")
    form.on "ajax:success", @successSave
    form.on "ajax:error",   @errorSave
    form.submit()

  successSave: (e, data) =>
#    @panel.find('.panel-body').html data
    Turbolinks.reload()
    @modal.modal('hide')

  errorSave: (e, xhr) =>
    @modal.find('.modal-body').html xhr.responseText
    Initializer.initAll()

$(document).on 'turbolinks:load', -> Panel.init()
