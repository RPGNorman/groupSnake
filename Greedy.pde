class GreedyView{
  
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
