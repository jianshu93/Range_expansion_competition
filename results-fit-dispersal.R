# Source library for making 3D plots
library(plot3D)

# Source library
library("deSolve")
# Source models
## Diffusion
source("disp/diffuse.R")
## Diffusion + density-independent diffusion coefficient
source("disp/dispersal1.R")
## Diffusion + density-dependent (i.e., starting density of the patch)
source("disp/dispersal2.R")

# Source estimates
source("Data/param-wet.R")

# Read data (as.matrix ensure compliance with lsoda)
dataN.wet <- as.matrix(read.csv("Data/dataN-dispersal-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1])
dataM.wet <- as.matrix(read.csv("Data/dataM-dispersal-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1])

### Create duplicate data frames representing "before dispersal"
dataN.wet0 <- dataN.wet * 0
dataN.wet0[, 1] <- rowSums(dataN.wet)
dataM.wet0 <- dataM.wet * 0
dataM.wet0[, 1] <- rowSums(dataM.wet)

pdf(file="Fits-Dispersal.pdf", height = 6, width = 12)
par(mar = c(2, 5, 2, 2), mfrow = c(1, 2))
# Base plot
## T castaneum
scatter3D(x = seq(1,  5),
          y = rep(dataN.wet0[1, 1], 5),
          z = dataN.wet[1, 1:5],
          colvar = NULL,
          col = rgb(0, 0, 0, alpha = 0.7),
          xlim = c(1, 5),
          ylim = c(0, 150),
          zlim = c(0, 100),
          type = "p",
          cex = 0.7,
          pch = 16,
          xlab = "",
          ylab = "",
          zlab = "",
          theta = 310,
          phi = 30,
          d = 5,
          bty = "g",
          ticktype = "detailed")
scatter3D(x = seq(1,  5),
          y = rep(dataN.wet0[1, 1], 5),
          z = dataN.wet[1, 1:5],
          colvar = NULL,
          col = rgb(.65, .65, .65, alpha = 0.7),
          type = "h",
          cex = 0,
          lty = "solid",
          add = TRUE)
# Other rows
for(i in 2:nrow(dataN.wet)){
    scatter3D(x = seq(1,  5),
              y = rep(dataN.wet0[i, 1], 5),
              z = dataN.wet[i, 1:5],
              colvar = NULL,
              col = rgb(0, 0, 0, alpha = 0.7),
              xlim = c(1, 5),
              ylim = c(0, 150),
              zlim = c(0, 100),
              type = "p",
              cex = 0.7,
              pch = 16,
              add = TRUE)
    scatter3D(x = seq(1,  5),
              y = rep(dataN.wet0[i, 1], 5),
              z = dataN.wet[i, 1:5],
              colvar = NULL,
              col = rgb(.65, .65, .65, alpha = 0.7),
              type = "h",
              cex = 0,
              lty = "solid",
              add = TRUE)
}
# Add labels
dims <- par("usr")
text(x = dims[1] + .92 * diff(dims[1:2]),
     y = dims[3] + 0.09 * diff(dims[3:4]),
     c("Patch number"), cex = 1.3, xpd = TRUE)
text(x = dims[1] + 0.22 * diff(dims[1:2]),
     y = dims[3] + 0.07 * diff(dims[3:4]),
     expression(paste(italic("N")["1,t"])), cex = 1.3, xpd = TRUE)
text(x = dims[1] - 0.08 * diff(dims[1:2]),
     y = dims[3] + 0.52 * diff(dims[3:4]),
     expression(paste(italic("N")["x,t+1"])), cex = 1.3, xpd = TRUE)
# Add dispersal lines
xx <- seq(1, 5)
yy <- seq(0, 150, 2)
xxs <- matrix(xx, nrow = length(xx), ncol = length(yy), byrow = FALSE)
yys <- matrix(yy, nrow = length(xx), ncol = length(yy), byrow = TRUE)
zz <- matrix(NA, nrow = length(xx), ncol = length(yy))
for(i in 1:length(xx)){
    for(j in 1:length(yy)){
        zz[i, j] <- dispersal2(D = param.wet$Dn, F = param.wet$Fn, N = c(yy[j], rep(0, 4)))[i]
    }
}
## Loop
surf3D(x = xxs,
       y = yys,
       z = zz,
       colvar = NULL,
       add = TRUE,
       col = rgb(0, 0.8, 0, alpha = 0.7),
       alpha = 0.2)
mtext(side = 3, text = expression(paste(bold("A      "), italic("T. castaneum "), sep = "")), adj = 0)

## T confusum
scatter3D(x = seq(5,  9),
          y = rep(dataM.wet0[1, 1], 5),
          z = dataM.wet[1, 5:1],
          colvar = NULL,
          col = rgb(0, 0, 0, alpha = 0.7),
          xlim = c(5, 9),
          ylim = c(0, 350),
          zlim = c(0, 350),
          type = "p",
          cex = 0.7,
          pch = 16,
          xlab = "",
          ylab = "",
          zlab = "",
          theta = 310,
          phi = 30,
          d = 5,
          bty = "g",
          ticktype = "detailed")
scatter3D(x = seq(5,  9),
          y = rep(dataM.wet0[1, 1], 5),
          z = dataM.wet[1, 5:1],
          colvar = NULL,
          col = rgb(.65, .65, .65, alpha = 0.7),
          type = "h",
          cex = 0,
          lty = "solid",
          add = TRUE)
# Other rows
for(i in 2:nrow(dataM.wet)){
    scatter3D(x = seq(5,  9),
              y = rep(dataM.wet0[i, 1], 5),
              z = dataM.wet[i, 5:1],
              colvar = NULL,
              col = rgb(0, 0, 0, alpha = 0.7),
              xlim = c(5, 9),
              ylim = c(0, 350),
              zlim = c(0, 350),
              type = "p",
              cex = 0.7,
              pch = 16,
              add = TRUE)
    scatter3D(x = seq(5,  9),
              y = rep(dataM.wet0[i, 1], 5),
              z = dataM.wet[i, 5:1],
              colvar = NULL,
              col = rgb(.65, .65, .65, alpha = 0.7),
              type = "h",
              cex = 0,
              lty = "solid",
              add = TRUE)
}
# Add labels
dims <- par("usr")
text(x = dims[1] + 0.92 * diff(dims[1:2]),
     y = dims[3] + 0.09 * diff(dims[3:4]),
     c("Patch number"), cex = 1.3, xpd = TRUE)
text(x = dims[1] + 0.22 * diff(dims[1:2]),
     y = dims[3] + 0.07 * diff(dims[3:4]),
     expression(paste(italic("M")["1,t"])), cex = 1.3, xpd = TRUE)
text(x = dims[1] - 0.08 * diff(dims[1:2]),
     y = dims[3] + 0.52 * diff(dims[3:4]),
     expression(paste(italic("M")["x,t+1"])), cex = 1.3, xpd = TRUE)
# Add dispersal lines
xx <- seq(5, 9)
yy <- seq(0, 350, 2)
xxs <- matrix(xx, nrow = length(xx), ncol = length(yy), byrow = FALSE)
yys <- matrix(yy, nrow = length(xx), ncol = length(yy), byrow = TRUE)
zz <- matrix(NA, nrow = length(xx), ncol = length(yy))
for(i in 1:length(xx)){
    for(j in 1:length(yy)){
        zz[i, j] <- dispersal2(D = param.wet$Dm, F = param.wet$Fm, N = c(rep(0, 4), yy[j]))[i]
    }
}
## Loop
surf3D(x = xxs,
       y = yys,
       z = zz,
       colvar = NULL,
       add = TRUE,
       col = rgb(0, 0.8, 0, alpha = 0.7),
       alpha = 0.2)
mtext(side = 3, text = expression(paste(bold("B      "), italic("T. confusum "), sep = "")), adj = 0)

dev.off()
