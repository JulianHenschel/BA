import processing.opengl.*;
import processing.pdf.*;
import fullscreen.*;

FullScreen fs;

int        w = 1440;
int        h = 900;

int        lightWidth;
boolean    dosave = false;
ArrayList  lightList;

void setup() {
  
  size(w,h,OPENGL);
  
  frameRate(40);
    
  lightList = new ArrayList();
  
  /* ---------------------------------------------------------------------------- */
  
  kinectSetup();
  
  /* ---------------------------------------------------------------------------- */
  
  // init fullscreen object
  
  fs = new FullScreen(this); 
  fs.enter();
  
}

void draw() {
  
  background(0);
  
  /* ---------------------------------------------------------------------------- */
  
  kinectDraw();
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {

    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 

    pdf.fill(0);
    pdf.rect(0,0, width,height);
    
  }
  
  /* ---------------------------------------------------------------------------- */
    
  // add new light
  for (int i = 0; i < users.size(); i++)
  {
    CoM c = (CoM)users.get(i);
    
    int colorIndex = c.id % userColors.length;
    lightList.add(new Light(c.pos.x,c.pos.y,userColors[colorIndex]));
  }
  
  /* ---------------------------------------------------------------------------- */
  
  // update light
  for(int i = 0; i < lightList.size(); i++) {
  
    Light l = (Light)lightList.get(i);  
    
    l.update();
    l.draw();
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  // remove unused object
  for (int i = lightList.size()-1; i >= 0; i--) {

    Light l = (Light)lightList.get(i);
    
    if(l.counter > 300) { 
      lightList.remove(i);  
    }
  }
  
  /* ---------------------------------------------------------------------------- */
    
  // draw center
  /*
  rectMode(CENTER);
  fill(0);
  noStroke();
  rect(width/2,height/2,width,20);
  */
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    endRaw();
    dosave=false;
  }
  
  /* ---------------------------------------------------------------------------- */
  
}

void keyPressed() 
{
  if (key == 's') 
  { 
    dosave = true;
  }
}
