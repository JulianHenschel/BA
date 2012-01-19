import processing.pdf.*;
import processing.opengl.*;
import generativedesign.*;

int       nodeCount = 2200;
int       attrRadius = 150;
int       attraction = -50;

boolean   dosave = false;
color     bg = color(0);
PFont     myFont;

String    txt = "YOU FRIGHTEN THE ANIMALS. HOLD ON!";

Node[]    nodeList = new Node[nodeCount];
Attractor attr = new Attractor();

void setup() {
  
  size(1200,800,OPENGL);
  
  for(int i = 0; i < nodeCount; i++) {
  
    nodeList[i] = new Node(random(0,width),random(0,height)); 
    
    nodeList[i].maxVelocity = random(3,8);
    nodeList[i].setBoundary(0,0,width,height) ;
    
    nodeList[i].velocity.x = random(1,4);
    nodeList[i].velocity.y = random(0);
    
    nodeList[i].damping = 0.001;
    
  }
  
  myFont = loadFont("MyriadPro-Bold-48.vlw");
  
  attr.radius = attrRadius;
  attr.mode = 1;
  attr.strength = attraction;
   
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
  
  for(int i = 0; i < nodeCount; i++) 
  {
    
    nodeList[i].update();
    
    ellipseMode(CENTER);
        
    strokeWeight(1);
    noFill();
    
    float distance = dist(mouseX,mouseY,nodeList[i].x,nodeList[i].y);
    
    if(distance < attrRadius*2) 
    {
      
      float c = constrain(distance-(attrRadius/2),0,255);
      float c2 = map(c,0,255,255,50);
      stroke(c2);
      
      if(distance < attrRadius/1.5) {
        stroke(255,0,0);  
      }
      
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

void displayVector(PVector v, float x, float y, float scayl) 
{
  
  float arrowsize = 4;
    
  pushMatrix();
  translate(x,y);
  rotate(v.heading2D());
  
  float len = v.mag()*scayl;
    
  /* arrows
  line(0,0,len,0);
  line(len,0,len-arrowsize,+arrowsize);
  line(len,0,len-arrowsize,-arrowsize);
  */
  
  line(0,0,-len,0);
  
  popMatrix();
    
}

void mouseClicked() {
  
  attraction *= -1;
  attr.strength = attraction;
    
}

