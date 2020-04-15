# Hypothesis Testing {#HypothesisTesting}



## Introduction
The problem addressed in this chapter is how to decide whether an estimate of AUC is consistent with a pre-specified value. One example of this is when a single-reader rates a set of cases in a single-modality, from which one estimates AUC, and the question is whether the estimate is statistically consistent with a pre-specified value. From a clinical point of view, this is generally not a useful exercise, but its simplicity is conducive to illustrating the broader concepts involved in this and later chapters. The clinically more useful analysis is when multiple readers interpret the same cases in two or more modalities. With two modalities, for example, one obtains an estimate AUC for each reader in each modality, averages the AUC values over all readers within each modality, and computes the inter-modality difference in reader-averaged AUC values. The question forming the main subject of this book is whether the observed difference is consistent with zero.
 
Each situation outlined above admits a binary (yes/no) answer, which is different from the estimation problem that was dealt with in connection with the maximum likelihood method in Chapter 06, where one computed numerical estimates (and confidence intervals) of the parameters of the fitting model. 

**Hypothesis testing is the process of dichotomizing the possible outcomes of a statistical study and then using probabilistic arguments to choose one option over the other.**

The two competing options are termed the null hypothesis (NH) and the alternative hypothesis (AH). The hypothesis testing procedure is analogous1 to the jury trial system in the US, with 20 instead of 12 jurors, with the null hypothesis being the presumption of innocence and the alternative hypothesis being the defendant is guilty, and the decision rule is to assume the defendant is innocent unless all 20 jurors agree the defendant is guilty. If even one juror disagrees, the defendant is deemed innocent (equivalent to choosing an $\alpha$ – defined below - of 0.05, or 1/20). 

## Hypothesis testing for a single-modality single-reader ROC study
The binormal model described in Chapter 06 can be used to generate sets of ratings to illustrate the methods being described in this chapter. To recapitulate, the model is described by:

\begin{equation*} 
Z_{k_11} \sim N\left ( 0,1 \right )\\
Z_{k_22} \sim N\left ( \mu,\sigma^2 \right )
\end{equation*} 

The following code chunk encodes the `Wilcoxon` function:


```r
Wilcoxon <- function (zk1, zk2)
{
  K1 = length(zk1)
  K2 = length(zk2)
  W <- 0
    for (k1 in 1:K1) {
      W <- W + sum(zk1[k1] < zk2)
      W <- W + 0.5 * sum(zk1[k1] == zk2)
    }
    W <- W/K1/K2
  return (W)
}
```

In the next code chunk we set $\mu = 1.5$ and $\sigma = 1.3$ and simulate $K_1 = 50$ non-diseased cases and  $K_2 = 52$ diseased cases. For clarity I like to keep the sizes of the two arrays slightly different; this allows one to quickly check, with a glance at the `Environment` panel, that array dimensions are as expected. The `for` loop draws 50 samples from the $N(0,1)$ distribution and 52 samples from the $N(\mu,\sigma^2)$ distribution, calculates the empirical AUC using the Wilcoxon, and the process is repeated 10,000 times, the AUC values are saved to a huge array `AUC`. After exit from the `for-loop` we calculate the mean and standard deviation of the `AUC` values. 


```r
seed <- 1;set.seed(seed)
mu <- 1.5;sigma <- 1.3;K1 <- 50;K2 <- 52

# cheat to find the population mean and std. dev.
AUC <- array(dim = 10000)
for (i in 1:length(AUC)) {
  zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = mu, sd = sigma)  
  AUC[i] <- Wilcoxon(zk1, zk2)
}
meanAUC   <-  mean(AUC);sigmaAUC  <-  sd(AUC)
cat("pop mean AUC = ", meanAUC, ", pop sigma AUC = ", sigmaAUC, "\n")
#> pop mean AUC =  0.819178 , pop sigma AUC =  0.04176683
```

By the simple (if unimaginative) approach of sampling 10,000 times, one estimates the *population* mean and standard deviation of empirical AUC, denoted below by $AUC_{pop}$ and $\sigma_{AUC}$, respectively. Based on the 10,000 simulations, $AUC_{pop}$ = 0.819178  and $\sigma_{AUC}$ =0.0417668. 

The next chunk simulates one more independent ROC study with the same numbers of cases, and the resulting area under the empirical curve is denoted  $AUC$, AUC in the code. 


```r
# one more trial, this is the one we want to compare to meanAUC, i.e., get P-value
zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = mu, sd = sigma) 
AUC <- Wilcoxon(zk1, zk2)
cat("New AUC = ", AUC, "\n")
#> New AUC =  0.8626923

z <- (AUC - meanAUC)/sigmaAUC
cat("z-statistic = ", z, "\n")
#> z-statistic =  1.04184
```

Is the new value, 0.8626923, sufficiently different from the population mean (0.819178) to reject the null hypothesis $NH: AUC = AUC_{pop}$? Note that the answer to this question can be either yes or no: equivocation is not allowed.

The new value is "somewhat close" to the population mean, but how does one decide if "somewhat close" is close enough? Needed is the statistical distribution of the random variable $AUC$ under the hypothesis that the true mean is  $AUC_{pop}$. In the asymptotic limit of a large number of cases (this is an approximation), one can assume that the pdf of $AUC$  under the null hypothesis is the normal distribution  $N\left ( AUC_{pop}, \sigma_{AUC}^{2} \right )$:

\begin{equation*} 
pdf_{AUC}\left ( AUC\mid AUC_{pop}, \sigma_{AUC} \right )=\frac{1}{\sqrt{2\pi}\sigma_{AUC}}exp\left ( -\frac{1}{2} \left ( \frac{AUC-AUC_{pop}}{\sigma_{AUC}} \right )^2\right )
\end{equation*} 

The translated and scaled value is distributed as a unit normal distribution, i.e., 

\begin{equation*} 
Z=\frac{AUC-AUC_{pop}}{\sigma_{AUC}}\sim N\left ( 0,1 \right )
\end{equation*} 

[The $Z$ notation here should not be confused with z-sample, decision variable or rating of a case in an ROC study; the latter, when sampled over a set of non-diseased and diseased cases, yield a realization of  $AUC$. The author trusts the distinction will be clear from the context.] The observed magnitude of $z$ is 1.0418397. 

**The ubiquitous p-value is the probability that the observed magnitude of $z$, or larger, occurs under the null hypothesis (NH), that the true mean of $Z$ is zero.**

The p-value corresponding to an observed $z$ of 1.0418397 is given by (as always, uppercase $Z$ is the random variable, while lower case $z$ is a realized value):

\begin{equation*} 
\Pr\left ( \lvert Z \rvert \geq \lvert z \rvert \mid Z\sim N\left ( 0,1 \right )\right )=\\
\Pr\left ( \lvert Z \rvert \geq 1.042 \mid Z\sim N\left ( 0,1 \right )\right )=\\
2\Phi\left ( -1.042 \right )=0.2975
\end{equation*} 

To recapitulate statistical notation, $\Pr\left ( \lvert Z \rvert \geq \lvert z \rvert \mid Z\sim N\left ( 0,1 \right )\right )$ is to be parsed as  $\Pr\left ( A\mid  B \right )$, that is, the probability $\lvert Z \rvert \geq \lvert z \rvert$  given that $Z\sim N\left ( 0,1 \right )$. The last line in Eqn. (8.4) follows from the symmetry of the unit normal distribution, i.e., the area above 1.042 must equal the area below -1.042. 

Since $z$ is a continuous variable, the probability that a sampled value will exactly equal the observed value is zero. Therefore, one must pose the question as stated above, namely what is the probability that $Z$ is at least as extreme as the observed value (by "extreme" I mean further from zero, in either positive or negative directions). If the observed was $z$ = 2.5 then the corresponding p-value would be  $2\Phi(-2.5)$=0.01242, which is smaller than 0.2975 (`2*pnorm(-2.5)` = 0.01241933). This is cited below as the "second example".

Under the zero-mean null hypothesis, the larger the magnitude of the observed value of $Z$, the smaller the p-value, and the more unlikely that the data supports the NH. **The p-value can be interpreted as the degree of unlikelihood that the data supports the NH.** 

By convention one adopts a fixed value of the probability, denoted  and usually $\alpha$ = 0.05, which is termed the *size* of the test or *the significance level* of the test, and the decision rule is to reject the null hypothesis if the observed p-value < $\alpha$. 

\begin{equation*} 
p < \alpha \Rightarrow \text{Reject NH}
\end{equation*} 


```r
p2tailed <- pnorm(-abs(z)) + (1-pnorm(abs(z))) # p value for two-sided AH
p1tailedGT <- 1-pnorm(z) # p value for one-sided AH > 0 
p1tailedLT <- pnorm(z)# p value for one-sided AH < 0 
alpha  <- 0.05
```

In the first example, with observed p-value equal to 0.2975, one would not reject the null hypothesis, but in the second example, with observed p-value equal to 0.01242, one would. If the p-value is exactly 0.05 (unlikely with ROC analysis, but one needs to account for it) then one does not reject the NH. In the 20-juror analogy, of one juror insists the defendant is not guilty, then observed $\Pr$ is 0.05, and one does not reject the NH that the defendant is innocent (the double negatives, very common in statistics, can be confusing; in plain English, the defendant goes home).

According to the previous discussion, the critical magnitude of $z$ that determines whether to reject the null hypothesis is given by:

\begin{equation*} 
z_\frac{\alpha}{2}=-\Phi^{-1}\left ( \frac{\alpha}{2} \right )
\end{equation*} 

For $\alpha$ = 0.05 this evaluates to 1.95996 (which is sometimes rounded up to two, good enough for "government work" as the saying goes) and the decision rule is to reject the null hypothesis only if the observed magnitude of $z$ is larger than $z_\frac{\alpha}{2}$. 

**The decision rule based on comparing the observed z to a critical value is equivalent to a decision rule based on comparing the observed p-value to $\alpha$. It is also equivalent, as will be shown later, to a decision rule based on a $\left ( 1-\alpha \right )$  confidence interval for the observed statistic. One rejects the NH if the closed confidence interval does not include zero.**

## Type-I errors
Just because one rejects the null hypothesis, as in the second example, does not mean that the null hypothesis is false. Following the decision rule "caps", or puts an upper limit on, the probability of incorrectly rejecting the null hypothesis at $\alpha$. In other words, by agreeing to reject the NH only if $p \leq \alpha$, one has set an upper limit, namely  $\alpha$, on errors of this type, termed *Type-I* errors. These could be termed false positives in the hypothesis testing sense, not to be confused with false positive occurring on individual case-level decisions. According to the definition of $\alpha$:

\begin{equation*} 
\Pr( \text{Type I error} \mid {NH} )=\alpha
\end{equation*} 

To demonstrate the ideas one needs to have a very cooperative reader interpreting new sets of independent cases not just one more time, but 2000 more times (the reason for the 2000 trials will be explained below). The simulation code for this follows:


```r
seed <- 1;set.seed(seed)
mu <- 1.5;sigma <- 1.3;K1 <- 50;K2 <- 52

nTrials <- 2000
alpha <- 0.05 # size of test
reject = array(0, dim = nTrials)
for (trial in 1:length(reject)) {  
  zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = mu, sd = sigma)  
  AUC <- Wilcoxon(zk1, zk2)  
  z <- (AUC - meanAUC)/sigmaAUC
  p <- 2*pnorm(-abs(z)) # p value for individual trial
  if (p < alpha) reject[trial] = 1 
}

CI <- c(0,0); width <- -qnorm(alpha/2)
ObsvdTypeIErrRate <- sum(reject)/length(reject)
CI[1] <- ObsvdTypeIErrRate - width*sqrt(ObsvdTypeIErrRate*(1-ObsvdTypeIErrRate)/nTrials)
CI[2] <- ObsvdTypeIErrRate + width*sqrt(ObsvdTypeIErrRate*(1-ObsvdTypeIErrRate)/nTrials)
cat("alpha = ", alpha, "\n")
#> alpha =  0.05
cat("ObsvdTypeIErrRate = ", ObsvdTypeIErrRate, ", 95% confidence interval = ", CI, "\n")
#> ObsvdTypeIErrRate =  0.0535 , 95% confidence interval =  0.04363788 0.06336212
exact <- binom.test(sum(reject),n = 2000,p = alpha)
cat("exact 95% CI = ", as.numeric(exact$conf.int), "\n")
#> exact 95% CI =  0.04404871 0.06428544
```

The population means were calculated in an earlier code chunk. One initializes `NTrials` to 2000 and $\alpha$ to 0.05. The `for-loop` describes our captive reader interpreting independent sets of cases 2000 times. *Each completed interpretation of 102 cases is termed a trial.* For each trial one calculates the observed value of `AUC`, the observed `z` statistic and the the observed p-value. The observed p-value is compared against the fixed value $\alpha$ and one sets the corresponding `reject[trial]` flag to unity if $p < \alpha$. In other words, if the trial-specific p-value is less than $\alpha$ one counts an instance of rejection of the null hypothesis. The process is repeated 2000 times.

Upon exit from the for-loop, one calculates the observed Type-I error rate, denoted `ObsvdTypeIErrRate` by summing the reject array and dividing by 2000. One calculates a 95% confidence interval for `ObsvdTypeIErrRate` based on the binomial distribution, as in Chapter 03. 

The observed Type-I error rate is a realization of a random variable, as is the estimated 95% confidence interval. The fact that the confidence interval includes $\alpha$ = 0.05 is no coincidence - it shows that the hypothesis testing procedure is working as expected. To distinguish between the selected $\alpha$ (a fixed value) and that observed in a simulation study (a realization of a random variable), the term *empirical $\alpha$* is used to denote the observed value rejection rate.

It is a mistake to state that one wishes to minimize the Type-I error probability (the author has seen this comment from a senior researcher, which is the reason for bringing it up). The minimum value of $\alpha$ (a probability) is zero. Run the software with this value of $\alpha$: the NH will never be rejected. The downside of minimizing the expected Type-I error rate is that the NH will never be rejected, even when the NH is patently false. The aim of a valid method of analyzing the data is not minimizing the Type-I error rate, rather, the observed Type-I error rate should equal the specified value of $\alpha$ (0.05 in our example), allowance being made for the inherent variability in it’s estimate, i.e., its confidence interval. This is the reason 2000 trials were chosen for testing the validity of the NH testing procedure. With this choice, the 95% confidence interval, assuming that observed value is close to 0.05, is roughly ±0.01 as explained next. 

Following analogous reasoning to Chapter 03, Eqn. (3.10.10), and defining $f$ as the observed rejection fraction over $T$ trials, and as usual, $F$ is a random variable and $f$ a realized value, 

\begin{equation*} 
\sigma_f = \sqrt{f(1-f)/T}\\
F \sim N\left ( f,\sigma_{f}^{2} \right )
\end{equation*} 

An approximate $(1-\alpha)100$ percent CI for $f$  is:

\begin{equation*} 
{CI}_f = \left [ f-z_{\frac{\alpha}{2}}\sigma_f, f+z_{\frac{\alpha}{2}}\sigma_f \right ]
\end{equation*} 

If $f$ is close to 0.05, then for 2000 trials, the 0.95 or 95% CI for $f$ is $f \pm 0.01$, i.e.,  `qnorm(alpha/2) * sqrt(.05*(.95)/2000)` = 0.009551683 ~ 0.01.

The only way to reduce the width of the CI, and thereby run a more stringent test of the validity of the analysis, is to increase the number of trials $T$. Since the width of the CI depends on the inverse square root of the number of trials, one soon reaches a point of diminishing returns. Usually $T = 2000$ trials are enough for most statisticians and the author, but examples using more simulations have been published.

## One sided vs. two sided tests
In the preceding example, the null hypothesis was rejected anytime the magnitude of the observed value of $z$ exceeded the critical value $-\Phi^{-1}\left ( \frac{\alpha}{2} \right)$. This is a statement of the alternative hypothesis (AH) $AUC\neq AUC_{pop}$, in other words too high or too low values of $z$ *both* result in rejection of the null hypothesis. This is referred to as a two-sided AH and the resulting p-value is termed a *two-sided* p-value. This is the most common one used in the literature.

Now suppose that the additional trial performed by the radiologist was performed after an intervention following which the radiologist’s performance is expected to increase. To make matters clearer, assume the interpretations in the 10,000 trials used to estimate $AUC_{pop}$ were performed with the radiologist wearing an old pair of eye-glasses, possibly out of proper strength, and the additional trial is performed after the radiologist gets a new set of prescription eye-glasses. Because the radiologist’s eyesight has improved, the expectation is that performance should increase. In this situation, it is appropriate to use the one-sided alternative hypothesis $AUC > AUC_{pop}$. Now, large values of $z$ result in rejection of the null hypothesis, but small values do not. The critical value of $z$ is defined by $z_\alpha = \Phi\left ( 1-\alpha \right )$, which for $\alpha$ = 0.05 is 1.645 (i.e., `qnorm(1-alpha)
= 1.644854`). Compare 1.64 to the critical value  $-\Phi^{-1}\left ( \frac{\alpha}{2} \right)$ = 1.96 for a two-sided test. If the change is in the expected direction, it is more likely that one will reject the NH with a one-sided than with a two-sided test. The p-value for a one-sided test is given by: 

\begin{equation*} 
\Pr\left ( Z \geq 1.042 \mid NH \right ) = \Phi \left (-1.042  \right ) = 0.1487
\end{equation*} 

Notice that this is half the corresponding two-sided test p-value; this is because one is only interested in the area under the unit normal that is above the observed value of $z$. If the intent is to obtain a significant finding, it is tempting to use one-sided tests. The down side of a one-sided test is that even with a large excursion of the observed $z$ in the other direction one cannot reject the null hypothesis. So if the new eye-glasses are so bad as to render the radiologist practically blind (think of a botched cataract surgery) the observed $z$ would be large and negative, but one cannot reject the null hypothesis $AUC=AUC_{pop}$.

The one-sided test could be run the other way, with the alternative hypothesis being stated as $AUC<AUC_{pop}$. Now, large negative excursions of the observed value of AUC cause rejection of the null hypothesis, but large positive excursions do not. The critical value is defined by  $z_\alpha = \Phi^{-1}\left (\alpha  \right )$, which for $\alpha$ = 0.05  is -1.645. The p-value is given by (note the reversed sign compared to the previous one-sided test:

\begin{equation*} 
\Pr\left ( Z \leq 1.042 \mid NH  \right ) = \Phi(1.042) = 1 - 0.1487 = 0.8513
\end{equation*} 

This is the complement of the value for a one-sided test with the alternative hypothesis going the other way: obviously the probability that $Z$ is smaller than the observed value (1.042) plus the probability that $Z$ is larger than the same value must equal one. 

## Statistical power


## References  
