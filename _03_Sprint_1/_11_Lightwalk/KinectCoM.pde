import SimpleOpenNI.*;

ArrayList     users;
int           userCount = 0;
SimpleOpenNI  context;

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
  
  users = new ArrayList();
  
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
    
    float theX = map(pos.x,-width/2,width/2,width,0);
    float theY = map(pos.y,-height/2,height/2,height,0);
    float theZ = pos.z;
    
    c.pos = new PVector(theX,theY,theZ);
    
  }
  
  /* ---------------------------------------------------------------------------- */
  
}

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

class CoM {
  
  int     id;
  PVector pos;
  
  CoM(int userId) {
    
    id = userId;
    pos = new PVector(0,0);
    
  }
}
