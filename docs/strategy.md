# Strategy for playing Quadblockquiz

Quadblockquiz is a tetrominoes-like game
that is part tetrominoes and part question/answer quiz.
The question/answer less about what you already know,
and is more about educating on
supply chain cybersecurity. 

## 1. Getting started
The purpose of the game is to learn more about 
supply chain cybersecurity in a fun way.
See [How to Play](./HowToPlay.md) to get started.
See [Question and Answer](./topics.md) for how the questions are organized.
See [Power Ups](./powerups.md) on the powerups.

This page is background on how the game works 
ie things you should take into account when developing your strategy.

## 2. Time
There is a game clock. 
The game will terminate at 10 minutes if you haven't terminated it sooner.
Note the game clock runs regardless of whether you are paused.
The game clock is more obvious in the quadblocks section of the game,
but note it is still present even if you can't see it in Q&A.

Most people will want to use as much of the game clock as they can.
I.e. the longer you play, the more points you will get.
In general this is true, but several things can impact.
Cyber attacks and Licence Lawsuits are more likely the longer you play,
so watch your vuln and issue counts.
And it 'should' record your point total correctly if you timeout, but there
have been issues with recording your point total correctly if you lose your network connection (so you might not get credit for having played).

There are some large bonus point potentials mentioned in subsequent sections.
There is a tendency to try to get the highest "multipliers" before cashing in.
But don't wait too long because the might game time out.

## 3. Falling Blocks
Like other tretromino games, you accumulate points with each tick of the clock on falling blocks. There are different speeds which you control with speed-up and slow-down powerups. Besides just occuring faster, you get bonus points for the higher tick speeds. And you get points for clearing rows - see section XX.

## 4. Vulnerabilities
Vulnerabilities occur after a certain amount of technical debt occurs,
as shown by one of the counters on the screen. 
They also occur randomly on falling blocks and when questions are answered wrong.

A row can not be cleared if it has a vulnerability in it.
A cyber attack occurs when there are 5 vulnerabilities on the board.

If all you did was play falling blocks, eventually you would be cyberattacked, lost most of your points, and the game would be over.

To counter vulnerabilties, you must use powerups which you get by answering questions.
Powerups of particular use are:
- delete block,
- fix vulnerability,
- remove all vulnerabilities, and
- clear blocks.

## 5. Cyber Attack
A cyber attack is bad, and you should attempt to avoid.
A cyber attack occurs when there are 5 vulnerabilities on the board.
When a cyber attack occurs, 
the clock speeds up to very fast (ie you have little time to respond),
extra blocks are added causing the board to fill up,
and points hemorage away.
This emulates the hackers operating at machine speed,
and you losing lots of money.

If you haven't been able to prevent the attack,
then hit the space bar as soon as the attack occurs.

If you don't have the appropriate powerups, you can attempt to get them
from answering questions (but note the game will continue even when paused),
or you can cut your losses and quit the game with your current score.

The powerups that might be useful in a cyberattack are:
- delete block,
- fix vulnerability,
- remove all vulnerabilities,
- clear blocks, and
- slow down

## 6. Licensing Issues
Licensing issues occur after a certain amount of technical debt occurs,
as shown by one of the counters on the screen. 

A row can not be cleared if it has a licensing issues in it.
A licensing lawsuit occurs when there are 5 licensing issues on the board.

If all you did was play falling blocks, eventually you would be sued, lost most of your points, and the game would be over.

To counter licensing issues, you must use powerups which you get by answering questions.
Powerups of particular use are:
- delete block,
- fix licensing issue,
- remove all licensing issues, and
- clear blocks.

## 7. License Lawsuits
A license lawsuit is bad, and you should attempt to avoid.
A license lawsuit occurs when there are 5 licensing issues on the board.
When a license lawsuit occurs, 
the clock slows to extremely slow,
extra blocks are added causing the board to fill up,
and points hemorage away.
This emulates the courts and lawyers costiing you lots of money,
and tieing up your business.

If you haven't been able to prevent the lawsuit,
then hit the space bar as soon as it occurs.

If you don't have the appropriate powerups, you can attempt to get them
from answering questions (but note the game will continue even when paused),
or you can cut your losses and quit the game with your current score.

The powerups that might be useful in a lawsuit are:
- delete block,
- fix license issue,
- remove all licensing issues,
- clear blocks, and
- speed up


## 8. Q&A Point Multipliers
Answering questions correctly gets you points.
There is a multiplier on the points for each question,
that increases if you have played more blocks in the 
falling blocks part of the game.

For example, if you hit the space bar before the first block
falls to the brickyard, the first question in OStart would be
worth 25 points for a correct answer.

But if you let first brick touch the brickyard before answering
that same question, it would be worth 50 points because it has a multiplier of "2". 

The multipliers are:
- 1 for zero blocks
- 2 for 1-9 blocks
- 3 for 10-19 blocks
- 5 for 20-49 blocks
- 7 for 50-99 blocks
- 11 for over 100 blocks

Note points increase as you do more questions in a category.
But they aren't the same in all categories.
There are a few really hight point questions sprinkled randomly throughout.
In the ideal play you would answer a high point question after 
having a large multiplier.

## 9. Clearing Multiple Rows at once
It is possible to clear multiple rows at once.
This is because row cleaing is only computed when a falling block falls
into the brickyard.
Therefore you can use powerups to move blocks, fix vulns, add blocks, etc
while the game is "paused" and multiple rows will clear when the next
falling block touches the brickyard.

There are bonus points for clearing multiple rows at once - and they go up exponentially. Ignoring multipliers (see next section), the points for clearing rows are:
- 1 row = 200 points
- 2 rows = 400 points
- 3 rows = 800 points
- 4 rows = 1,600 points
- 5 rows = 3,200 points
- etc

## 10. Row Clearing Muliplier
As the previous section showed, clearing rows gets you points.
There is an additional multiplier on clearing rows that rewards you
for having answered questions correctly. The multipliers are:
- 1 for no correct answers
- 2 for 2-9 correct answers
- 3 for 10-49 correct answers
- 5 for 50-99 correct answers
- 7 for 100-299 correct answers
- 11 for >300 correct answers

Note those higher multipliers are impossible in 10 min, 
plus there aren't that many questions.
But answering 10 questions is reasonable 
and it turns the points for 5 rows 
from 3,200 points to 9,600 points.

