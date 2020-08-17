# Calculate sensitivities from estimated exponents

# Exponents were first estimated using "analysis-sensitivity-local-exponents.R" run on
# the lab server and saved to "estimated_exponents.csv". We try a couple of
# different approaches to estimate sensitivity with improved precision.

# Brett Melbourne
# 13 Aug 2020
#
library(viridis) #for color palette

# Read in estimated exponents
exponents <- read.csv("Data/estimated_exponents.csv",as.is=TRUE)
head(exponents)

# Split the label string
par_val <- strsplit(exponents$run,"-")
par_val <- data.frame(do.call("rbind",par_val),stringsAsFactors=FALSE)
colnames(par_val) <- c("par","val")
par_val$val <- as.numeric(par_val$val)
exponents <- cbind(par_val,exponents)

# tidy form (could use tidyr::gather but hey, it will soon break)
exponents <- cbind(exponents$par,exponents$val,stack(exponents[,-(1:3)]),stringsAsFactors=FALSE)
names(exponents) <- c("par","parval","exponent","gen")
exponents$gen <- as.numeric(sub("G","",exponents$gen))
head(exponents)
names(exponents)
unique(exponents$par)
unique(exponents$parval)

# Kernel smooth of inverse generation model
# df: data frame containing exponent and gen
# x: values to predict at
# sigma: window width for smoothing
#
ksmooth <- function( df, x, sigma ) {
    y <- x*NA
    starts <- list(a=0.07,b=1.7,c=1) # initial starting values
    for ( i in 1:length(x) ) {
        x0 <- x[i]
        w <- exp( -(abs(df$gen - x0)^2) / (2*sigma^2) ) #Gaussian kernel
        fit <- nls(exponent ~ a+b/(gen^c), start=starts, data=df, weights=w,
                   control=list(maxiter=10000,minFactor=1/(2^20),warnOnly=TRUE))
        starts <- list(a=coef(fit)[1],b=coef(fit)[2],c=coef(fit)[3])
        y[i] <- coef(fit)[1]+coef(fit)[2]/(x0^coef(fit)[3])
        rm(fit)
    }
    return(y)
}


# For the local sensitivity analysis, we can considerably reduce the Monte Carlo
# noise by smoothing the exponents first. We'll use the kernel smooth function
# we derived above. It will produce some warnings about not converging, but
# its estimates are good enough

# First compile smoothed exponents into a data frame. This will take 5 mins.
exponent_hats <- NULL
for ( p in c("alphamn","alphanm","Fm","Fn") ) {
    print(p)
    parvals <- seq(0.95,1.05,by=0.01) #needs to match the simulation values
    for ( pv in parvals ) {
        tmp <- subset(exponents, par==p & parval == pv & 
                          gen > 4 & gen < 101 & !is.na(exponent))
        # Kernel smooth of inverse generation model
        x <- tmp$gen #we want to predict at each generation
        exponent_hat <- ksmooth(tmp,x,sigma=15) 
        n <- length(exponent_hat)
        this_set <- data.frame(par=rep(p,n),parval=rep(pv,n),exponent_hat=exponent_hat,gen=5:100)
        exponent_hats <- rbind(exponent_hats,this_set)
        rm(tmp,x,exponent_hat,n,this_set)
        print(pv)
    }
}

pdf(file = "Figure 4.pdf", width = 6, height = 6)

par(mar=c(5, 5, .2, .2))

# Set up colors
parcols <- viridis(n = 4, begin = 0, end = .95)

# Plotting space
plot(NA, xlim=c(0,100), ylim=c(-1.5,0.5),
     xlab = "Generation", ylab = "Sensitivity of wave shape", xaxt = "n", yaxt = "n", bty = "n", cex.lab = 1.4)
axis(1, tcl = -.5)
axis(2, tcl = -.5, las = 1)
abline(h=0,col="black", lty = "dotted")

# Calculate and plot sensitivities
parnames <- c("alphamn","alphanm","Fm","Fn") #plotting order of parameters
for ( p in parnames ) {
    sensitivity <- rep(NA,100)
    for ( g in 5:100 ) {
        tmp <- subset(exponent_hats,par==p & gen == g & parval > 0.94 & parval < 1.06)
        tmp$exponent_hat <- tmp$exponent_hat/tmp$exponent_hat[tmp$parval==1]
        fit <- lm(exponent_hat~parval,data=tmp)
        sensitivity[g] <- coef(fit)["parval"]
    }
    lines(5:100,sensitivity[5:100],col=parcols[parnames==p],lwd=2)
}

# Data labels
lx <- 100
text(lx,0.45,expression(alpha[mn]),adj=1)
text(lx,0.14,expression(italic(G)[m]),adj=1)
text(lx,-0.96,expression(italic(G)[n]),adj=1)
text(lx,-1.25,expression(alpha[nm]),adj=1)

# Annotation
arrows(1.5,-0.1,1.5,-.5,length=0.1)
text(-1, (-0.1 + -.5)/2, "shallower",srt=90)
arrows(1.5,0.1,1.5,0.5,length=0.1)
text(-1, (0.1 + 0.5)/2, "steeper",srt=90)

dev.off()
