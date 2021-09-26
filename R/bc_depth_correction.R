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
#' @param sampler_length name of the column with the total length of the sampler tube
#' @param sampler_diameter name of the column with the diameter of the sampler tube
#' @param internal_distance name of the column with distance between sampler top and core surface
#' @param external_distance name of the column with distance between sampler top and sediment surface
#' @param method linear or exponential correction
#' @return the initial sample_data with the addition of the corrected sample depth and volume
#' 
#' @export

bc_depth_correction <-
  function(core_data,
           sample_data,
           sampler_length = "sampler_length",
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
    
    # Stop if the required variables are not numeric
    if (!all(is.numeric(core_data[, sampler_length]),
             is.numeric(core_data[, sampler_diameter]),
             is.numeric(core_data[, internal_distance]),
             is.numeric(core_data[, external_distance]),
             is.numeric(sample_data[, depth]),
             is.numeric(sample_data[, weight]),
             is.numeric(sample_data[, volume]))
             ) {
      non_numeric <-
        !sapply(X = list(core_data[, sampler_length],
                         core_data[, sampler_diameter],
                         core_data[, internal_distance], 
                         core_data[, external_distance],
                         sample_data[, depth],
                         sample_data[, weight],
                         sample_data[, volume]),
                FUN = is.numeric)
      
      var_names <-
        c(sampler_length, sampler_diameter, internal_distance, external_distance, depth, weight, volume)
      
      stop("The following variables are not numeric:\n",
           paste(var_names[which(non_numeric)], sep = "\n"))
    }
    
    # estimate depth correction with "linear" model
    if (method == "linear") {
      
      # as more cores are/could be present, all the calculation are grouped by the Core_ID and sample_ID
      cm_observed <- 
        sample_data[, depth] + ((core_data[, sampler_length] - core_data[, external_distance]) - (core_data[, sampler_length] - core_data[, internal_distance]))
      
      # estimate compaction correction factor
      compaction_correction_factor <-
        (core_data[, sampler_length] - core_data[, internal_distance]) /
        (core_data[, sampler_length] - core_data[, external_distance])
      
      sample_data$depth_corrected <- 
        cm_observed * compaction_correction_factor
      
      sect_h <- 
        c(dplyr::first(sample_data[, depth_corrected]), diff(sample_data[, depth_corrected]))
      
      sample_data$volume <- 
        (((pi * (core_data[, sampler_diameter]/2)^2) * sect_h)/2) #volume is divided by two as half section is used
      
      sample_data$density <- 
        sample_data[, weight]/sample_data[, volume]
      
      return(sample_data)
    }
    
    # estimate depth correction with "exponential" model
    if(method == "exp") {
      
      test <- data.frame(x = c(((sampler_lenght - external_distance) - (sampler_lenght - internal_distance)), (sampler_lenght - external_distance)),
                         y = c(((sampler_lenght - external_distance) - (sampler_lenght - internal_distance)), 0.1))
      
      a <- as.numeric(stats::coef(drc::drm(y~x, data=test, fct=aomisc::DRC.expoDecay()))[1])
      b <- as.numeric(stats::coef(drc::drm(y~x, data=test, fct=aomisc::DRC.expoDecay()))[2])
      
      decomp$cm_obs <- data$cm + ((sampler_lenght - external_distance) - (sampler_lenght - internal_distance))
      decomp$cm_deco <- decomp$cm_obs -
        (a * exp(-b*decomp$cm_obs))
      decomp$sect_h <- c(dplyr::first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (sampler_diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume
      
      return(sample_data)
    }
  }
