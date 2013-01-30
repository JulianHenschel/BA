import processing.opengl.*;
import processing.pdf.*;
import SimpleOpenNI.*;

SimpleOpenNI context;

float        zoomF = 0.5f;
float        rotX = radians(180);
float        rotY = radians(0);

int          userCount;
int          steps = 10;
int          slider = 0;

ArrayList    bl;

boolean      dosave = false;

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
  
  // add bricks to arraylist
  
  bl = new ArrayList();
  
}

void draw() {

  if(dosave) {

    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 

    //pdf.strokeJoin(MITER);
    //pdf.strokeCap(SQUARE);
    pdf.fill(255);
    //pdf.noStroke();
    pdf.rect(0,0, width,height);
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
  context.update();

  background(255);
  
  /* ---------------------------------------------------------------------------- */
  
  pushMatrix();
  
  translate(width/2, height/2, 0);
  rotateX(rotX);
  //scale(zoomF);
    
  /* ---------------------------------------------------------------------------- */
    
  // init bricks
    
  if(bl.size() == 0) {
      
    for(int y = -height/2+steps; y < height/2-steps; y += steps) 
    {
      for(int x = -width/2+steps; x < width/2-steps; x += steps) 
      {
        bl.add(new Brick(x,y));
      }
    }
  }
    
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
          
      noStroke();

      // check if there is a user
      if(userMap != null && userMap[index] != 0) 
      {
                   
        float testX = map(realWorldPoint.x,0,context.depthWidth(),-width/2,width/2);
        float testY = map(realWorldPoint.y,0,context.depthHeight(),-height/2,height/2);
        
        for(int i = 0; i < bl.size();  i++) 
        {
          
          Brick b = (Brick) bl.get(i);
              
          float distance = dist(b.pos.x,b.pos.y,testX,testY);
                    
          float depth = map(realWorldPoint.z,0,7000,0,130);             
                        
          if(distance < steps/2) {
            
            b.newWidth = (int)depth;
            b.counter = 0;
            
          }
        }
        
        /*
        pushMatrix();
        translate(0,0,realWorldPoint.z);
          
        fill(100);
        rect(testX,testY,steps,steps);
            
        popMatrix();
        */
        
      }
          
    }
  }
    
  /* ---------------------------------------------------------------------------- */
  
  // draw and update bricks
  
  for(int i = 0; i < bl.size();  i++) 
  {
    
    Brick b = (Brick) bl.get(i);
      
    b.update();
    b.draw();
    
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
