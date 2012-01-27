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
Palette[]        pl;

String[][] csv;
int        count = 20;
boolean    dosave = false;
ArrayList  al;
PFont      myFont;
int        curCountry = 0;

void setup() {
  
  size(600,849);
  smooth();
  
  /* ---------------------------------------------------------------------------- */
  
  k = new Kuler(this);
  k.setKey("D8499719CCFCD92F468F2BADDAEA4BDC");
  k.setNumResults(1);
  
  
  /* ---------------------------------------------------------------------------- */

  gfx = new ToxiclibsSupport(this);
  
  /* ---------------------------------------------------------------------------- */
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  /* ---------------------------------------------------------------------------- */
  
  loadCSV();
  
  pl = new Palette[csv.length];
  
  for(int i = 0; i < csv.length; i++) 
  {
    kt = k.search(csv[i][0], "title");
    
    int count = k.getNumResults();
    if(count > 0) 
    {
      pl[i] = kt[0];
    }
  }
  
  
  
  /* ---------------------------------------------------------------------------- */
  
  al = new ArrayList();
  
  /* ---------------------------------------------------------------------------- */
  
}
 
void draw() {
  
  /* ---------------------------------------------------------------------------- */
  
  // define database
  
  //float w = map(Integer.parseInt(csv[curCountry][1]),0,674843,0,width);
  //float h = map(Integer.parseInt(csv[curCountry][1]),0,674843,0,height);
  
  //float c = map(Integer.parseInt(csv[curCountry][3]),0,229,0,100);
  
  count = 50;
  
  ls = new Line2D[count];
  
  for(int i = 0; i < count; i++) {
    ls[i] = new Line2D(new Vec2D(random(0,width),random(0,height)),new Vec2D(random(0,width),random(0,height)));
  }
  
  /* ---------------------------------------------------------------------------- */
  
  int darkestColor = pl[curCountry].getDarkest();
  int lightestColor = pl[curCountry].getLightest();
  
  /* ---------------------------------------------------------------------------- */
  
  background(lightestColor);
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) {
    
    beginRecord(PDF, "output/"+csv[curCountry][0]+"-"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
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
    
    int col = pl[curCountry].getColor((int)random(0,4));
        
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
  text(csv[curCountry][0].toUpperCase(), width/2, height/2);
  
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
    
    curCountry++;
    
    if(curCountry > csv.length-1) {
      curCountry = 0;
    }
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  if (key == 's') { 
    dosave=true;
    loop();
  }
  
}
