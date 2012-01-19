
int     lightSteps = 600;
int     lightWidth;
Light[] lightList;

void setup() {
  
  size(1200,768);
  
  lightWidth = width/lightSteps;
  
  lightList = new Light[lightSteps];
  
  for(int i = 0; i < lightList.length; i++) {
    lightList[i] = new Light(i*lightWidth+(lightWidth/2),height/2);
  }
  
}

void draw() {
  
  background(0);
  
  float area = (int)map(mouseX,0,width,0,lightSteps);
        
  for(int i = 0; i < lightList.length; i++) 
  {
    if(area == i) 
    {
      lightList[i].rHeight = height+1;
    }
      
    lightList[i].update();  
    lightList[i].draw();
  }
  
  // draw center
  
  rectMode(CENTER);
  fill(200);
  stroke(0,100);
  rect(width/2,height/2,width,20);
  
  noStroke();
  fill(0,100);
  rect(width/2,height/2-10,width,5);
  rect(width/2,height/2+11,width,5);
  
}
