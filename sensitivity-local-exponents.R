# Calculates exponents for an exponential approximation to the wave front.
# For T. castaneum
# Code extended from "sensitivity-local-EDA.R".
# First copy all the data files into a directory (with no other files).

# Outputs a csv file containing all the exponents, and produces separate pdfs
# of the fits for each parameter value.

# Brett Melbourne
# 2 Aug 2020

source("fit_exponent.R")

# Options
ylim <- c(0,50)  #ylims for plots: c(0,50) for zoomed in, or c(0,250)
gens <- 2:100    #generations to process and save data for
gens2plot <- c(2:5,seq(10,100,10)) #which generations to plot (must be subset of gens)
dirpath <- "/mnt/md0raid1_2tb/geoff_bigfiles/localsensitivity/"  #put directory path here

# Get the names of the saved simulation output files
fnames <- list.files(dirpath)
print(fnames)

# Set up storage for exponents
exponent_store <- NULL
labels_store <- NULL

# Process each file
for ( f in fnames ) {
    fpath <- paste(dirpath,f,sep="")
    dataN <- read.csv(fpath, header = FALSE, stringsAsFactors = FALSE)
    colnames(dataN) <- c("Replicate", "Generation", 1:200)
    unique(dataN$Generation)
    head(dataN)
    
    # Calculate means (code not changed from Geoff's)
    stor <- data.frame()
    for ( g in gens ) {
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
    
    
    # Plot model output
    dataID <- sub("dataN-simulate-long-wetcomp-sensitivity-","",f) #delete string
    dataID <- sub("local-","",dataID) #delete string if present
    dataID <- sub(".csv","",dataID) #delete string
    print(dataID)
    
    pdf(file = paste(dataID,".pdf",sep=""),width=11,height=8.5)
    plot(NA, xlim = c(1, 200), ylim = ylim, ylab = "Abundance", xlab = "Patch number", bty = "n",
         xaxt = "n", yaxt = "n", cex.lab = 1.2, 
         main=paste(dataID,"generation 2-5, 10-100 by 10"))
    axis(1, at = seq(1, 20, by = 19), tcl = -.5)
    axis(1, at = seq(20, 200, by = 20), tcl = -.5)
    axis(2, at = seq(0, 250, 10), tcl = -.5, las = 1, pos = -3)
    for ( g in gens2plot ) {
        temp <- subset(stor, Generation == g)
        points(Mean ~ Patch, data = temp, col = rgb(51 / 255, 51 / 255, 51 / 255, alpha = .8), type = "l", lwd = 2)
    }
    
    # Calculate exponents for right hand tail of wave (abundance < upper threshold)
    # Abundance thresholds control the range of data used in the model fits
    # Note exceptions in the if statements at the start
    up_abun <- 20 #upper threshold for abundance
    lo_abun <- 0 #lower threshold for abundance
    exponents <- rep(NA,length(gens))
    for ( i in 1:length(gens) ) {
        if ( dataID == "alphanm-0" & gens[i] > 50 ) break  #hits end after 50 generations
        if ( dataID == "alphanm-0.75" & gens[i] > 80 ) break  #hits end after 80 generations
        if ( dataID == "alphamn-0" ) up_abun <- 10           #has reduced carrying capacity
        if ( f == "dataN-simulate-long-wetnocomp-sensitivity-Fn-1.5" & gens[i] > 90 ) break #hits end after 90 generations
        taildata <- subset(stor, (Generation == gens[i]) & (Mean < up_abun) & (Mean > lo_abun) )
        expfit <- fit_exponent(x=taildata$Patch,y=taildata$Mean)
        if ( gens[i] %in% gens2plot ) {
            lines(taildata$Patch,expfit$ypred,col="red",lty=2)
        }
        exponents[i] <- expfit$exp
    }
    exponents
    legend("topright",col=1:2,lty=1:2,legend=c("simulation mean","fitted exponential"))
    
    dev.off()
    
    exponent_store <- rbind(exponent_store,exponents,deparse.level=0)
    labels_store <- c(labels_store,dataID)

}

exponent_store <- as.data.frame(exponent_store)
out <- cbind(labels_store,exponent_store)
colnames(out) <- c("run",paste("G",gens,sep=""))
write.csv(out,file="estimated_exponents.csv",row.names=FALSE)
