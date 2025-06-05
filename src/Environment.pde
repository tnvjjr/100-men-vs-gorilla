class Environment {
  ArrayList<PVector> obstacles;
  boolean isEnclosed;
  
  Environment() {
    obstacles = new ArrayList<PVector>();
    isEnclosed = false;
  }
  
  void update() {
    // Update environment state if needed
  }
  
  void display() {
    // Draw environment elements
    if (isEnclosed) {
      stroke(0);
      noFill();
      rect(0, 0, width, height);
    }
    
    // Draw obstacles
    fill(150);
    noStroke();
    for (PVector obstacle : obstacles) {
      ellipse(obstacle.x, obstacle.y, 20, 20);
    }
  }
  
  void addObstacle(float x, float y) {
    obstacles.add(new PVector(x, y));
  }
  
  void clearObstacles() {
    obstacles.clear();
  }
  
  void setEnclosed(boolean enclosed) {
    isEnclosed = enclosed;
  }
  
  boolean isPointInObstacle(PVector point) {
    for (PVector obstacle : obstacles) {
      if (PVector.dist(point, obstacle) < 10) {
        return true;
      }
    }
    return false;
  }
} 