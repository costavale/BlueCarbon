<<<<<<< HEAD:bc_decomp.R
# Correct sample depth and sample volume to account for compression of the sediment core
# Takes in 2 data.frames: one with the sample properties and one with the core properties


correct_compression <- function(
  sample_data,             
  core_data,
  core_id,
  sample_depth,
  sample_volume = "half-core",  
  core_diameter,
  slice_height,
  method = "linear") {
  
  if(!all(is.data.frame(sample_data), is.data.frame(core_data))){
    stop("data is not a data.frame")
  }
  
  # Calculate uncorrected sample volume 
    # If the sample volume is estimated from half-core
  if(sample_volume == "half-core"){ 
    # check that the diameter column is present in the core_data
    if(!core_diameter %in% names(core_data)){
      stop("Core diameter column does not exist in sample_data")
    }
    if(!slice_height %in% names(sample_data)){
      stop("Slice height column does not exist in sample_data")
    }
    
    sample_data_tmp <- merge(
      sample_data, 
      core_data[, c(core_id, core_diameter)],
      by = core_id
    )
    
    sample_data_tmp$sample_volume <- pi    *   # pi
      (sample_data_tmp[, core_diameter]/2) *   # radius
      (sample_data[, slice_height])    /       # slice height
      2                                        # cut slice in half
    # If the sample volume was given as a column in sample_data
  } else {
    if(!sample_volume %in% names(sample_data)){
      stop("Sample volume column does not exist in sample_data")
    }
    sample_data_tmp <- sample_data
  }
  
  # Add compaction correction factors to the sample_data
  sample_data_tmp <- merge(
    sample_data_tmp,
    core_data[,c(core_id, compaction_correction_factor)]
  )
  
=======
#' bc_decomp
#'
#' This function uses six arguments
#' @param data dataframe with the following columns "ID" "cm" "weight" "LOI" "c_org".
#' @param tube_lenght The lenght in cm of the sampler.
#' @param core_in The lenght in cm of the part of the sampler left outside of the sediment (from the inside of the sampler).
#' @param core_out The lenght in cm of the part of the sampler left outside of the sediment (from the outside of the sampler).
#' @param diameter in cm of the sampler
#' @param method used to estimate the decompressed depth of each section, "linear" or "exp". Default is "linear".
#' @return
#' @export
#' @examples
#' bc_decomp(data, 200, 48, 25, 6.9, method = "linear")

bc_decomp <-
  function(data, tube_lenght, core_in, core_out, diameter, method = "linear") {

    if(!(method %in% c("linear", "exp"))) {

          return("Method must be either 'linear' or 'exp'")
        }
        
>>>>>>> upstream/main:R/bc_decomp.R
    if(method == "linear") {

      decomp <- data.frame(data$ID)
<<<<<<< HEAD:bc_decomp.R
      decomp$cm_obs <- data$cm + ((tube_length - core_out) - (tube_length - core_in)) 
      
      corr_fact <- as.numeric((tube_length - core_in) / (tube_length - core_out))
      
=======
      decomp$cm_obs <- data$cm + ((tube_lenght - core_out) - (tube_lenght - core_in))

      corr_fact <- as.numeric((tube_lenght - core_in) / (tube_lenght - core_out))

>>>>>>> upstream/main:R/bc_decomp.R
      decomp$cm_deco <- decomp$cm_obs * corr_fact
      decomp$sect_h <- c(first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume
<<<<<<< HEAD:bc_decomp.R
      
=======

      c <- as.numeric(coef(lm(c_org~LOI, data = data))[1])
      d <- as.numeric(coef(lm(c_org~LOI, data = data))[2])

      decomp$c_org_est <- (data$LOI * d) + c
      decomp$c_org_density <- decomp$density * (decomp$c_org_est/100)
      decomp$c_org_dens_sect <- decomp$c_org_density * decomp$sect_h

>>>>>>> upstream/main:R/bc_decomp.R
      return(decomp)
    }

    if(method == "exp") {
<<<<<<< HEAD:bc_decomp.R
      test <- data.frame(x = c(((tube_length - core_out) - (tube_length - core_in)), (tube_length - core_out)), 
                         y = c(((tube_length - core_out) - (tube_length - core_in)), 0.1))
      
=======
      test <- data.frame(x = c(((tube_lenght - core_out) - (tube_lenght - core_in)), (tube_lenght - core_out)),
                         y = c(((tube_lenght - core_out) - (tube_lenght - core_in)), 0.1))

>>>>>>> upstream/main:R/bc_decomp.R
      a <- as.numeric(coef(drm(y~x, data=test, fct=DRC.expoDecay()))[1])
      b <- as.numeric(coef(drm(y~x, data=test, fct=DRC.expoDecay()))[2])

      decomp <- data.frame(data$ID)
<<<<<<< HEAD:bc_decomp.R
      decomp$cm_obs <- data$cm + ((tube_length - core_out) - (tube_length - core_in)) 
      decomp$cm_deco <- decomp$cm_obs - 
=======
      decomp$cm_obs <- data$cm + ((tube_lenght - core_out) - (tube_lenght - core_in))
      decomp$cm_deco <- decomp$cm_obs -
>>>>>>> upstream/main:R/bc_decomp.R
        (a * exp(-b*decomp$cm_obs))
      decomp$sect_h <- c(first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume
<<<<<<< HEAD:bc_decomp.R
=======

      c <- as.numeric(coef(lm(c_org~LOI, data = data))[1])
      d <- as.numeric(coef(lm(c_org~LOI, data = data))[2])

      decomp$c_org_est <- (data$LOI * d) + c
      decomp$c_org_density <- decomp$density * (decomp$c_org_est/100)
      decomp$c_org_dens_sect <- decomp$c_org_density * decomp$sect_h

>>>>>>> upstream/main:R/bc_decomp.R
      return(decomp)
    }
  }
