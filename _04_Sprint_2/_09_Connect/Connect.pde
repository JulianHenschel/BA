class Connect {
  
  PVector pos;
  int id;
  int addMove = 0;
  int steps = 500;
  
  Connect(float x, float y, int identity) {
    
    pos = new PVector(x,y);
    
    id = identity;
    
  }
  
  void draw() {
        
    drawCenter();
    
    // define connections to draw
    for(int i = 0; i < cl.size(); i++) {
      
      Connect c = (Connect)cl.get(i);
      
      if(c.id != id) {
        
        noFill();
        //fill(lightestColor,1);
        stroke(lightestColor,5);
        strokeWeight(.1);
        
        //float angle = PVector.angleBetween(pos, c.pos);
        float angle = seg_angle(c.pos.x,c.pos.y,pos.x,pos.y);
        float distance = PVector.dist(pos,c.pos);
        
        distance = 30;

        for(int j = 0; j < steps; j++) 
        {        
              
          float cp1x = pos.x + distance + addMove * sin(angle * PI/180);
          float cp1y = pos.y + distance + addMove * cos(angle * PI/180);
          float cp2x = c.pos.x + distance + addMove * sin(angle * PI/180);
          float cp2y = c.pos.y + distance + addMove * cos(angle * PI/180);
                  
          bezier(
                pos.x,pos.y,
                cp1y,cp1y,
                cp2y,cp2y,
                c.pos.x,c.pos.y
                );
          
          addMove += random(-10,10);
        }  
      }
    }
    
    
    
  }
  
  void drawCenter() {
    
    noStroke();
    fill(255,10);
    
    //ellipse(pos.x,pos.y,20,20); 
    
  }
  
  float seg_angle(float xTo, float yTo, float xFrom, float yFrom)
  {
      float dx = xTo - xFrom;
      float dy = yTo - yFrom;

      return atan2(dy,dx);
  }
  
}
