#' bc_decomp
#'
#' This function uses six arguments
#' 
#' @param data data.frame with the following columns "ID" "cm" "weight" "LOI" "c_org".
#' @param sampler_length name of the column with the total length of the sampler tube
#' @param internal_distance The length in cm of the part of the sampler left outside of the sediment (from the inside of the sampler).
#' @param external_distance The length in cm of the part of the sampler left outside of the sediment (from the outside of the sampler).
#' @param sampler_diameter diameter in cm of the sampler
#' @param method used to estimate the decompressed depth of each section, "linear" or "exp". Default is "linear".
#' 
#' @export

bc_decomp <-
  function(data,
           sampler_length,
           internal_distance,
           external_distance,
           sampler_diameter,
           method = "linear") {
   
    # Stop if data is not a data.frame  
    if(!is.data.frame(data)){
      stop("data is not a data.frame")
    }
    
    # Stop if method is not linear or exp
    if (!(method %in% c("linear", "exp"))) {
      return("Method must be either 'linear' or 'exp'")
    }
    
    if (method == "linear") {
      

      decomp <- data.frame(data$ID)
      decomp$cm_obs <- data$cm + ((sampler_length - external_distance) - (sampler_length - internal_distance))

      corr_fact <- as.numeric((sampler_length - internal_distance) / (sampler_length - external_distance))

      decomp$cm_deco <- decomp$cm_obs * corr_fact
      decomp$sect_h <- c(dplyr::first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (sampler_diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume

      c <- as.numeric(stats::coef(stats::lm(c_org~LOI, data = data))[1])
      d <- as.numeric(stats::coef(stats::lm(c_org~LOI, data = data))[2])

      decomp$c_org_est <- (data$LOI * d) + c
      decomp$c_org_density <- decomp$density * (decomp$c_org_est/100)
      decomp$c_org_dens_sect <- decomp$c_org_density * decomp$sect_h

      return(decomp)
    }

    if(method == "exp") {
      test <- data.frame(x = c(((sampler_length - external_distance) - (sampler_length - internal_distance)), (sampler_length - external_distance)),
                         y = c(((sampler_length - external_distance) - (sampler_length - internal_distance)), 0.1))

      a <- as.numeric(stats::coef(drc::drm(y~x, data=test, fct=aomisc::DRC.expoDecay()))[1])
      b <- as.numeric(stats::coef(drc::drm(y~x, data=test, fct=aomisc::DRC.expoDecay()))[2])

      decomp <- data.frame(data$ID)
      decomp$cm_obs <- data$cm + ((sampler_length - external_distance) - (sampler_length - internal_distance))
      decomp$cm_deco <- decomp$cm_obs -
        (a * exp(-b*decomp$cm_obs))
      decomp$sect_h <- c(dplyr::first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (sampler_diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume

      c <- as.numeric(stats::coef(stats::lm(c_org~LOI, data = data))[1])
      d <- as.numeric(stats::coef(stats::lm(c_org~LOI, data = data))[2])

      decomp$c_org_est <- (data$LOI * d) + c
      decomp$c_org_density <- decomp$density * (decomp$c_org_est/100)
      decomp$c_org_dens_sect <- decomp$c_org_density * decomp$sect_h

      return(decomp)
    }
  }
