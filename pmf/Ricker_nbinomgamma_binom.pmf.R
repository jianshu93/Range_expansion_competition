Ricker_nbinomgamma_binom.pmf <- function(Xt, Xtp1, Yt, Rx, alphaxx, alphaxy, KDx, KEx, ...){
    if(isTRUE(any(is.na(c(Xt, Xtp1, Yt)))) || Xt == 0 & Xtp1 == 0){
        1
    } else{
        if(Xt == 0 & Xtp1 > 0 | Xt < 2 & Xtp1 > 0){
            0
        } else{
            tryCatch(integrate(Vectorize(function(xx, Xt, Xtp1, Yt, Rx, alphaxx, alphaxy, KDx, KEx){
                exp(dgamma(xx, shape = KEx, scale = Rx / KEx, log = TRUE) + log(Ricker_nbinomD_binom.pmf(Xt, Xtp1, Yt, xx, alphaxx, alphaxy, KDx)))}),
                Xt = Xt,
                Xtp1 = Xtp1,
                Yt = Yt,
                Rx = Rx,
                alphaxx = alphaxx,
                alphaxy = alphaxy,
                KDx = KDx,
                KEx = KEx,
                lower = 0, upper = Inf, rel.tol = 1e-8)$value,
                error = function(e) return(0))
        }
    }
}



    
