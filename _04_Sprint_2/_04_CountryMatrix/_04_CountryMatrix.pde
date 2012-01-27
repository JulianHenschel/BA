import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

Kuler            k;
KulerTheme[]     kt;

Matrix m;
Matrix m2;

boolean    dosave = false;

void setup() {
  
  size(600,800);
  smooth();
  
  k = new Kuler(this);
  k.setKey("D8499719CCFCD92F468F2BADDAEA4BDC");
  k.setNumResults(1);
  
  kt = k.search("fiji", "title");
  m = new Matrix(0,width,kt[0]);
  
  //kt = k.search("fiji", "title");
  //m2 = new Matrix(width/5,width-width/5,kt[0]);
  
}

void draw() {
  
  if(dosave) {
    
    beginRecord(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
    noStroke();
    fill(255);
    rect(0,0,width,height);
    
  }
  
  background(255);
  
  m.draw();
  //m2.draw();
  
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
