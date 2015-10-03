# coffeelint: disable=max_line_length

{ MAX, MIN } = require '../minimax'
{
  _, X, O, decode
  empty
  bin, at, rows, columns, diagonals, lines
  isWin, isTerminal
  evaluate
  BinTicTacToe
} = require './bin-tic-tac-toe'

e = empty

ultimateEmpty = [e,e,e
                 e,e,e
                 e,e,e]

rowsU = (a) -> (a[i...i+3] for i in [0...3*3] by 3)
columnsU = (a) -> ([a[i],a[i+3],a[i+6]] for i in [0...3])
diagonalsU = (a) -> [[a[0],a[4],a[8]], [a[2],a[4],a[6]]]
linesU = (a) -> [(rowsU a)..., (columnsU a)..., (diagonalsU a)...]

isWinU = (a, W) ->
  for l in linesU a
    if (l.every (v) -> isWin v, W)
      return yes
  no

class UltimateTicTacToe

  constructor: (@a = ultimateEmpty, @nextPlayer = X, @lastPlayedPosition = 4, @depth = 0) ->

  at: (i, j) -> at @a[i], j

  rows: -> rowsU @a
  columns: -> columnsU @a
  diagonals: -> diagonalsU @a
  lines: -> linesU @a

  isTerminal: ->
    (@possibleActions().length is 0) or (@isWin X) or (@isWin O)

  isWin: (W) -> isWinU @a, W

  nextAgent: -> if @nextPlayer is X then MAX else MIN
  opponent: (who = @nextPlayer) -> if who is X then O else X

  # get boards for next play, returns :: list of board indexes
  boardsForNextPlay: ->
    v = if @lastPlayedPosition? then @a[@lastPlayedPosition] else null
    if v? and !(isTerminal v)
      # the board derived from the last played position is available
      [@lastPlayedPosition]
    else
      # all available board indexes
      res = []
      for v, i in @a
        unless isTerminal v
          res.push i
      res

  openPositions: ->
    # get open positions for the boards
    # returns :: list of [board index, list of open positions for board]
    res = []
    for i in @boardsForNextPlay()
      v = @a[i]
      js = []
      for j in [0...18] by 2
        if (0b11 << j & v) is 0 # the position is open, b11 is X|O
          js.push j / 2
      res.push [i, js]
    res

  action: (ij) -> ij

  possibleActions: ->
    return @actions if @actions?
    res = []
    for [i, js] in @openPositions()
      for j in js
        res.push [i, j]
    @actions = res

  play: ([i, j]) ->
    a = @a.slice()
    a[i] = @nextPlayer << (j*2) | a[i]
    new @constructor a, @opponent(), j, @depth + 1

  positionForAction: (action) -> action

  utility: ->
    score = 0
    for l in linesU @a
      [i, j, k] = [0, 0, 0]
      for v in l
        if isWin v, X
          ++i
        else if isWin v, O
          ++j
        k += evaluate v
      score += 1000**i - 1000**j if i is 0 or j is 0
      score += k
    score

  toString: ->
    s = ''
    for bri in [0..2] # bri = board row index
      vs = @rows()[bri]
      for ri in [0..2] # ri = row index within a board
        strRows = ("|#{(decode e for e in (rows v)[ri]).join '|'}|" for v in vs)
        s += strRows.join ' ║ '
        s += '\n' if bri < 2 or ri < 2
      s += '════════╬═════════╬════════\n' if bri < 2
    s

module.exports = {
  _, X, O, bin # re-exports
  UltimateTicTacToe
}
