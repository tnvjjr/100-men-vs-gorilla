// Gorilla class - Extends Entity
// This class represents the gorilla with special abilities and behaviors

class Gorilla extends Entity {
  // Gorilla specific properties
  float territorialRange;
  float staminaLevel;
  float intimidationFactor;
  float roarCooldown;
  float chargeCooldown;
  float staminaRecoveryRate;
  float aggressionLevel;
  float territorialDefense;
  float lastRoarTime;
  float lastChargeTime;
  float restThreshold;
  float maxStamina;
  
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
    maxStamina = 100;
    intimidationFactor = 5.0;
    roarCooldown = 0;
    chargeCooldown = 0;
    staminaRecoveryRate = 0.1;
    aggressionLevel = 0.5;
    territorialDefense = 1.0;
    lastRoarTime = 0;
    lastChargeTime = 0;
    restThreshold = 30;
  }
  
  // Update method - override from Entity
  void update() {
    if (!active) return;
    
    // Decrease cooldowns
    if (roarCooldown > 0) roarCooldown--;
    if (chargeCooldown > 0) chargeCooldown--;
    
    // Recover stamina
    if (staminaLevel < maxStamina) {
      staminaLevel += staminaRecoveryRate;
      if (staminaLevel > maxStamina) staminaLevel = maxStamina;
    }
    
    // Find nearest human
    Human nearestHuman = findNearestHuman();
    
    // If a human is found, move toward it
    if (nearestHuman != null && nearestHuman.isActive()) {
      PVector target = nearestHuman.getPosition();
      PVector desired = PVector.sub(target, position);
      float distance = desired.mag();
      
      // If within territorial range, pursue
      if (distance < territorialRange) {
        // Increase aggression when humans are in territory
        aggressionLevel = min(1.0, aggressionLevel + 0.01);
        
        // Calculate pursuit speed based on stamina and aggression
        float pursuitSpeed = maxSpeed * (staminaLevel / maxStamina) * (1 + aggressionLevel * 0.5);
        
        desired.normalize();
        desired.mult(pursuitSpeed);
        
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        
        applyForce(steer);
        
        // Decide whether to roar or charge based on conditions
        if (roarCooldown <= 0 && random(1) < 0.01 * aggressionLevel && staminaLevel > 20) {
          roar();
        }
        
        if (chargeCooldown <= 0 && random(1) < 0.005 * aggressionLevel && staminaLevel > 30) {
          chargeAttack(nearestHuman);
        }
      } else {
        // Decrease aggression when no humans in territory
        aggressionLevel = max(0.5, aggressionLevel - 0.005);
      }
    }
    
    // Rest if stamina is low
    if (staminaLevel < restThreshold) {
      rest();
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
         
    // Draw stamina bar
    fill(255, 0, 0);
    rect(position.x - healthBarWidth/2, position.y - size/2 - 35, 
         healthBarWidth, healthBarHeight);
    
    fill(0, 0, 255);
    rect(position.x - healthBarWidth/2, position.y - size/2 - 35, 
         healthBarWidth * (staminaLevel / maxStamina), healthBarHeight);
  }
  
  // Handle collision - override from Entity
  void handleCollision(Entity other) {
    // If colliding with a human, deal damage
    if (other instanceof Human) {
      Human human = (Human)other;
      
      // Calculate damage based on speed and strength
      float impactForce = velocity.mag() * strength;
      human.health -= impactForce * 0.5;
      
      // Increase human's fear based on impact force
      human.applyFear(impactForce * 0.2);
      
      // Knockback effect
      PVector knockback = PVector.sub(human.position, position);
      knockback.normalize();
      knockback.mult(impactForce * 0.3);
      human.applyForce(knockback);
      
      // Take some damage from the collision
      health -= human.strength * 0.1;
      
      // Increase aggression on successful hit
      aggressionLevel = min(1.0, aggressionLevel + 0.1);
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
        // Calculate intimidation effect based on distance and aggression
        float effect = map(distance, 0, territorialRange, intimidationFactor * aggressionLevel, 0);
        
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
    lastRoarTime = millis();
  }
  
  // Charge attack - rush toward a target
  void chargeAttack(Human target) {
    if (staminaLevel < 30) return;
    
    // Calculate direction to target
    PVector direction = PVector.sub(target.position, position);
    direction.normalize();
    
    // Charge speed based on stamina and aggression
    float chargeSpeed = maxSpeed * 3 * (staminaLevel / maxStamina) * (1 + aggressionLevel);
    direction.mult(chargeSpeed);
    
    // Apply charge force
    velocity = direction.copy();
    
    // Set cooldown and use stamina
    chargeCooldown = 300;
    staminaLevel -= 30;
    lastChargeTime = millis();
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
    float totalThreat = 0;
    
    for (Human human : humans) {
      if (!human.isActive()) continue;
      
      float distance = PVector.dist(position, human.position);
      if (distance < territorialRange) {
        humansInTerritory++;
        // Calculate threat based on human's strength and health
        totalThreat += human.strength * (human.health / 50.0);
      }
    }
    
    // Adjust territorial defense based on threat level
    if (humansInTerritory > 0) {
      territorialDefense = 1.0 + (totalThreat / humansInTerritory) * 0.2;
      // Increase aggression when threatened
      aggressionLevel = min(1.0, aggressionLevel + 0.02);
    } else {
      territorialDefense = 1.0;
    }
  }
  
  // Rest to recover health and stamina
  void rest() {
    // Slow down
    maxSpeed = 1.0;
    
    // Recover faster when resting
    staminaLevel += staminaRecoveryRate * 2;
    health += 0.1;
    
    if (health > 500) health = 500;
    if (staminaLevel > maxStamina) staminaLevel = maxStamina;
    
    // Decrease aggression while resting
    aggressionLevel = max(0.5, aggressionLevel - 0.01);
  }
}
