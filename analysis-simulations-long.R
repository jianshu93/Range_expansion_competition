# Set seed
set.seed(20190823)

# Load libray
library("deSolve")

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

# No Competition
## Storage
N.stor <- matrix(NA, nrow = numr * (max(gens) + 1), ncol = land.size + 2)
M.stor <- matrix(NA, nrow = numr * (max(gens) + 1), ncol = land.size + 2)
## Loop        
for(h in 1:numr){
    # Storage
    storN <- matrix(0, ncol = land.size, nrow = max(gens) + 1)
    storM <- matrix(0, ncol = land.size, nrow = max(gens) + 1)
    # Initialize replicate
    storN[1, 1] <- 50 # T. castaneum
    # Simulate replicate
    for(i in 2:(max(gens) + 1)){
        ## Simulation
        temp <- simulate.landscape(N = storN[i - 1, ],
                                   M = storM[i - 1, ],
                                   param = param.wet,
                                   growth = growth,
                                   dispN = dispersal3,
                                   dispM = dispersal3)
        storN[i, ] <- temp$N
        storM[i, ] <- temp$M
    }
    N.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 1] <- h
    N.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 2] <- gens
    N.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 3:ncol(N.stor)] <- storN
    M.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 1] <- h
    M.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 2] <- gens
    M.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 3:ncol(M.stor)] <- storM
}
## Save output
write.table(x = N.stor, file = "simulations/dataN-simulate-long-wetnocomp.csv", sep = ",", row.names = FALSE, col.names = FALSE)

# Competition
## Storage
N.stor <- matrix(NA, nrow = numr * (max(gens) + 1), ncol = land.size + 2)
M.stor <- matrix(NA, nrow = numr * (max(gens) + 1), ncol = land.size + 2)
## Loop        
for(h in 1:numr){
    # Storage
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
                                   param = param.wet,
                                   growth = growth,
                                   dispN = dispersal3,
                                   dispM = dispersal3)
        storN[i, ] <- temp$N
        storM[i, ] <- temp$M
    }
    N.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 1] <- h
    N.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 2] <- gens
    N.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 3:ncol(N.stor)] <- storN
    M.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 1] <- h
    M.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 2] <- gens
    M.stor[((max(gens) + 1) * (h - 1) + 1):((max(gens) + 1) * h), 3:ncol(M.stor)] <- storM
}
## Save output
write.table(x = N.stor, file = "simulations/dataN-simulate-long-wetcomp.csv", sep = ",", row.names = FALSE, col.names = FALSE)
write.table(x = M.stor, file = "simulations/dataM-simulate-long-wetcomp.csv", sep = ",", row.names = FALSE, col.names = FALSE)
