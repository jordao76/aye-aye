# coffeelint: disable=max_line_length

(require 'chai').should()
Benchmark = require 'benchmark'
{MinimaxAgent} = require '../../src/minimax'
{TicTacToe} = require '../../src/games/tic-tac-toe'
{BinTicTacToe} = require '../../src/games/bin-tic-tac-toe'
{UltimateTicTacToe} = require '../../src/games/ultimate-tic-tac-toe'

run = (s, f) ->
  new Benchmark.Suite()
    .add s, f
    .on 'cycle', (e) -> it e.target, ->
    .run async: false

describe 'Tic-tac-toe benchmarks', ->
  @timeout 60*1000

  runGame = (Game, description, depth, step = 20) ->
    agent = new MinimaxAgent depth
    playTurn = (state) -> state.play agent.nextAction state
    describe description, ->
      state = new Game
      turn = 0
      until state.isTerminal()
        run "minimax depth #{depth} play turn after #{turn} turns", -> playTurn state
        for i in [0...step]
          turn++
          state = playTurn state unless state.isTerminal()

  runGame TicTacToe, 'TicTacToe', Infinity
  runGame BinTicTacToe, 'BinTicTacToe', Infinity
  runGame UltimateTicTacToe, 'UltimateTicTacToe', 2
