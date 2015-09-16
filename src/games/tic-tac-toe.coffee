# coffeelint: disable=max_line_length

{MAX, MIN} = require '../minimax'
{_, X, O, empty, lines, Board, ultimateEmpty, UltimateBoard} = require './board'

# TIC TAC TOE

ticTacToeEvaluate = (board) ->
  ls = lines board.ps
  score = 0
  for l in ls
    [x, o] = [0, 0]
    for w in l
      ++x if w is X
      ++o if w is O
    score += 10**x - 10**o if x is 0 or o is 0
  score

class TicTacToeState extends Board
  constructor: (ps = empty, @nextPlayer = X, @depth = 0) -> super ps
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  possibleActions: -> @openPositions()
  play: (i) ->
    new @constructor (super i, @nextPlayer).ps, @opponent(), @depth + 1
  utility: -> ticTacToeEvaluate @
  opponent: (who = @nextPlayer) -> if who is X then O else X

# MISÈRE TIC TAC TOE

class MisereTicTacToeState extends TicTacToeState
  isWin: (who) -> super @opponent who
  utility: -> -super

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

module.exports =
  _: _, X: X, O: O
  TicTacToeState: TicTacToeState
  ticTacToeEvaluate: ticTacToeEvaluate
  MisereTicTacToeState: MisereTicTacToeState
  UltimateTicTacToeState: UltimateTicTacToeState
