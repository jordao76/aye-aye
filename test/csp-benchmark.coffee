# coffeelint: disable=max_line_length

(require 'chai').should()
Benchmark = require 'benchmark'
{ConstraintSolver} = require '../src/csp'
{AustraliaCSP} = require './csp-test'

describe 'CSP benchmarks', ->
  @timeout 60*1000
  new Benchmark.Suite()
    .add 'Australia map coloring', -> new ConstraintSolver(AustraliaCSP).solve()
    .on 'cycle', (e) -> it e.target, ->
    .run async: false
