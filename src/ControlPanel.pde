import g4p_controls.*;

class ControlPanel {
  GWindow controlWindow;
  GSlider aggressionSlider;
  GSlider fearSlider;
  GSlider cohesionSlider;
  GCheckbox enclosedCheckbox;
  GButton resetButton;
  
  ControlPanel() {
    controlWindow = GWindow.getWindow(this, "Control Panel", 0, 0, 300, 400, JAVA2D);
    controlWindow.addDrawHandler(this, "drawControlPanel");
    
    // Create controls
    aggressionSlider = new GSlider(controlWindow, 20, 20, 260, 40, 20);
    aggressionSlider.setLimits(0.5, 0, 1);
    aggressionSlider.setEasing(1);
    aggressionSlider.setShowValue(true);
    aggressionSlider.setShowLimits(true);
    aggressionSlider.setTextOrientation(GAlign.LEFT, GAlign.TOP);
    aggressionSlider.setOpaque(true);
    aggressionSlider.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    aggressionSlider.setValueLabel("Gorilla Aggression");
    
    fearSlider = new GSlider(controlWindow, 20, 80, 260, 40, 20);
    fearSlider.setLimits(0.5, 0, 1);
    fearSlider.setEasing(1);
    fearSlider.setShowValue(true);
    fearSlider.setShowLimits(true);
    fearSlider.setTextOrientation(GAlign.LEFT, GAlign.TOP);
    fearSlider.setOpaque(true);
    fearSlider.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    fearSlider.setValueLabel("Human Fear");
    
    cohesionSlider = new GSlider(controlWindow, 20, 140, 260, 40, 20);
    cohesionSlider.setLimits(0.5, 0, 1);
    cohesionSlider.setEasing(1);
    cohesionSlider.setShowValue(true);
    cohesionSlider.setShowLimits(true);
    cohesionSlider.setTextOrientation(GAlign.LEFT, GAlign.TOP);
    cohesionSlider.setOpaque(true);
    cohesionSlider.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    cohesionSlider.setValueLabel("Group Cohesion");
    
    enclosedCheckbox = new GCheckbox(controlWindow, 20, 200, 260, 40);
    enclosedCheckbox.setText("Enclosed Environment");
    enclosedCheckbox.setOpaque(true);
    enclosedCheckbox.setLocalColorScheme(GCScheme.BLUE_SCHEME);
    
    resetButton = new GButton(controlWindow, 20, 260, 260, 40, "Reset Simulation");
    resetButton.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  }
  
  void drawControlPanel(PApplet appc, GWinData data) {
    appc.background(220);
  }
  
  void handleSliderEvents(GValueControl slider, GEvent event) {
    if (slider == aggressionSlider) {
      gorilla.setAggression(slider.getValueF());
    }
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
        humans[i] = new Human(random(width), random(height));
      }
      gorilla = new Gorilla(width/2, height/2);
      environment.clearObstacles();
    }
  }
} 