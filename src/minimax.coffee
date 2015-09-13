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

class MinimaxAgent
  constructor: (@depth = Infinity) ->

  # nextAction :: (state:State) -> Action
  nextAction: (state) ->
    return null if state.isTerminal()
    [_, bestAction] = @minimax state
    bestAction

  minimax: (state, ply = 0, α = -Infinity, β = +Infinity) ->
    ++ply if state.nextAgent() is MAX
    if ply > @depth or state.isTerminal()
      [state.utility(), null]
    else if state.nextAgent() is MAX
      @maxi state, ply, α, β
    else
      @mini state, ply, α, β

  maxi: (state, ply, α, β) ->
    [v, a] = [-Infinity, null]
    for action in state.possibleActions()
      successor = state.play(action)
      [nextValue, _] = @minimax successor, ply, α, β
      if nextValue > v
        [v, a] = [nextValue, action]
      return [v, a] if v >= β
      α = Math.max α, v
    [v, a]

  mini: (state, ply, α, β) ->
    [v, a] = [+Infinity, null]
    for action in state.possibleActions()
      successor = state.play(action)
      [nextValue, _] = @minimax successor, ply, α, β
      if nextValue < v
        [v, a] = [nextValue, action]
      return [v, a] if v <= α
      β = Math.min β, v
    [v, a]

module.exports = MAX: MAX, MIN: MIN, MinimaxAgent: MinimaxAgent
