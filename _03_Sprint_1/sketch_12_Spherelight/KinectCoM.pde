import SimpleOpenNI.*;
import controlP5.*;

SimpleOpenNI  context;
ControlP5     controlP5;

ArrayList     users;
int           userCount = 0;

boolean       showControls = false;

float         kinect_to_front = 0;
float         kinect_to_back = 7000;
float         kinect_to_left = 0;
float         kinect_to_right = 0;

void kinectSetup() 
{
  
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
  
  kinect_to_left = -width/2;
  kinect_to_right = width/2;
  
  /*
  controlP5 = new ControlP5(this);
  
  kinect_to_left = -width/2;
  kinect_to_right = width/2;
  
  controlP5.addSlider("kinect_to_front",0,7000,kinect_to_front,40,60,250,20).setLabel("Kinect -> front");
  controlP5.addSlider("kinect_to_back",0,7000,kinect_to_back,40,90,250,20).setLabel("Kinect -> back");
  controlP5.addSlider("kinect_to_left",-width,width,kinect_to_left,40,120,250,20).setLabel("Kinect -> left");
  controlP5.addSlider("kinect_to_right",-width,width,kinect_to_right,40,150,250,20).setLabel("Kinect -> right");
  */
  
  /* ---------------------------------------------------------------------------- */
  
  users = new ArrayList();
  
  /* ---------------------------------------------------------------------------- */
  
}

void kinectDraw() 
{
  
  context.update();
  
  /* ---------------------------------------------------------------------------- */
  
  userCount = context.getNumberOfUsers();
  
  /* ---------------------------------------------------------------------------- */
  
  PVector pos = new PVector();
  
  for (int i = 0; i < users.size(); i++)
  {
    
    CoM c = (CoM)users.get(i);
    
    context.getCoM(c.id,pos);
    
    float theX = map(pos.x,kinect_to_left,kinect_to_right,width,0);
    float theY = map(pos.y,-height/2,height/2,height,0);
    float theZ = map(pos.z,0,7000,kinect_to_front,kinect_to_back);
    
    c.pos = new PVector(theX,theY,theZ);
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  kinectControls();
    
}

/* ---------------------------------------------------------------------------- */

void kinectControls() {
  
  /*
  if(dist(20,20,mouseX,mouseY) < 500) 
  {
    showControls = true;
  }else 
  {
    showControls = false;
  }
   
  if(showControls) 
  {
    
    fill(0);
    stroke(255);
    
    rectMode(CORNER);
    rect(20,40,360,150);
    
    controlP5.show();
    
  }else 
  {
    controlP5.hide();
  }
  */
  
}

/* ---------------------------------------------------------------------------- */

void onNewUser(int userId) 
{
  users.add(new CoM(userId));
}

void onLostUser(int userId)
{
  for (int i = users.size()-1; i >= 0; i--) 
  {

    CoM c = (CoM) users.get(i);
    
    if(c.id == userId) 
    {
      users.remove(i);
      break;
    }
  }
}

/* ---------------------------------------------------------------------------- */

class CoM {
  
  int     id;
  PVector pos;
  
  CoM(int userId) {
    
    id = userId;
    pos = new PVector(0,0);
    
  }
}
