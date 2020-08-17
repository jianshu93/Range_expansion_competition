
gens <- seq(10, 100, by = 10)

## Scan data

### 0 %
#### alphamn
dataN.alphamn.0 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-alphamn-0.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.alphamn.0) <- c("Replicate", "Generation", 1:200)
dataN.alphamn.0 <- subset(dataN.alphamn.0, Generation %in% gens)
#### alphanm
dataN.alphanm.0 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-alphanm-0.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.alphanm.0) <- c("Replicate", "Generation", 1:200)
dataN.alphanm.0 <- subset(dataN.alphanm.0, Generation %in% gens)
#### Fn
##### No comp
dataN.nocomp.Fn.0 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetnocomp-sensitivity-Fn-0.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.nocomp.Fn.0) <- c("Replicate", "Generation", 1:200)
dataN.nocomp.Fn.0 <- subset(dataN.nocomp.Fn.0, Generation %in% gens)
##### Comp
dataN.Fn.0 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-Fn-0.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.Fn.0) <- c("Replicate", "Generation", 1:200)
dataN.Fn.0 <- subset(dataN.Fn.0, Generation %in% gens)
#### Fm
dataN.Fm.0 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-Fm-0.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.Fm.0) <- c("Replicate", "Generation", 1:200)
dataN.Fm.0 <- subset(dataN.Fm.0, Generation %in% gens)

### 75 %
#### alphamn
dataN.alphamn.75 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-alphamn-0.75.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.alphamn.75) <- c("Replicate", "Generation", 1:200)
dataN.alphamn.75 <- subset(dataN.alphamn.75, Generation %in% gens)
#### alphanm
dataN.alphanm.75 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-alphanm-0.75.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.alphanm.75) <- c("Replicate", "Generation", 1:200)
dataN.alphanm.75 <- subset(dataN.alphanm.75, Generation %in% gens)
#### Fn
##### No comp
dataN.nocomp.Fn.75 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetnocomp-sensitivity-Fn-0.75.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.nocomp.Fn.75) <- c("Replicate", "Generation", 1:200)
dataN.nocomp.Fn.75 <- subset(dataN.nocomp.Fn.75, Generation %in% gens)
##### Comp
dataN.Fn.75 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-Fn-0.75.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.Fn.75) <- c("Replicate", "Generation", 1:200)
dataN.Fn.75 <- subset(dataN.Fn.75, Generation %in% gens)
#### Fm
dataN.Fm.75 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-Fm-0.75.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.Fm.75) <- c("Replicate", "Generation", 1:200)
dataN.Fm.75 <- subset(dataN.Fm.75, Generation %in% gens)

### 100 %
#### alphamn
dataN.alphamn.100 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-alphamn-1.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.alphamn.100) <- c("Replicate", "Generation", 1:200)
dataN.alphamn.100 <- subset(dataN.alphamn.100, Generation %in% gens)
#### alphanm
dataN.alphanm.100 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-alphanm-1.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.alphanm.100) <- c("Replicate", "Generation", 1:200)
dataN.alphanm.100 <- subset(dataN.alphanm.100, Generation %in% gens)
#### Fn
##### No comp
dataN.nocomp.Fn.100 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetnocomp-sensitivity-Fn-1.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.nocomp.Fn.100) <- c("Replicate", "Generation", 1:200)
dataN.nocomp.Fn.100 <- subset(dataN.nocomp.Fn.100, Generation %in% gens)
##### Comp
dataN.Fn.100 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-Fn-1.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.Fn.100) <- c("Replicate", "Generation", 1:200)
dataN.Fn.100 <- subset(dataN.Fn.100, Generation %in% gens)
#### Fm
dataN.Fm.100 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-Fm-1.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.Fm.100) <- c("Replicate", "Generation", 1:200)
dataN.Fm.100 <- subset(dataN.Fm.100, Generation %in% gens)

### 125 %
#### alphamn
dataN.alphamn.125 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-alphamn-1.25.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.alphamn.125) <- c("Replicate", "Generation", 1:200)
dataN.alphamn.125 <- subset(dataN.alphamn.125, Generation %in% gens)
#### alphanm
dataN.alphanm.125 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-alphanm-1.25.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.alphanm.125) <- c("Replicate", "Generation", 1:200)
dataN.alphanm.125 <- subset(dataN.alphanm.125, Generation %in% gens)
#### Fn
##### No comp
dataN.nocomp.Fn.125 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetnocomp-sensitivity-Fn-1.25.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.nocomp.Fn.125) <- c("Replicate", "Generation", 1:200)
dataN.nocomp.Fn.125 <- subset(dataN.nocomp.Fn.125, Generation %in% gens)
##### Comp
dataN.Fn.125 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-Fn-1.25.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.Fn.125) <- c("Replicate", "Generation", 1:200)
dataN.Fn.125 <- subset(dataN.Fn.125, Generation %in% gens)
#### Fm
dataN.Fm.125 <- read.csv("../geoff_bigfiles/dataN-simulate-long-wetcomp-sensitivity-Fm-1.25.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(dataN.Fm.125) <- c("Replicate", "Generation", 1:200)
dataN.Fm.125 <- subset(dataN.Fm.125, Generation %in% gens)

## alphamn
### 0
stor.alphamn.0 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.alphamn.0, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.alphamn.0 <- rbind(stor.alphamn.0, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.alphamn.0$Mean[stor.alphamn.0$Mean == 0] <- NA
### 75
stor.alphamn.75 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.alphamn.75, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.alphamn.75 <- rbind(stor.alphamn.75, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.alphamn.75$Mean[stor.alphamn.75$Mean == 0] <- NA
### 100
stor.alphamn.100 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.alphamn.100, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.alphamn.100 <- rbind(stor.alphamn.100, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.alphamn.100$Mean[stor.alphamn.100$Mean == 0] <- NA
### 125
stor.alphamn.125 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.alphamn.125, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.alphamn.125 <- rbind(stor.alphamn.125, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.alphamn.125$Mean[stor.alphamn.125$Mean == 0] <- NA

## alphanm
### 0
stor.alphanm.0 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.alphanm.0, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.alphanm.0 <- rbind(stor.alphanm.0, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.alphanm.0$Mean[stor.alphanm.0$Mean == 0] <- NA
### 75
stor.alphanm.75 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.alphanm.75, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.alphanm.75 <- rbind(stor.alphanm.75, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.alphanm.75$Mean[stor.alphanm.75$Mean == 0] <- NA
### 100
stor.alphanm.100 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.alphanm.100, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.alphanm.100 <- rbind(stor.alphanm.100, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.alphanm.100$Mean[stor.alphanm.100$Mean == 0] <- NA
### 125
stor.alphanm.125 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.alphanm.125, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.alphanm.125 <- rbind(stor.alphanm.125, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.alphanm.125$Mean[stor.alphanm.125$Mean == 0] <- NA

## Fn (NO COMP)
### 0
stor.nocomp.Fn.0 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.nocomp.Fn.0, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.nocomp.Fn.0 <- rbind(stor.nocomp.Fn.0, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.nocomp.Fn.0$Mean[stor.nocomp.Fn.0$Mean == 0] <- NA
### 75
stor.nocomp.Fn.75 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.nocomp.Fn.75, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.nocomp.Fn.75 <- rbind(stor.nocomp.Fn.75, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.nocomp.Fn.75$Mean[stor.nocomp.Fn.75$Mean == 0] <- NA
### 100
stor.nocomp.Fn.100 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.nocomp.Fn.100, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.nocomp.Fn.100 <- rbind(stor.nocomp.Fn.100, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.nocomp.Fn.100$Mean[stor.nocomp.Fn.100$Mean == 0] <- NA
### 125
stor.nocomp.Fn.125 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.nocomp.Fn.125, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.nocomp.Fn.125 <- rbind(stor.nocomp.Fn.125, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.nocomp.Fn.125$Mean[stor.nocomp.Fn.125$Mean == 0] <- NA
## Fn (COMP)
### 0
stor.Fn.0 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.Fn.0, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.Fn.0 <- rbind(stor.Fn.0, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.Fn.0$Mean[stor.Fn.0$Mean == 0] <- NA
### 75
stor.Fn.75 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.Fn.75, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.Fn.75 <- rbind(stor.Fn.75, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.Fn.75$Mean[stor.Fn.75$Mean == 0] <- NA
### 100
stor.Fn.100 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.Fn.100, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.Fn.100 <- rbind(stor.Fn.100, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.Fn.100$Mean[stor.Fn.100$Mean == 0] <- NA
### 125
stor.Fn.125 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.Fn.125, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.Fn.125 <- rbind(stor.Fn.125, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.Fn.125$Mean[stor.Fn.125$Mean == 0] <- NA

## Fm
### 0
stor.Fm.0 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.Fm.0, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.Fm.0 <- rbind(stor.Fm.0, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.Fm.0$Mean[stor.Fm.0$Mean == 0] <- NA
### 75
stor.Fm.75 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.Fm.75, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.Fm.75 <- rbind(stor.Fm.75, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.Fm.75$Mean[stor.Fm.75$Mean == 0] <- NA
### 100
stor.Fm.100 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.Fm.100, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.Fm.100 <- rbind(stor.Fm.100, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.Fm.100$Mean[stor.Fm.100$Mean == 0] <- NA
### 125
stor.Fm.125 <- data.frame()
for(i in 1:length(gens)){
    temp <- subset(dataN.Fm.125, Generation == gens[i])
    temp2 <- sapply(3:ncol(temp), FUN = function(X){
        c(mean(temp[, X]), quantile(temp[, X], prob = c(0.025))[[1]], quantile(temp[, X], prob = c(0.975))[[1]])
    })
    stor.Fm.125 <- rbind(stor.Fm.125, data.frame(Treatment = "Wet",
                                                 Generation = gens[i],
                                                 Patch = c(1:200),
                                                 Mean = t(temp2)[, 1],
                                                 Lower = t(temp2)[, 2],
                                                 Upper = t(temp2)[, 3]))
}
stor.Fm.125$Mean[stor.Fm.125$Mean == 0] <- NA

pdf(file = "Sensitivity-all.pdf", width = 16, height = 16)

## alphamn
par(mfcol = c(4, 4), mar = c(5, 5, 6, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("A"), "  0% ", italic(alpha)["mn"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.alphamn.0, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
for(i in 1:length(gens)){
    temp <- subset(stor.nocomp.Fn.100, Generation == gens[i])
    points(Mean ~ Patch, data = temp, col = rgb(34 / 255, 139 / 255, 34 / 255, alpha = .8), type = "l", lwd = 2, lty = "dashed")
}
legend("topright", adj = 0, c("No competition", "Competition"), bty = "n", pch = NA, col = c(rgb(34 / 255, 139 / 255, 34 / 255), rgb(51 / 255, 51 / 255, 51 / 255)), cex = 1, lwd = 2, lty = c("dashed", "solid"), inset = 0.05)
mtext(side = 3, expression(paste(bold("Resident competitive effect"))), adj = 0, padj = -1.8, cex = 1.5)
par(mar = c(5, 5, 2, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("E"), "  75% ", italic(alpha)["mn"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.alphamn.75, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("I"), "  100% ", italic(alpha)["mn"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.alphamn.100, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("M"), "  125% ", italic(alpha)["mn"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.alphamn.125, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}

## alphanm
par(mar = c(5, 5, 6, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("B"), "  0% ", italic(alpha)["nm"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.alphanm.0, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
for(i in 1:length(gens)){
    temp <- subset(stor.nocomp.Fn.100, Generation == gens[i])
    points(Mean ~ Patch, data = temp, col = rgb(34 / 255, 139 / 255, 34 / 255, alpha = .8), type = "l", lwd = 2, lty = "dashed")
}
legend("topright", adj = 0, c("No competition", "Competition"), bty = "n", pch = NA, col = c(rgb(34 / 255, 139 / 255, 34 / 255), rgb(51 / 255, 51 / 255, 51 / 255)), cex = 1, lwd = 2, lty = c("dashed", "solid"), inset = 0.05)
mtext(side = 3, expression(paste(bold("Invader competitive effect"))), adj = 0, padj = -1.8, cex = 1.5)
par(mar = c(5, 5, 2, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("F"), "  75% ", italic(alpha)["nm"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.alphanm.75, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("J"), "  100% ", italic(alpha)["nm"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.alphanm.100, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("N"), "  125% ", italic(alpha)["nm"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.alphanm.125, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}

## Fn
par(mar = c(5, 5, 6, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("C"), "  0% ", italic(G)["n"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.Fn.0, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
for(i in 1:length(gens)){
    temp <- subset(stor.nocomp.Fn.0, Generation == gens[i])
    points(Mean ~ Patch, data = temp, col = rgb(34 / 255, 139 / 255, 34 / 255, alpha = .8), type = "l", lwd = 2, lty = "dashed")
}
legend("topright", adj = 0, c("No competition", "Competition"), bty = "n", pch = NA, col = c(rgb(34 / 255, 139 / 255, 34 / 255), rgb(51 / 255, 51 / 255, 51 / 255)), cex = 1, lwd = 2, lty = c("dashed", "solid"), inset = 0.05)
mtext(side = 3, expression(paste(bold("Invader DD dispersal"))), adj = 0, padj = -1.8, cex = 1.5)
par(mar = c(5, 5, 2, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("G"), "  75% ", italic(G)["n"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.Fn.75, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
for(i in 1:length(gens)){
    temp <- subset(stor.nocomp.Fn.75, Generation == gens[i])
    points(Mean ~ Patch, data = temp, col = rgb(34 / 255, 139 / 255, 34 / 255, alpha = .8), type = "l", lwd = 2, lty = "dashed")
}
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("K"), "  100% ", italic(G)["n"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.Fn.100, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
for(i in 1:length(gens)){
    temp <- subset(stor.nocomp.Fn.100, Generation == gens[i])
    points(Mean ~ Patch, data = temp, col = rgb(34 / 255, 139 / 255, 34 / 255, alpha = .8), type = "l", lwd = 2, lty = "dashed")
}
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("O"), "  125% ", italic(G)["n"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.Fn.125, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
for(i in 1:length(gens)){
    temp <- subset(stor.nocomp.Fn.125, Generation == gens[i])
    points(Mean ~ Patch, data = temp, col = rgb(34 / 255, 139 / 255, 34 / 255, alpha = .8), type = "l", lwd = 2, lty = "dashed")
}

## Fm
par(mar = c(5, 5, 6, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("D"), "  0% ", italic(G)["m"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.Fm.0, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
for(i in 1:length(gens)){
    temp <- subset(stor.nocomp.Fn.100, Generation == gens[i])
    points(Mean ~ Patch, data = temp, col = rgb(34 / 255, 139 / 255, 34 / 255, alpha = .8), type = "l", lwd = 2, lty = "dashed")
}
legend("topright", adj = 0, c("No competition", "Competition"), bty = "n", pch = NA, col = c(rgb(34 / 255, 139 / 255, 34 / 255), rgb(51 / 255, 51 / 255, 51 / 255)), cex = 1, lwd = 2, lty = c("dashed", "solid"), inset = 0.05)
mtext(side = 3, expression(paste(bold("Resident DD dispersal"))), adj = 0, padj = -1.8, cex = 1.5)
par(mar = c(5, 5, 2, 1))
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("H"), "  75% ", italic(G)["m"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.Fm.75, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("L"), "  100% ", italic(G)["m"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.Fm.100, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}
plot(NA, xlim = c(1, 200), ylim = c(0, 250), ylab = "Abundance", xlab = "Patch number", bty = "n",
     xaxt = "n", yaxt = "n", cex.lab = 1.2)
axis(1, at = seq(1, 20, by = 19), tcl = -.5)
axis(1, at = seq(20, 200, by = 20), tcl = -.5)
axis(2, at = seq(0, 250, 50), tcl = -.5, las = 1, pos = -3)
mtext(side = 3, expression(paste(bold("P"), "  125% ", italic(G)["m"])), adj = 0, cex = 1)
for(i in 1:length(gens)){
    temp <- subset(stor.Fm.125, Generation == gens[i])
    print(i)
    points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
}

dev.off()

