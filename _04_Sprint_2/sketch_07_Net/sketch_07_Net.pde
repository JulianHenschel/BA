import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

Net n;
Kuler            k;
KulerTheme[]     kt;

int              darkestColor;
int              lightestColor;

String           country = "germany";

void setup() {
  
  size(600,800);
  smooth();
  
  k = new Kuler(this);
  k.setKey(kulerAPIKey);
  k.setNumResults(1);
  
  kt = k.search(country, "title");
  
  darkestColor = kt[0].getDarkest();
  lightestColor = kt[0].getLightest();
  
  n = new Net(kt[0]);
  
  background(lightestColor);
  
}

void draw() {
  
  fill(lightestColor,8);
  noStroke();
  rect(0,0,width,height);
  
  n.draw();
  n.rotation();
  
}
