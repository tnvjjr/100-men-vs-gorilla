import g4p_controls.*;

// Simulation parameters
final int NUM_HUMANS = 100;
final int WINDOW_WIDTH = 800;
final int WINDOW_HEIGHT = 600;

// Global variables
Human[] humans;
Gorilla gorilla;
Environment environment;
ControlPanel controlPanel;

void setup() {
  size(800, 600);
  
  // Initialize simulation components
  humans = new Human[NUM_HUMANS];
  for (int i = 0; i < NUM_HUMANS; i++) {
    humans[i] = new Human(random(width), random(height));
  }
  
  gorilla = new Gorilla(width/2, height/2);
  environment = new Environment();
  
  // Create control panel in a separate window
  controlPanel = new ControlPanel(this);
}

void draw() {
  background(200);
  
  // Update and display environment
  environment.update();
  environment.display();
  
  // Update and display humans
  for (Human human : humans) {
    human.update(gorilla, humans);
    human.display();
  }
  
  // Update and display gorilla
  gorilla.update(humans);
  gorilla.display();
  
  // Display statistics
  displayStats();
}

void displayStats() {
  fill(0);
  textSize(12);
  text("Humans: " + NUM_HUMANS, 10, 20);
  text("FPS: " + frameRate, 10, 40);
} 