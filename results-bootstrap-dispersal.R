library("plyr")

# Source bootstraps
results <- read.csv("Data/results-bootstrap-dispersal.csv", header = TRUE)
# Parameters D and S need to be exp-transformed
results[, "D"] <- exp(results[, "D"])
# Subset
results <- subset(results, converge == 0) # optim coverged
## Separate by species to assign proper colnames
results1 <- subset(results, Species == "Cast")
results2 <- subset(results, Species == "Conf")
## Assign colnames that correspond with parameter names
colnames(results1)[6:7] <- c("Dn", "Fn")
colnames(results2)[6:7] <- c("Dm", "Fm")
## Recombine
results <- rbind.fill(results1, results2)

# Source estimates
source("Data/param-wet.R")

# Keep only first dispersal parameters
param.wet <- param.wet[-c(1:9)]

stor <- data.frame()
for(i in 1:length(param.wet)){
    coltemp <- which(names(results) == names(param.wet)[i])
    temp <- subset(results, Environment == "Humid")
    quant.temp <- quantile(temp[, coltemp], probs = c(0.025, 0.975), na.rm = TRUE)
    stor.temp <- data.frame(Environment = "Humid",
                            Parameter = names(param.wet)[i],
                            PointEst = param.wet[[i]],
                            Lower95 = quant.temp[[1]],
                            Upper95 = quant.temp[[2]])
    stor <- rbind(stor, stor.temp)
}

pdf(file= "Dispersal-Bootstrap.pdf", width = 9, height = 5)

par(mfrow = c(1, 2), mar = c(5, 6, 3, 0))
# Dn
plot(NA, xlim = c(0, 3), ylim = c(0, 1),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "", xlab = "Parameter", cex.lab = 1.5)
mtext(side = 2, text = "Value", line = 3, cex = 1.4)
axis(1, seq(0, 3, 3), tcl = 0, labels = FALSE)
axis(1, seq(1, 2, 1), tcl = -.5, labels = c(expression(italic("D")[n]), expression(italic("D")[m])), cex.axis = 1.5)
axis(2, at = seq(0, 1, .2), tcl = -.5, las = 1)
sub1 <- subset(stor, Parameter %in% c("Dn", "Dm"))
arrows(x0 = 1, y0 = sub1$Lower95[1], y1 = sub1$Upper95[1], length = 0.05, angle = 90, code = 3)
arrows(x0 = 2, y0 = sub1$Lower95[2], y1 = sub1$Upper95[2], length = 0.05, angle = 90, code = 3)
points(x = 1, y = sub1$PointEst[1], pch = 16, cex = 1.5)
points(x = 2, y = sub1$PointEst[2], pch = 16, cex = 1.5)
mtext(side = 3, expression(paste(bold("A"), "   Dispersal rate, ", italic("D"))), adj = 0, cex = 1.3)
clip(0, 3, 0, 1)
abline(h = 0, lty = "dotted")
# Fn
plot(NA, xlim = c(0, 3), ylim = c(0, .015),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "", xlab = "Parameter", cex.lab = 1.4)
axis(1, seq(0, 3, 3), tcl = 0, labels = FALSE)
axis(1, seq(1, 2, 1), tcl = -.5, labels = c(expression(italic("G")[n]), expression(italic("G")[m])), cex.axis = 1.5)
axis(2, at = seq(0, .015, .003), tcl = -.5, las = 1)
sub1 <- subset(stor, Parameter %in% c("Fn", "Fm"))
arrows(x0 = 1, y0 = sub1$Lower95[1], y1 = sub1$Upper95[1], length = 0.05, angle = 90, code = 3)
arrows(x0 = 2, y0 = sub1$Lower95[2], y1 = sub1$Upper95[2], length = 0.05, angle = 90, code = 3)
points(x = 1, y = sub1$PointEst[1], pch = 16, cex = 1.5)
points(x = 2, y = sub1$PointEst[2], pch = 16, cex = 1.5)
mtext(side = 3, expression(paste(bold("B"), "   Fouling coefficient, ", italic("G"))), adj = 0, cex = 1.3)
clip(0, 3, 0, 1)
abline(h = 0, lty = "dotted")

dev.off()
