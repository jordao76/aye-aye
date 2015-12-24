# coffeelint: disable=max_line_length

(require 'chai').should()
{ConstraintSolver} = require '../src/csp'

describe 'CSP solver', ->

  it 'should solve a map coloring problem with 2 regions and 2 colors', ->

    region1 = '1'
    region2 = '2'
    regions = [region1, region2] # variables
    colors = ['red', 'blue'] # domain
    disjointConstraint = # the regions shall not be painted by the same color
      variables: [region1, region2]
      relation: (region1Color, region2Color) -> region1Color isnt region2Color

    csp =
      variables: regions
      domain: colors
      constraints: [disjointConstraint]

    new ConstraintSolver(csp).solve().should.deep.equal
      "#{region1}": 'red'
      "#{region2}": 'blue'
