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
    it "returns 60 words", ->
      text = "Լինում է, չի լինում մի խեղճ մարդանունը Նազար: Էս Նազարը մի անշնորհք ու ալարկոտ մարդ է լինում: Էնքան էլ վախկոտ, էնքան էլ վախկոտ, որ մենակ ոտը ոտի առաջ չէր դնիլ, թեկուզ սպանեիր: Օրը մինչև իրիկուն կնկա կողքը կտրած նրա հետ էր դուրս գնալիս դուրս էր գնում, տուն գալիս` տուն գալի: Դրա համար էլ անունը դնում են վախկոտ Նազար: Ժաննա դ՚Արկ"
      expect(wordcount(text)).toBe(60)

  describe "when the sample English text is counted", ->
    it "returns 26 words", ->
      text = "English uses contractions, such as don't and canʼt. While there are no hard and fast rules, contractions are typically considered one word by native English speakers."
      expect(wordcount(text)).toBe(26)

  describe "when the excerpt of Don Quixote in Spanish is counted", ->
    it "returns 234 words", ->
      text = "CAPÍTULO PRIMERO\n\nQue trata de la condición y ejercicio del famoso hidalgo D. Quijote de la Mancha\n\nEn un lugar de la Mancha, de cuyo nombre no quiero acordarme, no ha mucho tiempo que vivía un hidalgo de los de lanza en astillero, adarga antigua, rocín flaco y galgo corredor. Una olla de algo más vaca que carnero, salpicón las más noches, duelos y quebrantos los sábados, lentejas los viernes, algún palomino de añadidura los domingos, consumían las tres partes de su hacienda. El resto della concluían sayo de velarte, calzas de velludo para las fiestas con sus pantuflos de lo mismo, los días de entre semana se honraba con su vellori de lo más fino. Tenía en su casa una ama que pasaba de los cuarenta, y una sobrina que no llegaba a los veinte, y un mozo de campo y plaza, que así ensillaba el rocín como tomaba la podadera. Frisaba la edad de nuestro hidalgo con los cincuenta años, era de complexión recia, seco de carnes, enjuto de rostro; gran madrugador y amigo de la caza. Quieren decir que tenía el sobrenombre de Quijada o Quesada (que en esto hay alguna diferencia en los autores que deste caso escriben), aunque por conjeturas verosímiles se deja entender que se llama Quijana; pero esto importa poco a nuestro cuento; basta que en la narración dél no se salga un punto de la verdad."
      expect(wordcount(text)).toBe(234)

    describe "when the sample Spanish sentence is counted", ->
      it "returns 19 words", ->
        text = "El veloz murciélago hindú comía feliz cardillo y kiwi. La cigüeña tocaba el saxofón detrás del palenque de paja."
        expect(wordcount(text)).toBe(19)

    describe "when the sample German text is counted", ->
      it "returns 148 words", ->
        text = "Wenn Tina aus dem Fenster schaut, sieht sie im Garten neun Bäume. Auf einem der dünnen Äste sitzt ein Täubchen und macht lustige Geräusche. Ihr Hund sitzt nicht weit entfernt gemütlich neben seinem Häuschen und beäugt das Tier. Sein Interesse verfliegt aber schnell, als mit lautem Getöse ein Flugzeug am Himmel vorbeifliegt. Erschrocken fliegt das Täubchen auf und verschwindet im feuchten Gebüsch. Gestern hat es stark geregnet, dennoch sind am bläulichen Himmel immer noch einige Wolken zu sehen.\n\nTina schaut den Tieren gerne bei ihrer täglichen Beschäftigung zu. Einmal hat sie die Katze des Nachbarn beobachtet, wie sie über einige Zäune gesprungen ist. Als Tina ihr nachgerannt ist, hat sie sich aber bei einem Sturz eine Beule zugezogen. Trotzdem beneidet sie die Tiere um ihr unbeschwertes Leben. Denn sie muss noch ihre Hausaufgaben erledigen und dann ihr Zimmer aufräumen. Andererseits kann man das wohl auch ein Hundeleben nennen!"
        expect(wordcount(text)).toBe(148)

    describe "when the sample Greek text is counted", ->
      it "returns 5 words", ->
        text = "αβαθείς αβαθές άβαθες αβαθή άβαθη"
        expect(wordcount(text)).toBe(5)
