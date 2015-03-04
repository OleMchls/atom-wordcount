WordcountView = require './wordcount-view'
view = null
tile = null

module.exports =

  config:
    files:
      type: 'string'
      default: 'md markdown readme txt rst'

  activate: (state) ->
    view = new WordcountView()

    atom.workspace.observeTextEditors (editor) ->
      editor.onDidChange -> view.update_count editor
      editor.onDidChangeSelectionRange -> view.update_count editor

    atom.workspace.onDidChangeActivePaneItem @show_or_hide_for_item

    @show_or_hide_for_item atom.workspace.getActivePaneItem()

  show_or_hide_for_item: (item) ->
    extensions = atom.config.get('wordcount.files').split(' ').map (extension) -> extension.toLowerCase()
    current_file_extension = item?.buffer?.file?.path.split('.').pop().toLowerCase()
    if current_file_extension in extensions
      view.show()
    else
      view.hide()

  consumeStatusBar: (statusBar) ->
    tile = statusBar.addRightTile(item: view, priority: 100)

  deactivate: ->
    tile?.destroy()
    tile = null
