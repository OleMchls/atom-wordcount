AtomWordcountView = require './atom-wordcount-view'

module.exports =
  atomWordcountView: null

  activate: ->
    @atomWordcountView = new AtomWordcountView()

  deactivate: ->
    @atomWordcountView.destroy()
