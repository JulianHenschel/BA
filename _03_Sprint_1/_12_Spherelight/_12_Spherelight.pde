import processing.opengl.*;
import fullscreen.*;

FullScreen fs;

int        w = 1440;
int        h = 900;

void setup() 
{
  size(w,h,OPENGL);
  
  /* ---------------------------------------------------------------------------- */
  
  kinectSetup();
  
  /* ---------------------------------------------------------------------------- */
  
  // init fullscreen object
  
  fs = new FullScreen(this); 
  fs.enter();
  
}

void draw() 
{
 
  /* ---------------------------------------------------------------------------- */
  
  background(0);
  noStroke();
  
  /* ---------------------------------------------------------------------------- */
  
  for (int i = 0; i < users.size(); i++)
  {
    CoM c = (CoM)users.get(i);
    pointLight(255,255,255,c.pos.x,c.pos.y,0);
  }
  
  /* ---------------------------------------------------------------------------- */
    
  int steps = 23;
  
  for(int x = steps; x <= width-steps; x+=steps) 
  {
    for(int y = steps; y <= height-steps; y+=steps) 
    {
      pushMatrix();
      translate(x,y);
       
      sphereDetail(6);
      sphere(8);
  
      popMatrix();
    }
  }
  
  /* ---------------------------------------------------------------------------- */
  
  kinectDraw();
  
}
