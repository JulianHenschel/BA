class Light {
  
  int       counter = 0;
  float     rHeight = 5;
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
      return;
    }
    
    if(counter > 5) {
      
      rHeight = 0;
      shrink();
    }
    
  }
  
  void draw(int index) 
  {
        
    rectMode(CENTER);
    
    //fill(255);
    noStroke();
    
    if(cHeight > 0) { 
      
      beginShape();
      
      texture(images[index]);
      
      float new_x = pos.x - lightWidth/2;
      
      vertex(new_x,0,0,0);
      vertex(new_x+lightWidth,0,new_x+lightWidth,0);
      vertex(new_x+lightWidth,cHeight,new_x+lightWidth,cHeight);
      vertex(new_x,cHeight,0,cHeight);
      
      endShape();
      
    }
    
    counter++;
    
  }
  
}
