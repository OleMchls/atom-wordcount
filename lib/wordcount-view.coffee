{View} = require 'atom'

module.exports =
class WordcountView extends View
  CSS_SELECTED_CLASS: 'wordcount-select'
  @content: ->
    @div class: 'word-count inline-block'

  initialize: ->
    # Make sure the view gets added
    if atom.workspaceView.statusBar
      @attach()
    else
      @subscribe atom.packages.once 'activated', @attach
    # Due to the lack of documentation of events, subscribing to this one seems most appropriate
    @subscribe atom.workspaceView, 'cursor:moved', @updateWordCountText
    @subscribe atom.workspaceView.statusBar, 'active-buffer-changed', @updateWordCountText
    @subscribe atom.workspaceView.statusBar, 'active-buffer-changed', @attachOrDestroy
    # Also watch for config changes
    #@observeConfig 'wordcount.files', @attachOrDestroy even if documented, this just throws errors at the moment

  attachOrDestroy: =>
    extensions = atom.config.get('wordcount.files')['File extensions'].split(' ').map (extension) -> extension.toLowerCase()
    current_file_extension = atom.workspaceView.getActivePaneItem()?.buffer?.file?.path.split('.').pop().toLowerCase()
    if current_file_extension in extensions
      @show()
    else
      @hide()

  # Attach the view to the farthest right of the status bar
  attach: =>
    atom.workspaceView.statusBar.prependRight(this)
    @attachOrDestroy()

  destroy: ->
    @remove()

  afterAttach: ->
    @updateWordCountText()

  updateWordCountText: =>
    editor = atom.workspaceView.getActivePaneItem()
    text = @getCurrentText editor
    [wordCount, charCount] = @count text
    @text("#{wordCount || 0} W | #{charCount || 0} C")

  getCurrentText: (editor) =>
    selection = if editor?.getSelection? then editor?.getSelection()?.getText() else ''
    if selection
      @addClass @CSS_SELECTED_CLASS
    else
      @removeClass @CSS_SELECTED_CLASS
    text = if editor?.getText? then editor.getText() else ''
    selection || text

  count: (text) ->
    words = text?.match(/\S+/g)?.length
    chars = text?.length
    [words, chars]
