# coffeelint: disable=max_line_length

(require 'chai').should()
{_, X, O, empty, Board} = require '../../src/games/tic-tac-toe'

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

  it 'rows should break the board into its rows', ->
    new Board().rows([1,2,3
                      4,5,6
                      7,8,9]).should.deep.equal [[1,2,3]
                                                 [4,5,6]
                                                 [7,8,9]]

  it 'columns should break the board into its columns', ->
    new Board().columns([1,2,3
                         4,5,6
                         7,8,9]).should.deep.equal [[1,4,7]
                                                    [2,5,8]
                                                    [3,6,9]]

  it 'diagonals should break the board into its diagonals', ->
    new Board().diagonals([1,2,3
                           4,5,6
                           7,8,9]).should.deep.equal [[1,5,9]
                                                      [3,5,7]]

  it 'lines should break the board into its winning-prone lines (rows + columns + diagonals)', ->
    new Board().lines([1,2,3
                       4,5,6
                       7,8,9]).should.deep.equal [[1,2,3]
                                                  [4,5,6]
                                                  [7,8,9]
                                                  [1,4,7]
                                                  [2,5,8]
                                                  [3,6,9]
                                                  [1,5,9]
                                                  [3,5,7]]

  it 'isTerminal should return if the game is over', ->

    new Board().isTerminal().should.be.false

    new Board(g).isTerminal().should.be.false

    new Board(d).isTerminal().should.be.true

    new Board(x).isTerminal().should.be.true

    new Board(o).isTerminal().should.be.true

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

  it 'isFull should indicate if the board is full', ->

    new Board().isFull().should.be.false
    new Board(g).isFull().should.be.false
    new Board(d).isFull().should.be.true

  it 'openPositions should return all open position indexes in an array', ->

    new Board().openPositions().should.deep.equal [0,1,2,3,4,5,6,7,8]
    new Board(d).openPositions().should.deep.equal []
    new Board(g).openPositions().should.deep.equal [1,2,3,5,6,7,8]

  it 'mark should mark the board with a new play (returned as a new array of positions)', ->

    new Board().mark(4,X).should.deep.equal [_,_,_
                                             _,X,_
                                             _,_,_]

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

# -------------------------------------------------------

{C14n} = require '../../src/games/tic-tac-toe'

describe 'C14n', ->

  c14n = new C14n

  describe 'rotate', ->
    it 'should rotate a board clockwise', ->
      c14n.rotate([1,2,3
                   4,5,6
                   7,8,9]).should.deep.equal [7,4,1
                                              8,5,2
                                              9,6,3]
  describe 'rotations', ->
    it 'should return all rotations of a board', ->
      c14n.rotations([1,2,3
                      4,5,6
                      7,8,9]).should.deep.equal [[1,2,3
                                                  4,5,6
                                                  7,8,9]
                                                 [7,4,1
                                                  8,5,2
                                                  9,6,3]
                                                 [9,8,7
                                                  6,5,4
                                                  3,2,1]
                                                 [3,6,9
                                                  2,5,8
                                                  1,4,7]]
  describe 'flip', ->
    it 'should flip a board horizontally', ->
      c14n.flip([1,2,3
                 4,5,6
                 7,8,9]).should.deep.equal [3,2,1
                                            6,5,4
                                            9,8,7]
  describe 'symmetries', ->
    it 'should return all rotations and flipped rotations', ->
      c14n.symmetries([1,2,3
                       4,5,6
                       7,8,9]).should.deep.equal [[1,2,3
                                                   4,5,6
                                                   7,8,9]
                                                  [7,4,1
                                                   8,5,2
                                                   9,6,3]
                                                  [9,8,7
                                                   6,5,4
                                                   3,2,1]
                                                  [3,6,9
                                                   2,5,8
                                                   1,4,7]
                                                  [3,2,1
                                                   6,5,4
                                                   9,8,7]
                                                  [9,6,3
                                                   8,5,2
                                                   7,4,1]
                                                  [7,8,9
                                                   4,5,6
                                                   1,2,3]
                                                  [1,4,7
                                                   2,5,8
                                                   3,6,9]]
  describe 'canonicalize', ->
    it 'should return the same representation for all symmetries of a board', ->
      board = [_,O,X
               O,X,X
               _,_,O]
      c = c14n.canonicalize board
      ss = c14n.symmetries board
      (c14n.canonicalize s).should.deep.equal c for s in ss

# -------------------------------------------------------

{UC14n} = require '../../src/games/ultimate-tic-tac-toe'

describe 'UC14n', ->

  uc14n = new UC14n
  c14n = new C14n

  rd = c14n.rotate d
  rx = c14n.rotate x
  ro = c14n.rotate o

  fd = c14n.flip d
  fx = c14n.flip x
  fo = c14n.flip o

  describe 'rotate', ->
    it 'should rotate an ultimate board clockwise', ->
      uc14n.rotate([d,d,d
                    x,x,d
                    o,d,d]).
        should.deep.equal [ro,rx,rd
                           rd,rx,rd
                           rd,rd,rd]
  describe 'flip', ->
    it 'should flip an ultimate board horizontally', ->
      uc14n.flip([d,d,d
                  x,x,d
                  o,d,d]).
        should.deep.equal [fd,fd,fd
                           fd,fx,fx
                           fd,fd,fo]
  describe 'canonicalize', ->
    it 'should return the same representation for all symmetries of an ultimate board', ->
      board = [d,d,d
               x,x,d
               o,d,d]
      c = uc14n.canonicalize board
      ss = uc14n.symmetries board
      (uc14n.canonicalize s).should.deep.equal c for s in ss

# -------------------------------------------------------

{UltimateBoard} = require '../../src/games/ultimate-tic-tac-toe'

describe 'UltimateBoard', ->

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
        [1,1,1,1,1,1,1,1,1]
        [2,2,2,2,2,2,2,2,2]
        [3,3,3,3,3,3,3,3,3]
        [4,4,4,4,4,4,4,4,4]
        [5,5,5,5,5,5,5,5,5]
        [6,6,6,6,6,6,6,6,6]
        [7,7,7,7,7,7,7,7,7]
        [8,8,8,8,8,8,8,8,8]
        [9,9,9,9,9,9,9,9,9]
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

    new UltimateBoard([d,d,d
                       x,x,d
                       o,d,d]).
      toString().should.equal(
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

    new UltimateBoard([d,d,d
                       x,x,d
                       o,d,d]).isWin(X).should.be.false
    new UltimateBoard([d,d,d
                       x,x,d
                       o,d,d]).isWin(O).should.be.false

    new UltimateBoard([g,g,x
                       g,g,x
                       g,g,x]).isWin(X).should.be.true
    new UltimateBoard([g,g,x
                       g,g,x
                       g,g,x]).isWin(O).should.be.false

    new UltimateBoard([d,d,x
                       d,x,g
                       o,d,o]).isWin(X).should.be.false
    new UltimateBoard([d,d,x
                       d,x,g
                       o,d,o]).isWin(O).should.be.false

    new UltimateBoard([d,d,x
                       d,x,g
                       o,o,o]).isWin(X).should.be.false
    new UltimateBoard([d,d,x
                       d,x,g
                       o,o,o]).isWin(O).should.be.true

  it 'isTerminal should return if the game is over', ->

    new UltimateBoard().isTerminal().should.be.false

    new UltimateBoard([d,d,d
                       d,d,d
                       d,d,d]).isTerminal().should.be.true
