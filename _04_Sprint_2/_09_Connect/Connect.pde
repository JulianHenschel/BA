class Connect {
  
  PVector pos;
  
  int     id;
  int     addMove = 0;
  int     steps = 500;
  
  Connect(float x, float y, int identity, int s) {
    
    pos = new PVector(x,y);
    id = identity;
    
    steps = s;
    
  }
  
  void draw() {
        
    // define connections to draw
    for(int i = 0; i < cl.size(); i++) 
    {
      
      Connect c = (Connect)cl.get(i);
      
      if(c.id != id) {
        
        int col = (int)random(0,4);
        
        noFill();
        stroke(kt[0].getColor(col),80);
        strokeWeight(.1);
        
        float distance = PVector.dist(pos,c.pos) / 1000;
        float angle = PVector.angleBetween(pos,c.pos);
        
        //println(degrees(angle));
        //println(distance);
                
        for(int j = 0; j < steps; j++) 
        { 
          
          float cp1x = pos.x + (distance + addMove) * sin(angle * PI/180);
          float cp1y = pos.y + (distance + addMove) * cos(angle * PI/180);        
          float cp2x = c.pos.x + (distance + addMove) * sin(angle * PI/180);
          float cp2y = c.pos.y + (distance + addMove) * cos(angle * PI/180);
          
          bezier(pos.x, pos.y, cp1y, cp1y, cp2y, cp2y, c.pos.x, c.pos.y);
          
          totalRenderedLines++;
          
          //addMove += random(-15,15);
          distance += random(-10,10);
                    
        }
      }

    }
    
    drawCenter();
        
    println("rendered id "+id+": "+steps+" lines");
    
  }
  
  void drawCenter() {
    
    noFill();
    stroke(darkestColor);
    
    ellipse(pos.x,pos.y,10,10); 
    
  }
  
}
