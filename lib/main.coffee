WordcountView = require './wordcount-view'
view = null
tile = null

module.exports =

  config:
    extensions:
      title: 'Autoactivated file extensions'
      description: 'list of file extenstions which should have the wordcount plugin enabled'
      type: 'array'
      default: [ 'md', 'markdown', 'readme', 'txt', 'rst', 'adoc', 'log', 'msg' ]
      items:
        type: 'string'
      order: 1
    noextension:
      title: 'Autoactivate for files without an extension'
      description: 'wordcount plugin enabled for files without a file extension'
      type: 'boolean'
      default: false
      items:
        type: 'boolean'
      order: 2
    goal:
      title: 'Work toward a word goal'
      description: 'shows a bar showing progress toward a word goal'
      type: 'number'
      default: 0
      order: 3
    goalColor:
      title: 'Color for word goal'
      description: 'use a CSS color value, such as rgb(0, 85, 255) or green'
      type: 'string'
      default: 'rgb(0, 85, 0)'
      order: 4
    goalLineHeight:
      title: 'Percentage height of word goal line'
      type: 'string'
      default: '20%'
      order: 5
    ignorecode:
      title: 'Ignore Markdown code blocks'
      description: 'do not count words inside of code blocks'
      type: 'boolean'
      default: false
      items:
        type: 'boolean'
      order: 6

  activate: (state) ->
    view = new WordcountView()
    atom.workspace.observeTextEditors (editor) ->
      editor.onDidChange -> view.update_count editor
      editor.onDidChangeSelectionRange -> view.update_count editor

    atom.workspace.onDidChangeActivePaneItem @show_or_hide_for_item

    @show_or_hide_for_item atom.workspace.getActivePaneItem()

    atom.config.observe('wordcount.goal', @update_goal)

  update_goal: (item) ->
    if item is 0
      view.css('background', 'transparent')

  show_or_hide_for_item: (item) ->
    extensions = (atom.config.get('wordcount.extensions') || []).map (extension) -> extension.toLowerCase()
    not_saved = not item?.buffer?.file?
    no_extension = atom.config.get('wordcount.noextension') && item?.buffer?.file?.path.split('.').length == 1
    current_file_extension = item?.buffer?.file?.path.split('.').pop().toLowerCase()
    if no_extension or current_file_extension in extensions or not_saved
      view.css("display", "inline-block")
    else
      view.css("display", "none")

  consumeStatusBar: (statusBar) ->
    tile = statusBar.addRightTile(item: view, priority: 100)

  deactivate: ->
    tile?.destroy()
    tile = null
