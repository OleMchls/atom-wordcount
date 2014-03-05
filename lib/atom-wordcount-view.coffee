{View} = require 'atom'

module.exports =
class AtomWordcountView extends View
  @content: ->
    @div class: 'atom-wordcount overlay from-top', =>
      @div "The AtomWordcount package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "atom-wordcount:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "AtomWordcountView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
