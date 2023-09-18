plot_VL <- function(results,
										meandynamic) {
	g <- ggplot(results, aes(x=t, y=pt, group=id)) + geom_path(alpha=0.30) + ylim(0.5,1) + theme_bw() + theme(axis.text=element_text(color="black")) + xlab(expression("Learning iteration"~italic(t))) + ylab(expression("Weight of"~italic(G)[1]*","~italic(p)[italic(t)]))
	g <- g + geom_path(data=meandynamic, lwd=0.8, inherit.aes=FALSE, aes(x=t, y=pt))
	g
}


plot_CRE <- function() {
	times <- seq(from=-5, to=5, length.out=100)

	cre1 <- data.frame(t=times, p=logistic(t=times, s=1, k=-1), context="context 1")
	cre2 <- data.frame(t=times, p=logistic(t=times, s=1, k=1), context="context 2")
	cre <- rbind(cre1, cre2)

	vre1 <- data.frame(t=times, p=logistic(t=times, s=1.2, k=-1), context="context 1")
	vre2 <- data.frame(t=times, p=logistic(t=times, s=0.8, k=1), context="context 2")
	vre <- rbind(vre1, vre2)

	g_cre <- ggplot(cre, aes(x=t, y=p, lty=context)) + geom_path() + ylim(0,1) + theme_bw() + ylab("Frequency") + xlab("Time") + scale_x_continuous(labels=NULL) + labs(lty="") + theme(axis.text=element_text(color="black"), panel.grid.minor=element_blank(), legend.position="none", plot.margin = unit(c(0,0.5,0,0)+0.5, "cm")) + ggtitle("(a)")
	g_vre <- ggplot(vre, aes(x=t, y=p, lty=context)) + geom_path() + ylim(0,1) + theme_bw() + ylab("Frequency") + xlab("Time") + scale_x_continuous(labels=NULL) + labs(lty="") + theme(axis.text=element_text(color="black"), panel.grid.minor=element_blank(), legend.position="none", plot.margin = unit(c(0,0,0,0.5)+0.5, "cm")) + ggtitle("(b)")

	grid.arrange(g_cre, g_vre, nrow=1)
}


plot_power <- function(results) {
	results$ES <- factor(results$ES, levels=c("0.2", "0.1", "0.05", "0.01"))
	ggplot(results, aes(x=N, y=power, lty=ES)) + geom_path() + geom_point() + theme_bw() + scale_x_log10(labels=scales::comma) + ylim(0,1) + annotation_logticks(sides="b") + xlab(expression("Sample size"~italic(N))) + ylab(expression("Power"~1-beta)) + theme(axis.text=element_text(color="black")) + labs(lty=expression("Effect size"~italic(E)))
}

