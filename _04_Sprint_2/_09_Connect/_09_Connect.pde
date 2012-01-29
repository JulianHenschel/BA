import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

ArrayList     cl;
int           id = 0;
boolean       dosave = false;

PFont         myFont;

Kuler         k;
KulerTheme[]  kt;

int           darkestColor;
int           lightestColor;

String        country = "Sweden";

void setup() {
  
  size(600,800);
  smooth();
  
  cl = new ArrayList();
  
  k = new Kuler(this);
  k.setKey("D8499719CCFCD92F468F2BADDAEA4BDC");
  k.setNumResults(1);
  
  kt = k.search(country, "title");
  
  darkestColor = kt[0].getDarkest();
  lightestColor = kt[0].getLightest();
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  /*
  int steps = 10;
  
  for(int x = steps; x <= width-steps; x+=steps) {
   for(int y = steps; y <= height-steps; y+=steps) {
     cl.add(new Connect(x,y,id)); 
     id++;
    }
  }
  */
  
  for(int i = 0; i < 10; i++) 
  {
    cl.add(new Connect(random(-width/2,width+width/2),random(-height/2,height+height/2),id,(int)random(200,500))); 
    id++;
  }
    
}

void draw() {
  
  background(darkestColor);
  
  if(dosave) 
  {
    beginRecord(PDF, "output/"+country+"-"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
  }
  
  for(int i = 0; i < cl.size(); i++) 
  {  
    Connect c = (Connect)cl.get(i);
    c.draw();
  }
  
  drawTextInformations();
  
  if(dosave) 
  {
    endRecord();
    dosave=false;
  }
  
  noLoop();
  
}

void drawTextInformations() {
  
  textSize(50);
  fill(lightestColor);
  textAlign(LEFT);
  text(country.toUpperCase(), 50, height-50);
  
}

void mouseClicked() 
{
  
  /*
  cl.add(new Connect(mouseX,mouseY,id)); 
  
  id++;
  
  loop();
  */
}

void keyPressed() 
{
  if (key == 'r') 
  {
    cl.clear();
    background(0);
    loop();
  }
  
  if (key == 's') 
  { 
    dosave = true;
    loop();
  } 
}
