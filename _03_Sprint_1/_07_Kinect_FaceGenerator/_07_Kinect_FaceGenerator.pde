import processing.pdf.*;
import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI context;

float        rotX = radians(180);
float        rotY = radians(0);
float        zoomF = 1f;

int          userCount;
boolean      dosave = false;
color        bg = color(255);
ArrayList    facePoints;

void setup() {

  size(1024,768,P3D);

  facePoints = new ArrayList();

  /* ---------------------------------------------------------------------------- */

  context = new SimpleOpenNI(this);

  // disable mirror
  context.setMirror(false);

  // enable depthMap generation 
  if (context.enableDepth() == false)
  {
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  /* ---------------------------------------------------------------------------- */
}

void draw() {

  // update the cam
  context.update();

  background(bg);
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 
    
    pdf.noStroke();
    pdf.fill(bg);
    pdf.rect(0,0, width,height);
  }

  /* ---------------------------------------------------------------------------- */

  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  /* ---------------------------------------------------------------------------- */

  if (context.isTrackingSkeleton(1)) 
  {  
    getHeadPosition(1);
  }
  
  drawHead();
  
  /* ---------------------------------------------------------------------------- */

  popMatrix();
  
  /* ---------------------------------------------------------------------------- */
  
  if(dosave) 
  {
    endRaw();
    dosave=false;
  }
}

/* ---------------------------------------------------------------------------- */

// save head points in arraylist

void saveHeadDepthModel(float d, PVector headPos) {
  
  int[]   depthMap = context.depthMap();
  int     index;
  int     steps = 2;
  PVector realWorldPoint;

  userCount = context.getNumberOfUsers();

  int[] userMap = null;

  if (userCount > 0) 
  {
    userMap = context.getUsersPixels(SimpleOpenNI.USERS_ALL);
  }

  /* ---------------------------------------------------------------------------- */
  
  facePoints.clear();

  for (int y=0; y < context.depthHeight(); y+=steps) 
  {
    for (int x=0; x < context.depthWidth(); x+=steps)
    {
      index = x + y * context.depthWidth();
      
      // check if there is a user
      if (userMap != null && userMap[index] != 0) 
      {
        
        realWorldPoint = context.depthMapRealWorld()[index];  
        
        // distance to head
        float di = dist(headPos.x, headPos.y, headPos.z, realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);
        
        // if distance to head ist correct, save points in arraylist
        if (di < d) 
        {
          facePoints.add(new PVector(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z));
        }
      }
    }
  }
}

/* ---------------------------------------------------------------------------- */

void drawHead() {

  if(facePoints.size() > 0)
  {
    for(int i = 0; i < facePoints.size(); i++) 
    {
      
      PVector pos = (PVector)facePoints.get(i);
      
      float testX = map(pos.x,-context.depthWidth()/2,context.depthWidth()/2,-width,width);
      float testY = map(pos.y,-context.depthHeight()/2,context.depthHeight()/2,-height,height);
      //float testZ = map(pos.z,0,7000,0,4000);
    
      pushMatrix();
      translate(testX,testY,pos.z);
      
      // map color
      //float col = map(pos.z,0,7000,0,255);
      
      stroke(0);
      noFill();
      ellipse(0,0,10,10);
      
      //point(0,0,pos.z/5);  
      
      popMatrix();  
      
    }
  }
}

/* ---------------------------------------------------------------------------- */

// get position of head

void getHeadPosition(int userId) {

  PVector jointPosHead = new PVector();
  PVector jointPosNeck = new PVector();
  float   confidence;

  confidence = context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPosHead);
  confidence = context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, jointPosNeck);

  float d = dist(jointPosHead.x, jointPosHead.y, jointPosNeck.x, jointPosNeck.y);

  saveHeadDepthModel(d, jointPosHead);
}

/* ---------------------------------------------------------------------------- */

// SimpleOpenNI events

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");

  context.startPoseDetection("Psi", userId);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);

  if (successfull) 
  { 
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId);
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");

  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
}

void onEndPose(String pose, int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

void keyPressed() 
{  
  
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
    
  switch(keyCode)
  {
    case LEFT:
      rotY += 0.1f;
      break;
    case RIGHT:
      // zoom out
      rotY -= 0.1f;
      break;
    case UP:
      if(keyEvent.isShiftDown())
        zoomF += 1f;
      else
        rotX += 0.1f;
      break;
    case DOWN:
      if(keyEvent.isShiftDown())
      {
        zoomF -= 0.01f;
        if(zoomF < 0.01)
          zoomF = 0.01;
      }
      else
        rotX -= 0.1f;
      break;
  }
  
  if (key == 's') 
  { 
    dosave = true;
  }
}

