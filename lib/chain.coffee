#------------------------------------------------------------------------------#
# This file is part of wordchains.

# wordchains is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Foobar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------------#
require './extensions'
alphabet = (String.fromCharCode(i) for i in [97..122])

permutate = (parts) ->
    [parts[0], letter, parts[1]].join('') for letter in alphabet

class Chain
  constructor: (first_word, second_word, words = []) ->
    @first_word = first_word.toLowerCase() if first_word
    @second_word = second_word.toLowerCase() if second_word
    @related = {}
    @addWord @first_word
    @addWord @second_word
    @addWord word for word in words

  print: ->
    console.log link for link in @links

  addWord: (word) ->
    if word.length is @first_word.length
      for w in (word.nulify(i) for i in [0..(word.length-1)])
        @related[w] ?= []
        @related[w].push word

  relatedWords: (word) ->
    related = []
    for i in [0..(word.length-1)]
      nword = word.nulify(i)
      if @related.hasOwnProperty nword
        for w in @related[nword]
          related.push w
    related

  @property 'links', get: () ->
    links = [@first_word, @second_word]
    middleLinks = @findMiddleLinks()
    links.insert 1, middleLinks

  findMiddleLinks: ->
    that = this
    current = [@first_word]
    path = {}
    path[@first_word] = no
    try
      until current.length is 0
        next = []
        for c in current
          for p in that.relatedWords(c)
            unless path.hasOwnProperty p
              path[p] = c
              throw 'found' if p is that.second_word
              next.push p
        current = next
      no
    catch e
      @buildChain(that.second_word, path)

  buildChain: (target, path) ->
    chain = []
    while target = path[target]
      chain.push target
    chain.reverse()
    chain.shift()
    chain

module.exports = Chain
