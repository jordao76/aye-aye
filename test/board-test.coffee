(require 'chai').should()
{_, X, O, Board, UltimateBoard} = require '../src/board'

# game in progress
g = [O,_,_
     _,X,_
     _,_,_]
# draw
d = [X,O,X
     O,O,X
     X,X,O]
# X wins
x = [X,O,O
     _,X,_
     _,_,X]
# O wins
o = [X,X,O
     _,O,_
     O,_,X]

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

    new Board([1,2,3
               4,5,6
               7,8,9]).toString().should.equal """|1|2|3|
                                                  |4|5|6|
                                                  |7|8|9|"""

  it 'isWin should find out if a player won', ->

    new Board().isWin(X).should.be.false
    new Board().isWin(O).should.be.false

    new Board(x).isWin(X).should.be.true
    new Board(x).isWin(O).should.be.false

    new Board(o).isWin(O).should.be.true
    new Board(o).isWin(X).should.be.false

    new Board(g).isWin(X).should.be.false
    new Board(g).isWin(O).should.be.false

    new Board(d).isWin(X).should.be.false
    new Board(d).isWin(O).should.be.false

  it 'isTerminal should return if the game is over', ->

    new Board().isTerminal().should.be.false

    new Board(g).isTerminal().should.be.false

    new Board(d).isTerminal().should.be.true

    new Board(x).isTerminal().should.be.true

    new Board(o).isTerminal().should.be.true

describe 'UltimateBoard', ->

  bs = (pss) -> (new Board ps for ps in pss)

  it 'toString should represent the board as a string', ->

    new UltimateBoard().toString().should.equal(
      """| | | | ║ | | | | ║ | | | |
         | | | | ║ | | | | ║ | | | |
         | | | | ║ | | | | ║ | | | |
         ════════╬═════════╬════════
         | | | | ║ | | | | ║ | | | |
         | | | | ║ | | | | ║ | | | |
         | | | | ║ | | | | ║ | | | |
         ════════╬═════════╬════════
         | | | | ║ | | | | ║ | | | |
         | | | | ║ | | | | ║ | | | |
         | | | | ║ | | | | ║ | | | |"""
     )

    new UltimateBoard(
      [
        new Board [1,1,1,1,1,1,1,1,1]
        new Board [2,2,2,2,2,2,2,2,2]
        new Board [3,3,3,3,3,3,3,3,3]
        new Board [4,4,4,4,4,4,4,4,4]
        new Board [5,5,5,5,5,5,5,5,5]
        new Board [6,6,6,6,6,6,6,6,6]
        new Board [7,7,7,7,7,7,7,7,7]
        new Board [8,8,8,8,8,8,8,8,8]
        new Board [9,9,9,9,9,9,9,9,9]
      ]
    ).toString().should.equal(
      """|1|1|1| ║ |2|2|2| ║ |3|3|3|
         |1|1|1| ║ |2|2|2| ║ |3|3|3|
         |1|1|1| ║ |2|2|2| ║ |3|3|3|
         ════════╬═════════╬════════
         |4|4|4| ║ |5|5|5| ║ |6|6|6|
         |4|4|4| ║ |5|5|5| ║ |6|6|6|
         |4|4|4| ║ |5|5|5| ║ |6|6|6|
         ════════╬═════════╬════════
         |7|7|7| ║ |8|8|8| ║ |9|9|9|
         |7|7|7| ║ |8|8|8| ║ |9|9|9|
         |7|7|7| ║ |8|8|8| ║ |9|9|9|"""
     )

    new UltimateBoard(bs [d,d,d
                          x,x,d
                          o,d,d]).toString().should.equal(
      """|X|O|X| ║ |X|O|X| ║ |X|O|X|
         |O|O|X| ║ |O|O|X| ║ |O|O|X|
         |X|X|O| ║ |X|X|O| ║ |X|X|O|
         ════════╬═════════╬════════
         |X|O|O| ║ |X|O|O| ║ |X|O|X|
         | |X| | ║ | |X| | ║ |O|O|X|
         | | |X| ║ | | |X| ║ |X|X|O|
         ════════╬═════════╬════════
         |X|X|O| ║ |X|O|X| ║ |X|O|X|
         | |O| | ║ |O|O|X| ║ |O|O|X|
         |O| |X| ║ |X|X|O| ║ |X|X|O|"""
     )

  it 'isWin should find out if a player won', ->

    new UltimateBoard().isWin(X).should.be.false
    new UltimateBoard().isWin(O).should.be.false

    new UltimateBoard(bs [d,d,d
                          x,x,d
                          o,d,d]).isWin(X).should.be.false
    new UltimateBoard(bs [d,d,d
                          x,x,d
                          o,d,d]).isWin(O).should.be.false

    new UltimateBoard(bs [g,g,x
                          g,g,x
                          g,g,x]).isWin(X).should.be.true
    new UltimateBoard(bs [g,g,x
                          g,g,x
                          g,g,x]).isWin(O).should.be.false

    new UltimateBoard(bs [d,d,x
                          d,x,g
                          o,d,o]).isWin(X).should.be.false
    new UltimateBoard(bs [d,d,x
                          d,x,g
                          o,d,o]).isWin(O).should.be.false

    new UltimateBoard(bs [d,d,x
                          d,x,g
                          o,o,o]).isWin(X).should.be.false
    new UltimateBoard(bs [d,d,x
                          d,x,g
                          o,o,o]).isWin(O).should.be.true

  it 'isTerminal should return if the game is over', ->

    new UltimateBoard().isTerminal().should.be.false

    new UltimateBoard(bs [d,d,d
                          d,d,d
                          d,d,d]).isTerminal().should.be.true
