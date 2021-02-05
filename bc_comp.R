bc_comp <-
  function(tube_lenght, core_in, core_out) {
    
    ## compute percentage of core compression 
    compr <- (core_in - core_out) * 100 / (tube_lenght - core_out)
    
    ## compute correction factor 
    corr <- (tube_lenght - core_in) / (tube_lenght - core_out)
    
    list("Percentage of core compression" = compr,
         "Correction factor" = corr)
  }
