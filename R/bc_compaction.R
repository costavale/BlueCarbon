#' Calculates Percentage of core compression for cores
#'
#' Accepts a data.frame with core properties and returns a modified version
#' of it, with the addition of the estimated parameters
#' @param sampler_length: name of the column with the total length of the sampler tube
#' @param internal_distance: name of the column with distance between sampler top and core surface
#' @param external_distance: name of the column with distance between sampler top and sediment surface
#' @return Percentage of core compression
#' @export
#' @examples
#' bc_compaction(data = data, 
#'  sampler_length = "sampler_lenght",
#'  internal_distance = "internal_distance",
#'  external_distance = "external_distance"
#')

bc_compaction <- function(
  data,
  sampler_length,
  internal_distance,
  external_distance
){
  if(!is.data.frame(data)){
    stop("data is not a data.frame")
  }
  # Stop if any of the required variables are not numeric
  if(!all(is.numeric(data[, sampler_length]),
          is.numeric(data[, internal_distance]),
          is.numeric(data[, external_distance])
  )){
    non_numeric <- !sapply(
      X = list(data[, sampler_length], data[, internal_distance], data[, external_distance]),
      FUN = is.numeric)
    
    var_names <- c(sampler_length, internal_distance, external_distance)
    
    stop("The following variables are not numeric:\n",
         paste(var_names[which(non_numeric)], sep = "\n"))
  }
  
  # estimate compaction correction factor
  compaction_correction_factor <-
    (data[, sampler_length] - data[, internal_distance]) /
    (data[, sampler_length] - data[,external_distance])
  
  
  # compaction rate as percentage
  data$compression_rate <- (1 - compaction_correction_factor) * 100
  
  return(data)
}
