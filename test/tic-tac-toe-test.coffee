{_, X, O, TicTacToeState} = require '../src/tic-tac-toe'

# PLAY

play = (initialState) ->
  {playTurn} = require '../src/minimax'

  console.time 'time'

  state = initialState
  console.log state.toString()
  while !state.isTerminal()
    state = playTurn state
    console.log state.toString()
  console.log switch
    when state.isWin X then 'X wins!'
    when state.isWin O then 'O wins!'
    else 'Draw!'

  console.timeEnd 'time'

board = [_,_,_
         _,_,_
         _,_,_]
state = new TicTacToeState board, X
play state
