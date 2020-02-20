dispersal3 <- function(D, F, N, M, tt = 1, diffuse.model = diffuse, ...) {
    D.fouled <- D * exp(F * (N + M))
    out <- lsoda(N, c(0, tt), diffuse.model, parms = c(D = D.fouled))
    out[2, 2:ncol(out)]
}
