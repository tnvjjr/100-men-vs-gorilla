class Human {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float maxForce;
  float fearLevel;
  float size;
  
  Human(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    maxSpeed = 3;
    maxForce = 0.2;
    fearLevel = 0;
    size = 10;
  }
  
  void update(Gorilla gorilla, Human[] humans) {
    // Calculate fear based on distance to gorilla
    float distanceToGorilla = PVector.dist(position, gorilla.position);
    fearLevel = map(distanceToGorilla, 0, 300, 1, 0);
    
    // Apply forces
    PVector fleeForce = flee(gorilla);
    PVector cohesionForce = cohesion(humans);
    PVector separationForce = separation(humans);
    
    // Weight the forces based on fear level
    fleeForce.mult(fearLevel);
    cohesionForce.mult(1 - fearLevel);
    separationForce.mult(0.5);
    
    // Apply the forces
    applyForce(fleeForce);
    applyForce(cohesionForce);
    applyForce(separationForce);
    
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
  
  PVector flee(Gorilla gorilla) {
    PVector desired = PVector.sub(position, gorilla.position);
    float d = desired.mag();
    
    if (d < 100) {
      desired.normalize();
      desired.mult(maxSpeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      return steer;
    }
    return new PVector(0, 0);
  }
  
  PVector cohesion(Human[] humans) {
    PVector center = new PVector(0, 0);
    int count = 0;
    
    for (Human other : humans) {
      float d = PVector.dist(position, other.position);
      if (d > 0 && d < 50) {
        center.add(other.position);
        count++;
      }
    }
    
    if (count > 0) {
      center.div(count);
      return seek(center);
    }
    return new PVector(0, 0);
  }
  
  PVector separation(Human[] humans) {
    PVector steer = new PVector(0, 0);
    int count = 0;
    
    for (Human other : humans) {
      float d = PVector.dist(position, other.position);
      if (d > 0 && d < 25) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    
    if (count > 0) {
      steer.div(count);
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
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
    fill(0, 0, 255, map(fearLevel, 0, 1, 255, 100));
    noStroke();
    ellipse(position.x, position.y, size, size);
  }
} 