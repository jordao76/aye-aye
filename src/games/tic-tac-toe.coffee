# -------------------------------------------------------

[_, X, O] = [' ', 'X', 'O']

empty = [_,_,_
         _,_,_
         _,_,_]
class Board
  constructor: (@a = empty) ->
  rows: (a=@a) -> (a[i...i+3] for i in [0...3*3] by 3)
  columns: (a=@a) -> ([a[i],a[i+3],a[i+6]] for i in [0...3])
  diagonals: (a=@a) -> [[a[0],a[4],a[8]], [a[2],a[4],a[6]]]
  lines: (a=@a) -> [(@rows a)..., (@columns a)..., (@diagonals a)...]
  isTerminal: (a=@a) -> (@isFull a) or (@isWin X, a) or (@isWin O, a)
  isWin: (who, a=@a) -> (@lines a).some (l) -> l.every (e) -> e is who
  isFull: (a=@a) -> a.every (e) -> e isnt _
  openPositions: (a=@a) -> (i for e, i in a when e is _)
  mark: (i, who, a=@a) -> [a[0...i]..., who, a[i+1..]...]
  toString: (a=@a) -> ("|#{r.join '|'}|" for r in (@rows a)).join "\n"

# -------------------------------------------------------

# canonicalization
class C14n
  constructor: ->
    @value = {}; @value[_] = 0; @value[X] = 1; @value[O] = 1<<1
    @maxBin = +Infinity
  rotate: (a) ->
    [a[6],a[3],a[0]
     a[7],a[4],a[1]
     a[8],a[5],a[2]]
  rotations: (a) ->
    [a, (r1 = @rotate a), (r2 = @rotate r1), @rotate r2]
  flip: (a) ->
    [a[2],a[1],a[0]
     a[5],a[4],a[3]
     a[8],a[7],a[6]]
  symmetries: (a) -> (@rotations a).concat @rotations @flip a
  bin: (a) ->
    res = 0
    for e, i in a
      res |= @value[e] << (i*2)
    res
  canonicalize: (a) ->
    [res, min] = [null, @maxBin]
    for s in @symmetries a
      curr = @bin s
      [res, min] = [s, curr] if curr < min
    res
  canonicalizeActions: (actions) ->
    [res, seen] = [[], {}]
    for action in actions
      c = @canonicalize action.a
      key = (@bin c).toString()
      unless seen[key]
        res.push action
        seen[key] = yes
    res

# -------------------------------------------------------

{MAX, MIN} = require '../minimax'

c14n = new C14n

class TicTacToeAction
  constructor: (@i, @a) ->
  toString: -> @i.toString()

class TicTacToe extends Board
  constructor: (a, @nextPlayer = X, @depth = 0) -> super a
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  possibleActions: ->
    c14n.canonicalizeActions (@action i for i in @openPositions())
  action: (i) -> new TicTacToeAction i, (@mark i, @nextPlayer)
  play: (action) -> new @constructor action.a, @opponent(), @depth + 1
  utility: -> ticTacToeEvaluate @a
  opponent: (who = @nextPlayer) -> if who is X then O else X

evals = {}
ticTacToeEvaluate = (a) ->
  b = c14n.bin a
  return evals[b] if evals[b]?
  score = 0
  for l in Board::lines a
    [x, o] = [0, 0]
    for w in l
      ++x if w is X
      ++o if w is O
    score += 10**x - 10**o if x is 0 or o is 0
  evals[b] = score

# -------------------------------------------------------

class MisereTicTacToe extends TicTacToe
  isWin: (who) -> super @opponent who
  utility: -> -super

# -------------------------------------------------------

module.exports = {
  _, X, O
  empty
  Board
  C14n
  TicTacToe
  ticTacToeEvaluate
  MisereTicTacToe
}
