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

PImage       img;

int          userCount;
int          waveSteps = 100;

color        bg = color(255);

int[]        colors;

void setup() {
  
  size(1200,800,OPENGL);
  
  /* ---------------------------------------------------------------------------- */
  
  wList = new ArrayList();
  wList.add(new Wave());
  
  img = loadImage("background3.jpg");
  
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
  
  /* ---------------------------------------------------------------------------- */
  
  // take colors from image
  
  int s      = img.width/waveSteps;
  int i      = 0;
  colors     = new int[waveSteps];
  
  for(int x = 0; x < img.width; x+=s) {
    
    int pix = x+10*img.width;
    colors[i] = img.pixels[pix];
    
    println(i);
    
    i++;
    
  }
    
  println(colors);
  
  /* ---------------------------------------------------------------------------- */
  
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
  
  image(img,0,0);
  
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
