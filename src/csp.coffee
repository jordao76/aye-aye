# coffeelint: disable=max_line_length

class ConstraintSolver

  # Constraint :: { # constraint on a set of variables
  #   variables : [String]@length n
  #   relation : (var1, ...)@arity n -> Bool
  # }
  # csp :: { # constraint satisfaction problem
  #   variables : [String]@length n # set of variables
  #   domains : [[Value]]@length n # Value :: primitive value like String, Number or Boolean
  #   constraints : [Constraint]
  # }
  constructor: (@csp) ->

  solve: -> @search {}

  search: (assignment) ->
    return assignment if @isComplete assignment
    variable = @selectUnassignedVariable assignment
    for value in @domainValues variable, assignment
      if @assignIfConsistent variable, value, assignment
        result = @search assignment
        return result if result?
        delete assignment[variable]
    null

  isComplete: (assignment) ->
    # all variables are assigned
    Object.keys(assignment).length is @csp.variables.length

  assignIfConsistent: (variable, value, assignment) ->
    assignment[variable] = value
    unless @isConsistent assignment
      delete assignment[variable]
      return no
    yes

  isConsistent: (assignment) ->
    for constraint in @csp.constraints
      values = []
      for variable in constraint.variables
        if assignment[variable]?
          values.push assignment[variable]
        else
          break
      if values.length is constraint.variables.length
        unless constraint.relation values...
          return no
    yes

  selectUnassignedVariable: (assignment) ->
    assigned = Object.keys(assignment)
    all = @csp.variables
    for variable in all
      return variable unless variable in assigned

  domainValues: (variable, assignment) ->
    @csp.domains[@csp.variables.indexOf variable]

module.exports = {ConstraintSolver}
