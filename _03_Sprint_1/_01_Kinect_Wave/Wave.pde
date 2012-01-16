class Wave {
  
  int        steps = waveSteps;
  int        stepHeight = 400;
  
  int[]      rotationSteps = new int[steps];
  int[]      activeSpeed = new int[steps];
  int[]      activeTime = new int[steps];
  boolean[]  active = new boolean[steps];
  color[]    col = new color[steps];
  float[]    stepWidth = new float[steps];
  
  Wave() 
  {
    for(int i = 0; i < steps; i++) 
    {
      
      rotationSteps[i] = 0;
      activeTime[i] = 0;
      activeSpeed[i] = 0;
      active[i] = false;
      col[i] = color(random(0,255),random(0,255),random(0,255));
      stepWidth[i] = random(-(width/steps)*2,(width/steps)*2);
      
    }
  }
  
  void setActive(int step) 
  {
    if( (step < steps) && (step >= 0) ) 
    {
      active[step] = true;
      activeTime[step] = 0;
      activeSpeed[step] = 5;
      
    }else 
    {
      println("step error: "+step);  
    }
    
  }
  
  void update() 
  {
    for(int i = 0; i < steps; i++) 
    {
      if(active[i]) 
      {
        rotationSteps[i] += activeSpeed[i];
        activeTime[i]++;
      }
      
      if(activeTime[i] > 50) 
      {
        activeSpeed[i]--;

        if(activeSpeed[i] <= 0) 
        {
          active[i] = false;
        }
      }

    }
  }
  
  void draw() 
  {
    
    float s = width/steps;
    int index = 0;
    
    for(float i = -width/2; i < width/2; i+=(s+1)) 
    {
      
      pushMatrix();
      rotateX(radians(rotationSteps[index]));
      
      rectMode(CENTER);
      ellipseMode(CENTER);
      
      fill(col[index],200);
      noStroke(); 

      //rect(i,0,s,stepHeight); 
      rect(i,0,s+(stepWidth[index]),stepHeight); 
            
      popMatrix();
      
      index++;
      
    }
  }
  
}
