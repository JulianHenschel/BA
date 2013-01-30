class Matrix {
  
  int steps = 400;
  Palette p;
  int f,t;
  
  int xNoise = 0;
  int yNoise = 0;
  
  Matrix(int from, int to, Palette pal) {
    
    f = from;
    t = to;
    
    p = pal;
    
    darkestColor = p.getDarkest();
    lightestColor = p.getLightest();
    
    p.sortBySaturation();
  }
  
  void draw() {
    
    float noiseScale = 0.02;
        
    int stepsH = height / steps;
    int stepsW = width / steps;
    
    noiseDetail(100);
    
    for(int y = f+stepsH; y-stepsH <= t; y+=stepsH) {
            
      for(int x = f+stepsW; x <= t-stepsW*2; x+=stepsW) {
        
        float noiseVal = noise(x*noiseScale, y*noiseScale);  
        float col = map(noiseVal,0,0.8,0,4);
        
        pushMatrix();
        translate(x,y);
        
          noStroke();
          
          //float col = map(noise(xNoise),0,0.8,0,4);        
          fill(p.getColor((int)col));
          
          triangle(0,0,stepsW,0,0,stepsH);
                 
          float col2 = map(noise(x,y),0,0.8,0,4);
          fill(p.getColor((int)col2));
                    
          triangle(0,stepsH,stepsW,stepsH,stepsW,0);

        popMatrix();
        
      }
    }
    
  }
  
}
