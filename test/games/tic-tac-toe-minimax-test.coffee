# coffeelint: disable=max_line_length

(require 'chai').should()
{MinimaxAgent} = require '../../src/minimax'

minimax = new MinimaxAgent

playTurn = (state) ->
  return null if state.isTerminal()
  state.play minimax.nextAction state

play = (state) ->
  until state.isTerminal()
    state = playTurn state
  state

testTicTacToe = (game, _, X, O) ->

  describe 'minimax strategy - tic tac toe', ->

    it 'should end in a draw for initial conditions', ->

      state = game()
      state = play state
      state.isWin(X).should.be.false
      state.isWin(O).should.be.false

    it 'X should win given the right conditions', ->

      state = game [_,O,_
                    _,X,_
                    _,_,_], X
      state = play state
      state.isWin(X).should.be.true
      state.isWin(O).should.be.false

    it 'O should win given the right conditions', ->

      state = game [_,X,_
                    _,O,_
                    _,_,_], O
      state = play state
      state.isWin(X).should.be.false
      state.isWin(O).should.be.true

do ->
  {_, X, O, TicTacToe} = require '../../src/games/tic-tac-toe'
  game = (args...) -> new TicTacToe args...
  testTicTacToe game, _, X, O

do ->
  {_, X, O, BinTicTacToe} = require '../../src/games/bin-tic-tac-toe'
  game = (args...) -> BinTicTacToe.create args...
  testTicTacToe game, _, X, O

describe 'minimax strategy - tic tac toe', ->

  it 'Oh misère', ->

    {_, X, O, MisereTicTacToe} = require '../../src/games/tic-tac-toe'
    state = new MisereTicTacToe [O,O,X
                                 O,X,X
                                 _,_,_], X
    state = play state
    state.isWin(X).should.be.false
    state.isWin(O).should.be.true
