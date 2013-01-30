class Light {
  
  PVector   pos;
  
  int       speed = (int)random(1,2);
  int       counter = 0;
  int       angle = (int)random(0,360);
  int       radius = 0;
  int       modulo = frameCount%2;
  float     factor = random(-1,1);
    
  color     c;
  
  Light(float x, float y, color col) 
  {
     pos = new PVector(x,y);
     c = col;
  }
    
  void update() 
  {
    radius += speed;
    counter ++;  
  }
  
  
  void draw() 
  {
    
    rectMode(CENTER);
    ellipseMode(CENTER);
    
    fill(255);
    stroke(0);
        
    pushMatrix();
    translate(radius*sin(angle), radius*cos(angle)); 
    
    noStroke();
    fill(c,100);
    
    /*
    if(modulo == 0) {
      ellipse(pos.x,pos.y,counter*factor,counter*factor);
    }else {
      rect(pos.x,pos.y,counter*factor,counter*factor);
    }
    */
    
    rect(pos.x,pos.y,counter*factor,counter*factor);
    
    popMatrix();
    
  }
  
}
