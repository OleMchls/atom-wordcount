{View} = require 'atom-space-pen-views'

module.exports =
class WordcountView extends View
  CSS_SELECTED_CLASS: 'wordcount-select'

  @content: ->
    @div class: 'word-count inline-block'

  update_count: (editor) ->
    text = @getCurrentText editor
    [wordCount, charCount] = @count text
    @text("#{wordCount || 0} W | #{charCount || 0} C")
    if goal = atom.config.get('wordcount.goal')
      green = Math.round(wordCount / goal * 100)
      @css('background', '-webkit-linear-gradient(left, rgb(0, 85, 0) ' + green + '%, black')

  getCurrentText: (editor) =>
    selection = editor.getSelectedText()
    if selection
      @addClass @CSS_SELECTED_CLASS
    else
      @removeClass @CSS_SELECTED_CLASS
    text = editor.getText()
    selection || text

  count: (text) ->
    words = text?.match(/\S+/g)?.length
    chars = text?.length
    [words, chars]