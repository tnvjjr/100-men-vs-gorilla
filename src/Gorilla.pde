class Gorilla {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float maxForce;
  float aggression;
  float size;
  
  Gorilla(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    maxSpeed = 2;
    maxForce = 0.1;
    aggression = 0.5;
    size = 30;
  }
  
  void update(Human[] humans) {
    // Find nearest human
    Human nearestHuman = findNearestHuman(humans);
    if (nearestHuman != null) {
      PVector seekForce = seek(nearestHuman.position);
      seekForce.mult(aggression);
      applyForce(seekForce);
    }
    
    // Update position and velocity
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
    
    // Wrap around screen edges
    wrapEdges();
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  Human findNearestHuman(Human[] humans) {
    Human nearest = null;
    float minDist = Float.MAX_VALUE;
    
    for (Human human : humans) {
      float d = PVector.dist(position, human.position);
      if (d < minDist) {
        minDist = d;
        nearest = human;
      }
    }
    
    return nearest;
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }
  
  void wrapEdges() {
    if (position.x < 0) position.x = width;
    if (position.x > width) position.x = 0;
    if (position.y < 0) position.y = height;
    if (position.y > height) position.y = 0;
  }
  
  void display() {
    fill(100, 100, 100);
    noStroke();
    ellipse(position.x, position.y, size, size);
  }
  
  void setAggression(float value) {
    aggression = constrain(value, 0, 1);
  }
} 