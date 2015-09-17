# coffeelint: disable=max_line_length

(require 'chai').should()
{MAX, MIN, MinimaxAgent} = require '../src/minimax'

describe 'minimax strategy for 2-level tree', ->

  minimax = new MinimaxAgent

  # this it the tree in this example (utilities are after the colon)
  # ── initialState
  #   ├── maxState: 10
  #   └── minState: -10

  initialState =
    isTerminal: -> no
    possibleActions: -> ['MAX wins', 'MIN wins']
    play: (a) -> if a is 'MAX wins' then maxState else minState
  maxState =
    isTerminal: -> yes
    utility: -> 10
  minState =
    isTerminal: -> yes
    utility: -> -10

  it 'should maximize for MAX', ->
    initialState.nextAgent = -> MAX
    nextAction = minimax.nextAction initialState
    nextAction.should.equal 'MAX wins'

  it 'should minimize for MIN', ->
    initialState.nextAgent = -> MIN
    nextAction = minimax.nextAction initialState
    nextAction.should.equal 'MIN wins'

describe 'minimax strategy for 3-level tree', ->

  minimax = new MinimaxAgent

  # this it the tree in this example (actions are in parens, utilities after the colon)
  # ── initialState
  #   ├── (1) state1
  #   │   ├── (1) terminal : 10
  #   │   └── (2) terminal : -100
  #   └── (2) state2
  #       ├── (1) terminal : -10
  #       └── (2) terminal : 100

  initialState = (next) ->
    isTerminal: -> no
    nextAgent: -> next
    possibleActions: -> [1, 2]
    opponent: -> if next is MAX then MIN else MAX
    play: (a) -> if a is 1 then state1(@opponent()) else state2(@opponent())
  state1 = (next) ->
    isTerminal: -> no
    nextAgent: -> next
    possibleActions: -> [1, 2]
    play: (a) -> terminal(if a is 1 then 10 else -100)
  state2 = (next) ->
    isTerminal: -> no
    nextAgent: -> next
    possibleActions: -> [1, 2]
    play: (a) -> terminal(if a is 1 then -10 else 100)
  terminal = (u) ->
    isTerminal: -> yes
    utility: -> u

  it 'should maximize for MAX', ->
    nextAction = minimax.nextAction initialState(MAX)
    nextAction.should.equal 2

  it 'should minimize for MIN', ->
    nextAction = minimax.nextAction initialState(MIN)
    nextAction.should.equal 1

  describe 'from state1', ->

    it 'should maximize for MAX', ->
      nextAction = minimax.nextAction state1(MAX)
      nextAction.should.equal 1

    it 'should minimize for MIN', ->
      nextAction = minimax.nextAction state1(MIN)
      nextAction.should.equal 2

  describe 'from state2', ->

    it 'should maximize for MAX', ->
      nextAction = minimax.nextAction state2(MAX)
      nextAction.should.equal 2

    it 'should minimize for MIN', ->
      nextAction = minimax.nextAction state2(MIN)
      nextAction.should.equal 1
