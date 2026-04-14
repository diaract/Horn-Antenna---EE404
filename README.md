# 📡 Horn Antenna Measurement and Simulation Analysis

This repository contains MATLAB scripts used for the analysis and comparison of simulated and measured performance of a horn antenna designed to operate around **2 GHz**.

---

## Contents

- `EE404.m` → Main MATLAB script for all plots and analysis  
- `s11.csv` → Measured S11 data  
- `vswr.csv` → Measured VSWR data  
- `smith.csv` → Smith chart raw data  
- `HornS11.txt` → Simulated S11 data  
- `Horn VSWR.txt` → Simulated VSWR data  

---

## Features

The script performs the following:

### Measured Data Analysis
- S11 parameter plotting  
- VSWR plotting  
- Smith chart visualization  

### Comparison
- Simulated vs measured S11  
- Simulated vs measured VSWR  

### Calculations
- Minimum S11  
- Minimum VSWR  
- Reflection coefficient  
- Input impedance (from Smith chart data)  

---

## How to Run

1. Place all data files in the same folder as the MATLAB script.
2. Run the script in MATLAB:

```matlab
EE404
