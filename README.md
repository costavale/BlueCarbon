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
3.  *bc_stock* (work in progress)

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

`cm_deco`, decompressed depth of each section expressed in cm    
`sect_h`, height of each section expressed in cm     
`volume`, volume of each section expressed in cm<sup>3</sup>   
`density`, density of each section expressed in g/cm<sup>3</sup>     
`c_org_est`, estimation of organic carbon concentration based on the linear relationship between LOI and c_org data provided       
`c_org_density`, density of organic carbon concentration expressed in g/cm<sup>3</sup>           
`c_org_dens_sect`, density of organic carbon concentration of each section expressed in g/cm<sup>2</sup>      

## 3. *bc_stock* (work in progress)

*bc_stock* calculates carbon stock 

`bc_stock(data, depth = 1)`

#### Arguments

- `data` dataframe with the following columns "ID", "cm_deco", "c_org_dens_sect"     

- `depth` used to standardize the amount of carbon stored. Default is 1 m

Every suggestions/comments/changes to improve all the codes are welcome :)
