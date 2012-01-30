

void setup() {
 
  size(600,800);
  smooth();  
  
}

void draw() {
  
  background(255);
  
  strokeWeight(.5);
  
  pushMatrix();
  translate(width/2,height/2);
  
  float cellWidth = 40;
  
  fill(212,112,211);
  stroke(255);
  
  for(int i = 0; i < 4; i++) {
    rotate(radians(90)*i);
    triangle(-cellWidth/4,-cellWidth/2,cellWidth/4,-cellWidth/2,0,0);
  }

  stroke(255);
  
  
  for(int i = 1; i < 5; i++) {
    rotate(radians(45)*i);
    ellipse(0,0,cellWidth/4,cellWidth);
  }
  
  strokeWeight(3);
  
  line(-cellWidth/2,0,cellWidth/2,0);
  line(0,-cellWidth/2,0,cellWidth/2);
  
  popMatrix();
  
  noLoop();
}
