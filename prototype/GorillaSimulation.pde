// Gorilla vs Men Simulation - Main Tab
// This is the main file that contains setup() and draw() functions

// Global variables
ArrayList<Entity> entities;
Gorilla gorilla;
ArrayList<Human> humans;
Environment environment;
GUI gui;
boolean paused = false;
int simulationSpeed = 1;
int frameCounter = 0;

// Configuration
int numHumans = 100;
float worldWidth = 1000;
float worldHeight = 800;
String configFile = "config.txt";

void setup() {
  size(1000, 800);
  frameRate(60);
  
  // Initialize simulation components
  initializeSimulation();
  
  // Load configuration if file exists
  if (fileExists(configFile)) {
    loadConfiguration(configFile);
  }
}

void draw() {
  // Update simulation state if not paused
  if (!paused) {
    for (int i = 0; i < simulationSpeed; i++) {
      updateSimulation();
    }
  }
  
  // Display simulation
  displaySimulation();
  
  // Display GUI
  gui.display();
  
  // Increment frame counter
  frameCounter++;
}

void initializeSimulation() {
  // Initialize lists
  entities = new ArrayList<Entity>();
  humans = new ArrayList<Human>();
  
  // Create environment
  environment = new Environment(worldWidth, worldHeight);
  
  // Create GUI
  gui = new GUI();
  
  // Create gorilla
  gorilla = new Gorilla(width/2, height/2);
  entities.add(gorilla);
  
  // Create humans
  for (int i = 0; i < numHumans; i++) {
    // Distribute humans around the edges
    float x, y;
    if (random(1) < 0.5) {
      // Place on horizontal edges
      x = random(width);
      y = (random(1) < 0.5) ? 50 : height - 50;
    } else {
      // Place on vertical edges
      x = (random(1) < 0.5) ? 50 : width - 50;
      y = random(height);
    }
    
    Human human = new Human(x, y);
    humans.add(human);
    entities.add(human);
  }
}

void updateSimulation() {
  // Update all entities
  for (Entity entity : entities) {
    entity.update();
  }
  
  // Check for collisions
  checkCollisions();
  
  // Update environment
  environment.update();
  
  // Collect statistics
  if (frameCounter % 30 == 0) {
    collectStatistics();
  }
}

void displaySimulation() {
  // Clear background
  background(220);
  
  // Display environment
  environment.display();
  
  // Display all entities
  for (Entity entity : entities) {
    entity.display();
  }
}

void checkCollisions() {
  // Check collisions between entities
  for (int i = 0; i < entities.size(); i++) {
    for (int j = i + 1; j < entities.size(); j++) {
      Entity a = entities.get(i);
      Entity b = entities.get(j);
      
      if (a.isCollidingWith(b)) {
        a.handleCollision(b);
        b.handleCollision(a);
      }
    }
  }
}

void collectStatistics() {
  // Count active humans
  int activeHumans = 0;
  for (Human human : humans) {
    if (human.isActive()) {
      activeHumans++;
    }
  }
  
  // Update statistics in GUI
  gui.updateStatistics(activeHumans, gorilla.getHealth());
}

boolean fileExists(String filename) {
  File file = new File(dataPath(filename));
  return file.exists();
}

void loadConfiguration(String filename) {
  // Load configuration from file
  String[] lines = loadStrings(filename);
  for (String line : lines) {
    String[] parts = split(line, "=");
    if (parts.length == 2) {
      String key = trim(parts[0]);
      String value = trim(parts[1]);
      
      if (key.equals("numHumans")) {
        numHumans = int(value);
      } else if (key.equals("worldWidth")) {
        worldWidth = float(value);
      } else if (key.equals("worldHeight")) {
        worldHeight = float(value);
      } else if (key.equals("gorillaStrength")) {
        gorilla.setStrength(float(value));
      }
    }
  }
}

// Mouse and keyboard interaction
void mousePressed() {
  gui.handleMousePressed(mouseX, mouseY);
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  } else if (key == '1') {
    simulationSpeed = 1;
  } else if (key == '2') {
    simulationSpeed = 2;
  } else if (key == '3') {
    simulationSpeed = 4;
  } else if (key == 'r' || key == 'R') {
    initializeSimulation();
  } else if (key == 's' || key == 'S') {
    saveStatistics("statistics.txt");
  }
}

void saveStatistics(String filename) {
  // Save current statistics to file
  String[] stats = new String[3];
  stats[0] = "Time: " + frameCount;
  stats[1] = "Active Humans: " + countActiveHumans();
  stats[2] = "Gorilla Health: " + gorilla.getHealth();
  saveStrings(dataPath(filename), stats);
}

int countActiveHumans() {
  int count = 0;
  for (Human human : humans) {
    if (human.isActive()) {
      count++;
    }
  }
  return count;
}
