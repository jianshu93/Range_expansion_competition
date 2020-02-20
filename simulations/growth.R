growth <- function(Nt, Mt, Rn, Rm, alphann, alphanm, alphamm, alphamn, KDn, KEm, thetam, ...){
    p <- 0.5 # sex ratio
    # Competitor N
    ifelse(Nt == 0, femalesNt <- 0, femalesNt <- rbinom(n = 1, size = Nt, prob = p))
    ifelse(femalesNt == 0, birthsN <- 0, birthsN <- rnbinom(n = 1, size = KDn * femalesNt, mu = Rn * femalesNt))
    survivorsN <- rbinom(n = 1, birthsN, exp(-alphann * Nt + -alphanm * Mt))
    # Competitor M
    ifelse(Mt == 0, femalesMt <- 0, femalesMt <- rbinom(n = 1, size = Mt, prob = p))
    ifelse(femalesMt == 0, birthsM <- 0, birthsM <- rnbinom(n = 1, size = KEm, mu = Rm * femalesMt * ((Mt - femalesMt) / (thetam + (Mt - femalesMt)))))
    survivorsM <- rbinom(n = 1, birthsM, exp(-alphamm * Mt + -alphamn * Nt))
    # Bring together
    c(survivorsN, survivorsM)
}
