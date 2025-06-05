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
  GSlider gorillaHealthBar, humanCountBar; // Use GSlider as progress bar
  GLabel titleLabel;
  
  // Stats to display
  int currentFrame = 0;
  int currentActiveHumans = 0;
  float currentGorillaHealth = 0;
  
  // Simulation parameters (GUI values)
  int guiNumHumans = 100;
  float guiGorillaStrength = 10.0;
  float guiGorillaSpeed = 3.0;
  float guiEnvironmentSize = 1000.0;
  
  // Constructor
  GUI(PApplet parent) {
    createGUI(parent);
  }
  
  void createGUI(PApplet parent) {
    controlsWindow = GWindow.getWindow(parent, "Simulation Controls", 0, 0, 420, 820, JAVA2D);
    controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
    controlsWindow.addDrawHandler(this, "drawControlsWindow");
    controlsWindow.setBackground(color(245, 245, 255));
    
    int y = 10;
    titleLabel = new GLabel(controlsWindow, 0, y, 420, 30);
    titleLabel.setText("Gorilla vs Humans Simulation");
    titleLabel.setFont(new GFont(this, "Arial", 18, true));
    titleLabel.setOpaque(false);
    titleLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    y += 35;
    
    GLabel gorillaLabel = new GLabel(controlsWindow, 10, y, 400, 20);
    gorillaLabel.setText("GORILLA SETTINGS");
    gorillaLabel.setFont(new GFont(this, "Arial", 14, true));
    gorillaLabel.setOpaque(false);
    y += 25;
    
    GLabel strengthLabel = new GLabel(controlsWindow, 20, y, 100, 20);
    strengthLabel.setText("Strength:");
    strengthLabel.setOpaque(false);
    gorillaStrengthSlider = new GSlider(controlsWindow, 120, y, 260, 20, 10);
    gorillaStrengthSlider.setLimits(guiGorillaStrength, 5, 20);
    gorillaStrengthSlider.setShowValue(true);
    gorillaStrengthSlider.setNumberFormat(G4P.DECIMAL, 1);
    gorillaStrengthSlider.setShowTicks(true);
    gorillaStrengthSlider.setNbrTicks(5);
    gorillaStrengthSlider.setEasing(6.5);
    gorillaStrengthSlider.setOpaque(true);
    gorillaStrengthSlider.setTextOrientation(G4P.ORIENT_LEFT);
    gorillaStrengthSlider.addEventHandler(this, "handleGorillaStrength");
    y += 30;
    
    GLabel speedLabel = new GLabel(controlsWindow, 20, y, 100, 20);
    speedLabel.setText("Speed:");
    speedLabel.setOpaque(false);
    gorillaSpeedSlider = new GSlider(controlsWindow, 120, y, 260, 20, 10);
    gorillaSpeedSlider.setLimits(guiGorillaSpeed, 1, 5);
    gorillaSpeedSlider.setShowValue(true);
    gorillaSpeedSlider.setNumberFormat(G4P.DECIMAL, 1);
    gorillaSpeedSlider.setShowTicks(true);
    gorillaSpeedSlider.setNbrTicks(5);
    gorillaSpeedSlider.setEasing(6.5);
    gorillaSpeedSlider.setOpaque(true);
    gorillaSpeedSlider.setTextOrientation(G4P.ORIENT_LEFT);
    gorillaSpeedSlider.addEventHandler(this, "handleGorillaSpeed");
    y += 40;
    
    GLabel humanLabel = new GLabel(controlsWindow, 10, y, 400, 20);
    humanLabel.setText("HUMAN SETTINGS");
    humanLabel.setFont(new GFont(this, "Arial", 14, true));
    humanLabel.setOpaque(false);
    y += 25;
    
    GLabel numHumansLabel = new GLabel(controlsWindow, 20, y, 100, 20);
    numHumansLabel.setText("Number:");
    numHumansLabel.setOpaque(false);
    numHumansSlider = new GSlider(controlsWindow, 120, y, 260, 20, 10);
    numHumansSlider.setLimits(guiNumHumans, 10, 200);
    numHumansSlider.setShowValue(true);
    numHumansSlider.setNumberFormat(G4P.INTEGER, 0);
    numHumansSlider.setShowTicks(true);
    numHumansSlider.setNbrTicks(5);
    numHumansSlider.setEasing(6.5);
    numHumansSlider.setOpaque(true);
    numHumansSlider.setTextOrientation(G4P.ORIENT_LEFT);
    numHumansSlider.addEventHandler(this, "handleNumHumans");
    y += 40;
    
    GLabel envLabel = new GLabel(controlsWindow, 10, y, 400, 20);
    envLabel.setText("ENVIRONMENT SETTINGS");
    envLabel.setFont(new GFont(this, "Arial", 14, true));
    envLabel.setOpaque(false);
    y += 25;
    
    GLabel envSizeLabel = new GLabel(controlsWindow, 20, y, 100, 20);
    envSizeLabel.setText("Size:");
    envSizeLabel.setOpaque(false);
    environmentSizeSlider = new GSlider(controlsWindow, 120, y, 260, 20, 10);
    environmentSizeSlider.setLimits(guiEnvironmentSize, 500, 2000);
    environmentSizeSlider.setShowValue(true);
    environmentSizeSlider.setNumberFormat(G4P.INTEGER, 0);
    environmentSizeSlider.setShowTicks(true);
    environmentSizeSlider.setNbrTicks(5);
    environmentSizeSlider.setEasing(6.5);
    environmentSizeSlider.setOpaque(true);
    environmentSizeSlider.setTextOrientation(G4P.ORIENT_LEFT);
    environmentSizeSlider.addEventHandler(this, "handleEnvironmentSize");
    y += 50;
    
    resetButton = new GButton(controlsWindow, 40, y, 150, 35);
    resetButton.setText("Reset Simulation");
    resetButton.setFont(new GFont(this, "Arial", 13, true));
    resetButton.addEventHandler(this, "handleReset");
    pauseButton = new GButton(controlsWindow, 230, y, 150, 35);
    pauseButton.setText("Pause/Resume");
    pauseButton.setFont(new GFont(this, "Arial", 13, true));
    pauseButton.addEventHandler(this, "handlePause");
    y += 60;
    
    GLabel statsTitleLabel = new GLabel(controlsWindow, 10, y, 400, 20);
    statsTitleLabel.setText("SIMULATION STATISTICS");
    statsTitleLabel.setFont(new GFont(this, "Arial", 14, true));
    statsTitleLabel.setOpaque(false);
    y += 25;
    
    timeLabel = new GLabel(controlsWindow, 20, y, 380, 20);
    timeLabel.setText("Time: 0");
    timeLabel.setOpaque(false);
    y += 20;
    humansLabel = new GLabel(controlsWindow, 20, y, 380, 20);
    humansLabel.setText("Active Humans: 0");
    humansLabel.setOpaque(false);
    y += 20;
    gorillaHealthLabel = new GLabel(controlsWindow, 20, y, 380, 20);
    gorillaHealthLabel.setText("Gorilla Health: 0");
    gorillaHealthLabel.setOpaque(false);
    y += 30;
    gorillaHealthBar = new GSlider(controlsWindow, 20, y, 380, 20, 10);
    gorillaHealthBar.setLimits(0, 0, 100);
    gorillaHealthBar.setShowValue(true);
    gorillaHealthBar.setNumberFormat(G4P.INTEGER, 0);
    gorillaHealthBar.setShowTicks(false);
    gorillaHealthBar.setOpaque(true);
    gorillaHealthBar.setTextOrientation(G4P.ORIENT_LEFT);
    gorillaHealthBar.setEnabled(false);
    y += 30;
    humanCountBar = new GSlider(controlsWindow, 20, y, 380, 20, 10);
    humanCountBar.setLimits(0, 0, 100);
    humanCountBar.setShowValue(true);
    humanCountBar.setNumberFormat(G4P.INTEGER, 0);
    humanCountBar.setShowTicks(false);
    humanCountBar.setOpaque(true);
    humanCountBar.setTextOrientation(G4P.ORIENT_LEFT);
    humanCountBar.setEnabled(false);
  }

  void handleGorillaStrength(GSlider slider, GEvent event) {
    if (event == GEvent.VALUE_STEADY) {
      guiGorillaStrength = slider.getValueF();
    }
  }

  void handleGorillaSpeed(GSlider slider, GEvent event) {
    if (event == GEvent.VALUE_STEADY) {
      guiGorillaSpeed = slider.getValueF();
    }
  }

  void handleNumHumans(GSlider slider, GEvent event) {
    if (event == GEvent.VALUE_STEADY) {
      guiNumHumans = slider.getValueI();
    }
  }

  void handleEnvironmentSize(GSlider slider, GEvent event) {
    if (event == GEvent.VALUE_STEADY) {
      guiEnvironmentSize = slider.getValueF();
    }
  }

  void handleReset(GButton _button, GEvent event) {
    if (event == GEvent.CLICKED) {
      // Copy GUI values to simulation globals and re-initialize
      numHumans = guiNumHumans;
      worldWidth = guiEnvironmentSize;
      worldHeight = guiEnvironmentSize * 0.8;
      // Gorilla parameters
      if (gorilla != null) {
        gorilla.setStrength(guiGorillaStrength);
        gorilla.maxSpeed = guiGorillaSpeed;
      }
      initializeSimulation();
    }
  }

  void handlePause(GButton _button, GEvent event) {
    if (event == GEvent.CLICKED) {
      paused = !paused;
    }
  }

  // Draw handler for the control window
  synchronized public void drawControlsWindow(PApplet appc, GWinData _data) {
    appc.background(245, 245, 255);
    // Update statistics labels
    timeLabel.setText("Time: " + currentFrame);
    humansLabel.setText("Active Humans: " + currentActiveHumans);
    gorillaHealthLabel.setText("Gorilla Health: " + int(currentGorillaHealth));
    // Update progress bars
    gorillaHealthBar.setValue(currentGorillaHealth / (guiGorillaStrength * 50) * 100);
    humanCountBar.setValue(currentActiveHumans / float(guiNumHumans) * 100);
  }
} 