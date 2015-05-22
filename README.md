##Learning Tic-Tac-Toe

Tonight's SDRuby Magic Night challenge is to implement an AI for playing Tic-Tac-Toe, with a catch: You're not allowed to embed any knowledge of the game into your creation beyond how to make legal moves and recognizing that it has won or lost.

Your program is expected to "learn" from the games it plays, until it masters the game and can play flawlessly.

Submissions can have any interface, but should be able to play against humans interactively. However, I also suggest making it easy to play against another AI, so you can "teach" the program faster.

Being able to monitor the learning progression and know when a program has mastered the game would be very interesting, if you can manage it.

Adapted from Ruby Quiz #11, please don't look at the answers or outside
discussion.


 1 | 2 | 3  
---+---+---
 4 | 5 | 6
---+---+---
 7 | 8 | 9

Board will be represented by a Board class and ultimately an array [0..8]

An array of winning moves can be used to check moves against the board to determine if anyone has one.

players play the game so have a Player class from which we derive HumanPlayer and ComputerPlayer

Have Game object that tracks the game, turns, moves as well as prompts for player's turn
