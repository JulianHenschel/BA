class Shadow {
  
  PVector orgPos;
  color   col;
  
  Shadow(float x, float y, color c) {
    c = col;
    orgPos = new PVector(x,y);
  }
  
  void draw() {
    
    stroke(0);
    point(orgPos.x,orgPos.y);  
    
  }
  
  void drawShadow(float mX, float mY) {
    
    PVector lightPos = new PVector(mX,mY);
    PVector curPos = new PVector(orgPos.x,orgPos.y);
    
    curPos.sub(lightPos);
    curPos.mult(1.05);    
      
    pushMatrix();
    translate(lightPos.x,lightPos.y);
      
    stroke(200);  
    strokeWeight(1);
    
    point(curPos.x,curPos.y);
      
    popMatrix();
    
  }
  
}
