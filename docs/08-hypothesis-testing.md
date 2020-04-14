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

In the next code chunk we set $\mu = 1.5$ and $\sigma = 1.3$ (these values were selected arbitrarily; the reader may wish to experiment with different ones) and simulate $K_1 = 50$ non-diseased cases and  $K_2 = 52$ diseased cases. For clarity I like to keep the sizes of the two arrays slightly different; this allows one to quickly check, with a glance at the `Environment` panel, that array dimensions are as expected. The `for` loop draws 50 samples from the $N(0,1)$ distribution and 52 samples from the $N(\mu,\sigma^2)$ distribution, calculates the empirical AUC using the Wilcoxon, and the process is repeated 10,000 times, the AUC values are saved to a huge array `AUC`. After exit from the `for-loop` we calculate the mean and standard deviation of the `AUC` values. 


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
zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = mu, sd = sigma) # sqrt(DeLong(zk1,zk2)) 
AUC <- Wilcoxon(zk1, zk2)
cat("New AUC = ", AUC, "\n")
#> New AUC =  0.8626923

z <- (AUC - meanAUC)/sigmaAUC
#z <- qnorm(0.05/2)
cat("z-statistic = ", z, "\n")
#> z-statistic =  1.04184
```

Is the new value, 0.8626923, sufficiently different from the population mean (0.819178) to reject the null hypothesis $NH: AUC = AUC_{pop}$? Note that the answer to this question can be either yes or no: equivocation is not allowed.

The new value is "somewhat close" to the population mean, but how does one decide if "somewhat close" is close enough? Needed is the statistical distribution of the random variable $AUC$  under the hypothesis that the true mean is  $AUC_{pop}$. In the asymptotic limit of a large number of cases (this is an approximation), one can assume that the pdf of $AUC$  under the null hypothesis is the normal distribution  $N\left ( AUC_{pop}, \sigma_{AUC}^{2} \right )$:

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
P\left ( \lvert Z \rvert \geq \lvert z \rvert \mid Z\sim N\left ( 0,1 \right )\right )=\\
P\left ( \lvert Z \rvert \geq 1.042 \mid Z\sim N\left ( 0,1 \right )\right )=\\
2\Phi\left ( -1.042 \right )=0.2975
\end{equation*} 

To recapitulate statistical notation, $P\left ( \lvert Z \rvert \geq \lvert z \rvert \mid Z\sim N\left ( 0,1 \right )\right )$ is to be parsed as  $P\left ( A\mid  B \right )$, that is, the probability $\lvert Z \rvert \geq \lvert z \rvert$  given that $Z\sim N\left ( 0,1 \right )$. The last line in Eqn. (8.4) follows from the symmetry of the unit normal distribution, i.e., the area above 1.042 must equal the area below -1.042. 

Since $z$ is a continuous variable, the probability that a sampled value will exactly equal the observed value is zero. Therefore, one must pose the question as stated above, namely what is the probability that $Z$ is at least as extreme as the observed value (by "extreme" I mean further from zero, in either positive or negative directions). If the observed was $z$ = 2.5 then the corresponding p-value would be  , which is smaller than 0.2975 (`2*pnorm(-2.5)` = 0.01241933). This is cited below as the "second example".

Under the zero-mean null hypothesis, the larger the magnitude of the observed value of $Z$, the smaller the p-value, and the more unlikely that the data supports the NH. **The p-value can be interpreted as the degree of unlikelihood that the data supports the NH.** 

By convention one adopts a fixed value of the probability, denoted  and usually $\alpha$ = 0.05, which is termed the *size* of the test or *the significance level* of the test, and the decision rule is to reject the null hypothesis if the observed p-value < $\alpha$. 

\begin{equation*} 
p \leq \alpha \Rightarrow \text{Reject NH}
\end{equation*} 

In the first example, with observed p-value equal to 0.2975, one would not reject the null hypothesis, but in the second example, with observed p-value equal to 0.01242, one would. If the p-value is exactly 0.05 (unlikely with ROC analysis, but one needs to account for it) then one does not reject the NH. In the 20-juror analogy, of one juror insists the defendant is not guilty, then observed P is 0.05, and one does not reject the NH that the defendant is innocent (the double negatives, very common in statistics, can be confusing; in plain English, the defendant goes home).

According to the previous discussion, the critical magnitude of $z$ that determines whether to reject the null hypothesis is given by:

\begin{equation*} 
z_\frac{\alpha}{2}=-\Phi^{-1}\left ( \frac{\alpha}{2} \right )
\end{equation*} 

For $\alpha$ = 0.05 this evaluates to 1.95996 (which is sometimes rounded up to two, good enough for "government work" as the saying goes) and the decision rule is to reject the null hypothesis only if the observed magnitude of $z$ is larger than $z_\frac{\alpha}{2}$. 

**The decision rule based on comparing the observed z to a critical value is equivalent to a decision rule based on comparing the observed p-value to $\alpha$. It is also equivalent, as will be shown later, to a decision rule based on a $\left ( 1-\alpha \right )$  confidence interval for the observed statistic. One rejects the NH if the closed confidence interval does not include zero.**

## Type-I errors


## References  

