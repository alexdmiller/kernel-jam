class Kernel {
  public static final int DRAW_SCALE = 20;
  
  PGraphics kernel;
  PVector pos;
  
  public Kernel(int size) {
    kernel = createGraphics(size, size, P2D);
    kernel.noSmooth();
    
    kernel.beginDraw();
    kernel.background(255);
    kernel.endDraw();
    
    pos = new PVector();
  }
  
  public void setPosition(float x, float y) {
    pos.set(x, y);    
  }
  
  public void draw() {
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
  }
  
  public boolean mousePressed() {
    if (mouseX > pos.x && mouseX < pos.y + kernel.width * DRAW_SCALE && mouseY > pos.x && mouseY < pos.y + kernel.height * DRAW_SCALE) {      
      int x = floor((mouseX - pos.x) / DRAW_SCALE);
      int y = floor((mouseY - pos.y) / DRAW_SCALE);

      kernel.beginDraw();
      kernel.loadPixels();
      kernel.pixels[y * kernel.width + x] = color(((int) brightness(kernel.pixels[y * kernel.width + x]) + (255 / 4)) % 255);
      kernel.updatePixels();
      kernel.endDraw();
      
      return true;
    } else {
      return false;
    }
  }
  
  public boolean mouseReleased() {
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
