bc_decomp <- 
  function(data, tube_lenght, core_in, core_out, diameter, method = "linear") {
    
    if(method == "linear") {
      
      decomp <- data.frame(data$ID)
      decomp$cm_obs <- data$cm + ((tube_lenght - core_out) - (tube_lenght - core_in)) 
      
      corr_fact <- as.numeric((tube_lenght - core_in) / (tube_lenght - core_out))
      
      decomp$cm_deco <- decomp$cm_obs * corr_fact
      decomp$sect_h <- c(first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume
      
      c <- as.numeric(coef(lm(c_org~LOI, data = data))[1])
      d <- as.numeric(coef(lm(c_org~LOI, data = data))[2])
      
      decomp$c_org_est <- (data$LOI * d) + c
      decomp$c_org_density <- decomp$density * (decomp$c_org_est/100)
      decomp$c_org_dens_sect <- decomp$c_org_density * decomp$sect_h
      
      return(decomp)
    }
    
    if(method == "exp") {
      test <- data.frame(x = c(((tube_lenght - core_out) - (tube_lenght - core_in)), (tube_lenght - core_out)), 
                         y = c(((tube_lenght - core_out) - (tube_lenght - core_in)), 0.1))
      
      a <- as.numeric(coef(drm(y~x, data=test, fct=DRC.expoDecay()))[1])
      b <- as.numeric(coef(drm(y~x, data=test, fct=DRC.expoDecay()))[2])
      
      decomp <- data.frame(data$ID)
      decomp$cm_obs <- data$cm + ((tube_lenght - core_out) - (tube_lenght - core_in)) 
      decomp$cm_deco <- decomp$cm_obs - 
        (a * exp(-b*decomp$cm_obs))
      decomp$sect_h <- c(first(decomp$cm_deco), diff(decomp$cm_deco))
      decomp$volume <- (((pi * (diameter/2)^2) * decomp$sect_h)/2) #volume is divided by two as half section is used
      decomp$density <- data$weight/decomp$volume
      
      c <- as.numeric(coef(lm(c_org~LOI, data = data))[1])
      d <- as.numeric(coef(lm(c_org~LOI, data = data))[2])
      
      decomp$c_org_est <- (data$LOI * d) + c
      decomp$c_org_density <- decomp$density * (decomp$c_org_est/100)
      decomp$c_org_dens_sect <- decomp$c_org_density * decomp$sect_h
      
      return(decomp)
    }
  }
