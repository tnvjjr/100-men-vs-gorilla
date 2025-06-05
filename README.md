# 100 Men vs Gorilla Simulation

A Processing-based simulation that models the complex interactions between a single gorilla and a crowd of 100 humans, incorporating psychological and behavioral factors.

## Project Overview

This simulation aims to create a realistic representation of crowd behavior and individual responses in the presence of a potentially threatening gorilla. The project uses Processing for visualization and G4P for the control interface.

### Key Features

- Real-time simulation of 100 humans and 1 gorilla
- Dual-window system:
  - Main simulation window showing the interaction
  - Control panel for parameter adjustment
- Psychological factors:
  - Fear response
  - Mob mentality
  - Group coordination
  - Panic behavior
- Adjustable parameters:
  - Gorilla aggression
  - Human fear sensitivity
  - Group cohesion
  - Speed and strength variables
  - Environment settings

## Setup Instructions

1. Install Processing (version 3.5.4 or later)
2. Install the G4P library through Processing's library manager
3. Clone this repository
4. Open the project in Processing
5. Run the simulation

## Project Structure

```
├── src/
│   ├── Main.pde           # Main simulation window
│   ├── ControlPanel.pde   # Control panel window
│   ├── Human.pde          # Human class
│   ├── Gorilla.pde        # Gorilla class
│   └── Environment.pde    # Environment settings
├── data/                  # Assets and resources
└── README.md             # This file
```

## MVP Features

### Phase 1 (Current)
- Basic movement system for humans and gorilla
- Simple collision detection
- Basic fear response (fleeing behavior)
- Minimal control panel with essential parameters

### Future Enhancements
- Advanced psychological modeling
- More complex group behaviors
- Additional environment types
- Enhanced visualization
- Statistical analysis of interactions

## Dependencies

- Processing 3.5.4+
- G4P Library 