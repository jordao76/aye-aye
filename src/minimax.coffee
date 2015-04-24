# MINIMAX

# Agent :: @enum(MIN, MAX)

# MAX :: Agent
# MIN :: Agent
[MAX, MIN] = ['MAX', 'MIN']

# Agent :: {
#   getAction :: (State) -> Action
# }

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
  minimax = new MinimaxAgent
  state.play minimax.getAction state

utility = (state) -> state.utility()

class MinimaxAgent
  constructor: (@evaluate = utility, @depth = Infinity) ->

  # getAction :: (state:State) -> Action
  getAction: (state) ->
    return null if state.isTerminal()
    [_, bestAction] = @minimax state
    bestAction

  minimax: (state, ply = 0, α = -Infinity, β = +Infinity) ->
    if state.nextAgent() is MAX
      ++ply
    if ply > @depth or state.isTerminal()
      [@evaluate state, null]
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

module.exports = MAX: MAX, MIN: MIN, playTurn: playTurn
