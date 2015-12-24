# coffeelint: disable=max_line_length

(require 'chai').should()
{ConstraintSolver} = require '../src/csp'

[WA, NT, Q, NSW, V, SA] = ['WA', 'NT', 'Q', 'NSW', 'V', 'SA']
colors = ['red', 'green', 'blue']
disjointRelation = (c1, c2) -> c1 isnt c2
constraints = [
  { variables: [WA, NT], relation: disjointRelation }
  { variables: [WA, SA], relation: disjointRelation }
  { variables: [NT, Q], relation: disjointRelation }
  { variables: [SA, Q], relation: disjointRelation }
  { variables: [Q, NSW], relation: disjointRelation }
  { variables: [SA, NSW], relation: disjointRelation }
  { variables: [SA, V], relation: disjointRelation }
  { variables: [NSW, V], relation: disjointRelation }
]
csp =
  variables: [WA, NT, Q, NSW, V, SA]
  domains: colors for i in [0...6] # same domain for all variables
  constraints: constraints

describe 'CSP solver', ->

  it 'should solve Australia\'s map coloring problem', ->

    solution = new ConstraintSolver(csp).solve()
    # check that all variables were assigned a color
    for variable in [WA, NT, Q, NSW, V, SA]
      colors.should.include solution[variable]
    # check the constraints
    solution[WA].should.not.equal solution[NT]
    solution[WA].should.not.equal solution[SA]
    solution[NT].should.not.equal solution[Q]
    solution[SA].should.not.equal solution[Q]
    solution[Q].should.not.equal solution[NSW]
    solution[SA].should.not.equal solution[NSW]
    solution[SA].should.not.equal solution[V]
    solution[NSW].should.not.equal solution[V]

module.exports = {AustraliaCSP: csp}
