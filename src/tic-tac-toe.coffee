{MAX, MIN} = require './minimax'

# TIC TAC TOE

[_, X, O] = [' ', 'X', 'O']
empty = [_,_,_
         _,_,_
         _,_,_]
class TicTacToeState
  constructor: (@board = empty, @nextPlayer = X, @depth = 0) ->
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  opponent: -> if @nextPlayer is X then O else X
  isTerminal: -> @isWin(X) or @isWin(O) or @isFull()
  isWin: (who) ->
    [@rows()..., @columns()..., @diagonals()...]
      .some (r) -> r.every (p) -> p is who
  isFull: -> @board.every (p) -> p isnt _
  possibleActions: ->
    b = @board
    _is = (i for p, i in b when p is _) # _is = indexes of _s
    bs = ([b[0...i]..., @nextPlayer, b[i+1..]...] for i in _is) # bs = boards
    # the actions are the states
    (new @constructor b, @opponent(), @depth + 1 for b in bs)
  play: (action) -> action
  utility: ->
    # depth makes winning sooner preferable
    switch
      when @isWin X then  1 / (@depth + 1)
      when @isWin O then -1 / (@depth + 1)
      else 0
  rows: -> b = @board; ([b[i],b[i+1],b[i+2]] for i in [0..8] by 3)
  columns: -> b = @board; ([b[i],b[i+3],b[i+6]] for i in [0..2])
  diagonals: -> b = @board; [[b[0],b[4],b[8]], [b[2],b[4],b[6]]]
  toString: -> ("|#{r.join '|'}|\n" for r in @rows()).join ''

# MISÈRE TIC TAC TOE

class MisereTicTacToeState extends TicTacToeState
  isWin: (who) -> super @opponent()

module.exports =
  _: _, X: X, O: O
  TicTacToeState: TicTacToeState
  MisereTicTacToeState: MisereTicTacToeState
