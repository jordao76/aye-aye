# coffeelint: disable=max_line_length

should = (require 'chai').should()
{
  _, X, O, decode
  empty
  bin, at, rows, columns, diagonals, lines
  isFull, isWin, isTerminal
  openPositions, allPlays, changedOn
  utility, evaluate
  BinTicTacToe
} = require '../../src/games/bin-tic-tac-toe'

e = empty
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

describe 'bin tic tac toe operations', ->

  describe 'decode', ->
    it 'should decode _, X and O from their binary values to their string representation', ->
      (decode _).should.equal ' '
      (decode X).should.equal 'X'
      (decode O).should.equal 'O'
      (-> decode X|O).should.throw Error # not representable

  describe 'bin', ->
    it 'should convert an array of positions (a board) into a single packed binary number', ->
      (bin [_,_,_,_,_,_,_,_,_]).should.equal 0
      (bin [X,_,_,_,_,_,_,_,_]).should.equal X
      (bin [_,_,_,_,X,_,_,_,_]).should.equal X<<(4*2) # each position takes 2 bits
      (bin [_,_,_,_,_,_,_,_,X]).should.equal X<<(8*2)
      (bin [X,_,_,_,X,_,_,_,X]).should.equal X|X<<(4*2)|X<<(8*2)
      (bin [X,_,O,_,X,_,O,_,X]).should.equal X|O<<(2*2)|X<<(4*2)|O<<(6*2)|X<<(8*2)
      (bin [_,X,_,O,_,X,_,O,_]).should.equal X<<(1*2)|O<<(3*2)|X<<(5*2)|O<<(7*2)

  describe 'at', ->
    it 'should retrieve the element at a specified position', ->
      a = bin [X,_,O,_,X,_,O,_,X]
      (at a, 0).should.equal X
      (at a, 1).should.equal _
      (at a, 2).should.equal O
      (at a, 3).should.equal _
      (at a, 4).should.equal X
      (at a, 5).should.equal _
      (at a, 6).should.equal O
      (at a, 7).should.equal _
      (at a, 8).should.equal X

  describe 'rows', ->
    it 'should retrieve the rows of a value', ->
      (rows bin [_,X,_,O,_,X,_,O,_]).should.deep.equal [[_,X,_],[O,_,X],[_,O,_]]

  describe 'columns', ->
    it 'should retrieve the columns of a value', ->
      (columns bin [_,X,_,O,_,X,_,O,_]).should.deep.equal [[_,O,_],[X,_,O],[_,X,_]]

  describe 'diagonals', ->
    it 'should retrieve the diagonals of a value', ->
      (diagonals bin [X,_,O,_,X,_,O,_,X]).should.deep.equal [[X,X,X],[O,X,O]]

  describe 'lines', ->
    it 'should retrieve all lines (rows, columns and diagonals) of a value', ->
      (lines bin [X,O,X
                  O,X,O
                  _,_,X]).should.deep.equal [
        [X,O,X],[O,X,O],[_,_,X]
        [X,O,_],[O,X,_],[X,O,X]
        [X,X,X],[X,X,_]
      ]

  describe 'isFull', ->
    it 'should detect if a value is full', ->
      (isFull bin [_,_,_,_,_,_,_,_,_]).should.be.false
      (isFull bin [X,_,O,_,X,_,O,_,X]).should.be.false
      (isFull bin [X,X,X,X,X,X,X,X,X]).should.be.true
      (isFull bin [O,O,O,O,O,O,O,O,O]).should.be.true
      (isFull bin [X,O,X,X,O,X,O,O,X]).should.be.true

  describe 'isWin', ->
    it 'should detect if a player won', ->
      (isWin e, X).should.be.false
      (isWin e, O).should.be.false
      (isWin g, X).should.be.false
      (isWin g, O).should.be.false
      (isWin d, X).should.be.false
      (isWin d, O).should.be.false
      (isWin x, X).should.be.true
      (isWin x, O).should.be.false
      (isWin o, X).should.be.false
      (isWin o, O).should.be.true

  describe 'isTerminal', ->
    it 'should return if the game is over', ->
      (isTerminal e).should.be.false
      (isTerminal g).should.be.false
      (isTerminal d).should.be.true
      (isTerminal x).should.be.true
      (isTerminal o).should.be.true

  describe 'openPositions', ->
    it 'should return a list of open positions', ->
      (openPositions e).should.deep.equal [0,1,2,3,4,5,6,7,8]
      (openPositions bin [X,_,O,_,X,_,O,_,X]).should.deep.equal [1,3,5,7]
      (openPositions bin [X,X,X,X,X,X,X,X,X]).should.deep.equal []

  describe 'allPlays', ->
    it 'should return all possible plays given a value and a player', ->
      (allPlays (bin [X,X,O,_,X,_,O,O,X]), X).should.deep.equal [
        bin [X,X,O,X,X,_,O,O,X]
        bin [X,X,O,_,X,X,O,O,X]
      ]
      (allPlays (bin [X,X,O,_,X,_,O,O,X]), O).should.deep.equal [
        bin [X,X,O,O,X,_,O,O,X]
        bin [X,X,O,_,X,O,O,O,X]
      ]

  describe 'changedOn', ->
    it 'should detect the first position where 2 values differ', ->
      (changedOn (bin [_,_,_,_,_,_,_,_,_]), (bin [_,X,_,_,_,_,_,_,_])).should.equal 1
      (changedOn (bin [_,X,_,_,_,_,_,_,_]), (bin [_,X,_,_,_,_,_,O,_])).should.equal 7
    it 'should return undefined if there\'s no change', ->
      should.not.exist changedOn (bin [_,X,_,_,_,_,_,_,_]), (bin [_,X,_,_,_,_,_,_,_])

  describe 'utility', ->
    it 'should return maximum score for wins', ->
      (utility bin [X,O,O,
                    O,X,O
                    O,O,X]).should.equal 2000
      (utility bin [O,O,O,
                    X,X,O
                    O,X,X]).should.equal -2000
    it 'should return score estimate for unfinished games', ->
      (utility bin [_,_,_,
                    _,X,_
                    _,_,_]).should.be.within 10, 100
      (utility bin [_,_,_,
                    _,O,_
                    _,_,_]).should.be.within -100, -10
      (utility bin [X,O,_,
                    _,X,_
                    _,_,_]).should.be.within 100, 1000
    it 'should return score of zero for draws', ->
      (utility bin [O,X,O,
                    X,X,O
                    X,O,X]).should.equal 0
