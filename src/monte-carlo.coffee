# coffeelint: disable=max_line_length

{P1, P2} = require './game'

choose = (a) -> a[Math.floor(Math.random()*a.length)]
argmax = (xs, testF) ->
  max = Number.MIN_SAFE_INTEGER
  for x in xs
    curr = testF x
    if curr > max
      max = curr
      val = x
  val

class Tree
  constructor: (@data = {}) ->
  observe: (node) -> @data[node] ?= [0,0] # (visits::Int,results::Int)
  observed: (node) -> @data[node]?
  addResult: (node, result) ->
    stats = @data[node]
    stats[0] += 1 # increase the visit count
    stats[1] += result # add the result
  value: (node) ->
    # average of the results of all simulated games on node
    stats = @data[node]
    stats[1] / stats[0]
  visitCount: (node) -> @data[node][0]

# Action :: Any

# State :: {
#   isTerminal : -> Bool
#   winner: -> P1|P2|null
#   nextPlayer : P1|P2
#   possibleActions : -> [Action]
#   play : Action -> State
# }

class MonteCarloAgent

  # options :: {
  #   timeFrameMs? : Int [=5000]
  #   tree? : Tree [=new Tree]
  # }
  constructor: (options = {}) ->
    @timeFrameMs = options.timeFrameMs ? 5000
    @tree = options.tree ? new Tree

  # nextAction :: (state:State) -> Action
  nextAction: (state) -> # state is the root node for the monte carlo tree search

    @tree.observe state # make sure state is in the tree

    begin = Date.now()
    while Date.now() - begin < @timeFrameMs # while has time
      game = [] # the current game being played, a path through the search tree
      node = state # the game starts at the root

      while node? and @tree.observed node # while the current node is in the search tree
        game.push lastNode = node
        node = @select node
      node = lastNode # last node added to the game is the leaf

      before = node
      node = @expand node, game unless node.isTerminal() # expand from the leaf node if it's not a terminal node
      result = @simulate node
      for node in game
        # backpropagate the result
        @tree.addResult node, result

    # final move selection
    mul = if state.nextPlayer is P1 then +1 else -1
    successors = ([action, state.play action] for action in state.possibleActions())
    # max child: the child that has the highest value
    [bestAction, _] = argmax successors, ([action, nextState]) =>
      if @tree.observed nextState
        mul * @tree.value nextState
      else
        Number.MIN_SAFE_INTEGER # un-observed node is not considered
    bestAction

  select: (node) ->
    return null if node.isTerminal()
    T = 30 # visit count threshold for UCT
    nodeVisits = @tree.visitCount node
    if nodeVisits >= T
      @uct node, nodeVisits
    else
      # select next node based on the simulation strategy
      @play node

  # UCT - Upper Confidence Bound applied to Trees
  uct: (node, nodeVisits) ->
    C = 0.7 # coefficient that needs to be tuned experimentally (!)
    successors = (node.play action for action in node.possibleActions())
    nodeLog = Math.log nodeVisits
    argmax successors, (succNode) =>
      @tree.observe succNode
      @tree.value(succNode) + C * Math.sqrt(nodeLog / (@tree.visitCount(succNode) or 1e-6))

  expand: (node, game) ->
    # expand one node
    actions = node.possibleActions()
    # expand the first child that is not stored in the tree yet
    for action in actions
      successor = node.play action
      unless @tree.observed successor
        @tree.observe successor
        game.push successor
        return successor
    # default: if all children are stored in the tree,
    # select the next based on the simulation strategy
    @play node

  simulate: (node) ->
    until node.isTerminal()
      node = @play node
    winner = node.winner()
    switch winner
      when P1 then +1
      when P2 then -1
      else 0

  play: (node) ->
    # random strategy
    node.play choose node.possibleActions()

module.exports = { P1, P2, MonteCarloAgent, Tree }
