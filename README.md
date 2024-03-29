<!-- badges: start -->

[![DOI](https://zenodo.org/badge/336005552.svg)](https://zenodo.org/badge/latestdoi/336005552) [![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip) [![R-CMD-check](https://github.com/valybionda/BlueCarbon/workflows/R-CMD-check/badge.svg)](https://github.com/valybionda/BlueCarbon/actions)

<!-- badges: end -->

# BlueCarbon

**BlueCarbon** is a collection of functions with the main focus to help "blue carbon" scientists

## Installation

Please note that the *devtools*, *tidyverse*, *aomisc*, *drc* package are necessary, and must be available prior to the installation of 'BlueCarbon'.

    install.packages("tidyverse")  # only the first time
    install.packages("drc")  # only the first time

    install.packages("devtools") # only the first time
    devtools::install_github("OnofriAndreaPG/aomisc")

    library("aomisc")
    library("tidyverse")
    library("drc")

Install the BlueCarbon package (and the vignettes):

    # You can install (and update) the BlueCarbon package from GitHub

    devtools::install_github("costavale/BlueCarbon", build_vignettes = TRUE)

## Expected data format

To use the functions collected here, you need to provide 2 data.frame:

1.  Sediment core properties
2.  Sediment sample properties

The data is expected to follow [tidy data format](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html), with one observation per row and one variable per column.

### **1. Sediment core properties**

<img src="vignettes/core-table.png" alt="core-table" width="600"/>

<img src="vignettes/core-extraction.png" alt="core-extraction" align="right" width="230"/> In particular, for each core **core_ID** (one row per each core) the following information need to be provided :

1.  sampler_length, total length of the sampler
2.  sampler_diameter, internal diameter of the sampler
3.  internal_distance, distance between sampler top and core surface
4.  external_distance, distance between sampler top and sediment surface

### **2. Sediment sample properties**

<img src="vignettes/sample-table.png" alt="sample-table" width="600"/>

1.  Core_ID, **Important** use the same identification code in both data.frames as this column is the key to identify the core from which a sample is originated.
2.  sample_ID, identification code used to identify each sample
3.  depth, sampling depth in cm of each sample
4.  weight, weight in g of each sample
5.  LOI, value of each sample
6.  Corg, value of each sample
7.  other variables (optional)

## Contents

The following functions are presented:

1.  *bc_compaction* (WORKING)
2.  *bc_depth_correction* (WORK IN PROGRESS)
3.  *bc_decomp* (OLD VERSION - NOT WORKING)
4.  *bc_stock* (WORK IN PROGRESS)

### 1. bc_compaction

The user provides the core_data data.frame and the function calculates **compaction rates** (in percentage) adding a column in the data.frame.  
The function uses four arguments

    bc_compaction(
      core_data,
      sampler_lenght,
      internal_distance,
      external_distance)

#### Arguments

-   `core_data` data.frame with core properties
-   `sampler_lenght` name of the column with the length of the sampler,
-   `internal_distance` name of the column with the distance between sampler top and core surface,
-   `external_distance` name of the column with the distance between sampler top and sediment surface

#### Output

**compaction rates**, percentage of compression in the core

### 2. bc_depth_correction

The user provides the core_data data.frame and the sample_data sample data.frame and the function calculates **corrected sample depth** and **sample volume** to account for compaction (linear or exponential methods).

The user can specify if the sample volume is estimated from a half of the core or in another way.

The function returns the sample data.frame modified with the addition of the estimated parameters.

    bc_depth_correction(
      core_data,
      sample_data,
      sampler_lenght,
      sampler_diameter,
      internal_distance,
      external_distance,
      method)

#### Arguments

-   `core_data` data.frame with core properties,
-   `sample_data` data.frame with sample properties,
-   `sampler_length` name of the column with the length of the sampler,
-   `sampler_diameter` name of the column with the diameter of the sampler,
-   `internal_distance` name of the column with the distance between sampler top and core surface,
-   `external_distance` name of the column with the distance between sampler top and sediment surface
-   `method` used to estimate the decompressed depth of each section, "linear" or "exp". Default is "linear"

#### Output

**corrected sample depth**, sample depth corrected taking into account the compaction rate **sample volume**, volume of each sample corrected for the compaction rate

### 3. bc_decomp (OLD VERSION - NOT WORKING...)

    Suggestions:
    Break down in 2 functions:  

    1. Correct sample depth and sample volume to account for compaction (linear and exponential methods). Currently done in `bc_decomp`
            - User provides the core data.frame from `1` and another data.frame with the sample data. User can specify if the sample volume is estimated from a half of the core or if the sample volume was measured in another way.

    2. Estimate carbon content from LOI, using pre-measured values. Currently done in `bc_decomp`
            - User can provide some measurements of carbon content and organic matter. The OC content of samples where OC was NOT measured is then added (when OC was measured, that value is maintained). Also allows the user to provide more data that just the one being analyzed (if you are analyzing cores from one area but have more samples with measured OC contents and wnat to use them in your model)

    2.1 Add dry bulk density and carbon concentation (g cm3)

*bc_decomp* uses six arguments

`bc_decomp(data, tube_lenght, core_in, core_out, diameter, method = "linear)`

#### Arguments

-   `data` data.frame with the following columns "ID" "cm" "weight" "LOI" "c_org"
-   `tube_length` length in cm of the sampler,
-   `core_in` length in cm of the part of the sampler left outside of the sediment (from the inside of the sampler),
-   `core_out`length in cm of the part of the sampler left outside of the sediment (from the outside of the sampler),
-   `diameter` in cm of the sampler
-   `method` used to estimate the decompressed depth of each section, "linear" or "exp". Default is "linear"

#### Output

The output is a data.frame that use the same "ID" of the data provided. For each row, the following information are calculated:

`cm_deco`, decompressed depth of each section expressed in cm  
`sect_h`, height of each section expressed in cm  
`volume`, volume of each section expressed in cm<sup>3</sup>  
`density`, density of each section expressed in g/cm<sup>3</sup>  
`c_org_est`, estimation of organic carbon concentration based on the linear relationship between LOI and c_org data provided  
`c_org_density`, density of organic carbon concentration expressed in g/cm<sup>3</sup>  
`c_org_dens_sect`, density of organic carbon concentration of each section expressed in g/cm<sup>2</sup>

### 4. bc_stock (Work In Progress)

*bc_stock* calculates carbon stock

`bc_stock(data, depth = 1)`

#### Arguments

-   `data` data.frame with the following columns "ID", "cm_deco", "c_org_dens_sect"
-   `depth` used to standardize the amount of carbon stored. Default is 1 m

## Code of Conduct

Please note that the BlueCarbon project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
