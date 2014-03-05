{View} = require 'atom'

module.exports =
class AtomWordcountView extends View
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

  # Attach the view to the farthest right of the status bar
  attach: =>
    atom.workspaceView.statusBar.appendRight(this)

  destroy: ->
    @remove()

  afterAttach: ->
    @updateWordCountText()

  updateWordCountText: =>
    editor = atom.workspaceView.getActivePaneItem()
    [wordCount, charCount] = @count editor?.getText()
    @text("#{wordCount} W | #{charCount} C").show()

  count: (text) ->
    words = text.split(' ').length
    chars = text.match(/\w/g).length
    [words, chars]
