WordcountView = require './wordcount-view'

module.exports =
  WordcountView: null

  activate: ->
    @WordcountView = new WordcountView()

  deactivate: ->
    @WordcountView.destroy()
