
## Humid simulations
dataN.wetnocomp <- read.csv("simulations/dataN-simulate-wetnocomp.csv", header = FALSE, stringsAsFactors = FALSE)
dataN.wetcomp <- read.csv("simulations/dataN-simulate-wetcomp.csv", header = FALSE, stringsAsFactors = FALSE)
dataM.wetcomp <- read.csv("simulations/dataM-simulate-wetcomp.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.wetnocomp) <- c("Replicate", "Generation", 1:16)
colnames(dataN.wetcomp) <- c("Replicate", "Generation", 1:16)
colnames(dataM.wetcomp) <- c("Replicate", "Generation", 1:16)

# Source counts
landscapes <- read.csv("Data/data-counts.csv", header = T, stringsAsFactors = F)

## Generations
gens <- c(1:8)

### No comp
stor.wetnocomp <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.wetnocomp, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.wetnocomp <- rbind(stor.wetnocomp, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:16),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.wetnocomp$Mean[stor.wetnocomp$Mean == 0] <- NA
### Comp cast
stor.wetcomp <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.wetcomp, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.wetcomp <- rbind(stor.wetcomp, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:16),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.wetcomp$Mean[stor.wetcomp$Mean == 0] <- NA
### Comp conf
stor.wetcomp2 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataM.wetcomp, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.wetcomp2 <- rbind(stor.wetcomp2, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:16),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.wetcomp2$Mean[stor.wetcomp2$Mean == 0] <- NA

# Plotting parameters
col.cast <- rgb(131 / 255, 139 / 255, 139 / 255, alpha = .7) # colors of 95% interval
col.conf <- rgb(210 / 255, 105 / 255, 30 / 255, alpha = .7) # color of 95% interval
gens <- c(1:8)
xlabels <- c(rep("", 4), rep("Patch number", 4))
ylabels <- c("Abundance", "", "", "", "Abundance", "", "", "")

# No Competition
## Make pdf
pdf(file = "Figs/NoCompetition-NoRestart.pdf", width = 16, height = 8, onefile = TRUE)
par(mfrow = c(2, 4), mar = c(4, 1.5, 2, 0), oma = c(1, 3, 0, 0)) # 2 rows, 4 columns
## Plotting loop
for(h in 1:length(gens)){
    temp.current <- subset(landscapes, TREATMENT == "A" & GENERATION == gens[h])
    refs.current <- unique(temp.current$REFERENCE_ID)
    tempN.simulation <- subset(stor.wetnocomp, Generation == gens[h])
    ## Plot real data
    plot(NA, xlim = c(1, 16), ylim = c(0, 700),
         xaxt = "n", yaxt = "n", bty = "n",
         ylab = ylabels[h], xlab = xlabels[h], cex.lab = 1.3)
    axis(1, at = seq(1, 16, 1), tcl = -.5, cex = .95)
    if(h == 1 | h == 5){
        axis(2, at = seq(0, 700, 100), tcl = -.5, pos = .7, las = 1)
    } else{
        axis(2, at = seq(0, 700, 100), tcl = -.5, pos = .7, labels = FALSE)
    }
    nonzeroesN <- which(tempN.simulation$Mean > 0)
    polygon(x = c(nonzeroesN, rev(nonzeroesN)), y = c(tempN.simulation[nonzeroesN, "Lower"], rev(tempN.simulation[nonzeroesN, "Upper"])), col = col.cast, border = "black", lty = NULL)
    for(i in 1:length(refs.current)){
        temp.real <- subset(temp.current, REFERENCE_ID == refs.current[i] & CASTCOUNT > 0)
        temp.real <- temp.real[order(temp.real$PATCH), ]
        points(CASTCOUNT ~ PATCH, data = temp.real, type = "l", pch = 15)
        points(CASTCOUNT ~ PATCH, data = temp.real, type = "p", pch = 15, cex = 0.8)
    }
    if(h == 1 | h == 5){
        mtext(side = 2, line = 3, text = "Abundance", cex = .95)
    } else{}
    if(h == 1){
        legend("topleft", c(expression(paste(italic("T. castaneum"), " (Data)", sep = "")), "95% prediction interval (Model)"), col = c("black", col.cast), bty = "n", pch = c(15, 15), lty = c("solid", NA, NA), cex = 1.2, pt.cex = c(1, 1.1), inset = 0.05)
    } else{}
    mtext(side = 3, bquote(paste(bold(.(LETTERS[h])), "  Generation ", .(gens[h]))), adj = 0, cex = 1.1)
}
dev.off()

# Humid, Competition
## Make pdf
pdf(file = "Figs/Humid-Competition-NoRestart.pdf", width = 16, height = 8, onefile = TRUE)
par(mfrow = c(2, 4), mar = c(4, 1.5, 2, 0), oma = c(1, 3, 0, 0)) # 2 rows, 4 columns
## Plotting loop
for(h in 1:length(gens)){
    temp.current <- subset(landscapes, TREATMENT == "D" & GENERATION == gens[h])
    refs.current <- unique(temp.current$REFERENCE_ID)
    tempN.simulation <- subset(stor.wetcomp, Generation == gens[h])
    tempM.simulation <- subset(stor.wetcomp2, Generation == gens[h])
    ## Plot real data
    plot(NA, xlim = c(1, 16), ylim = c(0, 700),
         xaxt = "n", yaxt = "n", bty = "n",
         ylab = ylabels[h], xlab = xlabels[h], cex.lab = 1.3)
    axis(1, at = seq(1, 16, 1), tcl = -.5, cex = .95)
    if(h == 1 | h == 5){
        axis(2, at = seq(0, 700, 100), tcl = -.5, pos = .7, las = 1)
    } else{
        axis(2, at = seq(0, 700, 100), tcl = -.5, pos = .7, labels = FALSE)
    }
    nonzeroesN <- which(tempN.simulation$Mean > 0)
    nonzeroesM <- which(tempM.simulation$Mean > 0)
    polygon(x = c(nonzeroesM, rev(nonzeroesM)), y = c(tempM.simulation[nonzeroesM, "Lower"], rev(tempM.simulation[nonzeroesM, "Upper"])), col = col.conf, border = "brown", lty = NULL)
    polygon(x = c(nonzeroesN, rev(nonzeroesN)), y = c(tempN.simulation[nonzeroesN, "Lower"], rev(tempN.simulation[nonzeroesN, "Upper"])), col = col.cast, border = "black", lty = NULL)
    for(i in 1:length(refs.current)){
        if(h == 2 & refs.current[i] == 15){
            temp.real <- subset(temp.current, REFERENCE_ID == refs.current[i])
            temp.real <- temp.real[order(temp.real$PATCH), ]
            temp.real <- subset(temp.real, PATCH > 5)
        } else{
            temp.real <- subset(temp.current, REFERENCE_ID == refs.current[i] & CONFCOUNT > 0)
            temp.real <- temp.real[order(temp.real$PATCH), ]
        }
        points(CONFCOUNT ~ PATCH, data = temp.real, type = "l", pch = 2, lty = "dotted")
        points(CONFCOUNT ~ PATCH, data = temp.real, type = "p", pch = 2, cex = 0.8)
    }
    for(i in 1:length(refs.current)){
        temp.real <- subset(temp.current, REFERENCE_ID == refs.current[i] & CASTCOUNT > 0)
        temp.real <- temp.real[order(temp.real$PATCH), ]
        points(CASTCOUNT ~ PATCH, data = temp.real, type = "l", pch = 15)
        points(CASTCOUNT ~ PATCH, data = temp.real, type = "p", pch = 15, cex = 0.8)
    }
    if(h == 1 | h == 5){
        mtext(side = 2, line = 3, text = "Abundance", cex = .95)
    } else{}
    if(h == 1){
        legend("topleft", c(expression(paste(italic("T. castaneum"), " (Data)", sep = "")), "95% prediction interval (Model)", "", expression(paste(italic("T. confusum"), " (Data)", sep = "")), "95% prediction interval (Model)"), col = c("black", col.cast, NA, "black", col.conf), bty = "n", pch = c(15, 15, NA, 2, 15), lty = c("solid", NA, NA, "dotted", NA), cex = 1.2, pt.cex = c(1, 1.1, NA, 1, 1.1), inset = 0.05)
    } else{}
    mtext(side = 3, bquote(paste(bold(.(LETTERS[h])), "  Generation ", .(gens[h]))), adj = 0, cex = 1.1, xpd = TRUE)
}
dev.off()
