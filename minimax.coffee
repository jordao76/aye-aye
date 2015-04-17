# MINIMAX

# Agent :: @enum(MIN, MAX)

# MAX :: Agent
# MIN :: Agent
[MAX, MIN] = ['MAX', 'MIN']

# Action :: Any

# State :: {
#   isTerminal : -> Bool
#   nextAgent : -> Agent
#   utility : -> Num
#   possibleActions : -> [Action]
#   play : Action -> State
# }

# playTurn :: (state:State) -> State
playTurn = (state) ->
  return null if state.isTerminal()
  [_, bestAction] = minimax state
  return state.play(bestAction)

minimax = (state, alpha = -Infinity, beta = +Infinity) ->
  return [state.utility(), null] if state.isTerminal()
  return maxi state, alpha, beta if state.nextAgent() is MAX
  return mini state, alpha, beta #  state.nextAgent() is MIN

maxi = (state, alpha, beta) ->
  [bestValue, bestAction] = [-Infinity, null]
  for action in state.possibleActions()
    successor = state.play(action)
    [nextValue, _] = minimax successor, alpha, beta
    if nextValue > bestValue
      bestValue = nextValue
      bestAction = successor
    return [bestValue, bestAction] if bestValue >= beta
    alpha = Math.max alpha, bestValue
  return [bestValue, bestAction]

mini = (state, alpha, beta) ->
  [bestValue, bestAction] = [+Infinity, null]
  for action in state.possibleActions()
    successor = state.play(action)
    [nextValue, _] = minimax successor, alpha, beta
    if nextValue < bestValue
      bestValue = nextValue
      bestAction = successor
    return [bestValue, bestAction] if bestValue <= alpha
    beta = Math.min beta, bestValue
  return [bestValue, bestAction]

module.exports = MAX: MAX, MIN: MIN, playTurn: playTurn
