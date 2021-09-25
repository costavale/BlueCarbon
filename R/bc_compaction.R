#' @title bc_compaction
#' 
#' @description Calculates Percentage of core compression for cores
#' Accepts a data.frame with core properties and returns a modified version
#' of it, with the addition of the estimated parameters
#' 
#' @param core_data data.frame with core properties
#' @param sampler_length name of the column with the total length of the sampler tube
#' @param internal_distance name of the column with distance between sampler top and core surface
#' @param external_distance name of the column with distance between sampler top and sediment surface
#' @return the initial data.frame with the addition of Percentage of core compression

bc_compaction <- 
  function(core_data,
           sampler_length = "sampler_length",
           internal_distance = "internal_distance",
           external_distance = "external_distance") {
    
    # Stop if data is not a data.frame
  if (!is.data.frame(core_data)) {
    stop("core_data is not a data.frame")
  }
  # Stop if any of the required variables are not numeric
  if (!all(is.numeric(core_data[, sampler_length]),
           is.numeric(core_data[, internal_distance]),
           is.numeric(core_data[, external_distance]))) {
    non_numeric <- !sapply(X = list(core_data[, sampler_length], core_data[, internal_distance], core_data[, external_distance]),
                           FUN = is.numeric)
    
    var_names <-
      c(sampler_length, internal_distance, external_distance)
    
    stop("The following variables are not numeric:\n",
         paste(var_names[which(non_numeric)], sep = "\n"))
  }
  
  # estimate compaction correction factor
  compaction_correction_factor <-
    (core_data[, sampler_length] - core_data[, internal_distance]) /
    (core_data[, sampler_length] - core_data[, external_distance])
  
  # compaction rate as percentage
  core_data$compression_rate <- 
    (1 - compaction_correction_factor) * 100
  
  return(core_data)
}
