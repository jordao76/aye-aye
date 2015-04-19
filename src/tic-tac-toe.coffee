{MAX, MIN} = require './minimax'

# TIC TAC TOE

{_, X, O, Board} = require './board'

empty = [_,_,_
         _,_,_
         _,_,_]
class TicTacToeState
  constructor: (@ps = empty, @nextPlayer = X, @depth = 0) -> # ps = positions
    @board = new Board(@ps)
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  opponent: (who = @nextPlayer) -> if who is X then O else X
  possibleActions: ->
    _is = (i for p, i in @ps when p is _) # _is = indexes of _s
    pss = ([@ps[0...i]..., @nextPlayer, @ps[i+1..]...] for i in _is)
    # the actions are the states
    (new @constructor ps, @opponent(), @depth + 1 for ps in pss)
  play: (action) -> action
  utility: ->
    # depth makes winning sooner preferable
    switch
      when @isWin X then  1 / (@depth + 1)
      when @isWin O then -1 / (@depth + 1)
      else 0
  isTerminal: -> @board.isTerminal()
  isWin: (who) -> @board.isWin who
  toString: -> @board.toString()

# MISÈRE TIC TAC TOE

class MisereTicTacToeState extends TicTacToeState
  isWin: (who) -> super @opponent who

# EXPORTS

module.exports =
  _: _, X: X, O: O
  TicTacToeState: TicTacToeState
  MisereTicTacToeState: MisereTicTacToeState
