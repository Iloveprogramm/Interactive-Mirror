import processing.video.*;
import controlP5.*;
ControlP5 cp5;
Capture video;


float ANG = 0;

boolean play = false;
boolean blue = false;
boolean Vague = false;
boolean goCircle = false;
boolean BB = false;

int Size = 15;
int VagueDepth;
int BlueDepth;
int Columns;
int Rows;
int signal = 0;
int numP;
int plus;

ArrayList frames = new ArrayList();


void setup() 
{
  size(1000, 800);
  mouseX = width /2;
  mouseY = height /2;
  Columns = width / Size;
  Rows = height / Size;
  colorMode(RGB, 255, 255, 255, 100);
  rectMode(CENTER);
  video = new Capture(this, width, height, "pipeline:autovideosrc");
  video.start();  
  
  cp5 = new ControlP5(this); 
  cp5.addButton("Blue")
  .setPosition(20, 20)
  .setSize(50, 20);
  
  cp5.addButton("BlueSTOP")
  .setPosition(20, 60)
  .setSize(50, 20);
  
  cp5.addButton("Vague")
  .setPosition(20, 100)
  .setSize(50, 20);
  
  cp5.addButton("VagueSTOP")
  .setPosition(20, 140)
  .setSize(50, 20);
  
  cp5.addButton("Circle")
  .setPosition(20, 180)
  .setSize(50, 20);
  
  cp5.addButton("NOTCircle")
  .setPosition(20, 220)
  .setSize(50, 20);
  
  
  cp5.addSlider("VagueDepth")
  .setPosition(80, 100)
  .setSize(100, 20)
  .setRange(0, 500)
  .setColorCaptionLabel(color(#FF0D0D));
  
  cp5.addSlider("BlueDepth")
  .setPosition(80, 20)
  .setSize(100, 20)
  .setRange(0, 500)
  .setColorCaptionLabel(color(#FF0D0D));
}

void captureEvent(Capture camera) 
{
  camera.read();
  PImage img = createImage(width, height, RGB);
  video.loadPixels();
  arrayCopy(video.pixels, img.pixels);
  frames.add(img);
  if (frames.size() > height/4) 
  {
    frames.remove(0);
  }
}

void draw() 
{
   int tempImage = 0;
   
   loadPixels();
  
  for (int y = 0; y < video.height; y+=4) 
  {
        if (tempImage < frames.size())
       {
           PImage img = (PImage)frames.get(tempImage);
      
           if (img != null) 
           {
               img.loadPixels();
               for (int x = 0; x < video.width; x++)
              {
                   pixels[x + y * width] = img.pixels[x + y * video.width];
                   pixels[x + (y + 1) * width] = img.pixels[x + (y + 1) * video.width];
                   pixels[x + (y + 2) * width] = img.pixels[x + (y + 2) * video.width];
                   pixels[x + (y + 3) * width] = img.pixels[x + (y + 3) * video.width];
               }  
            }
            tempImage++;
        } 
        else 
        {
           break;
        }
         updatePixels();
   }
 
  
  if (play == true)
  {
   translate(mouseX,mouseY);
   rotate(ANG);
   image(video, 0, 0);
   ANG += 0.1;
  }
  
  
  if(blue == true)
  {
    video.read();
    video.loadPixels();
    background(0, 0, 255);
    for (int i = 0; i < Columns;i++)
    {
      for (int j = 0; j < Rows;j++)
      {
        int x = i * Size;
        int y = j * Size;
        int LO = (video.width - x - 1) + y*video.width; 
        color c = video.pixels[LO];
        float BR = (brightness(c+BlueDepth) / 255.0) * Size;
        fill(255);
        noStroke();
        rect(x + Size/2, y + Size/2, BR, BR);
      }
    }
  }
  
  
  if(Vague == true)
  {
    video.read();
    video.loadPixels();
    for (int i = 0; i < Columns; i++)
    {
      for (int j = 0; j < Rows; j++)
      {
        int x = i*Size;
        int y = j*Size;
        int LO = (video.width - x - 1) + y*video.width;
        float Red = red(video.pixels[LO]);
        float Green = green(video.pixels[LO]);
        float Blue = blue(video.pixels[LO]);
        color colour = color(Red, Green, Blue, 75);
        pushMatrix();
        translate(x+Size/2, y+Size/2);
        rotate((2 * PI * brightness(colour+VagueDepth) / 255));
        rectMode(CENTER);
        fill(colour+VagueDepth);
        noStroke();
        rect(0, 0, Size+6, Size+6);
        popMatrix();
      }
    }
  }
  
  if(goCircle == true)
  {
    video.read();
    image(video, 0, 0, width, height);
    int XX = 0; 
    int YY = 0; 
    float Value = 0; 
    video.loadPixels();
    int num = 0;
    for (int i = 0; i < video.height; i++) 
    {
      for (int x = 0; x < video.width; x++)
      {
        int pixelValue = video.pixels[num];
        float pixelBrightness = brightness(pixelValue);
        if (pixelBrightness > Value) 
        {
          Value = pixelBrightness;
          YY = i;
          XX = x;
        }
        num++;
      }
    }
    fill(#12F7FC);
    ellipse(XX, YY, 500, 500);
  }
  
  if(BB == true)
  {
    numP = video.width * video.height;
    video.read();
    video.loadPixels();
    float Bright; 
    loadPixels();
    for (int i = 0; i < numP; i++) 
    {
      Bright = brightness(video.pixels[i]);
      if (Bright > 127) 
      { 
        pixels[i] = color(40+plus); 
      } 
      else
      { 
        pixels[i] = color(0); 
      }
    }
    updatePixels();
  } 
  
  textSize(15);
   text("Press A to Rotate", 250, 20);
   fill(#FC1212);
   
   textSize(15);
   text("Press a to STOP Rotate", 250, 40);
   fill(#FC1212);
   
   textSize(15);
   text("Press B to Go Black", 250, 60);
   fill(#FC1212);
   
   textSize(15);
   text("Press B to STOP Black", 250, 80);
   fill(#FC1212);
   
   textSize(15);
   text("Press P to PLUS color into BLACK", 250, 100);
   fill(#FC1212);
   
   textSize(15);
   text("Press M to REDUCTION color into Black", 250, 120);
   fill(#FC1212);
}


void Blue()
{
    blue = true;
}

void BlueSTOP()
{
  blue = false;
}

void Vague()
{
  Vague = true;
}

void VagueSTOP()
{
  Vague = false;
}

void Circle()
{
  goCircle = true;
}

void NOTCircle()
{
  goCircle = false;
}

void BLACK()
{
  BB = true;
}

void NOTBLACK()
{
  BB = false;
}

void keyPressed()
{
  if(key == 'A')
  {
    play = true;
  }
  else if(key == 'a')
  {
    play = false;
  }
  if(key == 'B')
  {
    BB = true;
  }
  else if(key == 'b')
  {
    BB = false;
  }
  if(key == 'P')
  {
    plus+=20;
  }
  else if(key == 'M')
  {
    plus-=20;
  }
}
