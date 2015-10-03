# coffeelint: disable=max_line_length

chalk = require 'chalk'
{_, X, O, decode, BinTicTacToe} = require './bin-tic-tac-toe-cli'
{UltimateTicTacToe} = require './ultimate-tic-tac-toe-cli'
{MinimaxAgent} = require '../minimax'

log = console.log
write = (args...) -> process.stdout.write args...

Game = null
game = null
agent = new MinimaxAgent 3

# Agent :: {
#   nextAction : (State) -> Action
# }

# playTurn :: (Agent, State) -> [Action, State]
playTurn = (agent, state) ->
  return null if state.isTerminal()
  action = agent.nextAction state
  [action, state.play action]

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
  unless Game?
    log 'Choose (1) for tic tac toe or (anything else) for ultimate tic tac toe'
  else
    log game.toString()
    log ''
    finish() if game.isTerminal()
    write "#{chalk.blue.bold decode game.nextPlayer} plays. "
    log "Enter a position like #{chalk.blue.bold 'A1'}; or #{chalk.blue.bold '<ENTER>'} for me to play. #{chalk.blue.bold 'q'} quits."
  write '> '

humanPlays = (i) ->
  action = game.action i
  game = game.play action
  Game.position = i

computerPlays = ->
  console.time 'time'
  [action, nextGame] = playTurn agent, game
  console.timeEnd 'time'
  Game.position = game.positionForAction action
  game = nextGame

input = (text) ->
  action = game.parseAction text
  if game.isValidAction action
    humanPlays action
  else if text in ['bye', 'exit', 'quit', 'q']
    finish()
  else if text
    log chalk.red.bold 'Bad play: ' + text
  else
    computerPlays()

process.stdin.resume()
process.stdin.setEncoding 'utf8'
process.stdin.on 'data', (text) ->
  unless Game?
    Game = switch text.trim()
      when '1' then BinTicTacToe
      else UltimateTicTacToe
    game = new Game
  else
    log ''
    input text.trim().toLowerCase()
    log ''
  prompt()

printHeader()
prompt()
