import processing.pdf.*;
import processing.opengl.*;
import processing.video.*;

int        lightSteps = 600;
int        beforeBehind = 10;
int        lightWidth;

PImage     img;
PImage[]   images;

boolean    dosave = false;
boolean    makeMovie = false;

Light[]    lightList;
MovieMaker mm;

void setup() {

  size(1200,800,P3D);
  background(0);
  
  /* ---------------------------------------------------------------------------- */
  
  kinectSetup();
  
  /* ---------------------------------------------------------------------------- */
  
  if(makeMovie)
  {
    mm = new MovieMaker(this, width, height, "output/mov/"+year()+month()+day()+"-"+hour()+minute()+second()+".mov", 30, MovieMaker.ANIMATION, MovieMaker.HIGH);
  }
  
  /* ---------------------------------------------------------------------------- */

  lightWidth = width/lightSteps;

  lightList = new Light[lightSteps];

  for (int i = 0; i < lightList.length; i++) 
  {
    lightList[i] = new Light(i*lightWidth+(lightWidth/2), height/2);
  }
  
  /* ---------------------------------------------------------------------------- */
  
  img = loadImage("background.jpg");
  
  /* ---------------------------------------------------------------------------- */
  
  // copy sliced images to new image array
  
  images = new PImage[lightSteps];
  
  for(int i = 0; i < images.length; i++) 
  {
    
    images[i] = createImage(lightWidth, height, RGB);
    
    int pixel_count = images[i].pixels.length;
    int[] new_pixels = new int[pixel_count];
    
    int index = 0;    
    
    // read original image region
    for(int y = 0; y < img.height; y++) 
    {
      for(int x = i*lightWidth; x < (i*lightWidth)+lightWidth; x++) 
      {
        new_pixels[index] = img.get(x,y);
        index++;
      } 
    }
    
    // save pixels in new image
    for(int j = 0; j < images[i].pixels.length; j++) 
    {  
      images[i].pixels[j] = new_pixels[j];
    }

  }
  
}

void draw() {
  
  //background(0);
  
  rectMode(CORNER);
  
  fill(0,4);
  rect(0,0,width,height);
  
  /* ---------------------------------------------------------------------------- */
  
  kinectDraw();

  /* ---------------------------------------------------------------------------- */

  if (dosave) 
  {

    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 

    pdf.fill(0);
    pdf.rect(0, 0, width, height);
  }

  /* ---------------------------------------------------------------------------- */
  
  for (int i = 0; i < users.size(); i++)
  {
  
    CoM c = (CoM)users.get(i);
  
    int area = (int)map(c.pos.x, 0, width, 0, lightSteps);
    float depth = map(c.pos.z, 0, 3000, height/5, height);
  
    for (float j = area-beforeBehind; j < area+beforeBehind; j++) {
  
      if (j > 0 && j < lightList.length) {
  
        float h = map(j, area-beforeBehind, area+beforeBehind, -height, height);
  
        lightList[(int)j].rHeight = depth;
        lightList[(int)j].counter = 0;
      }
    }
    
  }
  
  /* ---------------------------------------------------------------------------- */

  for (int i = 0; i < lightList.length; i++) 
  {
    lightList[i].update();
    lightList[i].draw(i);
  }

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
  
  /* ---------------------------------------------------------------------------- */
  
}

void keyPressed() 
{
  if (key == 's') 
  { 
    dosave = true;
  }
  
  if(makeMovie) 
  {
    if (key == ' ') {
      mm.finish();
      exit();
    }
  }
}
