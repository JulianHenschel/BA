import processing.pdf.*;
import toxi.geom.*;
import toxi.processing.*;
import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;

Kuler            k;
KulerTheme[]     kt;
ToxiclibsSupport gfx;
Line2D[]         ls;

int       count = 20;
boolean   dosave = false;
ArrayList al;
String    country = "fiji";
PFont     myFont;

void setup() {
  
  size(600,800);
  smooth();
  
  /* ---------------------------------------------------------------------------- */
  
  k = new Kuler(this);
  k.setKey("D8499719CCFCD92F468F2BADDAEA4BDC");
  k.setNumResults(1);
  kt = k.search(country, "title");
  
  /* ---------------------------------------------------------------------------- */

  gfx = new ToxiclibsSupport(this);
  
  /* ---------------------------------------------------------------------------- */
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  /* ---------------------------------------------------------------------------- */
  
  al = new ArrayList();
  
  /* ---------------------------------------------------------------------------- */
  
  ls = new Line2D[count];
  
  for(int i = 0; i < count; i++) {
    ls[i] = new Line2D(new Vec2D(random(0,width),random(0,height)),new Vec2D(random(0,width),random(0,height)));
  }
  
  /* ---------------------------------------------------------------------------- */
  
}
 
void draw() {
  
  int darkestColor = kt[0].getDarkest();
  int lightestColor = kt[0].getLightest();
  
  /* ---------------------------------------------------------------------------- */
  
  background(lightestColor);
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) {
    
    beginRecord(PDF, "output/"+country+"-"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
    noStroke();
    fill(lightestColor);
    rect(0,0,width,height);
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  for(int i = 0; i < count; i++) {
  
    Line2D l1 = ls[i];
   
    for(int j = 0; j < count; j++) {
    
      if(j == i) {
        break;
      }
     
      Line2D l2 = ls[j];
      
      Line2D.LineIntersection isec = l1.intersectLine(l2);
      
      if (isec.getType() == Line2D.LineIntersection.Type.INTERSECTING) {
        Vec2D pos=isec.getPos();
        al.add(new PVector(pos.x,pos.y));
      }
    } 
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  // draw areas
  for(int i = 0; i < al.size(); i++) {
    
    PVector p = (PVector)al.get(i);
    
    PVector p2 = (PVector)al.get((int)random(0,al.size()));
    PVector p3 = (PVector)al.get((int)random(0,al.size()));
    
    int col = kt[0].getColor((int)random(0,4));
        
    fill(col,200);
    noStroke();
    stroke(darkestColor,100);
    strokeWeight(.5);
    triangle(p.x,p.y,p2.x,p2.y,p3.x,p3.y);
        
    for (int j = al.size()-1; j >= 0; j--) {
    
      PVector a = (PVector)al.get(j);
      
      if(a.x == p.x && a.y == p.y) {
        al.remove(j);  
      }
    }
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  // draw strokes
  /*
  for(int i = 0; i < count; i++) {
    gfx.line(ls[i]);
  }
  */
  
  /* ---------------------------------------------------------------------------- */
  
  textSize(50);
  fill(lightestColor);
  textAlign(CENTER);
  text(country.toUpperCase(), width/2, height/2);
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) {
    endRecord();
    dosave=false;
  }
  
  /* ---------------------------------------------------------------------------- */
  
  noLoop();
  
}

void keyPressed() {

  if (key == ' ') {
    
    loop();
    
    for(int i = 0; i < count; i++) {
      ls[i] = new Line2D(new Vec2D(random(0,width),random(0,height)),new Vec2D(random(0,width),random(0,height)));
    }
    
    al.clear();
  }
  
  /* ---------------------------------------------------------------------------- */
  
  if (key == 's') { 
    dosave=true;
    loop();
  }
  
}
