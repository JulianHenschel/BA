import processing.pdf.*;
import processing.opengl.*;
import generativedesign.*;

int       nodeCount = 3000;

Node[]    nodeList = new Node[nodeCount];
Attractor attr = new Attractor();

boolean   dosave = false;
color     bg = color(255);

void setup() {
  
  size(1024,768,OPENGL);
  
  for(int i = 0; i < nodeCount; i++) {
  
    nodeList[i] = new Node(0,random(0,height)); 
    
    nodeList[i].maxVelocity = random(4,8);
    nodeList[i].setBoundary(0,0,width+10,height) ;
    
    nodeList[i].velocity.x = random(1,5);
    nodeList[i].velocity.y = random(0);
    nodeList[i].velocity.y = random(-1,1);
    
    nodeList[i].damping = 0.001;
    
  }
    
  attr.radius = 300;
  attr.mode = 2;
  attr.strength = -5;
   
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
    
    displayVector(nodeList[i].velocity,nodeList[i].x,nodeList[i].y,5);
    
    ellipseMode(CENTER);
    
    noFill();
    ellipse(nodeList[i].x,nodeList[i].y,10,10);  
    
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

