#' estimate_stock()
#'
#' Estimate the stock of an element contained given its concentration along 
#' a sediment core
#' 
#' @param sample_data 
#'
#'
#' @export

# TODO: Add warnings when extrapolation occurs!!
# TODO: Add data checks when user provides section heights: is the final result
#   equal to maximum_depth?

bc_stocks <- function(
  sample_data,
  core_id,
  sample_depth,
  element_concentration,
  maximum_depth,
  method = NULL,
  section_height = NULL,
  diagnostic_plot = FALSE
){
  
  if(is.null(method) | !method %in% c("rectangle", "trapezoid")){
    stop("Please select a stock estimation method.\n
         Consult documentation for method descriptions.")
  }
  
  if(method == "trapezoid"){
    sample_data <- split(
      sample_data, 
      as.factor(sample_data$core_id)
    )
    
    stocks <- sapply(
      sample_data,
      FUN = function(x) {
        stock <- MESS::auc(
          x = x[ , sample_depth],
          y = x[ , element_concentration],
          from = 0,
          to = maximum_depth,
          type = "linear",
          rule = 2
        )
      }
    )
    
    stocks <- data.frame(
      "core_id" = names(stocks),
      "element_stock" = stocks)
    
  } else if(method == "rectangular"){
    # Height of sections represented by each slice are given
    if(!is.null(section_height)){
      sample_data$section_start <- sample_data[ , sample_depth] - 
                                   sample_data[, section_height]/2
      
      sample_data$section_end <- sample_data[ , sample_depth] + 
                                 sample_data[, section_height]/2
      
      sample_data <- split(sample_data, f = sample_data[, core_id])
      
      # Correct data so that stocks are estimated for `maximum_depth`
      sample_data <- sapply(
        sample_data,
        FUN = function(x){
          x <- x[order(x[ , sample_depth]), ]
          # Remove sections deeper than needed
          x <- x[x$section_start < maximum_depth , ]
          # If last section goes over `maximum depth`, shorten it
          x$section_end <- if(x$section_end > maximum_depth){
            x$section_end - (x$section_end - maximum_depth)
            }
          # If last section doesn't reach `maximum depth`, extend it
          x$section_end <- if(x$section_end < maximum_depth){
            x$section_end + (maximum_depth - x$section_end)
          }
        }
      )
      
      # Calculate new section heights
      sample_data[ , section_height] <- sample_data$section_end - 
                                        sample_data$section_start
      
      # Calculate carbon stock per section
      sample_data$section_stock <- sample_data[ , element_concentration] *
                                   sample_data[ , section_height]
      
      stocks <- aggregate(
        formula = c(section_stock) ~ core_id,
        data = sample_data,
        FUN = function(x) c(stock = sum(x))
      )
    # If height of sections represented by each slice are not provided
    } else {
      sample_data <- split(sample_data, f = sample_data[, core_id])
      
      sample_data <- lapply(
        sample_data,
        FUN = function(x){
          x <- x[order(x[ , sample_depth]), ]
          # Estimate the middle point from current sample to next and previous
          # sample - this is determined as the section represented by the sample
          x$height_below <- (c(x[-1 ,sample_depth], NA)  - x[ ,sample_depth])/2
          x$height_above <- x[ , sample_depth] - c(0, x[-nrow(x), sample_depth])
          x$height_above[-1] <- x$height_above[-1]/2
          x$section_start <- x[ , sample_depth] - x$height_above
          x$section_end <- x[ , sample_depth] + x$height_below
          # Remove samples deeper than needed
          x <- x[x$section_start < maximum_depth, ]
          # Correct end of last section be be equal to max stock depth
          x$section_end[nrow(x)] <- maximum_depth
          x$section_height <- x$section_end - x$section_start
          
          return(x)
        }
      )
        
        sample_data <- do.call(rbind, sample_data)
        
        # Calculate carbon stock per section
        sample_data$section_stock <- sample_data[ , element_concentration] *
          sample_data$section_height
        
        stocks <- aggregate(
          formula = c(section_stock) ~ core_id,
          data = sample_data,
          FUN = function(x) c(stock = sum(x))
        )
    }
  } else {
    message("Invalid method selected.")
  }
}
