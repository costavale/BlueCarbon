# Package planning

What is this document?
This is a little annoying, but if we're going to collaborate it's easier if we have a common vision of the package and some rules for naming and programming.

I combined in this document:  
  **1. Functionality**  
      + What do we expect the package to do, and what functions should be used for that goal?  
  **2. Ontology**  
      + The names we use throughout the package and documentation.  

# 1. Functionality
  1. Correct core depths to account for compaction  
        + Linear correction  
        + Exponential correction  
  2. Calculate elemental stocks
        + Trapezoid rule (Martins, M. et al 2021)
        + Rectangle rule (Howard, J. et al 2014)
  3. Calculate degradation rates
        + Exponential decay models (1, 2 and 3 compartments - see "traditional model" in Trevathan-Tecket, S. 2020)
  4. Sediment core vertical profile visualization
        + Plot variable (or list of variables)
        + Include picture of core
        + Plot profile from vertical description file
    

Possibly:    
  1. Estimate sedimentation rates?
    + If given dates for certain levels, we could use age models to estimate sedimentation/sequestration rates. This is more advanced and something to think for in the future
    
# 2. Ontology

 I propose the following , which is a combination of terms compiled from Howard, J. et al 2014 and from the [General Multilingual Environmental Thesaurus](https://www.eionet.europa.eu/gemet/en/themes/).

## Scientific terminology

**Blue carbon**: “The carbon stored in mangroves, tidal salt marshes, and seagrass meadows within the soil, the living biomass above-ground (leaves, branches, stems), the living biomass below-ground (roots), and the non-living biomass (litter and dead wood)” (Howard et al. 2014).

### Sample properties  

Some of these terms are not defined anywhere, but I am defining them here as they are often used in BC papers. Make sure to specify units when describing them in the methods. Units can vary but I include here the ones I use the most often

**Element content** - Concentration of the element (e.g organic carbon), expressed as a percentage or fraction of the dried weight of the sample (g element / g dw; %)

**Dry bulk density** - A property of a sediment sample which tells us the amount of dry material per volume of sample (g cm3)

**Element concentration** - Concentration of the element (e.g organic carbon), expressed as mass of element per volume of sample (g element cm3). Calculated as element content times dry bulk density.


### Properties of a BC ecosystem

**Carbon pool**: “Carbon pools refer to carbon reservoirs such as soil, vegetation, water, and the atmosphere that absorb and release carbon. Together carbon pools make up a carbon stock” (Howard et al. 2014).

**Carbon store:** Refers to the carbon that is kept in reservoirs such as plants or sediments but not necessarily accumulating in long term, since it can be converted into CO2 or exported to adjacent ecosystems.

**Carbon stock**: "Quantity of carbon in a “pool”, meaning a reservoir or system which has the capacity to accumulate or release carbon". Howard et al. 2014 adds that "a carbon stock is the sum of one or more carbon pools".
	- Important to realize that, while the definition of a carbon stock is the total carbon in a pool, they are often compared as **stock per area**
	
### Processes

**Carbon balance**: "Process of identifying and quantifying carbon in form of carbon dioxide (CO2) added to or removed from the earth's atmosphere, natural and human activity"

**Carbon sequestration**: "Biological process that absorbs carbon dioxide from the atmosphere and contains it in living organic matter, soil, or aquatic ecosystems"

**Carbon accumulation**: Process in which the carbon is retained in long term inside the ecosystems, in sediments as well as long term within the biomass.

### Variable naming

For programming, I think we should stick to the [tidyverse style guide](https://style.tidyverse.org/) as much as possible. The one thing I think is important is how to name things - camel_case. This means we don't use capitalized letters.

Function names should also be verbs with a meaning, so users can easily understand what the function does.


| Variable | Name | Description |
|----------|------|-------------|
| Core sampler length | sampler_length | Length of the core sampler used for the core extraction |
| Sampler internal diameter | sampler_diameter | Internal diameter of sampler used for the core extraction |
| Internal distance | internal_distance | Distance measured from the top of the sediment to the top of the core sampler, after hammering the sediment core |
| External distance | external_distance | Distance measured from the top of the sediment to the top of the core sampler, after hammering the sediment core | Core ID | core_id | Unique identifier used for sediment cores |


