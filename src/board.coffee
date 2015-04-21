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

module.exports =
  _: _, X: X, O: O
  empty: empty
  lines: lines
  Board: Board
  ultimateEmpty: ultimateEmpty
  UltimateBoard: UltimateBoard
