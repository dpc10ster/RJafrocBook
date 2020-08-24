---
output:
  pdf_document: default
  html_document: default
---
# Illustrations of the OR method {#ORExamples}



## Introduction {#ORExamples-introduction}
* Two examples are given. In the first example we use the VanDyke dataset, i.e., `dataset02`. 
* The analysis involves the following steps: calculate the figure of merit, calculate the variance-covariance matrix and the mean-squares, and calculate the NH statistic, p-value and confidence interval(s).

### Figures of merit

```r
foms <- UtilFigureOfMerit(dataset02, FOM = "Wilcoxon")
print(foms)
#>           rdr0      rdr1      rdr2      rdr3      rdr4
#> trt0 0.9196457 0.8587762 0.9038647 0.9731079 0.8297907
#> trt1 0.9478261 0.9053140 0.9217391 0.9993559 0.9299517
```

### Variance covariance and mean-squares

```r
ret <- UtilORVarComponentsFactorial(dataset02, FOM = "Wilcoxon", covEstMethod = "jackknife")
print(ret)
#> $TRanova
#>             SS DF           MS
#> T  0.004796171  1 0.0047961705
#> R  0.015344800  4 0.0038362000
#> TR 0.002204122  4 0.0005510306
#> 
#> $VarCom
#>          Estimates      Rhos
#> VarR  0.0015349993        NA
#> VarTR 0.0002004025        NA
#> Cov1  0.0003466137 0.4320314
#> Cov2  0.0003440748 0.4288668
#> Cov3  0.0002390284 0.2979333
#> Var   0.0008022883        NA
#> 
#> $IndividualTrt
#>      DF  msREachTrt   varEachTrt  cov2EachTrt
#> trt0  4 0.003082629 0.0010141028 0.0004839618
#> trt1  4 0.001304602 0.0005904738 0.0002041879
#> 
#> $IndividualRdr
#>      DF   msTEachRdr   varEachRdr  cov1EachRdr
#> rdr0  1 0.0003970662 0.0006989006 3.734661e-04
#> rdr1  1 0.0010828854 0.0011060528 7.601598e-04
#> rdr2  1 0.0001597470 0.0008423434 3.553224e-04
#> rdr3  1 0.0003444784 0.0001505777 1.083399e-06
#> rdr4  1 0.0050161160 0.0012135668 2.430368e-04
```

## Random-Reader Random-Case (RRRC) analysis
Illustrated next are the results of random-reader random-case analysis.

### Calculate F-statistic
The F-statistic is calculated using \@ref(eq:F-ORH-RRRC). The function `UtilORVarComponentsFactorial()` returns `ret`, which contains the values needed in this equation, as follows:

* MS(T) is in `ret$TRanova["T", "MS"]`, whose value is 0.0047962. 
* MS(TR) is in `ret$TRanova["TR", "MS"]`, whose value is 5.5103062\times 10^{-4}. 
* `J`, the number of readers, is the length of the second dimension of `dataset02$ratings$NL`, i.e., 5. 
* `Cov2` is in `ret$VarCom["Cov2", "Estimates"]`, whose value is 3.4407483\times 10^{-4}. 
* `Cov3` is in `ret$VarCom["Cov3", "Estimates"]`, whose value is 2.3902837\times 10^{-4}. 

Applying Eqn. \@ref(eq:F-ORH-RRRC) one gets (`den` is the denominator on the right hand side of this equation):


```r
J <- length(dataset02$ratings$NL[1,,1,1])
den <- ret$TRanova["TR", "MS"] + J* max(ret$VarCom["Cov2", "Estimates"] - ret$VarCom["Cov3", "Estimates"],0)
F_ORH_RRRC <- ret$TRanova["T", "MS"]/den
print(F_ORH_RRRC)
#> [1] 4.456319
```

### Calculate ddf_H
From the previous chapter, the Hillis `ddf` is calculated using Eqn. \@ref(eq:ddfH-RRRC)). The numerator of `ddf` is seen to be identical to `den^2`, where `den` was calculated in the preceding code block. The implementation follows:


```r
I <- length(dataset02$ratings$NL[,1,1,1])
ddf <- den^2*(I-1)*(J-1)/(ret$TRanova["TR", "MS"])^2
print(ddf)
#> [1] 15.25967
```

### Calculate the p-value
The relevant equation is Eqn. \@ref(eq:pValueOR-RRRC) whose implementation is shown next: 


```r
p <- 1 - pf(F_ORH_RRRC, I - 1, ddf)
print(p)
#> [1] 0.05166569
```

The difference is not significant at $\alpha$ = 0.05.

### Confidence intervals for reader-averaged inter-treatment FOM differences
Since `I` = 2, their is only one paired difference in reader-averaged FOMs, namely, the first treatment minus the second:


```r
trtMeans <- rowMeans(foms)
trtMeanDiffs <- trtMeans[1] - trtMeans[2]
print(trtMeanDiffs)
#>        trt0 
#> -0.04380032
```

From the previous chapter, the $(1-\alpha)$ confidence interval for $\theta_{1 \bullet} - \theta_{2 \bullet}$ is given by Eqn. \@ref(eq:CI-RRRC). The expression inside the square-root symbol is `2/J*den`. The implementation follows:


```r
alpha <- 0.05
stdErr <- sqrt(2 * den/J)
t_crit <- abs(qt(alpha/2, ddf))
CI_RRRC <- c(trtMeanDiffs - t_crit*stdErr, trtMeanDiffs + t_crit*stdErr)
names(CI_RRRC) <- c("Lower", "Right")
print(CI_RRRC)
#>         Lower         Right 
#> -0.0879594986  0.0003588544
```

The confidence interval, shown as `[Lower, Right]`, includes zero, which confirms that the reader-averaged FOM difference between treatments is not significant. 

## Comparison to RJafroc
* This is accomplished using the significance testing function of `RJafroc`, namely `StSignificanceTesting()`. 
* This function takes as arguments the `dataset`, the `FOM`, set to "Wilcoxon", the method of analysis, set to "OR" in this example, and `analysisOption`, set to "RRRC". The significance level of the test, `alpha`, defaults to 0.05. 
* The code below applies this function and saves the returned object to `st`. 
* The first member of this object, a  `list` object named `FOMs`, is then displayed. 
* `FOMs` contains three data frames: 
   + `FOMS$foms`, the figures of merit for each treatment and reader, 
   + `FOMS$trtMeans`, the figures of merit for each treatment averaged over readers, and 
   + `FOMS$trtMeanDiffs`, the inter-treatment difference figures of merit averaged over readers. The difference is always the first treatment minus the second, etc., in this example, `trt0` minus `trt1`.


```r
st <- StSignificanceTesting(dataset02, FOM = "Wilcoxon", method = "OR", analysisOption = "RRRC")
print(st$FOMs)
#> $foms
#>            rdr0       rdr1       rdr2       rdr3       rdr4
#> trt0 0.91964573 0.85877617 0.90386473 0.97310789 0.82979066
#> trt1 0.94782609 0.90531401 0.92173913 0.99935588 0.92995169
#> 
#> $trtMeans
#>        Estimate
#> trt0 0.89703704
#> trt1 0.94083736
#> 
#> $trtMeanDiffs
#>               Estimate
#> trt0-trt1 -0.043800322
```

* Displayed next are the variance components and mean-squares. 
* These are contained in the `ANOVA` `list` object. 
* `ANOVA$TRanova` contains the treatment-reader ANOVA table, i.e. the sum of squares, the degrees of freedom and the mean-squares, listed for the treatment, reader and treatment-reader factors, i.e., `T`, `R` and `TR`.
* `ANOVA$VarCom` contains the OR variance components and the correlations.
* `ANOVA$IndividualTrt` contains the quantities necessary for individual treatment analyses.
* `ANOVA$IndividualRdr` contains the quantities necessary for individual reader analyses.


```r
print(st$ANOVA)
#> $TRanova
#>              SS DF            MS
#> T  0.0047961705  1 0.00479617053
#> R  0.0153448000  4 0.00383619999
#> TR 0.0022041225  4 0.00055103062
#> 
#> $VarCom
#>           Estimates       Rhos
#> VarR  0.00153499935         NA
#> VarTR 0.00020040252         NA
#> Cov1  0.00034661371 0.43203138
#> Cov2  0.00034407483 0.42886683
#> Cov3  0.00023902837 0.29793328
#> Var   0.00080228827         NA
#> 
#> $IndividualTrt
#>      DF   msREachTrt    varEachTrt   cov2EachTrt
#> trt0  4 0.0030826287 0.00101410277 0.00048396180
#> trt1  4 0.0013046019 0.00059047376 0.00020418785
#> 
#> $IndividualRdr
#>      DF    msTEachRdr    varEachRdr   cov1EachRdr
#> rdr0  1 0.00039706618 0.00069890056 3.7346610e-04
#> rdr1  1 0.00108288538 0.00110605283 7.6015978e-04
#> rdr2  1 0.00015974702 0.00084234345 3.5532241e-04
#> rdr3  1 0.00034447841 0.00015057773 1.0833995e-06
#> rdr4  1 0.00501611603 0.00121356676 2.4303685e-04
```

* Displayed next are the results of RRRC analysis.
* These are contained in the `RRRC` `list` object.
* `RRRC$FTests` contains the results of the F-tests.
* `RRRC$ciDiffTrt` contains the results of the confidence intervals for the inter-treatment difference FOMs, averaged over readers.
* `RRRC$ciAvgRdrEachTrt` contains the results of the confidence intervals for the treatments, averaged over readers.


```r
print(st$RRRC)
#> $FTests
#>                  DF           MS     FStat           p
#> Treatment  1.000000 0.0047961705 4.4563187 0.051665686
#> Error     15.259675 0.0010762629        NA          NA
#> 
#> $ciDiffTrt
#>               Estimate      StdErr        DF          t       PrGTt
#> trt0-trt1 -0.043800322 0.020748618 15.259675 -2.1109995 0.051665686
#>                CILower       CIUpper
#> trt0-trt1 -0.087959499 0.00035885444
#> 
#> $ciAvgRdrEachTrt
#>        Estimate      StdErr        DF    CILower    CIUpper          Cov2
#> trt0 0.89703704 0.033173597 12.744648 0.82522360 0.96885048 0.00048396180
#> trt1 0.94083736 0.021566368 12.710190 0.89413783 0.98753689 0.00020418785
```


## Discussion/Summary/5


## References {#ORExamples-references}

