class Snake {
   
  int score = 1;
  int lifeLeft = 100;  //amount of moves the snake can make before it dies
  int lifetime = 0;  //amount of time the snake has been alive
  int xVel, yVel;
  int foodItterate = 0;  //itterator to run through the foodlist (used for replay)
  int food2Itterate = 0;
  int obstacleItterate = 0;
  int currDir = 0;
  
  float myHigh = 0;
  float fitness = 0;
  
  boolean dead = false;
  boolean replay = false;  //if this snake is a replay of best snake
  boolean bodyCheck = false;
  boolean foodVision = false;
  
  boolean left;
  boolean right;
  boolean up;
  boolean down;
  
  float[] vision;  //snakes vision
  float[] decision;  //snakes decision
  
  PVector head;
  
  ArrayList<PVector> body;  //snakes body
  ArrayList<Food> foodList;  //list of food positions (used to replay the best snake)
  ArrayList<Food> food2List;
  ArrayList<Obstacle> obstacleList;
  
  Food food;
  Food food2;
  Obstacle obstacle;
  NeuralNet brain;
  
  Snake() {
    this(hidden_layers);
  }
  
  Snake(int layers) {
    head = new PVector(800,height/2);
    food = new Food();
    body = new ArrayList<PVector>();
    if(!humanPlaying) {
      vision = new float[24];
      decision = new float[4];
      body.add(new PVector(800,(height/2)-SIZE));  
      body.add(new PVector(800,(height/2)-(2*SIZE)));
      score+=2;
      if(!isGreedy && !isHamiltonian){
        foodList = new ArrayList<Food>();
        foodList.add(food.clone());
        brain = new NeuralNet(24,hidden_nodes,4,layers);
        if (addObstacle) {
          obstacle = new Obstacle();
          obstacleList = new ArrayList<Obstacle>();
          obstacleList.add(obstacle.clone());
        }
        if (addFood) {
          food2 = new Food();
          food2List = new ArrayList<Food>();
          food2List.add(food.clone());
        }
      }
    }
  }
  
  Snake(ArrayList<Food> foods, ArrayList<Food> foods2, ArrayList<Obstacle> obstacles) {  //this constructor passes in a list of food positions so that a replay can replay the best snake
     replay = true;
     vision = new float[24];
     decision = new float[4];
     body = new ArrayList<PVector>();
     foodList = new ArrayList<Food>(foods.size());
     for(Food f: foods) {  //clone all the food positions in the foodlist
       foodList.add(f.clone());
     }
     food = foodList.get(foodItterate);
     foodItterate++;
     if (addFood) {
      food2List = new ArrayList<Food>(foods2.size());
      for (Food f: foods2) {
        food2List.add(f.clone());
      }
      food2 = food2List.get(food2Itterate);
      food2Itterate++;
     }

     if(addObstacle){
      obstacleList = new ArrayList<Obstacle>(obstacles.size());
        for(Obstacle o: obstacles) {  //clone all the food positions in the foodlist
          obstacleList.add(o.clone());
        }
      obstacle = obstacleList.get(obstacleItterate);
      obstacleItterate++;
    }
     head = new PVector(800,height/2);
     body.add(new PVector(800,(height/2)+SIZE));
     body.add(new PVector(800,(height/2)+(2*SIZE)));
     score+=2;
  }
  
  boolean bodyCollide(float x, float y) {  //check if a position collides with the snakes body
     for(int i = 0; i < body.size(); i++) {
        if(x == body.get(i).x && y == body.get(i).y)  {
           return true;
        }
     }
     return false;
  }
  
  boolean foodCollide(float x, float y) {  //check if a position collides with the food
     if (addFood) {
       if(x == food.pos.x && y == food.pos.y) {
           return true;
       } else if (x == food2.pos.x && y == food2.pos.y) {
         return true;
       }
         return false;
     } else {
       if (x == food.pos.x && y == food.pos.y) {
         return true;
       }
     }
     return false;
  }
  
  boolean obstacleCollide(float x, float y) {  //check if a position collides with an obstacle
  if(addObstacle){
     if(x == obstacle.pos.x && y == obstacle.pos.y) {
         return true;
     }
   }
     return false;
  }

  boolean wallCollide(float x, float y) {  //check if a position collides with the wall
     if(x >= width-(SIZE) || x < 400 + SIZE || y >= height-(SIZE) || y < SIZE) {
       return true;
     }
     return false;
  }
  
  void show() {  //show the snake
     food.show();

     if (addObstacle) {
      obstacle.show();
     }

     if (addFood) {
      food2.show();
     }

     fill(255);
     stroke(0);
     for(int i = 0; i < body.size(); i++) {
       rect(body.get(i).x,body.get(i).y,SIZE,SIZE);
     }
     if(dead) {
       fill(150);
     } else {
       fill(255);
     }
     rect(head.x,head.y,SIZE,SIZE);
  }
  
  void move() {  //move the snake
     if(!dead){
       if(!humanPlaying && !modelLoaded && !isGreedy &&!isHamiltonian) {
         lifetime++;
         lifeLeft--;
       }
       if(foodCollide(head.x,head.y)) {
          eat();
       }
       shiftBody();
       if(wallCollide(head.x,head.y)) {
         dead = true;
       } else if(bodyCollide(head.x,head.y)) {
         dead = true;
       } else if(lifeLeft <= 0 && !humanPlaying && !isGreedy) {
          dead = true;
       } else if (addObstacle && obstacleCollide(head.x, head.y)) {
        dead = true;
       }
     }
  }
  
  void eat() {  //eat food
    int len = body.size()-1;
    score++;
    if(!humanPlaying && !modelLoaded && !isGreedy && !isHamiltonian) {
      if(lifeLeft < 500) {
        if(lifeLeft > 400) {
           lifeLeft = 500; 
        } else {
          lifeLeft+=50;
        }
      }
    }
    if(len >= 0) {
      body.add(new PVector(body.get(len).x,body.get(len).y));
    } else {
      body.add(new PVector(head.x,head.y)); 
    }
    if(!replay) {
      food = new Food();
      while(bodyCollide(food.pos.x,food.pos.y)) {
         food = new Food();
      }
      if(!humanPlaying && !isGreedy && !isHamiltonian) {
        foodList.add(food);
        if (addFood) {
        food2 = new Food();
        while (bodyCollide(food2.pos.x, food2.pos.y) || food2 == food) {
          food2 = new Food();
        }
      }
    } else {  //if the snake is a replay, then we dont want to create new random foods, we want to see the positions the best snake had to collect
      if (!isHamiltonian && foodItterate < foodList.size()) {
        food = foodList.get(foodItterate);
        foodItterate++;
      }
      if (addFood && food2Itterate < food2List.size()) {
        food2 = food2List.get(food2Itterate);
        food2Itterate++;
      }
      if(addObstacle && obstacleItterate < obstacleList.size()){
      obstacle = obstacleList.get(obstacleItterate);
      obstacleItterate++;
      }
    }
    }
  }
  
  
  void shiftBody() {  //shift the body to follow the head
    float tempx = head.x;
    float tempy = head.y;
    head.x += xVel;
    head.y += yVel;
    float temp2x;
    float temp2y;
    for(int i = 0; i < body.size(); i++) {
       temp2x = body.get(i).x;
       temp2y = body.get(i).y;
       body.get(i).x = tempx;
       body.get(i).y = tempy;
       tempx = temp2x;
       tempy = temp2y;
    }
  }
  
  Snake cloneForReplay() {  //clone a version of the snake that will be used for a replay
     Snake clone = new Snake(foodList, food2List, obstacleList);
     clone.brain = brain.clone();
     return clone;
  }
  
  Snake clone() {  //clone the snake
     Snake clone = new Snake(hidden_layers);
     clone.brain = brain.clone();
     return clone;
  }
  
  Snake crossover(Snake parent) {  //crossover the snake with another snake
     Snake child = new Snake(hidden_layers);
     child.brain = brain.crossover(parent.brain);
     return child;
  }
  
  void mutate() {  //mutate the snakes brain
     brain.mutate(mutationRate); 
  }
  
  void calculateFitness() {  //calculate the fitness of the snake
     if(score < 10) {
        fitness = floor(lifetime * lifetime) * pow(2,score); 
     } else {
        fitness = floor(lifetime * lifetime);
        fitness *= pow(2,10);
        fitness *= (score-9);
     }
  }
  
  void look() {  //look in all 8 directions and check for food, body and wall
    vision = new float[24];
    float[] temp = lookInDirection(new PVector(-SIZE,0));
    vision[0] = temp[0];
    vision[1] = temp[1];
    vision[2] = temp[2];
    temp = lookInDirection(new PVector(-SIZE,-SIZE));
    vision[3] = temp[0];
    vision[4] = temp[1];
    vision[5] = temp[2];
    temp = lookInDirection(new PVector(0,-SIZE));
    vision[6] = temp[0];
    vision[7] = temp[1];
    vision[8] = temp[2];
    temp = lookInDirection(new PVector(SIZE,-SIZE));
    vision[9] = temp[0];
    vision[10] = temp[1];
    vision[11] = temp[2];
    temp = lookInDirection(new PVector(SIZE,0));
    vision[12] = temp[0];
    vision[13] = temp[1];
    vision[14] = temp[2];
    temp = lookInDirection(new PVector(SIZE,SIZE));
    vision[15] = temp[0];
    vision[16] = temp[1];
    vision[17] = temp[2];
    temp = lookInDirection(new PVector(0,SIZE));
    vision[18] = temp[0];
    vision[19] = temp[1];
    vision[20] = temp[2];
    temp = lookInDirection(new PVector(-SIZE,SIZE));
    vision[21] = temp[0];
    vision[22] = temp[1];
    vision[23] = temp[2];
  }

  float[] lookInDirection(PVector direction) {  //look in a direction and check for food, body and wall
    float look[] = new float[3];
    PVector pos = new PVector(head.x,  head.y);
    float distance = 0;
    boolean foodFound = false;
    boolean bodyFound = false;
    boolean obstacleFound = false;
    pos.add(direction);
    distance +=1;
    while (!wallCollide(pos.x,pos.y)) {
      if(!foodFound && foodCollide(pos.x,pos.y)) {
        foodFound = true;
        look[0] = 1;
      }
      if(!bodyFound && bodyCollide(pos.x,pos.y)) {
         bodyFound = true;
         look[1] = 1;
      }
      if (addObstacle && !obstacleFound && obstacleCollide(pos.x, pos.y)) {
        obstacleFound = true;
      }
      if(replay && seeVision) {
        stroke(0,255,0);
        point(pos.x,pos.y);
        if(foodFound) {
           noStroke();
           fill(255,255,51);
           ellipseMode(CENTER);
           ellipse(pos.x,pos.y,5,5); 
        }
        if (obstacleFound) {
          noStroke();
          fill(255,255,51);
          ellipseMode(CENTER);
          ellipse(pos.x,pos.y,5,5); 
        }
        if(bodyFound) {
           noStroke();
           fill(102,0,102);
           ellipseMode(CENTER);
           ellipse(pos.x,pos.y,5,5); 
        }
      }
      pos.add(direction);
      distance +=1;
    }
    if(replay && seeVision) {
       noStroke();
       fill(0,255,0);
       ellipseMode(CENTER);
       ellipse(pos.x,pos.y,5,5); 
    }
    look[2] = 1/distance;
    return look;
  }
  
  void think() {  //think about what direction to move
      decision = brain.output(vision);
      int maxIndex = 0;
      float max = 0;
      for(int i = 0; i < decision.length; i++) {
        if(decision[i] > max) {
          max = decision[i];
          maxIndex = i;
        }
      }
      
      switch(maxIndex) {
         case 0:
           moveUp();
           break;
         case 1:
           moveDown();
           break;
         case 2:
           moveLeft();
           break;
         case 3: 
           moveRight();
           break;
      }
  }
  void greedyThink(){
    if(body.size() > 0){
    System.out.println(body.get(0).y/20);
    }
    myHigh = 0;
    for(int i=0; i <= 3; i++){
      if(vision[i*6+2] >= 1) {
        if(vision[i*6+2] >= myHigh){
          if(up && i==1){
            currDir = 1;
          }
          else if(right && i==2){
            currDir = 2;
          }
          else if(down && i==3){
            currDir = 3;
          }
          else if(left && i==0){
            currDir = 0;
          }
        }
      }
    }
    
      if(!foodVision){
         System.out.println(currDir);
         if (currDir==0){
           moveUp();
         }
         else if (currDir==1){
           moveRight();
         }
         else if (currDir==2){
           moveDown();
         }
         else if (currDir==3){ 
           moveLeft();
         }
      }
     foodVision = false;
     bodyCheck = false;
  }
  void setLeft(){
    left = true;
    right = false;
    up = false;
    down = false;
  }
  void setRight(){
    left = false;
    right = true;
    up = false;
    down = false;
  }
  void setUp(){
    left = false;
    right = false;
    up = true;
    down = false;
  }
  void setDown(){
    left = false;
    right = false;
    up = false;
    down = true;
  }
  
  void moveUp() { 
    if(yVel!=SIZE) {
      xVel = 0; yVel = -SIZE;
      setUp();
    }
  }
  void moveDown() { 
    if(yVel!=-SIZE) {
      xVel = 0; yVel = SIZE; 
      setDown();
    }
  }
  void moveLeft() { 
    if(xVel!=SIZE) {
      xVel = -SIZE; yVel = 0; 
      setLeft();
    }
  }
  void moveRight() { 
    if(xVel!=-SIZE) {
      xVel = SIZE; yVel = 0;
      setRight();
    }
  }
}
