# coffeelint: disable=max_line_length

chalk = require 'chalk'
{Board} = require './board'
{_, X, O, TicTacToeState} = require './tic-tac-toe'
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
  sep = chalk.dim '|'
  p = (i) =>
    if @ps[i] is _
      chalk.dim i
    else if lastAction is i
      chalk.inverse.bold @ps[i]
    else
      chalk.bold @ps[i]
  """#{sep}#{p 0}#{sep}#{p 1}#{sep}#{p 2}#{sep}
     #{sep}#{p 3}#{sep}#{p 4}#{sep}#{p 5}#{sep}
     #{sep}#{p 6}#{sep}#{p 7}#{sep}#{p 8}#{sep}"""

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

humanPlays = (action) ->
  game = game.play action
  lastAction = action
  log 'You played ' + lastAction.toString()

computerPlays = ->
  [lastAction, game] = playTurn agent, game
  log 'I played ' + lastAction

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
