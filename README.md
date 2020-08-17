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

### analysis-simulations-short, results-validation.R

These scripts simulate the spatiotemporal model (i.e., combination of fitted growth and dispersal models) and compare its predictions across 8 generations to the independent experimental data. They can be used to recreate Figs. S5, S6.

### analysis-bootstrap-growth, analysis-bootstrap-dispersal

These scripts use bootstrapping to estimate uncertainty in the estimates of the best-fitting growth and dispersal models.

### analysis-simulations-long.R, analysis-simulations-long-sensitivity-alphanm.R

These scripts simulate the spatiotemporal models in large 200-patch landscapes for 100 generations. The sensitivity script can be modified to examine the sensitivity of any parameter in the model (i.e., not just alpha_nm) across a range of values (see object `prop.range`). Note that the files created by these scripts are fairly large: 400-700 MB for each parameter set.

### analysis-sensitivity-wave.R

This script uses function ("fit_exponential.R") to fit an exponential model to the front of the expanding wave. It requires simulation data that can be generated using analysis-simulations-long-sensitivity-alphanm.R (which itself can be extended to examine the effect of other parameters). 

### results-figure1.R

This script visualizes mean abundance over time for the experimental landscapes. It can be used to recreate Figure 1 in the main text.

### results-figure2.R

This script compares abundances predicted by the fitted model with abundances in the experimental landscapes. It can be used to recreate Figure 2 in the main text.

### results-figure3.R

This script visualizes mean abundance over time for the long-term (100 generations) simulations. It requires that this data exist in folder /Data and can be used to recreate Figure 3 in the main text.

### results-figure4.R

This script visualizes the sensitivity of the shape of the expanding wave over time, with respect to four parameters (both alphas and Gs). It depends on estimated exponents in the folder /Data and can be used to recreate Figure 4 in the main text.

### results-fit-growth, results-fit-dispersal

These scripts create 3D plots to visualize the fit of the growth and dispersal models with the lowest AIC. They can be used to recreate Figs. S3, S4.

### results-bootstrap-growth, results-bootstrap-dispersal

These scripts visualize the uncertainty in the parameter estimates of the best-fitting growth and dispersal models. They can be used to recreate Figs. S7, S8.

### results-figure-sensitivity-all.R

This script visualizes how range expansion is impacted by varying different parameters. It requires simulation data that can be generated using analysis-simulations-long-sensitivity-alphanm.R and extensions of it for parameters alphamn, Gn, and Gm. It can be used to recreate Fig. S9.

## results-figure-sensitivity-wave.R

This script visualizes the fit of the exponential model to the front of the expanding wave. It can be used to recreate Fig. S10.

### results-figure-sensitivity-wave2.R

This script visualizes the sensitivity of the shape of the expanding wave over time, with respect to four parameters (both alphas and Gs). It covers a wider range of values (75-125%) than Fig. 4. It can be used to recreate Fig. S11.
