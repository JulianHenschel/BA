class Process {
  
  PVector start, end;
  
  int     h = 300;
  int     w = 450;
  
  int     steps = (int)random(400,500);
  
  int     baseWidth = 200;
  
  Process(float sX, float sY, float eX, float eY) {
    
    start = new PVector(sX,sY);
    end = new PVector(eX,eY);
    
  }
  
  void drawRect() {
    
    fill(0);
    rect(start.x, start.y-(h/2),w,h);
    
  }
  
  void draw() {
    
    drawRect();
    
    noFill();
    stroke(255);
    strokeWeight(0.4);
    
    beginShape();
        
    vertex(start.x,start.y);
    
    for(int i = 0; i < steps; i++) {
      
      float rX = random(0,width);
      float fX = map(rX,0,width,start.x+10,start.x+w-10);
      
      float rY = random(0,height);
      float fY = map(rY,0,height,start.y-(h/2)+10,start.y+(h/2)-10);
      
      vertex(fX,fY);
      
    }
    
    vertex(end.x,end.y);
    
    endShape();
    
  }
  
  void drawBase() {
   
    stroke(0);
    
    line(start.x-baseWidth,start.y,start.x,start.y); 
    line(end.x,end.y,end.x+baseWidth,end.y); 
    
  }
  
}
