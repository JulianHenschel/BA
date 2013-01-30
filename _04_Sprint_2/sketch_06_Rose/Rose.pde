class Rose {
  
  PVector   pos;
  ArrayList sl;
  int radius = 100;
  float noiseFactor = random(0.5,1);
  color col = color(random(0,255),random(0,255),random(0,255));
  
  Rose(float x, float y, int r) {
    
    radius = r;
    
    pos = new PVector(x,y);
    sl = new ArrayList();
    
  }
  
  void draw() {
    
    pushMatrix();
    translate(pos.x,pos.y);
    
    fill(col,50);
    //noFill();
    
    stroke(col);
    strokeWeight(.5);
    //noStroke();
    
    //for(int i = 0; i < 100; i++) 
    //{
      
      beginShape();
  
      for(int j = 0; j < 200; j++)
      {
        float a = j*PI/50;
        float rN = noise(a)*100*noiseFactor;
        
        //line(0,0,(radius+rN)*sin(a),(radius+rN)*cos(a));
        
        curveVertex((radius+rN)*sin(a),(radius+rN)*cos(a));
      }
            
      endShape();
            
    //}
    
    popMatrix();
    
  }
}
