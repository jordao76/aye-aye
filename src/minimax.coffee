# MINIMAX

[MAX, MIN] = ['MAX', 'MIN']

# Action :: Any

# State :: {
#   isTerminal : -> Bool
#   nextAgent : -> MAX|MIN
#   utility : -> Num
#   possibleActions : -> [Action]
#   play : Action -> State
# }

class MinimaxAgent
  constructor: (@depth = Infinity) ->
    @rootAgent = MAX

  # nextAction :: (state:State) -> Action
  nextAction: (state) ->
    @rootAgent = state.nextAgent()
    [_, bestAction] = @minimax state
    bestAction

  minimax: (state, α = -Infinity, β = +Infinity, ply = 0) ->
    isTerminal = state.isTerminal()
    ++ply if not isTerminal and state.nextAgent() is @rootAgent
    if ply > @depth or isTerminal
      [state.utility(), null]
    else if state.nextAgent() is MAX
      @maxi state, α, β, ply
    else
      @mini state, α, β, ply

  maxi: (state, α, β, ply) ->
    [v, a] = [-Infinity, null]
    for action in state.possibleActions()
      successor = state.play action
      [nextValue, _] = @minimax successor, α, β, ply
      if nextValue > v
        [v, a] = [nextValue, action]
      return [v, a] if v >= β
      α = Math.max α, v
    [v, a]

  mini: (state, α, β, ply) ->
    [v, a] = [+Infinity, null]
    for action in state.possibleActions()
      successor = state.play action
      [nextValue, _] = @minimax successor, α, β, ply
      if nextValue < v
        [v, a] = [nextValue, action]
      return [v, a] if v <= α
      β = Math.min β, v
    [v, a]

module.exports = { MAX, MIN, MinimaxAgent }
