{EventEmitter} = require 'events'
{playTurn} = require './minimax'

module.exports =
class Solver extends EventEmitter
  pause: ->
    @paused = yes
    @
  resume: ->
    @paused = no
    @play()
  solve: (initialState) ->
    @state = initialState
    @started = no
    @play()
  play: ->
    if !@paused
      if !@started
        @started = yes
        @emit 'start', @state
        return if @paused
      if @state.isTerminal()
        @emit 'end', @state
      else
        @state = playTurn @state
        @emit 'progress', @state
        @play()
    @
