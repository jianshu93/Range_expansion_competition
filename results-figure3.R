
gens <- seq(10, 100, by = 10)

# Scan data
## Humid
### No comp (T cast)
dataN.wetnocomp <- read.csv("simulations/dataN-simulate-long-wetnocomp.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.wetnocomp) <- c("Replicate", "Generation", 1:200)
dataN.wetnocomp <- subset(dataN.wetnocomp, Generation %in% gens)
### Comp (T cast)
dataN.wetcomp <- read.csv("simulations/dataN-simulate-long-wetcomp.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.wetcomp) <- c("Replicate", "Generation", 1:200)
dataN.wetcomp <- subset(dataN.wetcomp, Generation %in% gens)
### Comp (T conf)
dataM.wetcomp <- read.csv("simulations/dataM-simulate-long-wetcomp.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataM.wetcomp) <- c("Replicate", "Generation", 1:200)
dataM.wetcomp <- subset(dataM.wetcomp, Generation %in% gens)

## No comp
stor.wetnocomp <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.wetnocomp, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.wetnocomp <- rbind(stor.wetnocomp, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.wetnocomp$Mean[stor.wetnocomp$Mean == 0] <- NA
## Comp (T cast)
stor.wetcomp <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.wetcomp, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.wetcomp <- rbind(stor.wetcomp, data.frame(Treatment = "Wet",
                                             Generation = gens[i],
                                             Patch = c(1:200),
                                             Mean = t(temp2)[, 1],
                                             Lower = t(temp2)[, 2],
                                             Upper = t(temp2)[, 3]))
}
stor.wetcomp$Mean[stor.wetcomp$Mean == 0] <- NA
## Comp (T conf)
stor.wetcomp2 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataM.wetcomp, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.wetcomp2 <- rbind(stor.wetcomp2, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.wetcomp2$Mean[stor.wetcomp2$Mean == 0] <- NA

pdf(file = "Figs/Figure 3.pdf", width = 7, height = 9)

par(mfcol = c(2, 1), mar = c(5, 5, 2, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 350), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.4)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 350, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("A"), "  Predicted expansion, No Competition")), adj = 0, cex = 1.3)
for(i in 1:length(gens)){
    temp <- subset(stor.wetnocomp, Generation == gens[i])
    print(i)
    if(i < 10){
        points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .5), type = "l", lwd = 2)
    } else{
        points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = 1), type = "l", lwd = 4)
    }
}
legend(x = 1, y = 370, adj = 0, lty = c("solid"), c(expression(italic("T. castaneum"))), bty = "n", pch = NA, cex = 1.2, col = c(rgb(51 / 255, 51 / 255, 51 / 255)))

## B
plot(NA, xlim = c(1, 200), ylim = c(0, 350), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.4)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 350, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("B"), "  Predicted expansion, Competition")), adj = 0, cex = 1.3)
for(i in 1:length(gens)){
    temp <- subset(stor.wetcomp2, Generation == gens[i])
    if(i < 10){
        points(Mean ~ Patch, data = temp, col = rgb(202 / 255, 44 / 255, 146 / 255, alpha = .6), type = "l", lwd = 2, lty = "dotted")
    } else{
        points(Mean ~ Patch, data = temp, col = rgb(202 / 255, 44 / 255, 146 / 255, alpha = 1), type = "l", lwd = 4, lty = "dotted")
    }
}
for(i in 1:length(gens)){
    temp <- subset(stor.wetcomp, Generation == gens[i])
    if(i < 10){
        points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .5), type = "l", lwd = 2)
    } else{
        points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = 1), type = "l", lwd = 4)
    }
}
legend(x = 1, y = 370, adj = 0, lty = c("solid", "dotted"), c(expression(italic("T. castaneum")), expression(italic("T. confusum"))), bty = "n", pch = NA, col = c(rgb(51 / 255, 51 / 255, 51 / 255), rgb(202 / 255, 44 / 255, 146 / 255)), cex = 1.2)

dev.off()


