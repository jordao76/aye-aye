# coffeelint: disable=max_line_length

{MAX, MIN} = require '../minimax'

# a board is represented as an array of bits (packed in a single number)
# each position takes 2 bits, for a total of 2*9 = 18 needed bits
[_,X,O] = [0b00, 0b01, 0b10]
decode = 0b00: ' ', 0b01: 'X', 0b10: 'O'

# empty board
empty = 0b000000000000000000
masks =
  # masks for when X (b01) wins
  0b01: [
    0b010101000000000000, 0b000000010101000000, 0b000000000000010101, # rows
    0b010000010000010000, 0b000100000100000100, 0b000001000001000001, # columns
    0b010000000100000001, 0b000001000100010000 # diagonals
  ]
  # masks for when O (b10) wins
  0b10: [
    0b101010000000000000, 0b000000101010000000, 0b000000000000101010, # rows
    0b100000100000100000, 0b001000001000001000, 0b000010000010000010, # columns
    0b100000001000000010, 0b000010001000100000 # diagonals
  ]

bin = (a) ->
  res = 0
  for e, i in a
    res |= e << (i*2)
  res

class BinTicTacToe
  @create: (a = [_,_,_,_,_,_,_,_,_], args...) ->
    new BinTicTacToe (bin a), args...
  constructor: (@value = empty, @nextPlayer = X, @depth = 0) ->
  at: (i) -> @value >> (i*2) & 0b11
  rows: -> [
    [@at(0),@at(1),@at(2)]
    [@at(3),@at(4),@at(5)]
    [@at(6),@at(7),@at(8)]
  ]
  columns: -> [
    [@at(0),@at(3),@at(6)]
    [@at(1),@at(4),@at(7)]
    [@at(2),@at(5),@at(8)]
  ]
  diagonals: -> [
    [@at(0),@at(4),@at(8)]
    [@at(2),@at(4),@at(6)]
  ]
  lines: -> [@rows()..., @columns()..., @diagonals()...]
  isFull: ->
    for i in [0...18] by 2
      if (0b11 << i & @value) is 0 # the position is open, b11 is X|O
        return no
    yes
  isWin: (W) ->
    ms = masks[W]
    for m in ms
      return yes if (m & @value) is m
    no
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  isTerminal: -> @isFull() or (@isWin X) or (@isWin O)
  possibleActions: ->
    return @actions if @actions?
    res = []
    for i in [0...18] by 2
      if (0b11 << i & @value) is 0 # the position is open, b11 is X|O
        res.push @nextPlayer << i | @value
    @actions = res
  play: (value) -> new @constructor value, @opponent(), @depth + 1
  utility: ->
    if @isWin X
      10000
    else if @isWin O
      -10000
    else
      ticTacToeEvaluate @
  opponent: (who = @nextPlayer) -> if who is X then O else X
  toString: -> ("|#{(decode[e] for e in r).join '|'}|" for r in @rows()).join "\n"

evals = {}
ticTacToeEvaluate = (game) ->
  v = game.value
  return evals[v] if evals[v]?
  score = 0
  for l in game.lines()
    [x, o] = [0, 0]
    for w in l
      ++x if w is X
      ++o if w is O
    score += 10**x - 10**o if x is 0 or o is 0
  evals[v] = score
  score

module.exports = { _, X, O, BinTicTacToe }
