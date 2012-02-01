import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

Kuler         k;
KulerTheme[]  kt;
Matrix        m;
Matrix        m2;

PFont         myFont;
boolean       dosave = false;
String        country = "Germany";

int           darkestColor;
int           lightestColor;

void setup() {
  
  size(600,800);
  smooth();
  
  k = new Kuler(this);
  k.setKey(kulerAPIKey);
  k.setNumResults(1);
  
  kt = k.search(country, "title");
  m = new Matrix(0,width,kt[0]);
  
  //kt = k.search("fiji", "title");
  //m2 = new Matrix(width/5,width-width/5,kt[0]);
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
}

void draw() {
  
  if(dosave) {
    
    beginRecord(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
    noStroke();
    fill(255);
    rect(0,0,width,height);
    
  }
  
  background(lightestColor);
  
  textSize(118);
  fill(darkestColor);
  textAlign(CENTER);
  text(country.toUpperCase(), width/2, height/2);
  
  m.draw();
  
  if(dosave) {
    endRecord();
    dosave=false;
  }
  
  noLoop();
  
}


void keyPressed() {
  
  if (key == ' ') {
    loop();
  }
  if (key == 's') { 
    dosave=true;
    loop();
  }
}
