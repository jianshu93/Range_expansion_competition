diffuse <- function(t, N, D) {
    np <- length(N)
    dN <- N * D  # Number dispersing per hole
    holes <- c(1, rep(2, (np - 2)), 1) # Number of holes
    dNfrR <- c(dN[2:np], 0)        # Number disperse from right
    dNfrL <- c(0, dN[1:(np - 1)])    # Number disperse from left
    list(dNfrR + dNfrL - holes * dN)
}
