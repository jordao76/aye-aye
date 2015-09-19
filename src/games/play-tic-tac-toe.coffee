# coffeelint: disable=max_line_length

chalk = require 'chalk'
{_, X, O, Board, TicTacToeState} = require './tic-tac-toe'
{MinimaxAgent} = require '../minimax'

log = console.log
write = (args...) -> process.stdout.write args...

game = new TicTacToeState
agent = new MinimaxAgent 3
lastAction = null

# Agent :: {
#   nextAction : (State) -> Action
# }

# playTurn :: (Agent, State) -> [Action, State]
playTurn = (agent, state) ->
  return null if state.isTerminal()
  action = agent.nextAction state
  [action, state.play action]

Board::toString = ->
  v = chalk.dim '|'
  h = chalk.dim '-----------'
  p = (i) =>
    if @ps[i] is _
      chalk.dim i
    else if lastAction.i is i
      chalk.inverse.bold @ps[i]
    else
      chalk.bold @ps[i]
  """ #{p 0} #{v} #{p 1} #{v} #{p 2}
      #{h}
       #{p 3} #{v} #{p 4} #{v} #{p 5}
      #{h}
       #{p 6} #{v} #{p 7} #{v} #{p 8}"""

TicTacToeState::parseAction = (text) -> parseInt text, 10
TicTacToeState::isValidAction = (action) -> action in @openPositions()

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
  log "#{chalk.bold game.nextPlayer} plays."
  log "Enter a position to play: #{chalk.bold game.openPositions()}; or just <ENTER> for me to play. 'q' quits."
  write '> '

humanPlays = (i) ->
  action = game.action i
  game = game.play action
  lastAction = action
  log 'You played ' + lastAction.toString()

computerPlays = ->
  [lastAction, game] = playTurn agent, game
  log 'I played ' + lastAction.toString()

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
