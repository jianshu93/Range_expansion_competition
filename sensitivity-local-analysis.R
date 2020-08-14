# Calculate sensitivities from estimated exponents

# Exponents were first estimated using "sensitivity-local-exponents.R" run on
# the lab server and saved to "estimated_exponents.csv". We try a couple of
# different approaches to estimate sensitivity with improved precision.

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
# CV suggests best fit is sigma < 13 for all parameters.
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

# We can considerably reduce the Monte Carlo noise by smoothing the exponents
# first. We'll use the kernel smooth function we derived above.

# First compile smoothed exponents into a data frame. This will take 5 mins.
exponent_hats <- NULL
for ( p in c("alphamn","alphanm","Fm","Fn") ) {
    print(p)
    parvals <- seq(0.95,1.05,by=0.01) #need to match the simulation values
    for ( pv in parvals ) {
        tmp <- subset(exponents, par==p & parval == pv & 
                          gen > 4 & gen < 101 & !is.na(exponent))
        # Kernel smooth of inverse generation model
        x <- tmp$gen #we want to predict at each generation
        if ( p == "Fm" & pv == 0.95 ) { #this one needs more smoothing
            exponent_hat <- ksmooth(tmp,x,sigma=20) 
        } else {
            exponent_hat <- ksmooth(tmp,x,sigma=15)
        }
        n <- length(exponent_hat)
        this_set <- data.frame(par=rep(p,n),parval=rep(pv,n),exponent_hat=exponent_hat,gen=5:100)
        exponent_hats <- rbind(exponent_hats,this_set)
        rm(tmp,x,exponent_hat,n,this_set)
        print(pv)
    }
}
# save(exponent_hats,file="exponent_hats.RData")
# load("exponent_hats.RData")


# We see this has improved the noise and remains linear
# Check parameters one at a time
# require(ggplot2)
# require(dplyr)
# p <- unique(exponent_hats$par)[3]     #change 1 thru 4
# p
# exponent_hats %>%
#     filter(par==p, gen > 4, parval > 0.94, parval < 1.06) %>%
#     ggplot() +
#     geom_point(mapping = aes(x=parval,y=exponent_hat),shape=1) +
#     facet_wrap(facets = ~ gen,scales="free") +
#     theme(axis.text=element_blank(),axis.ticks=element_blank(),
#           panel.grid=element_blank())

# Figure 4
windows(6,6)
par(mar=c(4,4,0.2,0.2)) #square

# Set up colors (ggplot palette from scales package)
ggplotcols <- hue_pal(h = c(0, 360) + 15, c = 100, l = 65, h.start = 0, direction = 1)
parcols <- ggplotcols(4) #[c(3,1,2)]

# Plotting space
plot(NA,NA,xlim=c(-3,100),ylim=c(-1.25,0.5),type="n",axes=FALSE,ann=FALSE)
axis(1)
axis(2)
abline(h=0,col="gray")
box()
mtext("Generation",side=1,line=2.5)
mtext("Sensitivity of wave shape",side=2,line=2.5)

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
arrows(0,-0.2,0,-1,length=0.1)
text(-3, (-0.2 + -1)/2, "shallower",srt=90)
arrows(0,0.1,0,0.4,length=0.1)
text(-3, (0.1 + 0.4)/2, "steeper",srt=90)
