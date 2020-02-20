nll.growth <- function(param, N, M, pmf1, pmf2, pos){
    pos.regex <- paste(pos, collapse = "|") # collapse "pos" to regex
    pos.tr <- grep(pos.regex, names(param)) # parameters to transform
    param.tr <- replace(param, pos.tr, exp(unlist(param[pos.tr]))) # transform (exp)
    param1 <- param.tr # species 1
    names(param1) <- gsub("n", "x", names(param1))
    names(param1) <- gsub("m", "y", names(param1))
    param2 <- param.tr # species 2
    names(param2) <- gsub("m", "x", names(param2))
    names(param2) <- gsub("n", "y", names(param2))
    ntime <- ncol(N) - 1 # Number of time steps after the first
    likestor1 <- dim(ntime) # For storing likelihoods
    for(i in 1:ntime){
        species1 <- list(Xt = N[, i], Xtp1 = N[, i + 1], Yt = M[, i])
        probN <- sapply(1:nrow(N), FUN = function(j) {
            log(do.call(pmf1, append(lapply(species1, "[[", j), param1)))
        })
        species2 <- list(Xt = M[, i], Xtp1 = M[, i + 1], Yt = N[, i])
        probM <- sapply(1:nrow(M), FUN = function(j) {
            log(do.call(pmf2, append(lapply(species2, "[[", j), param2)))
        })       
        sum.temp <- probN + probM
        sum.temp[is.infinite(sum.temp)] <- -10000 # Punish 0 likelihoods
        likestor1[i] <- sum(sum.temp)
    }
    return(-sum(likestor1))
}
