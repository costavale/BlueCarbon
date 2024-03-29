#' bc_stock()
#'
#' Estimate the stock of an element contained given its concentration along
#' a sediment core. 
#' 
#' **Calculate elemental stocks:**
#'  1. Trapezoid rule (Martins, M. et al 2021)
#'  2. Rectangle rule (Howard, J. et al 2014)
#'    + User provides start and end of sections represented by samples
#'    + Heights of sections are automatically estimated
#'  3.(optional) - Plots how the stock is being estimated, with a special draw towards any sections that have to be extrapolated
#'
#' @param sample_data Sediment sample properties, after calculating elemental concentration and correcting compaction
#' @param core_id Name of for core the identifier. Should be a string
#' @param sample_depth Name of variable for the depth at which samples were taken
#' @param element_concentration Name of the variable for the concentration of the element whose stock is being estimated
#' @param maximum_depth Depth to which to estimate the stock.
#' @param method Method used to estimate the stock, one of "rectangle" or "trapezoid"
#' @param section_start (Optional, only for "rectangle" method) Depth at which the core section represented by each sample begins
#' @param section_end (Optional, only for "rectangle" method) Depth at which the core section represented by each sample ends
#' @param diagnostic_plot Should a plot of how the stock was estimated be shown? FALSE (default) or TRUE
#'
#' @export
# TODO: Add warnings when extrapolation occurs!!
# TODO: Add data checks when user provides section heights: is the final result
#   equal to maximum_depth?
# TODO: Add argument to allow user to select if he wants to extrapolate or not 

bc_stocks <- function(sample_data,
                      core_id,
                      sample_depth,
                      element_concentration,
                      maximum_depth,
                      method = NULL,
                      section_height = NULL,
                      diagnostic_plot = FALSE) {
  
  if (is.null(method) | !method %in% c("rectangle", "trapezoid")) {
    stop("Please select a stock estimation method.\n
         Consult documentation for method descriptions.")
  }

  if(method == "trapezoid"){
    sample_data <- split(
      sample_data,
      as.factor(sample_data$core_id)
    )
    
    # Save the name of all cores where extrapolation occurred - to warn user
    extrapolated_cores <- lapply(
      sample_data,
      FUN = function(x) {
        if(max(x[, sample_depth]) < maximum_depth){
          c(unique(x[, core_id]))
        }
      }
    )
    extrapolated_cores <- do.call(c, extrapolated_cores)
    
    # Calculate the stocks
    stocks <- sapply(
      sample_data,
      FUN = function(x) {
        stock <- MESS::auc(
          x = x[, sample_depth],
          y = x[, element_concentration],
          from = 0,
          to = maximum_depth,
          type = "linear",
          rule = 2
        )
      }
    )

    stocks <- data.frame(
      "core_id" = names(stocks),
      "element_stock" = stocks
    )
    
    if (diagnostic_plot) BlueCarbon:::plot_stock_diagnostic(
      sample_data,
      core_id,
      sample_depth,
      element_concentration,
      maximum_depth,
      method)
    
    if(!is.null(extrapolated_cores))message(
      paste("Extrapolation was required for cores:\n", extrapolated_cores)
    )
    
    return(stocks)

  } else if (method == "rectangle") {
    # Height of sections represented by each slice are given
    if (!is.null(section_height)) {
      # TODO: Verify if this method works
      message("The rectangle method with section starts and ends provided by user is in test.\n
              Beware!")
      
      sample_data <- split(sample_data, f = sample_data[, core_id])
      
      # Save the name of all cores where extrapolation occurred - to warn user
      extrapolated_cores <- lapply(
        sample_data,
        FUN = function(x) {
          if(max(x[, section_end]) < maximum_depth){
            c(unique(x[, core_id]))
          }
        }
      )
      extrapolated_cores <- do.call(c, extrapolated_cores)
      
      # Correct data so that stocks are estimated for `maximum_depth`
      sample_data <- sapply(
        sample_data,
        FUN = function(x) {
          x <- x[order(x[, sample_depth]), ]

          # Identify if last layer needs to be extrapolated
          x$extrapolated <- FALSE
          x$extrapolated[nrow(x)] <- x[nrow(x), section_end] < maximum_depth
          
          # Remove samples deeper than needed
          x <- x[x$section_start < maximum_depth, ]

          # Create new section that extrapolates the elemental profile
          if (any(x$extrapolated)) {
            # Add new section
            x <- rbind(x, x[nrow(x), ])
            # Only the actually extrapolated section is flagged as extrapolated
            x$extrapolated[1:(nrow(x) - 1)] <- FALSE
            # Extrapolated layer starts at end of previous one
            x[nrow(x), section_start] <- x[nrow(x), section_end]
            # Extrapolated layer ends at `maximum_depth`
            x[nrow(x), section_end] <- maximum_depth
          }
        }
      )
      # If height of sections represented by each slice are not given
    } else {
      sample_data <- split(sample_data, f = sample_data[, core_id])
      
      # Save the name of all cores where extrapolation occurred - to warn user
      extrapolated_cores <- lapply(
        sample_data,
        FUN = function(x) {
          if(max(x[, sample_depth]) < maximum_depth){
            c(unique(x[, core_id]))
          }
        }
      )
      extrapolated_cores <- do.call(c, extrapolated_cores)
      
      # Calculate core section heights and extrapolate
      sample_data <- lapply(
        sample_data,
        FUN = function(x) {
          x <- x[order(x[, sample_depth]), ]
          # Estimate the middle point from current sample to next and previous
          # sample - this is determined as the section represented by the sample
          x$height_below <- (c(x[-1, sample_depth], NA) - x[, sample_depth]) / 2
          x$height_above <- x[, sample_depth] - c(0, x[-nrow(x), sample_depth])
          x$height_above[-1] <- x$height_above[-1] / 2
          x$section_start <- x[, sample_depth] - x$height_above
          x$section_end <- x[, sample_depth] + x$height_below

          # Identify if last layer needs to be extrapolated
          x$extrapolated <- FALSE
          x$extrapolated[nrow(x)] <- x[nrow(x), sample_depth] < maximum_depth

          # Remove samples deeper than needed
          x <- x[x$section_start < maximum_depth, ]

          # Create new section that extrapolates the elemental profile
          if (any(x$extrapolated)) {
            # Set end of last recorded section to measured sample depth
            x[nrow(x), "section_end"] <- x[nrow(x), sample_depth]
            # Add new section
            x <- rbind(x, x[nrow(x), ])
            # Only the actually extrapolated section is flagged as extrapolated
            x$extrapolated[1:(nrow(x) - 1)] <- FALSE
            # Extrapolated layer starts at end of previous one
            x[nrow(x), "section_start"] <- x[nrow(x), "section_end"]
            # Extrapolated layer ends at `maximum_depth`
            x[nrow(x), "section_end"] <- maximum_depth
          }

          return(x)
        }
      )
    }

    if (diagnostic_plot) BlueCarbon:::plot_stock_diagnostic(
      sample_data,
      core_id,
      sample_depth,
      element_concentration,
      maximum_depth,
      method)

    sample_data <- do.call(rbind, sample_data)

    # Calculate new section heights
    if(is.null(section_height)) section_height <- "section_height"
    sample_data[, section_height] <- sample_data$section_end -
      sample_data$section_start

    # Calculate carbon stock per section
    sample_data$section_stock <- sample_data[, element_concentration] *
      sample_data[, section_height]

    stocks <- aggregate(
      formula = section_stock ~ core_id,
      data = sample_data,
      FUN = function(x) c(stock = sum(x))
    )
    
    if(!is.null(extrapolated_cores)) message(
      paste("Extrapolation was required for cores:\n", extrapolated_cores)
    )
    
    return(stocks)

  } else {
    message("Invalid method selected.")
  }
}
