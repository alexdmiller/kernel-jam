import controlP5.*;
import processing.video.*;

PShader conway;
PGraphics mainCanvas;
PGraphics drawLayer;

int scale = 3;
int rectSize = 5;
boolean flicker = true;
int threshold = 1;

ControlP5 cp5;

Kernel kernel;

int LEFT_MARGIN = 200;


void setup() {
  fullScreen(OPENGL);

  noSmooth();
  hint(DISABLE_TEXTURE_MIPMAPS);

  //f = createFont("Optician-Sans", 50, false);
  //textFont(f);

  mainCanvas = createGraphics((width - LEFT_MARGIN) / scale, height / scale, P2D);
  mainCanvas.noSmooth();

  drawLayer = createGraphics(mainCanvas.width, mainCanvas.height, P2D);
  drawLayer.noSmooth();
  
  kernel = new Kernel(10);
  kernel.setPosition(10, 10);

  conway = loadShader("conway.glsl");
  conway.set("resolution", float(mainCanvas.width), float(mainCanvas.height));

  ((PGraphicsOpenGL)g).textureSampling(3);

  frameRate(60);

  cp5 = new ControlP5(this);
  
  cp5.addToggle("flicker")
    .setPosition(10, 200);
  cp5.addSlider("threshold", 0, 10)
    .setPosition(10, 250);
}

void draw() {
  background(0);
  conway.set("kernel", kernel.get());
  conway.set("kernelSize", kernel.size(), kernel.size());
  
  for (int i = 0; i < (flicker ? 1 : 2); i++) {
    conway.set("time", millis()/1000.0);
    float x = map(mouseX, 0, width, 0, 1);
    float y = map(mouseY, 0, height, 1, 0);

    drawLayer.beginDraw();
    //drawLayer.background(0);
    
    if (mousePressed) {
      if (mouseX > LEFT_MARGIN) {
        drawLayer.rectMode(CENTER);
        drawLayer.fill(255);
        drawLayer.noStroke();
        drawLayer.rect((mouseX - LEFT_MARGIN) / scale, mouseY/scale, rectSize, 3);
      }
    }
    
    drawLayer.endDraw();

    conway.set("mouse", x, y);
    conway.set("drawLayer", drawLayer);
    conway.set("threshold", threshold);

    mainCanvas.beginDraw();
    mainCanvas.background(0);
    mainCanvas.shader(conway);
    mainCanvas.rect(0, 0, mainCanvas.width, mainCanvas.height);
    mainCanvas.endDraw();
  }

  image(mainCanvas.get(), LEFT_MARGIN, 0, (width - LEFT_MARGIN), height);

  kernel.draw();
  
  line(LEFT_MARGIN, 0, LEFT_MARGIN, height); 
}

void mousePressed() {
  kernel.mousePressed();
}

void mouseReleased() {
  kernel.mouseReleased();
}

void keyPressed() {
  if (key == ' ') {
    mainCanvas.beginDraw();
    mainCanvas.background(0);
    mainCanvas.endDraw();
  }
  
  if (key == 'c') {
    drawLayer.beginDraw();
    drawLayer.background(0);
    drawLayer.endDraw();
  }

  if (key == 's') {
    mainCanvas.save(frameCount + ".png");
  }
}
