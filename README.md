# Aye-aye [![npm](https://img.shields.io/npm/v/aye-aye.svg)](https://www.npmjs.com/package/aye-aye)

[![Build Status](https://travis-ci.org/jordao76/aye-aye.svg)](https://travis-ci.org/jordao76/aye-aye)
[![Dependency Status](https://david-dm.org/jordao76/aye-aye.svg)](https://david-dm.org/jordao76/aye-aye)
[![devDependency Status](https://david-dm.org/jordao76/aye-aye/dev-status.svg)](https://david-dm.org/jordao76/aye-aye#info=devDependencies)
[![Codacy Badge](https://api.codacy.com/project/badge/grade/a970fdf8aed14f5fb1c84f5525b886ca)](https://www.codacy.com/app/rodrigo-jordao/aye-aye)
[![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/jordao76/aye-aye/blob/master/LICENSE.txt)

Simple AI code. Minimax with some tic tac toe...

![aye-aye](http://upload.wikimedia.org/wikipedia/commons/6/6e/Aye-aye.png)

Nothing to do with that lemur...

Check out [ultimate-tic-tac-toe](https://github.com/jordao76/ultimate-tic-tac-toe) and [tic-tac-toe-cli](https://github.com/jordao76/tic-tac-toe-cli).

## Intro

To use aye-aye in a [node.js](https://nodejs.org/en/) project:

```
$ npm install --save aye-aye
```

## Minimax

Aye-aye's [minimax](https://en.wikipedia.org/wiki/Minimax) is a textbook implementation that uses [alpha-beta pruning](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning) and can also be restricted by depth.

```javascript
var minimax = require('aye-aye');
var MAX = minimax.MAX, MIN = minimax.MIN;
var depth = 4;
var agent = new minimax.MinimaxAgent(depth);
```

You'll need a `State` that "implements" the following interface:

```
Action :: Any
State :: {
  isTerminal : () -> Bool
  nextAgent : () -> MAX|MIN
  utility : () -> Num
  possibleActions : () -> [Action]
  play : (Action) -> State
}
```

You can think of a `State` instance as a node in the game tree, where:

- `isTerminal` returns if a state is an end state.
- `nextAgent` returns whether it's MAX's or MIN's turn to play.
- `utility` returns the "value" of the state. For terminal states, this should be its final value; for non-terminal states this should be an estimate of its final value. Values that favor MAX should be greater than values that favor MIN, since MAX will try to maximize those values, whereas MIN will try to minimize them.
- `possibleActions` returns an array of the valid actions that can be taken from the current state using the next agent.
- `play` executes an action and returns the new state after that action.

And then you can run minimax to find out the next action to take:

```javascript
var initialState = ...
var actionToTake = agent.nextAction(initialState);
```

Note that depending on your `State` implementation and the depth of the search, this could take a very long time.

## License

Licensed under the [MIT license](https://github.com/jordao76/aye-aye/blob/master/LICENSE.txt).
