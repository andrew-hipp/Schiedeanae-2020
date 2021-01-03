# Schiedeanae-2020
Analysis scripts and data for Reznicek et al. 2021 monograph of _Carex_ section _Schiedeanae_ (CYPERACEAE)
in _Journal of Systematics and Evolution_.  
[![DOI](https://zenodo.org/badge/290276619.svg)](https://zenodo.org/badge/latestdoi/290276619)  

To execute analyses:
1. Analyze molecular data in RAxML by executing the shell script in `DNA.EDITED` using `sh doRax.schiedeanae.sh` if you would like to reanalyze the data. However, note that the analysis files generated for this paper are already included in the folder, so you do not need to run RAxML unless you want to. 
2. Open R within the directory called `WORKING`
3. Within R, execute scripts 01 -- 04 in order, e.g. `source('../SCRIPTS/00.ReadData.R')`
4. Inspect results within `OUT` folder
