
# Source negative log-likelihood function (to be optimized)
source("nll-growth.R")
# Source probability mass functions
source("pmf/Ricker_nbinomD_binom.pmf.R") # T castaneum
source("pmf/Ricker_nbinomE_allee_binom.pmf.R") # T confusum

# Initial parameter estimates (previous studies)
param.wet <- list(
    Rn = 1.52,
    Rm = 2.01,
    alphann = 0.0041,
    alphamm = 0.0046,
    alphanm = 0.004,
    alphamn = 0.004,
    KDn = -1.62,
    KEm = 2.09,
    thetam = log(20)
    )

# Parameter values that must be positive
positives <- c("Rn", "Rm", "KDn", "KEm", "thetam")

# Read growth data
dataN.wet <- read.csv("Data/dataN-growth-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]
dataM.wet <- read.csv("Data/dataM-growth-wet.csv", header = TRUE, stringsAsFactors = FALSE)[, -1]

# Run optimizer
fit <- optim(par = param.wet,
                 fn = nll.growth,
                 N = dataN.wet,
                 M = dataM.wet,
                 pmf1 = Ricker_nbinomD_binom.pmf,
                 pmf2 = Ricker_nbinomE_allee_binom.pmf,
                 pos = positives,
                 method = c("Nelder-Mead"),
                 control = list(maxit = 10000, trace = 1, parscale = c(abs(as.numeric(param.wet)))))
estimates <- cbind(data.frame(Environment = c("Wet"),
                              Modeln = "Ricker_nbinomD_binom",
                              Modelm = "Ricker_nbinomE_allee_binom",
                              Parameters = length(fit$par),
                              negloglike = fit$value,
                              converge = fit$convergence, stringsAsFactors = FALSE),
                   t(as.data.frame(fit$par)))

# Calculate AIC
estimates$AIC <- (2 * estimates$Parameters) + (2 * estimates$negloglike)

# Undo log transform
estimates$Rn <- exp(estimates$Rn)
estimates$Rm <- exp(estimates$Rm)
estimates$thetam <- exp(estimates$thetam)
estimates$KDn <- exp(estimates$KDn)
estimates$KEm <- exp(estimates$KEm)

# Show work
estimates
