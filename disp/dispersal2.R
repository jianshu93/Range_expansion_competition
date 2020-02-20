dispersal2 <- function(D, F, N, tt = 1, diffuse.model = diffuse, ...) {
    D.fouled <- D * exp(F * N)
    out <- lsoda(N, c(0, tt), diffuse.model, parms = c(D = D.fouled))
    out[2, 2:ncol(out)]
}
