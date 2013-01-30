class MindMap {
 
  PVector pos;
  
  float radius = 250;
  float steps = 16;
  
  MindMap(float x, float y) {
  
    pos = new PVector(x,y);
    
  } 

  void draw() {
    
    strokeWeight(.5);
    stroke(0);
    
    float angle = TWO_PI/(float)steps;
    
    for(int i = 0; i < steps; i++) {

      pushMatrix();
      translate(pos.x,pos.y);
      
        stroke(0);        
        noFill();
        
        bezier(0,0,
               radius/2*sin(angle*(i-2)), radius/2*cos(angle*(i-2)),
               radius/2*sin(angle*(i+2)), radius/2*cos(angle*(i+2)),   
               radius*sin(angle*i), radius*cos(angle*i)
               );
               
        fill(0);
        noStroke();
        ellipse(radius*sin(angle*i), radius*cos(angle*i), 80, 80);
      
      popMatrix();
      
    }
    
    // draw middle point
    fill(0);
    noStroke();
    ellipse(pos.x,pos.y,120,120);
    
  }
}
