# Source libraries
library(plyr) # rbind.fill
library(deSolve) # ODE solver

# Read data (as.matrix ensure compliance with lsoda)
dataN.wet <- as.matrix(read.csv("Data/dataN-dispersal-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1])
dataM.wet <- as.matrix(read.csv("Data/dataM-dispersal-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1])

### Create duplicate data frames representing "before dispersal"
dataN.wet0 <- dataN.wet * 0
dataN.wet0[, 1] <- rowSums(dataN.wet)
dataM.wet0 <- dataM.wet * 0
dataM.wet0[, 1] <- rowSums(dataM.wet)

### Assume an equal number of T. confusum dispersed to the other side (e.g., double # in patch 2)
dataM.wet[, 2] <- dataM.wet[, 2] * 2
dataM.wet[, 3] <- dataM.wet[, 3] * 2
dataM.wet[, 4] <- dataM.wet[, 4] * 2

# Source models
## Diffusion
source("disp/diffuse.R")
## Diffusion + density-independent diffusion coefficient
source("disp/dispersal1.R")
## Diffusion + density-dependent (i.e., starting density of the patch)
source("disp/dispersal2.R")
# Source likelihood function
source("nll-dispersal.R")

# Model parameters that must be positive
positives <- c("D")

# Make empty data.frame for storing fits
estimates <- data.frame(Species = c(),
                        Environment = c(),
                        Kernel = c(),
                        PMF = c(),
                        Parameters = c(),
                        negloglike = c(),
                        converge = c(),
                        D = c(),
                        F = c())

##### Multinomial

# Optimize dispersal model 1 (Diffusion + density-independent diffusion coefficient)
#
# Note: For 1-dimensional optimization, "positive" parameters are not exp-transformed within
# nll.dispersal due to the way R handles names in 1-dimensional objects. This quirk has no impact
# on the results.
#
## T cast
fit.cast.wet <- optim(par = list(D = runif(1)),
                      fn = nll.dispersal,
                      N.before = dataN.wet0,
                      N.after = dataN.wet,
                      kernel = dispersal1,
                      pmf = c("dmultinom"),
                      diffuse.model = diffuse,
                      pos = positives, # must include
                      method = "Brent",
                      lower = 0,
                      upper = 10)
# Store fit in table
estimates <- rbind.fill(estimates, data.frame(Species = c("Cast"),
                                              Environment = c("Wet"),
                                              Kernel = c("Diffusion"),
                                              PMF = c("multinomial"),
                                              Parameters = length(fit.cast.wet$par),
                                              negloglike = fit.cast.wet$value,
                                              converge = fit.cast.wet$convergence,
                                              D = fit.cast.wet$par,
                                              stringsAsFactors = FALSE))
## T conf
fit.conf.wet <- optim(par = list(D = runif(1)),
                      fn = nll.dispersal,
                      N.before = dataM.wet0,
                      N.after = dataM.wet,
                      kernel = dispersal1,
                      pmf = c("dmultinom"),
                      diffuse.model = diffuse,
                      pos = c(), # not needed for Brent method
                      method = "Brent",
                      lower = 0,
                      upper = 10)
# Store fit in table
estimates <- rbind.fill(estimates, data.frame(Species = c("Conf"),
                                              Environment = c("Wet"),
                                              Kernel = c("Diffusion"),
                                              PMF = c("multinomial"),
                                              Parameters = length(fit.conf.wet$par),
                                              negloglike = fit.conf.wet$value,
                                              converge = fit.conf.wet$convergence,
                                              D = fit.conf.wet$par,
                                              stringsAsFactors = FALSE))

# Optimize dispersal model 2 (Diffusion + density-dependent [patch] diffusion coefficient)
#
## T cast
fit.cast.wet2 <- optim(par = list(D = runif(1), F = 0.1),
                       fn = nll.dispersal,
                       N.before = dataN.wet0,
                       N.after = dataN.wet,
                       kernel = dispersal2,
                       pmf = c("dmultinom"),
                       diffuse.model = diffuse,
                       pos = positives)
# Store fit in table
estimates <- rbind.fill(estimates, data.frame(Species = c("Cast"),
                                              Environment = c("Wet"),
                                              Kernel = c("Fouling"),
                                              PMF = c("multinomial"),
                                              Parameters = length(fit.cast.wet2$par),
                                              negloglike = fit.cast.wet2$value,
                                              converge = fit.cast.wet2$convergence,
                                              D = exp(fit.cast.wet2$par[1]),
                                              F = fit.cast.wet2$par[2],
                                              stringsAsFactors = FALSE))
## T conf
fit.conf.wet2 <- optim(par = list(D = runif(1), F = 0.1),
                       fn = nll.dispersal,
                       N.before = dataM.wet0,
                       N.after = dataM.wet,
                       kernel = dispersal2,
                       pmf = c("dmultinom"),
                       diffuse.model = diffuse,
                       pos = positives)
# Store fit in table
estimates <- rbind.fill(estimates, data.frame(Species = c("Conf"),
                                              Environment = c("Wet"),
                                              Kernel = c("Fouling"),
                                              PMF = c("multinomial"),
                                              Parameters = length(fit.conf.wet2$par),
                                              negloglike = fit.conf.wet2$value,
                                              converge = fit.conf.wet2$convergence,
                                              D = exp(fit.conf.wet2$par[1]),
                                              F = fit.conf.wet2$par[2],
                                              stringsAsFactors = FALSE))

# Calculate AIC
estimates$AIC <- 2 * estimates$Parameters + (2 * estimates$negloglike)
# Reorder
estimates <- estimates[order(estimates$Species, estimates$Environment, estimates$AIC), ]

# Save results (everything)
write.table(estimates, file="Data/results-fit-dispersal.csv", sep = ",", quote = FALSE, row.names = FALSE)
