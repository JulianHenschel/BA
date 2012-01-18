import processing.pdf.*;
import processing.opengl.*;
import generativedesign.*;

int       nodeCount = 2000;

Node[]    nodeList = new Node[nodeCount];
Attractor attr = new Attractor();
int       attrRadius = 150;
boolean   dosave = false;
color     bg = color(0);
PFont     myFont;

String    txt = "YOU FRIGHTEN THE ANIMALS. HOLD ON!";

void setup() {
  
  size(1024,768,OPENGL);
  
  for(int i = 0; i < nodeCount; i++) {
  
    nodeList[i] = new Node(0,random(0,height)); 
    
    nodeList[i].maxVelocity = random(4,8);
    nodeList[i].setBoundary(0,0,width,height) ;
    
    nodeList[i].velocity.x = random(1,5);
    nodeList[i].velocity.y = random(0);
    nodeList[i].velocity.y = random(-1,1);
    
    nodeList[i].damping = 0.001;
    
  }
  
  myFont = loadFont("MyriadPro-Bold-48.vlw");
  
  attr.radius = attrRadius;
  attr.mode = 1;
  attr.strength = -50;
   
}

void draw() {
  
  /* ---------------------------------------------------------------------------- */

  if(dosave) 
  {
    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 

    pdf.fill(bg);
    pdf.rect(0,0, width,height);
  }
  
  /* ---------------------------------------------------------------------------- */
  
  //background(bg);
  
  fill(bg);
  noStroke();
  rect(0,0,width,height);
  
  /* ---------------------------------------------------------------------------- */
  
  attr.x = mouseX;
  attr.y = mouseY;
  
  fill(255);
  textSize(22);
  
  textAlign(CENTER);
  text(txt,attr.x-(150/2),attr.y-75,150,140);
  
  /* ---------------------------------------------------------------------------- */
  
  for(int i = 0; i < nodeCount; i++) {
    
    nodeList[i].update();
    
    ellipseMode(CENTER);
        
    strokeWeight(1);
    noFill();
    
    float distance = dist(mouseX,mouseY,nodeList[i].x,nodeList[i].y);
    
    if(distance < attrRadius+(attrRadius*1)) {
      
      float c = constrain(distance-(attrRadius/2),0,255);
      float c2 = map(c,0,255,255,50);
      stroke(c2);
      
      displayVector(nodeList[i].velocity,nodeList[i].x,nodeList[i].y,5);
      ellipse(nodeList[i].x,nodeList[i].y,10,10);  
      
    }else {

      stroke(50);
      
      displayVector(nodeList[i].velocity,nodeList[i].x,nodeList[i].y,5);
      ellipse(nodeList[i].x,nodeList[i].y,10,10);
      
    }
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  attr.attract(nodeList);
  
   /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    endRaw();
    dosave=false;
  }
  
   /* ---------------------------------------------------------------------------- */
  
  noSmooth();
  
}

void displayVector(PVector v, float x, float y, float scayl) {
    
  float arrowsize = 4;
    
  pushMatrix();
  translate(x,y);
  rotate(v.heading2D());
  
  float len = v.mag()*scayl;
    
  line(0,0,len,0);
  line(len,0,len-arrowsize,+arrowsize);
  line(len,0,len-arrowsize,-arrowsize);
    
  popMatrix();
    
} 

void keyPressed() 
{
  if (key == 's') 
  { 
    dosave = true;
    smooth();
  }
}

