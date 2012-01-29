import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

Kuler            k;
KulerTheme[]     kt;

String           country = "germany";

ArrayList dl;

Drawing d;

void setup() {
  
  size(600,800);
  smooth();
  
  k = new Kuler(this);
  k.setKey("D8499719CCFCD92F468F2BADDAEA4BDC");
  k.setNumResults(1);
  
  kt = k.search(country, "title");
  
  d = new Drawing(width/2,height/2,kt[0]);
  
  background(kt[0].getLightest());
  
  dl = new ArrayList();
  
  int s = 1;
  
  for(int x = 50; x < width-50; x+= s) {
    dl.add(new Drawing(x,0,kt[0]));  
  }
  
  //dl.add(new Drawing(width/2,0,kt[0]));
  
}

void draw() {
  
  for(int i = 0; i < dl.size(); i++) {
    
    Drawing d = (Drawing)dl.get(i);
  
    d.draw();
  }
  
  //noLoop();
  
}

void mouseClicked() {
  
  dl.add(new Drawing(mouseX,mouseY,kt[0]));
  
}
