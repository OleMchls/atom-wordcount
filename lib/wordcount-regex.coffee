'use strict'
# Modified from https://github.com/regexhq/word-regex/blob/master/index.js
# Counts contractions as one word
# Includes ASCII, Greek, Cyrillic, CJK, and Armenian
# https://tedclancy.wordpress.com/2015/06/03/which-unicode-character-should-represent-the-english-apostrophe-and-why-the-unicode-committee-is-very-wrong/
#
# RegEx matches:
#
# Latin Alphabet - Covers word characters from the following character sets:
# See: https://en.wikipedia.org/wiki/List_of_Unicode_characters
#   * Basic Latin
#   * Latin-1 Supplement
#   * Latin Extended-A
#   * Latin Extended-B
#   * Latin Extended Additional
#
#   [\u0027\u02BC\u0030-\u0039\u0041-\u005A\u0061-\u007A\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF\u0100-\u017F\u0180-\u024F\u1E02-\u1EF3]+
#
# CJK
#
#  [\u4E00-\u9FFF\u3400-\u4dbf\uf900-\ufaff\u3040-\u309f\uac00-\ud7af\u0400-\u04FF]
#
# Armenian
#
#   [\u0531-\u0556\u0561-\u0586\u0559\u055A\u055B]+

module.exports = ->
  /[\u0027\u02BC\u0030-\u0039\u0041-\u005A\u0061-\u007A\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF\u0100-\u017F\u0180-\u024F\u1E02-\u1EF3]+|[\u4E00-\u9FFF\u3400-\u4dbf\uf900-\ufaff\u3040-\u309f\uac00-\ud7af\u0400-\u04FF]+|[\u0531-\u0556\u0561-\u0586\u0559\u055A\u055B]+|\w+/g;
#  /[a-zA-Z0-9_'\u0392-\u03c9\u0400-\u04FF\u0027]+|[\u4E00-\u9FFF\u3400-\u4dbf\uf900-\ufaff\u3040-\u309f\uac00-\ud7af\u0400-\u04FF]+|[\u00E4\u00C4\u00E5\u00C5\u00F6\u00D6]+|[\u0531-\u0556\u0561-\u0586\u0559\u055A\u055B]+|\w+/g;
