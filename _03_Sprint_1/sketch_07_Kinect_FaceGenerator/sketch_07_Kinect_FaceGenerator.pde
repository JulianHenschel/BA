import processing.pdf.*;
import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI context;

float        rotX = radians(180);
float        rotY = radians(0);
float        zoomF = 0.5f;

int          userCount;
boolean      dosave = false;
boolean      drawPic = false;
color        bg = color(255);
ArrayList    facePoints;
PVector      head;

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
    
    /*
    pdf.noStroke();
    pdf.fill(bg);
    pdf.rect(0,0, width,height);
    */
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
  
  if(drawPic) {;
    drawPicture();
    noLoop();
  }else {
    drawHead(color(0));
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

/* ---------------------------------------------------------------------------- */

// save head points in arraylist

void saveHeadDepthModel(float d, PVector headPos) {
  
  int[]   depthMap = context.depthMap();
  int     index;
  int     steps = 1;
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

void drawPicture() {
      
  PVector t = getBorderPoints(1);
  PVector b = getBorderPoints(2);
  PVector r = getBorderPoints(3);
  PVector l = getBorderPoints(4);
  PVector f = getBorderPoints(5);
    
  float topToBottom = dist(t.x,t.y,b.x,b.y);
  
  //fill(0);
  //noStroke();
  //rect(t.x,t.y,topToBottom,-topToBottom);
  
  float ro = 0;
  
  for(int i = 0; i < 20; i++) {
  
    pushMatrix();
    translate(head.x,head.y);
    rotateZ(radians(ro));  
      
    rect(t.x,t.y,topToBottom,-topToBottom);
    
    popMatrix();
    
    ro += 0.5;
    
  }

  /*
  for(int j = 0; j < 30; j++) {
    
    pushMatrix();
    translate(head.x,head.y);
    rotate(radians(ro));
    
    for(int i = 1; i <= 5; i++) {
      
      PVector pos = getBorderPoints(i);
      
      stroke(0);
      noFill();
      
    }
    
    ro += 1;
    
    popMatrix();
    
  }
  */
  
  
  drawHead(color(255,0,0));
  
  
  noLoop();
  
}

/* ---------------------------------------------------------------------------- */

void drawHead(color c) {

  if(facePoints.size() > 0)
  {
    for(int i = 0; i < facePoints.size(); i++) 
    {
      
      PVector pos = (PVector)facePoints.get(i);
      
      float testX = map(pos.x,-context.depthWidth()/2,context.depthWidth()/2,-width,width);
      float testY = map(pos.y,-context.depthHeight()/2,context.depthHeight()/2,-height,height);
      float testZ = map(pos.z,0,7000,0,50);
      
      pushMatrix();
      //translate(testX,testY,pos.z);
      translate(testX,testY,pow(testZ,3.5));
      
      // map color
      float col = map(testZ,0,50,0,255);
      float st = map(testZ,0,50,1,10);

      stroke(col);
      strokeWeight(st);
      noFill();
      //ellipse(0,0,4,4);
      
      point(0,0,pow(testZ,3.5));  
      
      popMatrix();  
      
    }
  }
}

/* ---------------------------------------------------------------------------- */

PVector getBorderPoints(int mode) {
  
   PVector rtrn = new PVector(0,0);
   
   for(int i = 0; i < facePoints.size(); i++) 
   {
     PVector c = (PVector)facePoints.get(i);
  
     switch(mode) {
       
       case 1:
         
         // get top point
         if(c.y > rtrn.y) {
           rtrn = new PVector(c.x,c.y,c.z);  
         }
                
         break;
       case 2:
       
         // get bottom point
         if(c.y < rtrn.y) {
           rtrn = new PVector(c.x,c.y,c.z);  
         }   
         
         break;
       case 3:
         
         // get right point
         if(c.x > rtrn.x) {
           rtrn = new PVector(c.x,c.y,c.z);  
         }
         
         break;
         
       case 4:
       
         // get left point
         if(c.x < rtrn.x) {
           rtrn = new PVector(c.x,c.y,c.z);  
         }
                
         break;
       
       case 5:
     
         // get front point
         if(c.z > rtrn.z) {
           rtrn = new PVector(c.x,c.y,c.z);
         }
         
         break;
         
       default:
         rtrn = new PVector(0,0);
          
         break;
     }
   }
   
   float mapX = map(rtrn.x,-context.depthWidth()/2,context.depthWidth()/2,-width,width);
   float mapY = map(rtrn.y,-context.depthHeight()/2,context.depthHeight()/2,-height,height);
   float mapZ = map(rtrn.z,0,7000,0,50);
  
   //return new PVector(mapX,mapY,mapZ);
   return rtrn;
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
  
  head = new PVector(jointPosHead.x,jointPosHead.y);
  
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
  
    if(drawPic) 
    {
      drawPic = false;
      loop();
      noSmooth();
    }else {
      drawPic = true;
      smooth();
    }
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
        zoomF -= 1f;
        if(zoomF < 0.01)
          zoomF = 0.01;
      }
      else
        rotX -= 0.1f;
      break;
      
      
      
  }
  
  println(rotY);
  
  if (key == 's') 
  { 
    dosave = true;
    loop();
  }
}

