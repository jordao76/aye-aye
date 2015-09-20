# coffeelint: disable=max_line_length

{_, X, O, rows, lines, empty, Board, ticTacToeEvaluate} = require './tic-tac-toe'

e = empty
ultimateEmpty = [e,e,e
                 e,e,e
                 e,e,e]
class UltimateBoard extends Board
  constructor: (a = ultimateEmpty) -> super a
  isWin: (who, a=@a) -> (@lines a).some (l) => l.every (b) => super who, b
  isFull: (a=@a) -> a.every (a) => super a
  mark: (i, j, who, a=@a) -> [a[0...i]..., (super j, who, a[i]), a[i+1..]...]
  toString: (a=@a) ->
    s = ''
    for bri in [0..2] # bri = board row index
      bs = (@rows a)[bri]
      for ri in [0..2] # ri = row index within a board
        s += ("|#{((@rows b)[ri]).join '|'}|" for b in bs).join ' ║ '
        s += '\n' if bri < 2 or ri < 2
      s += '════════╬═════════╬════════\n' if bri < 2
    s

# -------------------------------------------------------

{C14n} = require './tic-tac-toe'

class UC14n extends C14n
  constructor: ->
    super
    i = +Infinity
    @maxBin = [i,i,i,i,i,i,i,i,i]
  rotate: (a) ->
    [(super a[6]),(super a[3]),(super a[0])
     (super a[7]),(super a[4]),(super a[1])
     (super a[8]),(super a[5]),(super a[2])]
  flip: (a) ->
    [(super a[2]),(super a[1]),(super a[0])
     (super a[5]),(super a[4]),(super a[3])
     (super a[8]),(super a[7]),(super a[6])]
  bin: (a) ->
    res = [0,0,0,0,0,0,0,0,0]
    for b, i in a
      for e, j in b
        res[i] |= @value[e] << (j*2)
    res

# -------------------------------------------------------

{MAX, MIN} = require '../minimax'

# ULTIMATE TIC TAC TOE

uc14n = new UC14n

class UltimateTicTacToeAction
  constructor: (@i, @j, @a) ->
  toString: -> "#{@i},#{@j}"

class UltimateTicTacToe extends UltimateBoard

  constructor: (a = ultimateEmpty, @nextPlayer = X, @lastPlayedPosition = 4, @depth = 0) ->
    super a

  nextAgent: -> if @nextPlayer is X then MAX else MIN
  opponent: (who = @nextPlayer) -> if who is X then O else X

  # get boards for next play, returns :: list of board indexes
  boardsForNextPlay: ->
    b = if @lastPlayedPosition? then @a[@lastPlayedPosition] else null
    if b? and !(Board::isTerminal b)
      # the board derived from the last played position is available
      [@lastPlayedPosition]
    else
      # all available board indexes
      (i for b, i in @a when !(Board::isTerminal b))

  openPositions: ->
    # get open positions for the boards
    # returns :: list of [board index, list of open positions for board]
    ([i, (Board::openPositions @a[i])] for i in @boardsForNextPlay())

  possibleActions: ->
    actions = []
    for [i, js] in @openPositions()
      for j in js
        actions.push @action i, j
    uc14n.canonicalizeActions actions
    #actions

  action: (i, j) -> new UltimateTicTacToeAction i, j, @mark(i, j, @nextPlayer)

  play: (action) ->
    new @constructor action.a, @opponent(), action.j, @depth + 1

  utility: ->
    score = 0
    for l in @lines()
      [i, j, k] = [0, 0, 0]
      for b in l
        if Board::isWin X, b
          ++i
        else if Board::isWin O, b
          ++j
        k += ticTacToeEvaluate b
      score += 1000**i - 1000**j if i is 0 or j is 0
      score += k
    score

# EXPORTS

module.exports = {
  UltimateBoard
  UltimateTicTacToe
  UC14n
}
