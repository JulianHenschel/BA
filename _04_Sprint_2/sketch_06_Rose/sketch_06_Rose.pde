
Rose r;
Rose r2;

void setup() {
  
  size(600,800);
  smooth();
  
  r = new Rose(width/2, height/2,150);
  r2 = new Rose(width/2, height/2,200);
  
}

void draw() {
  
  background(0);
  
  r.draw();
  r2.draw();
  
  noLoop();
  
}

void keyPressed() {
  
  if (key == ' ') {
    loop();
  }
  
  if (key == 's') { 
    //dosave=true;
    loop();
  }
  
}
