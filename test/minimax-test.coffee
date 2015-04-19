(require 'chai').should()
{playTurn} = require '../src/minimax'
{_, X, O, TicTacToeState, MisereTicTacToeState} = require '../src/tic-tac-toe'

play = (state) ->
  while !state.isTerminal()
    state = playTurn state
  state

describe 'minimax strategy', ->

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
                                     |X|X| |
                                     | | |O|"""
    state = playTurn state
    # anywhere O plays he loses, and he plays the top right position
    # the top right is simply the first free position from left-to-right,
    # top-to-bottom
    state.toString().should.equal """|X|O|O|
                                     |X|X| |
                                     | | |O|"""
    state = playTurn state
    state.toString().should.equal """|X|O|O|
                                     |X|X|X|
                                     | | |O|"""
    state.isWin(X).should.be.true
    state.isWin(O).should.be.false

  it 'O should win given the right conditions', ->

    state = new TicTacToeState [_,X,_
                                _,O,_
                                _,_,_], O
    state = play state
    state.toString().should.equal """|O|X|X|
                                     |O|O|O|
                                     | | |X|"""
    state.isWin(X).should.be.false
    state.isWin(O).should.be.true

  xit 'Oh misère', ->

    state = new MisereTicTacToeState [O,O,X
                                      O,X,X
                                      _,_,_], X
    state = playTurn state
    state.toString().should.equal """|O|O|X|
                                     |O|X|X|
                                     | |X| |""" # unexpected play!!
