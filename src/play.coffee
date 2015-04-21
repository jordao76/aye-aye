{playTurn} = require './minimax'
{_, X, O, empty, ultimateEmpty, TicTacToeState,
 UltimateTicTacToeState, ticTacToeEvaluate} =
  require './tic-tac-toe'
{Board} = require './board'
{EventEmitter} = require 'events'
Solver = require './solver'

printState = (state) ->
  console.log state.toString()
  console.log ''

s = new Solver 3
s.on 'start', (state) ->
  printState state
  s.pause()
s.on 'progress', (state) ->
  printState state
  console.timeEnd 'time'
  s.pause()
s.on 'end', (state) ->
  console.log switch
    when state.isWin(X) then 'X Wins!'
    when state.isWin(O) then 'O Wins!'
    else 'Draw!'
  process.exit()

state = new UltimateTicTacToeState
s.solve state

process.stdin.resume()
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (text) ->
  console.time 'time'
  s.resume()
