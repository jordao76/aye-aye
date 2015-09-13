# coffeelint: disable=max_line_length

chalk = require 'chalk'
{_, X, O, TicTacToeState, UltimateTicTacToeState} = require './tic-tac-toe'
{Board} = require './board'
Solver = require './solver'

log = console.log
write = (args...) -> process.stdout.write args...
s = new Solver 3

Board::toString = ->
  sep = chalk.dim '|'
  p = (i) => if @ps[i] is _ then chalk.dim i else chalk.bold @ps[i]
  """#{sep}#{p 0}#{sep}#{p 1}#{sep}#{p 2}#{sep}
     #{sep}#{p 3}#{sep}#{p 4}#{sep}#{p 5}#{sep}
     #{sep}#{p 6}#{sep}#{p 7}#{sep}#{p 8}#{sep}"""

printHeader = ->
  log chalk.yellow.bold """ _____ _        _____            _____
                           |_   _(_)      |_   _|          |_   _|
                             | |  _  ___    | | __ _  ___    | | ___   ___
                             | | | |/ __|   | |/ _` |/ __|   | |/ _ \\ / _ \\
                             | | | | (__    | | (_| | (__    | | (_) |  __/
                             \\_/ |_|\\___|   \\_/\\__,_|\\___|   \\_/\\___/ \\___|"""
  log ''

printState = (state) ->
  log state.toString()
  log ''
  printOpenPositions state

printOpenPositions = (state) ->
  if state.isTerminal()
    s.resume()
  else
    log "#{chalk.bold state.nextPlayer} plays."
    log "Enter a position to play: #{chalk.bold state.openPositions()}; or just <ENTER> for me to play. 'q' quits."
    write '> '

humanPlays = (position) ->
  if position in s.state.openPositions()
    log 'You played ' + position
    log ''
    s.state = s.state.play s.state.action position
    printState s.state
  else
    log chalk.red.bold 'Invalid position ' + position
    log ''
    printState s.state

computerPlays = ->
  log ''
  log 'I play'
  log ''
  console.time 'time'
  s.resume()

s.on 'start', (state) ->
  printHeader()
  printState state
  s.pause()
s.on 'progress', (newState) ->
  console.timeEnd 'time'
  printState newState
  s.pause()
s.on 'end', (state) ->
  log chalk.bold switch
    when state.isWin(X) then 'X Wins!'
    when state.isWin(O) then 'O Wins!'
    else 'Draw!'
  log ''
  process.exit()

state = new TicTacToeState
s.solve state

process.stdin.resume()
process.stdin.setEncoding 'utf8'

process.stdin.on 'data', (text) ->
  position = parseInt text, 10
  if Number.isInteger(position)
    humanPlays position
  else
    if text.trim().toLowerCase() in ['bye', 'exit', 'quit', 'q']
      log 'Goodbye...'
      process.exit()
    else
      computerPlays()
