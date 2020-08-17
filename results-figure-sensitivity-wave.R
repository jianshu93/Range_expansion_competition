# Plots fitted exponents for an exponential approximation to the wave front.
# For T. castaneum. For the best-fitting competition model only.
#
# Brett Melbourne
# 13 Aug 2020

source("fit_exponent.R")

# Which generations to plot
gens2plot <- c(2:5,seq(10,100,10))

# Read data
fpath <- "simulations/dataN-simulate-long-wetcomp.csv"
dataN <- read.csv(fpath, header = FALSE, stringsAsFactors = FALSE)
colnames(dataN) <- c("Replicate", "Generation", 1:200)
unique(dataN$Generation)
head(dataN)

# Calculate means (quantiles here too but we won't use those)
stor <- data.frame()
for ( g in gens2plot ) {
    temp <- subset(dataN, Generation == g)
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor <- rbind(stor, data.frame(Treatment = "Wet",
                                                 Generation = g,
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor$Mean[stor$Mean == 0] <- NA
head(stor)


pdf(file = "Figure S10 Fit.pdf", width = 7, height = 9)

# Draw figure with two panels
par(mfrow=c(2,1),mar=c(5, 5, 2, 2))

# ---- Panel A
plot(NA, xlim = c(1, 200), ylim = c(0,200), ylab = "Mean abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 200, 50), tcl = -.5, las = 1, pos = -3)
for ( g in gens2plot ) {
    temp <- subset(stor, Generation == g)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8),cex=0.5)
}
mtext(side = 3, expression(paste(bold("A"))), adj = 0, cex = 1.3)
legend("topright", adj = 0, lty = c(NA, "solid"), c(expression(paste(italic("T. castaneum"), " (Simulations)")), "Fitted exponential model"), bty = "n", pch = c(1, NA), cex = .9, col = c("black", "red"), inset = 0.05, lwd = c(1, 2))

# Plot fitted exponential model to tail
for ( g in gens2plot ) {
    taildata <- subset(stor, Generation == g & Mean < 20)
    expfit <- fit_exponent(x=taildata$Patch,y=taildata$Mean)
    lines(taildata$Patch,expfit$ypred,col="red")
}

# ---- Panel B
plot(NA, xlim = c(1, 200), ylim = c(0,20.2), ylab = "Mean abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 20, 10), tcl = -.5, las = 1, pos = -3)
axis(2, at = seq(0, 20, 2), tcl = -.25, pos = -3, labels=FALSE)
for ( g in gens2plot ) {
    temp <- subset(stor, Generation == g & Mean < 20)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8),cex=0.5)
}
mtext(side = 3, expression(paste(bold("B"))), adj = 0, cex = 1.3)

# Plot fitted exponential model to tail
up_abun <- 20 #upper threshold for abundance
lo_abun <- 0 #lower threshold for abundance
for ( g in gens2plot ) {
    taildata <- subset(stor, (Generation == g) & (Mean < up_abun) & (Mean > lo_abun) )
    expfit <- fit_exponent(x=taildata$Patch,y=taildata$Mean)
    lines(taildata$Patch,expfit$ypred,col="red")
}

dev.off()


