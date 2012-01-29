class Drawing {
  
  PVector pos;
  Palette p;
  
  int darkestColor;
  int lightestColor;
  float radiusOrg = 2;
  float radius = radiusOrg;
  float n = 0;
  
  Drawing(float x, float y, Palette palette) {
    
    p = palette;
    
    darkestColor = p.getDarkest();
    lightestColor = p.getLightest();
    
    pos = new PVector(x,y);
    
  }
  
  void draw() {
    
    pushMatrix();
    translate(pos.x,pos.y);
    
    int col = p.getColor((int)random(0,4));
    
    noFill();
    fill(col);
    strokeWeight(.5);
    stroke(lightestColor);
    noStroke();
    
    ellipse(0,0,radiusOrg,radiusOrg);
    
    popMatrix();
    
    move();
    
  }
  
  void move() {
    
    float spin = 1;
    
    //
    pos.y += noise(pos.x,pos.y);
    
    //if(pos.y > height/3) {
      pos.x += random(-noise(pos.x,pos.y)*spin,noise(pos.x,pos.y)*spin);
    //}
    
    
    radiusOrg = noise(pos.x,pos.y)*radius;
    
    //radius-=0.2;
        
  }
  
}
