#' plot_stock_diagnostic
#'
#' Internal function used to plot stock estimations in `bc_stocks`
#'
#' @param sample_data Sample data as a list, split by sediment core
#' @param method Method used to calculate elemental stock

plot_stock_diagnostic <- function(sample_data, method) {

  # Add depth zero value
  stock_points <- lapply(
    sample_data,
    FUN = function(x) {
      x <- rbind(x, x[1, ])
      x[nrow(x), sample_depth] <- 0
      x <- x[order(x[, sample_depth]), ]
      return(x)
    }
  )


  # Trapezoid method visualization ------------------------------------------
  if (method == "trapezoid") {

    # If extrapolation is required, create data.frame to visualize it
    extrapolated_values <- lapply(
      sample_data,
      FUN = function(x) {
        need_extrapolation <- x[nrow(x), sample_depth] < maximum_depth
        if (need_extrapolation) {
          extrapolated <- rbind(x[nrow(x), ], x[nrow(x), ])
          extrapolated[nrow(extrapolated), sample_depth] <- maximum_depth
          return(extrapolated)
        }
      }
    )

    stock_points <- do.call(rbind, stock_points)
    extrapolated_values <- do.call(rbind, extrapolated_values)
    sample_data <- do.call(rbind, sample_data)

    stock_plot <- ggplot() +
      geom_area(
        data = stock_points,
        aes(
          x = .data[[sample_depth]],
          y = .data[[element_concentration]]
        )
      ) +
      geom_point(
        data = sample_data,
        aes(
          x = .data[[sample_depth]],
          y = .data[[element_concentration]]
        )
      ) +
      facet_wrap(c(core_id)) +
      scale_x_reverse(expand = expansion(c(0, 0.02))) +
      coord_flip(xlim = c(maximum_depth, 0)) +
      if (!is.null(extrapolated_values)) {
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

    print(stock_plot)

    # Rectangle method visualization ------------------------------------------
  } else if (method == "rectangle") {

    # If extrapolation is required, create data.frame to visualize it
    extrapolated_values <- lapply(
      sample_data,
      FUN = function(x) {
        x <- x[x$extrapolated, ]
        if (!is.null(x)) {
          extrapolated <- rbind(x[nrow(x), ], x[nrow(x), ])
          extrapolated[nrow(extrapolated), "section_end"] <- maximum_depth
          return(extrapolated)
        }
      }
    )

    stock_points <- do.call(rbind, stock_points)
    extrapolated_values <- do.call(rbind, extrapolated_values)
    sample_data <- do.call(rbind, sample_data)

    stock_plot <- ggplot() +
      geom_rect(
        data = stock_points,
        aes(
          xmin = section_start,
          xmax = section_end,
          ymin = 0,
          ymax = .data[[element_concentration]]
        )
      ) +
      {
        if (!is.null(extrapolated_values)) {
          geom_rect(
            data = extrapolated_values,
            aes(
              xmin = section_start,
              xmax = section_end,
              ymin = 0,
              ymax = .data[[element_concentration]]
            ),
            color = "red",
            linetype = "dashed"
          )
        }
      } +
      geom_point(
        data = sample_data,
        aes(
          x = .data[[sample_depth]],
          y = .data[[element_concentration]]
        )
      ) +
      facet_wrap(c(core_id)) +
      scale_x_reverse(expand = expansion(c(0, 0.05))) +
      coord_flip(xlim = c(maximum_depth, 0))
    
    print(stock_plot)
  }
}
