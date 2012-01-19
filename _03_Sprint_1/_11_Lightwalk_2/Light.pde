class Light {
  
  PVector   pos;
  
  int       speed = (int)random(1,2);
  int       counter = 0;
  int       angle = (int)random(0,360);
  int       radius = 0;
  float     factor = random(-1,1);
  int       modulo = frameCount%2;
    
  color     c = color(random(0,255),0,0);
  
  Light(float x, float y) 
  {
     pos = new PVector(x,y);
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
