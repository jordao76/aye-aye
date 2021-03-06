# coffeelint: disable=max_line_length

{MAX, MIN} = require '../minimax'

# a board is represented as an array of bits (packed in a single number)
# each position takes 2 bits, for a total of 2 * 9 = 18 needed bits
[_, X, O] = [0b00, 0b01, 0b10]

# note: 0b11 is X|O

opponent = (W) -> ~W & 0b11

decode = (W) -> { 0b00: ' ', 0b01: 'X', 0b10: 'O' }[W] or throw new Error W

# empty board
empty = 0b000000000000000000

bin = (a) ->
  res = 0
  for e, i in a
    res |= e << (i*2)
  res

at = (v, i) ->
  v >> (i*2) & 0b11

rows = (v) -> [
  [(at v,0),(at v,1),(at v,2)]
  [(at v,3),(at v,4),(at v,5)]
  [(at v,6),(at v,7),(at v,8)]
]

columns = (v) -> [
  [(at v,0),(at v,3),(at v,6)]
  [(at v,1),(at v,4),(at v,7)]
  [(at v,2),(at v,5),(at v,8)]
]

diagonals = (v) -> [
  [(at v,0),(at v,4),(at v,8)]
  [(at v,2),(at v,4),(at v,6)]
]

lines = (v) ->
  [(rows v)..., (columns v)..., (diagonals v)...]

isFull = (v) ->
  for i in [0...18] by 2
    if (0b11 << i & v) is 0 # the position is open
      return no
  yes

masks =
  # masks for when X (b01) wins
  0b01: [
    0b000000000000010101, 0b000000010101000000, 0b010101000000000000 # rows
    0b000001000001000001, 0b000100000100000100, 0b010000010000010000 # columns
    0b010000000100000001, 0b000001000100010000 # diagonals
  ]
  # masks for when O (b10) wins
  0b10: [
    0b000000000000101010, 0b000000101010000000, 0b101010000000000000 # rows
    0b000010000010000010, 0b001000001000001000, 0b100000100000100000 # columns
    0b100000001000000010, 0b000010001000100000 # diagonals
  ]
# the positions for the masks above, with matching indexes
positions = [
  [0,1,2], [3,4,5], [6,7,8]
  [0,3,6], [1,4,7], [2,5,8]
  [0,4,8], [2,4,6]
]

isWin = (v, W) ->
  ms = masks[W] or throw new Error W
  for m in ms
    return yes if (m & v) is m
  no

winOn = (v) ->
  w = (W) ->
    ms = masks[W]
    for m, i in ms
      return positions[i] if (m & v) is m
    null
  (w X) or (w O) or []

isTerminal = (v) ->
  (isFull v) or (isWin v, X) or (isWin v, O)

openPositions = (v) ->
  (i for i in [0...9] when (0b11 << (i*2) & v) is 0)

allPlays = (v, W) ->
  res = []
  for i in [0...18] by 2
    if (0b11 << i & v) is 0 # the position is open, b11 is X|O
      res.push W << i | v
  res

changedOn = (v1, v2) ->
  for i in [0...18]
    if (0b11 << (i*2) & v1) isnt (0b11 << (i*2) & v2)
      return i
  null

γ = 0.1 # discount factor (gamma)
discountedUtility = (v, depth = 0) ->
  γ**depth * utility v

utility = (v) ->
  if isWin v, X
    2000
  else if isWin v, O
    -2000
  else if isFull v
    0
  else
    evaluate v

evaluateCache = {}
evaluate = (v) ->
  return evaluateCache[v] if evaluateCache[v]?
  score = 0
  for l in lines v
    [x, o] = [0, 0]
    for w in l
      ++x if w is X
      ++o if w is O
    score += 10**x - 10**o if x is 0 or o is 0
  evaluateCache[v] = score

class BinTicTacToe
  @create: (a = [_,_,_,_,_,_,_,_,_], args...) ->
    new BinTicTacToe (bin a), args...
  constructor: (@value = empty, @nextPlayer = X, @depth = 0) ->
  at: (i) -> at @value, i
  rows: -> rows @value
  columns: -> columns @value
  diagonals: -> diagonals @value
  lines: -> lines @value
  isFull: -> isFull @value
  isWin: (W) -> isWin @value, W
  winner: ->
    switch
      when @isWin X then X
      when @isWin O then O
      else null
  winOn: -> winOn @value
  isTerminal: -> isTerminal @value
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  openPositions: -> openPositions @value
  possibleActions: -> allPlays @value, @nextPlayer
  action: (i) -> @nextPlayer << (i*2) | @value
  positionForAction: (action) -> changedOn @value, action
  play: (value) -> new @constructor value, @opponent(), @depth + 1
  utility: -> utility @value
  opponent: (W = @nextPlayer) -> opponent W
  toString: ->
    ("|#{(decode e for e in r).join '|'}|" for r in @rows()).join "\n"

module.exports = {
  _, X, O, opponent, decode
  empty
  bin, at, rows, columns, diagonals, lines
  isFull, isWin, isTerminal
  openPositions, allPlays, changedOn, winOn
  discountedUtility, utility, evaluate
  BinTicTacToe
}
