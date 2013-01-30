import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

Gradient g;

Kuler         k;
KulerTheme[]  kt;

color[]       cl;

boolean       dosave = false;

int           darkestColor;
int           lightestColor;

String        country = "Denmark";

void setup() {
  
  size(600,800);
  smooth();
  
  k = new Kuler(this);
  k.setKey(kulerAPIKey);
  k.setNumResults(1);
  
  kt = k.search(country, "title");
  
  darkestColor = kt[0].getDarkest();
  lightestColor = kt[0].getLightest();
    
  cl = new color[kt[0].totalSwatches()];
  
  for(int i = 0; i < cl.length; i++) 
  {
    cl[i] = kt[0].getColor(i);
  }
  
  g = new Gradient(this, cl, height);

}

void draw() {
  
  if(dosave) 
  {
    beginRecord(PDF, "output/"+country+"-"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
  }
  
  for (int i = 0; i < g.totalSwatches(); i++) 
  {
    stroke(g.getColor(i));
    line(0, i, width, i);
  }
  
  if(dosave) 
  {
    endRecord();
    dosave=false;
  }
  
  noLoop();
  
}

void keyPressed() 
{
  if (key == 'r') 
  {
    background(0);
    loop();
  }
  
  if (key == 's') 
  { 
    dosave = true;
    loop();
  } 
}
