WordcountView = require './wordcount-view'
view = null
tile = null

module.exports =

  config:
    extensions:
      title: 'Autoactivated file extensions'
      description: 'list of file extenstions which should have the wordcount plugin enabled'
      type: 'array'
      default: [ 'md', 'markdown', 'readme', 'txt', 'rst' ]
      items:
        type: 'string'

  activate: (state) ->
    view = new WordcountView()

    atom.workspace.observeTextEditors (editor) ->
      editor.onDidChange -> view.update_count editor
      editor.onDidChangeSelectionRange -> view.update_count editor

    atom.workspace.onDidChangeActivePaneItem @show_or_hide_for_item

    @show_or_hide_for_item atom.workspace.getActivePaneItem()

  show_or_hide_for_item: (item) ->
    extensions = (atom.config.get('wordcount.extensions') || []).map (extension) -> extension.toLowerCase()
    current_file_extension = item?.buffer?.file?.path.split('.').pop().toLowerCase()
    if current_file_extension in extensions
      view.css("display", "inline-block")
    else
      view.css("display", "none")

  consumeStatusBar: (statusBar) ->
    tile = statusBar.addRightTile(item: view, priority: 100)

  deactivate: ->
    tile?.destroy()
    tile = null
