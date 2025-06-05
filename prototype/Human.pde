// Human class - Extends Entity
// This class represents the humans with group behaviors

class Human extends Entity {
  // Human specific properties
  float groupCohesion;
  float fearLevel;
  String role;
  PVector groupCenter;
  ArrayList<Human> neighbors;
  color humanColor;
  
  // Constructor
  Human(float x, float y) {
    super(x, y);
    
    // Override base entity properties
    size = 15;
    mass = 1.0;
    maxSpeed = 2.5;
    health = 50;
    strength = 1.0;
    
    // Human specific properties
    groupCohesion = random(0.5, 1.5);
    fearLevel = 0;
    neighbors = new ArrayList<Human>();
    
    // Assign random role
    float r = random(1);
    if (r < 0.7) {
      role = "follower";
      humanColor = color(0, 0, 255);
    } else if (r < 0.9) {
      role = "defender";
      humanColor = color(255, 0, 0);
      strength = 2.0;
    } else {
      role = "leader";
      humanColor = color(0, 255, 0);
      maxSpeed = 3.0;
    }
  }
  
  // Update method - override from Entity
  void update() {
    if (!active) return;
    
    // Update fear level
    if (fearLevel > 0) {
      fearLevel -= 0.01;
    }
    
    // Find neighbors
    findNeighbors(100);
    
    // Calculate group center
    calculateGroupCenter();
    
    // Apply behaviors based on role and situation
    if (fearLevel > 5) {
      // Flee from gorilla
      flee(gorilla.position);
    } else {
      // Normal behavior based on role
      if (role.equals("follower")) {
        followGroup();
        avoidGorilla(200);
      } else if (role.equals("defender")) {
        defendGroup();
      } else if (role.equals("leader")) {
        leadGroup();
      }
    }
    
    // Call the parent update method
    super.update();
  }
  
  // Display method - override from Entity
  void display() {
    if (!active) return;
    
    // Draw human
    fill(humanColor);
    stroke(0);
    ellipse(position.x, position.y, size, size);
    
    // Draw connections to neighbors
    if (neighbors.size() > 0) {
      stroke(200, 200, 200, 100);
      for (Human neighbor : neighbors) {
        if (neighbor.isActive()) {
          line(position.x, position.y, neighbor.position.x, neighbor.position.y);
        }
      }
    }
    
    // Draw fear indicator if afraid
    if (fearLevel > 0) {
      fill(255, 255, 0, map(fearLevel, 0, 10, 0, 255));
      noStroke();
      ellipse(position.x, position.y, size * 1.5, size * 1.5);
    }
  }
  
  // Handle collision - override from Entity
  void handleCollision(Entity other) {
    // If colliding with gorilla, take damage and increase fear
    if (other instanceof Gorilla) {
      health -= other.strength * 0.5;
      fearLevel += 3.0;
      
      // Knockback effect
      PVector knockback = PVector.sub(position, other.position);
      knockback.normalize();
      knockback.mult(other.strength * 0.2);
      applyForce(knockback);
    }
    
    // If colliding with another human, slight repulsion
    if (other instanceof Human) {
      PVector separation = PVector.sub(position, other.position);
      separation.normalize();
      separation.mult(0.3);
      applyForce(separation);
    }
    
    // Check if human is still active
    if (health <= 0) {
      active = false;
    }
  }
  
  // Find neighbors within a certain radius
  void findNeighbors(float radius) {
    neighbors.clear();
    
    for (Human human : humans) {
      if (human != this && human.isActive()) {
        float distance = PVector.dist(position, human.position);
        if (distance < radius) {
          neighbors.add(human);
        }
      }
    }
  }
  
  // Calculate the center of the group
  void calculateGroupCenter() {
    if (neighbors.size() == 0) {
      groupCenter = position.copy();
      return;
    }
    
    PVector sum = new PVector(0, 0);
    for (Human neighbor : neighbors) {
      sum.add(neighbor.position);
    }
    
    sum.div(neighbors.size());
    groupCenter = sum;
  }
  
  // Follow the group (cohesion behavior)
  void followGroup() {
    if (neighbors.size() == 0) return;
    
    // Move toward group center
    PVector desired = PVector.sub(groupCenter, position);
    desired.normalize();
    desired.mult(maxSpeed);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    steer.mult(groupCohesion);
    
    applyForce(steer);
    
    // Alignment - try to move in the same direction as neighbors
    PVector alignment = new PVector(0, 0);
    for (Human neighbor : neighbors) {
      alignment.add(neighbor.velocity);
    }
    
    if (neighbors.size() > 0) {
      alignment.div(neighbors.size());
      alignment.normalize();
      alignment.mult(maxSpeed);
      
      PVector alignSteer = PVector.sub(alignment, velocity);
      alignSteer.limit(maxForce);
      alignSteer.mult(0.5);
      
      applyForce(alignSteer);
    }
    
    // Separation - avoid crowding neighbors
    PVector separation = new PVector(0, 0);
    int count = 0;
    
    for (Human neighbor : neighbors) {
      float distance = PVector.dist(position, neighbor.position);
      if (distance > 0 && distance < size * 2) {
        PVector diff = PVector.sub(position, neighbor.position);
        diff.normalize();
        diff.div(distance);
        separation.add(diff);
        count++;
      }
    }
    
    if (count > 0) {
      separation.div(count);
      separation.normalize();
      separation.mult(maxSpeed);
      
      PVector sepSteer = PVector.sub(separation, velocity);
      sepSteer.limit(maxForce);
      sepSteer.mult(1.5);
      
      applyForce(sepSteer);
    }
  }
  
  // Defend the group (move toward gorilla)
  void defendGroup() {
    // Only defend if gorilla is near the group
    float distanceToGorilla = PVector.dist(groupCenter, gorilla.position);
    
    if (distanceToGorilla < 300 && fearLevel < 3) {
      // Move toward gorilla
      PVector desired = PVector.sub(gorilla.position, position);
      
      // But keep some distance
      if (desired.mag() < 100) {
        desired.normalize();
        desired.mult(-maxSpeed);  // Move away if too close
      } else {
        desired.normalize();
        desired.mult(maxSpeed);
      }
      
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      
      applyForce(steer);
    } else {
      // Otherwise follow the group
      followGroup();
    }
  }
  
  // Lead the group (move strategically)
  void leadGroup() {
    // Leaders try to position the group strategically
    
    // If gorilla is nearby, lead group away
    float distanceToGorilla = PVector.dist(position, gorilla.position);
    
    if (distanceToGorilla < 250) {
      // Lead away from gorilla
      PVector desired = PVector.sub(position, gorilla.position);
      desired.normalize();
      desired.mult(maxSpeed);
      
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      
      applyForce(steer);
      
      // Also try to move toward edges
      moveTowardEdge();
    } else {
      // Otherwise, try to surround gorilla from a distance
      surroundGorilla();
    }
  }
  
  // Move toward the nearest edge
  void moveTowardEdge() {
    PVector edgeDir = new PVector(0, 0);
    
    // Find direction to nearest edge
    if (position.x < width/2) {
      edgeDir.x = -1;
    } else {
      edgeDir.x = 1;
    }
    
    if (position.y < height/2) {
      edgeDir.y = -1;
    } else {
      edgeDir.y = 1;
    }
    
    edgeDir.normalize();
    edgeDir.mult(maxSpeed * 0.5);
    
    PVector steer = PVector.sub(edgeDir, velocity);
    steer.limit(maxForce);
    
    applyForce(steer);
  }
  
  // Try to surround gorilla from a distance
  void surroundGorilla() {
    // Calculate angle around gorilla
    PVector toGorilla = PVector.sub(gorilla.position, position);
    float distance = toGorilla.mag();
    
    // Only if at a safe distance
    if (distance > 200 && distance < 400) {
      float angle = toGorilla.heading();
      
      // Calculate position on circle around gorilla
      float targetAngle = angle + PI/6;  // Slightly offset
      float targetDistance = 300;
      
      float targetX = gorilla.position.x + cos(targetAngle) * targetDistance;
      float targetY = gorilla.position.y + sin(targetAngle) * targetDistance;
      
      PVector target = new PVector(targetX, targetY);
      
      // Move toward that position
      PVector desired = PVector.sub(target, position);
      desired.normalize();
      desired.mult(maxSpeed);
      
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      
      applyForce(steer);
    } else {
      // If too far, move closer to gorilla
      if (distance > 400) {
        PVector desired = PVector.sub(gorilla.position, position);
        desired.normalize();
        desired.mult(maxSpeed);
        
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        steer.mult(0.5);  // Move slowly toward gorilla
        
        applyForce(steer);
      }
      
      // If too close, move away
      if (distance < 200) {
        flee(gorilla.position);
      }
    }
  }
  
  // Flee from a position
  void flee(PVector target) {
    PVector desired = PVector.sub(position, target);
    float distance = desired.mag();
    
    if (distance < 250) {
      desired.normalize();
      desired.mult(maxSpeed);
      
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);
      
      // Flee stronger when closer
      float fleeFactor = map(distance, 0, 250, 3, 1);
      steer.mult(fleeFactor);
      
      applyForce(steer);
    }
  }
  
  // Avoid gorilla if within range
  void avoidGorilla(float range) {
    float distance = PVector.dist(position, gorilla.position);
    
    if (distance < range) {
      flee(gorilla.position);
    }
  }
  
  // Apply fear effect
  void applyFear(float amount) {
    fearLevel += amount;
    if (fearLevel > 10) {
      fearLevel = 10;
    }
  }
  
  // Communicate with nearby humans (increase their fear if this human is afraid)
  void communicate() {
    if (fearLevel > 3) {
      for (Human neighbor : neighbors) {
        if (neighbor.fearLevel < fearLevel) {
          neighbor.fearLevel += 0.5;
        }
      }
    }
  }
  
  // Form a group with nearby humans
  void formGroup() {
    // Already implemented through the neighbors system
  }
  
  // Calculate strategy based on group composition
  void calculateStrategy() {
    // Count roles in neighbors
    int leaders = 0;
    int defenders = 0;
    int followers = 0;
    
    for (Human neighbor : neighbors) {
      if (neighbor.role.equals("leader")) leaders++;
      if (neighbor.role.equals("defender")) defenders++;
      if (neighbor.role.equals("follower")) followers++;
    }
    
    // Adjust behavior based on group composition
    if (defenders > 3) {
      // With many defenders, be more aggressive
      if (role.equals("defender")) {
        strength *= 1.2;
      }
    }
    
    if (leaders == 0 && role.equals("follower") && random(1) < 0.1) {
      // If no leaders in group, followers might become leaders
      role = "leader";
      humanColor = color(0, 255, 0);
    }
  }
  
  // Retreat when heavily damaged
  void retreat() {
    if (health < 20) {
      // Move away from gorilla and toward edges
      flee(gorilla.position);
      moveTowardEdge();
    }
  }
}
