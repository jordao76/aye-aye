# coffeelint: disable=max_line_length

(require 'chai').should()
Solver = require '../src/solver'
{_, X, O, TicTacToeState} = require '../src/tic-tac-toe'

describe 'Solver', ->

  beforeEach ->
    @solver = new Solver
    @initialState = new TicTacToeState

  it 'should emit events while solving a minimax problem', ->

    [start, progress, end] = [0, 0, 0]
    finalState = null
    @solver
      .on 'start', -> ++start
      .on 'progress', -> ++progress
      .on 'end', (state) ->
        finalState = state
        ++end
      .solve @initialState

    start.should.equal 1
    progress.should.equal 9
    end.should.equal 1
    finalState.isWin(X).should.be.false
    finalState.isWin(O).should.be.false
    finalState.toString().should.not.equal @initialState.toString()

  it 'should be able to pause minimax before starting, and resume it later', ->

    [start, progress, end] = [0, 0, 0]
    @solver
      .on 'start', -> ++start
      .on 'progress', -> ++progress
      .on 'end', (state) -> ++end
      .pause()
      .solve @initialState

    start.should.equal 0
    progress.should.equal 0
    end.should.equal 0

    @solver.resume()

    start.should.equal 1
    progress.should.equal 9
    end.should.equal 1

  it 'should be able to pause minimax right after starting, and resume it later', ->

    [start, progress, end] = [0, 0, 0]
    @solver
      .on 'start', =>
        ++start
        @solver.pause()
      .on 'progress', -> ++progress
      .on 'end', (state) -> ++end
      .solve @initialState

    start.should.equal 1
    progress.should.equal 0
    end.should.equal 0

    @solver.resume()

    start.should.equal 1
    progress.should.equal 9
    end.should.equal 1

  it 'should be able to pause minimax when in progress, and resume it later', ->

    [start, progress, end] = [0, 0, 0]
    @solver
      .on 'start', -> ++start
      .on 'progress', =>
        ++progress
        @solver.pause()
      .on 'end', (state) -> ++end
      .solve @initialState

    start.should.equal 1
    progress.should.equal 1
    end.should.equal 0

    @solver.resume()
    progress.should.equal 2
    @solver.resume()
    progress.should.equal 3
    @solver.resume()
    progress.should.equal 4
    @solver.resume()
    progress.should.equal 5
    @solver.resume()
    progress.should.equal 6
    @solver.resume()
    progress.should.equal 7
    @solver.resume()
    progress.should.equal 8
    @solver.resume()
    progress.should.equal 9
    end.should.equal 0
    @solver.resume()
    end.should.equal 1
