#' Calculates Percentage of core compression and Linear Correction Factor
#'
#' This function calculates the Percentage of core compression and the Linear Correction Factor using three arguments.
#' @param tube_lenght The lenght in cm of the sampler.
#' @param core_in The lenght in cm of the part of the sampler left outside of the sediment (from the inside of the sampler).
#' @param core_out The lenght in cm of the part of the sampler left outside of the sediment (from the outside of the sampler).
#' @return Percentage of core compression and the Linear Correction Factor.
#' @export
#' @examples
#' bc_comp(200, 48, 25)

bc_comp <-
  function(tube_lenght, core_in, core_out) {

    ## compute percentage of core compression
    compr <- (core_in - core_out) * 100 / (tube_lenght - core_out)

    ## compute correction factor
    corr <- (tube_lenght - core_in) / (tube_lenght - core_out)

    output <- list("Percentage of core compression" = compr,
                    "Linear Correction factor" = corr)

    return(output)
  }
