rows = (a) -> (a[i...i+3] for i in [0...3*3] by 3)
columns = (a) -> ([a[i],a[i+3],a[i+6]] for i in [0...3])
diagonals = (a) -> [[a[0],a[4],a[8]], [a[2],a[4],a[6]]]
lines = (a) -> [rows(a)..., columns(a)..., diagonals(a)...]

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
  mark: (i, who) -> new @constructor [@ps[0...i]..., who, @ps[i+1..]...]
  toString: -> ("|#{r.join '|'}|" for r in rows(@ps)).join "\n"

# -------------------------------------------------------

{MAX, MIN} = require '../minimax'

class TicTacToeState extends Board
  constructor: (ps = empty, @nextPlayer = X, @depth = 0) -> super ps
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  possibleActions: -> @openPositions()
    #bs = (@mark i, @nextPlayer for i in @openPositions())
    #canonicalize b for b in bs # TODO: remove duplicates
  play: (i) ->
    new @constructor (@mark i, @nextPlayer).ps, @opponent(), @depth + 1
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
