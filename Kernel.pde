class Kernel {
  public static final int DRAW_SCALE = 20;
  
  PGraphics kernel;
  PVector pos;
  private boolean initialized = false;
  private boolean mouseDown = false;
  private PVector lastMouse;
  private PVector lastMouseClick;
  
  public Kernel(int size) {
    kernel = createGraphics(size, size, P2D);
    kernel.noSmooth();
    
    
    pos = new PVector();
    
    lastMouse = new PVector();
  }
  
  public void setPosition(float x, float y) {
    pos.set(x, y);
  }
  
  public void draw() {
    if (!initialized) {
      initialized = true;
      kernel.beginDraw();
      kernel.background(255/2);
      //kernel.stroke(255);
      //kernel.noFill();
      //kernel.ellipseMode(CENTER);
      //kernel.ellipse(kernel.width / 2f, kernel.height / 2f, kernel.width/1.5f, kernel.height/1.5f);
      //kernel.background(255/2);
      //kernel.loadPixels();
      //kernel.pixels[floor(kernel.height / 2) * kernel.width + floor(kernel.width / 2)] = 0;
      //kernel.updatePixels();
      kernel.endDraw();    
    }
    
    if (mouseDown) {
      int x = floor((lastMouseClick.x - pos.x) / DRAW_SCALE);
      int y = floor((lastMouseClick.y - pos.y) / DRAW_SCALE);
      
      float mouseDist = lastMouse.y - mouseY;
            
      kernel.beginDraw();
      kernel.loadPixels();
      kernel.pixels[y * kernel.width + x] = color((int) constrain(brightness(kernel.pixels[y * kernel.width + x]) + mouseDist, 0, 255));
      kernel.updatePixels();
      kernel.endDraw();
    }

    pushMatrix();
    translate(pos.x, pos.y);
   
    image(kernel.get(), 0, 0, kernel.width * DRAW_SCALE, kernel.height * DRAW_SCALE);
    
    stroke(150);
    noFill();
    rect(0, 0, kernel.width * DRAW_SCALE, kernel.height * DRAW_SCALE);
    
    for (int x = 0; x < kernel.height; x++) {
      line(x * DRAW_SCALE, 0, x* DRAW_SCALE, kernel.height * DRAW_SCALE);
    }

    for (int y = 0; y < kernel.height; y++) {
      line(0, y * DRAW_SCALE, kernel.width * DRAW_SCALE, y * DRAW_SCALE);
    }
    
    
    popMatrix();
    
    lastMouse = new PVector(mouseX, mouseY);
  }
  
  public boolean mousePressed() {
    println("PRESSED");
    if (mouseX > pos.x && mouseX < pos.y + kernel.width * DRAW_SCALE && mouseY > pos.x && mouseY < pos.y + kernel.height * DRAW_SCALE) {
      mouseDown = true;      
      lastMouseClick = new PVector(mouseX, mouseY);
      return true;
    } else {
      return false;
    }
  }
  
  public boolean mouseReleased() {
    mouseDown = false;
    if (mouseX > 0 && mouseX < kernel.width * DRAW_SCALE && mouseY > 0 && mouseY < kernel.height * DRAW_SCALE) {
      
      return true;
    } else {
      return false;
    }

  }

  
  public PImage get() {
    return kernel;
  }
  
  public int size() {
    return kernel.width;
  }
}
