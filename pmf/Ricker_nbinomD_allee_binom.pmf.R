Ricker_nbinomD_allee_binom.pmf <- function(Xt, Xtp1, Yt, Rx, alphaxx, alphaxy, KDx, thetax, ...){
    z <- 0.5 # probability of being female
    if(isTRUE(any(is.na(c(Xt, Xtp1, Yt)))) || Xt == 0 & Xtp1 == 0){
        1
    } else{
        if(Xt == 0 & Xtp1 > 0 | Xt < 2 & Xtp1 > 0){
            0
        } else{
            if(Xtp1 > 0){
                f_X <- 1:(Xt - 1)
                lambdaX <- f_X * Rx * ((Xt - f_X) / (thetax + (Xt - f_X))) * exp(-(alphaxx * Xt + alphaxy * Yt))
                sum(exp(dbinom(f_X, Xt, z, log = TRUE) + dnbinom(Xtp1, size = KDx * f_X, mu = lambdaX, log = TRUE)))
            } else{
                f_X <- 0:Xt
                lambdaX <- f_X * Rx * ((Xt - f_X) / (thetax + (Xt - f_X))) * exp(-(alphaxx * Xt + alphaxy * Yt))
                sum(exp(dbinom(f_X, Xt, z, log = TRUE) + dnbinom(Xtp1, size = KDx * f_X, mu = lambdaX, log = TRUE)))
            }
        }
    }
}
