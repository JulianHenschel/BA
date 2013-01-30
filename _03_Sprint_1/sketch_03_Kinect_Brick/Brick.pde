class Brick {
  
  PVector pos;
  
  color rand = color(random(0,255),random(0,255),random(0,255));
    
  int rWidth = 5;
  
  int counter = 0;
  
  int newWidth = rWidth;
  int rWidthOrg = rWidth;
  
  Brick(float x, float y) {
    
    pos = new PVector(x,y);  
    
  }
  
  void draw() {
    
    //pushMatrix();
    //translate(-width,-height);
    //rotateX(rotX);
    
    rectMode(CENTER);
    ellipseMode(CENTER);
    
    noFill();
    strokeWeight(.5);
    stroke(0);
    
    pushMatrix();
    translate(pos.x,pos.y);
    
    float x = map(rWidth,0,130,0.5,5);
    strokeWeight(0.5+x);
    stroke(0);
    
    ellipse(0-3,0,1+x,1+x);
    ellipse(0+3,0,1+x,1+x);
    ellipse(0,-3,1+x,1+x);
    ellipse(0,+3,1+x,1+x);
    
    popMatrix();
    
    /*    
    fill(rand,150);
    rect(pos.x,pos.y,rWidth,rWidth);
    */
  
    /*  
    float x = map(rWidth,0,130,0.5,5);
    strokeWeight(x);
    line(pos.x,pos.y,pos.x+rWidth,pos.y+rWidth);
    */
    
    /*
    bezier(pos.x,pos.y,
           pos.x+rWidth,pos.y,
           pos.x,pos.y+rWidth,
           pos.x+rWidth,pos.y+rWidth
          );
    */
    
    /*
    line(rWidth/2,rWidth/2, (rWidth+d)/2,(rWidth+d)/2);
    line(-rWidth/2,-rWidth/2, (-rWidth-d)/2,(-rWidth-d)/2);
    
    line(-rWidth/2,rWidth/2, (-rWidth-d)/2,(rWidth+d)/2);
    line(rWidth/2,-rWidth/2, (rWidth+d)/2,(-rWidth-d)/2);
    */
    
    //popMatrix();  
    
  }
  
  void update() {
    
    if(counter > 5) {
      reset();  
    }
    
    if(rWidth != newWidth) 
    {
      if(newWidth > rWidth) 
      {
        rWidth += 1;
      }
      else 
      {
        rWidth -= 1; 
      }
    }
    
    counter++;
    
  }
  
  void reset() {
    newWidth = rWidthOrg;
  }
  
}
