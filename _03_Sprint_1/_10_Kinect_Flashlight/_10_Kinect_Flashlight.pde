PImage img;

int    lightRadius = 400;

void setup() {
 
  size(1024,683,P3D);  
    
  img = loadImage("background.jpg");
  image(img,0,0);
  
}

void draw() {
  
  image(img,0,0);
  
  manipulate(mouseX,mouseY,lightRadius);
  
}
