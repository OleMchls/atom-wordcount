{View} = require 'atom'

module.exports =
class WordcountView extends View
  @content: ->
    @div class: 'word-count inline-block'

  initialize: ->
    # Make sure the view gets added last
    if atom.workspaceView.statusBar
      @attach()
    else
      @subscribe atom.packages.once 'activated', =>
        setTimeout this.attach, 1
    # Due to the lack of documentation of events, subscribing to this one seems most appropriate
    @subscribe atom.workspaceView, 'cursor:moved', @updateWordCountText
    @subscribe atom.workspaceView.statusBar, 'active-buffer-changed', @updateWordCountText

  # Attach the view to the farthest right of the status bar
  attach: =>
    atom.workspaceView.statusBar.appendRight(this)

  destroy: ->
    @remove()

  afterAttach: ->
    @updateWordCountText()

  updateWordCountText: =>
    editor = atom.workspaceView.getActivePaneItem()
    selection = if editor.getSelection? then editor.getSelection()?.getText() else ''
    text = if editor?.getText? then editor.getText() else ''
    [wordCount, charCount] = @count selection || text
    @text("#{wordCount || 0} W | #{charCount || 0} C").show()

  count: (text) ->
    words = text?.match(/\S+/g)?.length
    chars = text?.match(/\w/g)?.length
    [words, chars]
