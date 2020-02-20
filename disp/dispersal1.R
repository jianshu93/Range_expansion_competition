dispersal1 <- function(D, N, tt = 1, diffuse.model = diffuse, ...) {
    out <- lsoda(N, c(0, tt), diffuse.model, parms = c(D = D))
    out[2, 2:ncol(out)]
}
