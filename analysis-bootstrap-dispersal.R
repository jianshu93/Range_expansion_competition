# Set seed
set.seed(20190913)

### Number of bootstraps
numr <- 5000

# Source plyr for rbind.fill function
library(plyr)
# Source xtable library
library(xtable)
# Source parallel library
library(parallel)
# Source deSolve library
library("deSolve")

# Make cluser
clus <- makeCluster(12)
# Export the libraries
clusterEvalQ(clus, library(parallel))
clusterEvalQ(clus, library(xtable))
clusterEvalQ(clus, library(plyr))
clusterEvalQ(clus, library(deSolve))

# Source models
## Diffusion
source("disp/diffuse.R")
## Diffusion + density-independent diffusion coefficient
source("disp/dispersal1.R")
## Diffusion + density-dependent (i.e., starting density of the patch)
source("disp/dispersal2.R")
# Source negative log-likelihood function (to be optimized)
source("nll-dispersal.R")

# Source parameter estimates
source("Data/param-wet.R")
source("Data/param-dry.R")

# Parameter values that must be positive in the optimization
positives <- c("Dn", "Dm")
# Keep only parameter relevant for dispersal
param.wet <- param.wet[10:13]
param.dry <- param.dry[10:12]
# Transform estimates to be compatible with exp transform in the nll function
positives.regex <- paste(positives, collapse = "|") # collapse "pos" to regex
positives.wet.tr <- grep(positives.regex, names(param.wet)) # parameters to transform (WET)
positives.dry.tr <- grep(positives.regex, names(param.dry)) # parameters to transform (DRY)
param.wet <- replace(param.wet, positives.wet.tr, log(unlist(param.wet[positives.wet.tr]))) # transform (log)
param.dry <- replace(param.dry, positives.dry.tr, log(unlist(param.dry[positives.dry.tr]))) # transform (log)
# Change positive list after transformation (for compatability with likelihood function)
positives <- c("D")

# Read data (as.matrix ensure compliance with lsoda)
dataN.wet <- as.matrix(read.csv("Data/dataN-dispersal-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1])
dataM.wet <- as.matrix(read.csv("Data/dataM-dispersal-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1])
dataN.dry <- as.matrix(read.csv("Data/dataN-dispersal-dry.csv", header = TRUE, stringsAsFactors = FALSE)[, -1])
dataM.dry <- as.matrix(read.csv("Data/dataM-dispersal-dry.csv", header = TRUE, stringsAsFactors = FALSE)[, -1])

### Create duplicate data frames representing "before dispersal"
dataN.wet0 <- dataN.wet * 0
dataN.wet0[, 1] <- rowSums(dataN.wet)
dataN.dry0 <- dataN.dry * 0
dataN.dry0[, 1] <- rowSums(dataN.dry)
dataM.wet0 <- dataM.wet * 0
dataM.wet0[, 1] <- rowSums(dataM.wet)
dataM.dry0 <- dataM.dry * 0
dataM.dry0[, 1] <- rowSums(dataM.dry)

### Assume an equal number of T. confusum dispersed to the other side
dataM.wet[, 2] <- dataM.wet[, 2] * 2
dataM.dry[, 2] <- dataM.dry[, 2] * 2
dataM.wet[, 3] <- dataM.wet[, 3] * 2
dataM.dry[, 3] <- dataM.dry[, 3] * 2
dataM.wet[, 4] <- dataM.wet[, 4] * 2
dataM.dry[, 4] <- dataM.dry[, 4] * 2

# Make empty data.frame for storing fits
estimates <- data.frame()

# Export everything to the cluster
clusterExport(clus, c("param.wet",
                      "param.dry",
                      "diffuse",
                      "dispersal1",
                      "dispersal2",
                      "nll.dispersal",
                      "positives",
                      "dataN.wet",
                      "dataN.wet0",
                      "dataM.wet",
                      "dataM.wet0",
                      "dataN.dry",
                      "dataN.dry0",
                      "dataM.dry",
                      "dataM.dry0",
                      "estimates"))

# Run optimizer (T. castaneum, Humid)
estimates.raw <- parLapplyLB(clus, 1:numr, fun = function(i){
    rands.temp <- sample(1:nrow(dataN.wet), size = nrow(dataN.wet), replace = TRUE)
    dataN.temp <- dataN.wet[rands.temp, ]
    dataN0.temp <- dataN.wet0[rands.temp, ]
    startingvalues.i <- list(D = param.wet[["Dn"]], F = param.wet[["Fn"]])
    if(sum(dataN.temp[, -1]) == 0){
        estimates.temp <- data.frame(Species = c("Cast"),
                                     Environment = c("Humid"),
                                     Replicate = i,
                                     negloglike = NA,
                                     converge = 0,
                                     D = -100,
                                     F = 0,
                                     stringsAsFactors = FALSE)
    } else{    
        fit <- optim(par = startingvalues.i,
                     fn = nll.dispersal,
                     N.before = dataN0.temp,
                     N.after = dataN.temp,
                     kernel = dispersal2,
                     pmf = c("dmultinom"),
                     diffuse.model = diffuse,
                     pos = positives)
        estimates.temp <- cbind(data.frame(Species = c("Cast"),
                                           Environment = c("Humid"),
                                           Replicate = i,
                                           negloglike = fit$value,
                                           converge = fit$convergence, stringsAsFactors = FALSE),
                                t(as.data.frame(fit$par)))
    }
    estimates.temp
})
# Merge results with storage data.frame
for(i in 1:length(estimates.raw)){
    estimates <- rbind.fill(estimates, as.data.frame(estimates.raw[i]))
}

# Run optimizer (T. castaneum, Dry)1
estimates.raw <- parLapplyLB(clus, 1:numr, fun = function(i){
    rands.temp <- sample(1:nrow(dataN.dry), size = nrow(dataN.dry), replace = TRUE)
    dataN.temp <- dataN.dry[rands.temp, ]
    dataN0.temp <- dataN.dry0[rands.temp, ]
    startingvalues.i <- list(D = param.dry[["Dn"]], F = param.dry[["Fn"]])
    if(sum(dataN.temp[, -1]) == 0){
        estimates.temp <- data.frame(Species = c("Cast"),
                                     Environment = c("Dry"),
                                     Replicate = i,
                                     negloglike = NA,
                                     converge = 0,
                                     D = -100,
                                     F = 0,
                                     stringsAsFactors = FALSE)
    } else{    
        fit <- optim(par = startingvalues.i,
                     fn = nll.dispersal,
                     N.before = dataN0.temp,
                     N.after = dataN.temp,
                     kernel = dispersal2,
                     pmf = c("dmultinom"),
                     diffuse.model = diffuse,
                     pos = positives)
        estimates.temp <- cbind(data.frame(Species = c("Cast"),
                                           Environment = c("Dry"),
                                           Replicate = i,
                                           negloglike = fit$value,
                                           converge = fit$convergence, stringsAsFactors = FALSE),
                                t(as.data.frame(fit$par)))
    }
    estimates.temp
})
# Merge results with storage data.frame
for(i in 1:length(estimates.raw)){
    estimates <- rbind.fill(estimates, as.data.frame(estimates.raw[i]))
}

# Run optimizer (T. confusum, Humid)
estimates.raw <- parLapplyLB(clus, 1:numr, fun = function(i){
    rands.temp <- sample(1:nrow(dataM.wet), size = nrow(dataM.wet), replace = TRUE)
    dataM.temp <- dataM.wet[rands.temp, ]
    dataM0.temp <- dataM.wet0[rands.temp, ]
    startingvalues.i <- list(D = param.wet[["Dm"]], F = param.wet[["Fm"]])
    if(sum(dataM.temp[, -1]) == 0){
        estimates.temp <- data.frame(Species = c("Conf"),
                                     Environment = c("Humid"),
                                     Replicate = i,
                                     negloglike = NA,
                                     converge = 0,
                                     D = -100,
                                     F = 0,
                                     stringsAsFactors = FALSE)
    } else{    
        fit <- optim(par = startingvalues.i,
                     fn = nll.dispersal,
                     N.before = dataM0.temp,
                     N.after = dataM.temp,
                     kernel = dispersal2,
                     pmf = c("dmultinom"),
                     diffuse.model = diffuse,
                     pos = positives)
        estimates.temp <- cbind(data.frame(Species = c("Conf"),
                                           Environment = c("Humid"),
                                           Replicate = i,
                                           negloglike = fit$value,
                                           converge = fit$convergence, stringsAsFactors = FALSE),
                                t(as.data.frame(fit$par)))
    }
    estimates.temp
})
# Merge results with storage data.frame
for(i in 1:length(estimates.raw)){
    estimates <- rbind.fill(estimates, as.data.frame(estimates.raw[i]))
}

# Run optimizer (T. confusum, Dry)
estimates.raw <- parLapplyLB(clus, 1:numr, fun = function(i){
    rands.temp <- sample(1:nrow(dataM.dry), size = nrow(dataM.dry), replace = TRUE)
    dataM.temp <- dataM.dry[rands.temp, ]
    dataM0.temp <- dataM.dry0[rands.temp, ]
    startingvalues.i <- list(D = param.dry[["Dm"]])
    if(sum(dataM.temp[, -1]) == 0){
        estimates.temp <- data.frame(Species = c("Conf"),
                                     Environment = c("Dry"),
                                     Replicate = i,
                                     negloglike = NA,
                                     converge = 0,
                                     D = -100,
                                     stringsAsFactors = FALSE)
    } else{    
        fit <- optim(par = startingvalues.i,
                     fn = nll.dispersal,
                     N.before = dataM0.temp,
                     N.after = dataM.temp,
                     kernel = dispersal1,
                     pmf = c("dmultinom"),
                     diffuse.model = diffuse,
                     pos = positives)
        estimates.temp <- cbind(data.frame(Species = c("Conf"),
                                           Environment = c("Dry"),
                                           Replicate = i,
                                           negloglike = fit$value,
                                           converge = fit$convergence, stringsAsFactors = FALSE),
                                t(as.data.frame(fit$par)))
    }
    estimates.temp
})
# Merge results with storage data.frame
for(i in 1:length(estimates.raw)){
    estimates <- rbind.fill(estimates, as.data.frame(estimates.raw[i]))
}

print(estimates)

# Save results (everything)
write.table(estimates, file="results-bootstrap-dispersal.csv", sep = ",", quote = FALSE, row.names = FALSE)
