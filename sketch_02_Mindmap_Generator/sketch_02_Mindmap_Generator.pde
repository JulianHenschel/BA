import processing.pdf.*;

ArrayList mm;
boolean   dosave = false;

void setup() {
 
  size(800,800);
  smooth();
     
  mm = new ArrayList();
  mm.add(new MindMap(width/2,height/2));
  
}

void draw() {
  
  background(255);
  
  if(dosave) {
    beginRecord(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 
  }
  
  for (int i = 0; i < mm.size(); i++) {
    
    MindMap m = (MindMap) mm.get(i);
    
    m.draw();
    
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
