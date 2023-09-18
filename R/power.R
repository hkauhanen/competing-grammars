# logistic function with slope s and intercept k
#
logistic <- function(t,
										 s,
										 k) {
	1/(1 + exp(-s*t + k))
}


# make a mock data set with two contexts, effect size ES and temporal
# resolution Tres
#
make_mock_data <- function(N,
													 ES,
													 Tres) {
	# sample size per context
	Npercontext <- ceiling(N/2)

	# sample size per data point
	Nperpoint <- ceiling(Npercontext/Tres)

	# time points
	times <- seq(from=-3, to=3, length.out=Tres)

	# data frames for the two contexts separately
	df1 <- expand.grid(t=times, context="con1", datapoint=1:Nperpoint, p=NA, success=NA)
	df2 <- expand.grid(t=times, context="con2", datapoint=1:Nperpoint, p=NA, success=NA)

	# their slopes and "successes" (the dependent variable, Bernoulli sampled)
	df1$p <- logistic(t=df2$t, s=1, k=0)
	df2$p <- logistic(t=df2$t, s=ES+1, k=-3*ES)
	df1$success <- unlist(lapply(X=df1$p, FUN=function(X) { sample(x=0:1, size=1, prob=c(1 - X, X)) }))
	df2$success <- unlist(lapply(X=df2$p, FUN=function(X) { sample(x=0:1, size=1, prob=c(1 - X, X)) }))

	# combine the two data frames and return
	rbind(df1, df2)
}


# carry out power analysis simulation for sample size N, temporal resolution
# Tres and effect size ES, with reps repetitions
#
simulate_power <- function(N,
													 Tres,
													 ES,
													 plevel,
													 reps) {
	do_this <- function() {
		data <- make_mock_data(N=N, ES=-ES, Tres=Tres)
		model <- glm(success~t*context, data, family=binomial)

		# p-value of the interaction
		ifelse(coef(summary(model))["t:contextcon2", "Pr(>|z|)"] < plevel, 1, 0)
	}

	sum(replicate(reps, do_this()))/reps
}


# power analysis simulation sweep across multiple combinations of N, ES and Tres
#
power_sweep <- function(N,
												ES,
												Tres,
												plevel = 0.05,
												reps,
												mc.cores) {
	params <- expand.grid(N=N, ES=ES, Tres=Tres)

	params$power <- parallel::mcmapply(FUN=simulate_power, N=params$N, ES=params$ES, Tres=params$Tres, MoreArgs=list(plevel=plevel, reps=reps), mc.cores=mc.cores)

	params
}


