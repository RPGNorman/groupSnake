class HamiltonianGraph extends PApplet {
   HamiltonianGraph() {
       super();
       PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
   }
   
   void settings() {
      size(900,600); 
   }
   
   void setup() {
       background(15000);
       frameRate(30);
   }
   
void draw() {
    background(150);
    fill(0);
    strokeWeight(1);
    textSize(15);
    textAlign(CENTER, CENTER);
    text("Iteration", width/2, height-10);
    translate(10, height/2);
    rotate(PI/2);
    text("Score", 0, 0);
    rotate(-PI/2);
    translate(-10, -height/2);
    textSize(10);
    float x = 50;
    float y = height-35;
    float xbuff = (width-50) / 51.0;
    float ybuff = (height-50) / 1500.0;
    for(int i=0; i<=50; i++) {
        text(i, x, y); 
        x += xbuff;
    }
    x = 35;
    y = height-50;
    float ydif = ybuff * 75.0;
    stroke(0,0,0);
    for(int i=0; i<=1500; i+=75) {
        text(i, x, y); 
        line(50, y, width, y);
        y -= ydif;
    }
    strokeWeight(5);
    line(50, 0, 50, height-50);
    line(50, height-50, width, height-50);
      for (int i = 0; i < hamiltonianSnake.scores.size(); i++) {
          strokeWeight(5);
          stroke(255,255,255);
          point(i * xbuff+50, height - 50 - (hamiltonianSnake.scores.get(i) * ybuff));
          if(i > 0){
            strokeWeight(2);
            stroke(255,255,255);
            line((i-1) * xbuff+50, height - 50 - (hamiltonianSnake.scores.get(i-1) * ybuff), i * xbuff+50, height - 50 - (hamiltonianSnake.scores.get(i) * ybuff));
          }
      }
}

   void exit() {
      dispose();
      graph = null;
   }
}
