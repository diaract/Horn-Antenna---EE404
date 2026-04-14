# Antenna Measurement Analysis using MATLAB

This repository contains a MATLAB script for analyzing antenna measurement data obtained from a Vector Network Analyzer (VNA). The script processes S11, VSWR, and Smith chart data exported in CSV format and generates both plots and numerical results.

---

##  Features

* Plots **S11 (dB) vs Frequency**
* Plots **VSWR vs Frequency** (full and zoomed view)
* Generates **Smith Chart visualization**
* Automatically detects:

  * Minimum S11
  * Minimum VSWR
* Computes **input impedance (Z)** using reflection coefficient (Γ)
* Displays results in a clean and report-ready format

---

##  Input Files

The script expects three CSV files exported from the VNA:

* `s11.csv` → Frequency vs S11 (dB)
* `vswr.csv` → Frequency vs VSWR
* `smith.csv` → Frequency, Re(S11), Im(S11)


