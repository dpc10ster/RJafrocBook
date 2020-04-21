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

\begin{equation}
\theta_{i\{c\}}=\mu+\tau_i+\epsilon_{i\{c\}}
(\#eq:ORModel1RMT)
\end{equation}

*In the Obuchowski and Rockette method [@RN1450] one models the figure-of-merit, not the pseudovalues, indeed this is one of the key differences from the DBMH method.*

Recall that $\{c\}$ denotes a *set of cases*. Eqn. (10.1) models the observed figure-of-merit $\theta_{i\{c\}}$ as a constant term $\mu$ plus a treatment dependent term $\tau_i$ (the treatment-effect) with the constraint: 

\begin{equation}
\sum_{i=1}^{I}\tau_i=0
(\#eq:ConstraintTau)
\end{equation}

The *c-index* was introduced in (book) Chapter 07. The left hand side of Eqn. (10.1) is the figure-of-merit $\theta_i\{c\}$ for treatment $i$ and case-set index $\{c\}$, where $c$ = 1, 2, ..., $C$ denotes different independent case-sets sampled from the population, i.e., different collections of $K_1$ non-diseased and $K_2$ diseased cases, *not individual cases*.

*This is one place the case-set index is essential for clarity; without it $\theta_i$ is a fixed quantity - the figure of merit estimate for treatment $i$ - lacking any index allowing for sampling related variability.* 

Obuchowski and Rockette use a *k-index*, defined as the “kth repetition of the study involving the same diagnostic test, reader and patient (sic)”. In the author's opinion, what is meant is a case-set index instead of a repetition index. Repeating a study with the same treatment, reader and cases yields *within-reader* variability, which is different from sampling the population of cases with new case-sets, which yields *case-sampling plus within-reader* variability. As noted earlier, within-reader variability cannot be "turned off" and affects the interpretations of all case-sets. 

*Interest is in extrapolating to the population of cases and the only way to do this is to sample different case-sets. It is shown below that usage of the case-set index interpretation yields the same results using the DBMH or the ORH methods.*

Finally, and this is where I had some difficulty understanding what is going on, there is an additive random error term   whose sampling behavior is described by a multivariate normal distribution with an I-dimensional zero mean vector and an I x I dimensional covariance matrix  $\Sigma$:

\begin{equation}
\epsilon_{i\{c\}} \sim N_I\left ( \vec{0} ,  \Sigma\right )
(\#eq:DefinitionEpsilon)
\end{equation}

Here $N_I$ is the I-variate normal distribution (i.e., each sample yields $I$ random numbers). Obuchowski and Rockette assumed the following structure for the covariance matrix (they describe a more general model, but here one restricts to the simpler one):

\begin{equation}
\Sigma=Cov\left ( \epsilon_{i\{c\}}, \epsilon_{i'\{c\}} \right )\\
=Var \Rightarrow i=i'\\
=Cov_1 \Rightarrow i\neq i'
(\#eq:DefinitionSigma)
\end{equation}

The reason for the subscript "1" in $Cov_1$  will become clear when one extends this model to multiple readers. The $I \times I$ covariance matrix $\Sigma$  is: 

\begin{equation}
\Sigma=
\begin{pmatrix}
Var & Cov_1   & \ldots & Cov_1 & Cov_1 \\
Cov_1 & Var   & \ldots &Cov_1 & Cov_1 \\
\vdots & \vdots & \vdots & \vdots & \vdots \\
Cov_1 & Cov_1 & \ldots & Var & Cov_1 \\
Cov_1 & Cov_1 & \ldots & Cov_1 & Var
\end{pmatrix}
(\#eq:ExampleSigma)
\end{equation}

If $I$ = 2 then $\Sigma$  is a symmetric 2 x 2 matrix, whose diagonal terms are the common variances in the two treatments (each assumed equal to $Var$) and whose off-diagonal terms (each assumed equal to  $Cov_1$) are the co-variances. With $I$ = 3 one has a 3 x 3 symmetric matrix with all diagonal elements equal to $Var$ and all off-diagonal terms are equal to $Cov_1$, etc. 

*An important aspect of the Obuchowski and Rockette model is that the variances and co-variances are assumed to be treatment independent. This implies that $Var$ estimates need to be averaged over all treatments. Likewise,  $Cov_1$ estimates need to be averaged over all distinct treatment-treatment pairings.*

A more complex model, with more parameters and therefore more difficult to work with, would allow the variances to be treatment dependent, and the covariances to depend on the specific treatment pairings. For obvious reasons ("Occam's Razor" or the law of parsimony ) one wishes to start with the simplest model that, one hopes, captures essential characteristics of the data.

Some elementary statistical results are presented next.

### Definitions of covariance and correlation

The covariance of two scalar random variables X and Y is defined by:

\begin{equation}
Cov(x,y) =\frac{\sum_{i=1}^{N}(x_{i}-x_{\bullet})(y_{i}-y_{\bullet})}{N-1}=E(XY)-E(X)-E(Y)
(\#eq:DefinitionCovariance)
\end{equation}

Here $E*X)$ is the expectation value of the random variable $X$, i.e., the integral of x multiplied by its $pdf$: 

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

\begin{equation}
Var(X-Y)=Var(X)+Var(Y)-2Cov(X,Y)=2(Var-Cov)
(\#eq:UsefulTheorem)
\end{equation}

The first line of the above equation is general, the second line specializes to the OR single-reader multiple-treatment model where the variances are equal and likewise all covariances in Eqn. (10.5) are equal) The correlation  $\rho_1$ is defined by (the reason for the subscript 1 on $\rho$  is the same as the reason for the subscript 1 on  $Cov_1$, which will be explained later): 

$$\rho_1=\frac{Cov_1}{Var}$$

The I x I covariance matrix $\Sigma$  can be written alternatively as (shown below is the matrix for I = 5; as the matrix is symmetric one need only show elements at and above the diagonal): 

\begin{equation}
\Sigma = 
\begin{bmatrix}
\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
& \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
&  & \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
&  &  & \sigma^2 & \rho_1\sigma^2\\
&  &  &  & \sigma^2
\end{bmatrix}
(\#eq:ExampleSigmaRho)
\end{equation}

### Estimation of the covariance matrix
An unbiased estimate of the covariance Eqn. (10.4) follows from:

\begin{equation}
\Sigma_{ii'}=\frac{1}{C-1}\sum_{c=1}^{C} \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)
(\#eq:EstimateSigmaPopulation)
\end{equation}

Sampling different case-sets, as required by Eqn. (10.16), is unrealistic and in reality one is stuck with $C$ = 1, i.e., a single dataset. Therefore direct application of this formula is impossible. However, as seen when this situation was encountered before in (book) Chapter 07, one uses resampling methods to realize, for example, different bootstrap samples, which are resampling-based “stand-ins” for actual case-sets. If $B$ is the number of bootstraps, then the estimation formula is:

\begin{equation}
\Sigma_{ii'}\mid_{bs} =\frac{1}{B-1}\sum_{b=1}^{B} \left ( \theta_{i\{b\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{b\}} - \theta_{i'\{\bullet\}} \right)
(\#eq:EstimateSigmaBootstrap)
\end{equation}

The bootstrap method of estimating the covariance matrix, Eqn. (10.17), is a direct translation of Eqn. (10.16). Alternatively, one could have used the jackknife FOM values $\theta_{i(k)}$, i.e., the figure of merit with a particular case removed, for all cases, to estimate the covariance matrix:

\begin{equation}
\Sigma_{ii'}\mid_{jk} =\frac{(K-1)^2}{K} \left [ \frac{1}{K-1}\sum_{k=1}^{K} \left ( \theta_{i\{k\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{k\}} - \theta_{i'\{\bullet\}} \right) \right ]
(\#eq:EstimateSigmaJackknife)
\end{equation}

For simplicity, in this section we depart from the usual two-subscript convention to index each case. So $k$ ranges from 1 to $K$, where the first $K_1$ values represent non-diseased and the following $K_2$  values represent diseased cases. Jackknife figure of merit values are not to be confused with jackknife pseudovalues. The jackknife FOM value corresponding to a particular case is the FOM with the particular case removed. Unlike pseudovalues, jackknife FOM values cannot be regarded as independent and identically distributed. Notice the use of the subscript enclosed in parenthesis $(k)$ to denote the FOM with case $k$ removed, i.e., a single case, while in the bootstrap equation one uses the curly brackets  $\{b\}$ to denote the bth bootstrap *case-set*, i.e., a whole set of $K_1$ non-diseased and $K_2$ diseased cases, sampled with replacement from the original dataset. Furthermore, the expression for the jackknife covariance contains a *variance inflation factor*:

\begin{equation}
\frac{(K-1)^2}{K}
(\#eq:JKVarianceInflationFactor)
\end{equation}

This factor multiplies the traditional expression for the covariance, shown in square brackets in Eqn. (10.18). A third method of estimating the covariance, namely the DeLong et al. method [@RN112], applicable only to the empirical AUC, is described later.

### Meaning of the covariance matrix in Eqn. (10.5)
Suppose one has the luxury of repeatedly sampling case-sets, each consisting of $K$ cases from the population. A single radiologist interprets these cases in $I$ treatments. Therefore, each case-set $\{c\}$ yields $I$ figures of merit. The final numbers at ones disposal are $\theta_{i\{c\}}$, where $i$ = 1,2,...,$I$ and $c$ = 1,2,...,$C$. Considering treatment $i$, the variance of the FOM-values for the different case-sets $c$ = 1,2,...,$C$, is an estimate of $Var_i$ for this treatment: 

\begin{equation}
\sigma_i^2 \equiv Var_i = \frac{1}{C-1}\sum_{c=1}^{C}\left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right)
(\#eq:EstimateVari)
\end{equation}


The process is repeated for all treatments and the $I$-variance values are averaged. This is the final estimate of $Var$ appearing in \@ref(eq:DefinitionEpsilon). 

To estimate the covariance matrix one considers pairs of FOM values for the same case-set $\{c\}$  but different treatments, i.e., $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$; *by definition primed and un-primed indices are different*. Since they are derived from the same case-set, one expects the values to be correlated. For a particularly easy case-set one expects all I-estimates to be collectively higher than usual. The process is repeated for different case-sets and one calculates the correlation $\rho_{1;ii'}$  between the two $C$-length arrays $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$: 

\begin{equation}
\rho_{1;ii'} = \frac{1}{C-1}\sum_{c=1}^{C} \frac {\left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)}{\sigma_i \sigma_{i'} }
(\#eq:EstimateRho)
\end{equation}

The entire process is repeated for different treatment pairings and the resulting $I(I-1)/2$  distinct values are averaged yielding the final estimate of $\rho_1$  in Eqn. (10.15). According to Eqn. (10.14) one expects the covariance to be smaller than the variance determined as in the previous paragraph. 

In most situations one expects $\rho_1$ (for ROC studies) to be positive. There is, perhaps unlikely, a scenario that could lead to anti-correlation and negative. This could occur, with "complementary" treatments, e.g., CT vs. MRI, where one treatment is good for bone imaging and the other for soft-tissue imaging. In this situation what constitutes an easy case-set in one treatment could be a difficult case-set in the other treatment.

### Code illustrating the covariance matrix

As indicated above, the covariance matrix can be estimated using the jackknife or the bootstrap. If the figure of merit is the Wilcoxon statistic, then one can also use the DeLong et al method [@RN112]. In Chapter 07, these methods were described in the context of estimating the variance of AUC. Eqn. (10.17) and Eqn. (10.18) extend the jackknife and the bootstrap methods, respectively, to estimating the covariance of AUC (whose diagonal elements are the variances estimated in the earlier chapter). The extension of the DeLong method to covariances is described in Online Appendix 10.A and implemented in file VarCovMtrxDLStr.R. It has been confirmed by the author that the implementation of the DeLong method [@RN112] in file VarCovMtrxDLStr.R gives identical results to those yielded by the SAS macro attributed to DeLong. The file name stands for "variance covariance matrix according to the DeLong structural components method" described in five unnumbered equation following Eqn. 4 in the cited reference.

The jackknife, bootstrap and the DeLong methods are used in file mainVarCov1.R, a listing and explanation of which appears in Online Appendix 10.B. Source the file yielding the following code output:













```r
seed <- 1;set.seed(seed)
jSelect <- 1  # selects the reader to be analyzed
rocData1R <- DfExtractDataset(dataset02, rdrs = jSelect)

zik1 <- rocData1R$NL[,1,,1];K <- dim(zik1)[2];I <- dim(zik1)[1]
zik2 <- rocData1R$LL[,1,,1];K2 <- dim(zik2)[2];K1 <- K-K2;zik1 <- zik1[,1:K1]

# jk = jackknife
# rjjk = RJafroc, covEstMethod = "jackknife"
# rjbs = RJafroc, covEstMethod = "bootstrap"
# bs = bootstrap
# dl = DeLong
ret1 <- VarCov1_Jk(zik1, zik2)
Var <- ret1$Var;Cov1 <- ret1$Cov1 # use these (i.e., jackknife) as default values 
data.frame ("Cov_jk" = Cov1, "Var_jk" = Var)
#>         Cov_jk       Var_jk
#> 1 0.0003734661 0.0006989006

ret4 <- UtilVarComponentsOR(rocData1R, FOM = "Wilcoxon")$varComp
data.frame ("Cov_rjjk" = ret4$cov1, "Var_rjjk" = ret4$var)
#>       Cov_rjjk     Var_rjjk
#> 1 0.0003734661 0.0006989006

ret2 <- VarCov1_Bs(zik1, zik2) 
data.frame ("Cov_bs" = ret2$Cov1, "Var_bs" = ret2$Var) # local code uses 2000 nBoots
#>         Cov_bs       Var_bs
#> 1 0.0003466804 0.0006738506

ret5 <- UtilVarComponentsOR(rocData1R, FOM = "Wilcoxon", covEstMethod = "bootstrap", nBoots = 200)$varComp
data.frame ("Cov_rjbs" = ret5$cov1, "Var_rjbs" = ret5$var)
#>      Cov_rjbs     Var_rjbs
#> 1 0.000283905 0.0005845354

ret5 <- UtilVarComponentsOR(rocData1R, FOM = "Wilcoxon", covEstMethod = "bootstrap", nBoots = 2000)$varComp
data.frame ("Cov_rjbs" = ret5$cov1, "Var_rjbs" = ret5$var) # matches local code with 2000 nBoots, provided seeds are identical
#>       Cov_rjbs     Var_rjbs
#> 1 0.0003466804 0.0006738506

ret5 <- UtilVarComponentsOR(rocData1R, FOM = "Wilcoxon", covEstMethod = "bootstrap", nBoots = 20000)$varComp
data.frame ("Cov_rjbs" = ret5$cov1, "Var_rjbs" = ret5$var)
#>       Cov_rjbs     Var_rjbs
#> 1 0.0003680714 0.0006862668

mtrxDLStr <- VarCovMtrxDLStr(rocData1R)
ret3 <- VarCovs(mtrxDLStr)

data.frame ("Cov_dl" = ret3$cov1, "Var_dl" = ret3$var)
#>         Cov_dl       Var_dl
#> 1 0.0003684357 0.0006900766
```
### TBA Discussion of above code

## Significance testing
The covariance matrix is needed for significance testing. Define the mean square corresponding to the treatment effect, denoted $MS(T)$, by:

\begin{equation}
MS(T)=\frac{1}{I-1}\sum_{i=1}^{I}(\theta_i-\theta_\bullet)^2
(\#eq:DefinitionMST)
\end{equation}

*Unlike the previous chapter, all mean square quantities defined in this chapter are based on FOMs; specifically, they are not based on pseudovalues. Converting between them is described in Ref. 1-3 and is implemented in the RJafroc package.*

It can be shown [@RN1772] that under the null hypothesis that all treatments have identical performances, the test statistic $F_{1R}$ defined below (the $1R$ subscript is meant to denote single-reader analysis) is distributed approximately as a $\chi^2$ distribution with $I-1$ degrees of freedom, i.e., 

\begin{equation}
F_{1R} \equiv \frac{(I-1)MS(T)}{Var-Cov_1} \sim \chi_{I-1}^{2}
(\#eq:F1RMT)
\end{equation}

\@ref(eq:F1RMT) is from §5.4 [@RN1865] with two other covariance terms "zeroed out" because they are multiplied by a zero (since we are restricting to $J=1$). 

The $\chi_{ndf}^2$ distribution is related to the F-distribution $F_{ndf,\infty}$:

\begin{equation}
\frac{\chi_{ndf}^{2}}{I-1} \equiv F_{ndf,\infty}
(\#eq:Chisqr2F)
\end{equation}

Dividing a $\chi^2$ distributed random variable with $ndf$ degrees of freedom which is divided by $ndf$ yields an F-distributed random variable with $\text{ndf}$ and $ddf=\infty$, as in \@ref(eq:Chisqr2F). Here is an `R` example: 


```r
pf(3.1,4,Inf)
#> [1] 0.9853881
pchisq(3.1*4,4)
#> [1] 0.9853881
```

The first form shows that the CDF of the F-distribution with 4 and infinite degrees of freedom at 3.1 equals the CDF of the $\chi_2$ distribution with 4 degrees of freedom at 3.1 times 4. A little "mulling over it" should convince the reader about the truth of these statements.

The p-value is the probability that a sample from the $F_{I-1,\infty}$ distribution is greater than or equal to the observed value of the test statistic, namely: 

\begin{equation}
p\equiv \Pr(f>F_{1R} \mid f \sim F_{I-1,\infty})
(\#eq:pValue1RMT)
\end{equation}

The $(1-\alpha)$  confidence interval for the inter-treatment FOM difference is given by:

\begin{equation}
CI_{1-\alpha} = (\theta_{i\bullet} - \theta_{i'\bullet}) \pm t_{\alpha/2,\infty} \sqrt{2(Var-Cov_1)}
(\#eq:CIValue1RMT)
\end{equation}

Comparing \@ref(eq:CIValue1RMT) to \@ref(eq:UsefulTheorem) shows that the term $\sqrt{2(Var-Cov_1)}$ is the standard error of the inter-treatment FOM difference, whose square root is the standard deviation. The term $t_{\alpha/2,\infty}$ is -1.96 and $t_{1-\alpha/2,\infty}$ is +1.96. Therefore, the confidence interval is constructed by adding and subtracting 1.96 times the standard deviation of the difference from the central value. All this should should make sense. One has probably encountered the rule that a 95% confidence interval is plus or minus two standard deviations from the central value. The "2" comes from rounding up 1.96. 

### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments
We have shown two methods for analyzing a single reader in multiple treatments: the DBMH method, involving jackknife derived pseudovalues and the Obuchowski and Rockette method that does not have to use the jackknife, since it could use the bootstrap to get the covariance matrix, or some other methods such as the DeLong method, if one restricts to the Wilcoxon statistic for the figure of merit (empirical ROC-AUC). Since one is dealing with a single reader in multiple treatments, for DBMH one needs the fixed-reader analysis described in §9.8 the previous chapter (with just one reader the conclusions apply to the specific reader, so reader must be a fixed factor). Source the file MainOrDbmh1R.R, a listing of which appears in Online Appendix 10.C. For convenience, a few relevant lines are shown here:


```r
# seed <- 1;set.seed(seed)
alpha <- 0.05
theta_i <- c(0,0);for (i in 1:I) theta_i[i] <- Wilcoxon(zik1[i,], zik2[i,])

MS_T <- 0;MS_T <- MS_T + sum((theta_i[i]-mean(theta_i))^2);MS_T <- MS_T/(I-1)

F_1R <- MS_T/(Var - Cov1)
pValue <- 1 - pf(F_1R, I-1, Inf)

trtDiff <- array(dim = c(I,I))
for (i1 in 1:(I-1)) {    
  for (i2 in (i1+1):I) {
    trtDiff[i1,i2] <- theta_i[i1]- theta_i[i2]    
  }
}
trtDiff <- trtDiff[!is.na(trtDiff)]
nDiffs <- I*(I-1)/2
CI_DIFF_FOM_1RMT <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_1RMT[i,1] <- qt(alpha/2,df = Inf)*sqrt(2*(Var - Cov1)) + trtDiff[i]
  CI_DIFF_FOM_1RMT[i,2] <- trtDiff[i]
  CI_DIFF_FOM_1RMT[i,3] <- qt(1-alpha/2,df = Inf)*sqrt(2*(Var - Cov1)) + trtDiff[i]
  print(data.frame("F_1R" = F_1R, 
                   "pValue" = pValue,
                   "Lower" = CI_DIFF_FOM_1RMT[i,1], 
                   "Mid" = CI_DIFF_FOM_1RMT[i,2], 
                   "Upper" = CI_DIFF_FOM_1RMT[i,3]))
}
#>        F_1R    pValue       Lower         Mid      Upper
#> 1 0.6100555 0.4347669 -0.07818322 -0.02818035 0.02182251

# StSignificanceTestingSingleFixedFactor(rocData1R, FOM = "Wilcoxon")

# cat("DBMH: F-stat = ", ret1$fFRRC, ", ddf = ", ret1$ddfFRRC, ", P-val = ", ret1$pFRRC,"\n")
# 
# ret2 <- SignificanceTesting(rocData1R,FOM = "Wilcoxon", method = "ORH", option = "FRRC")
# cat("ORH (Jackknife):  F-stat = ", ret2$fFRRC, ", ddf = ", ret2$ddfFRRC, ", P-val = ", ret2$pFRRC,"\n")
# 
# ret3 <- SignificanceTesting(rocData1R,FOM = "Wilcoxon", method = "ORH", option = "FRRC", 
#                             covEstMethod = "DeLong")
# cat("ORH (DeLong):  F-stat = ", ret3$fFRRC, ", ddf = ", ret3$ddfFRRC, ", P-val = ", ret3$pFRRC,"\n")
# 
# ret4 <- SignificanceTesting(rocData1R,FOM = "Wilcoxon", method = "ORH", option = "FRRC", 
#                             covEstMethod = "Bootstrap")
# cat("ORH (Bootstrap):  F-stat = ", ret4$fFRRC, ", ddf = ", ret4$ddfFRRC, ", P-val = ", ret4$pFRRC,"\n")
# 
# 
# data.frame ("Cov_rjbs" = ret5$cov1, "Var_rjbs" = ret5$var) # matches local code with 2000 nBoots, provided seeds are identical
# 
# ret5 <- UtilVarComponentsOR(rocData1R, FOM = "Wilcoxon", covEstMethod = "bootstrap", nBoots = 20000)$varComp
# data.frame ("Cov_rjbs" = ret5$cov1, "Var_rjbs" = ret5$var)
# 
# mtrxDLStr <- VarCovMtrxDLStr(rocData1R)
# ret3 <- VarCovs(mtrxDLStr)
# 
# data.frame ("Cov_dl" = ret3$cov1, "Var_dl" = ret3$var)
```


## References  

