simulate.landscape <- function(N, M, param, growth, dispN, dispM){
    npatch <- length(N)
    landscape.cast <- N
    landscape.conf <- M
    for(j in 1:npatch){
        # Growth phase
        temp <- do.call(growth, append(param, list(Nt = landscape.cast[j],
                                                   Mt = landscape.conf[j])))
        landscape.cast[j] <- temp[1]
        landscape.conf[j] <- temp[2]
    }
    # Dispersal phase
    ## Drop subscripts for compatibility with disperse
    param1 <- param # species 1
    names(param1) <- gsub("n", "", names(param1))
    ## Drop subscripts for compatibility with disperse
    param2 <- param # species 2
    names(param2) <- gsub("m", "", names(param2))
    ## Calculate dispersal kernel
    kernel.cast <- do.call(dispN, append(param1, list(N = landscape.cast, M = landscape.conf)))
    kernel.conf <- do.call(dispM, append(param2, list(N = landscape.conf, M = landscape.cast)))
    ## Set negative values to 0 (numerical overflow)
    kernel.cast[kernel.cast < 0] <- 0
    kernel.conf[kernel.conf < 0] <- 0
    ## Dispersal occurs if there are any non-zero probabilities of dispersal
    if(sum(landscape.cast) > 0){
        landscape.cast <- rmultinom(n = 1, size = sum(landscape.cast), prob = kernel.cast)
    } else{}
    if(sum(landscape.conf) > 0){
        landscape.conf <- rmultinom(n = 1, size = sum(landscape.conf), prob = kernel.conf)
    } else{}
    return(list(N = c(landscape.cast), M = c(landscape.conf)))
}
