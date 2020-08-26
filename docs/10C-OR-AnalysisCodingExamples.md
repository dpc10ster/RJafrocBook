---
output:
  pdf_document: default
  html_document: default
---
# Illustrations using the Obuchowski Rockette method {#ORExamples} 



## Introduction {#ORExamples-introduction}
* Four examples are given. The first is a hand-calculation (i.e., from first principles, using the relevant formulae in the previous chapter). The next three examples use OR analysis as implemented in the `RJafroc` package. 
* The first example uses a two-treatment five-reader **ROC** dataset, well-know in the literature [@RN1993], as it has been used to illustrate advances in ROC methodology. 
* The second example uses a five-treatment four-reader **ROC** dataset, showing the effect of multiple treatment pairings on the significance testing (the first dataset has only one treatment pairing). 
* The third example uses a five-treatment four-reader **FROC** dataset, showing the key difference involved in FROC analysis. 
* Each analysis involves the following steps: 
+ Calculate the figure of merit, 
+ Calculate the variance-covariance matrix and the mean-squares, and 
+ Calculate the NH statistic, p-value and confidence interval(s).
* Each analysis is illustrated with three generalizations, namely RRRC, FRRC and RRFC.

## Hand calculation using dataset02 {#ORExamples-dataset02-hand}
* `dataset02` has 2 modalities and 5 readers. 


```r
I <- length(dataset02$ratings$NL[,1,1,1])
J <- length(dataset02$ratings$NL[1,,1,1])
modalityID <- dataset02$descriptions$modalityID
readerID <- dataset02$descriptions$readerID
```

* The first step is to calculate the figures of merit. 
* The following code uses `UtilFigureOfMerit()` to this end. Note that `FOM` is explicitly specified as "Wilcoxon".


```r
foms <- UtilFigureOfMerit(dataset02, FOM = "Wilcoxon")
print(foms)
#>           rdr0      rdr1      rdr2      rdr3      rdr4
#> trt0 0.9196457 0.8587762 0.9038647 0.9731079 0.8297907
#> trt1 0.9478261 0.9053140 0.9217391 0.9993559 0.9299517
```

* For example, for the first treatment, `trt0`, the second reader, `rdr1`, figure of merit is 0.8587762.
* The next step is to calculate the variance-covariance matrix and the mean-squares.
* The function `UtilORVarComponentsFactorial()` returns these quantities, which are saved to `vc`. The `Factorial` in the function name is due to the fact that this code applies to the factorial design. A different function is used for a split-plot design.
* Only the first two members of the returned object are displayed in full. The remaining members, `vc$IndividualTrt` and `vc$IndividualRdr`, are used in single-treatment and single-reader analyses.


```r
vc <- UtilORVarComponentsFactorial(
  dataset02, 
  FOM = "Wilcoxon", covEstMethod = "jackknife")
summary(vc)
#>               Length Class      Mode
#> TRanova       3      data.frame list
#> VarCom        2      data.frame list
#> IndividualTrt 4      data.frame list
#> IndividualRdr 4      data.frame list
print(vc$TRanova)
#>             SS DF           MS
#> T  0.004796171  1 0.0047961705
#> R  0.015344800  4 0.0038362000
#> TR 0.002204122  4 0.0005510306
print(vc$VarCom)
#>          Estimates      Rhos
#> VarR  0.0015349993        NA
#> VarTR 0.0002004025        NA
#> Cov1  0.0003466137 0.4320314
#> Cov2  0.0003440748 0.4288668
#> Cov3  0.0002390284 0.2979333
#> Var   0.0008022883        NA
```

### Random-Reader Random-Case (RRRC) analysis {#ORExamples-RRRC-dataset02-hand}
* The next step is the calculate the NH testing statistic. The relevant equation is Eqn. \@ref(eq:F-ORH-RRRC). `vc` contains the values needed in this equation, as follows:
+ MS(T) is contained in `vc$TRanova["T", "MS"]`, whose value is 0.0047962. 
+ MS(TR) is contained in `vc$TRanova["TR", "MS"]`, whose value is \ensuremath{5.5103062\times 10^{-4}}. 
+ `Cov2` is contained in `vc$VarCom["Cov2", "Estimates"]`, whose value is \ensuremath{3.4407483\times 10^{-4}}. 
+ `Cov3` is contained in `vc$VarCom["Cov3", "Estimates"]`, whose value is \ensuremath{2.3902837\times 10^{-4}}. 

[`Cov1`, contained in `vc$VarCom["Cov2", "Estimates"]` is not needed in the current calculation.]

Applying Eqn. \@ref(eq:F-ORH-RRRC) one gets (`den` is the denominator on the right hand side of the referenced equation):


```r
den <- vc$TRanova["TR", "MS"] + 
  J* max(vc$VarCom["Cov2", "Estimates"] - 
           vc$VarCom["Cov3", "Estimates"],0)
F_ORH_RRRC <- vc$TRanova["T", "MS"]/den
print(F_ORH_RRRC)
#> [1] 4.456319
```

* The numerator degrees of freedom is $I-1$.
* The denominator degrees of freedom, `ddf`, is calculated using Eqn. \@ref(eq:ddfH-RRRC)). 
* The numerator of `ddf` is seen to be identical to `den^2`, where `den` was calculated in the preceding code block. The implementation follows:


```r
ddf <- den^2*(I-1)*(J-1)/(vc$TRanova["TR", "MS"])^2
```

* The value of `ddf` is 15.2596746.
* The next step is calculation of the p-value for rejecting the NH.
* The relevant equation is Eqn. \@ref(eq:pValueOR-RRRC) whose implementation follows: 


```r
p_RRRC <- 1 - pf(F_ORH_RRRC, I - 1, ddf)
```

* The p-value is 0.0516657. The difference is not significant at $\alpha$ = 0.05. 
* The next step is calculation of the confidence interval for paired FOM differences. Since `I` = 2, their is only one paired difference in reader-averaged FOMs, namely, the first treatment minus the second:


```r
trtMeans <- rowMeans(foms)
trtMeanDiffs <- trtMeans[1] - trtMeans[2]
```

* The difference in reader-averaged FOM,s i.e., $\theta_{1 \bullet} - \theta_{2 \bullet}$, is -0.0438003.
* The $(1-\alpha)$ confidence interval the difference is given by Eqn. \@ref(eq:CI-RRRC).
* The expression inside the square-root symbol in this equation is `2/J*den`. 
* The implementation follows:


```r
alpha <- 0.05
stdErr <- sqrt(2 * den/J)
tStat <- vector()
PrGTt <- vector()
CI_RRRC <- array(dim = c(length(trtMeanDiffs), 2))
for (i in 1:length(trtMeanDiffs)) {
  tStat[i] <- trtMeanDiffs[i]/stdErr
  PrGTt[i] <- 2*pt(abs(tStat[i]), ddf, lower.tail = FALSE)
  CI_RRRC[i, ] <- sort(c(trtMeanDiffs[i] - qt(alpha/2, ddf) * stdErr, trtMeanDiffs[i] + qt(alpha/2, ddf) * stdErr))
}
print(CI_RRRC)
#>            [,1]         [,2]
#> [1,] -0.0879595 0.0003588544
```

The confidence interval includes zero, which confirms that the reader-averaged FOM difference between treatments is not significant. 

### Fixed-Reader Random-Case (FRRC) analysis {#ORExamples-FRRC-dataset02-hand}
* The F-statistic for testing the NH of no treatment effect was stated in \@ref(eq:DefFStatFRRC-OR). 
* The quantities needed to evaluate the right hand side are:
+ `MS(T)`, which is contained in vc$TRanova["T", "MS"];
+ `Var`, which is contained in vc$VarCom["Var", "Estimates"];
+ `Cov1`, which is contained in vc$VarCom["Cov1", "Estimates"];
+ `Cov2`, which is contained in vc$VarCom["Cov2", "Estimates"];
+ `Cov3`, which is contained in vc$VarCom["Cov3", "Estimates"].
* The implementation follows:


```r
den <- vc$VarCom["Var", "Estimates"] - 
  vc$VarCom["Cov1", "Estimates"] + 
  (J-1) * max(vc$VarCom["Cov2", "Estimates"]-vc$VarCom["Cov3", "Estimates"],0)
F_ORH_FRRC <- vc$TRanova["T", "MS"]/den
print(F_ORH_FRRC)
#> [1] 5.475953
```

* `F_ORH_FRRC` is distributed as an F-statistic with `ndf` = I-1 and `ddf` = infinity. 
* `F_ORH_FRRC` times (I-1) is distributed as a chi-square-statistic with $I-1$ degrees of freedom.
*  The observed value of the chi-square statistic is 5.4759532.
*  The p-value is calculated using \@ref(eq:pValueFRRC-OR), whose implementation follows:


```r
p_FRRC <- 1 - pchisq(F_ORH_FRRC * (I - 1), I - 1)
```

* The p-value is 0.0192798, which is significant at $\alpha$ = 0.05.
* The confidence interval for the difference FOM is in Eqn. \@ref(eq:CIDiffFomFRRC-OR). Its implementation follows: 


```r
stdErr <- sqrt(2/J * (vc$VarCom["Var", "Estimates"] - 
                        vc$VarCom["Cov1", "Estimates"] + 
                        (J-1)*max(vc$VarCom["Cov2", "Estimates"]-vc$VarCom["Cov3", "Estimates"],0)))
zStat <- vector()
PrGTz <- vector()
CI_FRRC <- array(dim = c(choose(I,2),2))
for (i in 1:choose(I,2)) {
  zStat[i] <- trtMeanDiffs[i]/stdErr
  PrGTz[i] <- 2 * pnorm(abs(zStat[i]), lower.tail = FALSE)
  CI_FRRC[i, ] <- c(trtMeanDiffs[i] + qnorm(alpha/2) * stdErr, 
                    trtMeanDiffs[i] + qnorm(1-alpha/2) * stdErr)
}
print(CI_FRRC)
#>             [,1]        [,2]
#> [1,] -0.08048591 -0.00711473
```

Note that this time, consistent with the p-value finding, the confidence interval does not include zero.

One can calculate confidence intervals for each treatment, using data from that treatment only, Eqn.  \@ref(eq:CIIndTrtFomFRRC-OR). The required `Var_i` and `Cov2_i`, calculated over each treatment, are in `vc$IndividualTrt`. The implementation follows.


```r
CI <- array(dim = c(I,2))
ci <- data.frame()
for (i in 1:I) {
  stdErr <- sqrt(1/J * (vc$IndividualTrt[i, "varEachTrt"] + 
                          (J-1)*max(vc$IndividualTrt[i, "cov2EachTrt"],0)))
  t_crit <- abs(qt(alpha/2, Inf))
  CI[i,] <- c(trtMeans[i] - t_crit*stdErr, trtMeans[i] + t_crit*stdErr)
  rowName <- paste0("trt", modalityID[i])
  ci <- rbind(ci, data.frame(Estimate = trtMeans[i], 
                             CILower = CI[i,1],
                             CIUpper = CI[i,2],
                             row.names = rowName,
                             stringsAsFactors = FALSE))
}
print(ci)
#>       Estimate   CILower   CIUpper
#> trt0 0.8970370 0.8494301 0.9446440
#> trt1 0.9408374 0.9079564 0.9737183
```

One can calculate confidence intervals for inter-treatment FOM differences for individual readers. Each analysis is based only on data for the specified reader, i.e, on the reader-specific `AUC`, variance and `Cov1` estimates. The required `Var_j` and `Cov1_j` are in `vc$IndividualRdr`. The implementation follows.


```r
diffTRName <- array(dim = choose(I, 2))
ii <- 1
for (i in 1:I) {
  if (i == I) 
    break
  for (ip in (i + 1):I) {
    diffTRName[ii] <- paste0("trt", modalityID[i], sep = "-", "trt", modalityID[ip]) # !sic
    ii <- ii + 1
  }
}

trtMeanDiffs <- array(dim = c(J, choose(I, 2)))
Reader <- array(dim = c(J, choose(I, 2)))
stdErr <- array(dim = c(J, choose(I, 2)))
zStat <- array(dim = c(J, choose(I, 2)))
trDiffNames <- array(dim = c(J, choose(I, 2)))
PrGTz <- array(dim = c(J, choose(I, 2)))
CIReader <- array(dim = c(J, choose(I, 2),2))
ci <- data.frame()
for (j in 1:J) {
  Reader[j,] <- rep(readerID[j], choose(I, 2))
  stdErr[j,] <- sqrt(2 * (vc$IndividualRdr[j,"varEachRdr"] - vc$IndividualRdr[j,"cov1EachRdr"]))
  pair <- 1
  for (i in 1:I) {
    if (i == I) break
    for (ip in (i + 1):I) {
      trtMeanDiffs[j, pair] <- foms[i, j] - foms[ip, j]
      trDiffNames[j,pair] <- diffTRName[pair]
      zStat[j,pair] <- trtMeanDiffs[j,pair]/stdErr[j,pair]
      PrGTz[j,pair] <- 2 * pnorm(abs(zStat[j,pair]), lower.tail = FALSE)
      CIReader[j, pair,] <- c(trtMeanDiffs[j,pair] + qnorm(alpha/2) * stdErr[j,pair], 
                              trtMeanDiffs[j,pair] + qnorm(1-alpha/2) * stdErr[j,pair])
      rowName <- paste0("rdr", Reader[j,pair], "::", trDiffNames[j, pair])
      ci <- rbind(ci, data.frame(Estimate = trtMeanDiffs[j, pair], 
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
print(ci)
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

### Random-Reader Fixed-Case (RRFC) analysis {#ORExamples-RRFC-dataset02-hand}
TBA

## Using RJafroc: dataset02 {#ORExamples-dataset02-RJafroc}
### Random-Reader Random-Case (RRRC) analysis {#ORExamples-RRRC-dataset02-RJafroc}
* This is accomplished using the significance testing function `StSignificanceTesting()`. 
* Since `analysisOption` is not explicitly specified in the following code, the function `StSignificanceTesting` performs all three analyses: `RRRC`, `FRRC` and `RRFC`.
* The significance level of the test, also an argument, `alpha`, defaults to 0.05. 
* The code below applies this function and saves the returned object to `st1`. 
* The first member of this object, a  `list` object named `FOMs`, is then displayed. 
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

* Displayed next are the variance components and mean-squares. 
* These are contained in the `ANOVA` `list` object. 
* `ANOVA$TRanova` contains the treatment-reader ANOVA table, i.e. the sum of squares, the degrees of freedom and the mean-squares, listed for the treatment, reader and treatment-reader factors, i.e., `T`, `R` and `TR`.
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

* Displayed next are the results of RRRC analysis, contained in the `RRRC` `list` object.
* `RRRC$FTests` contains the results of the F-tests.
* `RRRC$ciDiffTrt` contains the results of the confidence intervals for the inter-treatment difference FOMs, averaged over readers.
* `RRRC$ciAvgRdrEachTrt` contains the results of the confidence intervals for the treatments, averaged over readers.


```r
print(st1$RRRC$FTests)
#>                  DF           MS     FStat           p
#> Treatment  1.000000 0.0047961705 4.4563187 0.051665686
#> Error     15.259675 0.0010762629        NA          NA
```

* TBA


```r
print(st1$RRRC$ciDiffTrt[,-c(2:5)])
#>               Estimate      CILower       CIUpper
#> trt0-trt1 -0.043800322 -0.087959499 0.00035885444
```

* TBA


```r
print(st1$RRRC$ciAvgRdrEachTrt[,-c(2,3,6)])
#>        Estimate    CILower    CIUpper
#> trt0 0.89703704 0.82522360 0.96885048
#> trt1 0.94083736 0.89413783 0.98753689
```

* TBA

### Fixed-Reader Random-Case (FRRC) analysis {#ORExamples-FRRC-dataset02-RJafroc}

* TBA


```r
print(st1$FRRC$FTests)
#>                      MS     Chisq DF           p
#> Treatment 0.00479617053 5.4759532  1 0.019279843
#> Error     0.00087586039        NA NA          NA
```

* TBA


```r
print(st1$FRRC$ciDiffTrt[,-c(2:4)])
#>               Estimate      CILower       CIUpper
#> trt0-trt1 -0.043800322 -0.080485914 -0.0071147303
```

* TBA


```r
print(st1$FRRC$ciAvgRdrEachTrt[,-c(2,3,5)])
#>        Estimate    CILower
#> trt0 0.89703704 0.84943008
#> trt1 0.94083736 0.90795637
```

### Random-Reader Fixed-Case (RRFC) analysis {#ORExamples-RRFC-dataset02-RJafroc}


```r
print(st1$RRFC$FTests)
#>    DF            MS     F           p
#> T   1 0.00479617053 8.704 0.041958752
#> TR  4 0.00055103062    NA          NA
```

* TBA


```r
print(st1$RRFC$ciDiffTrt[,-c(2,3,4,5)])
#>               Estimate      CILower       CIUpper
#> trt0-trt1 -0.043800322 -0.085020224 -0.0025804202
```

## Using RJafroc: dataset04 {#ORExamples-dataset04-RJafroc}
* The second example uses the Federica Zanca dataset [@RN1882], i.e., `dataset04`, which has five modalities and four readers. 
* This illustrates the situation when multiple treatment pairings are involved. In contrast, the previous example had only one treatment pairing.
* Since this is an FROC dataset, in order to keep this comparable with the previous example, one converts it to an inferred-ROC dataset.
* The function `DfFroc2Roc(dataset04)` converts, using the highest-rating, the FROC dataset to an inferred-ROC dataset.
* The results are contained in the returned `list` object `st2`.


```r
ds <- DfFroc2Roc(dataset04) # convert to ROC
I <- length(ds$ratings$NL[,1,1,1])
J <- length(ds$ratings$NL[1,,1,1])
cat("I = ", I, ", J = ", J, "\n")
#> I =  5 , J =  4
st2 <- StSignificanceTesting(ds, FOM = "Wilcoxon", method = "OR")
print(st2$FOMs)
#> $foms
#>         rdr1    rdr2    rdr3    rdr4
#> trt1 0.90425 0.79820 0.81175 0.86645
#> trt2 0.86425 0.84470 0.82050 0.87160
#> trt3 0.81295 0.81635 0.75275 0.85730
#> trt4 0.90235 0.83150 0.78865 0.87980
#> trt5 0.84140 0.77300 0.77115 0.84800
#> 
#> $trtMeans
#>       Estimate
#> trt1 0.8451625
#> trt2 0.8502625
#> trt3 0.8098375
#> trt4 0.8505750
#> trt5 0.8083875
#> 
#> $trtMeanDiffs
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
print(st2$ANOVA$TRanova)
#>              SS DF            MS
#> T  0.0075878295  4 0.00189695737
#> R  0.0218825325  3 0.00729417750
#> TR 0.0055464825 12 0.00046220687
print(st2$ANOVA$VarCom)
#>            Estimates       Rhos
#> VarR   1.2837211e-03         NA
#> VarTR -1.0925227e-05         NA
#> Cov1   2.9480096e-04 0.37358228
#> Cov2   2.3331406e-04 0.29566389
#> Cov3   2.1212789e-04 0.26881601
#> Var    7.8911924e-04         NA
```

### Random-Reader Random-Case (RRRC) analysis {#ORExamples-RRRC-dataset04}


```r
print(st2$RRRC$FTests)
#>                  DF            MS     FStat           p
#> Treatment  4.000000 0.00189695737 3.4682364 0.030544556
#> Error     16.803749 0.00054695157        NA          NA
```

* TBA


```r
print(st2$RRRC$ciDiffTrt[,-c(2:5)])
#>             Estimate        CILower       CIUpper
#> trt1-trt2 -0.0051000 -0.04002130451  0.0298213045
#> trt1-trt3  0.0353250  0.00040369549  0.0702463045
#> trt1-trt4 -0.0054125 -0.04033380451  0.0295088045
#> trt1-trt5  0.0367750  0.00185369549  0.0716963045
#> trt2-trt3  0.0404250  0.00550369549  0.0753463045
#> trt2-trt4 -0.0003125 -0.03523380451  0.0346088045
#> trt2-trt5  0.0418750  0.00695369549  0.0767963045
#> trt3-trt4 -0.0407375 -0.07565880451 -0.0058161955
#> trt3-trt5  0.0014500 -0.03347130451  0.0363713045
#> trt4-trt5  0.0421875  0.00726619549  0.0771088045
```

* TBA


```r
print(st2$RRRC$ciAvgRdrEachTrt[,-c(2,3,6)])
#>       Estimate    CILower    CIUpper
#> trt1 0.8451625 0.77351391 0.91681109
#> trt2 0.8502625 0.80942311 0.89110189
#> trt3 0.8098375 0.74689261 0.87278239
#> trt4 0.8505750 0.77664342 0.92450658
#> trt5 0.8083875 0.74706746 0.86970754
```

* TBA

### Fixed-Reader Random-Case (FRRC) analysis {#ORExamples-FRRC-dataset04}


```r
print(st2$FRRC$FTests)
#>                     MS     Chisq DF            p
#> Treatment 0.0018969574 13.601264  4 0.0086826618
#> Error     0.0005578768        NA NA           NA
```

* TBA


```r
print(st2$FRRC$ciDiffTrt[,-c(2:4)])
#>             Estimate       CILower       CIUpper
#> trt1-trt2 -0.0051000 -0.0378342386  0.0276342386
#> trt1-trt3  0.0353250  0.0025907614  0.0680592386
#> trt1-trt4 -0.0054125 -0.0381467386  0.0273217386
#> trt1-trt5  0.0367750  0.0040407614  0.0695092386
#> trt2-trt3  0.0404250  0.0076907614  0.0731592386
#> trt2-trt4 -0.0003125 -0.0330467386  0.0324217386
#> trt2-trt5  0.0418750  0.0091407614  0.0746092386
#> trt3-trt4 -0.0407375 -0.0734717386 -0.0080032614
#> trt3-trt5  0.0014500 -0.0312842386  0.0341842386
#> trt4-trt5  0.0421875  0.0094532614  0.0749217386
```

* TBA


```r
print(st2$FRRC$ciAvgRdrEachTrt[,-c(2,3,5)])
#>       Estimate    CILower
#> trt1 0.8451625 0.80923466
#> trt2 0.8502625 0.81167398
#> trt3 0.8098375 0.77045178
#> trt4 0.8505750 0.81406752
#> trt5 0.8083875 0.76983500
```

* TBA


```r
print(st2$FRRC$FTests)
#>                     MS     Chisq DF            p
#> Treatment 0.0018969574 13.601264  4 0.0086826618
#> Error     0.0005578768        NA NA           NA
```

* TBA

### Random-Reader Fixed-Case (RRFC) analysis {#ORExamples-RRFC-dataset04}


```r
print(st2$RRFC$FTests)
#>    DF            MS         F           p
#> T   4 0.00189695737 4.1041306 0.025328308
#> TR 12 0.00046220687        NA          NA
```

* TBA


```r
print(st2$RRFC$ciDiffTrt[,-c(2,3,4,5)])
#>             Estimate       CILower       CIUpper
#> trt1-trt2 -0.0051000 -0.0382225014  0.0280225014
#> trt1-trt3  0.0353250  0.0022024986  0.0684475014
#> trt1-trt4 -0.0054125 -0.0385350014  0.0277100014
#> trt1-trt5  0.0367750  0.0036524986  0.0698975014
#> trt2-trt3  0.0404250  0.0073024986  0.0735475014
#> trt2-trt4 -0.0003125 -0.0334350014  0.0328100014
#> trt2-trt5  0.0418750  0.0087524986  0.0749975014
#> trt3-trt4 -0.0407375 -0.0738600014 -0.0076149986
#> trt3-trt5  0.0014500 -0.0316725014  0.0345725014
#> trt4-trt5  0.0421875  0.0090649986  0.0753100014
```



## Using RJafroc: dataset04, FROC analysis {#ORExamples-dataset04-FROC-RJafroc}
* The third example uses `dataset04`, but this time we use the FROC data, i.e, we do not convert it to inferred-ROC. 
* Since this is an FROC dataset, one needs to use an FROC figure of merit. 
* In this example the weighted AFROC figure of merit `FOM = "wAFROC"` is specified. This is the recommended figure of merit when both normal and abnormal cases are present in the dataset.
* If the dataset does not contain normal cases, then the weighted AFROC1 figure of merit `FOM = "wAFROC1"` should be specified. 


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
st3 <- StSignificanceTesting(ds, FOM = FOM, method = "OR")
print(st3$FOMs)
#> $foms
#>            rdr1       rdr3       rdr4       rdr5
#> trt1 0.77926667 0.72489167 0.70362500 0.80509167
#> trt2 0.78700000 0.72690000 0.72261667 0.80378333
#> trt3 0.72969167 0.71575833 0.67230833 0.77265833
#> trt4 0.81013333 0.74311667 0.69435833 0.82940833
#> trt5 0.74880000 0.68227500 0.65517500 0.77125000
#> 
#> $trtMeans
#>        Estimate
#> trt1 0.75321875
#> trt2 0.76007500
#> trt3 0.72260417
#> trt4 0.76925417
#> trt5 0.71437500
#> 
#> $trtMeanDiffs
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
print(st3$ANOVA$TRanova)
#>              SS DF            MS
#> T  0.0092661660  4 0.00231654149
#> R  0.0354043662  3 0.01180145539
#> TR 0.0020352419 12 0.00016960349
print(st3$ANOVA$VarCom)
#>            Estimates       Rhos
#> VarR   0.00220864564         NA
#> VarTR -0.00030459978         NA
#> Cov1   0.00042203598 0.45473916
#> Cov2   0.00033615564 0.36220403
#> Cov3   0.00030431124 0.32789204
#> Var    0.00092808365         NA
```

### Random-Reader Random-Case (RRRC) analysis {#ORExamples-RRRC-dataset04-FROC}


```r
print(st3$RRRC$FTests)
#>                  DF            MS     FStat           p
#> Treatment  4.000000 0.00231654149 7.8002997 0.000117105
#> Error     36.793343 0.00029698109        NA          NA
```

* TBA


```r
print(st3$RRRC$ciDiffTrt[,-c(2:5)])
#>                Estimate       CILower       CIUpper
#> trt1-trt2 -0.0068562500 -0.0315514439  0.0178389439
#> trt1-trt3  0.0306145833  0.0059193894  0.0553097773
#> trt1-trt4 -0.0160354167 -0.0407306106  0.0086597773
#> trt1-trt5  0.0388437500  0.0141485561  0.0635389439
#> trt2-trt3  0.0374708333  0.0127756394  0.0621660273
#> trt2-trt4 -0.0091791667 -0.0338743606  0.0155160273
#> trt2-trt5  0.0457000000  0.0210048061  0.0703951939
#> trt3-trt4 -0.0466500000 -0.0713451939 -0.0219548061
#> trt3-trt5  0.0082291667 -0.0164660273  0.0329243606
#> trt4-trt5  0.0548791667  0.0301839727  0.0795743606
```

* TBA


```r
print(st3$RRRC$ciAvgRdrEachTrt[,-c(2,3,6)])
#>        Estimate    CILower    CIUpper
#> trt1 0.75321875 0.68413193 0.82230557
#> trt2 0.76007500 0.69727167 0.82287833
#> trt3 0.72260417 0.66128414 0.78392420
#> trt4 0.76925417 0.67869638 0.85981195
#> trt5 0.71437500 0.63473415 0.79401585
```

* TBA

### Fixed-Reader Random-Case (FRRC) analysis {#ORExamples-FRRC-dataset04-FROC}


```r
print(st3$FRRC$FTests)
#>                      MS     Chisq DF            p
#> Treatment 0.00231654149 15.403026  4 0.0039343238
#> Error     0.00060158087        NA NA           NA
```

* TBA


```r
print(st3$FRRC$ciDiffTrt[,-c(2:4)])
#>                Estimate       CILower      CIUpper
#> trt1-trt2 -0.0068562500 -0.0408485147  0.027136015
#> trt1-trt3  0.0306145833 -0.0033776814  0.064606848
#> trt1-trt4 -0.0160354167 -0.0500276814  0.017956848
#> trt1-trt5  0.0388437500  0.0048514853  0.072836015
#> trt2-trt3  0.0374708333  0.0034785686  0.071463098
#> trt2-trt4 -0.0091791667 -0.0431714314  0.024813098
#> trt2-trt5  0.0457000000  0.0117077353  0.079692265
#> trt3-trt4 -0.0466500000 -0.0806422647 -0.012657735
#> trt3-trt5  0.0082291667 -0.0257630981  0.042221431
#> trt4-trt5  0.0548791667  0.0208869019  0.088871431
```

* TBA


```r
print(st3$FRRC$ciAvgRdrEachTrt[,-c(2,3,5)])
#>        Estimate    CILower
#> trt1 0.75321875 0.71076166
#> trt2 0.76007500 0.71538552
#> trt3 0.72260417 0.68032336
#> trt4 0.76925417 0.72777924
#> trt5 0.71437500 0.66975007
```

* TBA


```r
print(st3$FRRC$FTests)
#>                      MS     Chisq DF            p
#> Treatment 0.00231654149 15.403026  4 0.0039343238
#> Error     0.00060158087        NA NA           NA
```

* TBA

### Random-Reader Fixed-Case (RRFC) analysis {#ORExamples-RRFC-dataset04-FROC}


```r
print(st3$RRFC$FTests)
#>    DF            MS         F             p
#> T   4 0.00231654149 13.658572 0.00020192224
#> TR 12 0.00016960349        NA            NA
```

* TBA


```r
print(st3$RRFC$ciDiffTrt[,-c(2,3,4,5)])
#>                Estimate      CILower       CIUpper
#> trt1-trt2 -0.0068562500 -0.026920472  0.0132079720
#> trt1-trt3  0.0306145833  0.010550361  0.0506788053
#> trt1-trt4 -0.0160354167 -0.036099639  0.0040288053
#> trt1-trt5  0.0388437500  0.018779528  0.0589079720
#> trt2-trt3  0.0374708333  0.017406611  0.0575350553
#> trt2-trt4 -0.0091791667 -0.029243389  0.0108850553
#> trt2-trt5  0.0457000000  0.025635778  0.0657642220
#> trt3-trt4 -0.0466500000 -0.066714222 -0.0265857780
#> trt3-trt5  0.0082291667 -0.011835055  0.0282933886
#> trt4-trt5  0.0548791667  0.034814945  0.0749433886
```


## Discussion/Summary/5

## References {#ORExamples-references}

