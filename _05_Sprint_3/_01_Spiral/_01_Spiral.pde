import processing.pdf.*;

void setup() {
  
  size(600,800);
  background(255);
  smooth();
  
}

void draw() {
  
  beginRecord(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 
  
  float steps = 60;
  float angle = TWO_PI/(float)steps;
  
  pushMatrix();
  translate(width/2,height/2);

  for(int i = 0; i < steps; i++) {
    
    pushMatrix();
    //translate(50*sin(angle*i), 50*cos(angle*i));
    rotate(TWO_PI/steps * i);
    
    fill(0);
    Fibonacci f = new Fibonacci();
    f.draw();
    
    popMatrix();
    
  }

  popMatrix();
  
  endRecord();

  noLoop();
  
}
