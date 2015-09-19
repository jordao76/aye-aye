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
  mark: (i, who) -> [@ps[0...i]..., who, @ps[i+1..]...]
  play: (i, who) -> new @constructor @mark i, who
  toString: -> ("|#{r.join '|'}|" for r in rows(@ps)).join "\n"

# -------------------------------------------------------

rotate = (a) ->
  [a[6],a[3],a[0]
   a[7],a[4],a[1]
   a[8],a[5],a[2]]
rotations = (a) ->
  r1 = rotate a
  r2 = rotate r1
  r3 = rotate r2
  [a, r1, r2, r3]
flip = (a) ->
  [a[2],a[1],a[0]
   a[5],a[4],a[3]
   a[8],a[7],a[6]]
symmetries = (a) -> (rotations a).concat rotations (flip a)
# binary encoding
value = {}; value[_] = 0; value[X] = 1; value[O] = 2
bin = (a) ->
  res = 0
  for e, i in a
    res |= value[e] << (i*2)
  res
canonicalize = (a) ->
  [res, min] = [null, +Infinity]
  for s in symmetries a
    curr = bin s
    [res, min] = [s, curr] if curr < min
  res
# -------------------------------------------------------

{MAX, MIN} = require '../minimax'

class TicTacToeAction
  constructor: (@i, @ps) ->
  toString: -> @i.toString()

canonicalizeActions = (aa) ->
  [res, seen] = [[], {}]
  for a in aa
    c = canonicalize a.ps
    key = bin c
    unless seen[key]
      res.push a
      seen[key] = yes
  res

class TicTacToeState extends Board
  constructor: (ps = empty, @nextPlayer = X, @depth = 0) -> super ps
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  possibleActions: -> canonicalizeActions(@action i for i in @openPositions())
  action: (i) -> new TicTacToeAction i, (@mark i, @nextPlayer)
  play: (action) -> new @constructor action.ps, @opponent(), @depth + 1
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
  bin, rotate, rotations, flip, symmetries, canonicalize
  TicTacToeState
  ticTacToeEvaluate
  MisereTicTacToeState
}
