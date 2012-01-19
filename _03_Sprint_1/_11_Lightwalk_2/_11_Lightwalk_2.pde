import processing.opengl.*;
import processing.pdf.*;

int       lightWidth;
boolean   dosave = false;
ArrayList lightList;

void setup() {
  
  size(1200,768,OPENGL);
  
  frameRate(60);
    
  lightList = new ArrayList();
  
}

void draw() {
  
  background(0);
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {

    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 

    pdf.fill(0);
    pdf.rect(0,0, width,height);
    
  }
  
  /* ---------------------------------------------------------------------------- */
    
  // add new light
  lightList.add(new Light(mouseX,mouseY));
  
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
    
    if(l.counter > 200) { 
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
  
}

void keyPressed() 
{
  if (key == 's') 
  { 
    dosave = true;
  }
}
