import g4p_controls.*;

class ControlPanel {
  GWindow controlWindow;
  GSlider aggressionSlider;
  GSlider fearSlider;
  GSlider cohesionSlider;
  GCheckbox enclosedCheckbox;
  GButton resetButton;
  GLabel aggressionLabel;
  GLabel fearLabel;
  GLabel cohesionLabel;
  Human[] humans;
  Gorilla gorilla;
  Environment environment;
  
  ControlPanel(PApplet parentApplet, Human[] humans, Gorilla gorilla, Environment environment) {
    this.humans = humans;
    this.gorilla = gorilla;
    this.environment = environment;
    controlWindow = GWindow.getWindow(parentApplet, "Control Panel", 0, 0, 300, 400, JAVA2D);
    controlWindow.addDrawHandler(this, "drawControlPanel");
    
    aggressionLabel = new GLabel(controlWindow, 20, 10, 260, 20);
    aggressionLabel.setText("Gorilla Aggression");
    aggressionLabel.setOpaque(false);
    
    aggressionSlider = new GSlider(controlWindow, 20, 30, 260, 40, 20);
    aggressionSlider.setLimits(0.5, 0, 1);
    aggressionSlider.setEasing(1);
    aggressionSlider.setShowValue(true);
    aggressionSlider.setShowLimits(true);
    aggressionSlider.setTextOrientation(G4P.ORIENT_TRACK);
    aggressionSlider.setOpaque(true);
    aggressionSlider.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    aggressionSlider.addEventHandler(this, "handleSliderEvents");
    
    fearLabel = new GLabel(controlWindow, 20, 70, 260, 20);
    fearLabel.setText("Human Fear");
    fearLabel.setOpaque(false);
    
    fearSlider = new GSlider(controlWindow, 20, 90, 260, 40, 20);
    fearSlider.setLimits(0.5, 0, 1);
    fearSlider.setEasing(1);
    fearSlider.setShowValue(true);
    fearSlider.setShowLimits(true);
    fearSlider.setTextOrientation(G4P.ORIENT_TRACK);
    fearSlider.setOpaque(true);
    fearSlider.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    fearSlider.addEventHandler(this, "handleSliderEvents");
    
    cohesionLabel = new GLabel(controlWindow, 20, 130, 260, 20);
    cohesionLabel.setText("Group Cohesion");
    cohesionLabel.setOpaque(false);
    
    cohesionSlider = new GSlider(controlWindow, 20, 150, 260, 40, 20);
    cohesionSlider.setLimits(0.5, 0, 1);
    cohesionSlider.setEasing(1);
    cohesionSlider.setShowValue(true);
    cohesionSlider.setShowLimits(true);
    cohesionSlider.setTextOrientation(G4P.ORIENT_TRACK);
    cohesionSlider.setOpaque(true);
    cohesionSlider.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    cohesionSlider.addEventHandler(this, "handleSliderEvents");
    
    enclosedCheckbox = new GCheckbox(controlWindow, 20, 200, 260, 40);
    enclosedCheckbox.setText("Enclosed Environment");
    enclosedCheckbox.setOpaque(true);
    enclosedCheckbox.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    enclosedCheckbox.addEventHandler(this, "handleCheckboxEvents");
    
    resetButton = new GButton(controlWindow, 20, 260, 260, 40, "Reset Simulation");
    resetButton.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    resetButton.addEventHandler(this, "handleButtonEvents");
  }
  
  void drawControlPanel(PApplet appc, GWinData data) {
    appc.background(220);
  }
  
  void handleSliderEvents(GValueControl slider, GEvent event) {
    if (slider == aggressionSlider) {
      gorilla.setAggression(slider.getValueF());
    }
    // Add similar logic for other sliders if needed
  }
  
  void handleCheckboxEvents(GCheckbox checkbox, GEvent event) {
    if (checkbox == enclosedCheckbox) {
      environment.setEnclosed(checkbox.isSelected());
    }
  }
  
  void handleButtonEvents(GButton button, GEvent event) {
    if (button == resetButton) {
      // Reset simulation
      for (int i = 0; i < humans.length; i++) {
        humans[i].position = new PVector(random(width), random(height));
        humans[i].velocity = new PVector(0, 0);
        humans[i].acceleration = new PVector(0, 0);
      }
      gorilla.position = new PVector(width/2, height/2);
      gorilla.velocity = new PVector(0, 0);
      gorilla.acceleration = new PVector(0, 0);
      environment.clearObstacles();
    }
  }
} 