import colorLib.calculation.*;
import colorLib.*;
import colorLib.webServices.*;
import processing.pdf.*;

Kuler            k;
KulerTheme[]     kt;

int              steps = 600;
int              darkestColor;
int              lightestColor;

String           country = "china";

boolean          dosave = false;

PFont            myFont;

void setup() {
  
  size(600,800);
  //smooth();
  
  noiseDetail(1);
  
  myFont = loadFont("MyriadPro-Regular-48.vlw");
  textFont(myFont);
  
  k = new Kuler(this);
  k.setKey("D8499719CCFCD92F468F2BADDAEA4BDC");
  k.setNumResults(1);
  
  kt = k.search(country, "title");
  
  kt[0].sortBySaturation();
  
  darkestColor = kt[0].getDarkest();
  lightestColor = kt[0].getLightest();
}

void draw() {
  
  float noiseMult = random(80,200);
  
  background(darkestColor);
  
  if(dosave) {
    
    beginRecord(PDF, "output/"+country+"-"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf");
    noStroke();
    fill(darkestColor);
    rect(0,0,width,height);
    
  }
  
  float noiseScale = 0.02;
  
  textSize(50);
  fill(lightestColor);
  textAlign(CENTER);
  text(country.toUpperCase(), width/2, height-80);
  
  float s = height/steps;
  
  for(int y = 50; y < height-250; y+=s) {
    
    noFill();
    strokeWeight(1);
    stroke(0);
    
    //beginShape();

    for(int x = 0; x < width; x++) {
            
      float noiseVal = noise(x*noiseScale, y*noiseScale);
      float ny = y+noiseVal*noiseMult;
      
      float col = map(noiseVal,0,0.4,0,4);
      stroke(kt[0].getColor((int)col));
      
      //if(x > width/6 && x < width-width/6) {
        point(x,ny);
      //}
            
      /*
      if(x == width/5) {
        line(0,ny,width/5,ny);      
      }
      
      if(x == width-width/5) {
        line(width-width/5,ny,width,ny);  
      }
      */
      
    }
    
    //endShape();
        
  }
  
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
