import processing.pdf.*;
import processing.opengl.*;
import generativedesign.*;

int       nodeCount = 20000;

Node[]    nodeList = new Node[nodeCount];
Attractor attr = new Attractor();

boolean   dosave = false;
color     bg = color(255);

void setup() {
  
  size(1024,768,OPENGL);
  
  for(int i = 0; i < nodeCount; i++) {
  
    nodeList[i] = new Node(0,random(0,height)); 
    
    nodeList[i].maxVelocity = random(4,8);
    nodeList[i].setBoundary(-10,0,width+10,height) ;
    
    nodeList[i].velocity.x = random(1,5);
    nodeList[i].velocity.y = random(0);
    
    nodeList[i].damping = 0.001;
    
  }
  
  attr.radius = 200;
  attr.mode = 1;
  attr.strength = -100;
   
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
  
  background(bg);
  
  /* ---------------------------------------------------------------------------- */
  
  attr.x = mouseX;
  attr.y = mouseY;
  
  /* ---------------------------------------------------------------------------- */
  
  for(int i = 0; i < nodeCount; i++) {
    
    nodeList[i].update();
    
    if(nodeList[i].x > width) {
      nodeList[i].x = 0;
    }
    
    stroke(0);
    strokeWeight(1);
    
    /*
    if(i > 0) {      
      line(nodeList[i].x,nodeList[i].y,nodeList[i-1].x,nodeList[i-1].y);
    }
    */
    
    noFill();
    point(nodeList[i].x,nodeList[i].y);  
    
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
  
}

void keyPressed() 
{
  if (key == 's') 
  { 
    dosave = true;
  }
}

