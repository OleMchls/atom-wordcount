# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.
wordRegex = require('../lib/wordcount-regex')

wordcount = (str) ->
  str.match(wordRegex())?.length

describe "wordcount-regex", ->
  activationPromise = null

  describe "when the sample Armenian text is counted", ->
    it "returns 58 words", ->
      text = "Լինում է, չի լինում մի խեղճ մարդանունը Նազար: Էս Նազարը մի անշնորհք ու ալարկոտ մարդ է լինում: Էնքան էլ վախկոտ, էնքան էլ վախկոտ, որ մենակ ոտը ոտի առաջ չէր դնիլ, թեկուզ սպանեիր: Օրը մինչև իրիկուն կնկա կողքը կտրած նրա հետ էր դուրս գնալիս դուրս էր գնում, տուն գալիս` տուն գալի: Դրա համար էլ անունը դնում են վախկոտ Նազար: Ժաննա դ՚Արկ"
      expect(wordcount(text)).toBe(60)

  describe "when the sample English text is counted", ->
    it "returns 58 words", ->
      text = "English uses contractions, such as don't and can't. While there are no hard and fast rules, contractions are typically considered one word by native English speakers."
      expect(wordcount(text)).toBe(26)
