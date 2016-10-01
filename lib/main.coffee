WordcountView = require './wordcount-view'
_ = require 'lodash'

view = null
tile = null

module.exports =

  config:
    alwaysOn:
      title: 'Always on'
      description: 'Show word count for all files, regardless of extension'
      type: 'boolean'
      default: false
      order: 1
    extensions:
      title: 'Autoactivated file extensions'
      description: 'List of file extenstions which should have the wordcount plugin enabled'
      type: 'array'
      default: [ 'md', 'markdown', 'readme', 'txt', 'rst', 'adoc', 'log', 'msg' ]
      items:
        type: 'string'
      order: 2
    noextension:
      title: 'Autoactivate for files without an extension'
      description: 'Wordcount plugin enabled for files without a file extension'
      type: 'boolean'
      default: false
      items:
        type: 'boolean'
      order: 3
    goal:
      title: 'Work toward a word goal'
      description: 'Shows a bar showing progress toward a word goal'
      type: 'number'
      default: 0
      order: 4
    goalColor:
      title: 'Color for word goal'
      description: 'Use a CSS color value, such as rgb(0, 85, 255) or green'
      type: 'string'
      default: 'rgb(0, 85, 0)'
      order: 5
    goalLineHeight:
      title: 'Percentage height of word goal line'
      type: 'string'
      default: '20%'
      order: 6
    ignorecode:
      title: 'Ignore Markdown code blocks'
      description: 'Do not count words inside of code blocks'
      type: 'boolean'
      default: false
      items:
        type: 'boolean'
      order: 7
    hidechars:
      title: 'Hide character count'
      description: 'Hides the character count from the view'
      type: 'boolean'
      default: 'false'
      items:
        type: 'boolean'
      order: 8

  activate: (state) ->
    view = new WordcountView()
    atom.workspace.observeTextEditors (editor) ->
      update_count = _.throttle ->
        view.update_count(editor)
      , 300
      editor.onDidChange update_count
      editor.onDidChangeSelectionRange update_count

    atom.workspace.onDidChangeActivePaneItem @show_or_hide_for_item

    @show_or_hide_for_item atom.workspace.getActivePaneItem()

    atom.config.observe('wordcount.goal', @update_goal)

  update_goal: (item) ->
    if item is 0
      view.css('background', 'transparent')

  show_or_hide_for_item: (item) ->
    {alwaysOn, extensions, noextension} = atom.config.get('wordcount')
    extensions = (extensions || []).map (extension) -> extension.toLowerCase()
    buffer = item?.buffer

    not_text_editor = not buffer?
    untitled_tab = buffer?.file is null
    current_file_extension = buffer?.file?.path.match(/\.(\w+)$/)?[1].toLowerCase()

    if noextension and (not current_file_extension? or untitled_tab)
      no_extension = true

    if alwaysOn or no_extension or current_file_extension in extensions
      view.css("display", "inline-block") unless not_text_editor
    else
      view.css("display", "none")

  consumeStatusBar: (statusBar) ->
    tile = statusBar.addRightTile(item: view, priority: 100)

  deactivate: ->
    tile?.destroy()
    tile = null
