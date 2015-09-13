# coffeelint: disable=max_line_length

{MAX, MIN} = require './minimax'

# TIC TAC TOE

{_, X, O, empty, lines, Board, ultimateEmpty, UltimateBoard} = require './board'

class TicTacToeState
  constructor: (ps = empty, @nextPlayer = X, @depth = 0) ->
    @board = new Board(ps)
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  opponent: (who = @nextPlayer) -> if who is X then O else X
  action: (i) ->
    new @constructor (@board.play i, @nextPlayer).ps, @opponent(), @depth + 1
  possibleActions: ->
    bs = (@board.play i, @nextPlayer for i in @openPositions())
    # the actions are the states
    (new @constructor b.ps, @opponent(), @depth + 1 for b in bs)
  play: (action) -> action
  utility: -> ticTacToeEvaluate @board
  openPositions: -> @board.openPositions()
  isTerminal: -> @board.isTerminal()
  isWin: (who) -> @board.isWin who
  toString: -> @board.toString()

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

# MISÈRE TIC TAC TOE

class MisereTicTacToeState extends TicTacToeState
  isWin: (who) -> super @opponent who
  utility: -> -super

# ULTIMATE TIC TAC TOE

class UltimateTicTacToeState extends TicTacToeState

  constructor: (@bs = ultimateEmpty, @nextPlayer = X, @lastPlayedPosition = 4, @depth = 0) ->
    @board = new UltimateBoard(@bs)

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
    # bis :: list of board indexes
    bis = @boardsForNextPlay()

    # get open positions for the boards
    # iopss :: list of [board index, list of open positions]
    iopss = ([i, @bs[i].openPositions()] for i in bis)

    # the actions are the states
    states = []
    for [i, ops] in iopss
      for j in ops
        states.push new @constructor @board.play(i, j, @nextPlayer).bs, @opponent(), j, @depth + 1
    states

  utility: ->
    ls = lines @board.bs
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
