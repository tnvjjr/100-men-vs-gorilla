// Gorilla class - Extends Entity
// This class represents the gorilla with special abilities and behaviors

class Gorilla extends Entity {
  // Gorilla specific properties
  float territorialRange;
  float staminaLevel;
  float intimidationFactor;
  float roarCooldown;
  float chargeCooldown;
  
  // Constructor
  Gorilla(float x, float y) {
    super(x, y);
    
    // Override base entity properties
    size = 60;
    mass = 5.0;
    maxSpeed = 3.0;
    health = 500;
    strength = 10.0;
    
    // Gorilla specific properties
    territorialRange = 200;
    staminaLevel = 100;
    intimidationFactor = 5.0;
    roarCooldown = 0;
    chargeCooldown = 0;
  }
  
  // Update method - override from Entity
  void update() {
    // Decrease cooldowns
    if (roarCooldown > 0) roarCooldown--;
    if (chargeCooldown > 0) chargeCooldown--;
    
    // Recover stamina
    if (staminaLevel < 100) {
      staminaLevel += 0.1;
    }
    
    // Find nearest human
    Human nearestHuman = findNearestHuman();
    
    // If a human is found, move toward it
    if (nearestHuman != null && nearestHuman.isActive()) {
      PVector target = nearestHuman.getPosition();
      PVector desired = PVector.sub(target, position);
      
      // If within territorial range, pursue
      if (desired.mag() < territorialRange) {
        desired.normalize();
        desired.mult(maxSpeed);
        
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        
        applyForce(steer);
        
        // Decide whether to roar or charge
        if (roarCooldown <= 0 && random(1) < 0.01) {
          roar();
        }
        
        if (chargeCooldown <= 0 && random(1) < 0.005) {
          chargeAttack(nearestHuman);
        }
      }
    }
    
    // Call the parent update method
    super.update();
  }
  
  // Display method - override from Entity
  void display() {
    if (!active) return;
    
    // Draw territorial range indicator
    noFill();
    stroke(255, 0, 0, 50);
    ellipse(position.x, position.y, territorialRange * 2, territorialRange * 2);
    
    // Draw gorilla
    fill(100, 60, 20);
    stroke(0);
    ellipse(position.x, position.y, size, size);
    
    // Draw health bar
    float healthBarWidth = size * 1.5;
    float healthBarHeight = 10;
    float healthPercentage = health / 500.0;
    
    fill(255, 0, 0);
    rect(position.x - healthBarWidth/2, position.y - size/2 - 20, 
         healthBarWidth, healthBarHeight);
    
    fill(0, 255, 0);
    rect(position.x - healthBarWidth/2, position.y - size/2 - 20, 
         healthBarWidth * healthPercentage, healthBarHeight);
  }
  
  // Handle collision - override from Entity
  void handleCollision(Entity other) {
    // If colliding with a human, deal damage
    if (other instanceof Human) {
      other.health -= strength * 0.5;
      
      // Knockback effect
      PVector knockback = PVector.sub(other.position, position);
      knockback.normalize();
      knockback.mult(strength * 0.3);
      other.applyForce(knockback);
      
      // Take some damage from the collision
      health -= other.strength * 0.1;
    }
    
    // Check if gorilla is still active
    if (health <= 0) {
      active = false;
    }
  }
  
  // Roar ability - intimidates nearby humans
  void roar() {
    if (staminaLevel < 20) return;
    
    // Visual effect
    fill(255, 0, 0, 100);
    ellipse(position.x, position.y, territorialRange * 2, territorialRange * 2);
    
    // Affect nearby humans
    for (Human human : humans) {
      if (!human.isActive()) continue;
      
      float distance = PVector.dist(position, human.position);
      if (distance < territorialRange) {
        // Calculate intimidation effect based on distance
        float effect = map(distance, 0, territorialRange, intimidationFactor, 0);
        
        // Apply fear effect to human
        human.applyFear(effect);
        
        // Push humans away
        PVector force = PVector.sub(human.position, position);
        force.normalize();
        force.mult(effect);
        human.applyForce(force);
      }
    }
    
    // Set cooldown and use stamina
    roarCooldown = 180;
    staminaLevel -= 20;
  }
  
  // Charge attack - rush toward a target
  void chargeAttack(Human target) {
    if (staminaLevel < 30) return;
    
    // Calculate direction to target
    PVector direction = PVector.sub(target.position, position);
    direction.normalize();
    direction.mult(maxSpeed * 3);
    
    // Apply charge force
    velocity = direction.copy();
    
    // Set cooldown and use stamina
    chargeCooldown = 300;
    staminaLevel -= 30;
  }
  
  // Find the nearest active human
  Human findNearestHuman() {
    Human nearest = null;
    float minDistance = Float.MAX_VALUE;
    
    for (Human human : humans) {
      if (!human.isActive()) continue;
      
      float distance = PVector.dist(position, human.position);
      if (distance < minDistance) {
        minDistance = distance;
        nearest = human;
      }
    }
    
    return nearest;
  }
  
  // Defend territory - called when humans enter territory
  void defendTerritory() {
    // Count humans in territory
    int humansInTerritory = 0;
    
    for (Human human : humans) {
      if (!human.isActive()) continue;
      
      float distance = PVector.dist(position, human.position);
      if (distance < territorialRange) {
        humansInTerritory++;
      }
    }
    
    // If many humans in territory, increase strength temporarily
    if (humansInTerritory > 5) {
      strength = 10.0 + (humansInTerritory * 0.2);
    } else {
      strength = 10.0;
    }
  }
  
  // Rest to recover health and stamina
  void rest() {
    if (staminaLevel < 50) {
      // Slow down
      maxSpeed = 1.0;
      
      // Recover faster
      staminaLevel += 0.3;
      health += 0.1;
      
      if (health > 500) health = 500;
    } else {
      maxSpeed = 3.0;
    }
  }
}
