//this class will score the board based on a set of heuristics
class Score{
  //the set of scores it will look at
  float[] scores;
  
  //score[0] is lifetime
  //score[1] is the longest chain of tiles
  //score[2] is the amount of space left on the board
  
  Score(){
    scores=new float[3];
  }
  
  //addup scores
  void addScore(int[][] ts){
    scores[1]+=chainScore(ts);
    scores[2]+=spaceScore(ts);
  }
  
  //set scores
  void calcScore(int[][] ts){
    scores[1]=chainScore(ts);
    scores[2]=spaceScore(ts);
  }
  
  //this will calculate the number of tiles in a line
  //the is counted in such a way that it "zig-zags" from the left side
  float chainScore(int[][] ts){
    int chain=0;
    int last=-1;
    chain:
    for(int x=0;x<ts.length;x++){
      if(x%2==0){
        for(int y=0;y<ts[x].length;y++){
          if(ts[x][y]!=0&&(last==-1||(ts[x][y]!=0&&ts[x][y]<=last))){
            last=ts[x][y];
            chain+=pow(2,ts[x][y]);
          }else{
            break chain;
          }
        }
      }else{
        for(int y=ts[x].length-1;y>=0;y--){
          if(last==-1||(ts[x][y]!=0&&ts[x][y]<=last)){
            last=ts[x][y];
            chain+=pow(2,ts[x][y]);
          }else{
            break chain;
          }
        }
      }
    }
    return chain;
  }
  
  //will calculate the number of empty tiles
  float spaceScore(int[][] ts){
    int spaces=0;
    for(int x=0;x<ts.length;x++){
        for(int y=0;y<ts[x].length;y++){
          if(ts[x][y]==0){
            spaces++;
          }
        }
    }
    return spaces;
  }
  boolean equalS(Score test){
    for(int i=0;i<scores.length;i++){
      if(scores[i]!=test.scores[i]){
        return false;
      }
    }
    return true;
  }
  boolean compare(Score test){
    for(int i=0;i<scores.length;i++){
      if(scores[i]>test.scores[i]){
        return true;
      }else if(scores[i]<test.scores[i]){
        return false;
      }
    }
    return false;
  }
}
