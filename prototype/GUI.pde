// GUI class
// This class handles the G4P UI window for controlling simulation parameters

import g4p_controls.*;

class GUI {
  GWindow controlsWindow;
  GSlider gorillaStrengthSlider, gorillaSpeedSlider, gorillaHealthSlider;
  GSlider territorialRangeSlider, intimidationFactorSlider, staminaRecoverySlider;
  GSlider numHumansSlider, humanSpeedSlider, humanHealthSlider;
  GSlider environmentSizeSlider, obstacleFrictionSlider, numObstaclesSlider;
  GButton resetButton, pauseButton;
  GLabel statsLabel, timeLabel, humansLabel, gorillaHealthLabel;
  GProgressBar gorillaHealthBar, humanCountBar;
  
  // Simulation parameters
  int numHumans = 100;
  float gorillaStrength = 10.0;
  float gorillaSpeed = 3.0;
  float gorillaHealth = 500.0;
  float gorillaTerritorialRange = 200.0;
  float gorillaIntimidationFactor = 5.0;
  float gorillaStaminaRecovery = 0.1;
  
  float humanSpeed = 2.5;
  float humanHealth = 50.0;
  float humanStrength = 1.0;
  float humanFearDecay = 0.01;
  float humanGroupCohesion = 1.0;
  float humanFearThreshold = 5.0;
  float humanCommunicationRange = 100.0;
  
  float environmentSize = 1000.0;
  float obstacleFriction = 0.95;
  int numObstacles = 5;
  
  // Constructor
  GUI(PApplet parent) {
    createGUI(parent);
  }
  
  void createGUI(PApplet parent) {
    // Create control window
    controlsWindow = GWindow.getWindow(parent, "Simulation Controls", 0, 0, 400, 800, JAVA2D);
    controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
    controlsWindow.addDrawHandler(parent, "drawControlsWindow");
    
    // Gorilla Controls
    GLabel gorillaLabel = new GLabel(controlsWindow, 10, 10, 380, 20);
    gorillaLabel.setText("GORILLA SETTINGS");
    gorillaLabel.setOpaque(false);
    
    // Gorilla Strength Slider
    GLabel strengthLabel = new GLabel(controlsWindow, 10, 35, 100, 20);
    strengthLabel.setText("Strength:");
    strengthLabel.setOpaque(false);
    
    gorillaStrengthSlider = new GSlider(controlsWindow, 110, 35, 280, 20, 10);
    gorillaStrengthSlider.setLimits(gorillaStrength, 5, 20);
    gorillaStrengthSlider.setShowValue(true);
    gorillaStrengthSlider.setNumberFormat(G4P.DECIMAL, 1);
    gorillaStrengthSlider.setShowTicks(true);
    gorillaStrengthSlider.setNbrTicks(5);
    gorillaStrengthSlider.setEasing(6.5);
    gorillaStrengthSlider.setOpaque(true);
    gorillaStrengthSlider.setTextOrientation(G4P.ORIENT_LEFT);
    gorillaStrengthSlider.addEventHandler(parent, "handleGorillaStrength");
    
    // Gorilla Speed Slider
    GLabel speedLabel = new GLabel(controlsWindow, 10, 65, 100, 20);
    speedLabel.setText("Speed:");
    speedLabel.setOpaque(false);
    
    gorillaSpeedSlider = new GSlider(controlsWindow, 110, 65, 280, 20, 10);
    gorillaSpeedSlider.setLimits(gorillaSpeed, 1, 5);
    gorillaSpeedSlider.setShowValue(true);
    gorillaSpeedSlider.setNumberFormat(G4P.DECIMAL, 1);
    gorillaSpeedSlider.setShowTicks(true);
    gorillaSpeedSlider.setNbrTicks(5);
    gorillaSpeedSlider.setEasing(6.5);
    gorillaSpeedSlider.setOpaque(true);
    gorillaSpeedSlider.setTextOrientation(G4P.ORIENT_LEFT);
    gorillaSpeedSlider.addEventHandler(parent, "handleGorillaSpeed");
    
    // Human Controls
    GLabel humanLabel = new GLabel(controlsWindow, 10, 200, 380, 20);
    humanLabel.setText("HUMAN SETTINGS");
    humanLabel.setOpaque(false);
    
    // Number of Humans Slider
    GLabel numHumansLabel = new GLabel(controlsWindow, 10, 225, 100, 20);
    numHumansLabel.setText("Number:");
    numHumansLabel.setOpaque(false);
    
    numHumansSlider = new GSlider(controlsWindow, 110, 225, 280, 20, 10);
    numHumansSlider.setLimits(numHumans, 10, 200);
    numHumansSlider.setShowValue(true);
    numHumansSlider.setNumberFormat(G4P.INTEGER, 0);
    numHumansSlider.setShowTicks(true);
    numHumansSlider.setNbrTicks(5);
    numHumansSlider.setEasing(6.5);
    numHumansSlider.setOpaque(true);
    numHumansSlider.setTextOrientation(G4P.ORIENT_LEFT);
    numHumansSlider.addEventHandler(parent, "handleNumHumans");
    
    // Environment Controls
    GLabel envLabel = new GLabel(controlsWindow, 10, 400, 380, 20);
    envLabel.setText("ENVIRONMENT SETTINGS");
    envLabel.setOpaque(false);
    
    // Environment Size Slider
    GLabel envSizeLabel = new GLabel(controlsWindow, 10, 425, 100, 20);
    envSizeLabel.setText("Size:");
    envSizeLabel.setOpaque(false);
    
    environmentSizeSlider = new GSlider(controlsWindow, 110, 425, 280, 20, 10);
    environmentSizeSlider.setLimits(environmentSize, 500, 2000);
    environmentSizeSlider.setShowValue(true);
    environmentSizeSlider.setNumberFormat(G4P.INTEGER, 0);
    environmentSizeSlider.setShowTicks(true);
    environmentSizeSlider.setNbrTicks(5);
    environmentSizeSlider.setEasing(6.5);
    environmentSizeSlider.setOpaque(true);
    environmentSizeSlider.setTextOrientation(G4P.ORIENT_LEFT);
    environmentSizeSlider.addEventHandler(parent, "handleEnvironmentSize");
    
    // Control Buttons
    resetButton = new GButton(controlsWindow, 10, 500, 180, 30);
    resetButton.setText("Reset Simulation");
    resetButton.addEventHandler(parent, "handleReset");
    
    pauseButton = new GButton(controlsWindow, 210, 500, 180, 30);
    pauseButton.setText("Pause/Resume");
    pauseButton.addEventHandler(parent, "handlePause");
    
    // Statistics Display
    GLabel statsTitleLabel = new GLabel(controlsWindow, 10, 600, 380, 20);
    statsTitleLabel.setText("SIMULATION STATISTICS");
    statsTitleLabel.setOpaque(false);
    
    timeLabel = new GLabel(controlsWindow, 10, 625, 380, 20);
    timeLabel.setText("Time: 0");
    timeLabel.setOpaque(false);
    
    humansLabel = new GLabel(controlsWindow, 10, 650, 380, 20);
    humansLabel.setText("Active Humans: 0");
    humansLabel.setOpaque(false);
    
    gorillaHealthLabel = new GLabel(controlsWindow, 10, 675, 380, 20);
    gorillaHealthLabel.setText("Gorilla Health: 0");
    gorillaHealthLabel.setOpaque(false);
    
    // Progress bars
    gorillaHealthBar = new GProgressBar(controlsWindow, 10, 700, 380, 20);
    gorillaHealthBar.setLimits(0, 100);
    gorillaHealthBar.setValue(0);
    gorillaHealthBar.setTextVisible(true);
    gorillaHealthBar.setTextOrientation(G4P.ORIENT_LEFT);
    
    humanCountBar = new GProgressBar(controlsWindow, 10, 730, 380, 20);
    humanCountBar.setLimits(0, 100);
    humanCountBar.setValue(0);
    humanCountBar.setTextVisible(true);
    humanCountBar.setTextOrientation(G4P.ORIENT_LEFT);
  }
  
  void display() {
    // Update statistics labels
    timeLabel.setText("Time: " + frameCounter);
    humansLabel.setText("Active Humans: " + countActiveHumans());
    gorillaHealthLabel.setText("Gorilla Health: " + int(gorilla.getHealth()));
    
    // Update progress bars
    gorillaHealthBar.setValue(gorilla.getHealth() / gorillaHealth * 100);
    humanCountBar.setValue(float(countActiveHumans()) / numHumans * 100);
  }
}

// Event handlers for G4P controls
public void handleGorillaStrength(GSlider slider, GEvent event) {
  if (event == GEvent.VALUE_STEADY) {
    gorillaStrength = slider.getValueF();
    if (gorilla != null) gorilla.setStrength(gorillaStrength);
  }
}

public void handleGorillaSpeed(GSlider slider, GEvent event) {
  if (event == GEvent.VALUE_STEADY) {
    gorillaSpeed = slider.getValueF();
    if (gorilla != null) gorilla.maxSpeed = gorillaSpeed;
  }
}

public void handleNumHumans(GSlider slider, GEvent event) {
  if (event == GEvent.VALUE_STEADY) {
    numHumans = slider.getValueI();
  }
}

public void handleEnvironmentSize(GSlider slider, GEvent event) {
  if (event == GEvent.VALUE_STEADY) {
    environmentSize = slider.getValueF();
    worldWidth = environmentSize;
    worldHeight = environmentSize * 0.8;
  }
}

public void handleReset(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    initializeSimulation();
  }
}

public void handlePause(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    paused = !paused;
  }
}

// Draw handler for the control window
synchronized public void drawControlsWindow(PApplet appc, GWinData data) {
  appc.background(230);
} 