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

Dataset `dataset02` is well-know in the literature [@RN1993] as it has been widely used to illustrate advances in ROC methodology. The following code extract the numbers of modalities, readers and cases for `dataset02` and defines strings `modalityID`, `readerID` and `diffTRName` that will be needed later on.


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
* The first step is to calculate the figures of merit. 
* The following code uses `UtilFigureOfMerit()` to this end. Note that `FOM = "Wilcoxon"` has to be explicitly specified.


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

The second example shows application of the `RJafroc` package function `StSignificanceTesting()` to `dataset02`: this function encapsulates all formulae discussed previously and accomplishes all analyses with one function call. 

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset02-RJafroc}
* Since `analysisOption` is not explicitly specified in the following code, the function `StSignificanceTesting` performs all three analyses: `RRRC`, `FRRC` and `RRFC`.
* Likewise, the significance level of the test, also an argument, `alpha`, defaults to 0.05. 
* The code below applies `StSignificanceTesting()` and saves the returned object to `st1`. 
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

* Displayed next are the variance components and mean-squares contained in the `ANOVA` `list` object. 
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

* `RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset02-RJafroc}

* Displayed next are the results of FRRC analysis, contained in the `st1$FRRC` `list` object.
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

* `st1$RRFC$FTests` contains results of the F-test: the degrees of freedom, the mean-squares, the observed value of the F-statistic and the p-value for rejecting the NH, listed separately, where applicable, for the treatment and treatment-reader terms. The latter is also termed the error term. 
* For example, the treatment-reader mean squares is `st1$RRFC$FTests["TR", "MS"]` whose value is \ensuremath{5.51030622\times 10^{-4}}.


```r
print(st1$RRFC$ciDiffTrt)
#>               Estimate      StdErr DF          t       PrGTt      CILower
#> trt0-trt1 -0.043800322 0.014846287  4 -2.9502542 0.041958752 -0.085020224
#>                 CIUpper
#> trt0-trt1 -0.0025804202
```

* `st1$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.



```r
print(st1$RRFC$ciAvgRdrEachTrt)
#>        Estimate      StdErr DF    CILower    CIUpper
#> Trt0 0.89703704 0.024829936  4 0.82809808 0.96597599
#> Trt1 0.94083736 0.016153030  4 0.89598936 0.98568536
```

* `st1$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.

## Using RJafroc: dataset04 {#ORApplications-dataset04-RJafroc}
* The second example uses the Federica Zanca dataset [@RN1882], i.e., `dataset04`, which has five modalities and four readers. 
* This illustrates the situation when multiple treatment pairings are involved. In contrast, the previous example had only one treatment pairing.
* Since this is an FROC dataset, in order to keep this comparable with the previous example, one converts it to an inferred-ROC dataset.
* The function `DfFroc2Roc(dataset04)` converts, using the highest-rating, the FROC dataset to an inferred-ROC dataset.
* The results are contained in `st2`.


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

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04}


```r
print(st2$RRRC$FTests)
#>                  DF            MS     FStat           p
#> Treatment  4.000000 0.00189695737 3.4682364 0.030544556
#> Error     16.803749 0.00054695157        NA          NA
```

* In this example `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing is guaranteed to be significantly different from zero.


```r
print(st2$RRRC$ciDiffTrt)
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
```

* With I = 5 treatments there are 10 distinct comparisons listed above. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. 


```r
print(st2$RRRC$ciAvgRdrEachTrt)
#>       Estimate      StdErr         DF    CILower    CIUpper          Cov2
#> trt1 0.8451625 0.028578244  5.4574766 0.77351391 0.91681109 0.00021118589
#> trt2 0.8502625 0.019928157 27.7225775 0.80942311 0.89110189 0.00026649085
#> trt3 0.8098375 0.026647889  7.0371428 0.74689261 0.87278239 0.00024646233
#> trt4 0.8505750 0.029408701  5.4032614 0.77664342 0.92450658 0.00022042897
#> trt5 0.8083875 0.025758346  6.7756525 0.74706746 0.86970754 0.00022200226
```

* `st2$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.
* Looking at the `Estimate` column one confirms that `trt5` has the smallest FOM while `trt4` has the highest.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04}


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

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04}


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



## Using RJafroc: dataset04, FROC analysis {#ORApplications-dataset04-FROC-RJafroc}
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

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04-FROC}


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

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04-FROC}


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

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04-FROC}


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


## Using RJafroc for dataset04, FROC analysis, DBM method {#ORApplications-dataset04-FROC-DBM-RJafroc}
* The fourth example again uses `dataset04`, i.e., FROC data, *but this time we use DBM analysis*.
* The key difference below is in the call to `StSignificanceTesting()` function, where we set `method = "DBM"`.
* Since DBM analysis is pseudovalue based, and the figure of merit is not the empirical AUC under the ROC, one expects to see differences from the previously presented OR analysis, contained in `st3`.


```r
st4 <- StSignificanceTesting(ds, FOM = FOM, method = "DBM") # Note: using DBM analysis
print(st4$FOMs)
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
print(st4$ANOVA$TRCanova)
#>                 SS   DF          MS
#> T       1.85323319    4 0.463308298
#> R       7.08087324    3 2.360291078
#> C     289.60188783  199 1.455285868
#> TR      0.40704839   12 0.033920699
#> TC     95.77167376  796 0.120316173
#> RC    126.90154272  597 0.212565398
#> TRC   226.47948201 2388 0.094840654
#> Total 748.09574113 3999          NA
print(st4$ANOVA$VarCom)
#>             Estimates
#> VarR    0.00220864564
#> VarC    0.06086224757
#> VarTR  -0.00030459978
#> VarTC   0.00636887974
#> VarRC   0.02354494882
#> VarErr  0.09484065411
```

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04-FROC-DBM}


```r
print(st4$RRRC$FTests)
#>                  DF          MS     FStat           p
#> Treatment  4.000000 0.463308298 7.8002997 0.000117105
#> Error     36.793343 0.059396218        NA          NA
```

* TBA


```r
print(st4$RRRC$ciDiffTrt[,-c(2:5)])
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
print(st4$RRRC$ciAvgRdrEachTrt[,-c(2,3,6)])
#>        Estimate    CILower    CIUpper
#> trt1 0.75321875 0.68413193 0.82230557
#> trt2 0.76007500 0.69727167 0.82287833
#> trt3 0.72260417 0.66128414 0.78392420
#> trt4 0.76925417 0.67869638 0.85981195
#> trt5 0.71437500 0.63473415 0.79401585
```

* TBA

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04-FROC-DBM}


```r
print(st4$FRRC$FTests)
#>            DF         MS     FStat           p
#> Treatment   4 0.46330830 3.8507566 0.004163522
#> Error     796 0.12031617        NA          NA
```

* TBA


```r
print(st4$FRRC$ciDiffTrt[,-c(2:4)])
#>                Estimate        PrGTt       CILower      CIUpper
#> trt1-trt2 -0.0068562500 0.6927087308 -0.0409002793  0.027187779
#> trt1-trt3  0.0306145833 0.0779118871 -0.0034294460  0.064658613
#> trt1-trt4 -0.0160354167 0.3554604706 -0.0500794460  0.018008613
#> trt1-trt5  0.0388437500 0.0253859867  0.0047997207  0.072887779
#> trt2-trt3  0.0374708333 0.0310289993  0.0034268040  0.071514863
#> trt2-trt4 -0.0091791667 0.5967708242 -0.0432231960  0.024864863
#> trt2-trt5  0.0457000000 0.0085768050  0.0116559707  0.079744029
#> trt3-trt4 -0.0466500000 0.0072992573 -0.0806940293 -0.012605971
#> trt3-trt5  0.0082291667 0.6352831698 -0.0258148626  0.042273196
#> trt4-trt5  0.0548791667 0.0016137424  0.0208351374  0.088923196
```

* TBA


```r
print(st4$FRRC$ciAvgRdrEachTrt[,-c(2,3,5)])
#>        Estimate    CILower
#> trt1 0.75321875 0.71050187
#> trt2 0.76007500 0.71511208
#> trt3 0.72260417 0.68006466
#> trt4 0.76925417 0.72752547
#> trt5 0.71437500 0.66947702
```

* TBA

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04-FROC-DBM}


```r
print(st4$RRFC$FTests)
#>           DF          MS     FStat             p
#> Treatment  4 0.463308298 13.658572 0.00020192224
#> Error     12 0.033920699        NA            NA
```

* TBA


```r
print(st4$RRFC$ciDiffTrt[,-c(2,3,4,5)])
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

## Tentative, need to think over {#ToMullOver1-tentative}
A comparison was run between results of OR and DBM for the FROC dataset. Except for `FRRC`, where differences are expected (because `ddf` in the former is $\infty$, while that in the later is $(I-1)\times(J-1))$, the results for the p-values were identical. This was true for the following FOMs: `wAFROC`, with equal and unequal weights, and `MaxLLF`. The confidence intervals (again, excluding `FRRC`) were identical for `FOM` = `wAFROC`. Slight differences were observed for `FOM` = `MaxLLF`.  

## References {#ORApplications-references}

