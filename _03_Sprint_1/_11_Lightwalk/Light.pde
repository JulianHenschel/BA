class Light {
  
  int       counter = 0;
  float     rHeight = 10;
  float     cHeight = 0;
  PVector   pos;
  int       speed = (int)random(10,15);
  color     c = color(random(0,255),random(0,255),random(0,255));
  
  Light(float x, float y) 
  {
    pos = new PVector(x,y);
  }
  
  void grow() 
  {
    cHeight += speed;
  }
  
  void shrink() 
  {
    cHeight -= speed;
  }
  
  void update() 
  {
  
    if(cHeight < rHeight) 
    {
      grow();
    }else {
      shrink();
    }
    
    if(cHeight > rHeight) 
    {
        rHeight = 10;
    }
  }
  
  void draw() 
  {
        
    rectMode(CENTER);
    
    fill(255);
    stroke(0);
    
    rect(pos.x,pos.y,lightWidth,cHeight);
    
  }
  
}
