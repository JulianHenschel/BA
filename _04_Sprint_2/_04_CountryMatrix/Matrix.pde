class Matrix {
  
  int steps = 200;
  Palette p;
  int f,t;
  
  int darkestColor;
  int lightestColor;
  
  int xNoise = 0;
  int yNoise = 0;
  
  Matrix(int from, int to, Palette pal) {
    
    f = from;
    t = to;
    
    p = pal;
    
    darkestColor = p.getDarkest();
    lightestColor = p.getLightest();
  }
  
  void draw() {
    
    background(lightestColor);
    
    int stepsH = height / steps;
    int stepsW = width / steps;
    
    noiseDetail(10);
    
    for(int y = f+stepsH; y-stepsH <= t; y+=stepsH) {
      
      yNoise+=y;
      
      for(int x = f+stepsW; x <= t-stepsW*2; x+=stepsW) {
      
        xNoise+=x;
      
        pushMatrix();
        translate(x,y);
        
          noStroke();
          
          float col = map(noise(xNoise),0,0.8,0,4);        
          fill(p.getColor((int)col));
          
          triangle(0,0,stepsW,0,0,stepsH);
                 
          float col2 = map(noise(yNoise),0,0.8,0,4);
          fill(p.getColor((int)col2));
          
          triangle(0,stepsH,stepsW,stepsH,stepsW,0);

        popMatrix();
        
      }
    }
    
  }
  
}
