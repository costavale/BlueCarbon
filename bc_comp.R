# Estimate compaction rate and compaction correction factor for sediment cores
# Accepts a data.frame with core properties and returns a modified version 
# of it, with the addition of the estimated parameters
# 1. tube_length: length of the sampling tube used 
# 2. internal_distance: distance between sampler top and the sediment core surface
# 3. external_distance: distance between sampler top and the sediment column surface
# the names of the columns are passed as strings and a new data.frame is returned
bc_comp <- function(data, tube_length, internal_distance, external_distance){
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
  data$compaction_correction_factor <- 
    (data[, tube_length] - data[, internal_distance]) / 
    (data[, tube_length] - data[,external_distance])
  
  
  # compaction rate as percentage 
  data$compression_rate <- (1 - data$compaction_correction_factor) * 100
  
  
  return(data)
}
