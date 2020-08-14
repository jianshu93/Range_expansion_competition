# Original code 2015 for moving habitat models in exponent_ratio.R. Similar to
# tail_exponent() in exponent_ratio.R but x can be arbitrary values instead of
# equal increments.
# Updated 25 Jul 2020:
# - removed smoothed versions 
# - removed plotting code and returned predictions
# - convential order for x and y arguments
# Updated 5 Aug 2020
# - fixed bug in zeros (weren't being removed)
# - fixed to only remove zeros ahead of occupied patches
# Brett Melbourne


# ---- fit_exponent() --------------------------------

# Fits the exponential model to the abundance data
# from the tail. The input data (y and x) should start at a location in the tail
# from which you want to calculate the negative exponent to the right. The fit
# uses nonlinear least squares with starting parameters from a log-linear fit.
# The nls fit is less biased compared to the log-linear fit, which emphasizes
# the data near zero (since large residuals occur as we get closer to zero).
# Since the data from deterministic model output have no error and the tails are
# exactly exponential for many theoretical situations, the base nls() function
# often fails because there is no error. We use nlsLM from minpack.lm instead,
# which uses a different algorithm (Levenberg-Marquardt).

# Arguments
# x         Vector of spatial positions for the ys
# y         Vector of abundances in the tail
# zincl     TRUE/FALSE whether to include/append zeros for fitting
# nzero     Number of zeroes to append to the tail
# thresh    Threshold abundance for identifying the tail and reducing the
#           weight of the first data point
# effective_zero    Any abundance less than this will be taken as zero
#
# Return (list)
# exp       Scalar, the estimated exponent
# ypred     Vector, the predicted ys

require(minpack.lm)


fit_exponent <- function(x,y,zincl=FALSE,nzero=5,thresh=FALSE,
                         effective_zero = .Machine$double.eps ) {
    
    # First zero the x axis
    # Not really necessary but standardizes the estimate of "a"
    x <- x - min(x)
    
    # Remove zeros from tail
    if ( any(y < effective_zero) ) {
        #notzeros <- 1:( min( which(y < effective_zero) ) - 1 )
        notzeros <- 1:max( which(y > effective_zero) )
        yy <- y[notzeros]
        xx <- x[notzeros]
    } else {
        yy <- y
        xx <- x
    }
    
    # Get starting values from linear fit on log scale
    fitpre <- lm(log(yy)~xx)
    
    # Add a standard number of zeros to the tail
    if ( zincl ) {
        yy <- c(yy,rep(0,nzero))
    }
    
    # Weights, adjusting the first point given the tail threshold
    if ( thresh ) {
        w <- rep(1,length(yy))
        d1 <- thresh - yy[1]
        d2 <- yy[1] - yy[2]
        w[1] <- min(d1/d2,1)
    }
    
    # Fit nonlinear exponential model to the tail
    if ( thresh ) {
        fit <- nlsLM(yy ~ exp( a + b * xx ),
                     start=list(a=fitpre$coef[1],b=fitpre$coef[2]),
                     weights=w)
    } else {
        fit <- nlsLM(yy ~ exp( a + b * xx ),
                     start=list(a=fitpre$coef[1],b=fitpre$coef[2]))
    }
   
    cf <- coef(fit)
    # Return
    if ( fit$convInfo$isConv == FALSE ) {
        return(list(exp=NA,ypred=NULL))
    } else {
        exp <- -cf[2]
        names(exp) <- NULL
        ypred <- exp( cf[1] + cf[2] * x )
        return(list(exp=exp,ypred=ypred))
    }
    
}
