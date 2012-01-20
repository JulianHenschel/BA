import processing.pdf.*;
import processing.opengl.*;
import processing.video.*;

int        lightSteps = 600;
int        beforeBehind = 10;
int        lightWidth;

PImage     img;
PImage[]   images;

boolean    dosave = false;

Light[]    lightList;
MovieMaker mm;

void setup() {

  size(1200,800,P3D);
  background(0);
  
  mm = new MovieMaker(this, width, height, "drawing.mov", 30, MovieMaker.ANIMATION, MovieMaker.HIGH);

  /* ---------------------------------------------------------------------------- */

  lightWidth = width/lightSteps;

  lightList = new Light[lightSteps];

  for (int i = 0; i < lightList.length; i++) 
  {
    lightList[i] = new Light(i*lightWidth+(lightWidth/2), height/2);
  }
  
  /* ---------------------------------------------------------------------------- */
  
  img = loadImage("background.jpg");
  //image(img,0,0);
  
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

  if (dosave) 
  {

    PGraphicsPDF pdf = (PGraphicsPDF)beginRaw(PDF, "output/"+year()+month()+day()+"-"+hour()+minute()+second()+".pdf"); 

    pdf.fill(0);
    pdf.rect(0, 0, width, height);
  }

  /* ---------------------------------------------------------------------------- */

  int area = (int)map(mouseX, 0, width, 0, lightSteps);
  float depth = map(mouseY, 0, height, height/5, height);

  for (float i = area-beforeBehind; i < area+beforeBehind; i++) {

    if (i > 0 && i < lightList.length) {

      float h = map(i, area-beforeBehind, area+beforeBehind, -height, height);

      lightList[(int)i].rHeight = depth;
      lightList[(int)i].counter = 0;
    }
  }

  /* ---------------------------------------------------------------------------- */

  for (int i = 0; i < lightList.length; i++) 
  {
    lightList[i].update();
    lightList[i].draw(i);
  }
  
  /* ---------------------------------------------------------------------------- */

  if (dosave) 
  {
    endRaw();
    dosave=false;
  }
  
  /* ---------------------------------------------------------------------------- */
  
  mm.addFrame();
  
}

void keyPressed() 
{
  if (key == 's') 
  { 
    dosave = true;
  }
  
  if (key == ' ') {
    mm.finish();
    exit();
  }
}
