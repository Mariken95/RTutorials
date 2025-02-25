## Introduction to Likelihood
## (C) Steve Bellan, Cari van Schalkwyk and the ICI3D team 2009–2019

## The code is made available under a Creative Commons Attribution 4.0 International License. You
## are free to reuse this code provided that you give appropriate credit, provide a link to the
## license, and indicate if changes were made. You may do so in any reasonable manner, but not in
## any way that suggests the licensor endorses you or your use. Giving appropriate credit includes
## citation of the original repository.

## Set margins for plotting.
par(mar=c(6,4,4,2))

## Say we are randomly sampling from a population of people in a town
## of size 1,000,000 and we sample 100 people from that population.
sampleSize <- 100
## Say that the true HIV prevalence in that population of size 1,000,000
## is 30%, i.e. 300,000 are HIV positive.
true.prev <- .3

## Sample from this distribution once 
## samplePos <- rbinom(1,100,.3)

## You can use the above code to sample from this distribution, but
## we'll set it at 28 just so everyone is working on the same example
## for now.
samplePos <- 28                          
samplePrev <- samplePos/sampleSize
samplePrev

## Create a color vector for every possible number of HIV+ people we
## could have found when sampling 100 people (0:100 means 101
## possibilities). Then make the value we chose have a different
## color.
color.vec <- rep("black",sampleSize+1)
color.vec[samplePos+1] <-	"purple"

### Create a histogram of the binomial distribution function with the
### true prevalence, highlighting the value we sampled.
barplot.obj <- barplot(dbinom(0:sampleSize,size=sampleSize, prob=true.prev),
                       xlab="number HIV+", names.arg=c(0:sampleSize),
                       ylab="probability", col=color.vec, border = NA, space =0)

## A politician is claiming that HIV prevalence is 20%
## Given that we found samplePos
samplePos
## positives, would we accept or reject the hypothesis that the true prevalence is .2?
potential.prev <- .5

## Calculate the probability of getting every single possible value
## from the binomial distribtion with this hypothesized prevalence.
prob.dist <- dbinom(0:sampleSize, size=sampleSize, prob=potential.prev)
ymax <- .2
color.vec <- rep("grey",sampleSize)

## Plot the binomial distribution for N=100, and p=.2
barplot(prob.dist,
        xlab = "number HIV+",
        names.arg = c(0:sampleSize),
        ylab = "probability",
        col = color.vec ,
        border = NA,
        main = paste("hypothetical prevalence:",potential.prev*100,"%"),
        ylim = c(0,ymax),
        space = 0)

##What is the probability of observing 28/100, under this hypothesised prevalence?
dbinom(samplePos, sampleSize, potential.prev)

arrows(x0 = samplePos , y0=ymax, y1=dbinom(samplePos, sampleSize, potential.prev))

## Now do a classic test:

binom.test(samplePos, sampleSize, potential.prev, alternative = "two.sided")

## Task 1: Explain what we learn from the binom.test
## Focus on the confidence intervals; don't worry about the P value (or about the "guess" (potential.prev)

## Task 2: Repeat the above for two or three different examples 
## with different hypothesized prevalence and/or samplePos
## Explain what you see.

###########################################################################
## Now let's use the Maximum Likelihood approach to construct confidence intervals.
########################################################################### 

## Create a vector of potential prevalences spanning 0-1 with 10000 values
## These are all potential "null hypotheses".
potential.prev.vector <- seq(0,1, length=10000)

## The likelihood of a prevalence is the probability of observing the data given the
## hypothesized prevalence:
## L(prevalence | data) = p(data | prevalence)
likelihoods <- dbinom(samplePos, sampleSize, potential.prev.vector)

plot(potential.prev.vector, likelihoods, col = "purple", type = "l", lwd = 2,
     xlab = "potential HIV prevalences", ylab = "likelihood",
     main = "p(our data given prevalence) = LIKELIHOOD",
     bty = "n")

###################################################################### 
## Let's look at the negative log-likelihood which is what people
## traditionally use because it's usually easier to calculate (though
## for this example R can do all the work computationally quite
## easily).
plot(potential.prev.vector, -log(likelihoods), type = "l", col = "purple", col.main = "white",
     bty = "n", lwd = 3, xlab = "potential prevalences (our models)",
     ylab = "-log(likelihood)",  main = "we usually minimize the -log(likelihood)")

## We can use the Likelihood Ratio Test to calculate confidence intervals. 
## If the logL of a hypothesised prevalence is not within the chi-squared
## alpha=.05 cutoff of the minimum logL, then we do not reject it.
chisq.crit <- qchisq(.95, df = 1)
min.l <- min(-log(likelihoods))
abline(h = min.l + chisq.crit/2, lwd = 3, lty = 2)

######################################################################
## It's hard to see this so let's zoom in on last plot for values of
## the potential prevalence between .15 and .5.

xlim <- c(.15, .5)

zoom.plot.index <- potential.prev.vector>.15 & potential.prev.vector<.5
plot(potential.prev.vector[zoom.plot.index], -log(likelihoods[zoom.plot.index]),
     type = "l", col = "purple", col.main = "white", xlim = xlim,
     bty = "n", lwd = 3, xlab = "potential prevalences (our models)",
     ylab = "-log(likelihood)",  main = "we usually minimize the -log(likelihood)")
chisq.crit <- qchisq(.95, df = 1)
chisq.crit
min.l <- min(-log(likelihoods))
ci.likelihood <- range(potential.prev.vector[-log(likelihoods) < min.l + chisq.crit/2])
abline(h = min.l + chisq.crit/2, lwd = 3, lty = 2)
## add title to the plot
ci.l <- signif(ci.likelihood[1],3)
ci.u <- signif(ci.likelihood[2],3)
mtext(paste("95% CI includes HIV prevalences of ", ci.l*100, "% to ", ci.u*100, "%", sep=""), side = 3, line =0)
arrows(ci.l, min.l + 4, ci.l, min.l, length = .2)
arrows(ci.u, min.l + 4, ci.u, min.l, length = .2)
text(ci.l, min.l + 4, ci.l,cex = 1,pos = 3)
text(ci.u, min.l + 4, ci.u,cex = 1,pos = 3)

## Compare confidence intervals calculated using binom.test() and using the Likelihood
## Ratio Test.
binom.test(samplePos, sampleSize, samplePos/sampleSize, alternative = "two.sided")

ci.likelihood

## Are the results similar?

## Task 3: Consider the following questions:

## For this example, do you think it was worth the trouble constructing Likelihood based confidence intervals (CIs)?
## Under what circumstances might you use classical tests for CIs?
## Under what circumstances would likelihood-based tests be better for CIs?

