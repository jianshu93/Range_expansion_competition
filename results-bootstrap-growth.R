# Source bootstraps
results <- read.csv("Data/results-bootstrap-growth.csv", header = TRUE)
# Which parameters were (exp) transformed?
positives <- c("Rn", "Rm", "KDn", "KDm", "KEn", "KEm", "thetam")
# Exp transform relevant parameters
pos.regex <- paste(positives, collapse = "|") # collapse "pos" to regex
pos.tr <- grep(pos.regex, names(results)) # parameters to transform
results <- replace(results, pos.tr, exp(results[pos.tr])) # transform (exp)
# Convert female-specific growth rate to population-level
results$Rn <- results$Rn  / 2
results$Rm <- results$Rm  / 2

# Source estimates
source("Data/param-wet.R")
# Keep only first 8 elements
param.wet <- param.wet[1:9]
# Convert growth rate to population-level
param.wet$Rn <- param.wet$Rn / 2
param.wet$Rm <- param.wet$Rm / 2

stor <- data.frame()
# Humid
for(i in 1:length(param.wet)){
    coltemp <- which(names(results) == names(param.wet)[i])
    temp <- subset(results, Environment == "Wet")
    quant.temp <- quantile(temp[, coltemp], probs = c(0.025, 0.975))
    stor.temp <- data.frame(Environment = "Wet",
                            Parameter = names(param.wet)[i],
                            PointEst = param.wet[[i]],
                            Lower95 = quant.temp[[1]],
                            Upper95 = quant.temp[[2]])
    stor <- rbind(stor, stor.temp)
}

pdf(file= "Figs/Bootstrap.pdf", width = 14, height = 8)

par(mfrow = c(2, 3), mar = c(5, 5, 3, 0))
# R
plot(NA, xlim = c(0, 3), ylim = c(2, 6),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "Value", xlab = "Parameter", cex.lab = 1.5)
axis(1, seq(0, 3, 3), tcl = 0, labels = FALSE)
axis(1, seq(1, 2, 1), tcl = -.5, labels = c(expression(italic("R")[n]), expression(italic("R")[m])), cex.axis = 1.5)
axis(2, at = seq(2, 6, 1), tcl = -.5, las = 1)
sub1 <- subset(stor, Parameter %in% c("Rn", "Rm"))
arrows(x0 = 1, y0 = sub1$Lower95[1], y1 = sub1$Upper95[1], length = 0.05, angle = 90, code = 3)
arrows(x0 = 2, y0 = sub1$Lower95[2], y1 = sub1$Upper95[2], length = 0.05, angle = 90, code = 3)
points(x = 1, y = sub1$PointEst[1], pch = 16, cex = 2)
points(x = 2, y = sub1$PointEst[2], pch = 16, cex = 2)
mtext(side = 3, expression(paste(bold("A"), "  Intrinsic growth rate, ", italic("R"))), adj = 0, cex = 1.3)
# alpann
plot(NA, xlim = c(0, 3), ylim = c(.0035, .006),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "", xlab = "Parameter", cex.lab = 1.5)
axis(1, seq(0, 3, 3), tcl = 0, labels = FALSE)
axis(1, seq(1, 2, 1), tcl = -.5, labels = c(expression(italic(alpha)[nn]), expression(italic(alpha)[mm])), cex.axis = 1.5)
axis(2, at = seq(.0035, .006, .0005), tcl = -.5, las = 1)
sub1 <- subset(stor, Parameter %in% c("alphann", "alphamm"))
arrows(x0 = 1, y0 = sub1$Lower95[1], y1 = sub1$Upper95[1], length = 0.05, angle = 90, code = 3)
arrows(x0 = 2, y0 = sub1$Lower95[2], y1 = sub1$Upper95[2], length = 0.05, angle = 90, code = 3)
points(x = 1, y = sub1$PointEst[1], pch = 16, cex = 2)
points(x = 2, y = sub1$PointEst[2], pch = 16, cex = 2)
mtext(side = 3, expression(paste(bold("B"), "  Intraspecific search rate, ", alpha[ii])), adj = 0, cex = 1.3)
# alpanm
plot(NA, xlim = c(0, 3), ylim = c(.001, .008),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "", xlab = "Parameter", cex.lab = 1.5)
axis(1, seq(0, 3, 3), tcl = 0, labels = FALSE)
axis(1, seq(1, 2, 1), tcl = -.5, labels = c(expression(italic(alpha)[nm]), expression(italic(alpha)[mn])), cex.axis = 1.5)
axis(2, at = seq(.001, .008, .001), tcl = -.5, las = 1)
sub1 <- subset(stor, Parameter %in% c("alphanm", "alphamn"))
arrows(x0 = 1, y0 = sub1$Lower95[1], y1 = sub1$Upper95[1], length = 0.05, angle = 90, code = 3)
arrows(x0 = 2, y0 = sub1$Lower95[2], y1 = sub1$Upper95[2], length = 0.05, angle = 90, code = 3)
points(x = 1, y = sub1$PointEst[1], pch = 16, cex = 2)
points(x = 2, y = sub1$PointEst[2], pch = 16, cex = 2)
mtext(side = 3, expression(paste(bold("C"), "  Interspecific search rate, ", alpha[ij])), adj = 0, cex = 1.3)
# thetam
plot(NA, xlim = c(0, 3), ylim = c(2, 18),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "Value", xlab = "Parameter", cex.lab = 1.5)
axis(1, seq(0, 3, 3), tcl = 0, labels = FALSE)
axis(1, seq(1, 2, 1), tcl = -.5, labels = c(expression(italic(theta)[n]), expression(italic(theta)[m])), cex.axis = 1.5)
axis(2, at = seq(2, 18, 2), tcl = -.5, las = 1)
sub1 <- subset(stor, Parameter == "thetam")
arrows(x0 = 2, y0 = sub1$Lower95[1], y1 = sub1$Upper95[1], length = 0.05, angle = 90, code = 3)
## arrows(x0 = 2, y0 = sub1$Lower95[2], y1 = sub1$Upper95[2], length = 0.05, angle = 90, code = 3)
points(x = 2, y = sub1$PointEst[1], pch = 16, cex = 2)
mtext(side = 3, expression(paste(bold("D"), "  Half saturation, ", theta)), adj = 0, cex = 1.3)
text(x = 0.6, y = 10, labels = "No estimate", adj = 0, cex = 1.7)
abline(h = 0, lty = "dotted")
# kDn
plot(NA, xlim = c(0, 3), ylim = c(0.1, 0.3),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "", xlab = "Parameter", cex.lab = 1.5)
axis(1, seq(0, 3, 3), tcl = 0, labels = FALSE)
axis(1, seq(1, 2, 1), tcl = -.5, labels = c(expression(italic("KD")[n]), expression(italic("KD")[m])), cex.axis = 1.5)
axis(2, at = seq(.10, .3, .04), tcl = -.5, las = 1)
sub1 <- subset(stor, Parameter %in% "KDn")
arrows(x0 = 1, y0 = sub1$Lower95[1], y1 = sub1$Upper95[1], length = 0.05, angle = 90, code = 3)
points(x = 1, y = sub1$PointEst[1], pch = 16, cex = 2)
text(x = 1.7, y = .2, labels = "No estimate", adj = 0, cex = 1.7)
mtext(side = 3, expression(paste(bold("E"), "  Reciprocal dispersion (demographic)")), adj = 0, cex = 1.3)
abline(h = 0, lty = "dotted")
# kEm
plot(NA, xlim = c(0, 3), ylim = c(6, 12),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "", xlab = "Parameter", cex.lab = 1.5)
axis(1, seq(0, 3, 3), tcl = 0, labels = FALSE)
axis(1, seq(1, 2, 1), tcl = -.5, labels = c(expression(italic("KE")[n]), expression(italic("KE")[m])), cex.axis = 1.5)
axis(2, at = seq(6, 12, 1), tcl = -.5, las = 1)
sub1 <- subset(stor, Parameter == "KEm")
arrows(x0 = 2, y0 = sub1$Lower95[1], y1 = sub1$Upper95[1], length = 0.05, angle = 90, code = 3)
points(x = 2, y = sub1$PointEst[1], pch = 16, cex = 2)
text(x = .6, y = 9, labels = "No estimate", adj = 0, cex = 1.7)
mtext(side = 3, expression(paste(bold("F"), "  Reciprocal dispersion (environmental)")), adj = 0, cex = 1.3)


dev.off()
