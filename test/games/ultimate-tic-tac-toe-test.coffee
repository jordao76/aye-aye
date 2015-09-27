# coffeelint: disable=max_line_length

(require 'chai').should()
{_, X, O, bin, UltimateTicTacToe} = require '../../src/games/ultimate-tic-tac-toe'

# game in progress
g = bin [O,_,_
         _,X,_
         _,_,_]
# draw
d = bin [X,O,X
         O,O,X
         X,X,O]
# X wins
x = bin [X,O,O
         _,X,_
         _,_,X]
# O wins
o = bin [X,X,O
         _,O,_
         O,_,X]

describe 'UltimateTicTacToe', ->

  it 'toString should represent the board as a string', ->

    new UltimateTicTacToe().toString().should.equal(
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

    new UltimateTicTacToe([d,d,d
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

    new UltimateTicTacToe().isWin(X).should.be.false
    new UltimateTicTacToe().isWin(O).should.be.false

    new UltimateTicTacToe([d,d,d
                       x,x,d
                       o,d,d]).isWin(X).should.be.false
    new UltimateTicTacToe([d,d,d
                       x,x,d
                       o,d,d]).isWin(O).should.be.false

    new UltimateTicTacToe([g,g,x
                       g,g,x
                       g,g,x]).isWin(X).should.be.true
    new UltimateTicTacToe([g,g,x
                       g,g,x
                       g,g,x]).isWin(O).should.be.false

    new UltimateTicTacToe([d,d,x
                       d,x,g
                       o,d,o]).isWin(X).should.be.false
    new UltimateTicTacToe([d,d,x
                       d,x,g
                       o,d,o]).isWin(O).should.be.false

    new UltimateTicTacToe([d,d,x
                       d,x,g
                       o,o,o]).isWin(X).should.be.false
    new UltimateTicTacToe([d,d,x
                       d,x,g
                       o,o,o]).isWin(O).should.be.true

  it 'isTerminal should return if the game is over', ->

    new UltimateTicTacToe().isTerminal().should.be.false

    new UltimateTicTacToe([d,d,d
                       d,d,d
                       d,d,d]).isTerminal().should.be.true
