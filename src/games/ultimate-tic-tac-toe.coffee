# coffeelint: disable=max_line_length

{_, X, O, rows, lines, empty, Board, ticTacToeEvaluate} = require './tic-tac-toe'

e = new Board
ultimateEmpty = [e,e,e
                 e,e,e
                 e,e,e]
class UltimateBoard
  constructor: (@bs = ultimateEmpty) -> # bs = boards
  isTerminal: -> @isWin(X) or @isWin(O) or @isFull()
  isWin: (who) -> lines(@bs).some (l) -> l.every (b) -> b.isWin who
  isFull: -> @bs.every (b) -> b.isFull()
  play: (i, j, who) ->
    new @constructor [@bs[0...i]..., @bs[i].play(j, who), @bs[i+1..]...]
  toString: ->
    s = ''
    for bri in [0..2] # bri = board row index
      bs = rows(@bs)[bri]
      for ri in [0..2] # ri = row index within a board
        s += ("|#{(rows(b.ps)[ri]).join('|')}|" for b in bs).join ' ║ '
        s += '\n' if bri < 2 or ri < 2
      s += '════════╬═════════╬════════\n' if bri < 2
    s

# -------------------------------------------------------

{MAX, MIN} = require '../minimax'

# ULTIMATE TIC TAC TOE

class UltimateTicTacToeState extends UltimateBoard

  constructor: (bs = ultimateEmpty, @nextPlayer = X, @lastPlayedPosition = 4, @depth = 0) ->
    super bs

  nextAgent: -> if @nextPlayer is X then MAX else MIN
  opponent: (who = @nextPlayer) -> if who is X then O else X

  openPositions: ->
    # get open positions for the boards
    # returns :: list of [board index, list of open positions for board]
    ([i, @bs[i].openPositions()] for i in @boardsForNextPlay())

  play: ([i, j]) ->
    new @constructor super(i, j, @nextPlayer).bs, @opponent(), j, @depth + 1

  # get boards for next play, returns :: list of board indexes
  boardsForNextPlay: ->
    b = if @lastPlayedPosition? then @bs[@lastPlayedPosition] else null
    if b? and !b.isTerminal()
      # the board derived from the last played position is available
      [@lastPlayedPosition]
    else
      # all available board indexes
      (i for b, i in @bs when !b.isTerminal())

  possibleActions: ->
    res = []
    for [i, js] in @openPositions()
      for j in js
        res.push [i, j]
    res

  utility: ->
    ls = lines @bs
    score = 0
    for l in ls
      [i, j, k] = [0, 0, 0]
      for b in l
        if b.isWin X
          ++i
        else if b.isWin O
          ++j
        k += ticTacToeEvaluate b
      score += 1000**i - 1000**j if i is 0 or j is 0
      score += k
    score

# EXPORTS

module.exports = {
  UltimateBoard
  UltimateTicTacToeState
}
