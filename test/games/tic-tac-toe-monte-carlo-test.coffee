# coffeelint: disable=max_line_length

(require 'chai').should()
{MonteCarloAgent} = require '../../src/monte-carlo'

# note that it's not a guarantee that Monte Carlo will win in the following
# situations, and so the tests just exercises the algorithm without asserting any outcome
monteCarlo = new MonteCarloAgent timeFrameMs: 50

playTurn = (state) ->
  return null if state.isTerminal()
  state.play monteCarlo.nextAction state

play = (state) ->
  until state.isTerminal()
    state = playTurn state
  state

describe 'monte carlo tree search', ->
  @timeout 10*1000

  testTicTacToe = (str, game, _, X, O) ->

    describe str, ->

      it 'initial conditions', ->

        state = game()
        state = play state
        state.isTerminal().should.be.true

      it 'X favorable conditions', ->

        state = game [_,O,_
                      _,X,_
                      _,_,_], X
        state = play state
        state.isTerminal().should.be.true

      it 'O favorable conditions', ->

        state = game [_,X,_
                      _,O,_
                      _,_,_], O
        state = play state
        state.isTerminal().should.be.true

  do ->
    {_, X, O, BinTicTacToe} = require '../../src/games/bin-tic-tac-toe'
    game = (args...) -> BinTicTacToe.create args...
    testTicTacToe 'BinTicTacToe', game, _, X, O

  it 'Ultimate tic-tac-toe', ->

    {_, X, O, UltimateTicTacToe} = require '../../src/games/ultimate-tic-tac-toe'
    state = new UltimateTicTacToe
    state = play state
    state.isTerminal().should.be.true
