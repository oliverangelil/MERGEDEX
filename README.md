# MERGEDEX
First performs quality control on HadEX2 and GHCND and then replaces missing values in GHCND with HadEX2.

### Details:
Quality Control (QC): valid grid cells where all of the following are true (applied separately to GHCND and HadEX2 netCDF files):
- at least 80% of time-steps are non-missing in the first 10 years
- at least 80% of time-steps are non-missing in the last 10 years
- at least 80% of time-steps are non-missing in the full period

Then, at each grid cell and time step, if value for QC'd GHCND is missing, replace with value from QC'd HadEX2.
