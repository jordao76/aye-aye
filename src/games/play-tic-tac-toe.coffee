# coffeelint: disable=max_line_length

chalk = require 'chalk'
{_, X, O, decode, BinTicTacToe} = require './bin-tic-tac-toe'
{UltimateTicTacToe} = require './ultimate-tic-tac-toe'
{MinimaxAgent} = require '../minimax'

log = console.log
write = (args...) -> process.stdout.write args...

game = new BinTicTacToe
agent = new MinimaxAgent 3
position = null # position of the last play

# Agent :: {
#   nextAction : (State) -> Action
# }

# playTurn :: (Agent, State) -> [Action, State]
playTurn = (agent, state) ->
  return null if state.isTerminal()
  action = agent.nextAction state
  [action, state.play action]

BinTicTacToe::toString = ->
  t = chalk.yellow '┏━━━┳━━━┳━━━┓'
  v = chalk.yellow '┃'
  h = chalk.yellow '┣━━━╋━━━╋━━━┫'
  b = chalk.yellow '┗━━━┻━━━┻━━━┛'
  l = (s) -> chalk.dim s
  p = (i) =>
    if (@at i) is _
      ' ' #chalk.dim i
    else if position is i
      chalk.red.bold decode @at i
    else
      chalk.bold decode @at i
  """         #{l 1}   #{l 2}   #{l 3}
       #{t}
      #{l 'A'}#{v} #{p 0} #{v} #{p 1} #{v} #{p 2} #{v}
       #{h}
      #{l 'B'}#{v} #{p 3} #{v} #{p 4} #{v} #{p 5} #{v}
       #{h}
      #{l 'C'}#{v} #{p 6} #{v} #{p 7} #{v} #{p 8} #{v}
       #{b}"""

UltimateTicTacToe::toString = ->
  v = chalk.yellow  '|'
  vv = chalk.yellow '║'
  h = chalk.yellow  '-----------╬-----------╬-----------'
  hh = chalk.yellow '═══════════╬═══════════╬═══════════'

  p = (i, j) =>
    if (@at i, j) is _
      ' ' #chalk.dim j
    else if position[0] is i and position[1] is j
      chalk.red.bold decode (@at i, j)
    else
      chalk.bold decode (@at i, j)
  """ #{p 0,0} #{v} #{p 0,1} #{v} #{p 0,2} #{vv} #{p 1,0} #{v} #{p 1,1} #{v} #{p 1,2} #{vv} #{p 2,0} #{v} #{p 2,1} #{v} #{p 2,2}
      #{h}
       #{p 0,3} #{v} #{p 0,4} #{v} #{p 0,5} #{vv} #{p 1,3} #{v} #{p 1,4} #{v} #{p 1,5} #{vv} #{p 2,3} #{v} #{p 2,4} #{v} #{p 2,5}
      #{h}
       #{p 0,6} #{v} #{p 0,7} #{v} #{p 0,8} #{vv} #{p 1,6} #{v} #{p 1,7} #{v} #{p 1,8} #{vv} #{p 2,6} #{v} #{p 2,7} #{v} #{p 2,8}
      #{hh}
       #{p 3,0} #{v} #{p 3,1} #{v} #{p 3,2} #{vv} #{p 4,0} #{v} #{p 4,1} #{v} #{p 4,2} #{vv} #{p 5,0} #{v} #{p 5,1} #{v} #{p 5,2}
      #{h}
       #{p 3,3} #{v} #{p 3,4} #{v} #{p 3,5} #{vv} #{p 4,3} #{v} #{p 4,4} #{v} #{p 4,5} #{vv} #{p 5,3} #{v} #{p 5,4} #{v} #{p 5,5}
      #{h}
       #{p 3,6} #{v} #{p 3,7} #{v} #{p 3,8} #{vv} #{p 4,6} #{v} #{p 4,7} #{v} #{p 4,8} #{vv} #{p 5,6} #{v} #{p 5,7} #{v} #{p 5,8}
      #{hh}
       #{p 6,0} #{v} #{p 6,1} #{v} #{p 6,2} #{vv} #{p 7,0} #{v} #{p 7,1} #{v} #{p 7,2} #{vv} #{p 8,0} #{v} #{p 8,1} #{v} #{p 8,2}
      #{h}
       #{p 6,3} #{v} #{p 6,4} #{v} #{p 6,5} #{vv} #{p 7,3} #{v} #{p 7,4} #{v} #{p 7,5} #{vv} #{p 8,3} #{v} #{p 8,4} #{v} #{p 8,5}
      #{h}
       #{p 6,6} #{v} #{p 6,7} #{v} #{p 6,8} #{vv} #{p 7,6} #{v} #{p 7,7} #{v} #{p 7,8} #{vv} #{p 8,6} #{v} #{p 8,7} #{v} #{p 8,8}
     """

toInt = (s) -> parseInt s, 10

coordinateMap = ['A1','A2','A3','B1','B2','B3','C1','C2','C3']

BinTicTacToe::parseAction = (text) ->
  coordinateMap.indexOf text.toUpperCase()
BinTicTacToe::isValidAction = (action) ->
  action in @openPositions()

UltimateTicTacToe::parseAction = (text) ->
  if text.match /^(\d),(\d)$/
    [(toInt RegExp.$1), (toInt RegExp.$2)]
UltimateTicTacToe::isValidAction = (action) ->
  return no unless action?
  [x,y] = action
  for [i,j] in @possibleActions()
    return yes if x is i and y is j
  no

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
  write "#{chalk.blue.bold decode game.nextPlayer} plays. "
  log "Enter a position like #{chalk.blue.bold 'A1'}; or #{chalk.blue.bold '<ENTER>'} for me to play. #{chalk.blue.bold 'q'} quits."
  write '> '

humanPlays = (i) ->
  action = game.action i
  game = game.play action
  position = i

computerPlays = ->
  console.time 'time'
  [action, nextGame] = playTurn agent, game
  console.timeEnd 'time'
  position = game.positionForAction action
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
  log ''
  input text.trim().toLowerCase()
  log ''
  prompt()

printHeader()
prompt()
