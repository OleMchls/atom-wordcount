
module.exports =
class WordcountView
  CSS_SELECTED_CLASS: 'wordcount-select'

  constructor: ->
    @element = document.createElement 'div'
    @element.classList.add('word-count')
    @element.classList.add('inline-block')

    @divWords = document.createElement 'div'

    @element.appendChild(@divWords)

    @wordregex = require('./wordcount-regex')();


  charactersToHMS: (words) ->
    # 1- calculate minutes and seconds for reading
    wpm = atom.config.get('wordcount.wordsPerMinute')
    minutes = words / wpm
    seconds = minutes * 60
    # 2- recalculate minutes based on seconds
    minutes = parseInt(seconds / 60)
    # 60 seconds in 1 minute
    # 3- Calculate remainder of seconds without minutes
    seconds = Math.round(seconds % 60)
    # 4- Return time
    minutes = ('0' + minutes).slice(-2)
    seconds = ('0' + seconds).slice(-2)
    minutes + ':' + seconds

  update_count: (editor) ->
    texts = @getTexts editor
    scope = editor.getGrammar().scopeName
    wordCount = charCount = 0
    for text in texts
      text = @stripText text, editor
      [words, chars] = @count text
      wordCount += words
      charCount += chars
    str = ''
    str += "<span class='wordcount-words'>#{new Intl.NumberFormat().format(wordCount) || 0} W</span>" if atom.config.get 'wordcount.showwords'
    str += ("<span class='wordcount-chars'>#{new Intl.NumberFormat().format(charCount) || 0} C</span>") if atom.config.get 'wordcount.showchars'
    str += ("<span class='wordcount-time'>#{ @charactersToHMS wordCount || 0}</span>") if atom.config.get 'wordcount.showtime'
    priceResult = wordCount*atom.config.get 'wordcount.wordprice'
    str += ("<span class='wordcount-price'>#{priceResult.toFixed(2) || 0} </span>") + atom.config.get 'wordcount.currencysymbol' if atom.config.get 'wordcount.showprice'
    @divWords.innerHTML = str
    if goal = atom.config.get 'wordcount.goal'
      if not @divGoal
        @divGoal = document.createElement 'div'
        @divGoal.style.width = '100%'
        @element.appendChild @divGoal
      green = Math.round(wordCount / goal * 100)
      green = 100 if green > 100
      color = atom.config.get 'wordcount.goalColor'
      colorBg = atom.config.get 'wordcount.goalBgColor'
      @divGoal.style.background = '-webkit-linear-gradient(left, ' + color + ' ' + green + '%, ' + colorBg + ' 0%)'
      percent = parseFloat(atom.config.get 'wordcount.goalLineHeight') / 100
      height = @element.clientHeight * percent
      @divGoal.style.height = height + 'px'
      @divGoal.style.marginTop = -height + 'px'

  getTexts: (editor) =>
    # NOTE: A cursor is considered an empty selection to the editor
    texts = []
    selectionRanges = editor.getSelectedBufferRanges()
    emptySelections = true
    for range in selectionRanges
      text = editor.getTextInBufferRange(range)

      # Text from buffer might be empty (no selection but a cursor)
      if text
        texts.push(text)
        emptySelections = false

    # No or only empty selections will cause the entire editor text to be returned instead
    if emptySelections
      texts.push(editor.getText())
      @element.classList.remove @CSS_SELECTED_CLASS
    else
      @element.classList.add @CSS_SELECTED_CLASS

    texts

  stripText: (text, editor) ->
    grammar = editor.getGrammar().scopeName
    stripgrammars = atom.config.get('wordcount.stripgrammars')

    if grammar in stripgrammars

      if atom.config.get('wordcount.ignorecode')
        codePatterns = [/`{3}(.|\s)*?(`{3}|$)/g, /[ ]{4}.*?$/gm]
        for pattern in codePatterns
          text = text?.replace pattern, ''

      if atom.config.get('wordcount.ignorecomments')
        commentPatterns = [/(<!--(\n?(?:(?!-->).)*)+(-->|$))/g, /({>>(\n?(?:(?!<<}).)*)+(<<}|$))/g]
        for pattern in commentPatterns
          text = text?.replace pattern, ''

      if atom.config.get('wordcount.ignoreblockquotes')
        blockquotePatterns = [/^\s{0,3}>(.*\S.*\n)+/gm]
        for pattern in blockquotePatterns
          text = text?.replace pattern, ''

      # Reduce links to text
      text = text?.replace /(?:__|[*#])|\[(.*?)\]\(.*?\)/gm, '$1'

    text

  count: (text) ->
    words = text?.match(@wordregex)?.length
    text = text?.replace '\n', ''
    text = text?.replace '\r', ''
    chars = text?.length
    [words, chars]
