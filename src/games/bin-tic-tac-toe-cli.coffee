chalk = require 'chalk'
{_, X, O, decode, discountedUtility, BinTicTacToe} = require './bin-tic-tac-toe'

BinTicTacToe.position = null # last played position

BinTicTacToe::utility = () -> discountedUtility @value, @depth

BinTicTacToe::toString = ->
  t = chalk.yellow '┏━━━┳━━━┳━━━┓'
  v = chalk.yellow '┃'
  h = chalk.yellow '┣━━━╋━━━╋━━━┫'
  b = chalk.yellow '┗━━━┻━━━┻━━━┛'
  l = (s) -> chalk.dim s
  wins = @winOn()
  p = (i) =>
    if (@at i) is _
      ' '
    else if BinTicTacToe.position is i
      chalk.red.bold decode @at i
    else if i in wins
      chalk.cyan.bold decode @at i
    else
      chalk.bold decode @at i
  """         #{l 1}   #{l 2}   #{l 3}
       #{t}
      #{l 'A'}#{v} #{p 0} #{v} #{p 1} #{v} #{p 2} #{v}
       #{h}
      #{l 'B'}#{v} #{p 3} #{v} #{p 4} #{v} #{p 5} #{v}
       #{h}
      #{l 'C'}#{v} #{p 6} #{v} #{p 7} #{v} #{p 8} #{v}
       #{b}"""

BinTicTacToe::coordinateMap = ['A1','A2','A3'
                               'B1','B2','B3'
                               'C1','C2','C3']

BinTicTacToe::parseAction = (text) -> @coordinateMap.indexOf text.toUpperCase()

BinTicTacToe::isValidAction = (action) -> action in @openPositions()

module.exports = {_, X, O, decode, BinTicTacToe}
