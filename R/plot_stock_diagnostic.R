#' plot_stock_diagnostic
#'
#' Estimate the stock of an element contained given its concentration along
#' a sediment core
#'
#' @param sample_data
#'
#'

plot_stock_diagnostic <- function() {
  if (method == "trapezoid") {
    sample_data <- lapply(
      sample_data,
      FUN = function(x) {
        # Add a new row for depth zero
        x <- rbind(x, x[1, ])
        x[nrow(x), sample_depth] <- 0
        x <- x[order(x[, sample_depth]), ]
        return(x)
      }
    )

    extrapolated_values <- lapply(
      sample_data,
      FUN = function(x) {
        need_extrapolation <- x[nrow(x), sample_depth] < maximum_depth

        # If extrapolation is required, create data.frame to visualize it
        if (need_extrapolation) {
          extrapolated <- rbind(x[nrow(x), ], x[nrow(x), ])
          extrapolated[nrow(extrapolated), sample_depth] <- maximum_depth
          return(extrapolated)
        }
      }
    )

    sample_data <- do.call(rbind, sample_data)
    extrapolated_values <- do.call(rbind, extrapolated_values)

    ggplot(sample_data) +
      geom_line(
        aes(
          x = .data[[sample_depth]],
          y = .data[[element_concentration]]
        )
      ) +
      geom_point(
        aes(
          x = .data[[sample_depth]],
          y = .data[[element_concentration]]
        )
      ) +
      facet_wrap(c(core_id)) +
      scale_x_reverse(expand = expansion(c(0, 0.05))) +
      coord_flip(xlim = c(maximum_depth, 0)) +
      if (need_extrapolation) {
        geom_line(
          data = extrapolated_values,
          aes(
            x = .data[[sample_depth]],
            y = .data[[element_concentration]]
          ),
          color = "red",
          linetype = "dashed"
        )
      }
  } else if(method == "rectangle"){
    if(!is.null(section_height)){
      print("Implement section plots when user gives section heigts")
    } else {
      print("Implement section plots when calculated by function")
    }
  }
}
