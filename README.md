# harbour-pipes

Puzzle game: rotate pipes to connect all the pieces together.

Inspired by excellent timeless classics like [PipesJ2ME] and [KNetWalk];
most QML code is taken from [harbour-picross].  Make sure to try them all of course!

[PipesJ2ME]: https://www.michaelkerley.net/wp/pipes-j2me/
[KNetWalk]: https://apps.kde.org/pl/knetwalk/
[harbour-picross]: https://github.com/direc85/harbour-picross

## FAQ

### How to play?

Click on the pipes to rotate them.
Zoom in and out with the standard zoom gesture and drag the board around to find your pipes.

### The game is getting really slow.  How to fix it?

You need to reduce the grid size.  Many pipes = much computation.
The game is not optimal (yet!), so whenever you click on a pipe
or do any scrolling, it must recalculate and redraw everything.
If you want to keep playing large puzzles, either have patience, or... suggest improvements!

### I love this game!

Thank you!  I really appreciate all kinds of feedback.
The one I like the most is sharing my creations with others,
and a bit of funding to help me work on projects like this in my free time.
It took me a month to write this game (mainly while being bored on a bus without headphones sometimes), and another one to release it.

### Does every level have a solution?

Yes, it does.  Even that hard one you are currently struggling with. 😄
This is because first a random solved puzzle is generated, and then scrabmled around.  A geeky explanation follows below.

### I don't believe you! (aka. help me, I'm stuck!)

/!\ _Spoiler alert: this section might ruin some fun, as it suggests strategies for solving the puzzle.  Many consider learning them yourself as part of the game.  My good advice: play the game first!_

.

.

<details>
The pipes form a [tree] on a grid.  No connection needs to be left hanging (think: the pipes cannot be leaky), all the pipes must be connected together (think: the fluid must be able to get everywhere), there is only one way for the fluid to reach every terminal pipe (think: every pipe is one-way, no cycles/circles).

One good way to solve the puzzle is starting with connections that are sure (pipes next to pluses and pipes next to board edges).  Then you can match pipe ends to pipe ends, and air gaps to air gaps (of pipes that you are sure are correct).

[tree]: https://en.wikipedia.org/wiki/Tree_(graph_theory)
</details>
