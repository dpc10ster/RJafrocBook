---
output:
  pdf_document: default
  html_document: default
---
# Obuchowski Rockette Hillis (ORH) Analysis {#ORHAnalysis}



## Introduction
The previous chapter described the DBM significance testing procedure5 for analyzing MRMC ROC data, along with improvements suggested by Hillis. Because the method depends on the assumption that jackknife pseudovalues can be regarded as independent and identically distributed case-level figures of merit, it has been criticized by Hillis who states that the method "works" but lacks firm statistical foundations [@RN1772; @RN1865; @RN1866]. I believes that if a method "works" there must be good reasons why it "works" and the last section of the previous chapter, §9.13, gave a justification for why the method "works". Specifically, the empirical AUC pseudovalues qualify as case-level FOM-like quantities; this property was also noted in 1997 by Hanley and Hajian-Tilaki [@RN1395]. However, this justification only applies to the empirical AUC, so an alternate approach is desirable. 

This chapter presents Hillis' preferred alternative to the DBMH approach. He has argued that the DBMH method can be regarded as a "working model that gives the right results", but a method based on an earlier publication [@RN1450] by Obuchowski and Rockette, which does not depend on pseudovalues, and predicts more or less the same results, is preferable from a conceptual viewpoint. Since, besides showing the correspondence, Hillis has made significant improvements to the original methodology, this chapter is named "ORH Analysis", where ORH stands for Obuchowski, Rockette and Hillis. The ORH method has advantages in being able to handle more complex study designs [@RN2508] that are outside the scope of this book (the author acknowledges a private communication from Dr. Obuchowski, ca. 2006, that demonstrates the flexibility afforded by the OR approach) and it is possible that applications to other paradigms (e.g., the FROC paradigm uses a rather different FOM from empirical ROC-AUC) are better performed with the ORH method.

This chapter starts with a "gentle" introduction to the Obuchowski and Rockette method. The reason for the "gentle" introduction is that the method was rather opaque to me, an I suspect, most users. Part of the problem, in my opinion, is the notation, namely lack of usage of the *case-set* index $\{c\}$, whose absence can be confusing. The notational issue is highlighted in a key difference of the Obuchowski and Rockette method from DBMH, namely in how the error term is modeled by a covariance matrix. In this chapter the structure of the covariance matrix is examined in some detail, as it is key to understanding the ORH method.

In the first step of the gentle introduction a single reader interpreting a case-set in multiple treatments is modeled and the results compared to those obtained using DBMH fixed-reader analysis described in the previous chapter. In the second step multiple readers interpreting a case-set in multiple treatments is modeled. The two analyses, DBMH and ORH, are compared for the same dataset. The special cases of fixed-reader and fixed-case analyses are described. Single treatment analysis, where interest is in comparing average performance of readers to a fixed value, is described. Three methods of estimating the covariance matrix are described.

## Single-reader multiple-treatment model
Consider a single-reader providing ROC interpretations of a common case-set $\{c\}$ in multiple-treatments $i$ ($i$ = 1, 2, …, $I$). Before proceeding, we note that this is not homologous (i.e., formally equivalent) to multiple-readers providing ROC interpretations in a single treatment, §10.7; this is because reader is a random factor while treatment is not. The figure of merit $\theta$  is modeled as:

\begin{equation*}
\theta_{i\{c\}}=\mu+\tau_i+\epsilon_{i\{c\}}
\end{equation*}

*In the Obuchowski and Rockette method [@RN1450] one models the figure-of-merit, not the pseudovalues, indeed this is one of the key differences from the DBMH method.*

Recall that $\{c\}$ denotes a *set of cases*. Eqn. (10.1) models the observed figure-of-merit $\theta_{i\{c\}}$ as a constant term $\mu$ plus a treatment dependent term $\tau_i$ (the treatment-effect) with the constraint: 

\begin{equation*}
\sum_{i=1}^{I}\tau_i=0
\end{equation*}

The *c-index* was introduced in (book) Chapter 07. The left hand side of Eqn. (10.1) is the figure-of-merit $\theta_i\{c\}$ for treatment $i$ and case-set index $\{c\}$, where $c$ = 1, 2, ..., $C$ denotes different independent case-sets sampled from the population, i.e., different collections of $K_1$ non-diseased and $K_2$ diseased cases, *not individual cases*.

*This is one place the case-set index is essential for clarity; without it $\theta_i$ is a fixed quantity - the figure of merit estimate for treatment $i$ - lacking any index allowing for sampling related variability.* 

Obuchowski and Rockette use a *k-index*, defined as the “kth repetition of the study involving the same diagnostic test, reader and patient (sic)”. In the author's opinion, what is meant is a case-set index instead of a repetition index. Repeating a study with the same treatment, reader and cases yields *within-reader* variability, which is different from sampling the population of cases with new case-sets, which yields *case-sampling plus within-reader* variability. As noted earlier, within-reader variability cannot be "turned off" and affects the interpretations of all case-sets. 

*Interest is in extrapolating to the population of cases and the only way to do this is to sample different case-sets. It is shown below that usage of the case-set index interpretation yields the same results using the DBMH or the ORH methods.*

Finally, and this is where I had some difficulty understanding what is going on, there is an additive random error term   whose sampling behavior is described by a multivariate normal distribution with an I-dimensional zero mean vector and an I x I dimensional covariance matrix  $\Sigma$:

\begin{equation*}
\epsilon_{i\{c\}} \sim N_I\left ( \vec{0} ,  \Sigma\right )
\end{equation*}

Here $N_I$ is the I-variate normal distribution (i.e., each sample yields $I$ random numbers). Obuchowski and Rockette assumed the following structure for the covariance matrix (they describe a more general model, but here one restricts to the simpler one):

\begin{equation*}
\Sigma=Cov\left ( \epsilon_{i\{c\}}, \epsilon_{i'\{c\}} \right )\\
=Var \Rightarrow i=i'\\
=Cov_1 \Rightarrow i\neq i'
\end{equation*}

The reason for the subscript "1" in $Cov_1$  will become clear when one extends this model to multiple readers. The $I \times I$ covariance matrix $\Sigma$  is: 

\begin{equation*}
\Sigma=
\begin{pmatrix}
    Var & Cov_1   & \ldots & Cov_1 & Cov_1 \\
    Cov_1 & Var   & \ldots &Cov_1 & Cov_1 \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    Cov_1 & Cov_1 & \ldots & Var & Cov_1 \\
    Cov_1 & Cov_1 & \ldots & Cov_1 & Var
\end{pmatrix}
\end{equation*}

If $I$ = 2 then $\Sigma$  is a symmetric 2 x 2 matrix, whose diagonal terms are the common variances in the two treatments (each assumed equal to $Var$) and whose off-diagonal terms (each assumed equal to  $Cov_1$) are the co-variances. With $I$ = 3 one has a 3 x 3 symmetric matrix with all diagonal elements equal to $Var$ and all off-diagonal terms are equal to $Cov_1$, etc. 

*An important aspect of the Obuchowski and Rockette model is that the variances and co-variances are assumed to be treatment independent. This implies that $Var$ estimates need to be averaged over all treatments. Likewise,  $Cov_1$ estimates need to be averaged over all distinct treatment-treatment pairings.*

A more complex model, with more parameters and therefore more difficult to work with, would allow the variances to be treatment dependent, and the covariances to depend on the specific treatment pairings. For obvious reasons ("Occam's Razor" or the law of parsimony ) one wishes to start with the simplest model that, one hopes, captures essential characteristics of the data.

Some elementary statistical results are presented next.

### Definitions of covariance and correlation

The covariance of two scalar random variables X and Y is defined by:

$$Cov(x,y) =\frac{\sum_{i=1}^{N}(x_{i}-x_{\bullet})(y_{i}-y_{\bullet})}{N-1}=E(XY)-E(X)-E(Y)$$

  $E*X)$ is the expectation value of the random variable $X$, i.e., the integral of x multiplied by its $pdf$: 

$$E(X)=\int pdf(x) x dx$$

The integral is over the range of $x$. The covariance can be thought of as variance of two random variables that is *common* to both of them. The variance, a special case of covariance, of $X$ is defined by:

$$Var(x,y) =Cov(X,X)=E(X^2)-(E(X))^2=\sigma_x^2$$

It can be shown using the Cauchy–Schwarz inequality that

$$\mid Cov(X,Y) \mid^2 \le Var(X)Var(Y)$$

A related quantity, the correlation $\rho$  is defined by (the $\sigma$s  are standard deviations):

$$\rho_{XY} \equiv Cor(X,Y)=\frac{Cov(X,Y)}{\sigma_X \sigma_Y}$$

It has the property:

$$\mid \rho_{XY} \mid \le 1$$

### Special case

Assuming $X$ and $Y$ have the same variance:

$$Var(X)=Var(Y)\equiv Var\equiv \sigma^2$$

A useful theorem applicable to the OR single-reader multiple-treatment model is:

$$Var(X-Y)=Var(X)+Var(Y)-2Cov(X,Y)=2(Var-Cov)$$

The first line of the above equation is general, the second line specializes to the OR single-reader multiple-treatment model where the variances are equal and likewise all covariances in Eqn. (10.5) are equal) The correlation  $\rho_1$ is defined by (the reason for the subscript 1 on $\rho$  is the same as the reason for the subscript 1 on  $Cov_1$, which will be explained later): 

$$\rho_1=\frac{Cov_1}{Var}$$

The I x I covariance matrix $\Sigma$  can be written alternatively as (shown below is the matrix for I = 5; as the matrix is symmetric one need only show elements at and above the diagonal): 

$$\Sigma = 
    \begin{bmatrix}
        \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
         & \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
         &  & \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
         &  &  & \sigma^2 & \rho_1\sigma^2\\
         &  &  &  & \sigma^2
    \end{bmatrix}
$$

### Estimation of the covariance matrix
An unbiased estimate of the covariance Eqn. (10.4) follows from:

$$\Sigma_{ii'}=\frac{1}{C-1}\sum_{c=1}^{C} \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)$$

Sampling different case-sets, as required by Eqn. (10.16), is unrealistic and in reality one is stuck with $C$ = 1, i.e., a single dataset. Therefore direct application of this formula is impossible. However, as seen when this situation was encountered before in (book) Chapter 07, one uses resampling methods to realize, for example, different bootstrap samples, which are resampling-based “stand-ins” for actual case-sets. If $B$ is the number of bootstraps, then the estimation formula is:

$$\Sigma_{ii'}\mid_{bs} =\frac{1}{B-1}\sum_{b=1}^{B} \left ( \theta_{i\{b\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{b\}} - \theta_{i'\{\bullet\}} \right)$$

The bootstrap method of estimating the covariance matrix, Eqn. (10.17), is a direct translation of Eqn. (10.16). Alternatively, one could have used the jackknife FOM values $\theta_{i(k)}$, i.e., the figure of merit with a particular case removed, for all cases, to estimate the covariance matrix:

$$\Sigma_{ii'}\mid_{jk} =\frac{(K-1)^2}{K} \left [ \frac{1}{K-1}\sum_{k=1}^{K} \left ( \theta_{i\{k\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{k\}} - \theta_{i'\{\bullet\}} \right) \right ]$$

For simplicity, in this section we depart from the usual two-subscript convention to index each case. So $k$ ranges from 1 to $K$, where the first $K_1$ values represent non-diseased and the following $K_2$  values represent diseased cases. Jackknife figure of merit values are not to be confused with jackknife pseudovalues. The jackknife FOM value corresponding to a particular case is the FOM with the particular case removed. Unlike pseudovalues, jackknife FOM values cannot be regarded as independent and identically distributed. Notice the use of the subscript enclosed in parenthesis $(k)$ to denote the FOM with case $k$ removed, i.e., a single case, while in the bootstrap equation one uses the curly brackets  $\{b\}$ to denote the bth bootstrap *case-set*, i.e., a whole set of $K_1$ non-diseased and $K_2$ diseased cases, sampled with replacement from the original dataset. Furthermore, the expression for the jackknife covariance contains a *variance inflation factor*:

$$\frac{(K-1)^2}{K}$$

This factor multiplies the traditional expression for the covariance, shown in square brackets in Eqn. (10.18). A third method of estimating the covariance, namely the DeLong et al. method [@RN112], applicable only to the empirical AUC, is described later.

### Meaning of the covariance matrix in Eqn. (10.5)
Suppose one has the luxury of repeatedly sampling case-sets, each consisting of $K$ cases from the population. A single radiologist interprets these cases in $I$ treatments. Therefore, each case-set $\{c\}$ yields $I$ figures of merit. The final numbers at ones disposal are $\theta_{i\{c\}}$, where $i$ = 1,2,...,$I$ and $c$ = 1,2,...,$C$. Considering treatment $i$, the variance of the FOM-values for the different case-sets $c$ = 1,2,...,$C$, is an estimate of $Vat_i$ for this treatment: 

$$\sigma_i^2 \equiv Var_i = \frac{1}{C-1}\sum_{c=1}^{C}\left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)$$
  	.	(10.20)

The process is repeated for all treatments and the I-variances are averaged. This is the final estimate of $Var$ appearing in Eqn. (10.5). 

To estimate the covariance matrix one considers pairs of FOM values for the same case-set $\{c\}$  but different treatments, i.e., $\theta_{i\{c\}}$  and $\theta_{i'\{c\}}$; *by definition primed and un-primed indices are different*. Since they are derived from the same case-set, one expects the values to be correlated. For a particularly easy case-set one expects all I-estimates to be collectively higher than usual. The process is repeated for different case-sets and one calculates the correlation $\rho_{1;ii'}$  between the two $C$-length arrays $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$: 

$$\rho_{1;ii'} = \frac{1}{C-1}\sum_{c=1}^{C} \frac {\left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)}{\sigma_i \sigma_{i'} }$$

The entire process is repeated for different treatment pairings and the resulting $I(I-1)/2$  distinct values are averaged yielding the final estimate of $\rho_1$  in Eqn. (10.15). According to Eqn. (10.14) one expects the covariance to be smaller than the variance determined as in the previous paragraph. 

In most situations one expects $\rho_1$ (for ROC studies) to be positive. There is, perhaps unlikely, a scenario that could lead to anti-correlation and negative. This could occur, with "complementary" treatments, e.g., CT vs. MRI, where one treatment is good for bone imaging and the other for soft-tissue imaging. In this situation what constitutes an easy case-set in one treatment could be a difficult case-set in the other treatment.

### Code illustrating the covariance matrix

As indicated above, the covariance matrix can be estimated using the jackknife or the bootstrap. If the figure of merit is the Wilcoxon statistic, then one can also use the DeLong et al method11. In Chapter 07, these methods were described in the context of estimating the variance of AUC. Eqn. (10.17) and Eqn. (10.18) extend the jackknife and the bootstrap methods, respectively, to estimating the covariance of AUC (whose diagonal elements are the variances estimated in the earlier chapter). The extension of the DeLong method to covariances is described in Online Appendix 10.A and implemented in file VarCovMtrxDLStr.R. It has been confirmed by the author that the implementation of the DeLong method11 in file VarCovMtrxDLStr.R gives identical results to those yielded by the SAS macro attributed to DeLong. The file name stands for "variance covariance matrix according to the DeLong structural components method" described in five unnumbered equation following Eqn. 4 in the cited reference.

The jackknife, bootstrap and the DeLong methods are used in file mainVarCov1.R, a listing and explanation of which appears in Online Appendix 10.B. Source the file yielding the following code output:


```r
Y <- UtilPseudoValues(dataset02, FOM = "Wilcoxon")$jkPseudoValues
I <- dim(Y)[1];J <- dim(Y)[2];K <- dim(Y)[3]
msT <- 0
for (i in 1:I) { # OK
  msT <- msT + (mean(Y[i, , ]) - mean(Y))^2
}
msT <- msT * K * J/(I - 1)

msTC <- 0
for (i in 1:I) {
  for (k in 1:K) { # OK
    msTC <- msTC + (mean(Y[i, , k]) - mean(Y[i, , ]) - mean(Y[, , k]) + mean(Y))^2
  }
  msTC <- msTC * J/((I - 1) * (K - 1))
} 

msR <- 0
for (j in 1:J) { # OK
  msR <- msR + (mean(Y[, j, ]) - mean(Y))^2
}
msR <- msR * K * I/(J - 1)

msC <- 0
for (k in 1:K) { # Not used subsequently
  msC <- msC + (mean(Y[, , k]) - mean(Y))^2
}
msC <- msC * I * J/(K - 1)

msTR <- 0
for (i in 1:I) {
  for (j in 1:J) { # OK
    msTR <- msTR + (mean(Y[i, j, ]) - mean(Y[i, , ]) - mean(Y[, j, ]) + mean(Y))^2
  }
}
msTR <- msTR * K/((I - 1) * (J - 1))

msTC <- 0
for (i in 1:I) {
  for (k in 1:K) { # OK
    msTC <- msTC + (mean(Y[i, , k]) - mean(Y[i, , ]) - mean(Y[, , k]) + mean(Y))^2
  }
}
msTC <- msTC * J/((I - 1) * (K - 1))

msRC <- 0
for (j in 1:J) {
  for (k in 1:K) { # ?? Not used subsequently
    msRC <- msRC + (mean(Y[, j, k]) - mean(Y[, j, ]) - mean(Y[, , k]) + mean(Y))^2
  }
}
msRC <- msRC * I/((J - 1) * (K - 1))

msTRC <- 0
for (i in 1:I) {
  for (j in 1:J) {
    for (k in 1:K) { # OK
      msTRC <- msTRC + (Y[i, j, k] - mean(Y[i, j, ]) - mean(Y[i, , k]) - mean(Y[, j, k]) + mean(Y[i, , ]) + mean(Y[, j, ]) + mean(Y[, , k]) - mean(Y))^2
    }
  }
}
msTRC <- msTRC/((I - 1) * (J - 1) * (K - 1))
data.frame("msT" = msT, "msR" = msR, "msC" = msC, "msTR" = msTR, "msTC" = msTC, "msRC" = msRC, "msTRC" = msTRC)
#>         msT       msR       msC       msTR       msTC       msRC     msTRC
#> 1 0.5467634 0.4373268 0.3968699 0.06281749 0.09984808 0.06450106 0.0399716
as.data.frame(UtilMeanSquares(dataset02)[1:7])
#>         msT       msR       msC       msTR       msTC       msRC     msTRC
#> 1 0.5467634 0.4373268 0.3968699 0.06281749 0.09984808 0.06450106 0.0399716
```

After displaying the results of the calculation, the results are compared to those calculated by `RJafroc` function `UtilMeanSquares(dataset02)`.

### Significance testing
If the NH of no treatment effect is true, i.e., if $\sigma_{\tau}^{2}$ = 0, then according to Table 9.1 the following holds (the last term in the row labeled $T$ in Table 9.1 drops out):

\begin{equation*}
E\left ( MST\mid NH \right ) = \sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2} + K\sigma_{\tau R}^{2} + J\sigma_{\tau C}^{2}
\end{equation*}

Also, the following linear combination is equal to $E\left ( MST\mid NH \right )$:

\begin{equation*}
E\left ( MS(TR) \right ) + E\left ( MS(TC) \right )  - E\left ( MS(TRC) \right ) \\ 
= \left (\sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2} + K\sigma_{\tau R}^{2} \right ) + \left (\sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2} + J\sigma_{\tau C}^{2} \right ) -\left (\sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2}  \right ) \\
= \sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2} + J \sigma_{\tau C}^{2} +  K\sigma_{\tau R}^{2} \\
= E\left ( MS(T)\mid NH \right )
\end{equation*}

Therefore, under the NH, the ratio: 

\begin{equation*}
\frac{E\left ( MS(T)\mid NH \right )}{E\left ( MS(TR) \right ) + E\left ( MS(TC) \right )  - E\left ( MS(TRC) \right )} = 1
\end{equation*}

In practice, one does not know the expected values – that would require averaging each of these quantities, regarded as random variables, over their respective distributions. Therefore, one defines the following statistic, denoted  $F_{DBM}$, using the observed values of the mean squares, calculated almost trivially using Eqn. (9.12):

\begin{equation*}
F_{DBM} = \frac{MS(T)}{MS(TR) + MS(TC) - MS(TRC)}
\end{equation*}

$F_{DBM}$ is a realization of a random variable. A non-zero treatment effect, i.e.,  $\sigma_{\tau}^{2} > 0$, will cause the ratio to be larger than one, because $E\left ( MS(T) \right)$  will be larger, see row labeled $T$ in Table 9.1. Therefore values of $F_{DBM} > 1$  will tend to reject the NH. Drawing on a theorem from statistics [@RN1492], under the NH the ratio of two independent mean squares is distributed as a (central) F-statistic with degrees of freedom corresponding to those of the mean squares forming the numerator and denominator of the ratio (Theorem 12.2.5 in “An Introduction to Mathematical Statistics and Its Applications”).  Knowing the distribution of the statistic defined by (9.18) under the NH enables hypothesis testing. This is completely analogous to Chapter 08 where knowledge of the distribution of AUC under the NH enabled testing the null hypothesis that the observed value of AUC equals a pre-specified value. 

Under the NH the left hand side of by (9.18), i.e., $F_{DBM}$, is distributed according to the F-distribution characterized by two numbers: 

* A numerator degrees of freedom ($ndf$) – determined by the degrees of freedom of the numerator $MST$ of the ratio comprising the F-statistic, i.e., $I – 1$, and 
* A denominator degrees of freedom ($ddf$) - determined by the degrees of freedom of the denominator of the ratio comprising the F-statistic, to be described below. 

Summarizing,

\begin{equation*}
F_{DBM} \sim F_{ndf,ddf} \\
ndf=I-1
\end{equation*}

The next topic is estimating $ddf$.

### The Satterthwaite approximation
The denominator of the F-ratio is MS(TR)+MS(TC)-MS(TRC).

This is not a simple mean square. Rather it is a *linear combination of mean squares* (with coefficients 1, 1 and  1), and the resulting value could even be negative, which is an illegal value for a sample from an F-distribution. In 1941 Satterthwaite [@RN2359; @RN2360] proposed an approximate degree of freedom for a linear combination of simple mean square quantities. Online Appendix 9.A explains the approximation in more detail. The end result is that the mean square quantity described in Eqn. (9.21) has an approximate degree of freedom defined by (this is called the *Satterthwaite's approximation*):

\begin{equation*}
ddf_{Sat}=\frac{\left ( MS(TR) + MS(TC) - MS(TRC) \right )^2}{\left ( \frac{MS(TR)^2}{(I-1)(J-1)} + \frac{MS(TC)^2}{(I-1)(K-1)} + \frac{MS(TRC)^2}{(I-1)(J-1)(K-1)}  \right )}
\end{equation*}

The subscript $Sat$ is for Satterthwaite. From Eqn. (9.22) it should be fairly obvious that in general $ddf_{Sat}$ is not an integer. To accommodate possible negative estimates of the denominator, Eqn. (9.21), the original DBM method [@RN204] proposed four expressions for the F-statistic and corresponding expressions for $ddf$. Rather than repeat them here, since they have been superseded by the method described below, the interested reader is referred to Eqn. 6 and Eqn. 7 in [@RN1866].

Hillis [@RN1865] proposes the following statistic for testing the null hypothesis (the subscript $DBMH$ give credit to the original formulation by DBM and the subsequent improvements by Hillis): 

\begin{equation*}
F_{DBMH} = \frac{MS(T)}{MS(TR) + \max \left (MS(TC) - MS(TRC), 0  \right )}
\end{equation*}

Now the denominator cannot be negative. One can think of the F-statistic $F_{DBMH}$ as a signal-to-noise ratio like quantity, with the difference that both numerator and denominator are variance like quantities. If the "variance" represented by the treatment effect is larger than the variance of the noise tending to mask the treatment effect, then $F_{DBMH}$  tends to be large, which makes the observed treatment "variance" stand out more clearly compared to the noise. 

Hillis has shown that the left hand side of Eqn. (9.23) is distributed as an F-statistic with ndf defined by Eqn. (9.20), and denominator degrees of freedom   defined by:

\begin{equation*}
ddf_H =\frac{\left ( MS(TR) + \max \left (MS(TC) - MS(TRC),0  \right ) \right )^2}{\left ( \frac{MS(TR)^2}{(I-1)(J-1)}  \right )}
\end{equation*}

Summarizing,

\begin{equation*}
F_{DBM} \sim F_{ndf,ddf} \\
ndf=I-1
\end{equation*}

Instead of 4 rules, as in the original DBM method, the Hillis modification involves just one rule, summarized by Eqns. (9.23) through Eqn. (9.25). Moreover, the F-statistic is constrained to non-negative values. Using simulation testing [@RN1866] has shown that the DBMH method has better null hypothesis behavior than the original DBM method; the latter tended to be too conservative, typically yielding Type I error rates smaller than the optimal 5%. 

### Decision rules, p-value and confidence intervals
The critical value of the F-statistic $F_{1-\alpha,ndf,ddf_H}$  is defined such that fraction   of the distribution lies to the left of the critical value, in other words it is the quantile function for the F-distribution: 

\begin{equation*}
\Pr\left ( F\leq F_{1-\alpha,ndf,ddf_H} \mid F\sim F_{ndf,ddf_H}\right ) = 1 - \alpha
\end{equation*}

The critical value $F_{1-\alpha,ndf,ddf_H}$ increases as $\alpha$ decreases. The value of $\alpha$, generally chosen to be 0.05, termed the *nominal* $\alpha$, is fixed. The decision rule is that if $F_{DBMH} > F_{1-\alpha, ndf, ddf_H}$ one rejects the NH and otherwise one does not. It follows, from the definition of $F_{DBMH}$, Eqn. (9.23), that rejection of the NH is more likely if: 
* $F_{DBMH}$ is large, Eqn. (9.18), which occurs if $MS(T)$ is large, meaning the treatment effect is large, and / or $MS(TR) + \max \left (MS(TC) - MS(TRC),0  \right )$ is small, see comments following Eqn. (9.23). 
*	$\alpha$ is large: for then $F_{1-\alpha,ndf,ddf_H}$ decreases and is more likely to be exceeded by $F_{DBMH}$. 
*	ndf is large: the more the number of treatment pairings, the greater the chance that at least one pairing will reject the NH. 
* $ddf_H$	is large: this causes the critical value to decrease, see below, and is more likely to be exceeded by $F_{DBMH}$. 

#### Example 2: Code illustrating the F-distribution for different arguments
* See [BACKGROUND ON THE F-DISTRIBUTION].

#### p-value and confidence interval
**The p-value of the test is the probability, under the NH, that an equal or larger value of the F-statistic than $F_{DBMH}$  could occur by chance. In other words, it is the area under the (central) F-distribution $F_{ndf,ddf}$ that lies above the observed value $F_{DBMH}$:

\begin{equation*}
p=\Pr\left ( F > F_{DBMH} \mid F \sim F_{ndf,ddf_H} \right )
\end{equation*}

If $p < \alpha$ then the NH that all treatments are identical is rejected at significance level $\alpha$. That informs the researcher that there exists at least one treatment-pair that has a significant difference. To identify which pair(s) are different, one calculates confidence intervals for each paired difference. Hillis has shown that the $(1-\alpha)$ percent confidence interval for $Y_{i \bullet \bullet} - Y_{i' \bullet \bullet}$ is given by:

\begin{equation*}
CI_{1-\alpha}=\left ( Y_{i \bullet \bullet} - Y_{i' \bullet \bullet} \right ) \pm t_{\alpha/2;ddf_H} \sqrt{\frac{2}{JK}\left ( MS(TR) + \max\left ( MS(TC)-MS(TRC),0 \right ) \right )}
\end{equation*}

Here $t_{\alpha/2;ddf_H}$ is that value such that $\alpha/2$  of the *central t-distribution* with  $ddf_H$ degrees of freedom is contained in the upper tail of the distribution: 

\begin{equation*}
\Pr\left ( T>t_{\alpha/2;ddf_H} \right )=\alpha/2
\end{equation*}

Since centered pseudovalues were used:   

\begin{equation*}
\left ( Y_{i \bullet \bullet} - Y_{i' \bullet \bullet} \right )=\left ( \theta_{i \bullet } - \theta_{i' \bullet} \right )
\end{equation*}

Eqn. (9.28) can be rewritten:

\begin{equation*}
CI_{1-\alpha}=\left ( \theta_{i \bullet} - \theta_{i' \bullet} \right ) \pm t_{\alpha/2;ddf_H} \sqrt{\frac{2}{JK}\left ( MS(TR) + \max\left ( MS(TC)-MS(TRC),0 \right ) \right )}
\end{equation*}

For two treatments the following equivalent rules could be adopted to reject the NH: 

* $F_{DBMH} > F_{1-\alpha,ndf,ddf_H}$
* $p < \alpha$
* $CI_{1-alpha}$ excludes zero

For more than two treatments the first two rules are equivalent and if a significant difference is found using either of them, then one can use the confidence intervals to determine which treatment pair differences are significantly different from zero. In this book the first F-test is called the *overall F-test* and the subsequent tests the *treatment-pair t-tests*. One only conducts treatment pair t-tests if the overall F-test yields a significant result.

#### Example 3: Code illustrating the F-statistic, ddf and p-value for RRRC analysis, Van Dyke data


```r
alpha <- 0.05
retMS <- data.frame("msT" = msT, "msR" = msR, "msC" = msC, "msTR" = msTR, "msTC" = msTC, "msRC" = msRC, "msTRC" = msTRC)
F_DBMH_den <- retMS$msTR+max(retMS$msTC - retMS$msTRC,0) # den of Eqn. (9.23)
F_DBMH <- retMS$msT / F_DBMH_den # Eqn. (9.23)
ndf <- (I-1)
ddf_H <- F_DBMH_den^2/(retMS$msTR^2/((I-1)*(J-1))) # Eqn. (9.22)
FCrit <- qf(1 - alpha, ndf, ddf_H)
pValueH <- 1 - pf(F_DBMH, ndf, ddf_H)
retRJafroc <- StSignificanceTesting(dataset = dataset02, FOM = "Wilcoxon", method = "DBMH")
data.frame("F_DBMH" = F_DBMH, "ddf_H"= ddf_H, "pValueH" = pValueH)
#>     F_DBMH    ddf_H    pValueH
#> 1 4.456319 15.25967 0.05166569
data.frame("F_DBMH" = retRJafroc$FTestStatsRRRC$fRRRC, 
           "ddf_H"= retRJafroc$FTestStatsRRRC$ddfRRRC, 
           "pValueH" = retRJafroc$FTestStatsRRRC$pRRRC)
#>     F_DBMH    ddf_H    pValueH
#> 1 4.456319 15.25967 0.05166569
```

* The first output shows the values ($F_{DBMH}$, $ddf_H$, $p$) calculated by the above code, which closely follows the formulae in this chapter. The next output are the correponding variables yielded by `RJafroc`. 

* The FOM difference is not significant, whether viewed from the point of view of the F-statistic exceeding the critical value or the observed p-value being larger than alpha. 

#### Example 4: Code illustrating the confidence interval calculation for RRRC analysis, Van Dyke data


```r
theta <- UtilFigureOfMerit(dataset02, FOM = "Wilcoxon")
theta_i_dot <- array(dim = I)
for (i in 1:I) theta_i_dot[i] <- mean(theta[i,])
trtDiff <- array(dim = c(I,I))
for (i1 in 1:(I-1)) {    
  for (i2 in (i1+1):I) {
    trtDiff[i1,i2] <- theta_i_dot[i1]- theta_i_dot[i2]    
  }
}
trtDiff <- trtDiff[!is.na(trtDiff)]
nDiffs <- I*(I-1)/2
CI_DIFF_FOM_RRRC <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_RRRC[i,1] <- qt(alpha/2,df = ddf_H)*sqrt(2*F_DBMH_den/J/K) + trtDiff[i]
  CI_DIFF_FOM_RRRC[i,2] <- trtDiff[i]
  CI_DIFF_FOM_RRRC[i,3] <- qt(1-alpha/2,df = ddf_H)*sqrt(2*F_DBMH_den/J/K) + trtDiff[i]
  print(data.frame("Lower" = CI_DIFF_FOM_RRRC[i,1], 
                   "Mid" = CI_DIFF_FOM_RRRC[i,2], 
                   "Upper" = CI_DIFF_FOM_RRRC[i,3]))
}
#>        Lower         Mid        Upper
#> 1 -0.0879595 -0.04380032 0.0003588544
data.frame("Lower" = retRJafroc$ciDiffTrtRRRC$CILower, 
           "Mid" = retRJafroc$ciDiffTrtRRRC$Estimate, 
           "Upper" = retRJafroc$ciDiffTrtRRRC$CIUpper)
#>        Lower         Mid        Upper
#> 1 -0.0879595 -0.04380032 0.0003588544
```

* Again, the first row of output shows the Lower, the Mid-point and the Upper 95% confidence interval. The second row shows the corresponding RJafroc output.

* The FOM difference is not significant, whether viewed from the point of view of the F-statistic not exceeding the critical value, the observed p-value being larger than alpha or the 95% CI for the difference FOM including zero. 

## Fixed-reader random-case (FRRC) analysis
The model is the same as in Eqn. (9.4) except one puts $\sigma_{R}^{2}$ = $\sigma_{\tau R}^{2}$ = 0 in Table 9.1. The appropriate test statistic is: 

\begin{equation*}
\frac{E\left ( MS(T) \right )}{E\left ( MS(TC) \right )} = \frac{\sigma_{\epsilon}^{2}+\sigma_{\tau RC}^{2}+J\sigma_{\tau C}^{2}+JK\sigma_{\tau}^{2}}{\sigma_{\epsilon}^{2}+\sigma_{\tau RC}^{2}+J\sigma_{\tau C}^{2}}
\end{equation*}

Under the null hypothesis $\sigma_{\tau}^{2} = 0$:

\begin{equation*}
\frac{E\left ( MS(T) \right )}{E\left ( MS(TC) \right )} = 1
\end{equation*}

As before, one defines the F-statistic (by replacing *expected* with *observed* values) by

\begin{equation*}
F_{DBM|R}=\frac{MS(T)}{MS(TC)}
\end{equation*}

The observed value $F_{DBM|R}$ (the Roe-Metz notation [@RN1124] is used which indicates that the factor appearing to the right of the vertical bar is regarded as fixed) is distributed as an F-statistic with $\text{ndf}$ = $I – 1$ and $ddf = (I-1)(K-1)$; the degrees of freedom follow from the rows labeled $T$ and $TC$ in Table 9.1. Therefore, the distribution of the observed value is (no Satterthwaite approximation needed this time as both numerator and denominator are simple mean-squares):

\begin{equation*}
F_{DBM|R} \sim F_{I-1,(I-1)(K-1)}
\end{equation*}

The null hypothesis is rejected if the observed value of the F- statistic exceeds the critical value:

\begin{equation*}
F_{DBM|R} > F_{1-\alpha,I-1,(I-1)(K-1)}
\end{equation*}

The p-value of the test is the probability that a random sample from the F-distribution Eqn. (9.39), exceeds the observed value:

\begin{equation*}
p=\Pr\left ( F> F_{DBM|R} \mid F \sim F_{I-1,(I-1)(K-1)} \right )
\end{equation*}

The $(1-\alpha)$  confidence interval for the inter-treatment reader-averaged difference FOM is given by:

\begin{equation*}
CI_{1-\alpha}=\left ( \theta_{i \bullet} - \theta_{i' \bullet} \right ) \pm t_{\alpha/2,(I-1)(K-1)}\sqrt{2\frac{MS(T)}{JK}}
\end{equation*}

### Single-reader multiple-treatment analysis
With a single reader interpreting cases in two or more treatments, the reader factor must necessarily be regarded as fixed. The preceding analysis is applicable. One simply puts $J = 1$ in the equations above. 

#### Example 5: Code illustrating p-values for FRRC analysis, Van Dyke data

```r
FDbmFR <- retMS$msT / retMS$msTC
ndf <- (I-1); ddf <- (I-1)*(K-1)
pValue <- 1 - pf(FDbmFR, ndf, ddf)

std_DIFF_FOM_FRRC <- sqrt(2*retMS$msTC/J/K)
nDiffs <- I*(I-1)/2
CI_DIFF_FOM_FRRC <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_FRRC[i,1] <- qt(alpha/2,df = ddf)*std_DIFF_FOM_FRRC + trtDiff[i]
  CI_DIFF_FOM_FRRC[i,2] <- trtDiff[i]
  CI_DIFF_FOM_FRRC[i,3] <- qt(1-alpha/2,df = ddf)*std_DIFF_FOM_FRRC + trtDiff[i]
  print(data.frame("pValue" = pValue, 
                   "Lower" = CI_DIFF_FOM_FRRC[i,1], 
                   "Mid" = CI_DIFF_FOM_FRRC[i,2], 
                   "Upper" = CI_DIFF_FOM_FRRC[i,3]))
}
#>       pValue       Lower         Mid        Upper
#> 1 0.02103497 -0.08088303 -0.04380032 -0.006717613
data.frame("pValue" = retRJafroc$FTestStatsFRRC$pFRRC,
           "Lower" = retRJafroc$ciDiffTrtFRRC$CILower, 
           "Mid" = retRJafroc$ciDiffTrtFRRC$Estimate, 
           "Upper" = retRJafroc$ciDiffTrtFRRC$CIUpper)
#>       pValue       Lower         Mid        Upper
#> 1 0.02103497 -0.08088303 -0.04380032 -0.006717613
```

As one might expect, if one "freezes" reader variability, the FOM difference becomes significant, whether viewed from the point of view of the F-statistic exceeding the critical value, the observed p-value being smaller than alpha or the 95% CI for the difference FOM not including zero. 

## Random-reader fixed-case (RRFC) analysis
The model is the same as in Eqn. Eqn. (9.4) except one puts $\sigma_C^2 = \sigma_{\tau C}^2 =0$ in Table 9.1. It follows that: 

\begin{equation*}
\frac{E(MS(T))}{E(MS(TR))}=\frac{\sigma_\epsilon^2+\sigma_{\tau RC}^2+K\sigma_{\tau R}^2+JK\sigma_{\tau}^2}{\sigma_\epsilon^2+\sigma_{\tau RC}^2+K\sigma_{\tau R}^2}
\end{equation*}

Under the null hypothesis $\sigma_\tau^2 = 0$:

\begin{equation*}
\frac{E(MS(T))}{E(MS(TR))}=1
\end{equation*}

Therefore, one defines the F-statistic (replacing expected values with observed values) by:

\begin{equation*}
F_{DBM|C} \sim \frac{MS(T)}{MS(TR)}
\end{equation*}

The observed value $F_{DBM|C}$ is distributed as an F-statistic with $ndf = I – 1$ and $ddf = (I-1)(J-1)$, see rows labeled $T$ and $TR$ in Table 9.1.

\begin{equation*}
F_{DBM|C} \sim F_{I-1,(I-1)(J-1))}
\end{equation*}

The null hypothesis is rejected if the observed value of the F statistic exceeds the critical value:

\begin{equation*}
F_{DBM|C} > F_{1-\alpha,I-1,(I-1)(J-1))}
\end{equation*}

The p-value of the test is the probability that a random sample from the distribution exceeds the observed value:

\begin{equation*}
p=\Pr\left ( F>F_{DBM|C} \mid F \sim F_{I-1,(I-1)(J-1)} \right )
\end{equation*}

The confidence interval for inter-treatment differences is given by (TBA check this):

\begin{equation*}
CI_{1-\alpha}=\left ( \theta_{i \bullet} - \theta_{i' \bullet} \right ) \pm t_{\alpha/2,(I-1)(J-1)}\sqrt{2\frac{MS(TR)}{JK}}
\end{equation*}

#### Example 6: Code illustrating analysis for RRFC analysis, Van Dyke data


```r
FDbmFC <- retMS$msT / retMS$msTR
ndf <- (I-1)
ddf <- (I-1)*(J-1)
pValue <- 1 - pf(FDbmFC, ndf, ddf)

nDiffs <- I*(I-1)/2
CI_DIFF_FOM_RRFC <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_RRFC[i,1] <- qt(alpha/2,df = ddf)*sqrt(2*retMS$msTR/J/K) + trtDiff[i]
  CI_DIFF_FOM_RRFC[i,2] <- trtDiff[i]
  CI_DIFF_FOM_RRFC[i,3] <- qt(1-alpha/2,df = ddf)*sqrt(2*retMS$msTR/J/K) + trtDiff[i]
  print(data.frame("pValue" = pValue, 
                   "Lower" = CI_DIFF_FOM_RRFC[i,1], 
                   "Mid" = CI_DIFF_FOM_RRFC[i,2], 
                   "Upper" = CI_DIFF_FOM_RRFC[i,3]))
}
#>       pValue       Lower         Mid       Upper
#> 1 0.04195875 -0.08502022 -0.04380032 -0.00258042
data.frame("pValue" = retRJafroc$FTestStatsRRFC$pRRFC, 
           "Lower" = retRJafroc$ciDiffTrtRRFC$CILower, 
           "Mid" = retRJafroc$ciDiffTrtRRFC$Estimate, 
           "Upper" = retRJafroc$ciDiffTrtRRFC$CIUpper)
#>       pValue       Lower         Mid       Upper
#> 1 0.04195875 -0.08502022 -0.04380032 -0.00258042
```


## DBMH analysis: Example 1, Van Dyke Data


## DBMH analysis: Example 2, VolumeRad data


## Validation of DBMH analysis



## The meaning of pseudovalues


## Summary
This chapter has detailed analysis of MRMC ROC data using the DBMH method. A reason for the level of detail is that almost all of the material carries over to other data collection paradigms, and a thorough understanding of the relatively simple ROC paradigm data is helpful to understanding the more complex ones. 

DBMH has been used in several hundred ROC studies (Prof. Kevin Berbaum, private communication ca. 2010). While the method allows generalization of a study finding, e.g., rejection of the NH, to the population of readers and cases, the author believes this is sometimes taken too literally. If a study is done at a single hospital, then the radiologists tend to be more homogenous as compared to sampling radiologists from different hospitals. This is because close interactions between radiologists at a hospital tend to homogenize reading styles and performance. A similar issue applies to patient characteristics, which are also expected to vary more between different geographical locations than within a given location served by the hospital. This means is that single hospital study based p-values may tend to be biased downwards, declaring differences that may not be replicable if a wider sampling "net" were used using the same sample size. The price paid for a wider sampling net is that one must use more readers and cases to achieve the same sensitivity to genuine treatment effects, i.e., statistical power (i.e., there is no "free-lunch").

A third MRMC ROC method, due to Clarkson, Kupinski and Barrett19,20, implemented in open-source JAVA software by Gallas and colleagues22,44 (http://didsr.github.io/iMRMC/) is available on the web. Clarkson et al19,20 provide a probabilistic rationale for the DBM model, provided the figure of merit is the empirical $AUC$. The method is elegant but it is only applicable as long as one is using the empirical AUC as the figure of merit (FOM) for quantifying observer performance. In contrast the DBMH approach outlined in this chapter, and the approach outlined in the following chapter, are applicable to any scalar FOM. Broader applicability ensures that significance-testing methods described in this, and the following chapter, apply to other ROC FOMs, such as binormal model or other fitted AUCs, and more importantly, to other observer performance paradigms, such as free-response ROC paradigm. An advantage of the Clarkson et al. approach is that it predicts truth-state dependence of the variance components. One knows from modeling ROC data that diseased cases tend to have greater variance than non-diseased ones, and there is no reason to suspect that similar differences do not exist between the variance components. 

Testing validity of an analysis method via simulation testing is only as good as the simulator used to generate the datasets, and this is where current research is at a bottleneck. The simulator plays a central role in ROC analysis. In the author's opinion this is not widely appreciated. In contrast, simulators are taken very seriously in other disciplines, such as cosmology, high-energy physics and weather forecasting. The simulator used to validate3 DBMH is that proposed by Roe and Metz39 in 1997. This simulator has several shortcomings. (a) It assumes that the ratings are distributed like an equal-variance binormal model, which is not true for most clinical datasets (recall that the b-parameter of the binormal model is usually less than one). Work extending this simulator to unequal variance has been published3. (b) It does not take into account that some lesions are not visible, which is the basis of the contaminated binormal model (CBM). A CBM model based simulator would use equal variance distributions with the difference that the distribution for diseased cases would be a mixture distribution with two peaks. The radiological search model (RSM) of free-response data, Chapter 16 &17 also implies a mixture distribution for diseased cases, and it goes farther, as it predicts some cases yield no z-samples, which means they will always be rated in the lowest bin no matter how low the reporting threshold. Both CBM and RSM account for truth dependence by accounting for the underlying perceptual process. (c) The Roe-Metz simulator is out dated; the parameter values are based on datasets then available (prior to 1997). Medical imaging technology has changed substantially in the intervening decades. (d) Finally, the methodology used to arrive at the proposed parameter values is not clearly described. Needed is a more realistic simulator, incorporating knowledge from alternative ROC models and paradigms that is calibrated, by a clearly defined method, to current datasets. 

Since ROC studies in medical imaging have serious health-care related consequences, no method should be used unless it has been thoroughly validated. Much work still remains to be done in proper simulator design, on which validation is dependent.

## Things for me to think about
### Expected values of mean squares 

Assuming no replications the expected mean squares are as follows, Table 9.1; understanding how this table is derived, would lead the author well outside his expertise and the scope of this book; suffice to say that these are *unconstrained* estimates (as summarized in the quotation above) which are different from the *constrained* estimates appearing in the original DBM publication [@RN204], Table 9.2; the differences between these two types of estimates is summarized in [@RN2079]. For reference, Table 9.3 is the table published in the most recent paper that I am aware of [@RN2508]. All three tables are different! **In this chapter I will stick to Table 9.1 for the subsequent development.** 

Source          df               E(MS)
-------         ----             ------------------------------------------------------------
T               (I-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$ + $J\sigma_{\tau C}^{2}$ + $JK\sigma_{\tau}^{2}$ 
R               (J-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IK\sigma_{R}^{2}$ + $K\sigma_{\tau R}^{2}$
C               (K-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IJ\sigma_{C}^{2}$ + $J\sigma_{\tau C}^{2}$
TR              (I-1)(J-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$  
TC              (I-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $J\sigma_{\tau C}^{2}$
RC              (J-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ 
TRC             (I-1)(J-1)(K-1)  $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ 
$\epsilon$      $N-1=0$          $\sigma_{\epsilon}^{2}$

Table: Table 9.1 Unconstrained expected values of mean-squares, as in [@RN2079]

Source          df               E(MS)
-------         ----             ------------------------------------------------------------
T               (I-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$ + $J\sigma_{\tau C}^{2}$ + $JK\sigma_{\tau}^{2}$ 
R               (J-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IK\sigma_{R}^{2}$
C               (K-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IJ\sigma_{C}^{2}$
TR              (I-1)(J-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$  
TC              (I-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $J\sigma_{\tau C}^{2}$
RC              (J-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ 
TRC             (I-1)(J-1)(K-1)  $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ 
$\epsilon$      0                $\sigma_{\epsilon}^{2}$

Table: Table 9.2 Constrained expected values of mean-squares, as in [@RN204] 

Source          df               E(MS)
-------         ----             ------------------------------------------------------------
T               (I-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$ + $J\sigma_{\tau C}^{2}$ + $JK\sigma_{\tau}^{2}$ 
R               (J-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $I\sigma_{RC}^{2}$ + $IK\sigma_{R}^{2}$ + $K\sigma_{\tau R}^{2}$
C               (K-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $I\sigma_{RC}^{2}$ + $IJ\sigma_{C}^{2}$ + $J\sigma_{\tau C}^{2}$
TR              (I-1)(J-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$  
TC              (I-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $J\sigma_{\tau C}^{2}$
RC              (J-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $I\sigma_{RC}^{2}$ 
TRC             (I-1)(J-1)(K-1)  $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ 
$\epsilon$      0                $\sigma_{\epsilon}^{2}$

Table: Table 9.3 As in Hillis "marginal anova paper" [@RN2508]

## References  

