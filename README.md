# competing-grammars

This repository contains R code required to reproduce the results contained in the following paper:

> Wallenberg, J. C., Kauhanen, H., Walkden, G. & Heycock, C. (in prep.) Grammar competition and variational learning. In *The Wiley–Blackwell Companion to Diachronic Linguistics*.


## Prerequisites

We assume all code is run inside the `R/` directory (tested on R version 4.2.2 Patched). Plots are saved in `out/`. To begin, please install/load the following prerequisites:

```r
# dependencies
require(ggplot2)
require(gridExtra)

# load routines
source("plots.R")
source("power.R")
source("VL.R")
```

## Variational learning

To simulate variational learning and produce the plot, issue the following commands.

```r
# set PRNG seed for reproducibility
set.seed(2023)

# simulate
VLresult <- many_VLs(c1=0.1, c2=0.5, p0=0.5, gamma=0.01, iter=1000, reps=5)
meandynamic <- mean_VL(t=0:1000, c1=0.1, c2=0.5, p0=0.5, gamma=0.01)

# plot
pdf("../out/Figure1.pdf", height=4, width=6)
print(plot_VL(VLresult, meandynamic))
dev.off()
```


## The Constant Rate Effect

To produce the constant and inconstant rates figure:

```r
pdf("../out/Figure2.pdf", height=2.5, width=6)
print(plot_CRE())
dev.off()
```

To reproduce the Constant Rate Effect Monte Carlo power analysis, run the following. The routines are automatically parallelized across available processor cores if the code is run on Linux or Mac; adjust `mc.cores` for the number of cores as necessary. Please note that this takes a while (on the order of 10 minutes if run on a modest laptop).

We also save the results of the power analysis in `out/CREresult.RData`.

```r
# number of processor cores (adjust as necessary)
mc.cores <- 2

# logarithmically spaced sequence of sample sizes
N <- floor(exp(seq(from=log(100), to=log(100000), length.out=10)))

# power analysis
CREresult <- power_sweep(N=N, Tres=4, ES=c(0.01, 0.05, 0.1, 0.2), plevel=0.05, reps=100, mc.cores=mc.cores)
save(CREresult, file="../out/CREresult.RData")

# plot
pdf("../out/Figure3.pdf", height=3, width=6)
print(plot_power(CREresult))
dev.off()
```


## Acknowledgement

This project has received funding from the European Research Council (ERC) under the European Union's Horizon 2020 research and innovation programme (grant agreement n° 851423).
