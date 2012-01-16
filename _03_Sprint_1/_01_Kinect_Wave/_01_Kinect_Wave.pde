import processing.opengl.*;
import processing.pdf.*;
import processing.video.*;
import SimpleOpenNI.*;

SimpleOpenNI context;
MovieMaker   mm;

ArrayList    wList;
boolean      dosave = false;
boolean      makeMovie = false;

float        zoomF = 0.5f;
float        rotX = radians(180);
float        rotY = radians(0);

int          userCount;
int          waveSteps = 150;

color        bg = color(0);

void setup() {
  
  size(1200,800,OPENGL);
  
  /* ---------------------------------------------------------------------------- */
  
  wList = new ArrayList();
  wList.add(new Wave());
  
  /* ---------------------------------------------------------------------------- */
  
  if(makeMovie)
  {
    mm = new MovieMaker(this, width, height, "drawing.mov", 30, MovieMaker.ANIMATION, MovieMaker.HIGH);
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
     
    float steps = map(pos.x,-width/2,width/2,0,waveSteps); 
     
    for(int i = 0; i < wList.size(); i++) 
    {
      
      Wave w = (Wave) wList.get(i);
      
      w.setActive((int)steps);
      w.update();
    
    }
  }  
  
  /* ---------------------------------------------------------------------------- */
  
  for(int i = 0; i < wList.size(); i++) 
  {
    
    Wave w = (Wave) wList.get(i);
    w.draw();  
    
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
  
  if(makeMovie)
  {
    mm.addFrame();
  }
  
}

 /* ---------------------------------------------------------------------------- */

// SimpleOpenNI user events

void onNewUser(int userId) 
{
  println("onNewUser - userId: " + userId);  
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

 /* ---------------------------------------------------------------------------- */

void keyPressed() 
{
  if (key == 's') 
  { 
    dosave = true;
  }
  
  if (key == ' ') 
  {
    if(makeMovie) 
    {
      mm.finish();
      exit();
    }
  }
}
