nll.dispersal <- function(param, N.before, N.after, kernel, pmf, diffuse.model, pos){
    pos.regex <- paste(pos, collapse = "|") # collapse "pos" to regex
    pos.tr <- grep(pos.regex, names(param)) # parameters to transform
    param.tr <- replace(param, pos.tr, exp(unlist(param[pos.tr]))) # transform (exp)
    param1 <- param.tr
    likestor <- dim(nrow(N.after))
    for(i in 1:nrow(N.after)){
        kernel.temp <- do.call(kernel, append(param1, list(N = N.before[i, ], diffuse.model = diffuse.model)))
        if(length(which(kernel.temp <= 0)) > 0){
            likestor[i] <- -10000 # punish negative probabilities
        } else{
            if(pmf == "dmultinom"){
                param.temp <- list(x = N.after[i, ], size = sum(N.after[i, ]), prob = kernel.temp, log = TRUE)
            }
            likestor[i] <- do.call(pmf, param.temp)
        }
    }
    -sum(likestor)
}
