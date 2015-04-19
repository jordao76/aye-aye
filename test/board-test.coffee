(require 'chai').should()
{_, X, O, Board} = require '../src/board'

describe 'Board', ->

  it 'toString should represent the board as a string', ->

    new Board().toString().should.equal """| | | |
                                           | | | |
                                           | | | |"""

    new Board([X,O,X
               O,X,O
               X,O,X]).toString().should.equal """|X|O|X|
                                                  |O|X|O|
                                                  |X|O|X|"""

  it 'isTerminal should return if the game is over', ->

    new Board().isTerminal().should.be.false

    new Board([X,O,X
               O,X,O
               X,O,X]).isTerminal().should.be.true

    new Board([X,_,X # <= open position
               O,X,O
               O,O,_]).isTerminal().should.be.false

    new Board([X,_,_
               _,X,_
               _,_,X]).isTerminal().should.be.true

    new Board([_,_,_
               _,_,_
               O,O,O]).isTerminal().should.be.true

  it 'isWin should find out if a player won', ->

    new Board().isWin(X).should.be.false
    new Board().isWin(O).should.be.false

    new Board([X,O,X
               O,X,O
               X,O,X]).isWin(X).should.be.true
    new Board([X,O,X
               O,X,O
               X,O,X]).isWin(O).should.be.false

    new Board([X,_,_
               _,X,_
               _,_,X]).isWin(X).should.be.true
    new Board([X,_,_
               _,X,_
               _,_,X]).isWin(O).should.be.false

    new Board([_,_,_
               _,_,_
               O,O,O]).isWin(O).should.be.true
    new Board([_,_,_
               _,_,_
               O,O,O]).isWin(X).should.be.false

    new Board([X,_,X
               _,O,_
               O,X,O]).isWin(X).should.be.false
    new Board([X,_,X
               _,O,_
               O,X,O]).isWin(O).should.be.false

    # both win
    new Board([X,X,X
               O,O,O
               O,X,O]).isWin(X).should.be.true
    new Board([X,X,X
               O,O,O
               O,X,O]).isWin(O).should.be.true
