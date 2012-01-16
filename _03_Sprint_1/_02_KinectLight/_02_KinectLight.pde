import processing.opengl.*;
import processing.pdf.*;

boolean    dosave = false;
ArrayList  sList;
PImage     img;

void setup() {
 
  size(1200,800,P3D);
  smooth();
  
  sList = new ArrayList();
  
  img = loadImage("background.gif");
        
  for(int x = 0; x < img.width; x++) {
    for(int y = 0; y < img.height; y++) {
        
      int pix = x+y*img.width;
        
      if(img.pixels[pix] != -1) {
        sList.add(new Shadow(x,y,img.pixels[pix]));
      }
    }
  }
  
}

void draw() {

  background(255);
  
  for(int i = 0; i < sList.size(); i++) {
    
    Shadow s = (Shadow) sList.get(i);
    s.drawShadow(mouseX,mouseY);
    
  }
  
  for(int i = 0; i < sList.size(); i++) {
    
    Shadow s = (Shadow) sList.get(i);
    s.draw();
    
  }
}
