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
int        count = 10;
boolean    dosave = false;
ArrayList  al;
PFont      myFont;
int        curCountry = 0;

float         maxPopulation, totalPop;
float         maxSpace, totalSpace;
float         maxSpacePop;

void setup() {
  
  size(600,849);
  smooth();
  
  /* ---------------------------------------------------------------------------- */
  
  k = new Kuler(this);
  k.setKey(kulerAPIKey);
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
  
  for(int i = 0; i < csv.length; i++) 
  {
    
    //totals
    totalPop += Float.parseFloat(csv[i][2]);
    totalSpace += Float.parseFloat(csv[i][1]);
    
    if(maxPopulation < Float.parseFloat(csv[i][2])) 
    {
      maxPopulation = Float.parseFloat(csv[i][2]);
    }
    if(maxSpace < Float.parseFloat(csv[i][1])) 
    {
      maxSpace = Float.parseFloat(csv[i][1]);
    }
    if(maxSpacePop < Float.parseFloat(csv[i][3])) 
    {
      maxSpacePop = Float.parseFloat(csv[i][3]);
    }
  }
  
}
 
void draw() {
    
  /* ---------------------------------------------------------------------------- */
    
  // define database
  
  float population = Float.parseFloat(csv[curCountry][2]);
  float space = Float.parseFloat(csv[curCountry][1]);
  float spacePop = Float.parseFloat(csv[curCountry][3]);
  
  float xCount = map(space, 0, maxSpace, 0, width);
  float yCount = map(space, 0, maxSpace, 0, height);
  
  float pointCount = map(space, 0, maxSpace, 5, 50);
  float lineCount = map(population, 0, maxPopulation, 100, 1000);
  
  count = (int)pointCount;
    
  ls = new Line2D[count];
  
  float multFactor = 2;
  
  for(int i = 0; i < count; i++) {
    ls[i] = new Line2D(new Vec2D(random(-xCount*multFactor,xCount*multFactor), random(-yCount*multFactor,yCount*multFactor)),
                       new Vec2D(random(-xCount*multFactor,xCount*multFactor), random(-yCount*multFactor,yCount*multFactor)));
  }
  
  /* ---------------------------------------------------------------------------- */
  
  int darkestColor = pl[curCountry].getDarkest();
  int lightestColor = pl[curCountry].getLightest();
  
  /* ---------------------------------------------------------------------------- */
  
  background(lightestColor);
  //background(255);
  
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
  
  pushMatrix();
  translate(width/2,height/2);
  
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
    
    //textSize(i*10);
    //text(csv[curCountry][0].toUpperCase(), width/2, i*10);
       
    for (int j = al.size()-1; j >= 0; j--) {
    
      PVector a = (PVector)al.get(j);
            
      if(a.x == p.x && a.y == p.y) {
        al.remove(j);  
      }
    }
    
  }
  
  popMatrix();
  
  
  /* ---------------------------------------------------------------------------- */
  
  // draw strokes
  /*
  for(int i = 0; i < count; i++) {
    gfx.line(ls[i]);
  }
  */
  
  /* ---------------------------------------------------------------------------- */
  
  textSize(30);
  fill(darkestColor);
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
