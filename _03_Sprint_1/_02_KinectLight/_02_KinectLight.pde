import processing.opengl.*;
import processing.pdf.*;
import SimpleOpenNI.*;

SimpleOpenNI context;

float        rotX = radians(180);
float        multFactor = 0.9;
int          userCount;

boolean      dosave = false;
ArrayList    sList;
PImage       img;

color        bg = color(255);

void setup() {
 
  size(1200,800,P3D);
  smooth();
  
  sList = new ArrayList();
  
  /* ---------------------------------------------------------------------------- */
  
  img = loadImage("background2.gif");
        
  for(int x = 0; x < img.width; x++) {
    for(int y = 0; y < img.height; y++) {
        
      int pix = x+y*img.width;
        
      if(img.pixels[pix] != -1) {
        sList.add(new Shadow(x,y,img.pixels[pix]));
      }
    }
  }
  
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
  
}

void draw() {
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) {

    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 

    pdf.fill(bg);
    pdf.rect(0,0, width,height);
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  context.update();
  
  background(bg);
  
  /* ---------------------------------------------------------------------------- */
  
  pushMatrix();
  
  translate(width/2, height/2, 0);
  rotateX(rotX);
  
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
  
  PVector pos = new PVector();
  
  for(int userId=1;userId <= userCount;userId++)
  {
    
    context.getCoM(userId,pos);
    
    /*
    stroke(0);
    strokeWeight(15);
    point(pos.x,pos.y);
    */
    
    for(int i = 0; i < sList.size(); i++) 
    {
      Shadow s = (Shadow) sList.get(i);
      s.drawShadow(pos.x,pos.y,pos.z);
    }
    
  }
  
  for(int i = 0; i < sList.size(); i++) 
  {
    Shadow s = (Shadow) sList.get(i);
    s.draw();
  }
  
  /* ---------------------------------------------------------------------------- */
    
  popMatrix();
  
  /* ---------------------------------------------------------------------------- */
    
  if(dosave) 
  {
    endRaw();
    dosave=false;
  }
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
