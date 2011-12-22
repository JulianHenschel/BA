class Process {
  
  PVector start, end;
  
  int     h = 350;
  int     w = 550;
  
  int     steps = (int)random(50,80);
  
  int     baseWidth = 80;
  
  float   nOff = 0;
  
  Process(float sX, float sY, float eX, float eY) {
    
    start = new PVector(sX,sY);
    end = new PVector(eX,eY);
    
  }
  
  void drawRect() {
    
    fill(0);
    rect(start.x, start.y-(h/2),w,h);
    
  }
  
  void draw() {
        
    noFill();
    stroke(0);
    strokeWeight(0.4);
    
    for(int i = 0; i < steps; i++) {
      
      float rW = random(w-100,w+100);
      float rH = random(h-50,h+50);
            
      ellipse(start.x+w/2,start.y,rW,rH);
    }
    
  }
  
  void drawBase() {
   
    stroke(0);
    
    line(start.x-baseWidth,start.y,start.x,start.y); 
    line(end.x,end.y,end.x+baseWidth,end.y); 
    
  }
  
}
