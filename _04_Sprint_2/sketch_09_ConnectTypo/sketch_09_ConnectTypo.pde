import processing.pdf.*;
import geomerative.*;

int           id = 0;
int           curCountry = 0;

boolean       dosave = false;
ArrayList     cl;

float         maxPopulation;
float         maxSpace;
float         maxSpacePop;

String        text = "0";

RFont         font;

void setup() {
  
  /* ---------------------------------------------------------------------------- */
  
  size(800,600);
  smooth();
  
  /* ---------------------------------------------------------------------------- */
  
  cl = new ArrayList();
  
  /* ---------------------------------------------------------------------------- */
  
  RG.init(this);
  font = new RFont("LTe52009.ttf", 430, RFont.CENTER);
  
  /* ---------------------------------------------------------------------------- */
  
}

void draw() {
  
  background(255);
  
  /* ---------------------------------------------------------------------------- */
  
  cl.clear();
  
  /* ---------------------------------------------------------------------------- */
  
  RGroup grp = font.toGroup(text);
      
  RCommand.setSegmentLength(10);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  
  grp = grp.toPolygonGroup();
  
  RPoint[] pnts = grp.getPoints();
  
  for ( int i = 1; i < pnts.length; i++ ) {
    cl.add(new Connect(pnts[i].x+(width/2), pnts[i].y+(height-100),i,(int)random(1,1)));
  }
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    beginRecord(PDF, "output/"+text+"-"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
  }
  
  /* ---------------------------------------------------------------------------- */
  
  for(int i = 0; i < cl.size(); i++) 
  {  
    Connect c = (Connect)cl.get(i);
    c.draw();
  }
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    endRecord();
    dosave=false;
  }
  
  /* ---------------------------------------------------------------------------- */
  
  noLoop();
  
  /* ---------------------------------------------------------------------------- */
  
}

void keyPressed() 
{
  
  /* ---------------------------------------------------------------------------- */
  
  if (key == 's') 
  { 
    dosave = true;
    loop();
  } 
}
