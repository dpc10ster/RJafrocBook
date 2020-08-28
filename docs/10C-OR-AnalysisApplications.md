---
output:
  pdf_document: default
  html_document: default
---
# Applications using the Obuchowski Rockette method {#ORApplications} 



## Introduction {#ORApplications-introduction}  

This chapter illustrates Obuchowski-Rockette analysis with several examples. The first example is a full-blown "hand-calculation" for `dataset02`, showing explicit implementations of formulae presented in the previous chapter. The second example shows application of the `RJafroc` package function `StSignificanceTesting()` to the same dataset: this function encapsulates all formulae and accomplishes all analyses with one function call. The third example shows application of the `StSignificanceTesting()` function to an ROC dataset derived from the Federica Zanca dataset [@RN1882], which has five modalities and four readers. This illustrates multiple treatment pairings (in contrast, `dataset02` has only one treatment pairing). The fourth example shows application of `StSignificanceTesting()` to `dataset04`, which is an **FROC** dataset (in contrast to the previous examples, which employed **ROC** datasets). It illustrates the key difference involved in FROC analysis, namely the choice of figure of merit. The final example again uses `dataset04`, i.e., FROC data, *but this time we use DBM analysis*. Since DBM analysis is pseudovalue based, and the figure of merit is not the empirical AUC under the ROC, one may expect to see differences from the previously presented OR analysis on the same dataset.

Each analysis involves the following steps: 

* Calculate the figure of merit; 
* Calculate the variance-covariance matrix and mean-squares;
* Calculate the NH statistic, p-value and confidence interval(s).
* For each analysis, three sub-analyses are shown: 
    + random-reader random-case (RRRC),
    + fixed-reader random-case (FRRC), and
    + random-reader fixed-case (RRFC).

## Hand calculation using dataset02 {#ORApplications-dataset02-hand}

Dataset `dataset02` is well-know in the literature [@RN1993] as it has been widely used to illustrate advances in ROC methodology. The following code extract the numbers of modalities, readers and cases for `dataset02` and defines strings `modalityID`, `readerID` and `diffTRName` that are needed for the hand-calculations.


```r
I <- length(dataset02$ratings$NL[,1,1,1])
J <- length(dataset02$ratings$NL[1,,1,1])
K <- length(dataset02$ratings$NL[1,1,,1])
modalityID <- dataset02$descriptions$modalityID
readerID <- dataset02$descriptions$readerID
diffTRName <- array(dim = choose(I, 2))
ii <- 1
for (i in 1:I) {
  if (i == I) 
    break
  for (ip in (i + 1):I) {
    diffTRName[ii] <- 
      paste0("trt", modalityID[i], 
             sep = "-", "trt", modalityID[ip])
    ii <- ii + 1
  }
}
```

The dataset consists of I = 2 treatments,  J = 5 readers and  K = 114 cases.

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset02-hand}
* The first step is to calculate the figures of merit using `UtilFigureOfMerit()`. 
* Note that the `FOM` argument has to be explicitly specified as there is no default.


```r
foms <- UtilFigureOfMerit(dataset02, FOM = "Wilcoxon")
print(foms)
#>           rdr0      rdr1      rdr2      rdr3      rdr4
#> trt0 0.9196457 0.8587762 0.9038647 0.9731079 0.8297907
#> trt1 0.9478261 0.9053140 0.9217391 0.9993559 0.9299517
```

* For example, for the first treatment, `"trt0"`, the second reader `"rdr1"` figure of merit is 0.8587762.
* The next step is to calculate the variance-covariance matrix and the mean-squares.
* The function `UtilORVarComponentsFactorial()` returns these quantities, which are saved to `vc`. 
* The `Factorial` in the function name is because this code applies to the factorial design. A different function is used for a split-plot design.


```r
vc <- UtilORVarComponentsFactorial(
  dataset02, FOM = "Wilcoxon", covEstMethod = "jackknife")
print(vc)
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

* The next step is the calculate the NH testing statistic. 
* The relevant equation is Eqn. \@ref(eq:F-ORH-RRRC). 
* `vc` contains the values needed in this equation, as follows:
    + MS(T) is in `vc$TRanova["T", "MS"]`, whose value is 0.0047962. 
    + MS(TR) is in `vc$TRanova["TR", "MS"]`, whose value is \ensuremath{5.5103062\times 10^{-4}}. 
    + `Cov2` is in `vc$VarCom["Cov2", "Estimates"]`, whose value is \ensuremath{3.4407483\times 10^{-4}}. 
    + `Cov3` is in `vc$VarCom["Cov3", "Estimates"]`, whose value is \ensuremath{2.3902837\times 10^{-4}}. 

Applying Eqn. \@ref(eq:F-ORH-RRRC) one gets (`den` is the denominator on the right hand side of the referenced equation) and F_ORH_RRRC is the value of the F-statistic:


```r
den <- vc$TRanova["TR", "MS"] + 
  J* max(vc$VarCom["Cov2", "Estimates"] - 
           vc$VarCom["Cov3", "Estimates"],0)
F_ORH_RRRC <- vc$TRanova["T", "MS"]/den
print(F_ORH_RRRC)
#> [1] 4.456319
```

* The F-statistic has numerator degrees of freedom $\text{ndf} = I - 1$ and denominator degrees of freedom, `ddf`, to be calculated next.
* From the previous chapter, `ddf` is calculated using Eqn. \@ref(eq:ddfH-RRRC)). The numerator of `ddf` is identical to `den^2`, where `den` was calculated in the preceding code block. The implementation follows:


```r
ddf <- den^2*(I-1)*(J-1)/(vc$TRanova["TR", "MS"])^2
print(ddf)
#> [1] 15.25967
```

* The next step is calculation of the p-value for rejecting the NH
* The relevant equation is Eqn. \@ref(eq:pValueOR-RRRC) whose implementation follows: 


```r
p <- 1 - pf(F_ORH_RRRC, I - 1, ddf)
print(p)
#> [1] 0.05166569
```

* The difference is not significant at $\alpha$ = 0.05. 
* The next step is to calculate confidence intervals.
* Since `I` = 2, their is only one paired difference in reader-averaged FOMs, namely, the first treatment minus the second.


```r
trtMeans <- rowMeans(foms)
trtMeanDiffs <- trtMeans[1] - trtMeans[2]
names(trtMeanDiffs) <- "trt0-trt1"
print(trtMeans)
#>      trt0      trt1 
#> 0.8970370 0.9408374
print(trtMeanDiffs)
#>   trt0-trt1 
#> -0.04380032
```

* `trtMeans`contains the reader-averaged figures of merit for each treatment.
* `trtMeanDiffs`contains the reader-averaged difference figure of merit.
* From the previous chapter, the $(1-\alpha)$ confidence interval for $\theta_{1 \bullet} - \theta_{2 \bullet}$ is given by Eqn. \@ref(eq:CI-DiffFomRRRC), in which equation the expression inside the square-root symbol is `2/J*den`. 
* $\alpha$, the significance level of the test, is set to 0.05. 
* The implementation follows:


```r
alpha <- 0.05
stdErr <- sqrt(2/J*den)
t_crit <- abs(qt(alpha/2, ddf))
CI_RRRC <- c(trtMeanDiffs - t_crit*stdErr, 
             trtMeanDiffs + t_crit*stdErr)
names(CI_RRRC) <- c("Lower", "Upper")
print(CI_RRRC)
#>         Lower         Upper 
#> -0.0879594986  0.0003588544
```

The confidence interval includes zero, which confirms the F-statistic finding that the reader-averaged FOM difference between treatments is not significant. 

Calculated next is the confidence interval for the reader-averaged FOM for each treatment, i.e. $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$. The relevant equations are Eqn. \@ref(eq:CI-RRRC-df-IndvlTrt) and Eqn. \@ref(eq:CI-RRRC-IndvlTrt). The implementation follows:


```r
df_i <- array(dim = I)
den_i <- array(dim = I)
stdErr_i <- array(dim = I)
ci <- array(dim = c(I, 2))
CI_RRRC_IndvlTrt <- data.frame()
for (i in 1:I) {
  den_i[i] <- vc$IndividualTrt[i, "msREachTrt"] + 
    J * max(vc$IndividualTrt[i, "cov2EachTrt"], 0)
  df_i[i] <- 
    (den_i[i])^2/(vc$IndividualTrt[i, "msREachTrt"])^2 * (J - 1)
  stdErr_i[i] <- sqrt(den_i[i]/J)
  ci[i,] <- 
    c(trtMeans[i] + qt(alpha/2, df_i[i]) * stdErr_i[i], 
      trtMeans[i] + qt(1-alpha/2, df_i[i]) * stdErr_i[i])
  rowName <- paste0("trt", modalityID[i])
  CI_RRRC_IndvlTrt <- rbind(
    CI_RRRC_IndvlTrt, 
    data.frame(Estimate = trtMeans[i], 
               StdErr = stdErr_i[i],
               DFi = df_i[i],
               CILower = ci[i,1],
               CIUpper = ci[i,2],
               Cov2i = vc$IndividualTrt[i,"cov2EachTrt"],
               row.names = rowName,
               stringsAsFactors = FALSE))
}
print(CI_RRRC_IndvlTrt)
#>       Estimate     StdErr      DFi   CILower   CIUpper        Cov2i
#> trt0 0.8970370 0.03317360 12.74465 0.8252236 0.9688505 0.0004839618
#> trt1 0.9408374 0.02156637 12.71019 0.8941378 0.9875369 0.0002041879
```


### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset02-hand}
* The chi-square statistic is calculated using Eqn. \@ref(eq:DefFStatFRRC-OR) and Eqn. \@ref(eq:ChisqStatFRRC-OR). 
* The needed quantities are in `vc`. 
* For example, MS(T) is in vc$TRanova["T", "MS"], see above. Likewise for `Cov2` and `Cov3`.
* The remaining needed quantities are:
+ `Var` is in `vc$VarCom["Var", "Estimates"]`, whose value is \ensuremath{8.0228827\times 10^{-4}}. 
+ `Cov1` is in `vc$VarCom["Cov1", "Estimates"]`, whose value is \ensuremath{3.4661371\times 10^{-4}}. 
* The degree of freedom is $I-1$.
* The implementation follows:


```r
den_FRRC <- vc$VarCom["Var","Estimates"] - 
  vc$VarCom["Cov1","Estimates"] + 
  (J - 1) * max(vc$VarCom["Cov2","Estimates"] - 
                  vc$VarCom["Cov3","Estimates"] ,0)
chisqVal <- (I-1)*vc$TRanova["T","MS"]/den_FRRC
p <- 1 - pchisq(chisqVal, I - 1)
FTests <- data.frame(MS = c(vc$TRanova["T", "MS"], den_FRRC),
                     Chisq = c(chisqVal,NA),
                     DF = c(I - 1, NA),
                     p = c(p,NA),
                     row.names = c("Treatment", "Error"),
                     stringsAsFactors = FALSE)
print(FTests)
#>                     MS    Chisq DF          p
#> Treatment 0.0047961705 5.475953  1 0.01927984
#> Error     0.0008758604       NA NA         NA
```

* Since p < 0.05, one has a significant finding. 
* Freezing reader variability shows a significant difference between the treatments. 
* The downside is that the conclusion applies only to the readers used in the study.
* The next step is to calculate the confidence interval for the reader-averaged FOM difference, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* The relevant equation is Eqn. \@ref(eq:CIDiffFomFRRC-OR), whose implementation follows.


```r
stdErr <- sqrt(2 * den_FRRC/J)
zStat <- vector()
PrGTz <- vector()
CI <- array(dim = c(choose(I,2),2))
for (i in 1:choose(I,2)) {
  zStat[i] <- trtMeanDiffs[i]/stdErr
  PrGTz[i] <- 2 * pnorm(abs(zStat[i]), lower.tail = FALSE)
  CI[i, ] <- c(trtMeanDiffs[i] + qnorm(alpha/2) * stdErr, 
               trtMeanDiffs[i] + qnorm(1-alpha/2) * stdErr)
}
ciDiffTrtFRRC <- data.frame(Estimate = trtMeanDiffs, 
                            StdErr = rep(stdErr, choose(I, 2)),
                            z = zStat, 
                            PrGTz = PrGTz, 
                            CILower = CI[,1],
                            CIUpper = CI[,2], 
                            row.names = diffTRName,
                            stringsAsFactors = FALSE)
print(ciDiffTrtFRRC)
#>              Estimate     StdErr         z      PrGTz     CILower     CIUpper
#> trt0-trt1 -0.04380032 0.01871748 -2.340075 0.01927984 -0.08048591 -0.00711473
```

* Consistent with the chi-square statistic significant finding, one finds that the treatment difference confidence interval does not include zero.
* The next step is to calculate the confidence interval for the reader-averaged figures of merit for each treatment, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.
* The relevant formula is in Eqn. \@ref(eq:CIIndTrtFomFRRC-OR), whose implementation follows:


```r
stdErr <- vector()
df <- vector()
CI <- array(dim = c(I,2))
ciAvgRdrEachTrt <- data.frame()
for (i in 1:I) {
  df[i] <- K - 1
  stdErr[i] <- 
    sqrt((vc$IndividualTrt[i,"varEachTrt"] + 
            (J-1)*max(vc$IndividualTrt[i,"cov2EachTrt"],0))/J)
  CI[i, ] <- c(trtMeans[i] + qnorm(alpha/2) * stdErr[i],
               trtMeans[i] + qnorm(1-alpha/2) * stdErr[i])
  rowName <- paste0("trt", modalityID[i])
  ciAvgRdrEachTrt <- 
    rbind(ciAvgRdrEachTrt, 
          data.frame(Estimate = trtMeans[i], 
                     StdErr = stdErr[i],
                     DF = df[i],
                     CILower = CI[i,1],
                     CIUpper = CI[i,2],
                     row.names = rowName,
                     stringsAsFactors = FALSE))
}
print(ciAvgRdrEachTrt)
#>       Estimate     StdErr  DF   CILower   CIUpper
#> trt0 0.8970370 0.02428971 113 0.8494301 0.9446440
#> trt1 0.9408374 0.01677632 113 0.9079564 0.9737183
```
* Finally, one calculates confidence intervals for the FOM differences for individual readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}}$. 
* The relevant formula is in Eqn. \@ref(eq:CIIndRdrDiffFomFRRC-OR), whose implementation follows:


```r
trtMeanDiffs1 <- array(dim = c(J, choose(I, 2)))
Reader <- array(dim = c(J, choose(I, 2)))
stdErr <- array(dim = c(J, choose(I, 2)))
zStat <- array(dim = c(J, choose(I, 2)))
trDiffNames <- array(dim = c(J, choose(I, 2)))
PrGTz <- array(dim = c(J, choose(I, 2)))
CIReader <- array(dim = c(J, choose(I, 2),2))
ciDiffTrtEachRdr <- data.frame()
for (j in 1:J) {
  Reader[j,] <- rep(readerID[j], choose(I, 2))
  stdErr[j,] <- 
    sqrt(
      2 * 
        (vc$IndividualRdr[j,"varEachRdr"] - 
           vc$IndividualRdr[j,"cov1EachRdr"]))
  pair <- 1
  for (i in 1:I) {
    if (i == I) break
    for (ip in (i + 1):I) {
      trtMeanDiffs1[j, pair] <- foms[i, j] - foms[ip, j]
      trDiffNames[j,pair] <- diffTRName[pair]
      zStat[j,pair] <- trtMeanDiffs1[j,pair]/stdErr[j,pair]
      PrGTz[j,pair] <- 
        2 * pnorm(abs(zStat[j,pair]), lower.tail = FALSE)
      CIReader[j, pair,] <- 
        c(trtMeanDiffs1[j,pair] + 
            qnorm(alpha/2) * stdErr[j,pair], 
          trtMeanDiffs1[j,pair] + 
            qnorm(1-alpha/2) * stdErr[j,pair])
      rowName <- 
        paste0("rdr", Reader[j,pair], "::", trDiffNames[j, pair])
      ciDiffTrtEachRdr <- rbind(
        ciDiffTrtEachRdr, 
        data.frame(Estimate = trtMeanDiffs1[j, pair], 
                   StdErr = stdErr[j,pair], 
                   z = zStat[j, pair], 
                   PrGTz = PrGTz[j, pair], 
                   CILower = CIReader[j, pair,1],
                   CIUpper = CIReader[j, pair,2],
                   row.names = rowName,
                   stringsAsFactors = FALSE))
      pair <- pair + 1
    }
  }
}
print(ciDiffTrtEachRdr)
#>                    Estimate     StdErr          z      PrGTz     CILower
#> rdr0::trt0-trt1 -0.02818035 0.02551213 -1.1045864 0.26933885 -0.07818322
#> rdr1::trt0-trt1 -0.04653784 0.02630183 -1.7693768 0.07683102 -0.09808848
#> rdr2::trt0-trt1 -0.01787440 0.03120965 -0.5727202 0.56683414 -0.07904418
#> rdr3::trt0-trt1 -0.02624799 0.01729129 -1.5179891 0.12901715 -0.06013829
#> rdr4::trt0-trt1 -0.10016103 0.04405746 -2.2734182 0.02300099 -0.18651207
#>                      CIUpper
#> rdr0::trt0-trt1  0.021822507
#> rdr1::trt0-trt1  0.005012792
#> rdr2::trt0-trt1  0.043295388
#> rdr3::trt0-trt1  0.007642316
#> rdr4::trt0-trt1 -0.013809995
```

The notation in the first column shows the reader and the treatment pairing. For example, `rdr1::trt0-trt1` means the FOM difference for reader `rdr1`. Only the fifth reader, i.e., `rdr4`, shows a significant difference between the treatments: the p-value is 0.023001 and the confidence interval also does not include zero. The large FOM difference for this reader, -0.100161, was enough to result in a significant finding for FRRC analysis. The FOM differences for the other readers are about a factor of 2.1522491 or more smaller than that for this reader.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset02-hand}
The F-statistic is shown in Eqn. \@ref(eq:DefFStatRRFC). This time `ndf` = $I-1$ and `ddf` = $(I-1) \times (J-1)$, the values proposed in the Obuchowski-Rockette paper. The implementation follows:


```r
den <- vc$TRanova["TR","MS"]
f <- vc$TRanova["T","MS"]/den
ddf <- ((I - 1) * (J - 1))
p <- 1 - pf(f, I - 1, ddf)
FTests_RRFC <- 
  data.frame(DF = c(I-1,(I-1)*(J-1)), 
             MS = c(vc$TRanova["T","MS"],vc$TRanova["TR","MS"]), 
             F = c(f,NA),  p = c(p,NA), 
             row.names = c("T","TR"), 
             stringsAsFactors = FALSE)
print(FTests_RRFC)
#>    DF           MS     F          p
#> T   1 0.0047961705 8.704 0.04195875
#> TR  4 0.0005510306    NA         NA
```

Freezing case variability also results in a significant finding, but the conclusion is only applicable to the specific case set used in the study. Next one calculates confidence intervals for the reader-averaged FOM differences, the relevant formula is in Eqn. \@ref(eq:CIDiffFomRRFC), whose implementation follows.


```r
stdErr <- sqrt(2 * den/J)
tStat <- vector()
PrGTt <- vector()
CI <- array(dim = c(choose(I,2), 2))
for (i in 1:choose(I,2)) {
  tStat[i] <- trtMeanDiffs[i]/stdErr
  PrGTt[i] <- 2 * 
    pt(abs(tStat[i]), ddf, lower.tail = FALSE)
  CI[i, ] <- c(trtMeanDiffs[i] + qt(alpha/2, ddf) * stdErr, 
               trtMeanDiffs[i] + qt(1-alpha/2, ddf) * stdErr)
}
ciDiffTrt_RRFC <- 
  data.frame(Estimate = trtMeanDiffs, 
             StdErr = rep(stdErr, choose(I, 2)), 
             DF = rep(ddf, choose(I, 2)), 
             t = tStat, 
             PrGTt = PrGTt, 
             CILower = CI[,1],
             CIUpper = CI[,2],
             row.names = diffTRName, 
             stringsAsFactors = FALSE)

print(ciDiffTrt_RRFC)
#>              Estimate     StdErr DF         t      PrGTt     CILower
#> trt0-trt1 -0.04380032 0.01484629  4 -2.950254 0.04195875 -0.08502022
#>               CIUpper
#> trt0-trt1 -0.00258042
```
* As expected because the overall F-test showed significance, the confidence interval does not include zero (the p-value is identical to that found by the F-test). 
* This completes the hand calculations.

## Using RJafroc: dataset02 {#ORApplications-dataset02-RJafroc}

The second example shows application of the `RJafroc` package function `StSignificanceTesting()` to `dataset02`. This function encapsulates all formulae discussed previously and accomplishes the analyses with a single function call. It returns an object, denoted `st1` below, that contains all results of the analysis. It is a `list` with the following components:

* `FOMs`, this in turn is a `list` containing the following data frames: 
    + `foms`, the individual treatment-reader figures of merit, i.e., $\theta_{i j}$, 
    + `trtMeans`, the treatment figures of merit averaged over readers, i.e., $\theta_{i \bullet}$,
    + `trtMeanDiffs`, the inter-treatment figures of merit differences averaged over readers, i.e., $\theta_{i \bullet}-\theta_{i' \bullet}$.

* `ANOVA`, a `list` containing the following data frames: 
    + `TRanova`, the treatment-reader ANOVA table,
    + `VarCom`, Obuchowski-Rockette variance-covariances and correlations,
    + `IndividualTrt`, the mean-squares, `Var` and `Cov2` calculated over individual treatments,
    + `IndividualRdr`, the mean-squares, `Var` and `Cov1` calculated over individual readers.

* `RRRC`, a `list` containing the following data frames: 
    + `FTests`, the results of the F-test,
    + `ciDiffTrt`, the confidence intervals for inter-treatment FOM differences, averaged over readers, denoted $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$ in the previous chapter,
    + `ciAvgRdrEachTrt`, the confidence intervals for individual treatment FOMs, averaged over readers, denoted $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$ in the previous chapter.

* `FRRC`, a `list` containing the following data frames: 
    + `FTests`, the results of the F-tests, which in this case specializes to chi-square tests,
    + `ciDiffTrt`, the confidence intervals for inter-treatment FOM differences, averaged over readers, denoted $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$ in the previous chapter,
    + `ciAvgRdrEachTrt`, the confidence intervals for individual treatment FOMs, averaged over readers, denoted $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$ in the previous chapter,
    + `ciDiffTrtEachRdr`, the confidence intervals for inter-treatment FOM differences for individual readers, denoted $CI_{1-\alpha,FRRC,\theta_{ij} - \theta_{i'j}}$ in the previous chapter,
    + `IndividualRdrVarCov1`, the individual reader variance-covariances and means squares.

* `RRFC`, a `list` containing the following data frames: 
    + `FTests`, the results of the F-tests, which in this case specializes to chi-square tests,
    + `ciDiffTrt`, the confidence intervals for inter-treatment FOM differences, averaged over readers, denoted $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$ in the previous chapter,
    + `ciAvgRdrEachTrt`, the confidence intervals for indvidual treatment FOMs, averaged over readers, denoted $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$ in the previous chapter.

In the interest of clarity, in the first example using the `RJafroc` package the components of the returned object `st1` are listed separately and described explicitly. In the interest of brevity, in subsequent examples the object is listed in its entirety.

Online help on the `StSignificanceTesting()` function is available:


```r
?`StSignificanceTesting`
```

The lower right `RStudio` panel contains the online description. Click on the small up-and-right pointing arrow icon to expand this to a new window. 

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset02-RJafroc}
* Since `analysisOption` is not explicitly specified in the following code, the function `StSignificanceTesting` performs all three analyses: `RRRC`, `FRRC` and `RRFC`.
* Likewise, the significance level of the test, also an argument, `alpha`, defaults to 0.05. 
* The code below applies `StSignificanceTesting()` and saves the returned object to `st1`. 
* The first member of this object, a  `list` named `FOMs`, is then displayed. 
* `FOMs` contains three data frames: 
    + `FOMS$foms`, the figures of merit for each treatment and reader, 
    + `FOMS$trtMeans`, the figures of merit for each treatment averaged over readers, and 
    + `FOMS$trtMeanDiffs`, the inter-treatment difference figures of merit averaged over readers. The difference is always the first treatment minus the second, etc., in this example, `trt0` minus `trt1`.


```r
st1 <- StSignificanceTesting(dataset02, FOM = "Wilcoxon", method = "OR")
print(st1$FOMs)
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

* Displayed next are the variance components and mean-squares contained in the `ANOVA` `list`. 
    * `ANOVA$TRanova` contains the treatment-reader ANOVA table, i.e. the sum of squares, the degrees of freedom and the mean-squares, for treatment, reader and treatment-reader factors, i.e., `T`, `R` and `TR`.
    * `ANOVA$VarCom` contains the OR variance components and the correlations.
    * `ANOVA$IndividualTrt` contains the quantities necessary for individual treatment analyses.
    * `ANOVA$IndividualRdr` contains the quantities necessary for individual reader analyses.


```r
print(st1$ANOVA)
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

* Displayed next are the results of the RRRC significance test, contained in `st1$RRRC`.


```r
print(st1$RRRC$FTests)
#>                  DF           MS     FStat           p
#> Treatment  1.000000 0.0047961705 4.4563187 0.051665686
#> Error     15.259675 0.0010762629        NA          NA
```

* `st1$RRRC$FTests` contains the results of the F-tests: the degrees of freedom, the mean-squares, the observed value of the F-statistic and the p-value for rejecting the NH, listed separately, where applicable, for the treatment and error terms. 
* For example, the treatment mean squares is `st1$RRRC$FTests["Treatment", "MS"]` whose value is 0.00479617.


```r
print(st1$RRRC$ciDiffTrt[,-c(2:5)])
#>               Estimate      CILower       CIUpper
#> trt0-trt1 -0.043800322 -0.087959499 0.00035885444
```

* `st1$RRRC$ciDiffTrt` contains the results of the confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.


```r
print(st1$RRRC$ciAvgRdrEachTrt)
#>        Estimate      StdErr        DF    CILower    CIUpper          Cov2
#> trt0 0.89703704 0.033173597 12.744648 0.82522360 0.96885048 0.00048396180
#> trt1 0.94083736 0.021566368 12.710190 0.89413783 0.98753689 0.00020418785
```

* `st1$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset02-RJafroc}

* Displayed next are the results of FRRC analysis, contained in `st1$FRRC`.
* `st1$FRRC$FTests` contains the results of the F-tests: the degrees of freedom, the mean-squares, the observed value of the F-statistic and the p-value for rejecting the NH, listed separately, where applicable, for the treatment and error terms. 
* For example, the treatment mean squares is `st1$FRRC$FTests["Treatment", "MS"]` whose value is 0.00479617.


```r
print(st1$FRRC$FTests)
#>                      MS     Chisq DF           p
#> Treatment 0.00479617053 5.4759532  1 0.019279843
#> Error     0.00087586039        NA NA          NA
```

* Note that this time the output lists a chi-square distribution observed value, 5.47595324, with degree of freedom $df = I -1 = 1$.
* The listed mean-squares and the p-value agree with the previously performed hand calculations.
* For FRRC analysis the value of the chi-square statistic is significant and the p-value is smaller than $\alpha$.


```r
print(st1$FRRC$ciDiffTrt)
#>               Estimate      StdErr          z       PrGTz      CILower
#> trt0-trt1 -0.043800322 0.018717483 -2.3400755 0.019279843 -0.080485914
#>                 CIUpper
#> trt0-trt1 -0.0071147303
```

* `st1$FRRC$ciDiffTrt` contains confidence intervals for inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* The confidence interval excludes zero, and the p-value, listed under `PrGTz` (for probability greater than `z`) is smaller than 0.05.
* One could be using the t-distribution with infinite degrees of freedom, but this is identical to the normal distribution. Hence the listed value is a `z` statistic, i.e., `z = -0.043800322/0.018717483` = -2.34007543.


```r
print(st1$FRRC$ciAvgRdrEachTrt)
#>        Estimate      StdErr  DF    CILower    CIUpper
#> trt0 0.89703704 0.024289710 113 0.84943008 0.94464399
#> trt1 0.94083736 0.016776324 113 0.90795637 0.97371835
```

* `st1$FRRC$st1$FRRC$ciAvgRdrEachTrt` contains confidence intervals for individual treatment FOMs, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.



```r
print(st1$FRRC$ciDiffTrtEachRdr)
#>                     Estimate      StdErr           z       PrGTz      CILower
#> rdr0::trt0-trt1 -0.028180354 0.025512133 -1.10458638 0.269338854 -0.078183215
#> rdr1::trt0-trt1 -0.046537842 0.026301827 -1.76937679 0.076831017 -0.098088476
#> rdr2::trt0-trt1 -0.017874396 0.031209647 -0.57272023 0.566834139 -0.079044180
#> rdr3::trt0-trt1 -0.026247987 0.017291289 -1.51798907 0.129017153 -0.060138290
#> rdr4::trt0-trt1 -0.100161031 0.044057460 -2.27341816 0.023000993 -0.186512066
#>                       CIUpper
#> rdr0::trt0-trt1  0.0218225068
#> rdr1::trt0-trt1  0.0050127916
#> rdr2::trt0-trt1  0.0432953879
#> rdr3::trt0-trt1  0.0076423157
#> rdr4::trt0-trt1 -0.0138099949
```

* `st1$FRRC$st1$FRRC$ciDiffTrtEachRdr` contains confidence intervals for inter-treatment difference FOMs, for each reader, i.e., $CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}}$.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset02-RJafroc}


```r
print(st1$RRFC$FTests)
#>    DF            MS     F           p
#> T   1 0.00479617053 8.704 0.041958752
#> TR  4 0.00055103062    NA          NA
```

* `st1$RRFC$FTests` contains results of the F-test: the degrees of freedom, the mean-squares, the observed value of the F-statistic and the p-value for rejecting the NH, listed separately, where applicable, for the treatment and treatment-reader terms. The latter is also termed the "error term". 
* For example, the treatment-reader mean squares is `st1$RRFC$FTests["TR", "MS"]` whose value is \ensuremath{5.51030622\times 10^{-4}}.


```r
print(st1$RRFC$ciDiffTrt)
#>               Estimate      StdErr DF          t       PrGTt      CILower
#> trt0-trt1 -0.043800322 0.014846287  4 -2.9502542 0.041958752 -0.085020224
#>                 CIUpper
#> trt0-trt1 -0.0025804202
```

* `st1$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment paired difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.



```r
print(st1$RRFC$ciAvgRdrEachTrt)
#>        Estimate      StdErr DF    CILower    CIUpper
#> Trt0 0.89703704 0.024829936  4 0.82809808 0.96597599
#> Trt1 0.94083736 0.016153030  4 0.89598936 0.98568536
```

* `st1$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.

## Using RJafroc: dataset04 {#ORApplications-dataset04-RJafroc}
* The third example uses the Federica Zanca dataset [@RN1882], i.e., `dataset04`, which has five modalities and four readers. 
* It illustrates the situation when multiple treatment pairings are involved. In contrast, the previous example had only one treatment pairing.
* Since this is an FROC dataset, in order to keep it comparable with the previous example, one converts it to an inferred-ROC dataset.
* The function `DfFroc2Roc(dataset04)` converts, using the highest-rating, the FROC dataset to an inferred-ROC dataset.
* The results are contained in `st2`. 
* As noted earlier, this time the object is listed in its entirety.


```r
ds <- DfFroc2Roc(dataset04) # convert to ROC
I <- length(ds$ratings$NL[,1,1,1])
J <- length(ds$ratings$NL[1,,1,1])
cat("I = ", I, ", J = ", J, "\n")
#> I =  5 , J =  4
st2 <- StSignificanceTesting(ds, FOM = "Wilcoxon", method = "OR")
print(st2)
#> $FOMs
#> $FOMs$foms
#>         rdr1    rdr2    rdr3    rdr4
#> trt1 0.90425 0.79820 0.81175 0.86645
#> trt2 0.86425 0.84470 0.82050 0.87160
#> trt3 0.81295 0.81635 0.75275 0.85730
#> trt4 0.90235 0.83150 0.78865 0.87980
#> trt5 0.84140 0.77300 0.77115 0.84800
#> 
#> $FOMs$trtMeans
#>       Estimate
#> trt1 0.8451625
#> trt2 0.8502625
#> trt3 0.8098375
#> trt4 0.8505750
#> trt5 0.8083875
#> 
#> $FOMs$trtMeanDiffs
#>             Estimate
#> trt1-trt2 -0.0051000
#> trt1-trt3  0.0353250
#> trt1-trt4 -0.0054125
#> trt1-trt5  0.0367750
#> trt2-trt3  0.0404250
#> trt2-trt4 -0.0003125
#> trt2-trt5  0.0418750
#> trt3-trt4 -0.0407375
#> trt3-trt5  0.0014500
#> trt4-trt5  0.0421875
#> 
#> 
#> $ANOVA
#> $ANOVA$TRanova
#>              SS DF            MS
#> T  0.0075878295  4 0.00189695737
#> R  0.0218825325  3 0.00729417750
#> TR 0.0055464825 12 0.00046220687
#> 
#> $ANOVA$VarCom
#>            Estimates       Rhos
#> VarR   1.2837211e-03         NA
#> VarTR -1.0925227e-05         NA
#> Cov1   2.9480096e-04 0.37358228
#> Cov2   2.3331406e-04 0.29566389
#> Cov3   2.1212789e-04 0.26881601
#> Var    7.8911924e-04         NA
#> 
#> $ANOVA$IndividualTrt
#>      DF    msREachTrt    varEachTrt   cov2EachTrt
#> trt1  3 0.00242212063 0.00071052519 0.00021118589
#> trt2  3 0.00052256229 0.00075105717 0.00026649085
#> trt3  3 0.00185459062 0.00087586914 0.00024646233
#> trt4  3 0.00257777083 0.00072651505 0.00022042897
#> trt5  3 0.00176596062 0.00088162963 0.00022200226
#> 
#> $ANOVA$IndividualRdr
#>      DF   msTEachRdr    varEachRdr   cov1EachRdr
#> rdr1  4 0.0015505755 0.00068948369 0.00021527296
#> rdr2  4 0.0007942725 0.00082356314 0.00034557909
#> rdr3  4 0.0007856530 0.00100854171 0.00035359299
#> rdr4  4 0.0001530770 0.00063488840 0.00026475880
#> 
#> 
#> $RRRC
#> $RRRC$FTests
#>                  DF            MS     FStat           p
#> Treatment  4.000000 0.00189695737 3.4682364 0.030544556
#> Error     16.803749 0.00054695157        NA          NA
#> 
#> $RRRC$ciDiffTrt
#>             Estimate      StdErr        DF            t       PrGTt
#> trt1-trt2 -0.0051000 0.016537103 16.803749 -0.308397420 0.761570284
#> trt1-trt3  0.0353250 0.016537103 16.803749  2.136105659 0.047689094
#> trt1-trt4 -0.0054125 0.016537103 16.803749 -0.327294321 0.747487331
#> trt1-trt5  0.0367750 0.016537103 16.803749  2.223787278 0.040173758
#> trt2-trt3  0.0404250 0.016537103 16.803749  2.444503079 0.025841064
#> trt2-trt4 -0.0003125 0.016537103 16.803749 -0.018896901 0.985145919
#> trt2-trt5  0.0418750 0.016537103 16.803749  2.532184698 0.021613616
#> trt3-trt4 -0.0407375 0.016537103 16.803749 -2.463399980 0.024868769
#> trt3-trt5  0.0014500 0.016537103 16.803749  0.087681619 0.931166167
#> trt4-trt5  0.0421875 0.016537103 16.803749  2.551081599 0.020792673
#>                  CILower       CIUpper
#> trt1-trt2 -0.04002130451  0.0298213045
#> trt1-trt3  0.00040369549  0.0702463045
#> trt1-trt4 -0.04033380451  0.0295088045
#> trt1-trt5  0.00185369549  0.0716963045
#> trt2-trt3  0.00550369549  0.0753463045
#> trt2-trt4 -0.03523380451  0.0346088045
#> trt2-trt5  0.00695369549  0.0767963045
#> trt3-trt4 -0.07565880451 -0.0058161955
#> trt3-trt5 -0.03347130451  0.0363713045
#> trt4-trt5  0.00726619549  0.0771088045
#> 
#> $RRRC$ciAvgRdrEachTrt
#>       Estimate      StdErr         DF    CILower    CIUpper          Cov2
#> trt1 0.8451625 0.028578244  5.4574766 0.77351391 0.91681109 0.00021118589
#> trt2 0.8502625 0.019928157 27.7225775 0.80942311 0.89110189 0.00026649085
#> trt3 0.8098375 0.026647889  7.0371428 0.74689261 0.87278239 0.00024646233
#> trt4 0.8505750 0.029408701  5.4032614 0.77664342 0.92450658 0.00022042897
#> trt5 0.8083875 0.025758346  6.7756525 0.74706746 0.86970754 0.00022200226
#> 
#> 
#> $FRRC
#> $FRRC$FTests
#>                     MS     Chisq DF            p
#> Treatment 0.0018969574 13.601264  4 0.0086826618
#> Error     0.0005578768        NA NA           NA
#> 
#> $FRRC$ciDiffTrt
#>             Estimate      StdErr            z       PrGTz       CILower
#> trt1-trt2 -0.0051000 0.016701449 -0.305362726 0.760089908 -0.0378342386
#> trt1-trt3  0.0353250 0.016701449  2.115085938 0.034422624  0.0025907614
#> trt1-trt4 -0.0054125 0.016701449 -0.324073677 0.745882255 -0.0381467386
#> trt1-trt5  0.0367750 0.016701449  2.201904752 0.027672037  0.0040407614
#> trt2-trt3  0.0404250 0.016701449  2.420448663 0.015501368  0.0076907614
#> trt2-trt4 -0.0003125 0.016701449 -0.018710951 0.985071692 -0.0330467386
#> trt2-trt5  0.0418750 0.016701449  2.507267477 0.012166860  0.0091407614
#> trt3-trt4 -0.0407375 0.016701449 -2.439159615 0.014721464 -0.0734717386
#> trt3-trt5  0.0014500 0.016701449  0.086818814 0.930815533 -0.0312842386
#> trt4-trt5  0.0421875 0.016701449  2.525978429 0.011537657  0.0094532614
#>                 CIUpper
#> trt1-trt2  0.0276342386
#> trt1-trt3  0.0680592386
#> trt1-trt4  0.0273217386
#> trt1-trt5  0.0695092386
#> trt2-trt3  0.0731592386
#> trt2-trt4  0.0324217386
#> trt2-trt5  0.0746092386
#> trt3-trt4 -0.0080032614
#> trt3-trt5  0.0341842386
#> trt4-trt5  0.0749217386
#> 
#> $FRRC$ciAvgRdrEachTrt
#>       Estimate      StdErr  DF    CILower    CIUpper
#> trt1 0.8451625 0.018330868 199 0.80923466 0.88109034
#> trt2 0.8502625 0.019688383 199 0.81167398 0.88885102
#> trt3 0.8098375 0.020095125 199 0.77045178 0.84922322
#> trt4 0.8505750 0.018626607 199 0.81406752 0.88708248
#> trt5 0.8083875 0.019670005 199 0.76983500 0.84694000
#> 
#> $FRRC$ciDiffTrtEachRdr
#>                 Estimate      StdErr            z        PrGTz       CILower
#> rdr1::trt1-trt2  0.04000 0.030796452  1.298850908 0.1939950999 -0.0203599373
#> rdr1::trt1-trt3  0.09130 0.030796452  2.964627198 0.0030304993  0.0309400627
#> rdr1::trt1-trt4  0.00190 0.030796452  0.061695418 0.9508053888 -0.0584599373
#> rdr1::trt1-trt5  0.06285 0.030796452  2.040819490 0.0412687726  0.0024900627
#> rdr1::trt2-trt3  0.05130 0.030796452  1.665776290 0.0957579803 -0.0090599373
#> rdr1::trt2-trt4 -0.03810 0.030796452 -1.237155490 0.2160293623 -0.0984599373
#> rdr1::trt2-trt5  0.02285 0.030796452  0.741968581 0.4581063718 -0.0375099373
#> rdr1::trt3-trt4 -0.08940 0.030796452 -2.902931780 0.0036968716 -0.1497599373
#> rdr1::trt3-trt5 -0.02845 0.030796452 -0.923807708 0.3555864411 -0.0888099373
#> rdr1::trt4-trt5  0.06095 0.030796452  1.979124071 0.0478020389  0.0005900627
#> rdr2::trt1-trt2 -0.04650 0.030918734 -1.503942569 0.1325961549 -0.1070996048
#> rdr2::trt1-trt3 -0.01815 0.030918734 -0.587022745 0.5571884312 -0.0787496048
#> rdr2::trt1-trt4 -0.03330 0.030918734 -1.077016936 0.2814726994 -0.0938996048
#> rdr2::trt1-trt5  0.02520 0.030918734  0.815039844 0.4150495035 -0.0353996048
#> rdr2::trt2-trt3  0.02835 0.030918734  0.916919824 0.3591846549 -0.0322496048
#> rdr2::trt2-trt4  0.01320 0.030918734  0.426925632 0.6694334951 -0.0473996048
#> rdr2::trt2-trt5  0.07170 0.030918734  2.318982413 0.0203959900  0.0111003952
#> rdr2::trt3-trt4 -0.01515 0.030918734 -0.489994192 0.6241380088 -0.0757496048
#> rdr2::trt3-trt5  0.04335 0.030918734  1.402062588 0.1608965575 -0.0172496048
#> rdr2::trt4-trt5  0.05850 0.030918734  1.892056780 0.0584834160 -0.0020996048
#> rdr3::trt1-trt2 -0.00875 0.036192505 -0.241762762 0.8089639949 -0.0796860066
#> rdr3::trt1-trt3  0.05900 0.036192505  1.630171765 0.1030651996 -0.0119360066
#> rdr3::trt1-trt4  0.02310 0.036192505  0.638253691 0.5233085518 -0.0478360066
#> rdr3::trt1-trt5  0.04060 0.036192505  1.121779214 0.2619563260 -0.0303360066
#> rdr3::trt2-trt3  0.06775 0.036192505  1.871934526 0.0612156622 -0.0031860066
#> rdr3::trt2-trt4  0.03185 0.036192505  0.880016453 0.3788503968 -0.0390860066
#> rdr3::trt2-trt5  0.04935 0.036192505  1.363541976 0.1727117647 -0.0215860066
#> rdr3::trt3-trt4 -0.03590 0.036192505 -0.991918074 0.3212374917 -0.1068360066
#> rdr3::trt3-trt5 -0.01840 0.036192505 -0.508392550 0.6111780762 -0.0893360066
#> rdr3::trt4-trt5  0.01750 0.036192505  0.483525523 0.6287226416 -0.0534360066
#> rdr4::trt1-trt2 -0.00515 0.027207705 -0.189284617 0.8498697516 -0.0584761218
#> rdr4::trt1-trt3  0.00915 0.027207705  0.336301795 0.7366432968 -0.0441761218
#> rdr4::trt1-trt4 -0.01335 0.027207705 -0.490669831 0.6236599874 -0.0666761218
#> rdr4::trt1-trt5  0.01845 0.027207705  0.678116733 0.4976976819 -0.0348761218
#> rdr4::trt2-trt3  0.01430 0.027207705  0.525586411 0.5991756003 -0.0390261218
#> rdr4::trt2-trt4 -0.00820 0.027207705 -0.301385215 0.7631207674 -0.0615261218
#> rdr4::trt2-trt5  0.02360 0.027207705  0.867401350 0.3857221425 -0.0297261218
#> rdr4::trt3-trt4 -0.02250 0.027207705 -0.826971626 0.4082531440 -0.0758261218
#> rdr4::trt3-trt5  0.00930 0.027207705  0.341814939 0.7324901666 -0.0440261218
#> rdr4::trt4-trt5  0.03180 0.027207705  1.168786565 0.2424896348 -0.0215261218
#>                      CIUpper
#> rdr1::trt1-trt2  0.100359937
#> rdr1::trt1-trt3  0.151659937
#> rdr1::trt1-trt4  0.062259937
#> rdr1::trt1-trt5  0.123209937
#> rdr1::trt2-trt3  0.111659937
#> rdr1::trt2-trt4  0.022259937
#> rdr1::trt2-trt5  0.083209937
#> rdr1::trt3-trt4 -0.029040063
#> rdr1::trt3-trt5  0.031909937
#> rdr1::trt4-trt5  0.121309937
#> rdr2::trt1-trt2  0.014099605
#> rdr2::trt1-trt3  0.042449605
#> rdr2::trt1-trt4  0.027299605
#> rdr2::trt1-trt5  0.085799605
#> rdr2::trt2-trt3  0.088949605
#> rdr2::trt2-trt4  0.073799605
#> rdr2::trt2-trt5  0.132299605
#> rdr2::trt3-trt4  0.045449605
#> rdr2::trt3-trt5  0.103949605
#> rdr2::trt4-trt5  0.119099605
#> rdr3::trt1-trt2  0.062186007
#> rdr3::trt1-trt3  0.129936007
#> rdr3::trt1-trt4  0.094036007
#> rdr3::trt1-trt5  0.111536007
#> rdr3::trt2-trt3  0.138686007
#> rdr3::trt2-trt4  0.102786007
#> rdr3::trt2-trt5  0.120286007
#> rdr3::trt3-trt4  0.035036007
#> rdr3::trt3-trt5  0.052536007
#> rdr3::trt4-trt5  0.088436007
#> rdr4::trt1-trt2  0.048176122
#> rdr4::trt1-trt3  0.062476122
#> rdr4::trt1-trt4  0.039976122
#> rdr4::trt1-trt5  0.071776122
#> rdr4::trt2-trt3  0.067626122
#> rdr4::trt2-trt4  0.045126122
#> rdr4::trt2-trt5  0.076926122
#> rdr4::trt3-trt4  0.030826122
#> rdr4::trt3-trt5  0.062626122
#> rdr4::trt4-trt5  0.085126122
#> 
#> $FRRC$IndividualRdrVarCov1
#>         varEachRdr   cov1EachRdr
#> rdr1 0.00068948369 0.00021527296
#> rdr2 0.00082356314 0.00034557909
#> rdr3 0.00100854171 0.00035359299
#> rdr4 0.00063488840 0.00026475880
#> 
#> 
#> $RRFC
#> $RRFC$FTests
#>    DF            MS         F           p
#> T   4 0.00189695737 4.1041306 0.025328308
#> TR 12 0.00046220687        NA          NA
#> 
#> $RRFC$ciDiffTrt
#>             Estimate      StdErr DF            t       PrGTt       CILower
#> trt1-trt2 -0.0051000 0.015202087 12 -0.335480262 0.743055139 -0.0382225014
#> trt1-trt3  0.0353250 0.015202087 12  2.323694167 0.038508394  0.0022024986
#> trt1-trt4 -0.0054125 0.015202087 12 -0.356036651 0.727993972 -0.0385350014
#> trt1-trt5  0.0367750 0.015202087 12  2.419075810 0.032372026  0.0036524986
#> trt2-trt3  0.0404250 0.015202087 12  2.659174429 0.020823153  0.0073024986
#> trt2-trt4 -0.0003125 0.015202087 12 -0.020556389 0.983937382 -0.0334350014
#> trt2-trt5  0.0418750 0.015202087 12  2.754556072 0.017454332  0.0087524986
#> trt3-trt4 -0.0407375 0.015202087 12 -2.679730818 0.020046910 -0.0738600014
#> trt3-trt5  0.0014500 0.015202087 12  0.095381643 0.925585993 -0.0316725014
#> trt4-trt5  0.0421875 0.015202087 12  2.775112461 0.016801933  0.0090649986
#>                 CIUpper
#> trt1-trt2  0.0280225014
#> trt1-trt3  0.0684475014
#> trt1-trt4  0.0277100014
#> trt1-trt5  0.0698975014
#> trt2-trt3  0.0735475014
#> trt2-trt4  0.0328100014
#> trt2-trt5  0.0749975014
#> trt3-trt4 -0.0076149986
#> trt3-trt5  0.0345725014
#> trt4-trt5  0.0753100014
#> 
#> $RRFC$ciAvgRdrEachTrt
#>       Estimate      StdErr DF    CILower    CIUpper
#> Trt1 0.8451625 0.024607522  3 0.76685038 0.92347462
#> Trt2 0.8502625 0.011429811  3 0.81388774 0.88663726
#> Trt3 0.8098375 0.021532479  3 0.74131154 0.87836346
#> Trt4 0.8505750 0.025385876  3 0.76978581 0.93136419
#> Trt5 0.8083875 0.021011667  3 0.74151900 0.87525600
```

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04}

* `st2$RRRC$FTests` contains the results of the F-test.
* In this example `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st2$RRRC$ciDiffTrt` contains the confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. 

* `st2$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.
* Looking at the `Estimate` column one confirms that `trt5` has the smallest FOM while `trt4` has the highest.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04}

* `st2$FRRC$FTests` contains results of the F-tests, which in this situation is actually a chi-square test of the NH.
* Again, `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st2$FRRC$ciDiffTrt` contains confidence intervals for the inter-treatment paired difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. 

* `st2$FRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.
* The `Estimate` column confirms that `trt5` has the smallest FOM while `trt4` has the highest.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04}

* `st2$RRFC$FTests` contains the results of the F-test of the NH.
* Again, `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st2$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* The `PrGTt` column shows that six pairings are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. 

* `st2$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.
* The `Estimate` column confirms that `trt5` has the smallest FOM while `trt4` has the highest (the `Estimates` column is identical for RRRC, FRRC and RRFC analyses).

## Using RJafroc: dataset04, FROC analysis {#ORApplications-dataset04-FROC-RJafroc}
* The fourth example uses `dataset04`, but this time we use the FROC data, specifically, we do not convert it to inferred-ROC. 
* Since this is an FROC dataset, one needs to use an FROC figure of merit. 
* In this example the weighted AFROC figure of merit `FOM = "wAFROC"` is specified. This is the recommended figure of merit when both normal and abnormal cases are present in the dataset.
* If the dataset does not contain normal cases, then the weighted AFROC1 figure of merit `FOM = "wAFROC1"` should be specified. 
* The results are contained in `st3`. 
* As noted earlier, this time the object is listed in its entirety.


```r
ds <- dataset04 # do NOT convert to ROC
FOM <- "wAFROC" 
st3 <- StSignificanceTesting(ds, FOM = FOM, method = "OR")
print(st3)
#> $FOMs
#> $FOMs$foms
#>            rdr1       rdr3       rdr4       rdr5
#> trt1 0.77926667 0.72489167 0.70362500 0.80509167
#> trt2 0.78700000 0.72690000 0.72261667 0.80378333
#> trt3 0.72969167 0.71575833 0.67230833 0.77265833
#> trt4 0.81013333 0.74311667 0.69435833 0.82940833
#> trt5 0.74880000 0.68227500 0.65517500 0.77125000
#> 
#> $FOMs$trtMeans
#>        Estimate
#> trt1 0.75321875
#> trt2 0.76007500
#> trt3 0.72260417
#> trt4 0.76925417
#> trt5 0.71437500
#> 
#> $FOMs$trtMeanDiffs
#>                Estimate
#> trt1-trt2 -0.0068562500
#> trt1-trt3  0.0306145833
#> trt1-trt4 -0.0160354167
#> trt1-trt5  0.0388437500
#> trt2-trt3  0.0374708333
#> trt2-trt4 -0.0091791667
#> trt2-trt5  0.0457000000
#> trt3-trt4 -0.0466500000
#> trt3-trt5  0.0082291667
#> trt4-trt5  0.0548791667
#> 
#> 
#> $ANOVA
#> $ANOVA$TRanova
#>              SS DF            MS
#> T  0.0092661660  4 0.00231654149
#> R  0.0354043662  3 0.01180145539
#> TR 0.0020352419 12 0.00016960349
#> 
#> $ANOVA$VarCom
#>            Estimates       Rhos
#> VarR   0.00220864564         NA
#> VarTR -0.00030459978         NA
#> Cov1   0.00042203598 0.45473916
#> Cov2   0.00033615564 0.36220403
#> Cov3   0.00030431124 0.32789204
#> Var    0.00092808365         NA
#> 
#> $ANOVA$IndividualTrt
#>      DF   msREachTrt    varEachTrt   cov2EachTrt
#> trt1  3 0.0022104190 0.00087740343 0.00033319886
#> trt2  3 0.0017130271 0.00093887326 0.00038023350
#> trt3  3 0.0017107295 0.00096971478 0.00029724350
#> trt4  3 0.0038607283 0.00085902596 0.00031071226
#> trt5  3 0.0029849654 0.00099540083 0.00035939006
#> 
#> $ANOVA$IndividualRdr
#>      DF    msTEachRdr    varEachRdr   cov1EachRdr
#> rdr1  4 0.00101374290 0.00088314868 0.00041224847
#> rdr3  4 0.00050928051 0.00089655670 0.00043556997
#> rdr4  4 0.00069838090 0.00117090526 0.00049516987
#> rdr5  4 0.00060394766 0.00076172396 0.00034515562
#> 
#> 
#> $RRRC
#> $RRRC$FTests
#>                  DF            MS     FStat           p
#> Treatment  4.000000 0.00231654149 7.8002997 0.000117105
#> Error     36.793343 0.00029698109        NA          NA
#> 
#> $RRRC$ciDiffTrt
#>                Estimate     StdErr        DF           t         PrGTt
#> trt1-trt2 -0.0068562500 0.01218567 36.793343 -0.56264860 5.7708666e-01
#> trt1-trt3  0.0306145833 0.01218567 36.793343  2.51234312 1.6509287e-02
#> trt1-trt4 -0.0160354167 0.01218567 36.793343 -1.31592413 1.9633987e-01
#> trt1-trt5  0.0388437500 0.01218567 36.793343  3.18765822 2.9246461e-03
#> trt2-trt3  0.0374708333 0.01218567 36.793343  3.07499173 3.9557451e-03
#> trt2-trt4 -0.0091791667 0.01218567 36.793343 -0.75327552 4.5607767e-01
#> trt2-trt5  0.0457000000 0.01218567 36.793343  3.75030682 6.0697106e-04
#> trt3-trt4 -0.0466500000 0.01218567 36.793343 -3.82826725 4.8459540e-04
#> trt3-trt5  0.0082291667 0.01218567 36.793343  0.67531510 5.0369787e-01
#> trt4-trt5  0.0548791667 0.01218567 36.793343  4.50358235 6.5228142e-05
#>                 CILower       CIUpper
#> trt1-trt2 -0.0315514439  0.0178389439
#> trt1-trt3  0.0059193894  0.0553097773
#> trt1-trt4 -0.0407306106  0.0086597773
#> trt1-trt5  0.0141485561  0.0635389439
#> trt2-trt3  0.0127756394  0.0621660273
#> trt2-trt4 -0.0338743606  0.0155160273
#> trt2-trt5  0.0210048061  0.0703951939
#> trt3-trt4 -0.0713451939 -0.0219548061
#> trt3-trt5 -0.0164660273  0.0329243606
#> trt4-trt5  0.0301839727  0.0795743606
#> 
#> $RRRC$ciAvgRdrEachTrt
#>        Estimate      StdErr         DF    CILower    CIUpper          Cov2
#> trt1 0.75321875 0.029762453  7.7084474 0.68413193 0.82230557 0.00033319886
#> trt2 0.76007500 0.028433963 10.6920840 0.69727167 0.82287833 0.00038023350
#> trt3 0.72260417 0.026924448  8.6191761 0.66128414 0.78392420 0.00029724350
#> trt4 0.76925417 0.035719663  5.2424244 0.67869638 0.85981195 0.00031071226
#> trt5 0.71437500 0.033251036  6.5854184 0.63473415 0.79401585 0.00035939006
#> 
#> 
#> $FRRC
#> $FRRC$FTests
#>                      MS     Chisq DF            p
#> Treatment 0.00231654149 15.403026  4 0.0039343238
#> Error     0.00060158087        NA NA           NA
#> 
#> $FRRC$ciDiffTrt
#>                Estimate      StdErr           z        PrGTz       CILower
#> trt1-trt2 -0.0068562500 0.017343311 -0.39532532 0.6926028123 -0.0408485147
#> trt1-trt3  0.0306145833 0.017343311  1.76520986 0.0775285026 -0.0033776814
#> trt1-trt4 -0.0160354167 0.017343311 -0.92458797 0.3551802713 -0.0500276814
#> trt1-trt5  0.0388437500 0.017343311  2.23969634 0.0251106431  0.0048514853
#> trt2-trt3  0.0374708333 0.017343311  2.16053518 0.0307312632  0.0034785686
#> trt2-trt4 -0.0091791667 0.017343311 -0.52926265 0.5966232621 -0.0431714314
#> trt2-trt5  0.0457000000 0.017343311  2.63502167 0.0084131912  0.0117077353
#> trt3-trt4 -0.0466500000 0.017343311 -2.68979783 0.0071495318 -0.0806422647
#> trt3-trt5  0.0082291667 0.017343311  0.47448649 0.6351530315 -0.0257630981
#> trt4-trt5  0.0548791667 0.017343311  3.16428432 0.0015546484  0.0208869019
#>                CIUpper
#> trt1-trt2  0.027136015
#> trt1-trt3  0.064606848
#> trt1-trt4  0.017956848
#> trt1-trt5  0.072836015
#> trt2-trt3  0.071463098
#> trt2-trt4  0.024813098
#> trt2-trt5  0.079692265
#> trt3-trt4 -0.012657735
#> trt3-trt5  0.042221431
#> trt4-trt5  0.088871431
#> 
#> $FRRC$ciAvgRdrEachTrt
#>        Estimate      StdErr  DF    CILower    CIUpper
#> trt1 0.75321875 0.021662179 199 0.71076166 0.79567584
#> trt2 0.76007500 0.022801172 199 0.71538552 0.80476448
#> trt3 0.72260417 0.021572235 199 0.68032336 0.76488497
#> trt4 0.76925417 0.021161065 199 0.72777924 0.81072909
#> trt5 0.71437500 0.022768240 199 0.66975007 0.75899993
#> 
#> $FRRC$ciDiffTrtEachRdr
#>                      Estimate      StdErr            z        PrGTz
#> rdr1::trt1-trt2 -0.0077333333 0.030688767 -0.251992312 0.8010470065
#> rdr1::trt1-trt3  0.0495750000 0.030688767  1.615411921 0.1062215205
#> rdr1::trt1-trt4 -0.0308666667 0.030688767 -1.005796899 0.3145132792
#> rdr1::trt1-trt5  0.0304666667 0.030688767  0.992762814 0.3208255556
#> rdr1::trt2-trt3  0.0573083333 0.030688767  1.867404232 0.0618451592
#> rdr1::trt2-trt4 -0.0231333333 0.030688767 -0.753804588 0.4509665689
#> rdr1::trt2-trt5  0.0382000000 0.030688767  1.244755126 0.2132217757
#> rdr1::trt3-trt4 -0.0804416667 0.030688767 -2.621208820 0.0087618575
#> rdr1::trt3-trt5 -0.0191083333 0.030688767 -0.622649106 0.5335151338
#> rdr1::trt4-trt5  0.0613333333 0.030688767  1.998559713 0.0456560130
#> rdr3::trt1-trt2 -0.0020083333 0.030364016 -0.066141888 0.9472648623
#> rdr3::trt1-trt3  0.0091333333 0.030364016  0.300794643 0.7635710940
#> rdr3::trt1-trt4 -0.0182250000 0.030364016 -0.600217047 0.5483615943
#> rdr3::trt1-trt5  0.0426166667 0.030364016  1.403525367 0.1604602331
#> rdr3::trt2-trt3  0.0111416667 0.030364016  0.366936530 0.7136663620
#> rdr3::trt2-trt4 -0.0162166667 0.030364016 -0.534075159 0.5932895354
#> rdr3::trt2-trt5  0.0446250000 0.030364016  1.469667254 0.1416518956
#> rdr3::trt3-trt4 -0.0273583333 0.030364016 -0.901011689 0.3675821046
#> rdr3::trt3-trt5  0.0334833333 0.030364016  1.102730724 0.2701441201
#> rdr3::trt4-trt5  0.0608416667 0.030364016  2.003742413 0.0450976604
#> rdr4::trt1-trt2 -0.0189916667 0.036762356 -0.516606359 0.6054309755
#> rdr4::trt1-trt3  0.0313166667 0.036762356  0.851867792 0.3942874746
#> rdr4::trt1-trt4  0.0092666667 0.036762356  0.252069448 0.8009873847
#> rdr4::trt1-trt5  0.0484500000 0.036762356  1.317924254 0.1875290058
#> rdr4::trt2-trt3  0.0503083333 0.036762356  1.368474152 0.1711637075
#> rdr4::trt2-trt4  0.0282583333 0.036762356  0.768675807 0.4420857903
#> rdr4::trt2-trt5  0.0674416667 0.036762356  1.834530613 0.0665752679
#> rdr4::trt3-trt4 -0.0220500000 0.036762356 -0.599798344 0.5486406368
#> rdr4::trt3-trt5  0.0171333333 0.036762356  0.466056461 0.6411750868
#> rdr4::trt4-trt5  0.0391833333 0.036762356  1.065854806 0.2864892816
#> rdr5::trt1-trt2  0.0013083333 0.028864107  0.045327345 0.9638463920
#> rdr5::trt1-trt3  0.0324333333 0.028864107  1.123656212 0.2611588993
#> rdr5::trt1-trt4 -0.0243166667 0.028864107 -0.842453450 0.3995341855
#> rdr5::trt1-trt5  0.0338416667 0.028864107  1.172448067 0.2410172108
#> rdr5::trt2-trt3  0.0311250000 0.028864107  1.078328867 0.2808870188
#> rdr5::trt2-trt4 -0.0256250000 0.028864107 -0.887780794 0.3746586757
#> rdr5::trt2-trt5  0.0325333333 0.028864107  1.127120723 0.2596914430
#> rdr5::trt3-trt4 -0.0567500000 0.028864107 -1.966109662 0.0492859446
#> rdr5::trt3-trt5  0.0014083333 0.028864107  0.048791855 0.9610851732
#> rdr5::trt4-trt5  0.0581583333 0.028864107  2.014901517 0.0439149690
#>                       CILower        CIUpper
#> rdr1::trt1-trt2 -0.0678822113  0.05241554467
#> rdr1::trt1-trt3 -0.0105738780  0.10972387800
#> rdr1::trt1-trt4 -0.0910155447  0.02928221134
#> rdr1::trt1-trt5 -0.0296822113  0.09061554467
#> rdr1::trt2-trt3 -0.0028405447  0.11745721134
#> rdr1::trt2-trt4 -0.0832822113  0.03701554467
#> rdr1::trt2-trt5 -0.0219488780  0.09834887800
#> rdr1::trt3-trt4 -0.1405905447 -0.02029278866
#> rdr1::trt3-trt5 -0.0792572113  0.04104054467
#> rdr1::trt4-trt5  0.0011844553  0.12148221134
#> rdr3::trt1-trt2 -0.0615207111  0.05750404442
#> rdr3::trt1-trt3 -0.0503790444  0.06864571108
#> rdr3::trt1-trt4 -0.0777373778  0.04128737775
#> rdr3::trt1-trt5 -0.0168957111  0.10212904442
#> rdr3::trt2-trt3 -0.0483707111  0.07065404442
#> rdr3::trt2-trt4 -0.0757290444  0.04329571108
#> rdr3::trt2-trt5 -0.0148873778  0.10413737775
#> rdr3::trt3-trt4 -0.0868707111  0.03215404442
#> rdr3::trt3-trt5 -0.0260290444  0.09299571108
#> rdr3::trt4-trt5  0.0013292889  0.12035404442
#> rdr4::trt1-trt2 -0.0910445595  0.05306122620
#> rdr4::trt1-trt3 -0.0407362262  0.10336955954
#> rdr4::trt1-trt4 -0.0627862262  0.08131955954
#> rdr4::trt1-trt5 -0.0236028929  0.12050289287
#> rdr4::trt2-trt3 -0.0217445595  0.12236122620
#> rdr4::trt2-trt4 -0.0437945595  0.10031122620
#> rdr4::trt2-trt5 -0.0046112262  0.13949455954
#> rdr4::trt3-trt4 -0.0941028929  0.05000289287
#> rdr4::trt3-trt5 -0.0549195595  0.08918622620
#> rdr4::trt4-trt5 -0.0328695595  0.11123622620
#> rdr5::trt1-trt2 -0.0552642772  0.05788094384
#> rdr5::trt1-trt3 -0.0241392772  0.08900594384
#> rdr5::trt1-trt4 -0.0808892772  0.03225594384
#> rdr5::trt1-trt5 -0.0227309438  0.09041427718
#> rdr5::trt2-trt3 -0.0254476105  0.08769761051
#> rdr5::trt2-trt4 -0.0821976105  0.03094761051
#> rdr5::trt2-trt5 -0.0240392772  0.08910594384
#> rdr5::trt3-trt4 -0.1133226105 -0.00017738949
#> rdr5::trt3-trt5 -0.0551642772  0.05798094384
#> rdr5::trt4-trt5  0.0015857228  0.11473094384
#> 
#> $FRRC$IndividualRdrVarCov1
#>         varEachRdr   cov1EachRdr
#> rdr1 0.00088314868 0.00041224847
#> rdr3 0.00089655670 0.00043556997
#> rdr4 0.00117090526 0.00049516987
#> rdr5 0.00076172396 0.00034515562
#> 
#> 
#> $RRFC
#> $RRFC$FTests
#>    DF            MS         F             p
#> T   4 0.00231654149 13.658572 0.00020192224
#> TR 12 0.00016960349        NA            NA
#> 
#> $RRFC$ciDiffTrt
#>                Estimate       StdErr DF           t         PrGTt      CILower
#> trt1-trt2 -0.0068562500 0.0092087864 12 -0.74453350 4.7088356e-01 -0.026920472
#> trt1-trt3  0.0306145833 0.0092087864 12  3.32449706 6.0595183e-03  0.010550361
#> trt1-trt4 -0.0160354167 0.0092087864 12 -1.74131704 1.0717825e-01 -0.036099639
#> trt1-trt5  0.0388437500 0.0092087864 12  4.21811825 1.1928824e-03  0.018779528
#> trt2-trt3  0.0374708333 0.0092087864 12  4.06903056 1.5563074e-03  0.017406611
#> trt2-trt4 -0.0091791667 0.0092087864 12 -0.99678353 3.3854538e-01 -0.029243389
#> trt2-trt5  0.0457000000 0.0092087864 12  4.96265175 3.2930420e-04  0.025635778
#> trt3-trt4 -0.0466500000 0.0092087864 12 -5.06581410 2.7711820e-04 -0.066714222
#> trt3-trt5  0.0082291667 0.0092087864 12  0.89362119 3.8909518e-01 -0.011835055
#> trt4-trt5  0.0548791667 0.0092087864 12  5.95943529 6.6167481e-05  0.034814945
#>                 CIUpper
#> trt1-trt2  0.0132079720
#> trt1-trt3  0.0506788053
#> trt1-trt4  0.0040288053
#> trt1-trt5  0.0589079720
#> trt2-trt3  0.0575350553
#> trt2-trt4  0.0108850553
#> trt2-trt5  0.0657642220
#> trt3-trt4 -0.0265857780
#> trt3-trt5  0.0282933886
#> trt4-trt5  0.0749433886
#> 
#> $RRFC$ciAvgRdrEachTrt
#>        Estimate      StdErr DF    CILower    CIUpper
#> Trt1 0.75321875 0.023507547  3 0.67840724 0.82803026
#> Trt2 0.76007500 0.020694366  3 0.69421629 0.82593371
#> Trt3 0.72260417 0.020680483  3 0.65678964 0.78841869
#> Trt4 0.76925417 0.031067379  3 0.67038390 0.86812443
#> Trt5 0.71437500 0.027317419  3 0.62743878 0.80131122
```

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04-FROC}

* `st3$RRRC$FTests` contains the results of the F-tests.
* The p-value is much smaller than that obtained after converting to an ROC dataset. Specifically, for FROC analysis, the p-value is \ensuremath{1.17105004\times 10^{-4}} while that for ROC analysis is 0.03054456. The F-statistic and the `ddf` are both larger for FROC analysis, both of of which result in increased probability of rejecting the NH, i.e., FROC analysis has greater power than ROC analysis.
* The increased power of FROC analysis has been confirmed in simulation studies [@RN1331].

* `st3$RRRC$ciDiffTrt` contains the confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. The findings are consistent with the prior ROC analysis, the difference being the smaller p-values. 

* `st3$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.
* Looking at the `Estimate` column one confirms that `trt5` has the smallest FOM while `trt4` has the highest (the `Estimates` column is identical for RRRC, FRRC and RRFC analyses).

* `st3$RRRC$st1$RRRC$ciDiffTrtEachRdr` contains confidence intervals for inter-treatment difference FOMs, for each reader, i.e., $CI_{1-\alpha,RRRC,\theta_{i j} - \theta_{i' j}}$.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04-FROC}

* `st3$FRRC$FTests` contains results of the F-test of the NH.
* Again, `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st3$FRRC$ciDiffTrt` contains the confidence intervals for the inter-treatment paired difference FOMs averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. The findings are consistent with the prior ROC analysis, the difference being the smaller p-values. 

* `st3$FRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.
* Looking at the `Estimate` column one confirms that `trt5` has the smallest FOM while `trt4` has the highest.

* `st3$FRRC$st1$FRRC$ciDiffTrtEachRdr` contains confidence intervals for inter-treatment difference FOMs, for each reader, i.e., $CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}}$.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04-FROC}

* `st3$RRFC$FTests` contains results of the F-test of the NH.
* Again, `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st3$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.

* `st3$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.
* The `Estimate` column confirms that `trt5` has the smallest FOM while `trt4` has the highest (the `Estimates` column is identical for RRRC, FRRC and RRFC analyses).

## Using RJafroc for dataset04, FROC analysis, DBM method {#ORApplications-dataset04-FROC-DBM-RJafroc}
* The fourth example again uses `dataset04`, i.e., FROC data, *but this time using DBM analysis*.
* The key difference below is in the call to `StSignificanceTesting()` function, where we set `method = "DBM"`.
* Since DBM analysis is pseudovalue based, and the figure of merit is not the empirical AUC under the ROC, one expects to see differences from the previously presented OR analysis, contained in `st3`.


```r
st4 <- StSignificanceTesting(ds, FOM = FOM, method = "DBM") # Note: using DBM analysis
print(st4)
#> $FOMs
#> $FOMs$foms
#>            rdr1       rdr3       rdr4       rdr5
#> trt1 0.77926667 0.72489167 0.70362500 0.80509167
#> trt2 0.78700000 0.72690000 0.72261667 0.80378333
#> trt3 0.72969167 0.71575833 0.67230833 0.77265833
#> trt4 0.81013333 0.74311667 0.69435833 0.82940833
#> trt5 0.74880000 0.68227500 0.65517500 0.77125000
#> 
#> $FOMs$trtMeans
#>        Estimate
#> trt1 0.75321875
#> trt2 0.76007500
#> trt3 0.72260417
#> trt4 0.76925417
#> trt5 0.71437500
#> 
#> $FOMs$trtMeanDiffs
#>                Estimate
#> trt1-trt2 -0.0068562500
#> trt1-trt3  0.0306145833
#> trt1-trt4 -0.0160354167
#> trt1-trt5  0.0388437500
#> trt2-trt3  0.0374708333
#> trt2-trt4 -0.0091791667
#> trt2-trt5  0.0457000000
#> trt3-trt4 -0.0466500000
#> trt3-trt5  0.0082291667
#> trt4-trt5  0.0548791667
#> 
#> 
#> $ANOVA
#> $ANOVA$TRCanova
#>                 SS   DF          MS
#> T       1.85323319    4 0.463308298
#> R       7.08087324    3 2.360291078
#> C     289.60188783  199 1.455285868
#> TR      0.40704839   12 0.033920699
#> TC     95.77167376  796 0.120316173
#> RC    126.90154272  597 0.212565398
#> TRC   226.47948201 2388 0.094840654
#> Total 748.09574113 3999          NA
#> 
#> $ANOVA$VarCom
#>             Estimates
#> VarR    0.00220864564
#> VarC    0.06086224757
#> VarTR  -0.00030459978
#> VarTC   0.00636887974
#> VarRC   0.02354494882
#> VarErr  0.09484065411
#> 
#> $ANOVA$IndividualTrt
#>       DF       Trt1       Trt2       Trt3       Trt4       Trt5
#> msR    3 0.44208381 0.34260543 0.34214590 0.77214565 0.59699308
#> msC  199 0.37540000 0.41591475 0.37228906 0.35823255 0.41471420
#> msRC 597 0.10884091 0.11172795 0.13449426 0.10966274 0.12720215
#> 
#> $ANOVA$IndividualRdr
#>       DF        rdr1        rdr3       rdr4        rdr5
#> msT    4 0.202748581 0.101856101 0.13967618 0.120789532
#> msC  199 0.506428511 0.527767315 0.63031695 0.428469287
#> msTC 796 0.094180042 0.092197347 0.13514708 0.083313668
#> 
#> 
#> $RRRC
#> $RRRC$FTests
#>                  DF          MS     FStat           p
#> Treatment  4.000000 0.463308298 7.8002997 0.000117105
#> Error     36.793343 0.059396218        NA          NA
#> 
#> $RRRC$ciDiffTrt
#>                Estimate     StdErr        DF           t         PrGTt
#> trt1-trt2 -0.0068562500 0.01218567 36.793343 -0.56264860 5.7708666e-01
#> trt1-trt3  0.0306145833 0.01218567 36.793343  2.51234312 1.6509287e-02
#> trt1-trt4 -0.0160354167 0.01218567 36.793343 -1.31592413 1.9633987e-01
#> trt1-trt5  0.0388437500 0.01218567 36.793343  3.18765822 2.9246461e-03
#> trt2-trt3  0.0374708333 0.01218567 36.793343  3.07499173 3.9557451e-03
#> trt2-trt4 -0.0091791667 0.01218567 36.793343 -0.75327552 4.5607767e-01
#> trt2-trt5  0.0457000000 0.01218567 36.793343  3.75030682 6.0697106e-04
#> trt3-trt4 -0.0466500000 0.01218567 36.793343 -3.82826725 4.8459540e-04
#> trt3-trt5  0.0082291667 0.01218567 36.793343  0.67531510 5.0369787e-01
#> trt4-trt5  0.0548791667 0.01218567 36.793343  4.50358235 6.5228142e-05
#>                 CILower       CIUpper
#> trt1-trt2 -0.0315514439  0.0178389439
#> trt1-trt3  0.0059193894  0.0553097773
#> trt1-trt4 -0.0407306106  0.0086597773
#> trt1-trt5  0.0141485561  0.0635389439
#> trt2-trt3  0.0127756394  0.0621660273
#> trt2-trt4 -0.0338743606  0.0155160273
#> trt2-trt5  0.0210048061  0.0703951939
#> trt3-trt4 -0.0713451939 -0.0219548061
#> trt3-trt5 -0.0164660273  0.0329243606
#> trt4-trt5  0.0301839727  0.0795743606
#> 
#> $RRRC$ciAvgRdrEachTrt
#>        Estimate      StdErr         DF    CILower    CIUpper
#> trt1 0.75321875 0.029762453  7.7084474 0.68413193 0.82230557
#> trt2 0.76007500 0.028433963 10.6920840 0.69727167 0.82287833
#> trt3 0.72260417 0.026924448  8.6191761 0.66128414 0.78392420
#> trt4 0.76925417 0.035719663  5.2424244 0.67869638 0.85981195
#> trt5 0.71437500 0.033251036  6.5854184 0.63473415 0.79401585
#> 
#> 
#> $FRRC
#> $FRRC$FTests
#>            DF         MS     FStat           p
#> Treatment   4 0.46330830 3.8507566 0.004163522
#> Error     796 0.12031617        NA          NA
#> 
#> $FRRC$ciDiffTrt
#>                Estimate      StdErr  DF           t        PrGTt       CILower
#> trt1-trt2 -0.0068562500 0.017343311 796 -0.39532532 0.6927087308 -0.0409002793
#> trt1-trt3  0.0306145833 0.017343311 796  1.76520986 0.0779118871 -0.0034294460
#> trt1-trt4 -0.0160354167 0.017343311 796 -0.92458797 0.3554604706 -0.0500794460
#> trt1-trt5  0.0388437500 0.017343311 796  2.23969634 0.0253859867  0.0047997207
#> trt2-trt3  0.0374708333 0.017343311 796  2.16053518 0.0310289993  0.0034268040
#> trt2-trt4 -0.0091791667 0.017343311 796 -0.52926265 0.5967708242 -0.0432231960
#> trt2-trt5  0.0457000000 0.017343311 796  2.63502167 0.0085768050  0.0116559707
#> trt3-trt4 -0.0466500000 0.017343311 796 -2.68979783 0.0072992573 -0.0806940293
#> trt3-trt5  0.0082291667 0.017343311 796  0.47448649 0.6352831698 -0.0258148626
#> trt4-trt5  0.0548791667 0.017343311 796  3.16428432 0.0016137424  0.0208351374
#>                CIUpper
#> trt1-trt2  0.027187779
#> trt1-trt3  0.064658613
#> trt1-trt4  0.018008613
#> trt1-trt5  0.072887779
#> trt2-trt3  0.071514863
#> trt2-trt4  0.024864863
#> trt2-trt5  0.079744029
#> trt3-trt4 -0.012605971
#> trt3-trt5  0.042273196
#> trt4-trt5  0.088923196
#> 
#> $FRRC$ciAvgRdrEachTrt
#>        Estimate      StdErr  DF    CILower    CIUpper
#> trt1 0.75321875 0.021662179 199 0.71050187 0.79593563
#> trt2 0.76007500 0.022801172 199 0.71511208 0.80503792
#> trt3 0.72260417 0.021572235 199 0.68006466 0.76514368
#> trt4 0.76925417 0.021161065 199 0.72752547 0.81098287
#> trt5 0.71437500 0.022768240 199 0.66947702 0.75927298
#> 
#> $FRRC$ciDiffTrtEachRdr
#>                      Estimate      StdErr  DF            t        PrGTt
#> rdr1::trt1-trt2 -0.0077333333 0.030688767 199 -0.251992312 0.8013070675
#> rdr1::trt1-trt3  0.0495750000 0.030688767 199  1.615411921 0.1078058305
#> rdr1::trt1-trt4 -0.0308666667 0.030688767 199 -1.005796899 0.3157346970
#> rdr1::trt1-trt5  0.0304666667 0.030688767 199  0.992762814 0.3220311471
#> rdr1::trt2-trt3  0.0573083333 0.030688767 199  1.867404232 0.0633155472
#> rdr1::trt2-trt4 -0.0231333333 0.030688767 199 -0.753804588 0.4518575457
#> rdr1::trt2-trt5  0.0382000000 0.030688767 199  1.244755126 0.2146856872
#> rdr1::trt3-trt4 -0.0804416667 0.030688767 199 -2.621208820 0.0094386515
#> rdr1::trt3-trt5 -0.0191083333 0.030688767 199 -0.622649106 0.5342279782
#> rdr1::trt4-trt5  0.0613333333 0.030688767 199  1.998559713 0.0470170958
#> rdr3::trt1-trt2 -0.0020083333 0.030364016 199 -0.066141888 0.9473312632
#> rdr3::trt1-trt3  0.0091333333 0.030364016 199  0.300794643 0.7638851251
#> rdr3::trt1-trt4 -0.0182250000 0.030364016 199 -0.600217047 0.5490444896
#> rdr3::trt1-trt5  0.0426166667 0.030364016 199  1.403525367 0.1620187360
#> rdr3::trt2-trt3  0.0111416667 0.030364016 199  0.366936530 0.7140562449
#> rdr3::trt2-trt4 -0.0162166667 0.030364016 199 -0.534075159 0.5938856422
#> rdr3::trt2-trt5  0.0446250000 0.030364016 199  1.469667254 0.1432310786
#> rdr3::trt3-trt4 -0.0273583333 0.030364016 199 -0.901011689 0.3686712399
#> rdr3::trt3-trt5  0.0334833333 0.030364016 199  1.102730724 0.2714759176
#> rdr3::trt4-trt5  0.0608416667 0.030364016 199  2.003742413 0.0464538856
#> rdr4::trt1-trt2 -0.0189916667 0.036762356 199 -0.516606359 0.6060045976
#> rdr4::trt1-trt3  0.0313166667 0.036762356 199  0.851867792 0.3953114650
#> rdr4::trt1-trt4  0.0092666667 0.036762356 199  0.252069448 0.8012475297
#> rdr4::trt1-trt5  0.0484500000 0.036762356 199  1.317924254 0.1890441132
#> rdr4::trt2-trt3  0.0503083333 0.036762356 199  1.368474152 0.1727066684
#> rdr4::trt2-trt4  0.0282583333 0.036762356 199  0.768675807 0.4429970724
#> rdr4::trt2-trt5  0.0674416667 0.036762356 199  1.834530613 0.0680683497
#> rdr4::trt3-trt4 -0.0220500000 0.036762356 199 -0.599798344 0.5493229753
#> rdr4::trt3-trt5  0.0171333333 0.036762356 199  0.466056461 0.6416848108
#> rdr4::trt4-trt5  0.0391833333 0.036762356 199  1.065854806 0.2877807352
#> rdr5::trt1-trt2  0.0013083333 0.028864107 199  0.045327345 0.9638918444
#> rdr5::trt1-trt3  0.0324333333 0.028864107 199  1.123656212 0.2625125832
#> rdr5::trt1-trt4 -0.0243166667 0.028864107 199 -0.842453450 0.4005455428
#> rdr5::trt1-trt5  0.0338416667 0.028864107 199  1.172448067 0.2424188377
#> rdr5::trt2-trt3  0.0311250000 0.028864107 199  1.078328867 0.2821923628
#> rdr5::trt2-trt4 -0.0256250000 0.028864107 199 -0.887780794 0.3757304216
#> rdr5::trt2-trt5  0.0325333333 0.028864107 199  1.127120723 0.2610486764
#> rdr5::trt3-trt4 -0.0567500000 0.028864107 199 -1.966109662 0.0506765926
#> rdr5::trt3-trt5  0.0014083333 0.028864107 199  0.048791855 0.9611341077
#> rdr5::trt4-trt5  0.0581583333 0.028864107 199  2.014901517 0.0452606144
#>                        CILower        CIUpper
#> rdr1::trt1-trt2 -0.06825024821  0.05278358154
#> rdr1::trt1-trt3 -0.01094191487  0.11009191487
#> rdr1::trt1-trt4 -0.09138358154  0.02965024821
#> rdr1::trt1-trt5 -0.03005024821  0.09098358154
#> rdr1::trt2-trt3 -0.00320858154  0.11782524821
#> rdr1::trt2-trt4 -0.08365024821  0.03738358154
#> rdr1::trt2-trt5 -0.02231691487  0.09871691487
#> rdr1::trt3-trt4 -0.14095858154 -0.01992475179
#> rdr1::trt3-trt5 -0.07962524821  0.04140858154
#> rdr1::trt4-trt5  0.00081641846  0.12185024821
#> rdr3::trt1-trt2 -0.06188485336  0.05786818669
#> rdr3::trt1-trt3 -0.05074318669  0.06900985336
#> rdr3::trt1-trt4 -0.07810152003  0.04165152003
#> rdr3::trt1-trt5 -0.01725985336  0.10249318669
#> rdr3::trt2-trt3 -0.04873485336  0.07101818669
#> rdr3::trt2-trt4 -0.07609318669  0.04365985336
#> rdr3::trt2-trt5 -0.01525152003  0.10450152003
#> rdr3::trt3-trt4 -0.08723485336  0.03251818669
#> rdr3::trt3-trt5 -0.02639318669  0.09335985336
#> rdr3::trt4-trt5  0.00096514664  0.12071818669
#> rdr4::trt1-trt2 -0.09148543428  0.05350210095
#> rdr4::trt1-trt3 -0.04117710095  0.10381043428
#> rdr4::trt1-trt4 -0.06322710095  0.08176043428
#> rdr4::trt1-trt5 -0.02404376761  0.12094376761
#> rdr4::trt2-trt3 -0.02218543428  0.12280210095
#> rdr4::trt2-trt4 -0.04423543428  0.10075210095
#> rdr4::trt2-trt5 -0.00505210095  0.13993543428
#> rdr4::trt3-trt4 -0.09454376761  0.05044376761
#> rdr4::trt3-trt5 -0.05536043428  0.08962710095
#> rdr4::trt4-trt5 -0.03331043428  0.11167710095
#> rdr5::trt1-trt2 -0.05561043170  0.05822709837
#> rdr5::trt1-trt3 -0.02448543170  0.08935209837
#> rdr5::trt1-trt4 -0.08123543170  0.03260209837
#> rdr5::trt1-trt5 -0.02307709837  0.09076043170
#> rdr5::trt2-trt3 -0.02579376504  0.08804376504
#> rdr5::trt2-trt4 -0.08254376504  0.03129376504
#> rdr5::trt2-trt5 -0.02438543170  0.08945209837
#> rdr5::trt3-trt4 -0.11366876504  0.00016876504
#> rdr5::trt3-trt5 -0.05551043170  0.05832709837
#> rdr5::trt4-trt5  0.00123956830  0.11507709837
#> 
#> 
#> $RRFC
#> $RRFC$FTests
#>           DF          MS     FStat             p
#> Treatment  4 0.463308298 13.658572 0.00020192224
#> Error     12 0.033920699        NA            NA
#> 
#> $RRFC$ciDiffTrt
#>                Estimate       StdErr DF           t         PrGTt      CILower
#> trt1-trt2 -0.0068562500 0.0092087864 12 -0.74453350 4.7088356e-01 -0.026920472
#> trt1-trt3  0.0306145833 0.0092087864 12  3.32449706 6.0595183e-03  0.010550361
#> trt1-trt4 -0.0160354167 0.0092087864 12 -1.74131704 1.0717825e-01 -0.036099639
#> trt1-trt5  0.0388437500 0.0092087864 12  4.21811825 1.1928824e-03  0.018779528
#> trt2-trt3  0.0374708333 0.0092087864 12  4.06903056 1.5563074e-03  0.017406611
#> trt2-trt4 -0.0091791667 0.0092087864 12 -0.99678353 3.3854538e-01 -0.029243389
#> trt2-trt5  0.0457000000 0.0092087864 12  4.96265175 3.2930420e-04  0.025635778
#> trt3-trt4 -0.0466500000 0.0092087864 12 -5.06581410 2.7711820e-04 -0.066714222
#> trt3-trt5  0.0082291667 0.0092087864 12  0.89362119 3.8909518e-01 -0.011835055
#> trt4-trt5  0.0548791667 0.0092087864 12  5.95943529 6.6167481e-05  0.034814945
#>                 CIUpper
#> trt1-trt2  0.0132079720
#> trt1-trt3  0.0506788053
#> trt1-trt4  0.0040288053
#> trt1-trt5  0.0589079720
#> trt2-trt3  0.0575350553
#> trt2-trt4  0.0108850553
#> trt2-trt5  0.0657642220
#> trt3-trt4 -0.0265857780
#> trt3-trt5  0.0282933886
#> trt4-trt5  0.0749433886
#> 
#> $RRFC$ciAvgRdrEachTrt
#>        Estimate      StdErr DF    CILower    CIUpper
#> trt1 0.75321875 0.023507547  3 0.67840724 0.82803026
#> trt2 0.76007500 0.020694366  3 0.69421629 0.82593371
#> trt3 0.72260417 0.020680483  3 0.65678964 0.78841869
#> trt4 0.76925417 0.031067379  3 0.67038390 0.86812443
#> trt5 0.71437500 0.027317419  3 0.62743878 0.80131122
```

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04-FROC-DBM}

* `st4$RRRC$FTests` contains the results of the F-test of the NH.

* `st4$RRRC$ciDiffTrt` contains the confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.

* `st4$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04-FROC-DBM}

* `st4$FRRC$FTests` contains results of the F-test of the NH, which is actually a chi-square statistic.

* `st4$FRRC$ciDiffTrt` contains confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. The findings are consistent with the prior ROC analysis, the difference being the smaller p-values. 

* `st4$FRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.

* `st4$FRRC$ciDiffTrtEachRdr` contains confidence intervals for inter-treatment difference FOMs, for each reader, i.e., $CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}}$.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04-FROC-DBM}

* `st4$RRFC$FTests` contains the results of the F-test of the NH.

* `st4$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment paired difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.

* `st4$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.
* The `Estimate` column confirms that `trt5` has the smallest FOM while `trt4` has the highest (the `Estimates` column is identical for RRRC, FRRC and RRFC analyses).


## Discussion/Summary/5

## Tentative, need to think over {#ToMullOver1-tentative}


```r
ds1 <- dataset04 # do NOT convert to ROC
# comment/uncomment following code to disable/enable unequal weights
# K2 <- length(ds1$ratings$LL[1,1,,1])
# weights <- array(dim = c(K2, max(ds1$lesions$perCase)))
# perCase <- ds1$lesions$perCase
# for (k2 in 1:K2) {
#   sum <- 0
#   for (el in 1:perCase[k2]) {
#     weights[k2,el] <- 1/el
#     sum <- sum + 1/el
#   }
#   weights[k2,1:perCase[k2]] <- weights[k2,1:perCase[k2]] / sum
# }
# ds1$lesions$weights <- weights
ds <- ds1
FOM <- "wAFROC" # also try wAFROC1, MaxLLF and MaxNLF
st5 <- StSignificanceTesting(ds, FOM = FOM, method = "OR")
print(st5)
```

A comparison was run between results of OR and DBM for the FROC dataset. Except for `FRRC`, where differences are expected (because `ddf` in the former is $\infty$, while that in the later is $(I-1)\times(J-1))$, the results for the p-values were identical. This was true for the following FOMs: `wAFROC`, with equal and unequal weights, and `MaxLLF`. The confidence intervals (again, excluding `FRRC`) were identical for `FOM` = `wAFROC`. Slight differences were observed for `FOM` = `MaxLLF`.  

## References {#ORApplications-references}

