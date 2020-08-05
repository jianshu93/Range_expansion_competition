# Set seed
set.seed(20190823)

# Load library
library("parallel")

clus <- makeCluster(10)
# Export the libraries
clusterEvalQ(clus, library(parallel))
clusterEvalQ(clus, library(deSolve))

# Source parameter estimates
source("Data/param-wet.R")

# Source growth models 
source("simulations/growth.R") # wet
# Source diffusion models
## Diffusion
source("disp/diffuse.R")
## Diffusion + density-independent diffusion coefficient
source("disp/dispersal1.R")
## Diffusion + density-dependent (i.e., starting density of the patch)
source("disp/dispersal3.R")
# Source simulation script
source("simulations/simulate-landscape.R")

# Simulations
numr <- 10000
# Landscape size
land.size <- 200
# Generations
gens <- c(0:100)

# Make list of parameters to test
## Range to test (in proportions)
prop.range <- seq(0, 1.5, by = .25)
## Param list
param.list <- list()
## Loop
for(i in 1:length(prop.range)){
    param.list[[i]] <- param.wet
    param.list[[i]][["alphanm"]] <- param.list[[i]][["alphanm"]] * prop.range[i]
}

# Export everything to the cluster
clusterExport(clus, c("param.list",
                      "prop.range",
                      "numr",
                      "land.size",
                      "gens",
                      "growth",
                      "diffuse",
                      "dispersal1",
                      "dispersal3",
                      "simulate.landscape"))

## Loop (parallel)
for(j in 1:length(param.list)){
    jj <- j
    clusterExport(clus, "jj")
    results <- parSapplyLB(clus, 1:numr, simplify = FALSE, FUN = function(h){
        # Storage
        N.stor <- matrix(NA, nrow = max(gens) + 1, ncol = land.size + 3)
        M.stor <- matrix(NA, nrow = max(gens) + 1, ncol = land.size + 3)
        # Storage2
        storN <- matrix(0, ncol = land.size, nrow = max(gens) + 1)
        storM <- matrix(0, ncol = land.size, nrow = max(gens) + 1)
        # Initialize replicate
        storN[1, 1] <- 50 # T. castaneum
        storM[1, 9:land.size] <- 50 # T. confusum
        # Simulate replicate
        for(i in 2:(max(gens) + 1)){
        ## Simulation
            temp <- simulate.landscape(N = storN[i - 1, ],
                                       M = storM[i - 1, ],
                                       param = param.list[[jj]],
                                       growth = growth,
                                       dispN = dispersal3,
                                       dispM = dispersal3)
            storN[i, ] <- temp$N
            storM[i, ] <- temp$M
        }
        N.stor[, 1] <- h
        N.stor[, 2] <- gens
        N.stor[, 3] <- 1
        N.stor[, 4:ncol(N.stor)] <- storN
        M.stor[, 1] <- h
        M.stor[, 2] <- gens
        M.stor[, 3] <- 2
        M.stor[, 4:ncol(M.stor)] <- storM
        rbind(N.stor, M.stor)
    })
    # Combine into matrix
    final <- do.call(rbind, results)
    # Split up species
    N.final <- subset(final, final[, 3] == 1)[, -3]
    M.final <- subset(final, final[, 3] == 2)[, -3]
    # Save data
    write.table(x = N.final, file = paste("simulations/dataN-simulate-long-wetcomp-sensitivity-alphanm-", prop.range[jj], ".csv", sep = ""), sep = ",", row.names = FALSE, col.names = FALSE)
    write.table(x = M.final, file = paste("simulations/dataM-simulate-long-wetcomp-sensitivity-alphanm-", prop.range[jj], ".csv", sep = ""), sep = ",", row.names = FALSE, col.names = FALSE)
}
