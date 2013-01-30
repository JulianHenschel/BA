class Fibonacci {
  
  PVector pos = new PVector(0,0);
  PVector lastPos;
  float angle, steps, radius, lastRadius;
  
  Fibonacci() {
    
    steps = 900;
    angle = TWO_PI/(float)steps;
    
    radius = 1;
    lastRadius = 0;
  }
  
  void draw() {
    
    float strokeW = 20/steps;
    float s = 0;
    
    for(int i = 0; i < steps; i++) {
      
      //float rad = (lastRadius + radius);
      float rad = radius + 1;
      
      s += strokeW;
      
      noStroke();
      ellipse(pos.x+rad*sin(angle*i), pos.y+rad*cos(angle*i),s,s);
      
      /*
      if(i > 0) {
       line(pos.x+rad*sin(angle*i), pos.y+rad*cos(angle*i),
            pos.x+lastRadius*sin(angle*i-1), pos.y+lastRadius*cos(angle*i-1));
      } 
      */
      
      lastRadius = radius;
      radius = rad;
      
    }
    
  }
}
