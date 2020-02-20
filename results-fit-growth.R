# Source library for making 3D plots
library(plot3D)

# Source estimates
source("Data/param-wet.R")

# Source pmf
source("pmf/Ricker_nbinomD_binom.pmf.R") # T. cast
source("pmf/Ricker_nbinomE_allee_binom.pmf.R") # T. conf

# Read data
dataN.wet <- read.csv("Data/dataN-growth-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]
dataM.wet <- read.csv("Data/dataM-growth-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]

# Format data for plotting
stor.wet <- matrix(NA, ncol = 4, nrow = 0)
for(i in 1:nrow(dataN.wet)){
    temp <- matrix(NA, ncol = 4, nrow = (ncol(dataN.wet) - 1))
    for(j in 1:(ncol(dataN.wet) - 1)){
        X1 <- dataN.wet[i, j]
        Y1 <- dataM.wet[i, j]
        X2 <- dataN.wet[i, j + 1]
        Y2 <- dataM.wet[i, j + 1]
        temp[j, ] <- c(X1, Y1, X2, Y2)
    }
    stor.wet <- rbind(stor.wet, temp)
}

# Probability of Xtp1 given estimated parameters
## T castaneum
#### Remove cases Xt = 0
stor.wet.cast <- stor.wet[-which(stor.wet[, 1] == 0), ]
#### Split into two for plotting
stor.wet.cast0 <- subset(stor.wet.cast, stor.wet.cast[, 2] == 0) # competitor absent
stor.wet.castY <- subset(stor.wet.cast, stor.wet.cast[, 2] > 0) # competitor present
#### Generate probabilities using T castaneum parameters and best-fit model
aa.wet.cast <- seq(2, 350, by = 1)
bb.wet.cast <- c(0, 165, 330)
cc.wet.cast <- seq(0, 350, by = 1)
probs.wet.cast <- array(NA, dim = c(length(aa.wet.cast), length(bb.wet.cast), length(cc.wet.cast)))
for(i in 1:length(aa.wet.cast)){
    for(j in 1:length(bb.wet.cast)){
        for(k in 1:length(cc.wet.cast)){
            probs.wet.cast[,,k][i, j] <- Ricker_nbinomD_binom.pmf(Xt = aa.wet.cast[i],
                                                                  Yt = bb.wet.cast[j],
                                                                  Xtp1 = cc.wet.cast[k],
                                                                  Rx = param.wet$Rn,
                                                                  alphaxx = param.wet$alphann,
                                                                  alphaxy = param.wet$alphanm,
                                                                  KDx = param.wet$KDn)
        }
    }
}

## T confusum
#### Remove cases Xt = 0
stor.wet.conf <- stor.wet[-which(stor.wet[, 2] == 0), ]
#### Split into two for plotting
stor.wet.conf0 <- subset(stor.wet.conf, stor.wet.conf[, 1] == 0)
stor.wet.confY <- subset(stor.wet.conf, stor.wet.conf[, 1] > 0)
#### Generate probabilities using T confusum parameters and best-fit model
aa.wet.conf <- seq(2, 525, by = 1)
bb.wet.conf <- c(0, 150, 300)
cc.wet.conf <- seq(0, 525, by = 1)
probs.wet.conf <- array(NA, dim = c(length(aa.wet.conf), length(bb.wet.conf), length(cc.wet.conf)))
for(i in 1:length(aa.wet.conf)){
    for(j in 1:length(bb.wet.conf)){
        for(k in 1:length(cc.wet.conf)){
            probs.wet.conf[,,k][i, j] <- Ricker_nbinomE_allee_binom.pmf(Xt = aa.wet.conf[i],
                                                                  Yt = bb.wet.conf[j],
                                                                  Xtp1 = cc.wet.conf[k],
                                                                  Rx = param.wet$Rm,
                                                                  alphaxx = param.wet$alphamm,
                                                                  alphaxy = param.wet$alphamn,
                                                                  KEx = param.wet$KEm,
                                                                  thetax = param.wet$thetam)
        }
    }
}

# Plot
pdf(file="Fits-Growth.pdf", height = 6, width = 12)
par(mar = c(2, 6, 2, 6), mfrow = c(1, 2))
## Panel A - T castaneum
### Plot points
scatter3D(x = stor.wet.cast0[, 1],
          y = stor.wet.cast0[, 2],
          z = stor.wet.cast0[, 3],
          colvar = NULL,
          col = rgb(0, 0, 0, alpha = 0.7),
          xlim = c(0, 350),
          ylim = c(0, 330),
          zlim = c(0, 350),
          type = "p",
          cex = .9,
          pch = 16,
          xlab = "",
          ylab = "",
          zlab = "",
          theta = 300,
          phi = 30,
          d = 5,
          bty = "g",
          ticktype = "detailed")
scatter3D(x = stor.wet.castY[, 1],
          y = stor.wet.castY[, 2],
          z = stor.wet.castY[, 3],
          colvar = NULL,
          col = rgb(.65, .65, .65, alpha = 0.7),
          type = "h",
          cex = 0,
          lty = "solid",
          add = TRUE)
scatter3D(x = stor.wet.castY[, 1],
          y = stor.wet.castY[, 2],
          z = stor.wet.castY[, 3],
          colvar = NULL,
          col = rgb(0, 0, 0, alpha = 0.7),
          type = "p",
          cex = 0.9,
          ## lty = "solid",
          ## lwd.col = rgb(0, 0, 0, alpha = 0.5),
          ## lwd = 0.01,
          pch = 16,
          add = TRUE)
### Axes labels
dims <- par("usr")
text(x = dims[1] + 0.85 * diff(dims[1:2]),
     y = dims[3] + 0.1 * diff(dims[3:4]),
     expression(paste(italic("N")[t])), cex = 1.5, xpd = TRUE)
text(x = dims[1] + 0.25 * diff(dims[1:2]),
     y = dims[3] + 0.1 * diff(dims[3:4]),
     expression(paste(italic("M")[t])), cex = 1.5, xpd = TRUE)
text(x = dims[1] - 0.2 * diff(dims[1:2]),
     y = dims[3] + 0.52 * diff(dims[3:4]),
     expression(paste(italic("N")[t+1])), cex = 1.5, xpd = TRUE)
### Add slices
slice3D (aa.wet.cast, bb.wet.cast, cc.wet.cast,
         colvar = probs.wet.cast^(1 / 5),
         xs = NULL,
         ys = c(0, 165, 330),
         zs = NULL,
         col = jet.col(alpha = .5),
         border = NA,
         d = 5,
         colkey = FALSE,
         add = TRUE)
mtext(side = 3, text = expression(paste(bold("A "), italic("T. castaneum"), sep = "")), adj = 0)

## Panel B - T confusum
### Plot points
scatter3D(x = stor.wet.conf0[, 2],
          y = stor.wet.conf0[, 1],
          z = stor.wet.conf0[, 4],
          colvar = NULL,
          col = rgb(0, 0, 0, alpha = 0.7),
          xlim = c(0, 525),
          ylim = c(0, 300),
          zlim = c(0, 525),
          type = "p",
          cex = .9,
          pch = 16,
          xlab = "",
          ylab = "",
          zlab = "",
          theta = 300,
          phi = 30,
          d = 5,
          bty = "g",
          ticktype = "detailed")
scatter3D(x = stor.wet.confY[, 2],
          y = stor.wet.confY[, 1],
          z = stor.wet.confY[, 4],
          colvar = NULL,
          col = rgb(.65, .65, .65, alpha = 0.7),
          type = "h",
          cex = 0,
          lty = "solid",
          add = TRUE)
scatter3D(x = stor.wet.confY[, 2],
          y = stor.wet.confY[, 1],
          z = stor.wet.confY[, 4],
          colvar = NULL,
          col = rgb(0, 0, 0, alpha = 0.7),
          type = "p",
          cex = 0.9,
          ## lty = "solid",
          ## lwd.col = rgb(0, 0, 0, alpha = 0.5),
          ## lwd = 0.01,
          pch = 16,
          add = TRUE)
### Axes labels
dims <- par("usr")
text(x = dims[1] + 0.85 * diff(dims[1:2]),
     y = dims[3] + 0.1 * diff(dims[3:4]),
     expression(paste(italic("M")[t])), cex = 1.5, xpd = TRUE)
text(x = dims[1] + 0.25 * diff(dims[1:2]),
     y = dims[3] + 0.1 * diff(dims[3:4]),
     expression(paste(italic("N")[t])), cex = 1.5, xpd = TRUE)
text(x = dims[1] - 0.2 * diff(dims[1:2]),
     y = dims[3] + 0.52 * diff(dims[3:4]),
     expression(paste(italic("M")[t+1])), cex = 1.5, xpd = TRUE)
### Add slices
slice3D (aa.wet.conf, bb.wet.conf, cc.wet.conf,
         colvar = probs.wet.conf^(1 / 5),
         xs = NULL,
         ys = c(0, 150, 300),
         zs = NULL,
         col = jet.col(alpha = .5),
         border = NA,
         d = 5,
         colkey = FALSE,
         add = TRUE)
mtext(side = 3, text = expression(paste(bold("B "), italic("T. confusum"), sep = "")), adj = 0)

dev.off()
