# coffeelint: disable=max_line_length

(require 'chai').should()
{MinimaxAgent} = require '../../src/minimax'
{TicTacToe} = require '../../src/games/tic-tac-toe'
{_,X,O,BinTicTacToe} = require '../../src/games/bin-tic-tac-toe'
{UltimateTicTacToe} = require '../../src/games/ultimate-tic-tac-toe'

# to execute this file standalone via `coffee test/games/perf.coffee`
# had to declare "describe" and "it" via eval'ed javascript
# declaring those functions directly causes mocha to behave differently
unless describe?
  eval("var describe=function(str,f){console.log(str);f();}")
  eval("var it=function(str){console.log('  '+str);}")

play = (Game, depth = Infinity) ->
  agent = new MinimaxAgent depth
  state = new Game
  until state.isTerminal()
    state = state.play agent.nextAction state
  state

run = (Game, str, n = 10, warmup = yes, depth = Infinity) ->
  describe "Performance for #{n} runs of #{str}", ->
    state = play Game, depth if warmup
    times = []
    for i in [0...n]
      s = Date.now()
      state = play Game, depth
      times.push Date.now() - s
    avg = (times.reduce (l, r) -> l + r) / n
    it "averages #{avg}ms", ->

run BinTicTacToe, 'BinTicTacToe', 100
run TicTacToe, 'TicTacToe', 10
#run UltimateTicTacToe, 'UltimateTicTacToe', 1, no, 3
