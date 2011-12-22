import processing.pdf.*;

ArrayList pList;
boolean   dosave = false;

void setup() {
  
  size(900,500);
  smooth();
  
  pList = new ArrayList();
  
  pList.add(new Process(0+(width/4),height/2, width-(width/4),height/2));
  
}

void draw() {
  
  if(dosave) {
    beginRecord(PDF, "output/genius_"+frameCount+".pdf"); 
  }
  
  background(255);
  
  for(int i = 0; i < pList.size(); i++) {
    
    Process p = (Process) pList.get(i);
    p.draw();
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
    dosave = true;
    loop();
  }
  
}
