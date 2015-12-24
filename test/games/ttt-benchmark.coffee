# coffeelint: disable=max_line_length

(require 'chai').should()
Benchmark = require 'benchmark'
{MinimaxAgent} = require '../../src/minimax'
{TicTacToe} = require '../../src/games/tic-tac-toe'
{_,X,O,BinTicTacToe} = require '../../src/games/bin-tic-tac-toe'
{UltimateTicTacToe} = require '../../src/games/ultimate-tic-tac-toe'

play = (Game, depth = Infinity) ->
  agent = new MinimaxAgent depth
  state = new Game
  until state.isTerminal()
    state = state.play agent.nextAction state
  state

# warm up
play BinTicTacToe
play TicTacToe

describe 'Tic-tac-toe benchmarks', ->
  @timeout 60*1000
  new Benchmark.Suite()
    .add 'BinTicTacToe', -> play BinTicTacToe
    .add 'TicTacToe', -> play TicTacToe
    #.add 'UltimateTicTacToe depth 2', -> play UltimateTicTacToe, 2
    .on 'cycle', (e) -> it e.target, ->
    .run async: false
  it 'would be good to compare to older commits'
