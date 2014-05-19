WordcountView = require './wordcount-view'

module.exports =
  WordcountView: null

  DEFAULT_FILES: 'md markdown readme txt rst'

  activate: ->
    atom.config.setDefaults('wordcount.files', {
      'File extensions': @DEFAULT_FILES
    })

    setTimeout ->
      @WordcountView = new WordcountView()
    , 1000

  deactivate: ->
    @WordcountView = new WordcountView() unless @WordcountView
    @WordcountView.destroy()
