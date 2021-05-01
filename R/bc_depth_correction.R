#' @title bc_depth_correction
#' 
#' @description Calculates corrected sample depth and sample volume to account for compaction (linear or exponential methods). 
#' User provides a core data.frame and a sample data.frame 
#' User can specify if the sample volume is estimated from a half of the core or in another way.
#' 
#' The function returns the sample data.frame modified with the addition of the estimated parameters
#' 
#' @param core_data data.frame with core properties
#' @param sample_data data.frame with sample properties
#' @param sampler_lenght name of the column with the total length of the sampler tube
#' @param sampler_diameter name of the column with the diameter of the sampler tube
#' @param internal_distance name of the column with distance between sampler top and core surface
#' @param external_distance name of the column with distance between sampler top and sediment surface
#' @param method linear or exponential correction
#' @return the initial data.frame with the addition of the corrected sample depth and volume

bc_depth_correction <-
  function(core_data,
           sample_data,
           sampler_lenght = "sampler_lenght",
           sampler_diameter = "sampler_diameter",
           internal_distance = "internal_distance",
           external_distance = "external_distance",
           method = "linear") {
    
    # Stop if core_data is not a data.frame  
    if(!is.data.frame(core_data)){
      stop("core_data is not a data.frame")
    }
    
    # Stop if sample_data is not a data.frame  
    if(!is.data.frame(sample_data)){
      stop("sample_data is not a data.frame")
    }
    
    # Stop if method is not linear or exp
    if (!(method %in% c("linear", "exp"))) {
      return("Method must be either 'linear' or 'exp'")
    }
    
    if (method == "linear") {
      
      decomp <- data.frame(data$ID)
      decomp$cm_obs <- data$cm + ((sampler_lenght - external_distance) - (sampler_lenght - internal_distance))
      
      corr_fact <- as.numeric((sampler_lenght - internal_distance) / (sampler_lenght - external_distance))
      
      decomp$cm_deco <- decomp$cm_obs * corr_fact
      decomp$sect_h <- c(dplyr::first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (sampler_diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume
      
      return(decomp)
    }
    
    if(method == "exp") {
      
      test <- data.frame(x = c(((sampler_lenght - external_distance) - (sampler_lenght - internal_distance)), (sampler_lenght - external_distance)),
                         y = c(((sampler_lenght - external_distance) - (sampler_lenght - internal_distance)), 0.1))
      
      a <- as.numeric(stats::coef(drc::drm(y~x, data=test, fct=aomisc::DRC.expoDecay()))[1])
      b <- as.numeric(stats::coef(drc::drm(y~x, data=test, fct=aomisc::DRC.expoDecay()))[2])
      
      decomp <- data.frame(data$ID)
      decomp$cm_obs <- data$cm + ((sampler_lenght - external_distance) - (sampler_lenght - internal_distance))
      decomp$cm_deco <- decomp$cm_obs -
        (a * exp(-b*decomp$cm_obs))
      decomp$sect_h <- c(dplyr::first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (sampler_diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume
      
      return(decomp)
    }
  }
