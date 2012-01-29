import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

ArrayList     cl;
int           id = 0;
boolean       dosave = false;

Kuler         k;
KulerTheme[]  kt;

int           darkestColor;
int           lightestColor;

String        country = "Germany";

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
    
}

void draw() {
  
  if(dosave) {
    
    beginRecord(PDF, "output/"+country+"-"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
    noStroke();
    fill(darkestColor);
    rect(0,0,width,height);
    
  }
  
  background(darkestColor);
  
  for(int i = 0; i < cl.size(); i++) {
    
    Connect c = (Connect)cl.get(i);
    c.draw();
  }
  
  if(dosave) {
    endRecord();
    dosave=false;
  }
  
  noLoop();
  
}

void mouseClicked() {
 
  cl.add(new Connect(mouseX,mouseY,id)); 
  
  id++;
  
  loop();
}

void keyPressed() {

  if (key == 'r') {
    cl.clear();
    background(0);
    loop();
  }
  
  if (key == 's') { 
    dosave = true;
    loop();
  } 
  
}
