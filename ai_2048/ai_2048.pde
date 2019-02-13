/*
  AI 2048
  --------------
  This is a recreation of the popular game "2048" but I programmed a bot to play it automatically.
  The bot is a combination of a Monte Carlo tree search and a heuristic AI.
  
  written by Adrian Margel, Summer 2018
*/

import java.math.BigInteger;

//the game board
int[][] tiles;
//size of the game
int gridSizeX=4;
int gridSizeY=4;

//zoom
int scale;

//the font of the tiles
PFont font;

//the game score
BigInteger score;

//the bot playing the game
Bot run;

void setup(){
  //init game
  score=new  BigInteger(0+"");
  tiles=new int[gridSizeX][gridSizeY];
  for(int i=0;i<2;i++){
    addTile(tiles);
  }
  
  //set window size
  size(800,800);
  
  //set the size of the tiles/zoom to fit things nicely on screen
  scale=min(width/gridSizeX,height/gridSizeY);
  
  //setup fonts
  textAlign(CENTER, CENTER);
  font=createFont("ClearSans-Medium.ttf",scale/2);
  textFont(font);
  
  //turn off stroke
  noStroke();
  
  //setup the bot to play
  run=new Bot(200,20);
  
}

void draw(){
  //run the AI
  run.runBot(tiles);
  
  //display the game
  display();
}

void display(){
  //fill background
  background(187,173,160);
  
  //draw all tiles
  for(int x=0;x<gridSizeX;x++){
    for(int y=0;y<gridSizeY;y++){
      if(tiles[x][y]!=0){
        //set tile color
        if(tiles[x][y]==1){
          fill(238,228,218);
        }else if(tiles[x][y]==2){
          fill(236,224,200);
        }else if(tiles[x][y]==3){
          fill(242,177,121);
        }else if(tiles[x][y]==4){
          fill(245,149,99);
        }else if(tiles[x][y]==5){
          fill(245,124,95);
        }else if(tiles[x][y]==6){
          fill(246,93,59);
        }else if(tiles[x][y]<11){
          fill(237,206,113);
        }else if(tiles[x][y]==11){
          fill(238,194,46);
        }else{
          fill(61,58,51);
        }
        //draw tile
        rect(x*scale+scale*0.05,y*scale+scale*0.05,scale*0.9,scale*0.9,scale/20);
        
        //set font color
        if(tiles[x][y]>2){
          fill(247);
        }else{
          fill(110);
        }
        //draw the text to the size to perfectly fit within the tile
        textSize(scale/2);
        String text=(new BigInteger(2+"").pow(tiles[x][y])).toString();
        float sizeT=textWidth(text);
        if(sizeT>scale*0.8){
          textSize(scale*scale/sizeT/2*0.8);
        }else{
          textSize(scale/2);
        }
        text(text,(x+0.5)*scale,(y+0.5-0.075)*scale);
        
      }else{
        //draw empty tiles
        fill(204,192,179);
        rect(x*scale+scale*0.05,y*scale+scale*0.05,scale*0.9,scale*0.9,scale/20);
      }
    }
  }
}

//game move up and down
void moveY(boolean dir, int[][] ts){
  for(int x=0;x<gridSizeX;x++){
    ArrayList<Integer> column=new ArrayList<Integer>();
    //add tiles array
    if(dir){
      for(int y=0;y<gridSizeY;y++){
        if(ts[x][y]!=0){
          column.add(ts[x][y]);
        }
      }
    }else{
      for(int y=gridSizeY-1;y>=0;y--){
        if(ts[x][y]!=0){
          column.add(ts[x][y]);
        }
      }
    }
    //combine same
    for(int i=1;i<column.size();i++){
      if(column.get(i-1)-column.get(i)==0){
        column.set(i-1,column.get(i)+1);
        column.remove(i);
        score=score.add(new BigInteger(2+"").pow(column.get(i-1)));
      }
    }
    //re-add
    if(dir){
      for(int y=0;y<gridSizeY;y++){
        if(y<column.size()){
          ts[x][y]=column.get(y);
        }else{
          ts[x][y]=0;
        }
      }
    }else{
      for(int y=0;y<gridSizeY;y++){
        if(y<column.size()){
          ts[x][gridSizeY-y-1]=column.get(y);
        }else{
          ts[x][gridSizeY-y-1]=0;
        }
      }
    }
  }
}

//game move left and right
void moveX(boolean dir, int[][] ts){
  for(int y=0;y<gridSizeY;y++){
    ArrayList<Integer> row=new ArrayList<Integer>();
    //add tiles array
    if(dir){
      for(int x=0;x<gridSizeX;x++){
        if(ts[x][y]!=0){
          row.add(ts[x][y]);
        }
      }
    }else{
      for(int x=gridSizeX-1;x>=0;x--){
        if(ts[x][y]!=0){
          row.add(ts[x][y]);
        }
      }
    }
    //combine same
    for(int i=1;i<row.size();i++){
      if(row.get(i-1)-row.get(i)==0){
        //row.set(i-1,row.get(i)+row.get(i-1));
        row.set(i-1,row.get(i)+1);
        row.remove(i);
        score=score.add(new BigInteger(2+"").pow(row.get(i-1)));
        //i--;
      }
    }
    //re-add
    if(dir){
      for(int x=0;x<gridSizeX;x++){
        if(x<row.size()){
          ts[x][y]=row.get(x);
        }else{
          ts[x][y]=0;
        }
      }
    }else{
      for(int x=0;x<gridSizeX;x++){
        if(x<row.size()){
          ts[gridSizeX-x-1][y]=row.get(x);
        }else{
          ts[gridSizeX-x-1][y]=0;
        }
      }
    }
  }
}


//spawn new tile randomly
void addTile(int[][] ts){
  ArrayList<Integer> validX=new ArrayList<Integer>();
  ArrayList<Integer> validY=new ArrayList<Integer>();
  //add all empty tiles
  for(int x=0;x<gridSizeX;x++){
    for(int y=0;y<gridSizeY;y++){
      if(ts[x][y]==0){
        validX.add(x);
        validY.add(y);
      }
    }
  }
  //spawn new tile in an empty tile
  if(validX.size()>0){
    //randomly spawn either a 2 tile or a 4 tile
    int rand=(int)(Math.random()*validX.size());
    if(Math.random()<0.9){
      ts[validX.get(rand)][validY.get(rand)]=1;
    }else{
      ts[validX.get(rand)][validY.get(rand)]=2;
    }
  }
}

//clone the board
int[][] getClone(int[][] ts){
  int[][] clone=new int[gridSizeX][gridSizeY];
  for(int x=0;x<gridSizeX;x++){
    for(int y=0;y<gridSizeY;y++){
      clone[x][y]=ts[x][y];
    }
  }
  return clone;
}

//find highest tile
int getHighest(int[][] ts){
  int highest=0;
  for(int x=0;x<gridSizeX;x++){
    for(int y=0;y<gridSizeY;y++){
      if(ts[x][y]>highest){
        highest=ts[x][y];
      }
    }
  }
  return highest;
}

//check if two boards are the same
boolean compare(int[][] ts1,int[][] ts2){
  for(int x=0;x<gridSizeX;x++){
    for(int y=0;y<gridSizeY;y++){
      if(ts1[x][y]!=ts2[x][y])
        return false;
    }
  }
  return true;
}

//move based on a direction
void move(int dir,boolean spawnTile,int[][] ts){
  int[][] lts=getClone(ts);
  switch(dir){
    case 1: moveX(true,ts);
      break;
    case 2: moveX(false,ts);
      break;
    case 3: moveY(true,ts);
      break;
    case 4: moveY(false,ts);
      break;
    default: break;
  }
  if(spawnTile&&!compare(lts,ts)){
    addTile(ts);
  }
}

//test if a move can be made
boolean canMove(int dir,int[][] ts){
  int[][] test=getClone(tiles);
  int[][] testLast=getClone(tiles);
  move(dir,false,test);
  return !compare(test,testLast);
}

/*
//this will allow a player to play using the WASD keys
void keyPressed(){
  if(key=='w'){
    move(3,true,tiles);
  }
  if(key=='s'){
    move(4,true,tiles);
  }
  if(key=='a'){
    move(1,true,tiles);
  }
  if(key=='d'){
    move(2,true,tiles);
  }
  //run.runBot(tiles);
}
*/
