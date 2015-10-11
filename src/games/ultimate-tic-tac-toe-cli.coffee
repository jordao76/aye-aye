# coffeelint: disable=max_line_length

chalk = require 'chalk'
{_, X, O, decode} = require './bin-tic-tac-toe'
{UltimateTicTacToe} = require './ultimate-tic-tac-toe'

# last played position as a tuple [i,j]
# i is the board index
# j is the position index within the board
UltimateTicTacToe.position = null

UltimateTicTacToe::toString = ->
  t = chalk.yellow  '╔═══════════╦═══════════╦═══════════╗'
  v = chalk.yellow  '┃'
  vv = chalk.yellow '║'
  h = chalk.yellow  '║ ━   ━   ━ ║ ━   ━   ━ ║ ━   ━   ━ ║'
  hh = chalk.yellow '╠═══════════╬═══════════╬═══════════╣'
  b = chalk.yellow  '╚═══════════╩═══════════╩═══════════╝'
  l = (s) -> chalk.dim s
  p = (i, j) =>
    wins = @winOn i
    if (@at i, j) is _
      ' '
    else if UltimateTicTacToe.position[0] is i and UltimateTicTacToe.position[1] is j
      chalk.red.bold decode (@at i, j)
    else if j in wins
      chalk.cyan.bold decode (@at i, j)
    else
      chalk.bold decode (@at i, j)
  """         #{l 1}   #{l 2}   #{l 3}   #{l 4}   #{l 5}   #{l 6}   #{l 7}   #{l 8}   #{l 9}
       #{t}
      #{l 'A'}#{vv} #{p 0,0} #{v} #{p 0,1} #{v} #{p 0,2} #{vv} #{p 1,0} #{v} #{p 1,1} #{v} #{p 1,2} #{vv} #{p 2,0} #{v} #{p 2,1} #{v} #{p 2,2} #{vv}
       #{h}
      #{l 'B'}#{vv} #{p 0,3} #{v} #{p 0,4} #{v} #{p 0,5} #{vv} #{p 1,3} #{v} #{p 1,4} #{v} #{p 1,5} #{vv} #{p 2,3} #{v} #{p 2,4} #{v} #{p 2,5} #{vv}
       #{h}
      #{l 'C'}#{vv} #{p 0,6} #{v} #{p 0,7} #{v} #{p 0,8} #{vv} #{p 1,6} #{v} #{p 1,7} #{v} #{p 1,8} #{vv} #{p 2,6} #{v} #{p 2,7} #{v} #{p 2,8} #{vv}
       #{hh}
      #{l 'D'}#{vv} #{p 3,0} #{v} #{p 3,1} #{v} #{p 3,2} #{vv} #{p 4,0} #{v} #{p 4,1} #{v} #{p 4,2} #{vv} #{p 5,0} #{v} #{p 5,1} #{v} #{p 5,2} #{vv}
       #{h}
      #{l 'E'}#{vv} #{p 3,3} #{v} #{p 3,4} #{v} #{p 3,5} #{vv} #{p 4,3} #{v} #{p 4,4} #{v} #{p 4,5} #{vv} #{p 5,3} #{v} #{p 5,4} #{v} #{p 5,5} #{vv}
       #{h}
      #{l 'F'}#{vv} #{p 3,6} #{v} #{p 3,7} #{v} #{p 3,8} #{vv} #{p 4,6} #{v} #{p 4,7} #{v} #{p 4,8} #{vv} #{p 5,6} #{v} #{p 5,7} #{v} #{p 5,8} #{vv}
       #{hh}
      #{l 'G'}#{vv} #{p 6,0} #{v} #{p 6,1} #{v} #{p 6,2} #{vv} #{p 7,0} #{v} #{p 7,1} #{v} #{p 7,2} #{vv} #{p 8,0} #{v} #{p 8,1} #{v} #{p 8,2} #{vv}
       #{h}
      #{l 'H'}#{vv} #{p 6,3} #{v} #{p 6,4} #{v} #{p 6,5} #{vv} #{p 7,3} #{v} #{p 7,4} #{v} #{p 7,5} #{vv} #{p 8,3} #{v} #{p 8,4} #{v} #{p 8,5} #{vv}
       #{h}
      #{l 'I'}#{vv} #{p 6,6} #{v} #{p 6,7} #{v} #{p 6,8} #{vv} #{p 7,6} #{v} #{p 7,7} #{v} #{p 7,8} #{vv} #{p 8,6} #{v} #{p 8,7} #{v} #{p 8,8} #{vv}
       #{b}
     """

UltimateTicTacToe::coordinateMap =
  A1:[0,0],A2:[0,1],A3:[0,2],A4:[1,0],A5:[1,1],A6:[1,2],A7:[2,0],A8:[2,1],A9:[2,2]
  B1:[0,3],B2:[0,4],B3:[0,5],B4:[1,3],B5:[1,4],B6:[1,5],B7:[2,3],B8:[2,4],B9:[2,5]
  C1:[0,6],C2:[0,7],C3:[0,8],C4:[1,6],C5:[1,7],C6:[1,8],C7:[2,6],C8:[2,7],C9:[2,8]
  D1:[3,0],D2:[3,1],D3:[3,2],D4:[4,0],D5:[4,1],D6:[4,2],D7:[5,0],D8:[5,1],D9:[5,2]
  E1:[3,3],E2:[3,4],E3:[3,5],E4:[4,3],E5:[4,4],E6:[4,5],E7:[5,3],E8:[5,4],E9:[5,5]
  F1:[3,6],F2:[3,7],F3:[3,8],F4:[4,6],F5:[4,7],F6:[4,8],F7:[5,6],F8:[5,7],F9:[5,8]
  G1:[6,0],G2:[6,1],G3:[6,2],G4:[7,0],G5:[7,1],G6:[7,2],G7:[8,0],G8:[8,1],G9:[8,2]
  H1:[6,3],H2:[6,4],H3:[6,5],H4:[7,3],H5:[7,4],H6:[7,5],H7:[8,3],H8:[8,4],H9:[8,5]
  I1:[6,6],I2:[6,7],I3:[6,8],I4:[7,6],I5:[7,7],I6:[7,8],I7:[8,6],I8:[8,7],I9:[8,8]
UltimateTicTacToe::parseAction = (text) -> @coordinateMap[text.toUpperCase()]
UltimateTicTacToe::isValidAction = (action) ->
  return no unless action?
  [x,y] = action
  for [i,j] in @possibleActions()
    return yes if x is i and y is j
  no

module.exports = {_, X, O, decode, UltimateTicTacToe}
