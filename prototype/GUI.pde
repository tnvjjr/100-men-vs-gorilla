// GUI class
// This class handles the user interface elements and controls

class GUI {
  // GUI properties
  boolean showStats = true;
  boolean showControls = true;
  int activeHumans = 100;
  float gorillaHealth = 500;
  
  // Button areas
  Rectangle pauseButton;
  Rectangle resetButton;
  Rectangle speedButton;
  Rectangle statsToggleButton;
  
  // Constructor
  GUI() {
    // Initialize button areas
    pauseButton = new Rectangle(20, 20, 80, 30);
    resetButton = new Rectangle(110, 20, 80, 30);
    speedButton = new Rectangle(200, 20, 80, 30);
    statsToggleButton = new Rectangle(290, 20, 80, 30);
  }
  
  // Display GUI elements
  void display() {
    // Draw control panel background
    fill(50, 50, 50, 200);
    noStroke();
    rect(10, 10, width - 20, 50);
    
    // Draw buttons
    drawButtons();
    
    // Draw statistics if enabled
    if (showStats) {
      drawStatistics();
    }
  }
  
  // Draw control buttons
  void drawButtons() {
    // Pause button
    if (paused) {
      fill(100, 200, 100);
    } else {
      fill(200, 100, 100);
    }
    rect(pauseButton.x, pauseButton.y, pauseButton.width, pauseButton.height);
    fill(255);
    textAlign(CENTER, CENTER);
    text(paused ? "PLAY" : "PAUSE", pauseButton.x + pauseButton.width/2, pauseButton.y + pauseButton.height/2);
    
    // Reset button
    fill(100, 100, 200);
    rect(resetButton.x, resetButton.y, resetButton.width, resetButton.height);
    fill(255);
    text("RESET", resetButton.x + resetButton.width/2, resetButton.y + resetButton.height/2);
    
    // Speed button
    fill(200, 150, 50);
    rect(speedButton.x, speedButton.y, speedButton.width, speedButton.height);
    fill(255);
    text("SPEED: " + simulationSpeed + "x", speedButton.x + speedButton.width/2, speedButton.y + speedButton.height/2);
    
    // Stats toggle button
    fill(150, 150, 150);
    rect(statsToggleButton.x, statsToggleButton.y, statsToggleButton.width, statsToggleButton.height);
    fill(255);
    text(showStats ? "HIDE STATS" : "SHOW STATS", statsToggleButton.x + statsToggleButton.width/2, statsToggleButton.y + statsToggleButton.height/2);
  }
  
  // Draw statistics panel
  void drawStatistics() {
    // Draw statistics panel background
    fill(50, 50, 50, 200);
    noStroke();
    rect(width - 210, 70, 200, 180);
    
    // Draw statistics text
    fill(255);
    textAlign(LEFT, TOP);
    text("SIMULATION STATISTICS", width - 200, 80);
    text("Time: " + frameCounter, width - 200, 100);
    text("Active Humans: " + activeHumans, width - 200, 120);
    text("Gorilla Health: " + int(gorillaHealth), width - 200, 140);
    
    // Draw human survival rate
    float survivalRate = float(activeHumans) / numHumans * 100;
    text("Survival Rate: " + nf(survivalRate, 0, 1) + "%", width - 200, 160);
    
    // Draw health bars
    text("Gorilla Health:", width - 200, 180);
    fill(255, 0, 0);
    rect(width - 200, 200, 180, 10);
    fill(0, 255, 0);
    rect(width - 200, 200, 180 * (gorillaHealth / 500), 10);
    
    text("Human Count:", width - 200, 220);
    fill(255, 0, 0);
    rect(width - 200, 240, 180, 10);
    fill(0, 255, 0);
    rect(width - 200, 240, 180 * (float(activeHumans) / numHumans), 10);
  }
  
  // Handle mouse pressed events
  void handleMousePressed(int mx, int my) {
    // Check if pause button was clicked
    if (pauseButton.contains(mx, my)) {
      paused = !paused;
    }
    
    // Check if reset button was clicked
    if (resetButton.contains(mx, my)) {
      initializeSimulation();
    }
    
    // Check if speed button was clicked
    if (speedButton.contains(mx, my)) {
      // Cycle through speeds: 1, 2, 4
      simulationSpeed = (simulationSpeed % 4) + 1;
      if (simulationSpeed == 3) simulationSpeed = 4;
    }
    
    // Check if stats toggle button was clicked
    if (statsToggleButton.contains(mx, my)) {
      showStats = !showStats;
    }
  }
  
  // Update statistics
  void updateStatistics(int humans, float health) {
    activeHumans = humans;
    gorillaHealth = health;
  }
  
  // Rectangle helper class for button areas
  class Rectangle {
    float x, y, width, height;
    
    Rectangle(float x, float y, float w, float h) {
      this.x = x;
      this.y = y;
      this.width = w;
      this.height = h;
    }
    
    boolean contains(float px, float py) {
      return (px >= x && px <= x + width && py >= y && py <= y + height);
    }
  }
}
