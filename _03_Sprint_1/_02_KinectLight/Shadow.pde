class Shadow {
  
  PVector orgPos;
  color   col;
  
  Shadow(float x, float y, color c) {
    col = c;
    orgPos = new PVector(x-width/2,y-height/2);
  }
  
  void draw() {
    
    pushMatrix();
    rotateX(rotX);
    
    stroke(col);
    strokeWeight(1);
    
    point(orgPos.x,orgPos.y);  
    
    popMatrix();
    
  }
  
  void drawShadow(float mX, float mY, float mZ) {
    
    pushMatrix();
    rotateX(rotX);
    
    PVector lightPos = new PVector(mX,mY);
    PVector curPos = new PVector(orgPos.x,orgPos.y);
    
    curPos.sub(lightPos);
    curPos.mult(multFactor);    
      
    pushMatrix();
    translate(lightPos.x,lightPos.y);
    
    /*
    float m = map(mZ,0,7000,1,1.5);
    scale(m);
    */
      
    stroke(255,0,0,100);  
    strokeWeight(1);
    
    point(curPos.x,curPos.y);
      
    popMatrix();
    popMatrix();
    
  }
  
}
