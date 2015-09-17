# coffeelint: disable=max_line_length

(require 'chai').should()
{MAX, MIN, MinimaxAgent} = require '../src/minimax'

describe 'minimax strategy for 2-level tree', ->

  agent = new MinimaxAgent

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
    [utility, action] = agent.minimax initialState
    action.should.equal 'MAX wins'
    utility.should.equal 10

  it 'should minimize for MIN', ->
    initialState.nextAgent = -> MIN
    [utility, action] = agent.minimax initialState
    action.should.equal 'MIN wins'
    utility.should.equal -10

describe 'minimax strategy for 3-level tree', ->

  agent = new MinimaxAgent

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
    play: (a) -> if a is 1 then state1 @opponent() else state2 @opponent()
  state1 = (next) ->
    isTerminal: -> no
    nextAgent: -> next
    possibleActions: -> [1, 2]
    play: (a) -> terminal if a is 1 then 10 else -100
  state2 = (next) ->
    isTerminal: -> no
    nextAgent: -> next
    possibleActions: -> [1, 2]
    play: (a) -> terminal if a is 1 then -10 else 100
  terminal = (u) ->
    isTerminal: -> yes
    utility: -> u

  it 'should maximize for MAX', ->
    [utility, action] = agent.minimax initialState MAX
    action.should.equal 2
    utility.should.equal -10 # this is the best MAX can make

  it 'should minimize for MIN', ->
    [utility, action] = agent.minimax initialState MIN
    action.should.equal 1
    utility.should.equal 10 # this is the best MIN can make

  describe 'from state1', ->

    it 'should maximize for MAX', ->
      [utility, nextAction] = agent.minimax state1 MAX
      nextAction.should.equal 1
      utility.should.equal 10

    it 'should minimize for MIN', ->
      [utility, nextAction] = agent.minimax state1 MIN
      nextAction.should.equal 2
      utility.should.equal -100

  describe 'from state2', ->

    it 'should maximize for MAX', ->
      [utility, nextAction] = agent.minimax state2 MAX
      nextAction.should.equal 2
      utility.should.equal 100

    it 'should minimize for MIN', ->
      [utility, nextAction] = agent.minimax state2 MIN
      nextAction.should.equal 1
      utility.should.equal -10

# TODO: pruning
