# coffeelint: disable=max_line_length

(require 'chai').should()
{MAX, MIN, MinimaxAgent} = require '../src/minimax'

node = (utility, children = null) -> (next) ->
  isTerminal: -> !children?
  opponent: -> if next is MAX then MIN else MAX
  nextAgent: -> next
  possibleActions: -> [0...children.length]
  play: (i) -> children[i] @opponent()
  utility: -> utility

describe 'minimax strategy for 2-level tree', ->

  agent = new MinimaxAgent

  root =
    node 0, [
      (node 10),
      (node -10)
    ]

  it 'should maximize for MAX', ->
    [utility, action] = agent.minimax root MAX
    action.should.equal 0
    utility.should.equal 10

  it 'should minimize for MIN', ->
    [utility, action] = agent.minimax root MIN
    action.should.equal 1
    utility.should.equal -10

describe 'minimax strategy for 3-level tree', ->

  agent = new MinimaxAgent

  root =
    node 0, [
      node 0, [
        (node 10),
        (node -100)
      ]
      node 0, [
        (node -10),
        (node 100)
      ]
    ]

  it 'should maximize for MAX', ->
    [utility, action] = agent.minimax root MAX
    action.should.equal 1
    utility.should.equal -10 # this is the best MAX can make

  it 'should minimize for MIN', ->
    [utility, action] = agent.minimax root MIN
    action.should.equal 0
    utility.should.equal 10 # this is the best MIN can make

describe 'minimax strategy with α-β pruning', ->

  agent = new MinimaxAgent

  fail = -> throw new Error
  root =
    node 0, [
      node 0, [
        (node 3),
        (node 12)
      ]
      node 0, [
        (node 2),
        # this next node should not be visited, since because of the 2,
        # this whole branch of the tree would never be chosen by MAX,
        # which prefers the other branch (where MIN would pick 3);
        # i.e. after the 2, it can only get worse for MAX (< 2), but not
        # better, since MIN won't pick any values > 2
        fail
      ]
    ]

  it 'should prune unnecessary searches', ->
    [utility, action] = agent.minimax root MAX
    action.should.equal 0
    utility.should.equal 3

describe 'minimax depth limited search', ->

  agent = new MinimaxAgent 1 # search to depth of 1 ply

  # plies start at zero and change at MAX's turns
  root =
    node 1, [         # (MAX) ply = 0
      node 2, [       # (MIN)
        node 3, [     # (MAX) ply = 1 <===== desired depth
          node 4, [   # (MIN)
            node 5    # (MAX) ply = 2
          ]
        ]
      ]
    ]

  it 'should stop at the desired depth', ->
    [utility, action] = agent.minimax root MAX
    utility.should.equal 3
