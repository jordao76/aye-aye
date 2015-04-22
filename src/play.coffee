{playTurn} = require './minimax'
{_, X, O, TicTacToeState} = require './tic-tac-toe'
{EventEmitter} = require 'events'
Solver = require './solver'

printState = (state) ->
  console.log state.toString()
  console.log ''

s = new Solver
s.on 'start', (state) ->
  printState state
  s.pause()
s.on 'progress', (state) ->
  printState state
  s.pause()
s.on 'end', (state) ->
  console.log switch
    when state.isWin(X) then 'X Wins!'
    when state.isWin(O) then 'O Wins!'
    else 'Draw!'
  process.exit()

state = new TicTacToeState
s.solve state

process.stdin.resume()
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (text) -> s.resume()
