# coffeelint: disable=max_line_length

chalk = require 'chalk'
{_, X, O, TicTacToeState, UltimateTicTacToeState} = require './tic-tac-toe'
{Board} = require './board'
{playTurn} = require './minimax'

log = console.log
write = (args...) -> process.stdout.write args...

game = new TicTacToeState

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

finish = ->
  log chalk.bold switch
    when game.isWin(X) then 'X Wins!'
    when game.isWin(O) then 'O Wins!'
    when game.isTerminal() then 'Draw!'
    else 'Goodbye...'
  log ''
  process.exit()

prompt = ->
  printState()
  write '> '

printState = ->
  log game.toString()
  log ''
  printOpenPositions()

printOpenPositions = ->
  finish() if game.isTerminal()
  log "#{chalk.bold game.nextPlayer} plays."
  log "Enter a position to play: #{chalk.bold game.openPositions()}; or just <ENTER> for me to play. 'q' quits."

humanPlays = (position) ->
  if position in game.openPositions()
    game = game.play game.action position
    log 'You played ' + position
  else
    log chalk.red.bold 'Invalid position ' + position

computerPlays = ->
  game = playTurn game, 3
  log 'I play'

printHeader()
prompt()

process.stdin.resume()
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (text) ->
  log ''
  position = parseInt text, 10
  if Number.isInteger(position)
    humanPlays position
  else
    if text.trim().toLowerCase() in ['bye', 'exit', 'quit', 'q']
      finish()
    else
      computerPlays()
  log ''
  prompt()
