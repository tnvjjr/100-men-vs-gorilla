// Entity class - Base class for Gorilla and Human
// This is the parent class that defines common properties and methods

class Entity {
  // Position and movement
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float maxForce;
  
  // Physical properties
  float size;
  float mass;
  
  // Status properties
  float health;
  float strength;
  boolean active;
  
  // Constructor
  Entity(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    maxSpeed = 2.0;
    maxForce = 0.1;
    size = 20;
    mass = 1.0;
    health = 100;
    strength = 1.0;
    active = true;
  }
  
  // Apply force to entity
  void applyForce(PVector force) {
    // F = m * a
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  // Update entity state
  void update() {
    if (!active) return;
    
    // Update velocity and position
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    
    // Reset acceleration
    acceleration.mult(0);
    
    // Boundary checking
    checkBoundaries();
  }
  
  // Display entity
  void display() {
    // Base display method - override in subclasses
    fill(200);
    ellipse(position.x, position.y, size, size);
  }
  
  // Check and handle boundary collisions
  void checkBoundaries() {
    // Bounce off edges
    if (position.x < size/2) {
      position.x = size/2;
      velocity.x *= -0.8;
    } else if (position.x > width - size/2) {
      position.x = width - size/2;
      velocity.x *= -0.8;
    }
    
    if (position.y < size/2) {
      position.y = size/2;
      velocity.y *= -0.8;
    } else if (position.y > height - size/2) {
      position.y = height - size/2;
      velocity.y *= -0.8;
    }
  }
  
  // Check collision with another entity
  boolean isCollidingWith(Entity other) {
    float distance = PVector.dist(position, other.position);
    return distance < (size/2 + other.size/2);
  }
  
  // Handle collision with another entity
  void handleCollision(Entity other) {
    // Base collision handling - override in subclasses
    // Simple physics response
    PVector force = PVector.sub(position, other.position);
    force.normalize();
    force.mult(strength);
    applyForce(force);
    
    // Health impact based on collision
    float damage = other.strength * 0.5;
    health -= damage;
    
    // Check if entity is still active
    if (health <= 0) {
      active = false;
    }
  }
  
  // Getters and setters
  float getHealth() {
    return health;
  }
  
  void setHealth(float h) {
    health = h;
  }
  
  float getStrength() {
    return strength;
  }
  
  void setStrength(float s) {
    strength = s;
  }
  
  boolean isActive() {
    return active;
  }
  
  void setActive(boolean a) {
    active = a;
  }
  
  PVector getPosition() {
    return position.copy();
  }
}
