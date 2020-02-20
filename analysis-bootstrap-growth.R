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

# Make cluser
clus <- makeCluster(10)
# Export the libraries
clusterEvalQ(clus, library(parallel))
clusterEvalQ(clus, library(xtable))
clusterEvalQ(clus, library(plyr))

# Source pmf
source("pmf/Ricker_nbinomD_binom.pmf.R") # T. cast
source("pmf/Ricker_nbinomE_allee_binom.pmf.R") # T. conf (wet)
source("pmf/Ricker_nbinomE_binom.pmf.R") # T. conf (dry)
# Source negative log-likelihood function (to be optimized)
source("nll-growth.R")
# Source parameter estimates
source("Data/param-wet.R")
source("Data/param-dry.R")

# Parameter values that must be positive in the optimization
positives <- c("Rn", "Rm", "KDn", "KDm", "KEm", "thetam")
# Keep only parameter relevant for growth
param.wet <- param.wet[1:9]
param.dry <- param.dry[1:8]
# Transform estimates to be compatible with exp transform in the nll function
positives.regex <- paste(positives, collapse = "|") # collapse "pos" to regex
positives.wet.tr <- grep(positives.regex, names(param.wet)) # parameters to transform (WET)
positives.dry.tr <- grep(positives.regex, names(param.dry)) # parameters to transform (DRY)
param.wet <- replace(param.wet, positives.wet.tr, log(unlist(param.wet[positives.wet.tr]))) # transform (log)
param.dry <- replace(param.dry, positives.dry.tr, log(unlist(param.dry[positives.dry.tr]))) # transform (log)

# Read data
dataN.wet <- read.csv("Data/dataN-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]
dataM.wet <- read.csv("Data/dataM-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]
dataN.dry <- read.csv("Data/dataN-dry.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]
dataM.dry <- read.csv("Data/dataM-dry.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]

# Make empty data.frame for storing fits
estimates <- data.frame(Environment = c(),
                        Replicate = c(),
                        negloglike = c(),
                        converge = c(),
                        Rn = c(),
                        Rm = c(),
                        alphann = c(),
                        alphamm = c(),
                        alphanm = c(),
                        alphamn = c(),
                        KDn = c(),
                        KEm = c(),
                        thetam = c())

# Export everything to the cluster
clusterExport(clus, c("param.wet",
                      "param.dry",
                      "Ricker_nbinomD_binom.pmf",
                      "Ricker_nbinomE_allee_binom.pmf",
                      "Ricker_nbinomE_binom.pmf",
                      "nll.growth",
                      "positives",
                      "dataN.wet",
                      "dataM.wet",
                      "dataN.dry",
                      "dataM.dry",
                      "estimates"))

# Run optimizer (WET)
estimates.raw <- parLapplyLB(clus, 1:numr, fun = function(i){
    rands.temp <- sample(1:nrow(dataN.wet), size = nrow(dataN.wet), replace = TRUE)
    dataN.temp <- dataN.wet[rands.temp, ]
    dataM.temp <- dataM.wet[rands.temp, ]
    arg1.temp <- gsub("x", "n", formalArgs(Ricker_nbinomD_binom.pmf))# species 1
    arg1.temp <- gsub("y", "m", arg1.temp)
    arg2.temp <- gsub("x", "m", formalArgs(Ricker_nbinomE_allee_binom.pmf))# species 2
    arg2.temp <- gsub("y", "n", arg2.temp)
    startingvalues.i <- param.wet[which(names(param.wet) %in% c(arg1.temp, arg2.temp))]
    fit <- optim(par = startingvalues.i,
                 fn = nll.growth,
                 N = dataN.temp,
                 M = dataM.temp,
                 pmf1 = Ricker_nbinomD_binom.pmf,
                 pmf2 = Ricker_nbinomE_allee_binom.pmf,
                 pos = positives,
                 method = c("Nelder-Mead"),
                 control = list(maxit = 5000, parscale = startingvalues.i))
    estimates.temp <- cbind(data.frame(Environment = c("Wet"),
                                       Replicate = i,
                                       negloglike = fit$value,
                                       converge = fit$convergence, stringsAsFactors = FALSE),
                            t(as.data.frame(fit$par)))
    estimates.temp
})
# Merge results with storage data.frame
for(i in 1:length(estimates.raw)){
    estimates <- rbind.fill(estimates, as.data.frame(estimates.raw[i]))
}


# Run optimizer (DRY)
estimates.raw <- parLapplyLB(clus, 1:numr, fun = function(i){
    rands.temp <- sample(1:nrow(dataN.dry), size = nrow(dataN.dry), replace = TRUE)
    dataN.temp <- dataN.dry[rands.temp, ]
    dataM.temp <- dataM.dry[rands.temp, ]
    arg1.temp <- gsub("x", "n", formalArgs(Ricker_nbinomD_binom.pmf))# species 1
    arg1.temp <- gsub("y", "m", arg1.temp)
    arg2.temp <- gsub("x", "m", formalArgs(Ricker_nbinomE_binom.pmf))# species 2
    arg2.temp <- gsub("y", "n", arg2.temp)
    startingvalues.i <- param.dry[which(names(param.dry) %in% c(arg1.temp, arg2.temp))]
    fit <- optim(par = startingvalues.i,
                 fn = nll.growth,
                 N = dataN.temp,
                 M = dataM.temp,
                 pmf1 = Ricker_nbinomD_binom.pmf,
                 pmf2 = Ricker_nbinomE_binom.pmf,
                 pos = positives,
                 method = c("Nelder-Mead"),
                 control = list(maxit = 5000, parscale = startingvalues.i))
    estimates.temp <- cbind(data.frame(Environment = c("Dry"),
                                       Replicate = i,
                                       negloglike = fit$value,
                                       converge = fit$convergence, stringsAsFactors = FALSE),
                            t(as.data.frame(fit$par)))
    estimates.temp
})
# Merge results with storage data.frame
for(i in 1:length(estimates.raw)){
    estimates <- rbind.fill(estimates, as.data.frame(estimates.raw[i]))
}

# Save results (everything)
write.table(estimates, file="results-bootstrap-growth.csv", sep = ",", quote = FALSE, row.names = FALSE)
