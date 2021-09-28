#' Estimate compaction rate for cores
#' Accepts a data.frame with core properties and returns a modified version
#' of it, with the addition of the estimated parameters
#' @param tube_length: name for column with length of the sampling tube used
#' @param internal_distance: name for column with distance between sampler top and the sediment core surface
#' @param external_distance: name for column with distance between sampler top and the sediment column surface
#' @export

calculate_core_compaction <- function(
  data,
  tube_length,
  internal_distance,
  external_distance
){
  if(!is.data.frame(data)){
    stop("data is not a data.frame")
  }
  # Stop if any of the required variables are not numeric
  if(!all(is.numeric(data[, tube_length]),
          is.numeric(data[, internal_distance]),
          is.numeric(data[, external_distance])
  )){
    non_numeric <- !sapply(
      X = list(data[, tube_length], data[, internal_distance], data[, external_distance]),
      FUN = is.numeric)
    
    var_names <- c(tube_length, internal_distance, external_distance)
    
    stop("The following variables are not numeric:\n",
         paste(var_names[which(non_numeric)], sep = "\n"))
  }
  
  # estimate compaction correction factor
  compaction_correction_factor <-
    (data[, tube_length] - data[, internal_distance]) /
    (data[, tube_length] - data[,external_distance])
  
  
  # compaction rate as percentage
  data$compression_rate <- (1 - compaction_correction_factor) * 100
  
  return(data)
}
