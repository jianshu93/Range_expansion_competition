# Calculate sensitivities from estimated exponents

# Exponents were first estimated using "analysis-sensitivity-wave.R" run on
# the lab server and saved to "estimated_exponents.csv".

# Brett Melbourne
# 13 Aug 2020
#
library(scales) #for color palette

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
# for single combination of parameter and parameter value
p <- unique(exponents$par)[2] #parameter
pv <- 1 #parameter value
tmp <- subset(exponents,par==p & parval == pv & gen > 5 & gen < 101)
plot(NA,NA,xlim=c(0,100),ylim=c(0,0.5),type="n",
     xlab="Generation",
     ylab="Exponent",
     main=paste(p,"Value =",pv))
with(tmp,points(gen,exponent))

sigma <- 15 #window width for smoothing
x <- seq(min(tmp$gen),max(tmp$gen),length.out=200) #use for interpolated curve
#x <- tmp$gen #use for data points: y_hat
y <- x*NA
c_hat <- x*NA
for ( i in 1:length(x) ) {
    x0 <- x[i]
    w <- exp( -(abs(tmp$gen - x0)^2) / (2*sigma^2) )
    fit <- nls(exponent ~ a+b/(gen^c), start=list(a=0.07,b=1.7,c=1), data=tmp, weights=w,
               control=list(maxiter=10000,minFactor=1/(2^20),warnOnly=TRUE))
    y[i] <- coef(fit)[1]+coef(fit)[2]/(x0^coef(fit)[3])
    c_hat[i] <- coef(fit)[3]
}
lines(x,y,col="red")
#interesting to also plot the c estimates
plot(x,c_hat)


# Cross validation for best value of sigma
# We use leave one out CV because we are most interested in minimizing bias. CV
# for this smooth is neat computationally because we leave out the data point we
# want to predict and then we predict for it, and only it, saving a lot of
# computation.
# CV suggests best fit is sigma < 13 for all parameters but we'll take it just
# slightly wider at sigma = 15 to improve stability of the fit and make it a
# little smoother.
p = unique(exponents$par)[3] #parameter
pv <- 0.95 #parameter value
tmp <- subset(exponents,par==p & parval == pv & gen > 5 & gen < 101)

sigma <- seq(12,15,by=0.1) #grid for sigma
rms <- rep(NA,length(sigma))
for ( i in 1:length(sigma) ) {
    print(sigma[i]) #monitoring
    n <- length(tmp$gen)
    dsq <- rep(NA,n)
    for ( j in 1:n ) {
        x0 <- tmp$gen[j]
        w <- exp( -(abs(tmp$gen[-j] - x0)^2) / (2*sigma[i]^2) )
        fit <- nls(exponent ~ a+b/(gen^c), start=list(a=0.07,b=1.7,c=1), data=tmp[-j,], weights=w,
                   control=list(maxiter=10000,minFactor=1/(2^20),warnOnly=TRUE))
        y <- coef(fit)[1]+coef(fit)[2]/(x0^coef(fit)[3])
        dsq[j] <- ( y - tmp$exponent[j] )^2
    }
    rms[i] <- sum(dsq/n)
}
plot(sigma,rms,main=paste(p,"value =",pv))
#plot(tmp$gen,sqrt(dsq)) to inspect prediction error for a single sigma value

# ---- Having investigated the kernel smooth, here's a function for it.
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


# ---- Figure S11
# 4 panel plot of shape exponent versus generation with smoothed inverse generation model
pdf(file = "Figure S11.pdf", width = 12, height = 9)

op <- par(mfrow=c(2,2),mar=c(5, 5, 2, 2))
# Set up colors
parvals <- c(0.75,1.25,1) #plotting order for parameter values
ggplotcols <- hue_pal(h = c(0, 360) + 15, c = 100, l = 65, h.start = 0, direction = 1)
pvcols <- ggplotcols(length(parvals))[c(3,1,2)]
pvcols[3] <- "black"
# Plot exponents and fit smoothed curve
parnames <- c("alphamn","alphanm","Fn","Fm") #plotting order of parameters
parexp <- c(expression(alpha[mn]),expression(alpha[nm]),expression(italic(G)[n]),expression(italic(G)[m]))

for ( p in parnames ) {    
    plot(NA,NA,xlim=c(0,100),ylim=c(0,0.5), bty = "n", xaxt = "n", yaxt = "n", xlab = "Generation", ylab = expression("Wave shape, " * italic(b)))
    # Axes
    axis(1)
    axis(2, las = 1)
    # Steepness annotation
    if ( p %in% parnames[1] ) {
        # Annotation
        arrows(100,0.15,100,0.4,length=0.1)
        text(100-3, (0.15 + 0.4)/2, "steeper",srt=90)
    }
    # Legend
    if ( p %in% parnames[1] ) {
        legend("topright",legend=paste(parvals*100,"%",sep="")[c(1,3,2)],
               lty=1,pch=1,col=pvcols[c(1,3,2)],bty="n")
    }
    # Data and smooth curve
    for ( pv in parvals ) {
        tmp <- subset(exponents, par==p & parval == pv & 
                          gen > 5 & gen < 101 & !is.na(exponent))
        with(tmp,points(gen,exponent,col=pvcols[parvals==pv]))
    # Smooth of inverse generation model
        x <- seq(min(tmp$gen),max(tmp$gen),length.out=200)
        y <- ksmooth( df=tmp, x, sigma = 15)
        lines(x,y,col=pvcols[parvals==pv])
    }
    # Plot label
    print(p)
    if( p %in% parnames[1] ){
        mtext(side = 3, expression(paste(bold("A"), "  ", italic(alpha)["mn"])), adj=0 )
    }
    if( p %in% parnames[2] ){
        mtext(side = 3, expression(paste(bold("B"), "  ", italic(alpha)["nm"])), adj=0 )
    }
    if( p %in% parnames[3] ){
        mtext(side = 3, expression(paste(bold("C"), "  ", italic(G)["n"])), adj=0 )
    }
    if( p %in% parnames[4] ){
        mtext(side = 3, expression(paste(bold("D"), "  ", italic(G)["m"])), adj=0 )
    }
    else {}
}
mtext("Generation",side=1,line=1,outer=TRUE)
mtext(expression( "Wave shape, " * italic(b) ),side=2,line=1,outer=TRUE)

dev.off()
