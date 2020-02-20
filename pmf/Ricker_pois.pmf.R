Ricker_pois.pmf <- function(Xt, Xtp1, Yt, Rx, alphaxx, alphaxy, ...){
    if(isTRUE(any(is.na(c(Xt, Xtp1, Yt)))) || Xt == 0 & Xtp1 == 0){
        1
    } else{
        if(Xt == 0 & Xtp1 > 0){
            0
        } else{    
            lambdaX <- Xt * Rx * exp(-(alphaxx * Xt + alphaxy * Yt))
            dpois(Xtp1, lambdaX, log = FALSE)
        }
    }
}
