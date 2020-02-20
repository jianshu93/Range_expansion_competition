Ricker_pois_allee_binom.pmf <- function(Xt, Xtp1, Yt, Rx, alphaxx, alphaxy, thetax, ...){
    z <- 0.5 # probability of being female
    if(isTRUE(any(is.na(c(Xt, Xtp1, Yt)))) || Xt == 0 & Xtp1 == 0){
        1
    } else{
        if(Xt == 0 & Xtp1 > 0 | Xt < 2 & Xtp1 > 0){
            0
        } else{
            if(Xtp1 > 0){
                f_X <- 1:(Xt - 1) # vector of possible females
                sum(exp(dbinom(f_X, Xt, z, log = TRUE) + dpois(Xtp1, f_X * Rx * ((Xt - f_X) / (thetax + (Xt - f_X))) * exp(-(alphaxx * Xt + alphaxy * Yt)), log = TRUE)))
            } else{
                f_X <- 0:Xt # vector of possible females
                sum(exp(dbinom(f_X, Xt, z, log = TRUE) + dpois(Xtp1, f_X * Rx * ((Xt - f_X) / (thetax + (Xt - f_X))) * exp(-(alphaxx * Xt + alphaxy * Yt)), log = TRUE)))
            }
        }
    }
}
