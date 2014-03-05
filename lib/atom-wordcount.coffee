AtomWordcountView = require './atom-wordcount-view'

module.exports =
  atomWordcountView: null

  activate: (state) ->
    @atomWordcountView = new AtomWordcountView(state.atomWordcountViewState)

  deactivate: ->
    @atomWordcountView.destroy()

  serialize: ->
    atomWordcountViewState: @atomWordcountView.serialize()
