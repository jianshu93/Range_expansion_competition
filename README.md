# Range expansion with interspecific competition

This repository contains R scripts associated with the paper:

Interspecific competition slows range expansion and shapes range boundaries

The main purpose of these scripts is to allow users to reproduce the analysis and figures from the paper.

## Files (following order in the analysis)

### analysis-fit-growth

This script fits stochastic growth models to data from the single-patch replicates. It calls a general purpose likelihood function ("nll-growth.R") and optimizes every combination of 16 probability mass functions (folder /pmf). 

It is strongly recommended that users run this code on a machine with multiple cores. They should also expect long run times (>12 hours) for the more complex stochastic models (e.g., nbinomgammabinom).

### analysis-fit-dispersal

This script fits stochastic dispersal models to data from the first generation of the expansion experiment. It calls a general purpose likelihood function ("nll-dispersal.R") and optimizes 2 dispersal models (folder /disp). 

### results-fit-growth, results-fit-dispersal

These scripts create 3D plots to visualize the fit of the growth and dispersal models with the lowest AIC. They can be used to recreate Figs. S3, S4.

### analysis-simulations-short, results-validation.R

These scripts simulate the spatiotemporal model (i.e., combination of fitted growth and dispersal models) and compare its predictions across 8 generations to the independent experimental data. They can be used to recreate Figs. S5, S6.

### analysis-bootstrap-growth, analysis-bootstrap-dispersal

These scripts use bootstrapping to estimate uncertainty in the estimates of the best-fitting growth and dispersal models.

### results-bootstrap-growth, results-bootstrap-dispersal

These scripts visualize the uncertainty in the parameter estimates of the best-fitting growth and dispersal models. They can be used to recreate Figs. S7, S8.

### analysis-simulations-long.R

This script simulates the spatiotemporal models in large 200-patch landscapes for 100 generations.

### results-figure1.R

This script visualizes mean abundance over time for the experimental landscapes. It can be used to recreate Figure 1 in the main text.

### results-figure2.R

This script visualizes mean abundance over time for the long-term (100 generations) simulations. It requires that this data exist in folder /Data and can be used to recreate Figure 2 in the main text.
