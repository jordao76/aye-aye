# MINIMAX

[MAX, MIN] = ['MAX', 'MIN']

playTurn = (state) ->
  return null if state.isTerminal()
  [_, bestState] = minimax state
  return bestState

minimax = (state, alpha = -Infinity, beta = +Infinity) ->
  return [state.utility(), state] if state.isTerminal()
  return maxi state, alpha, beta if state.nextAgent() is MAX
  return mini state, alpha, beta #  state.nextAgent() is MIN

maxi = (state, alpha, beta) ->
  [bestValue, bestState] = [-Infinity, null]
  for successor in state.successors()
    [nextValue, _] = minimax successor, alpha, beta
    if nextValue > bestValue
      bestValue = nextValue
      bestState = successor
    return [bestValue, bestState] if bestValue >= beta
    alpha = Math.max alpha, bestValue
  return [bestValue, bestState]

mini = (state, alpha, beta) ->
  [bestValue, bestState] = [+Infinity, null]
  for successor in state.successors()
    [nextValue, _] = minimax successor, alpha, beta
    if nextValue < bestValue
      bestValue = nextValue
      bestState = successor
    return [bestValue, bestState] if bestValue <= alpha
    beta = Math.min beta, bestValue
  return [bestValue, bestState]

# TIC TAC TOE

[_, X, O] = [' ', 'X', 'O']
empty = [_,_,_
         _,_,_
         _,_,_]
class TicTacToeState
  constructor: (@board = empty, @nextPlayer = X, @depth = 0) ->
  nextAgent: -> if @nextPlayer is X then MAX else MIN
  isTerminal: -> @isWin(X) or @isWin(O) or @isFull()
  isWin: (who) ->
    [@rows()..., @columns()..., @diagonals()...]
      .some (r) -> r.every (p) -> p is who
  isFull: -> @board.every (p) -> p isnt _
  successors: ->
    [b, who] = [@board, @nextPlayer]
    _is = (i for p, i in b when p is _) # _is = indexes of _s
    bs = ([b[0...i]..., who, b[i+1..]...] for i in _is) # bs = boards
    opponent = if who is X then O else X
    (new TicTacToeState(b, opponent, @depth + 1) for b in bs)
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

# PLAY

console.time 'time'

start = [_,_,_
         _,_,_
         _,_,_]
state = new TicTacToeState start, X
console.log state.toString()
while !state.isTerminal()
  state = playTurn state
  console.log state.toString()
console.log switch
  when state.isWin X then 'X wins!'
  when state.isWin O then 'O wins!'
  else 'Draw!'

console.timeEnd 'time'
