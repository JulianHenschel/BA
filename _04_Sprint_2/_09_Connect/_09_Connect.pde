import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

int           id = 0;
int           curCountry = 0;

boolean       dosave = true;
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

float         totalRenderedLines, totalRenderedKnots;

void setup() {
  
  /* ---------------------------------------------------------------------------- */
  
  size(595,842);
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
  
  float xCount = map(space, 0, maxSpace, 0, width);
  float yCount = map(space, 0, maxSpace, 0, height);
  
  float pointCount = map(space, 0, maxSpace, 5, 25);
  float lineCount = map(population, 0, maxPopulation, 100, 1000);
  
  totalRenderedKnots += pointCount;
  
  /*
  println("Mapped spacePop count: "+pointCount);
  println("Mapped line count: "+lineCount);
  println("x-range: "+xCount);
  */
  
  println("render: "+csv[curCountry][0]);
  
  /* ---------------------------------------------------------------------------- */
  
  float multFactor = 7;
  
  for(int i = 0; i < (int)pointCount; i++) 
  {
    cl.add(new Connect(
                       random(-xCount*multFactor,xCount*multFactor), random(-yCount*multFactor,yCount*multFactor),
                       id,
                       (int)random(lineCount-(lineCount/multFactor),lineCount+(lineCount/multFactor)) ) ); 
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
  
  pushMatrix();
  translate(width/2,height/2);
  
  for(int i = 0; i < cl.size(); i++) 
  {  
    Connect c = (Connect)cl.get(i);
    c.draw();
  }
  
  popMatrix();
    
  /* ---------------------------------------------------------------------------- */
  
  drawTextInformations();
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    endRecord();
    //dosave=false;
  }
  
  /* ---------------------------------------------------------------------------- */
  
  //noLoop();
  
  /* ---------------------------------------------------------------------------- */
  
  
  curCountry++;
    
  if(curCountry > csv.length-1) 
  {
    
    println("***done***");
    println("rendered lines: "+ totalRenderedLines);
    println("rendered knots: "+ totalRenderedKnots);
    
    exit();
  }
  
  
  /* ---------------------------------------------------------------------------- */
  
}

void drawTextInformations() {
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  textAlign(LEFT);
  
  // poster title
  textSize(8);
  fill(0);
  text("European diversity".toUpperCase(), 30, height-54);
  
  // poster text
  textSize(6);
  fill(0);
  String txt = "This poster is dynamically generated from this country’s demographics. It interprets visually the unique mood by color, population size and area to present the diversity of Europe to the viewer.";
  text(txt.toUpperCase(), 130, height-60, 230, 100);
  
  myFont = loadFont("MyriadPro-Bold-48.vlw");
  textFont(myFont);
  
  // country name
  textSize(14);
  fill(darkestColor);
  text(csv[curCountry][0].toUpperCase(), 30, height-39);
  
  //drawStatistic(130, height-45, 70, 10, Float.parseFloat(csv[curCountry][2]), maxPopulation, "Polulation");
  //drawStatistic(210, height-45, 70, 10, Float.parseFloat(csv[curCountry][1]), maxSpace, "Space");
  
}

void drawStatistic(float x, float y, float w, float h, float v, float vMax, String title) {
  
  noStroke();
  
  fill(200);
  rect(x,y,w,h);
  
  float mappedWidth = map(v,0,vMax,0,w);
  
  fill(darkestColor);
  rect(x,y,mappedWidth,h);
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  fill(100);
  
  textAlign(LEFT);
  textSize(8);
  text(title.toUpperCase(), x, y+15, w, 50);
  
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
