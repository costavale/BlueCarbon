#' estimate_stock()
#'
#' Estimate the stock of an element contained given its concentration along 
#' a sediment core
#' 
#' @param sample_data 
#'
#'
#' @export

bc_stocks <- function(
  sample_data,
  core_id,
  sample_depth,
  element_concentration,
  maximum_depth,
  method = NULL,
  extrapolation_rule
){
  
  if(is.null(method)){
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
          rule = extrapolation_rule
        )
      }
    )
    
    stocks <- as.data.frame(
      "core_id" = names(stocks),
      "element_stock" = stocks)
    
  } else if(method == "rectangular"){
    # TODO
    # Should the user give us the depth of the slice represented by the sample
    # or should we calculate it? 
    # See thesis code to determine representative
    # depth of non-regularly distributed samples
    print("Method being implemented. Some assumptions must be verified")
  } else {
    stop("Invalid method selected.")
  }
  
}