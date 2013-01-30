class Net {

  int steps = 800;
  PVector[] pl;
  float spin = 3;
  int lineHeight = 30;
  
  int[] colors;
  float[] rotation;
  
  Net(Palette pc) {
  
    pl = new PVector[steps];
    colors = new int[steps];
    rotation = new float[steps];
    
    for(int i = 0; i < pl.length; i++) {

      PVector p = new PVector(random(lineHeight*2,width-lineHeight*2), random(lineHeight*2,height-lineHeight*2));
      
      float n = noise(p.x, p.y)*180;
      
      rotation[i] = n;
      pl[i] = p;
      
      int r = (int)random(0,4);
      
      colors[i] = pc.getColor(r);
      
    }
    
  }

  void draw() {
  
    for(int i = 0; i < pl.length; i++) {
      
      pushMatrix();
      translate(pl[i].x,pl[i].y);
      rotate(radians(rotation[i]));
      
      strokeWeight(0.5);
      stroke(colors[i]);
      line(0,-lineHeight,0,lineHeight);
      
      popMatrix();
      
      /*
      fill(255);
      noStroke();
      ellipse(pl[i].x,pl[i].y,5,5);
      */
      
    }
  
  }

  void rotation() {
    
    for(int i = 0; i < pl.length; i++)
    {
      rotation[i] += 2;
    }
  }  
  
}
