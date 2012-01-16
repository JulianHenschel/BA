import processing.opengl.*;
import processing.pdf.*;
import SimpleOpenNI.*;

SimpleOpenNI context;

float        zoomF = 0.5f;
float        rotX = radians(180);
float        rotY = radians(0);

int          userCount;
int          steps = 10;

boolean      dosave = false;

color        bg = color(175,117,0);

void setup() {
  
  size(1024,768,P3D);
  //hint(ENABLE_OPENGL_4X_SMOOTH);
  
  /* ---------------------------------------------------------------------------- */
  
  context = new SimpleOpenNI(this);
   
  context.setMirror(false);

  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  // enable the scene, to get the floor
  context.enableScene();

  /* ---------------------------------------------------------------------------- */
  
  //smooth();  
  //perspective(radians(45), float(width)/float(height), 10, 150000);
      
}

void draw() {

  if(dosave) {

    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 

    //pdf.strokeJoin(MITER);
    //pdf.strokeCap(SQUARE);
    pdf.fill(bg);
    //pdf.noStroke();
    pdf.rect(0,0, width,height);
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  context.update();

  background(bg);
  
  /* ---------------------------------------------------------------------------- */
  
  pushMatrix();
  
  translate(width/2, height/2, 0);
  rotateX(rotX);
  //scale(zoomF);
    
  /* ---------------------------------------------------------------------------- */  
  
  int[]   depthMap = context.depthMap();
  int     index;
  PVector realWorldPoint;
    
  userCount = context.getNumberOfUsers();
    
  int[] userMap = null;
    
  if(userCount > 0) 
  {
    userMap = context.getUsersPixels(SimpleOpenNI.USERS_ALL);
  }
    
  /* ---------------------------------------------------------------------------- */    
    
  //stroke(255);
  //rect(0-context.depthWidth()/2,-context.depthHeight()/2,context.depthWidth(),context.depthHeight());
        
  for(int y=0; y < context.depthHeight(); y+=steps/2) 
  {
    for(int x=0; x < context.depthWidth(); x+=steps/2)
    {
        
      index = x + y * context.depthWidth();
          
      // get the realworld points
      realWorldPoint = context.depthMapRealWorld()[index];
          
      // check if there is a user
      if(userMap != null && userMap[index] != 0) 
      {
        
        float testX = map(realWorldPoint.x,0,context.depthWidth(),-width/2,width/2);
        float testY = map(realWorldPoint.y,0,context.depthHeight(),-height/2,height/2);
        
        pushMatrix();
        translate(testX,testY,realWorldPoint.z);
        
        //int col = (int)map(realWorldPoint.z,0,7000,0,255);
        
        stroke(0);
        
        float randX = random(-width,width);
        float randY = random(-height,height);
        
        point(0,0);
        noFill();
        ellipse(0,0,30,30);
        
        stroke(255);
        line(0,0,randY,randY);
        
        popMatrix();
        
      }
          
    }
  }
  
  /* ---------------------------------------------------------------------------- */
  
  popMatrix();
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    endRaw();
    dosave=false;
  }
  
  /* ---------------------------------------------------------------------------- */
  
}

// SimpleOpenNI user events

void onNewUser(int userId) 
{
  println("onNewUser - userId: " + userId);  
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void keyPressed() 
{
  if (key == 's') 
  { 
    dosave = true;
  }
}
