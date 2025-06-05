// Human class - Extends Entity
// This class represents individual humans with fear mechanics and group behavior

class Human extends Entity {
  // Human specific properties
  float fearLevel;
  float fearDecay;
  float fearThreshold;
  float groupCohesion;
  float communicationRange;
  float lastFearUpdate;
  float panicLevel;
  float courageLevel;
  float groupInfluence;
  float lastGroupUpdate;
  float maxFear;
  
  // Constructor
  Human(float x, float y) {
    super(x, y);
    
    // Override base entity properties
    size = 20;
    mass = 1.0;
    maxSpeed = 4.0;
    health = 50;
    strength = 2.0;
    
    // Human specific properties
    fearLevel = 0;
    fearDecay = 0.1;
    fearThreshold = 0.5;
    groupCohesion = 0.5;
    communicationRange = 100;
    lastFearUpdate = 0;
    panicLevel = 0;
    courageLevel = 0.5;
    groupInfluence = 0.3;
    lastGroupUpdate = 0;
    maxFear = 1.0;
  }
  
  // Update method - override from Entity
  void update() {
    if (!active) return;
    
    // Update fear level
    updateFear();
    
    // Update group behavior
    updateGroupBehavior();
    
    // Find nearest gorilla
    Gorilla nearestGorilla = findNearestGorilla();
    
    // If a gorilla is found, react to it
    if (nearestGorilla != null && nearestGorilla.isActive()) {
      PVector gorillaPos = nearestGorilla.getPosition();
      float distance = PVector.dist(position, gorillaPos);
      
      // Calculate fear response
      float fearResponse = calculateFearResponse(distance, nearestGorilla);
      
      // Update fear level based on response
      applyFear(fearResponse);
      
      // Determine behavior based on fear level
      if (fearLevel > fearThreshold) {
        // Flee from gorilla
        flee(gorillaPos);
      } else {
        // Consider attacking if in a group and not too afraid
        if (isInGroup() && courageLevel > 0.7) {
          considerAttack(nearestGorilla);
        } else {
          // Maintain safe distance
          maintainDistance(gorillaPos);
        }
      }
    }
    
    // Call the parent update method
    super.update();
  }
  
  // Display method - override from Entity
  void display() {
    if (!active) return;
    
    // Draw human
    color humanColor = lerpColor(color(0, 255, 0), color(255, 0, 0), fearLevel);
    fill(humanColor);
    stroke(0);
    ellipse(position.x, position.y, size, size);
    
    // Draw health bar
    float healthBarWidth = size * 1.5;
    float healthBarHeight = 5;
    float healthPercentage = health / 50.0;
    
    fill(255, 0, 0);
    rect(position.x - healthBarWidth/2, position.y - size/2 - 15, 
         healthBarWidth, healthBarHeight);
    
    fill(0, 255, 0);
    rect(position.x - healthBarWidth/2, position.y - size/2 - 15, 
         healthBarWidth * healthPercentage, healthBarHeight);
         
    // Draw fear indicator
    fill(255, 0, 0);
    rect(position.x - healthBarWidth/2, position.y - size/2 - 25, 
         healthBarWidth, healthBarHeight);
    
    fill(0, 0, 255);
    rect(position.x - healthBarWidth/2, position.y - size/2 - 25, 
         healthBarWidth * fearLevel, healthBarHeight);
  }
  
  // Handle collision - override from Entity
  void handleCollision(Entity other) {
    // If colliding with a gorilla, take damage
    if (other instanceof Gorilla) {
      Gorilla gorilla = (Gorilla)other;
      
      // Calculate damage based on gorilla's strength and speed
      float impactForce = gorilla.velocity.mag() * gorilla.strength;
      health -= impactForce * 0.5;
      
      // Apply fear based on impact
      applyFear(impactForce * 0.3);
      
      // Knockback effect
      PVector knockback = PVector.sub(position, gorilla.position);
      knockback.normalize();
      knockback.mult(impactForce * 0.5);
      applyForce(knockback);
      
      // Increase panic level
      panicLevel = min(1.0, panicLevel + 0.2);
    }
    
    // Check if human is still active
    if (health <= 0) {
      active = false;
    }
  }
  
  // Update fear level
  void updateFear() {
    // Decay fear over time
    if (fearLevel > 0) {
      fearLevel -= fearDecay;
      if (fearLevel < 0) fearLevel = 0;
    }
    
    // Decay panic level
    if (panicLevel > 0) {
      panicLevel -= fearDecay * 0.5;
      if (panicLevel < 0) panicLevel = 0;
    }
    
    // Update courage based on group presence
    if (isInGroup()) {
      courageLevel = min(1.0, courageLevel + 0.01);
    } else {
      courageLevel = max(0.2, courageLevel - 0.005);
    }
    
    lastFearUpdate = millis();
  }
  
  // Update group behavior
  void updateGroupBehavior() {
    if (millis() - lastGroupUpdate < 100) return;
    
    // Find nearby humans
    ArrayList<Human> nearbyHumans = findNearbyHumans();
    
    // Calculate group influence
    if (!nearbyHumans.isEmpty()) {
      // Share fear levels
      float sharedFear = 0;
      for (Human human : nearbyHumans) {
        sharedFear += human.fearLevel;
      }
      sharedFear /= nearbyHumans.size();
      
      // Adjust fear based on group
      fearLevel = lerp(fearLevel, sharedFear, groupInfluence);
      
      // Increase group cohesion
      groupCohesion = min(1.0, groupCohesion + 0.01);
    } else {
      // Decrease group cohesion when alone
      groupCohesion = max(0.2, groupCohesion - 0.005);
    }
    
    lastGroupUpdate = millis();
  }
  
  // Find the nearest active gorilla
  Gorilla findNearestGorilla() {
    if (gorilla != null && gorilla.isActive()) {
      return gorilla;
    }
    return null;
  }
  
  // Find nearby humans
  ArrayList<Human> findNearbyHumans() {
    ArrayList<Human> nearby = new ArrayList<Human>();
    
    for (Human human : humans) {
      if (!human.isActive() || human == this) continue;
      
      float distance = PVector.dist(position, human.position);
      if (distance < communicationRange) {
        nearby.add(human);
      }
    }
    
    return nearby;
  }
  
  // Calculate fear response based on distance and gorilla behavior
  float calculateFearResponse(float distance, Gorilla gorilla) {
    float baseFear = map(distance, 0, 500, 1.0, 0);
    
    // Adjust fear based on gorilla's aggression
    baseFear *= (1 + gorilla.aggressionLevel * 0.5);
    
    // Adjust fear based on group presence
    if (isInGroup()) {
      baseFear *= (1 - groupCohesion * 0.3);
    }
    
    // Adjust fear based on courage
    baseFear *= (1 - courageLevel * 0.5);
    
    return baseFear;
  }
  
  // Apply fear to the human
  void applyFear(float amount) {
    fearLevel = min(maxFear, fearLevel + amount);
    
    // Increase panic if fear is high
    if (fearLevel > fearThreshold * 0.8) {
      panicLevel = min(1.0, panicLevel + amount * 0.5);
    }
  }
  
  // Flee from a position
  void flee(PVector target) {
    PVector desired = PVector.sub(position, target);
    desired.normalize();
    
    // Adjust speed based on fear and panic
    float fleeSpeed = maxSpeed * (1 + fearLevel * 0.5 + panicLevel * 0.3);
    desired.mult(fleeSpeed);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    
    applyForce(steer);
  }
  
  // Maintain safe distance from a position
  void maintainDistance(PVector target) {
    PVector desired = PVector.sub(position, target);
    float distance = desired.mag();
    
    // Calculate ideal distance based on fear
    float idealDistance = map(fearLevel, 0, 1, 100, 300);
    
    if (distance < idealDistance) {
      // Move away if too close
      desired.normalize();
      desired.mult(maxSpeed * 0.8);
    } else if (distance > idealDistance * 1.2) {
      // Move closer if too far (when in a group)
      if (isInGroup()) {
        desired.normalize();
        desired.mult(-maxSpeed * 0.5);
      }
    }
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    
    applyForce(steer);
  }
  
  // Consider attacking the gorilla
  void considerAttack(Gorilla gorilla) {
    // Only attack if in a group and not too afraid
    if (!isInGroup() || fearLevel > fearThreshold * 0.7) return;
    
    PVector desired = PVector.sub(gorilla.position, position);
    float distance = desired.mag();
    
    // Only attack if close enough
    if (distance < 100) {
      desired.normalize();
      desired.mult(maxSpeed * 0.8);
      
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      
      applyForce(steer);
    }
  }
  
  // Check if human is part of a group
  boolean isInGroup() {
    return !findNearbyHumans().isEmpty();
  }
}
