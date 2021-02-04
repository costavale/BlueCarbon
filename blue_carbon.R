# ---
# title: "Blue_carbon"
# author: "Valentina Costa"
# date: 1 february
# ---

tube_lenght <- 200
core_in <- 48
core_out <- 25
samples_lim



# % of compression

bc_comp <-
  function(tube_lenght, core_in, core_out) {
    
    ## compute percentage of core compression 
    compr <- (core_in - core_out) * 100 / (tube_lenght - core_out)
    
    ## compute correction factor 
    corr <- (tube_lenght - core_in) / (tube_lenght - core_out)
    
    list("Percentage of core compression" = compr,
         "Correction factor" = corr)
  }

bc_comp(200, 48, 25)


exponential <- 
  function(x,a,b) {
    a * exp(b * x)
    }

fit <- 
  nls(y ~ a * exp(-b * x), 
    data = test, 
    start = list(a = 1, b = 1))


summary(fit)

library(tidyverse)

ggplot(test, aes(x=x, y=y)) + 
  geom_point() +
  geom_line(method="lm", formula = (y ~ a*exp(-b*x)), se=FALSE, linetype = 1)


lm

# Decompression

bc_decomp <- 
  function(tube_lenght, core_in, core_out, samples_lim, method) {
    
    if(method == "linear") {
      corr <- (tube_lenght - core_in) / (tube_lenght - core_out)
      output <- samples_lim * corr
      return(output)
    }
    
    if(method == "exp") {
      corr <- 
      output <- samples_lim * corr
      return(output)
    }
}





