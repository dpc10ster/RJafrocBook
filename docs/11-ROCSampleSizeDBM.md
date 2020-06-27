---
output:
  pdf_document: default
  html_document: default
---
# Sample size estimation for ROC studies DBM method {#RocSampleSizeDBM}



## Introduction
The question addressed in this chapter is "how many readers and cases", usually abbreviated to "sample-size", should one employ to conduct a "well-planned" ROC study. The reasons for the quotes around "well-planned" will shortly become clear. If cost were no concern, the reply would be: "as many readers and cases as one can get". There are other causes affecting sample-size, e.g., the data collection paradigm and analysis, however, this chapter is restricted to the MRMC ROC data collection paradigm, with data analyzed by the DBMH or the ORH methods described in previous chapters. It turns out that provided one can specify conceptually valid effect-sizes between different paradigms (i.e., in the same "units"), the methods described in this chapter are extensible to other paradigms; see TBA Chapter 19 for sample size estimation for FROC studies. *For this reason it is important to understand the concepts of sample-size estimation in the simpler ROC context.*
 
For simplicity and practicality, this chapter is restricted to analysis of two-treatment data (I = 2). The purpose of most imaging system assessment studies is to determine, for a given diagnostic task, whether radiologists perform better using a new treatment over the conventional treatment, and whether the difference is statistically significant. Therefore, the two-treatment case is the most common one encountered. While it is possible to extend the methods to more than two treatments, the extensions are not, in my opinion, clinically interesting. 
	
Assume the figure of merit (FOM) $\theta$  is chosen to be the area AUC under the ROC curve (empirical or fitted is immaterial as far as the formulae are concerned; however, the choice will affect statistical power - the dependence has not been studied). The statistical analysis determines the significance level of the study, i.e., the probability or p-value for incorrectly rejecting the null hypothesis (NH) that the two  $\theta$s are equal: $NH: \theta_1 = \theta_2$, where the subscripts refer to the two treatments. If the p-value is smaller than a pre-specified $\alpha$, typically set at 5%, one rejects the NH and declares the treatments different at the $\alpha$ significance level. Statistical power is the probability of correctly rejecting the null hypothesis when the alternative hypothesis $AH: \theta_1 \neq  \theta_2$ is true, (TBA Chapter 08). 

The value of the *true* difference between the treatments, i.e., the *true effect-size* is, of course, unknown. If it were known, there would be no need to conduct the ROC study. One would simply adopt the treatment with the higher $\theta$. Sample-size estimation involves making an educated guess regarding the true effect-size , called the *anticipated effect size*, and denoted by $d$. To quote Harold Kundel [@RN1383]: "any calculation of power amounts to specification of the anticipated effect-size". Increasing the anticipated effect size  will increase statistical power but may represent an unrealistic expectation of the true difference between the treatments, in the sense that it overestimates the ability of technology to achieve this much improvement. An unduly small  might be clinically insignificant, besides requiring a very large sample-size to achieve sufficient statistical power. 

Statistical power depends on the magnitude of $d$ divided by the standard deviation $\sigma(d)$ of $d$, i.e. $D=\frac{\left | d \right |}{\sigma (d)}$. The sign is relevant as it determines whether the project is worth pursuing at all (see §11.8.4). The ratio is termed [@cohen1988statistical] Cohen's D. When this signal-to-noise-ratio-like quantity is large, statistical power approaches 100%. Reader and case variability and data correlations determine  $\sigma(d)$. No matter how small the anticipated $d$, as long as it is finite, then, using sufficient numbers of readers and cases  $\sigma(d)$ can be made sufficiently small to achieve near 100% statistical power. Of course, a very small effect-size may not be clinically significant. There is a key difference between statistical significance and clinical significance. An effect-size in AUC units could be so small, e.g., 0.001, as to be clinically insignificant, but by employing a sufficiently large sample size one could design a study to detect this small and clinically meaningless difference with near unit probability, i.e., high statistical power.

What determines clinical significance? A small effect-size, e.g., 0.01 AUC units, could be clinically significant if it applies to a large population, where the small benefit in detection rate is amplified by the number of patients benefiting from the new treatment. In contrast, for an "orphan" disease, i.e., one with very low prevalence, an effect-size of 0.05 might not be enough to justify the additional cost of the new treatment. The improvement might have to be 0.1 before it is worth it for a new treatment to be brought to market. One hates to monetize life and death issues, but there is no getting away from it, as cost/benefit issues determine clinical significance. The arbiters of clinical significance are engineers, imaging scientists, clinicians, epidemiologists, insurance companies and those who set government health care policies. The engineers and imaging scientists determine whether the effect-size the clinicians would like is feasible from technical and scientific viewpoints. The clinician determines, based on incidence of disease and other considerations, e.g., altruistic, malpractice, cost of the new device and insurance reimbursement, what effect-size is justifiable. Cohen has suggested that d values of 0.2, 0.5, and 0.8 be considered small, medium, and large, respectively, but he has also argued against their indiscriminate usage. However, after a study is completed, clinicians often find that an effect-size that biostatisticians label as small may, in certain circumstances, be clinically significant and an effect-size that they label as large may in other circumstances be clinically insignificant. Clearly, this is a complex issue. Some suggestions on choosing a clinically significant effect size are made in (TBA §11.12).

Having developed a new imaging modality the R&D team wishes to compare it to the existing standard with the short-term goal of making a submission to the FDA to allow them to perform pre-market testing of the device. The long-term goal is to commercialize the device. Assume the R&D team has optimized the device based on physical measurements, (TBA Chapter 01), perhaps supplemented with anecdotal feedback from clinicians based on a few images. Needed at this point is a pilot study. A pilot study, conducted with a relatively small and practical sample size, is intended to provide estimates of different sources of variability and correlations. It also provides an initial estimate of the effect-size, termed the *observed effect-size*, $d$. Based on results from the pilot the sample-size tools described in this chapter permit estimation of the numbers of readers and cases that will reduce $\sigma(d)$  sufficiently to achieve the desired power for the larger "pivotal" study. [A distinction could be made in the notation between observed and anticipated effect sizes, but it will be clear from the context. Later, it will be shown how one can make an educated guess about the anticipated effect size from an observed effect size.]
  
This chapter is concerned with multiple-reader MRMC studies that follow the fully crossed factorial design meaning that each reader interprets a common case-set in all treatments. Since the resulting pairings (i.e., correlations) tend to decrease $\sigma(d)$ (since the variations occur in tandem, they tend to cancel out in the difference, see (TBA Chapter 09, Introduction), for Dr. Robert Wagner's sailboat analogy) it yields more statistical power compared to an unpaired design, and consequently this design is frequently used. Two sample-size estimation procedures for MRMC are the Hillis-Berbaum method [@RN1476] and the Obuchowski-Rockette [@RN1971] method. With recent work by Hillis, the two methods have been shown to be substantially equivalent. 

This chapter will focus on the DBMH approach. Since it is based on a standard ANOVA model, it is easier to extend the NH testing procedure described in Chapter 09 to the alternative hypothesis, which is relevant for sample size estimation. [TBA Online Appendix 11.A shows how to translate the DBMH formulae to the ORH method [@RN2137].] 

Given an effect-size, and choosing this wisely is the most difficult part of the process, the method described in this chapter uses pseudovalue variance components estimated by the DBMH method to predict sample-sizes (i.e., different combinations of numbers of readers and cases) necessary to achieve a desired power. 

## Statistical Power {#StatPower1}
The concept of statistical power was introduced in [TBA Chapter 08] but it is worth repeating. There are two possible decisions following a test of a null hypothesis (NH): reject or fail to reject the NH. Each decision is associated with a probability on an erroneous conclusion. If the NH is true and one rejects it, the probability of the ensuing Type-I error is  $\alpha$. If the NH is false and one fails to reject it, the probability of the ensuing Type II- error is $\beta$. Statistical power is the complement of $\beta$, i.e., 

\begin{equation}
Power = 1 - \beta
(\#eq:DefinitionStatPower)
\end{equation}

Thus, statistical power is defined as the probability of correctly rejecting the null hypothesis when the null hypothesis is false. Typically, one aims for $\beta = 0.2$  or less, i.e., a statistical power of 80% or more. Again, like $\alpha$ = 0.05, this is a convention, and more nuanced cost-benefit considerations may cause the researcher to adopt a different value in the study design.

### Sample size estimation for random-reader random-cases
For convenience the DBMH model is repeated below with the case-set index suppressed:

\begin{equation}
Y_{n(ijk)}=\mu+\tau_i+R_j+C_k+(\tau R)_{ij}+(\tau C)_{ik}+(RC)_{jk}+(\tau RC)_{ijk}+\epsilon_ {n(ijk)}
(\#eq:DBMModel)
\end{equation}

As usual, the treatment effects $\tau_i$  are subject to the constraint that they sum to zero. The observed effect size (a random variable) is defined by:

\begin{equation}
d=\theta_{1\bullet}-\theta_{2\bullet}
(\#eq:EffectSize)
\end{equation}

It is a realization of a random variable, so one has some leeway in the choice of anticipated effect size. In the significance-testing procedure described in TBA Chapter 09 interest was in the distribution of the F-statistic when the NH is true. For sample size estimation, one needs to know the distribution of the statistic when the NH is false. It was shown that then the observed F-statistic TBA Eqn. (9.35) is distributed as a non-central F-distribution  $F_{ndf,ddf,\Delta}$ with non-centrality parameter $\Delta$: 

\begin{equation}
F_{DBM|AH} \sim F_{ndf,ddf,\Delta}
(\#eq:FDBMSampling)
\end{equation}

The non-centrality parameter   was defined, Eqn. TBA (9.34), by:

\begin{equation}
\Delta=\frac{JK\sigma_{Y;\tau}^2}{\left ( \sigma_{Y;\epsilon}^2 + \sigma_{Y;\tau RC}^2 \right )+K\sigma_{Y;\tau R}^2+J\sigma_{Y;\tau C}^2}
(\#eq:DefDelta)
\end{equation}

To minimize confusion, this equation has been rewritten here using the subscript $Y$ to explicitly denote pseudo-value derived quantities (in TBA Chapter 09 this subscript was suppressed. 

The estimate of $\sigma_{Y;\tau C}^2$ can turn out to bee negative. To avoid a negative denominator, Hillis suggests the following modification:

\begin{equation}
\Delta=\frac{JK\sigma_{Y;\tau}^2}{\left ( \sigma_{Y;\epsilon}^2 + \sigma_{Y;\tau RC}^2 \right )+K\sigma_{Y;\tau R}^2+\max \left (J\sigma_{Y;\tau C}^2 ,0 \right )}
(\#eq:DefDeltaHillis)
\end{equation}

This expression depends on three variance components, $(\sigma_{Y;\epsilon}^2 + \sigma_{Y;\tau RC}^2)$ - the two terms are inseparable - $\sigma_{Y;\tau R}^2$ and $\sigma_{Y;\tau C}^2$. The $ddf$ term appearing in TBA Eqn. (11.4) was defined by TBA Eqn. (9.24) - this quantity does not change between NH and AH:

\begin{equation}
ddf_H=\frac{\left [MSTR+\max(MSTR-MSTRC,0)  \right ]^2}{\frac{[MSTR]^2}{(I-1)(J-1)}}
(\#eq:ddfH)
\end{equation}

The mean squares in this expression can be expressed in terms of the three variance-components appearing in TBA Eqn. (11.6). Hillis and Berbaum [@RN1476] have derived these expression and they will not be repeated here (Eqn. 4 in the cited reference). RJafroc implements a function to calculate the mean squares, `UtilMeanSquares()`, which allows ddf to be calculated using Eqn. TBA (11.7). The sample size functions in this package need only the three variance-components (the formula for $ddf_H$ is implemented internally). 

For two treatments, since the individual treatment effects must be the negatives of each other (because they sum to zero), it is easily shown that:

\begin{equation}
\sigma_{Y;\tau}^2=\frac{d^2}{2}
(\#eq:sigma2Tau)
\end{equation}
 
Therefore, for two treatments the numerator of the expression for $\Delta$ becomes $JKd^2/2$. For three treatments, I = 3, assuming the reader-averaged FOMs are spaced at intervals of d, it is easily shown that the numerator of the expression for $\Delta$ becomes $2JKd^2$, which is 4 times the value for two treatments, meaning that power is expected to increase dramatically. This is consistent with the fact that with more treatment pairings, the chance that at least one pairing will turn out to be signficant increases. For the rest of the chapter it is assumed that one is limited to two treatments.

### Observed vs. anticipated effect-size
*Assuming no other similar studies have already been conducted with the treatments in question, the observed effect-size, although "merely an estimate", is the best information available at the end of the pilot study regarding the value of the true effect-size. From the two previous chapters one knows that the significance testing software will report not only the observed effect-size, but also a 95% confidence interval associate with it. It will be shown later how one can use this information to make an educated guess regarding the value of the anticipated effect-size.*

### Dependence of statistical power on estimates of model parameters
Examination of the expression for  , Eqn. (11.5), shows that statistical power increases if:
* The numerator is large. This occurs if: (a) the anticipated effect-size $d$ is large. Since effect-size enters as the *square*, TBA Eqn. (11.8), it is has a particularly strong effect; (b) If $J \times K$ is large. Both of these results should be obvious, as a large effect size and a large sample size should result in increased probability of rejecting the NH. 
* The denominator is small. The first term in the denominator is  $\left ( \sigma_{Y;\epsilon}^2 + \sigma_{Y;\tau RC}^2 \right )$. These two terms cannot be separated. This is the residual variability of the jackknife pseudovalues. It should make sense that the smaller the variability, the larger is the non-centrality parameter and the statistical power. 
* The next term in the denominator is $K\sigma_{Y;\tau R}^2$, the treatment-reader variance component multiplied by the total number of cases. The reader variance $\sigma_{Y;R}^2$ has no effect on statistical power, because it has an equal effect on both treatments and cancels out in the difference. Instead, it is the treatment-reader variance $\sigma_{Y;R}^2$  that contributes "noise" tending to confound the estimate of the effect-size. 
* The variance components estimated by the ANOVA procedure are realizations of random variables and as such subject to noise (there actually exists a beast such as variance of a variance). The presence of the $K$ term, usually large, can amplify the effect of noise in the estimate of $\sigma_{Y;R}^2$, making the sample size estimation procedure less accurate.
* The final term in the denominator is  $J\sigma_{Y;\tau C}^2$. The variance $\sigma_{Y;C}^2$ has no impact on statistical power, as it cancels out in the difference. The treatment-case variance component introduces "noise" into the estimate of the effect size, thereby decreasing power. Since it is multiplied by J, the number of readers, and typically $J<<K$, the error amplification effect on accuracy of the sample size estimate is not as bad as with the treatment-reader variance component.
* Accuracy of sample size estimation, essentially estimating confidence intervals for statistical power, is addressed in [@RN2027].

### Formulae for random-reader random-case (RRRC) sample size estimation


### Significance testing

### p-value and confidence interval

### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments
Having performed a pilot study and planning to perform a pivotal study, sample size estimation follows the following procedure, which assumes that both reader and case are treated as random factors. Different formulae, described later, apply when either reader or case is treated as a fixed factor.

* Perform DBMH analysis on the pilot data. This yields the observed effect size as well as estimates of all relevant variance components and mean squares appearing in TBA Eqn. (11.5) and Eqn. (11.7).
* This is the difficult but critical part: make an educated guess regarding the effect-size, $d$, that one is interested in "detecting" (i.e., hoping to reject the NH with probability $1-\beta$). The author prefers the term "anticipated" effect-size to "true" effect-size (the latter implies knowledge of the true difference between the modalities which, as noted earlier, would obviate the need for a pivotal study). 
* Two scenarios are considered below. In the first scenario, the effect-size is assumed equal to that observed in the pilot study, i.e., $d = d_{obs}$. 
* In the second, so-called "best-case" scenario, one assumes that the anticipate value of $d$ is the observed value plus two-sigma of the confidence interval, in the correct direction, of course, i.e., $d=\left | d_{obs} \right |+2\sigma$. Here $\sigma$ is one-fourth the width of the 95% confidence interval for $d_{obs}$. Anticipating more than $2\sigma$  greater than the observed effect-size would be overly optimistic. The width of the CI implies that chances are less than 2.5% that the anticipated value is at or beyond the overly optimistic value. These points will become clearer when example datasets are analyzed below.
*	Calculate statistical power using the distribution implied by Eqn. (11.4), to calculate the probability that a random value of the relevant F-statistic will exceed the critical value, as in §11.3.2.
* If power is below the desired or "target" power, one tries successively larger value of $J$ and / or $K$ until the target power is reached. 


## Formulae for fixed-reader random-case (FRRC) sample size estimation
It was shown in TBA §9.8.2 that for fixed-reader analysis the non-centrality parameter is defined by:

\begin{equation}
\Delta=\frac{JK\sigma_{Y;\tau}^2}{\sigma_{Y;\epsilon}^2+\sigma_{Y;\tau RC}^2+J\sigma_{Y;\tau C}^2}
(\#eq:DeltaFRRC)
\end{equation}

The sampling distribution of the F-statistic under the AH is:

\begin{equation}
F_{AH|R}\equiv \frac{MST}{MSTC}\sim F_{I-1,(I-1)(K-1),\Delta}
(\#eq:SamplingFFRRC)
\end{equation}

### Formulae for random-reader fixed-case (RRFC) sample size estimation
It is shown in TBA §9.9 that for fixed-case analysis the non-centrality parameter is defined by:

\begin{equation}
\Delta=\frac{JK\sigma_{Y;\tau}^2}{\sigma_{Y;\epsilon}^2+\sigma_{Y;\tau RC}^2+K\sigma_{Y;\tau R}^2}
(\#eq:DeltaFRRFC)
\end{equation}

Under the AH, the test statistic is distributed as a non-central F-distribution as follows:

\begin{equation}
F_{AH|C}\equiv \frac{MST}{MSTR}\sim F_{I-1,(I-1)(J-1),\Delta}
(\#eq:SamplingFRRFC)
\end{equation}

### Example 1
In the first example the Van Dyke dataset is regarded as a pilot study. Two implementations are shown, a direct application of the relevant formulae, including usage of the mean squares, which in principle can be calculated from the three variance-components. This is then compared to the `RJafroc` implementation. 

Shown first is the "open" implementation. 


```r
alpha <- 0.05;cat("alpha = ", alpha, "\n")
#> alpha =  0.05
rocData <- dataset02 # select Van Dyke dataset
retDbm <- StSignificanceTesting(dataset = rocData, FOM = "Wilcoxon", method = "DBM") 
varYTR <- retDbm$ANOVA$VarCom["VarTR","Estimates"]
varYTC <- retDbm$ANOVA$VarCom["VarTC","Estimates"]
varYEps <- retDbm$ANOVA$VarCom["VarErr","Estimates"]
effectSize <- retDbm$FOMs$trtMeanDiffs["trt0-trt1","Estimate"]
cat("effect size = ", effectSize, "\n")
#> effect size =  -0.043800322

#RRRC
J <- 10; K <- 163
ncp <- (0.5*J*K*(effectSize)^2)/(K*varYTR+max(J*varYTC,0)+varYEps)
MS <- UtilMeanSquares(rocData, FOM = "Wilcoxon", method = "DBM")
ddf <- (MS$msTR+max(MS$msTC-MS$msTRC,0))^2/(MS$msTR^2)*(J-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power <- 1-pf(FCrit, 1, ddf, ncp = ncp)
data.frame("J"= J,  "K" = K, "FCrit" = FCrit, "ddf" = ddf, "ncp" = ncp, "RRRCPower" = Power)
#>    J   K     FCrit       ddf       ncp  RRRCPower
#> 1 10 163 4.1270572 34.334268 8.1269825 0.79111255

#FRRC
J <- 10; K <- 133
ncp <- (0.5*J*K*(effectSize)^2)/(max(J*varYTC,0)+varYEps)
ddf <- (K-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power <- 1-pf(FCrit, 1, ddf, ncp = ncp)
data.frame("J"= J,  "K" = K, "FCrit" = FCrit, "ddf" = ddf, "ncp" = ncp, "RRRCPower" = Power)
#>    J   K    FCrit ddf       ncp  RRRCPower
#> 1 10 133 3.912875 132 7.9873835 0.80111671

#RRFC
J <- 10; K <- 53
ncp <- (0.5*J*K*(effectSize)^2)/(K*varYTR+varYEps)
ddf <- (J-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power <- 1-pf(FCrit, 1, ddf, ncp = ncp)
data.frame("J"= J,  "K" = K, "FCrit" = FCrit, "ddf" = ddf, "ncp" = ncp, "RRRCPower" = Power)
#>    J  K    FCrit ddf       ncp  RRRCPower
#> 1 10 53 5.117355   9 10.048716 0.80496663
```

For 10 readers, the numbers of cases needed for 80% power is largest (163) for RRRC and least for RRFC (53). For all three analyses, the expectation of 80% power is met - the numbers of cases and readers were chosen to achieve close to 80% statistical power. Intermediate quantities such as the critical value of the F-statistic, `ddf` and `ncp` are shown. The reader should confirm that the code does in fact implement the relevant formulae. Shown next is the `RJafroc` implementation. The relevant file is mainSsDbmh.R, a listing of which follows: 

### Fixed-reader random-case (FRRC) analysis

### Random-reader fixed-case (RRFC) analysis

### Single-treatment multiple-reader analysis

## Discussion/Summary

## References  

