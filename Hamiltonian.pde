class Hamiltonian{

  Snake snake = new Snake();
  float head;
  float tail;
  float food;
  float leftMove;
  float upMove;
  float rightMove;
  float downMove;
  float nextMove;
  ArrayList<Integer> scores = new ArrayList<>();
  
  HamiltonianGraph graphH = new HamiltonianGraph();
  
  void update(){
    if(!snake.dead){
      snake.show();
      findMove();
      snake.move();
      text("SCORE : "+snake.score,500,50);

    }
    else{
      scores.add(snake.score);
      snake = new Snake();
    }
  }
  
  void findMove(){
    setGrid();
    if(snake.head.x/20-21>0){
      leftMove = convertToUniqueNumber((snake.head.x/20-22),(snake.head.y/20-1));
    }
    else{
      leftMove = 9999;
    }
    if(snake.head.x/20-21<37){
      rightMove = convertToUniqueNumber((snake.head.x/20-20),(snake.head.y/20-1));
    }
    else{
      rightMove = 9999;
    }
    if(snake.head.y/20-1>0){
      upMove = convertToUniqueNumber((snake.head.x/20-21),(snake.head.y/20-2));
    }
    else{
      upMove = 9999;
    }
    if(snake.head.y/20-1<37){
      downMove = convertToUniqueNumber((snake.head.x/20-21),(snake.head.y/20));
    }
    else{
      downMove = 9999;
    }
    float[] moveList = {upMove, rightMove, downMove, leftMove};
    float bestFit = 9999;
    float currentFit = 9999;

    for(int i = 0; i<=3; i++){
      
      if(isValidMove(head, tail, moveList[i])){
        if(moveList[i]>head){
          if(moveList[i] <= food){
            currentFit = Math.abs(food - moveList[i]);
          }
          else if(moveList[i] > food){
            currentFit = Math.abs(moveList[i]*2-food);
          }
          if (head > food && moveList[i]!=9999) {
            currentFit -= Math.abs(moveList[i]*2 - food);
            }
          if(currentFit < bestFit){
            if(i==0 && !snake.down){
              bestFit = currentFit;
              nextMove = i;
            }
            else if(i==1 && !snake.left){
              bestFit = currentFit;
              nextMove = i;
            }
            else if(i==2 && !snake.up){
              bestFit = currentFit;
              nextMove = i;
            }
            else if(i==3 && !snake.right){
              bestFit = currentFit;
              nextMove = i;
            }    
          }
        }
      }
    }
    if(nextMove == 0){
      snake.moveUp();
    }
    else if(nextMove == 1){
      snake.moveRight();
    }
    else if(nextMove == 2){
      snake.moveDown();
    }
    else if(nextMove == 3){
      snake.moveLeft();
    }
  }
  
  void setGrid(){
    head = convertToUniqueNumber((snake.head.x/20-21),(snake.head.y/20-1));
    tail = convertToUniqueNumber(snake.body.get(snake.body.size() - 1).x / 20 - 21, snake.body.get(snake.body.size() - 1).y / 20 - 1);
    food = convertToUniqueNumber(snake.food.pos.x/20-21,snake.food.pos.y/20-1);
  }

  public float convertToUniqueNumber(float x, float y) {
    if(y==0){
      return(x);
    }
    else if(x==0 && y > 0){
      return(y*1443-(((y-1)*1443)+(y-1)));
    }
    for(int i = 1; i<=37; i++){
      if(y==i){
        if(y%2==0){
          return (x + y * 37);
        }
        else {
          return (y + 1) * 37 - x+1;
        }
      }
    }
    return 0;
  }

  public boolean isValidMove(float head, float tail, float move) {
        if(head > tail){
          return move>head;
        }
        else if(head < tail){
          return move>head&&move<tail-1; //need to make -1
        }
        return false;
   }
void mousePressed() {
   if (graphButton.collide(mouseX, mouseY)) {
     graphH = new HamiltonianGraph();
   }
}

}
