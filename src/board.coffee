[_, X, O] = [' ', 'X', 'O']

empty = [_,_,_
         _,_,_
         _,_,_]
class Board
  constructor: (@ps = empty) -> # ps = positions
  isTerminal: -> @isWin(X) or @isWin(O) or @isFull()
  isWin: (who) ->
    [@rows()..., @columns()..., @diagonals()...]
      .some (r) -> r.every (p) -> p is who
  isFull: -> @ps.every (p) -> p isnt _
  rows: -> ([@ps[i],@ps[i+1],@ps[i+2]] for i in [0..8] by 3)
  columns: -> ([@ps[i],@ps[i+3],@ps[i+6]] for i in [0..2])
  diagonals: -> [[@ps[0],@ps[4],@ps[8]], [@ps[2],@ps[4],@ps[6]]]
  toString: -> ("|#{r.join '|'}|" for r in @rows()).join "\n"


module.exports =
  _: _, X: X, O: O
  Board: Board
