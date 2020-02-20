# Read data
data <- read.csv("Data/data-counts.csv", header = TRUE)

# Generations to plot
gens <- c(1:8)

# Make a palette
palet <- rainbow(length(gens))

# Number of bootstraps
boots <- 5000

## Plots
pdf(file = "Figs/Figure 1 X.pdf", width = 7, height = 9)
##

par(mfrow = c(2, 1), mar = c(5, 5, 2, 1))
# Treat A
plot(NA, xlim = c(1, 16), ylim = c(0, 400),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "Abundance", xlab = "Patch number", cex.lab = 1.4)
axis(1, seq(1, 16, 1), tcl = -.5)
axis(2, seq(0, 400, 100), tcl = -.5, las = 1, pos = .7)
##
gen8.A <- subset(data, TREATMENT == "A" & GENERATION == 8)
quants.A <- data.frame(PATCH = c(), LOWER = c(), UPPER = c())
for(i in 1:16){
    temp <- subset(gen8.A, PATCH == i)
    temp.stor <- dim(boots)
    for(j in 1:boots){
        temp.stor[j] <- mean(temp[sample(x = 1:nrow(temp), size = nrow(temp), replace = TRUE), "CASTCOUNT"])
    }
    quants.A <- rbind(quants.A,
                         data.frame(PATCH = i,
                                    LOWER = quantile(temp.stor, probs = 0.025)[[1]],
                                    UPPER = quantile(temp.stor, probs = 0.975)[[1]]))
}
##
polygon(x = c(1:16, 16:1), y = c(quants.A[, 2], rev(quants.A[, 3])), col = rgb(1, 0, 191 / 255, 0.15), border = NA)
##
for(i in 1:8){
    tempsub <- subset(data, TREATMENT == "A" & GENERATION == gens[i])
    temp <- aggregate(CASTCOUNT ~ PATCH, data = tempsub, mean)
    tempvar <- aggregate(CASTCOUNT ~ PATCH, data = tempsub, FUN = var)
    temp$var <- tempvar$CASTCOUNT
    zeroes <- which(temp$CASTCOUNT == 0 | temp$var == 0)
    mult <- subset(temp, PATCH < min(temp$PATCH[zeroes], 17))
    sing <- subset(temp, PATCH > max(mult$PATCH) & CASTCOUNT > 0)
    points(mult$CASTCOUNT ~ mult$PATCH, col = palet[i], type = "p", pch = 15)
    points(mult$CASTCOUNT ~ mult$PATCH, col = palet[i], type = "l", lwd = 1.5)
    if(length(sing) > 0){
        points(CASTCOUNT ~ PATCH, data = sing, type = "p", col = palet[i], cex = 1.2, pch = i)
    }
}
legend("topright", c("1", "2", "3", "4", "5", "6", "7", "8"), col = palet, inset = .05, pch = 15, bty = "n", title = expression(underline("Generation")), xjust = 1, cex = 1)
mtext(side = 3, expression(paste(bold("A"))), adj = -.13, cex = 1.4)
mtext(side = 3, expression(paste("No competition")), adj = 0, cex = 1.4)
legend(x = 1, y = 415, adj = 0, lty = "solid", c(expression(italic("T. castaneum"))), bty = "n", pch = c(15), cex = 1.2)

# Treat D
plot(NA, xlim = c(1, 16), ylim = c(0, 400),
     xaxt = "n", yaxt = "n", bty = "n",
     ylab = "Abundance", xlab = "Patch number", cex.lab = 1.4)
axis(1, seq(1, 16, 1), tcl = -.5)
axis(2, seq(0, 400, 100), tcl = -.5, las = 1, pos = .7)
##
gen8.D <- subset(data, TREATMENT == "D" & GENERATION == 8)
quants.D <- data.frame(PATCH = c(), LOWER = c(), UPPER = c())
for(i in 1:16){
    temp <- subset(gen8.D, PATCH == i)
    temp.stor <- dim(boots)
    for(j in 1:boots){
        temp.stor[j] <- mean(temp[sample(x = 1:nrow(temp), size = nrow(temp), replace = TRUE), "CASTCOUNT"])
    }
    quants.D <- rbind(quants.D,
                         data.frame(PATCH = i,
                                    LOWER = quantile(temp.stor, probs = 0.025)[[1]],
                                    UPPER = quantile(temp.stor, probs = 0.975)[[1]]))
}
##
polygon(x = c(1:16, 16:1), y = c(quants.D[, 2], rev(quants.D[, 3])), col = rgb(1, 0, 191 / 255, 0.15), border = NA)
##
for(i in 1:length(gens)){
    # cast
    tempsub <- subset(data, TREATMENT == "D" & GENERATION == gens[i])
    temp <- aggregate(CASTCOUNT ~ PATCH, data = tempsub, mean)
    tempvar <- aggregate(CASTCOUNT ~ PATCH, data = tempsub, FUN = var)
    temp$var <- tempvar$CASTCOUNT
    zeroes <- which(temp$CASTCOUNT == 0 | temp$var == 0)
    mult <- subset(temp, PATCH < min(temp$PATCH[zeroes], 17))
    sing <- subset(temp, PATCH > max(mult$PATCH) & CASTCOUNT > 0)
    points(mult$CASTCOUNT ~ mult$PATCH, col = palet[i], type = "p", pch = 15)
    points(mult$CASTCOUNT ~ mult$PATCH, col = palet[i], type = "l", lwd = 1.5)
    if(length(sing) > 0){
        points(CASTCOUNT ~ PATCH, data = sing, type = "p", col = palet[i], cex = 1.2, pch = 15)
    }
    # conf
    temp <- aggregate(CONFCOUNT ~ PATCH, data = tempsub, mean)
    tempvar <- aggregate(CONFCOUNT ~ PATCH, data = tempsub, FUN = var)
    temp$var <- tempvar$CONFCOUNT
    zeroes <- which(temp$CONFCOUNT == 0 | temp$var == 0)
    mult <- subset(temp, PATCH > max(temp$PATCH[zeroes], 0))
    sing <- subset(temp, PATCH < min(mult$PATCH) & CONFCOUNT > 0)
    points(mult$CONFCOUNT ~ mult$PATCH, col = palet[i], type = "p", pch = 2)
    points(mult$CONFCOUNT ~ mult$PATCH, col = palet[i], type = "l", lwd = 1.5, lty = "dotted")
    if(length(sing) > 0){
        points(CONFCOUNT ~ PATCH, data = sing, type = "p", col = palet[i], cex = 1.2, pch = 2)
    }
}
mtext(side = 3, expression(paste(bold("B"))), adj = -.13, cex = 1.4)
mtext(side = 3, expression(paste("Competition")), adj = 0, cex = 1.4)
legend(x = 1, y = 415, adj = 0, lty = c("solid", "dotted"), c(expression(italic("T. castaneum")), expression(italic("T. confusum"))), bty = "n", pch = c(15, 2), cex = 1.2)


dev.off()
