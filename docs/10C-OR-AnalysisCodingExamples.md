---
output:
  pdf_document: default
  html_document: default
---
# Coding illustrations of the OR method {#ORAnalysisCodingExamples}



## Introduction
It is time to reinforce the formulae with examples. We illustrate for the VanDyke dataset, i.e., `dataset02`. 

### Calculate figures of merit

```r
foms <- UtilFigureOfMerit(dataset02, FOM = "Wilcoxon")
print(foms)
#>           rdr0      rdr1      rdr2      rdr3      rdr4
#> trt0 0.9196457 0.8587762 0.9038647 0.9731079 0.8297907
#> trt1 0.9478261 0.9053140 0.9217391 0.9993559 0.9299517
```

### Calculate variance covariance and mean-squares

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

### Calculate F-statistic
From the previous chapter, the F-statistic is calculated using:

\begin{equation}
F_{ORH}=\frac{MS(T)}{MS(TR)+J\max(Cov_2-Cov_3,0)}
(\#eq:F-OR-H-Code)
\end{equation}

* MS(T) is in `ret$TRanova["T", "MS"]`, whose value is 0.0047962. 
* MS(TR) is in `ret$TRanova["TR", "MS"]`, whose value is 5.5103062\times 10^{-4}. 
* The value of `J`, the number of readers, is the length of the second dimension of `dataset02$ratings$NL[1,,1,1]`, which is 5. 
* The value of `Cov2` is in `ret$VarCom["Cov2", "Estimates"]`, whose value is 3.4407483\times 10^{-4}. 
* The value of `Cov3` is in `ret$VarCom["Cov3", "Estimates"]`, whose value is 2.3902837\times 10^{-4}. 

Applying Eqn. \@ref(eq:F-OR-H-Code) one gets (`den` is the denominator in Eqn. \@ref(eq:F-OR-H-Code)):


```r
J <- length(dataset02$ratings$NL[1,,1,1])
den <- ret$TRanova["TR", "MS"] + J* max(ret$VarCom["Cov2", "Estimates"] - ret$VarCom["Cov3", "Estimates"],0)
F_ORH <- ret$TRanova["T", "MS"]/den
print(F_ORH)
#> [1] 4.456319
```

### Calculate ddf_H
From the previous chapter, the Hillis `ddf` is calculated using:

\begin{equation}
\text{ddf}_H = \frac{\left [ MS(TR) + J \max(Cov_2-Cov_3,0)\right ]^2}{\frac{\left [ MS(TR) \right ]^2}{(I-1)(J-1)}}
(\#eq:ddfH-Code)
\end{equation}

The numerator of `ddf` is seen to be identical to `den^2`. Therefore, the implementation is as follows:


```r
I <- length(dataset02$ratings$NL[,1,1,1])
ddf <- den^2*(I-1)*(J-1)/(ret$TRanova["TR", "MS"])^2
print(ddf)
#> [1] 15.25967
```

### Calculate the p-value
This is the probability that a sample from $F_{I-1,ddf}$ exceeds the observed value of the statistic, `F_ORH` =  4.4563187. This is calculated as follows:


```r
p <- 1 - pf(F_ORH, I - 1, ddf)
print(p)
#> [1] 0.05166569
```

The difference is not significant at $\alpha$ = 0.05.

### Calculate confidence intervals for reader-averaged inter-treatment differences
Since `I` = 2, their is only one difference in reader-averaged FOMs, namely, the first treatment minus the second:


```r
trtMeans <- rowMeans(foms)
trtMeanDiffs <- trtMeans[1] - trtMeans[2]
print(trtMeanDiffs)
#>        trt0 
#> -0.04380032
```

From the previous chapter, the $(1-\alpha)$ confidence interval for $\theta_{i \bullet} - \theta_{i' \bullet}$ is given by (the average is over the reader index):

\begin{equation}
CI_{1-\alpha,RRRC}=\theta_{i \bullet} - \theta_{i' \bullet} \pm t_{\alpha/2, ddf_H}\sqrt{\frac{2}{J}(MS(TR)+J\max(Cov_2-Cov_3,0))}
(\#eq:CIalpha-RRRC-Code)
\end{equation}

The expression inside the square-root symbol is `2/J*den`. The implementation follows:


```r
alpha <- 0.05
stdErr <- sqrt(2 * den/J)
t_crit <- abs(qt(alpha/2, ddf))
CI <- c(trtMeanDiffs - t_crit*stdErr, trtMeanDiffs + t_crit*stdErr)
names(CI) <- c("Lower", "Right")
print(CI)
#>         Lower         Right 
#> -0.0879594986  0.0003588544
```

The confidence interval, shown as `[Lower, Right]`, includes zero, which confirms that the reader-averaged FOM difference between treatments is not significant. 

## Discussion/Summary/5


## References  

