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

# Source negative log-likelihood function (to be optimized)
source("nll-growth.R")

# Initial parameter estimates
param.wet <- list(
    Rn = 1.52,
    Rm = 2.01,
    alphann = 0.0041,
    alphamm = 0.0046,
    alphanm = 0.004,
    alphamn = 0.004,
    KDn = -1.62,
    KDm = 2.30,
    KEn = 6.98,
    KEm = 2.09,
    thetan = log(20),
    thetam = log(20)
    )

# Parameter values that must be positive
positives <- c("Rn", "Rm", "KDn", "KDm", "KEn", "KEm", "thetan", "thetam")

# Make list of probability mass functions (pmf)
pmf.list1 <- list.files(path = "pmf", pattern = "*.R")
# Source pmf functions
sapply(pmf.list1, FUN = function(X) source(paste("pmf/", X, sep = "")))
# Trim ".R" extension from list
pmf.list1 <- gsub(pattern = "\\.R$", "", pmf.list1)
# Create two column table (one per species) 
## Models with sex
sex.list <- expand.grid(Species1 = pmf.list1[c(grep(pattern = "binom.pmf", x = pmf.list1),
                                               grep(pattern = "binom2.pmf", x = pmf.list1))],
                        Species2 = pmf.list1[c(grep(pattern = "binom.pmf", x = pmf.list1),
                                               grep(pattern = "binom2.pmf", x = pmf.list1))],
                        stringsAsFactors = FALSE)
## Models without sex
nosex.list <- expand.grid(Species1 = pmf.list1[-c(grep(pattern = "binom.pmf", x = pmf.list1),
                                                  grep(pattern = "binom2.pmf", x = pmf.list1))],
                          Species2 = pmf.list1[-c(grep(pattern = "binom.pmf", x = pmf.list1),
                                                  grep(pattern = "binom2.pmf", x = pmf.list1))],
                          stringsAsFactors = FALSE)
## Merge
pmf.list2 <- rbind(sex.list, nosex.list)

# Read growth data
dataN.wet <- read.csv("Data/dataN-growth-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]
dataM.wet <- read.csv("Data/dataM-growth-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]

# Make empty data.frame for storing fits
estimates <- data.frame(Environment = c(),
                        Modeln = c(),
                        Modelm = c(),
                        Parameters = c(),
                        negloglike = c(),
                        converge = c(),
                        Rn = c(),
                        Rm = c(),
                        alphann = c(),
                        alphamm = c(),
                        alphanm = c(),
                        alphamn = c(),
                        kD = c(),
                        kE = c(),
                        thetan = c(),
                        thetam = c())

# Export everything to the cluster
clusterExport(clus, c("param.wet",
                      "nll.growth",
                      "positives",
                      paste(pmf.list1),
                      "pmf.list2",
                      "dataN.wet",
                      "dataM.wet",
                      "estimates"))

# Run optimizer
estimates.raw <- parLapplyLB(clus, 1:nrow(pmf.list2), fun = function(i){    
    arg1.temp <- gsub("x", "n", formalArgs(paste(pmf.list2[i, 1]))) # species 1
    arg1.temp <- gsub("y", "m", arg1.temp)
    arg2.temp <- gsub("x", "m", formalArgs(paste(pmf.list2[i, 2]))) # species 2
    arg2.temp <- gsub("y", "n", arg2.temp)
    startingvalues.i <- param.wet[which(names(param.wet) %in% c(arg1.temp, arg2.temp))]
    fit <- optim(par = startingvalues.i,
                 fn = nll.growth,
                 N = dataN.wet,
                 M = dataM.wet,
                 pmf1 = pmf.list2[i, 1],
                 pmf2 = pmf.list2[i, 2],
                 pos = positives,
                 method = c("Nelder-Mead"),
                 control = list(maxit = 10000, parscale = c(abs(as.numeric(startingvalues.i)))))
    estimates.temp <- cbind(data.frame(Environment = c("Wet"),
                                       Modeln = pmf.list2[i, 1],
                                       Modelm = pmf.list2[i, 2],
                                       Parameters = length(fit$par),
                                       negloglike = fit$value,
                                       converge = fit$convergence, stringsAsFactors = FALSE),
                            t(as.data.frame(fit$par)))
    estimates.temp
})
# Merge results with storage data.frame
for(i in 1:length(estimates.raw)){
    estimates <- rbind.fill(estimates, as.data.frame(estimates.raw[i]))
}
# Calculate AIC
estimates$AIC <- (2 * estimates$Parameters) + (2 * estimates$negloglike)
# Save results (WET)
write.table(estimates, file="results-fit-growth-wet.csv", sep = ",", quote = FALSE, row.names = FALSE)
