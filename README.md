# LISP Defenders

It's raining LISP S-Expressions!

When the S-Expressions hit the ground, they get evaluated. Depending on
the result of the S-Expression, you could get points, or lose.

If the S-Expression evaluates to a single emoji, the effect is:

- `🍩`- +10 points
- `🍰` - +15 points
- `🍕` - +15 points
- `🌯` - +25 points
- `🍣` - +45 points
- `💣` - Lose the game

If the S-Expression evaluates to a list of values, the effect is all the
effects of the elements combined. So `(' 🍩 🍩 💣)` would give you 20
points, then make you immediately lose.

The S-Expressions follow their own language of LISP.  `(' x y z)`
is a list containing x, y, and z (like `(list x y z)` in Scheme), and
`(* n x)` evaluates to a list containing `x` repeated `n` times.
`(> x y)`, where `x` and `y` are food emojis, is true if `x` has more
points than `y`. So e.g. `(> 🍕 🍰)` is true, but `( >🍕 🌯)` is false.
All food emojis are greater than the bomb emoji.

Fortunately, you can alter the S-Expressions, by shooting emojis at
them from your cannon. When an emoji hits one in the S-Expression, it
replaces it.

Project for HackDartmouth 2018.
