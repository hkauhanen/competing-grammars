# variational learner with penalty probabilities c1 and c2,
# initial state p0 and learning rate gamma, simulated for
# iter iterations
#
VL <- function(c1,
							 c2,
							 p0,
							 gamma,
							 iter) {
	p <- rep(p0, iter+1)
	p[1] <- p0

	for (t in 1:iter) {
		# the two grammars get punished with these probabilities, given that
		# the learner's current state is p[t]:
		punprob1 <- p[t]*c1 + (1-p[t])*(1-c2)
		punprob2 <- p[t]*(1-c1) + (1-p[t])*c2

		# sample event that occurs
		event <- sample(x=c("punish1", "punish2"), size=1, prob=c(punprob1, punprob2))

		# update state
		if (event == "punish2") {
			p[t+1] <- p[t] + gamma*(1 - p[t])
		} else if (event == "punish1") {
			p[t+1] <- p[t] - gamma*p[t]
		}
	}

	# return
	data.frame(t=0:iter, pt=p)
}


# simulate several VLs in the same environment
#
many_VLs <- function(c1,
										 c2,
										 p0,
										 gamma,
										 iter,
										 reps) {
	do.call(rbind, lapply(X=1:reps, FUN=function(X) { df <- VL(c1=c1, c2=c2, p0=p0, gamma=gamma, iter=iter); df$id <- X; df }))
}


# the mean dynamic of VL
#
mean_VL <- function(t,
										c1,
										c2,
										p0,
										gamma) {
	pt <- c2/(c1 + c2) - (1 - gamma*(c1 + c2))^t*(c2/(c1 + c2) - p0)
	data.frame(t=t, pt=pt)
}


