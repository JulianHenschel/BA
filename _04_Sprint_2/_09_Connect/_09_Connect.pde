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

float         maxPopulation = 0;
float         maxSpace = 0;
float         maxSpacePop = 0;

void setup() {
  
  /* ---------------------------------------------------------------------------- */
  
  size(600,800);
  smooth();
  
  /* ---------------------------------------------------------------------------- */
  
  cl = new ArrayList();
  
  /* ---------------------------------------------------------------------------- */
  
  k = new Kuler(this);
  k.setKey("D8499719CCFCD92F468F2BADDAEA4BDC");
  k.setNumResults(1);
  
  /* ---------------------------------------------------------------------------- */
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  /* ---------------------------------------------------------------------------- */
  
  loadCSV();
  
  /* ---------------------------------------------------------------------------- */
  
  for(int i = 0; i < csv.length; i++) 
  {
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
  
  /*
  println("search color for: "+csv[curCountry][0]);
  */
  
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
                       random(-width/2,width+(width/2)),
                       random(-height/2,height+height/2),
                       id,
                       (int)random(lineCount-(lineCount/5),lineCount+(lineCount/5)))
                       ); 
    id++;
  }
    
  /* ---------------------------------------------------------------------------- */
  
  background(120);
  
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
  
  //drawTextInformations();
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    endRecord();
    dosave=false;
  }
  
  /* ---------------------------------------------------------------------------- */
  
  noLoop();
  
  /* ---------------------------------------------------------------------------- */
  
}

void drawTextInformations() {
  
  textSize(50);
  fill(darkestColor);
  textAlign(LEFT);
  text(csv[curCountry][0].toUpperCase(), 50, height-50);
  
}

void keyPressed() 
{
  if (key == ' ') 
  {  
    curCountry++;
    
    if(curCountry > csv.length-1) 
    {
      curCountry = 0;
    }

    loop();
  }
  
  if (key == 's') 
  { 
    dosave = true;
    loop();
  } 
}
