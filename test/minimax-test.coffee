# coffeelint: disable=max_line_length

(require 'chai').should()
{playTurn} = require '../src/minimax'
{_, X, O, TicTacToeState, MisereTicTacToeState, UltimateTicTacToeState} = require '../src/tic-tac-toe'

play = (state, depth = Infinity) ->
  while !state.isTerminal()
    state = playTurn state, depth
  state

describe 'minimax strategy - tic tac toe', ->

  it 'should end in a draw for initial conditions', ->

    state = new TicTacToeState
    state = play state
    state.isWin(X).should.be.false
    state.isWin(O).should.be.false

  it 'X should win given the right conditions', ->

    state = new TicTacToeState [_,O,_
                                _,X,_
                                _,_,_], X
    state = playTurn state
    state.toString().should.equal """|X|O| |
                                     | |X| |
                                     | | | |"""
    state = playTurn state
    state.toString().should.equal """|X|O| |
                                     | |X| |
                                     | | |O|"""
    state = playTurn state
    state.toString().should.equal """|X|O| |
                                     | |X| |
                                     |X| |O|"""
    state = playTurn state
    state.toString().should.equal """|X|O|O|
                                     | |X| |
                                     |X| |O|"""
    state = playTurn state
    state.toString().should.equal """|X|O|O|
                                     |X|X| |
                                     |X| |O|"""
    state.isWin(X).should.be.true
    state.isWin(O).should.be.false

  it 'O should win given the right conditions', ->

    state = new TicTacToeState [_,X,_
                                _,O,_
                                _,_,_], O
    state = play state
    state.toString().should.equal """|O|X|X|
                                     |O|O| |
                                     |O| |X|"""
    state.isWin(X).should.be.false
    state.isWin(O).should.be.true

  it 'Oh misère', ->

    state = new MisereTicTacToeState [O,O,X
                                      O,X,X
                                      _,_,_], X
    state = playTurn state
    state.toString().should.equal """|O|O|X|
                                     |O|X|X|
                                     | |X| |"""
    state = playTurn state
    state.toString().should.equal """|O|O|X|
                                     |O|X|X|
                                     | |X|O|"""
    state = playTurn state
    state.toString().should.equal """|O|O|X|
                                     |O|X|X|
                                     |X|X|O|"""
    state.isWin(X).should.be.false
    state.isWin(O).should.be.true
