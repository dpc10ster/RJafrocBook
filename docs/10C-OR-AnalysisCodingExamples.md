---
output:
  pdf_document: default
  html_document: default
---
# Illustration of the OR method {#ORExamples}



## Introduction {#ORExamples-introduction}
* Four examples are given. The first three use OR analysis, while the last one uses the pseudovalue-based DBM analysis.
* The first example uses a two-treatment five-reader **ROC** dataset, a well-know and widely used dataset in the literature [@RN1993]. 
* The second example uses a five-treatment four-reader **ROC** dataset, showing the effect of multiple treatment pairings. 
* The third example uses a five-treatment four-reader **FROC** dataset, showing the key difference involved in FROC analysis, namely the choice of figure of merit. 
* The fourth example uses a five-treatment four-reader **FROC** dataset, showing the key difference involved in DBM vs. OR analysis. 
* Each analysis involves the following steps: 
    + Calculate the figure of merit, 
    + Calculate the variance-covariance matrix and the mean-squares, and 
    + Calculate the NH statistic, p-value and confidence interval(s).

## Illustration with dataset02 {#ORExamples-dataset02}
* `dataset02` has two modalities and five readers. 


```r
I <- length(dataset02$ratings$NL[,1,1,1])
J <- length(dataset02$ratings$NL[1,,1,1])
cat("I = ", I, ", J = ", J, "\n")
#> I =  2 , J =  5
```

### Random-Reader Random-Case (RRRC) analysis {#ORExamples-RRRC-dataset02}
* The first step is to calculate the figures of merit. 
* The following code uses `UtilFigureOfMerit()` to this end. Note that `FOM` has to be explicitly specified as "Wilcoxon".


```r
foms <- UtilFigureOfMerit(dataset02, FOM = "Wilcoxon")
print(foms)
#>           rdr0      rdr1      rdr2      rdr3      rdr4
#> trt0 0.9196457 0.8587762 0.9038647 0.9731079 0.8297907
#> trt1 0.9478261 0.9053140 0.9217391 0.9993559 0.9299517
```

* For example, for the first treatment, `trt0`, the second reader's figure of merit is 0.8587762.
* The next step is to calculate the variance-covariance matrix and the mean-squares.
* The function `UtilORVarComponentsFactorial()` returns these quantities. The `Factorial` in the function name is due to the fact that this code applies to the factorial design. A different function is used for a split-plot design.
* For compactness only the first two members of the returned object are displayed. The remaining members are used in single-treatment and single-reader analyses.


```r
ret <- UtilORVarComponentsFactorial(dataset02, FOM = "Wilcoxon", covEstMethod = "jackknife")
print(ret$TRanova)
#>             SS DF           MS
#> T  0.004796171  1 0.0047961705
#> R  0.015344800  4 0.0038362000
#> TR 0.002204122  4 0.0005510306
print(ret$VarCom)
#>          Estimates      Rhos
#> VarR  0.0015349993        NA
#> VarTR 0.0002004025        NA
#> Cov1  0.0003466137 0.4320314
#> Cov2  0.0003440748 0.4288668
#> Cov3  0.0002390284 0.2979333
#> Var   0.0008022883        NA
```

* The next step is the calculate the NH testing statistic. 
* The relevant equation is Eqn. \@ref(eq:F-ORH-RRRC). 
* `ret` contains the values needed in this equation, as follows:
   + MS(T) is in `ret$TRanova["T", "MS"]`, whose value is 0.0047962. 
   + MS(TR) is in `ret$TRanova["TR", "MS"]`, whose value is \ensuremath{5.5103062\times 10^{-4}}. 
   + `J`, the number of readers, is the length of the second dimension of `dataset02$ratings$NL`, i.e., 5. 
   + `Cov2` is in `ret$VarCom["Cov2", "Estimates"]`, whose value is \ensuremath{3.4407483\times 10^{-4}}. 
   + `Cov3` is in `ret$VarCom["Cov3", "Estimates"]`, whose value is \ensuremath{2.3902837\times 10^{-4}}. 

Applying Eqn. \@ref(eq:F-ORH-RRRC) one gets (`den` is the denominator on the right hand side of the referenced equation):


```r
den <- ret$TRanova["TR", "MS"] + J* max(ret$VarCom["Cov2", "Estimates"] - ret$VarCom["Cov3", "Estimates"],0)
F_ORH_RRRC <- ret$TRanova["T", "MS"]/den
print(F_ORH_RRRC)
#> [1] 4.456319
```

* The next step is calculation of the denominator degrees of freedom.
* From the previous chapter, `ddf` is calculated using Eqn. \@ref(eq:ddfH-RRRC)). The numerator of `ddf` is seen to be identical to `den^2`, where `den` was calculated in the preceding code block. The implementation follows:


```r
ddf <- den^2*(I-1)*(J-1)/(ret$TRanova["TR", "MS"])^2
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
* The next step is calculation of confidence intervals.
* Since `I` = 2, their is only one paired difference in reader-averaged FOMs, namely, the first treatment minus the second:


```r
trtMeans <- rowMeans(foms)
trtMeanDiffs <- trtMeans[1] - trtMeans[2]
print(trtMeanDiffs)
#>        trt0 
#> -0.04380032
```

* From the previous chapter, the $(1-\alpha)$ confidence interval for $\theta_{1 \bullet} - \theta_{2 \bullet}$ is given by Eqn. \@ref(eq:CI-RRRC).
* The expression inside the square-root symbol is `2/J*den`. The implementation follows:


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

* The confidence interval includes zero, which confirms that the reader-averaged FOM difference between treatments is not significant. 
* Finally, the preceding results are next compared to `RJafroc`.
* This is accomplished using the significance testing function `StSignificanceTesting()`. 
* This function takes as arguments the `dataset`, the `FOM`, set to "Wilcoxon", the method of analysis, set to "OR" and `analysisOption`, set to "RRRC". The significance level of the test, also an argument, `alpha`, defaults to 0.05. 
* The code below applies this function and saves the returned object to `st1`. 
* The first member of this object, a  `list` object named `FOMs`, is then displayed. 
* `FOMs` contains three data frames: 
   + `FOMS$foms`, the figures of merit for each treatment and reader, 
   + `FOMS$trtMeans`, the figures of merit for each treatment averaged over readers, and 
   + `FOMS$trtMeanDiffs`, the inter-treatment difference figures of merit averaged over readers. The difference is always the first treatment minus the second, etc., in this example, `trt0` minus `trt1`.


```r
st1 <- StSignificanceTesting(dataset02, FOM = "Wilcoxon", method = "OR", analysisOption = "RRRC")
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
print(st1$RRRC)
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

### Fixed-Reader Random-Case (FRRC) analysis {#ORExamples-FRRC-dataset02}


```r
st1 <- StSignificanceTesting(dataset02, FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC")
print(st1$FRRC)
#> $FTests
#>                      MS     Chisq DF           p
#> Treatment 0.00479617053 5.4759532  1 0.019279843
#> Error     0.00087586039        NA NA          NA
#> 
#> $ciDiffTrt
#>               Estimate      StdErr          z       PrGTz      CILower
#> trt0-trt1 -0.043800322 0.018717483 -2.3400755 0.019279843 -0.080485914
#>                 CIUpper
#> trt0-trt1 -0.0071147303
#> 
#> $ciAvgRdrEachTrt
#>        Estimate      StdErr  DF    CILower    CIUpper
#> trt0 0.89703704 0.024289710 113 0.84943008 0.94464399
#> trt1 0.94083736 0.016776324 113 0.90795637 0.97371835
#> 
#> $ciDiffTrtEachRdr
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
#> 
#> $IndividualRdrVarCov1
#>         varEachRdr   cov1EachRdr
#> rdr0 0.00069890056 3.7346610e-04
#> rdr1 0.00110605283 7.6015978e-04
#> rdr2 0.00084234345 3.5532241e-04
#> rdr3 0.00015057773 1.0833995e-06
#> rdr4 0.00121356676 2.4303685e-04
```

### Random-Reader Fixed-Case (RRFC) analysis {#ORExamples-RRFC-dataset02}


```r
st1 <- StSignificanceTesting(dataset02, FOM = "Wilcoxon", method = "OR", analysisOption = "RRFC")
print(st1$RRFC)
#> $FTests
#>    DF            MS     F           p
#> T   1 0.00479617053 8.704 0.041958752
#> TR  4 0.00055103062    NA          NA
#> 
#> $ciDiffTrt
#>               Estimate      StdErr DF          t       PrGTt      CILower
#> trt0-trt1 -0.043800322 0.014846287  4 -2.9502542 0.041958752 -0.085020224
#>                 CIUpper
#> trt0-trt1 -0.0025804202
#> 
#> $ciAvgRdrEachTrt
#>        Estimate      StdErr DF    CILower    CIUpper
#> Trt0 0.89703704 0.024829936  4 0.82809808 0.96597599
#> Trt1 0.94083736 0.016153030  4 0.89598936 0.98568536
```

## Illustration with dataset04 {#ORExamples-dataset04}
* The second example uses the Federica Zanca dataset [@RN1882], i.e., `dataset04`, which has five modalities and four readers. 
* This illustrates the situation when multiple treatment pairings are involved. In contrast, the previous example had only one treatment pairing.
* Since this is an FROC dataset, in order to keep this comparable with the previous example, one converts it to an inferred-ROC dataset.
* The function `DfFroc2Roc(dataset04)` converts, using the highest-rating, the FROC dataset to an inferred-ROC dataset.
* Since `analysisOption` is not explicitly specified in the following code, the function `StSignificanceTesting` performs all three analyses: `RRRC`, `FRRC` and `RRFC`.
* These are contained in the returned `list` object `st2`.


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

* TBA


```r
print(st2$RRRC$ciAvgRdrEachTrt)
#>       Estimate      StdErr         DF    CILower    CIUpper          Cov2
#> trt1 0.8451625 0.028578244  5.4574766 0.77351391 0.91681109 0.00021118589
#> trt2 0.8502625 0.019928157 27.7225775 0.80942311 0.89110189 0.00026649085
#> trt3 0.8098375 0.026647889  7.0371428 0.74689261 0.87278239 0.00024646233
#> trt4 0.8505750 0.029408701  5.4032614 0.77664342 0.92450658 0.00022042897
#> trt5 0.8083875 0.025758346  6.7756525 0.74706746 0.86970754 0.00022200226
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
print(st2$FRRC$ciDiffTrt)
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
```

* TBA


```r
print(st2$FRRC$ciAvgRdrEachTrt)
#>       Estimate      StdErr  DF    CILower    CIUpper
#> trt1 0.8451625 0.018330868 199 0.80923466 0.88109034
#> trt2 0.8502625 0.019688383 199 0.81167398 0.88885102
#> trt3 0.8098375 0.020095125 199 0.77045178 0.84922322
#> trt4 0.8505750 0.018626607 199 0.81406752 0.88708248
#> trt5 0.8083875 0.019670005 199 0.76983500 0.84694000
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
print(st2$RRFC)
#> $FTests
#>    DF            MS         F           p
#> T   4 0.00189695737 4.1041306 0.025328308
#> TR 12 0.00046220687        NA          NA
#> 
#> $ciDiffTrt
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
#> $ciAvgRdrEachTrt
#>       Estimate      StdErr DF    CILower    CIUpper
#> Trt1 0.8451625 0.024607522  3 0.76685038 0.92347462
#> Trt2 0.8502625 0.011429811  3 0.81388774 0.88663726
#> Trt3 0.8098375 0.021532479  3 0.74131154 0.87836346
#> Trt4 0.8505750 0.025385876  3 0.76978581 0.93136419
#> Trt5 0.8083875 0.021011667  3 0.74151900 0.87525600
```


## Illustration with dataset04, FROC analysis {#ORExamples-dataset04-FROC}
* The third example uses `dataset04`, but this time we use the FROC data, i.e, we do not convert it to inferred-ROC. 
* Since this is an FROC dataset, one needs to use an FROC figure of merit. 
* In this example the weighted AFROC figure of merit `FOM = "wAFROC"` is specified. This is the recommended figure of merit when both normal and abnormal cases are present in the dataset.
* If the dataset does not contain normal cases, then the weighted AFROC1 figure of merit `FOM = "wAFROC1"` should be specified. 


```r
ds <- dataset04 # do NOT convert to ROC
st3 <- StSignificanceTesting(ds, FOM = "wAFROC", method = "OR")
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
print(st3$RRRC$ciDiffTrt)
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
```

* TBA


```r
print(st3$RRRC$ciAvgRdrEachTrt)
#>        Estimate      StdErr         DF    CILower    CIUpper          Cov2
#> trt1 0.75321875 0.029762453  7.7084474 0.68413193 0.82230557 0.00033319886
#> trt2 0.76007500 0.028433963 10.6920840 0.69727167 0.82287833 0.00038023350
#> trt3 0.72260417 0.026924448  8.6191761 0.66128414 0.78392420 0.00029724350
#> trt4 0.76925417 0.035719663  5.2424244 0.67869638 0.85981195 0.00031071226
#> trt5 0.71437500 0.033251036  6.5854184 0.63473415 0.79401585 0.00035939006
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
print(st3$FRRC$ciDiffTrt)
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
```

* TBA


```r
print(st3$FRRC$ciAvgRdrEachTrt)
#>        Estimate      StdErr  DF    CILower    CIUpper
#> trt1 0.75321875 0.021662179 199 0.71076166 0.79567584
#> trt2 0.76007500 0.022801172 199 0.71538552 0.80476448
#> trt3 0.72260417 0.021572235 199 0.68032336 0.76488497
#> trt4 0.76925417 0.021161065 199 0.72777924 0.81072909
#> trt5 0.71437500 0.022768240 199 0.66975007 0.75899993
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
print(st3$RRFC)
#> $FTests
#>    DF            MS         F             p
#> T   4 0.00231654149 13.658572 0.00020192224
#> TR 12 0.00016960349        NA            NA
#> 
#> $ciDiffTrt
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
#> $ciAvgRdrEachTrt
#>        Estimate      StdErr DF    CILower    CIUpper
#> Trt1 0.75321875 0.023507547  3 0.67840724 0.82803026
#> Trt2 0.76007500 0.020694366  3 0.69421629 0.82593371
#> Trt3 0.72260417 0.020680483  3 0.65678964 0.78841869
#> Trt4 0.76925417 0.031067379  3 0.67038390 0.86812443
#> Trt5 0.71437500 0.027317419  3 0.62743878 0.80131122
```


## Illustration with dataset04, FROC analysis, DBM significance testing {#ORExamples-dataset04-FROC-DBM}
* The fourth example again uses `dataset04`, i.e., FROC data, *but this time we use DBM analysis*.
* The key difference below is in the call to `StSignificanceTesting()` function, where we set `method = "DBM"`.
* Since DBM analysis is pseudovalue based, and the figure of merit is not the empirical AUC under the ROC, one expects to see differences from the previously presented OR analysis, contained in `st3`.


```r
ds <- dataset04 # do NOT convert to ROC
st4 <- StSignificanceTesting(ds, FOM = "wAFROC", method = "DBM") # Note we are using DBM analysis
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

### Random-Reader Random-Case (RRRC) analysis {#ORExamples-RRRC-dataset04-FROC-DBM}


```r
print(st4$RRRC$FTests)
#>                  DF          MS     FStat           p
#> Treatment  4.000000 0.463308298 7.8002997 0.000117105
#> Error     36.793343 0.059396218        NA          NA
```

* TBA


```r
print(st4$RRRC$ciDiffTrt)
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
```

* TBA


```r
print(st4$RRRC$ciAvgRdrEachTrt)
#>        Estimate      StdErr         DF    CILower    CIUpper
#> trt1 0.75321875 0.029762453  7.7084474 0.68413193 0.82230557
#> trt2 0.76007500 0.028433963 10.6920840 0.69727167 0.82287833
#> trt3 0.72260417 0.026924448  8.6191761 0.66128414 0.78392420
#> trt4 0.76925417 0.035719663  5.2424244 0.67869638 0.85981195
#> trt5 0.71437500 0.033251036  6.5854184 0.63473415 0.79401585
```

* TBA

### Fixed-Reader Random-Case (FRRC) analysis {#ORExamples-FRRC-dataset04-FROC-DBM}


```r
print(st4$FRRC$FTests)
#>            DF         MS     FStat           p
#> Treatment   4 0.46330830 3.8507566 0.004163522
#> Error     796 0.12031617        NA          NA
```

* TBA


```r
print(st4$FRRC$ciDiffTrt)
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
```

* TBA


```r
print(st4$FRRC$ciAvgRdrEachTrt)
#>        Estimate      StdErr  DF    CILower    CIUpper
#> trt1 0.75321875 0.021662179 199 0.71050187 0.79593563
#> trt2 0.76007500 0.022801172 199 0.71511208 0.80503792
#> trt3 0.72260417 0.021572235 199 0.68006466 0.76514368
#> trt4 0.76925417 0.021161065 199 0.72752547 0.81098287
#> trt5 0.71437500 0.022768240 199 0.66947702 0.75927298
```

* TBA


```r
print(st4$FRRC$FTests)
#>            DF         MS     FStat           p
#> Treatment   4 0.46330830 3.8507566 0.004163522
#> Error     796 0.12031617        NA          NA
```

* TBA

### Random-Reader Fixed-Case (RRFC) analysis {#ORExamples-RRFC-dataset04-FROC-DBM}


```r
print(st4$RRFC)
#> $FTests
#>           DF          MS     FStat             p
#> Treatment  4 0.463308298 13.658572 0.00020192224
#> Error     12 0.033920699        NA            NA
#> 
#> $ciDiffTrt
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
#> $ciAvgRdrEachTrt
#>        Estimate      StdErr DF    CILower    CIUpper
#> trt1 0.75321875 0.023507547  3 0.67840724 0.82803026
#> trt2 0.76007500 0.020694366  3 0.69421629 0.82593371
#> trt3 0.72260417 0.020680483  3 0.65678964 0.78841869
#> trt4 0.76925417 0.031067379  3 0.67038390 0.86812443
#> trt5 0.71437500 0.027317419  3 0.62743878 0.80131122
```


## Discussion/Summary/5


## References {#ORExamples-references}

