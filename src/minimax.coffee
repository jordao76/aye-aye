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

minimax = (state, α = -Infinity, β = +Infinity) ->
  if state.isTerminal()
    [state.utility(), null]
  else if state.nextAgent() is MAX
    maxi state, α, β
  else
    mini state, α, β

maxi = (state, α, β) ->
  [v, a] = [-Infinity, null]
  for action in state.possibleActions()
    successor = state.play(action)
    [nextValue, _] = minimax successor, α, β
    if nextValue > v
      [v, a] = [nextValue, action]
    return [v, a] if v >= β
    α = Math.max α, v
  [v, a]

mini = (state, α, β) ->
  [v, a] = [+Infinity, null]
  for action in state.possibleActions()
    successor = state.play(action)
    [nextValue, _] = minimax successor, α, β
    if nextValue < v
      [v, a] = [nextValue, action]
    return [v, a] if v <= α
    β = Math.min β, v
  [v, a]

module.exports = MAX: MAX, MIN: MIN, playTurn: playTurn
