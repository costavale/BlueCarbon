[![DOI](https://zenodo.org/badge/336005552.svg)](https://zenodo.org/badge/latestdoi/336005552)

# blue_carbon

The blue_carbon repository is a collection of functions with the main focus to help "blue carbon" scientists

The following packages need to be installed and loaded:
- *tidyverse*
- *drc*
- *aomisc*

```
library("tidyverse")
library("drc")
install.packages("remotes") # only the first time
remotes::install_github("OnofriAndreaPG/aomisc") # only the first time
library(aomisc)
```

At the moment, the following functions are presented:
1.  *bc_comp*
2.  *bc_decomp*
3. 

## 1. *bc_comp*

*bc_comp* calculates the **Percentage of core compression** and the **Linear Correction Factor** using three arguments 

`bc_comp(tube_lenght, core_in, core_out)`

#### Arguments

- `tube_length` lenght in cm of the sampler,
- `core_in` lenght in cm of the part of the sampler left outside of the sediment (from the inside of the sampler),
- `core_out`lenght in cm of the part of the sampler left outside of the sediment (from the outside of the sampler)

#### Output

**Percentage of core compression**, percentage of compression in the core
**Linear Correction Factor**, estimate the linear correction factor that can be applied assuming the same compression through all the core

## 2. *bc_decomp*

*bc_decomp* uses six arguments  

`bc_decomp(data, tube_lenght, core_in, core_out, diameter, method = "linear)`

#### Arguments

- `data` dataframe with the following columns "ID"	"cm"	"weight"	"LOI"	"c_org"

- `tube_length` lenght in cm of the sampler,
- `core_in` lenght in cm of the part of the sampler left outside of the sediment (from the inside of the sampler),
- `core_out`lenght in cm of the part of the sampler left outside of the sediment (from the outside of the sampler),
- `diameter` in cm of the sampler
- `method` used to estimate the decompressed depth of each section, "linear" or "exp". Default is "linear"

#### Output

The output is a dataframe that use the same "ID" of the data provided. For each row, the following information are calculated: 

**cm_deco**, decompressed depth of each section expressed in cm    
**sect_h**, height of each section expressed in cm     
**volume**, volume of each section expressed as      
**density**, density of each section expressed as     
**c_org_est**,      
**c_org_density**, 
**c_org_dens_sect**, 

Every suggestions/comments/changes to improve all the codes are welcome :)
