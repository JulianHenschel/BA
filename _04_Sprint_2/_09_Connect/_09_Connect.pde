import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

int           id = 0;
int           curCountry = 0;

boolean       dosave = false;
ArrayList     cl;
String[][]    csv;

PFont         myFont;

Kuler         k;
KulerTheme[]  kt;

int           darkestColor;
int           lightestColor;

float         maxPopulation, totalPop;
float         maxSpace, totalSpace;
float         maxSpacePop;

void setup() {
  
  /* ---------------------------------------------------------------------------- */
  
  size(600,800);
  smooth();
  
  /* ---------------------------------------------------------------------------- */
  
  cl = new ArrayList();
  
  /* ---------------------------------------------------------------------------- */
  
  k = new Kuler(this);
  k.setKey(kulerAPIKey);
  k.setNumResults(1);
  
  /* ---------------------------------------------------------------------------- */
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  /* ---------------------------------------------------------------------------- */
  
  loadCSV();
  
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
  
  /*
  println("*** max population: "+maxPopulation);
  println("*** max space: "+maxSpace);
  println("*** max spacePop: "+maxSpacePop);
  */
  
  /* ---------------------------------------------------------------------------- */
  
}

void draw() {
  
  cl.clear();
  
  /* ---------------------------------------------------------------------------- */
  
  kt = k.search(csv[curCountry][0], "title");
  
  darkestColor = kt[0].getDarkest();
  lightestColor = kt[0].getLightest();
  
  /* ---------------------------------------------------------------------------- */
  
  float population = Float.parseFloat(csv[curCountry][2]);
  float space = Float.parseFloat(csv[curCountry][1]);
  float spacePop = Float.parseFloat(csv[curCountry][3]);
  
  float xCount = map(population, 0, maxPopulation, 0, width);
  float yCount = map(population, 0, maxPopulation, 0, height);
  
  float pointCount = map(space, 0, maxSpace, 10, 25);
  float lineCount = map(spacePop, 0, maxSpacePop, 100, 600);
  
  println("Mapped spacePop count: "+pointCount);
  println("Mapped line count: "+lineCount);
  println("x-range: "+xCount);
  
  /* ---------------------------------------------------------------------------- */
  
  for(int i = 0; i < (int)pointCount; i++) 
  {
    cl.add(new Connect(
                       random(-width/2,width+(width/2)), random(-height/2,height+height/2),
                       id,
                       (int)random(lineCount-(lineCount/5),lineCount+(lineCount/5)) ) ); 
    id++;
  }
    
  /* ---------------------------------------------------------------------------- */
  
  background(255);
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    beginRecord(PDF, "output/"+csv[curCountry][0]+"-"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
  }
  
  /* ---------------------------------------------------------------------------- */
  
  for(int i = 0; i < cl.size(); i++) 
  {  
    Connect c = (Connect)cl.get(i);
    c.draw();
  }
    
  /* ---------------------------------------------------------------------------- */
  
  drawTextInformations();
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    endRecord();
    dosave=false;
  }
  
  /* ---------------------------------------------------------------------------- */
  
  noLoop();
  
  /* ---------------------------------------------------------------------------- */
  
  /*
  curCountry++;
    
  if(curCountry > csv.length-1) 
  {
    exit();
  }
  */
  
  /* ---------------------------------------------------------------------------- */
  
}

void drawTextInformations() {
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  textAlign(LEFT);
  
  // poster title
  textSize(8);
  fill(0);
  text("Forms of Europe".toUpperCase(), 30, height-64);
  
  // poster text
  textSize(6);
  fill(0);
  String txt = "Dieses Poster wurde vollkommen dynamisch aus demografischen Daten dieses Landes generiert. Es soll die Einzigartigkeit des Landes und anhand der Farbstimmung Gefühl und Stimmung der Bevölkerung darstellen.";
  text(txt.toUpperCase(), 130, height-70, 230, 100);
  
  myFont = loadFont("MyriadPro-Bold-48.vlw");
  textFont(myFont);
  
  // country name
  textSize(14);
  fill(darkestColor);
  text(csv[curCountry][0].toUpperCase(), 30, height-49);
  
  drawStatistic(130, height-35, 70, 10, Float.parseFloat(csv[curCountry][2]), maxPopulation);
  drawStatistic(210, height-35, 70, 10, Float.parseFloat(csv[curCountry][1]), maxSpace);
  
}

void drawStatistic(float x, float y, float w, float h, float v, float vMax) {
  
  noStroke();
  
  fill(200);
  rect(x,y,w,h);
  
  float mappedWidth = map(v,0,vMax,0,w);
  
  fill(darkestColor);
  rect(x,y,mappedWidth,h);
  
}

/* ---------------------------------------------------------------------------- */

void keyPressed() 
{
  
  if (key == ' ') 
  {  
    loop();
    
    curCountry++;
    
    if(curCountry > csv.length-1) 
    {
      exit();
    }
  }
  
  /* ---------------------------------------------------------------------------- */
  
  if (key == 's') 
  { 
    dosave = true;
    loop();
  } 
}
