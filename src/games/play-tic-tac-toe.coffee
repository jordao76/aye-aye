# coffeelint: disable=max_line_length

chalk = require 'chalk'
{_, X, O, decode, BinTicTacToe} = require './bin-tic-tac-toe'
{_, X, O, UltimateTicTacToe} = require './ultimate-tic-tac-toe'
{MinimaxAgent} = require '../minimax'

log = console.log
write = (args...) -> process.stdout.write args...

game = new BinTicTacToe
agent = new MinimaxAgent 3
lastAction = null
lastPosition = null

# Agent :: {
#   nextAction : (State) -> Action
# }

# playTurn :: (Agent, State) -> [Action, State]
playTurn = (agent, state) ->
  return null if state.isTerminal()
  action = agent.nextAction state
  [action, state.play action]

BinTicTacToe::toString = ->
  v = chalk.dim '|'
  h = chalk.dim '-----------'
  p = (i) =>
    if @at(i) is _
      chalk.dim i
    else if lastPosition is i
      chalk.inverse.bold decode @at i
    else
      chalk.bold decode @at i
  """ #{p 0} #{v} #{p 1} #{v} #{p 2}
      #{h}
       #{p 3} #{v} #{p 4} #{v} #{p 5}
      #{h}
       #{p 6} #{v} #{p 7} #{v} #{p 8}"""

BinTicTacToe::parseAction = (text) -> parseInt text, 10
BinTicTacToe::isValidAction = (action) -> action in @openPositions()
UltimateTicTacToe::parseAction = (text) -> null
UltimateTicTacToe::isValidAction = (action) -> no

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
  log game.toString()
  log ''
  finish() if game.isTerminal()
  log "#{chalk.bold decode game.nextPlayer} plays."
  log "Enter a position to play: #{chalk.bold game.openPositions()}; or just <ENTER> for me to play. 'q' quits."
  write '> '

humanPlays = (i) ->
  action = game.action i
  game = game.play action
  lastAction = action
  lastPosition = i
  log 'You played ' + lastPosition

computerPlays = ->
  console.time 'In'
  [action, nextGame] = playTurn agent, game
  lastPosition = game.positionForAction action
  [lastAction, game] = [action, nextGame]
  console.timeEnd 'In'
  log 'I played ' + lastPosition

  do -> # play continuously
    return
    log game.toString()
    finish() if game.isTerminal()
    computerPlays()

input = (text) ->
  action = game.parseAction text
  if game.isValidAction action
    humanPlays action
  else if text in ['bye', 'exit', 'quit', 'q']
    finish()
  else if text
    log chalk.red.bold 'Invalid input ' + text
  else
    computerPlays()

printHeader()
prompt()

process.stdin.resume()
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (text) ->
  log ''
  input text.trim().toLowerCase()
  log ''
  prompt()
