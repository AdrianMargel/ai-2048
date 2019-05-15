# AI 2048
A recreation of the game 2048 with AI

![2048 board](https://i.imgur.com/KprsooS.png)

This is a recreated version of the poplular game 2048 with an artificial intelligence to play it automatically. The AI is actually combination of a Monte Carlo tree search(MCTS) and a heuristic AI. The program is also able to support any size of rectangle for the game size.

The AI works by using a set of greedy testers that look one move into the future and pick the move that will yeild the best score based on a set of heuristics. These testers will continue playing until either they reach a game over or they reach the "sight" limit for the number of moves tested. The main AI will then add up the scores of all the testers that did not reach a game over and choose the next move that resulted in the highest total score.

The approach described above allows for heuristic scoring technics to be combined with MCTS. In my testing I found this to be quite effective. It also has the advantage that the intelligence can be scaled simply by increasing the number of testers and or the number of moves that are tested up to. This of course will also decrease the speed it runs at though.

I also in testing found that the heuristic scoring of the testers must be the same as the main AI. When I attempted to have them using different heuristics for their scoring it would lead to occational self-sabotage. The main AI would sometimes make moves to intentionally destroy the testers scores in order to force the testers into making moves that would benefit the main AI's scoring even though this results in lower scores for both of them in the long term.

The code was written summer 2018

## more images:
![large 2048](https://i.imgur.com/FUlIYWX.png)
![huge 2048](https://i.imgur.com/rdyHMt6.png)
