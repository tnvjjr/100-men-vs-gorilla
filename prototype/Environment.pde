// Environment class
// This class handles the terrain, obstacles, and environmental effects

class Environment {
  // Environment properties
  float width, height;
  ArrayList<PVector> obstacles;
  ArrayList<PVector> resources;
  
  // Constructor
  Environment(float w, float h) {
    width = w;
    height = h;
    obstacles = new ArrayList<PVector>();
    resources = new ArrayList<PVector>();
    
    // Generate some random obstacles
    for (int i = 0; i < 5; i++) {
      float x = random(100, width - 100);
      float y = random(100, height - 100);
      obstacles.add(new PVector(x, y));
    }
    
    // Generate some resources
    for (int i = 0; i < 3; i++) {
      float x = random(100, width - 100);
      float y = random(100, height - 100);
      resources.add(new PVector(x, y));
    }
  }
  
  // Update environment state
  void update() {
    // Currently nothing to update in the environment
  }
  
  // Display environment
  void display() {
    // Draw background
    background(220);
    
    // Draw grid
    stroke(200);
    for (int x = 0; x < width; x += 50) {
      line(x, 0, x, height);
    }
    for (int y = 0; y < height; y += 50) {
      line(0, y, width, y);
    }
    
    // Draw obstacles
    fill(100);
    stroke(50);
    for (PVector obstacle : obstacles) {
      ellipse(obstacle.x, obstacle.y, 80, 80);
    }
    
    // Draw resources
    fill(0, 255, 0);
    stroke(0, 150, 0);
    for (PVector resource : resources) {
      ellipse(resource.x, resource.y, 40, 40);
    }
  }
  
  // Check if a position is inside an obstacle
  boolean isObstacle(float x, float y) {
    for (PVector obstacle : obstacles) {
      float distance = dist(x, y, obstacle.x, obstacle.y);
      if (distance < 40) {
        return true;
      }
    }
    return false;
  }
  
  // Check if a position is near a resource
  boolean isResource(float x, float y) {
    for (PVector resource : resources) {
      float distance = dist(x, y, resource.x, resource.y);
      if (distance < 20) {
        return true;
      }
    }
    return false;
  }
  
  // Generate terrain - currently just places obstacles
  void generateTerrain() {
    obstacles.clear();
    
    // Generate some random obstacles
    for (int i = 0; i < 5; i++) {
      float x = random(100, width - 100);
      float y = random(100, height - 100);
      obstacles.add(new PVector(x, y));
    }
  }
  
  // Place resources in the environment
  void placeResources() {
    resources.clear();
    
    // Generate some resources
    for (int i = 0; i < 3; i++) {
      float x = random(100, width - 100);
      float y = random(100, height - 100);
      resources.add(new PVector(x, y));
    }
  }
  
  // Affect movement of entities based on terrain
  void affectMovement(Entity entity) {
    // Slow down entities near obstacles
    for (PVector obstacle : obstacles) {
      float distance = dist(entity.position.x, entity.position.y, obstacle.x, obstacle.y);
      if (distance < 60) {
        // Apply friction near obstacles
        entity.velocity.mult(0.95);
      }
    }
  }
}
