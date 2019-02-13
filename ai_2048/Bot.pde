class Bot{
  //the subbots that will be tested
  ArrayList<SubBot> testers;
  //how many moves in advance are tested
  int sight;
  
  //setup bot with the number of testers it will run and how many moves those testers will be tested to
  Bot(int tests,int sight){
    testers=new ArrayList<SubBot>(); 
    this.sight=sight;
    for(int i=0;i<tests;i++){
      testers.add(new SubBot());
    }
  }
  
  //run the AI
  void runBot(int[][] ts){
    
    //the moves available to make
    int[] moves=new int[4];
    //the number of available names
    int available=1;
    
    //the top score (set it to have a negative value to start with so it'll always be the worst)
    Score topScore=new Score();
    topScore.scores[0]=-1;
    
    for(int i=0;i<4;i++){
      //if the move can be made
      if(canMove(i+1,ts)){
        
        //get the average score for this move
        Score tempScore=test(i+1,ts);
        
        //if the scores are equal add it to the list of available scores
        if(tempScore.equalS(topScore)){
          //increase the number of available best moves
          available++;
          moves[available-1]=i+1;
        
        //if the new score is better then update the current best update it
        }else if(tempScore.compare(topScore)){
          topScore=tempScore;
          //set there to be only one available best move
          available=1;
          moves[available-1]=i+1;
        }
      }
    }
    
    //make a random move out of the available best moves
    move(moves[(int)random(0,available)],true,ts);
  }
  
  //test the score for a move
  //takes in the move to be tested and the current board
  Score test(int move,int[][] ts){
    
    //return average score
    Score average=new Score();
    
    //launch an army of subbots to play the game and see how well they do
    for(SubBot t:testers){
      
      t=new SubBot(getClone(ts));
      t.forceMove(move);
      boolean dead=false;
      int lifeTime=0;
      //run the subbot till it has reached the sight limit or died
      for(int i=0;i<sight;i++){
        //as long as the bot is alive increase it's alive score
        lifeTime++;
        if(t.runBot()){
          //if it died then break
          dead=true;
          break;
        }
      }
      //only add up the scores of alive bots
      //this will put a huge penalty on moves that are likely to result in a loss
      if(!dead){
        average.scores[0]+=lifeTime;
        average.addScore(t.getTiles());
      }
    }
    
    //return the average score for the move
    return average;
  }
}

//subbot are just simple heuristic AIs used to test how well a move will work out
//this is basically like the normal bot but only looks 1 move into the future
class SubBot{
  //the board
  int[][] subTiles;
  
  SubBot(){
  }
  SubBot(int[][] ts){
    subTiles=getClone(ts);
  }
  
  //run the bot
  //return true if the bot has lost the game
  boolean runBot(){
    int[] moves=new int[4];
    int current=-1;
    
    //set best score negative to start with so it'll always be the lowest
    Score topScore=new Score();
    topScore.scores[0]=-1;
    
    for(int i=0;i<4;i++){
      //if the move can be made
      if(canMove(i+1,subTiles)){
        //test move
        int[][] test=getClone(subTiles);
        move(i+1,false,test);
        Score tempScore=new Score();
        tempScore.calcScore(test);
        
        //if the new score is better then update the current best update it
        if(tempScore.equalS(topScore)){
          //increase the number of available best moves
          current++;
          moves[current-1]=i+1;
        //if the new score is better then update the current best update it
        }else if(tempScore.compare(topScore)){
          topScore=tempScore;
          //set there to be only one available best move
          current=1;
          moves[current-1]=i+1;
        }
      }
    }
    
    //if there are no good moves then return true since it has lost
    if(current==-1)
      return true;
    //otherwise move and return false
    move(moves[(int)random(0,current)],true,subTiles);
    return false;
  }
  
  //force the bot to make a move
  void forceMove(int move){
    move(move,true,subTiles);
  }
  
  //get the board being simulated by the bot
  int[][] getTiles(){
    return subTiles;
  }
}
