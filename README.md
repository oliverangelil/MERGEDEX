## MERGEDEX (specifically for PRCPTOT and RX1day indices in this script, but can be expanded to any ETCCDI indices)
First performs Quality Control (QC) on HadEX2 and GHCND and then replaces missing values in GHCND with HadEX2.

### Details:
QC: mask-out grid cells except for where all of the following are true (applied separately to GHCND and HadEX2 netCDF files):
- at least 80% of time-steps are non-missing in the first 10 years
- at least 80% of time-steps are non-missing in the last 10 years
- at least 80% of time-steps are non-missing in the full period

Merging: at each grid cell and time step, if value for QC'd GHCND is missing, replace with value from QC'd HadEX2.

Note: both GHCND and HadEX2 must be described by the same grids. 
