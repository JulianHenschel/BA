
float rotation = 0;
float slider = 0;

void setup() {
 
  size(1200,800);
  smooth();
  
  frameRate(30);
  
  background(0);
  
}

void draw() {
  
  walkani(mouseX,mouseY,1);
  walkani(mouseX,mouseY,2);
  
}

void walkani(int x, int y, int id) {
  
  PVector pos = new PVector(x,y);
  
  switch(id) {
     
    case 1:
      
      pushMatrix();
      translate(pos.x,pos.y);
      rotate(rotation);
      
      stroke(255);
      strokeWeight(0.5);
      noFill();
      ellipse(0,0,100,random(180,190));
      
      popMatrix();
      
      rotation += 0.008;
      
      break;
    case 2:
      
      stroke(255);
      noFill();
      bezier(pos.x,0,
             slider,0,
             slider,height,
             pos.x,height);
      
      slider += 2;
      
      break;
    case 3:
    
      break;
    default:
    
      break;
  }
  
  
  
  if(slider > width) {
    slider = 0;
  }
  
}
