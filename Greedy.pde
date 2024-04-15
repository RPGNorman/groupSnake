class GreedyView{
  /*
  This entire class and part of the project doesn't serve any purpose to the final result. This was
  just an experiment to see how we could use the existing framework to create an algorithm.
  */
  Snake snake = new Snake();
  
  int[][] grid = new int[10][10];
  void start(){
    text("SCORE : "+snake.score,500,50);
  }
  void update(){
    
  if(!snake.dead){
    snake.show();
    snake.look();
    snake.greedyThink();
    snake.move();
    }
   else{
     snake = new Snake();
   }
  }
}
