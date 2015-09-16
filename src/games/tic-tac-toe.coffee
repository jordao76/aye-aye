rows = (ps) -> ([ps[i],ps[i+1],ps[i+2]] for i in [0..8] by 3)
columns = (ps) -> ([ps[i],ps[i+3],ps[i+6]] for i in [0..2])
diagonals = (ps) -> [[ps[0],ps[4],ps[8]], [ps[2],ps[4],ps[6]]]
lines = (ps) -> [rows(ps)..., columns(ps)..., diagonals(ps)...]

# -------------------------------------------------------

[_, X, O] = [' ', 'X', 'O']

empty = [_,_,_
         _,_,_
         _,_,_]
class Board
  constructor: (@ps = empty) -> # ps = positions
  isTerminal: -> @isWin(X) or @isWin(O) or @isFull()
  isWin: (who) -> lines(@ps).some (l) -> l.every (p) -> p is who
  isFull: -> @ps.every (p) -> p isnt _
  openPositions: -> (i for p, i in @ps when p is _)
  play: (i, who) -> new @constructor [@ps[0...i]..., who, @ps[i+1..]...]
  toString: -> ("|#{r.join '|'}|" for r in rows(@ps)).join "\n"

# -------------------------------------------------------

{MAX, MIN} = require '../minimax'

class TicTacToeState extends Board
  constructor: (ps = empty, @nextPlayer = X, @depth = 0) -> super ps
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  possibleActions: -> @openPositions()
  play: (i) ->
    new @constructor (super i, @nextPlayer).ps, @opponent(), @depth + 1
  utility: -> ticTacToeEvaluate @
  opponent: (who = @nextPlayer) -> if who is X then O else X

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

# -------------------------------------------------------

class MisereTicTacToeState extends TicTacToeState
  isWin: (who) -> super @opponent who
  utility: -> -super

# -------------------------------------------------------

module.exports = {
  _, X, O
  rows, columns, diagonals, lines
  empty
  Board
  TicTacToeState
  ticTacToeEvaluate
  MisereTicTacToeState
}
