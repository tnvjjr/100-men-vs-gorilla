// GUI class
// This class handles the ControlP5 UI window for controlling simulation parameters

import controlP5.*;

class GUI {
  ControlP5 cp5;
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
  GUI(PApplet parent) {
    this.parent = parent;
    createGUI();
  }
  
  void createGUI() {
    // Create a new window for the GUI
    PSurface surface = parent.createSurface(windowWidth, windowHeight, P2D);
    surface.setTitle("Simulation Control Panel");
    
    // Initialize ControlP5
    cp5 = new ControlP5(parent);
    
    // Create a group for all controls
    Group simulationGroup = cp5.addGroup("Simulation Controls")
                              .setPosition(20, 20)
                              .setWidth(windowWidth - 40)
                              .setHeight(windowHeight - 40)
                              .setBackgroundColor(color(0, 100))
                              .setBarHeight(20);
    
    // Gorilla Controls
    cp5.addTextlabel("gorillaLabel", "GORILLA SETTINGS")
       .setPosition(20, 20)
       .setGroup(simulationGroup);
    
    cp5.addSlider("gorillaStrength")
       .setPosition(20, 40)
       .setSize(300, 20)
       .setRange(5, 20)
       .setValue(gorillaStrength)
       .setLabel("Gorilla Strength")
       .setGroup(simulationGroup)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           gorillaStrength = event.getController().getValue();
           if (gorilla != null) gorilla.setStrength(gorillaStrength);
         }
       });
    
    cp5.addSlider("gorillaSpeed")
       .setPosition(20, 70)
       .setSize(300, 20)
       .setRange(1, 5)
       .setValue(gorillaSpeed)
       .setLabel("Gorilla Speed")
       .setGroup(simulationGroup)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           gorillaSpeed = event.getController().getValue();
           if (gorilla != null) gorilla.maxSpeed = gorillaSpeed;
         }
       });
    
    cp5.addSlider("gorillaHealth")
       .setPosition(20, 100)
       .setSize(300, 20)
       .setRange(200, 1000)
       .setValue(gorillaHealth)
       .setLabel("Gorilla Health")
       .setGroup(simulationGroup)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           gorillaHealth = event.getController().getValue();
           if (gorilla != null) gorilla.setHealth(gorillaHealth);
         }
       });
    
    cp5.addSlider("territorialRange")
       .setPosition(20, 130)
       .setSize(300, 20)
       .setRange(100, 400)
       .setValue(gorillaTerritorialRange)
       .setLabel("Territorial Range")
       .setGroup(simulationGroup)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           gorillaTerritorialRange = event.getController().getValue();
           if (gorilla != null) gorilla.territorialRange = gorillaTerritorialRange;
         }
       });
    
    cp5.addSlider("intimidationFactor")
       .setPosition(20, 160)
       .setSize(300, 20)
       .setRange(1, 10)
       .setValue(gorillaIntimidationFactor)
       .setLabel("Intimidation Factor")
       .setGroup(simulationGroup)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           gorillaIntimidationFactor = event.getController().getValue();
           if (gorilla != null) gorilla.intimidationFactor = gorillaIntimidationFactor;
         }
       });
    
    // Human Controls
    cp5.addTextlabel("humanLabel", "HUMAN SETTINGS")
       .setPosition(20, 200)
       .setGroup(simulationGroup);
    
    cp5.addSlider("numHumans")
       .setPosition(20, 220)
       .setSize(300, 20)
       .setRange(10, 200)
       .setValue(numHumans)
       .setLabel("Number of Humans")
       .setGroup(simulationGroup)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           numHumans = (int)event.getController().getValue();
         }
       });
    
    cp5.addSlider("humanSpeed")
       .setPosition(20, 250)
       .setSize(300, 20)
       .setRange(1, 4)
       .setValue(humanSpeed)
       .setLabel("Human Speed")
       .setGroup(simulationGroup)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           humanSpeed = event.getController().getValue();
           for (Human human : humans) human.maxSpeed = humanSpeed;
         }
       });
    
    // Environment Controls
    cp5.addTextlabel("envLabel", "ENVIRONMENT SETTINGS")
       .setPosition(20, 400)
       .setGroup(simulationGroup);
    
    cp5.addSlider("environmentSize")
       .setPosition(20, 420)
       .setSize(300, 20)
       .setRange(500, 2000)
       .setValue(environmentSize)
       .setLabel("Environment Size")
       .setGroup(simulationGroup)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           environmentSize = event.getController().getValue();
           worldWidth = environmentSize;
           worldHeight = environmentSize * 0.8;
         }
       });
    
    // Control Buttons
    cp5.addButton("resetSimulation")
       .setPosition(20, 500)
       .setSize(140, 30)
       .setLabel("Reset Simulation")
       .setGroup(simulationGroup)
       .onClick(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           initializeSimulation();
         }
       });
    
    cp5.addButton("pauseResume")
       .setPosition(180, 500)
       .setSize(140, 30)
       .setLabel("Pause/Resume")
       .setGroup(simulationGroup)
       .onClick(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           paused = !paused;
         }
       });
    
    // Statistics Display
    cp5.addTextlabel("statsLabel", "SIMULATION STATISTICS")
       .setPosition(20, 600)
       .setGroup(simulationGroup);
    
    cp5.addTextlabel("timeLabel", "Time: 0")
       .setPosition(20, 620)
       .setGroup(simulationGroup);
    
    cp5.addTextlabel("humansLabel", "Active Humans: 0")
       .setPosition(20, 640)
       .setGroup(simulationGroup);
    
    cp5.addTextlabel("gorillaHealthLabel", "Gorilla Health: 0")
       .setPosition(20, 660)
       .setGroup(simulationGroup);
    
    // Progress bars
    cp5.addProgressBar("gorillaHealthBar")
       .setPosition(20, 680)
       .setSize(300, 20)
       .setRange(0, 100)
       .setValue(0)
       .setLabel("Gorilla Health")
       .setGroup(simulationGroup);
    
    cp5.addProgressBar("humanCountBar")
       .setPosition(20, 710)
       .setSize(300, 20)
       .setRange(0, 100)
       .setValue(0)
       .setLabel("Human Count")
       .setGroup(simulationGroup);
  }
  
  void display() {
    // Update statistics labels
    cp5.get(Textlabel.class, "timeLabel").setText("Time: " + frameCounter);
    cp5.get(Textlabel.class, "humansLabel").setText("Active Humans: " + countActiveHumans());
    cp5.get(Textlabel.class, "gorillaHealthLabel").setText("Gorilla Health: " + int(gorilla.getHealth()));
    
    // Update progress bars
    cp5.get(ProgressBar.class, "gorillaHealthBar").setValue(gorilla.getHealth() / gorillaHealth * 100);
    cp5.get(ProgressBar.class, "humanCountBar").setValue(float(countActiveHumans()) / numHumans * 100);
  }
} 