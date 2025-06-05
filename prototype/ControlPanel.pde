// ControlPanel class
// This class handles the GP4 UI window for controlling simulation parameters

import gp4.*;

class ControlPanel {
  GP4UI ui;
  PApplet parent;
  int windowWidth = 400;
  int windowHeight = 800;
  
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
  ControlPanel(PApplet parent) {
    this.parent = parent;
    createControlPanel();
  }
  
  void createControlPanel() {
    // Create a new window for the control panel
    PSurface surface = parent.createSurface(windowWidth, windowHeight, P2D);
    surface.setTitle("Simulation Control Panel");
    
    // Initialize GP4 UI
    ui = new GP4UI(parent);
    
    // Create a panel for simulation controls
    GP4Panel panel = ui.createPanel("Simulation Controls", 20, 20, windowWidth - 40, windowHeight - 40);
    
    // Gorilla Controls
    panel.addLabel("GORILLA SETTINGS")
         .setPosition(20, 20);
         
    panel.addSlider("Gorilla Strength", 5, 20, gorillaStrength)
         .onChange(value -> {
           gorillaStrength = value;
           if (gorilla != null) gorilla.setStrength(value);
         });
         
    panel.addSlider("Gorilla Speed", 1, 5, gorillaSpeed)
         .onChange(value -> {
           gorillaSpeed = value;
           if (gorilla != null) gorilla.maxSpeed = value;
         });
         
    panel.addSlider("Gorilla Health", 200, 1000, gorillaHealth)
         .onChange(value -> {
           gorillaHealth = value;
           if (gorilla != null) gorilla.setHealth(value);
         });
         
    panel.addSlider("Territorial Range", 100, 400, gorillaTerritorialRange)
         .onChange(value -> {
           gorillaTerritorialRange = value;
           if (gorilla != null) gorilla.territorialRange = value;
         });
         
    panel.addSlider("Intimidation Factor", 1, 10, gorillaIntimidationFactor)
         .onChange(value -> {
           gorillaIntimidationFactor = value;
           if (gorilla != null) gorilla.intimidationFactor = value;
         });
         
    panel.addSlider("Stamina Recovery", 0.05, 0.3, gorillaStaminaRecovery)
         .onChange(value -> {
           gorillaStaminaRecovery = value;
           if (gorilla != null) gorilla.staminaRecoveryRate = value;
         });
    
    // Human Controls
    panel.addLabel("HUMAN SETTINGS")
         .setPosition(20, 200);
         
    panel.addSlider("Number of Humans", 10, 200, numHumans)
         .onChange(value -> numHumans = (int)value);
         
    panel.addSlider("Human Speed", 1, 4, humanSpeed)
         .onChange(value -> {
           humanSpeed = value;
           for (Human human : humans) human.maxSpeed = value;
         });
         
    panel.addSlider("Human Health", 20, 100, humanHealth)
         .onChange(value -> {
           humanHealth = value;
           for (Human human : humans) human.setHealth(value);
         });
         
    panel.addSlider("Human Strength", 0.5, 3, humanStrength)
         .onChange(value -> {
           humanStrength = value;
           for (Human human : humans) human.setStrength(value);
         });
         
    panel.addSlider("Fear Decay Rate", 0.005, 0.05, humanFearDecay)
         .onChange(value -> {
           humanFearDecay = value;
           for (Human human : humans) human.fearDecayRate = value;
         });
         
    panel.addSlider("Group Cohesion", 0.5, 2.0, humanGroupCohesion)
         .onChange(value -> {
           humanGroupCohesion = value;
           for (Human human : humans) human.groupCohesion = value;
         });
         
    panel.addSlider("Fear Threshold", 3, 8, humanFearThreshold)
         .onChange(value -> {
           humanFearThreshold = value;
           for (Human human : humans) human.fearThreshold = value;
         });
         
    panel.addSlider("Communication Range", 50, 200, humanCommunicationRange)
         .onChange(value -> {
           humanCommunicationRange = value;
           for (Human human : humans) human.communicationRange = value;
         });
    
    // Environment Controls
    panel.addLabel("ENVIRONMENT SETTINGS")
         .setPosition(20, 400);
         
    panel.addSlider("Environment Size", 500, 2000, environmentSize)
         .onChange(value -> {
           environmentSize = value;
           worldWidth = value;
           worldHeight = value * 0.8;
         });
         
    panel.addSlider("Obstacle Friction", 0.8, 0.99, obstacleFriction)
         .onChange(value -> {
           obstacleFriction = value;
           environment.obstacleFriction = value;
         });
         
    panel.addSlider("Number of Obstacles", 0, 10, numObstacles)
         .onChange(value -> {
           numObstacles = (int)value;
           environment.generateTerrain(numObstacles);
         });
    
    // Control Buttons
    panel.addButton("Reset Simulation")
         .onClick(() -> initializeSimulation());
         
    panel.addButton("Pause/Resume")
         .onClick(() -> paused = !paused);
    
    // Statistics Display
    panel.addLabel("SIMULATION STATISTICS")
         .setPosition(20, 600);
         
    panel.addLabel("Time: " + frameCounter)
         .setPosition(20, 620);
         
    panel.addLabel("Active Humans: " + countActiveHumans())
         .setPosition(20, 640);
         
    panel.addLabel("Gorilla Health: " + int(gorilla.getHealth()))
         .setPosition(20, 660);
         
    // Progress bars
    panel.addProgressBar("Gorilla Health", 0, 100)
         .setPosition(20, 680)
         .setSize(300, 20)
         .setValue(gorilla.getHealth() / gorillaHealth * 100);
         
    panel.addProgressBar("Human Count", 0, 100)
         .setPosition(20, 710)
         .setSize(300, 20)
         .setValue(float(countActiveHumans()) / numHumans * 100);
  }
  
  void display() {
    // Update statistics labels
    ui.updateLabel("Time: " + frameCounter, 20, 620);
    ui.updateLabel("Active Humans: " + countActiveHumans(), 20, 640);
    ui.updateLabel("Gorilla Health: " + int(gorilla.getHealth()), 20, 660);
    
    // Update progress bars
    ui.updateProgressBar("Gorilla Health", gorilla.getHealth() / gorillaHealth * 100);
    ui.updateProgressBar("Human Count", float(countActiveHumans()) / numHumans * 100);
  }
} 