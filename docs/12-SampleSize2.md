# ROC-DBMH sample size from first principles {#SSRocFirstPrinciples}





## Introduction
The starting point is a **pilot** study. The variability in this dataset (specifically the variance components, subsequently converted to mean squares), obtained by running the significance testing function `StSignificanceTesting()`, is used to extrapolate to the necessary numbers of readers and cases, in the **pivotal** study, to achieve the desired power. In this example, the observed effect size in the pilot study is used as the anticipated effect size for the pivotal study – this is generally not a good idea as discussed in **Chapter 11** under "Cautionary notes". Shown below, and the reader should confirm, is a first principles implementation of the relevant formulae in **Chapter 11**.  

## Sample size estimation using the DBMH method
The Van Dyke dataset in file `VanDyke.lrc`, in `"MRMC"` format, is regarded as a pilot study. The command `rocData <- DfReadDataFile(fileName, format = "MRMC")` reads the data and saves it to a `dataset` object `rocData`. [For more on data formats click here](https://dpc10ster.github.io/RJafroc/reference/RJafroc-package.html). The next line uses the function `StSignificanceTesting()` to apply `method = "DBMH"` analysis, the default, using the `FOM = "Wilcoxon"` figure of merit. The next line extracts the variance components `varYTR`, `varYTC` and `varYEps` (the Y's denote pseudovalue based values). The next line extracts the effect size.


```r
alpha <- 0.05
rocData <- dataset02 ##"VanDyke.lrc"
#fileName <- dataset03 ## "Franken1.lrc"
retDbm <- StSignificanceTesting(dataset = rocData, FOM = "Wilcoxon", method = "DBMH") 
varYTR <- retDbm$varComp$varTR;varYTC <- retDbm$varComp$varTC;varYEps <- retDbm$varComp$varErr
effectSize <- retDbm$ciDiffTrtRRRC$Estimate
```

The *observed* effect size is `effectSize` = -0.0438003, which, in this example, is used as the *anticipated* effect size, generally not a good idea. **See Chapter 11 for nuances regarding the choice of this all important value.** The following code snippet reveals the names and array indexing of the pseudovalue variance components. 


```r
retDbm$varComp
#>          varR       varC        varTR     varTC      varRC    varErr
#> 1 0.001534999 0.02724923 0.0002004025 0.0119753 0.01226473 0.0399716
```

For example, the treatment-reader pseudovalue variance component is the third element of `retDbm$varComp`. 

### Random reader random case (RRRC)
This illustrates random reader random case sample size estimation. Assumed are 10 readers and 163 cases in the pivotal study. The non-centrality parameter is defined by:

\[\Delta =\frac{JK\sigma _{Y;\tau }^{2}}{\left( \sigma _{Y;\varepsilon }^{2}+\sigma _{Y;\tau RC}^{2} \right)+K\sigma _{Y;\tau R}^{2}+J\max \left( \sigma _{Y;\tau C}^{2},0 \right)}\]

The sampling distribution of the F-statistic under the AH is:

\[{{F}_{\left. AH \right|R}}\equiv \frac{MST}{MSTC}\tilde{\ }{{F}_{I-1,\left( I-1 \right)\left( K-1 \right),\Delta }}\]
Also, 

\[\sigma _{Y;\tau }^{2}={{d}^{2}}/2\]

where `d` is the observed effect size, i.e., `effectSize`. The formulae for calculating the mean-squares are in [@RN1476], implemented in `UtilMeanSquares()`.


```r
#RRRC
J <- 10;K <- 163
ncp <- (0.5*J*K*(effectSize)^2)/(K*varYTR+max(J*varYTC,0)+varYEps)
MS <- UtilMeanSquares(rocData, FOM = "Wilcoxon", method = "DBMH")
ddf <- (MS$msTR+max(MS$msTC-MS$msTRC,0))^2/(MS$msTR^2)*(J-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power1 <- 1-pf(FCrit, 1, ddf, ncp = ncp)
```

The next line calculates the non centrality parameter, `ncp` = 8.1269825. Note that `effectSize` enters as the **square**. The `UtilMeanSquares()` function returns the mean-squares as a `list` (ignore the last two rows of output for now).


```r
str(MS)
#> List of 9
#>  $ msT       : num 0.547
#>  $ msR       : num 0.437
#>  $ msC       : num 0.397
#>  $ msTR      : num 0.0628
#>  $ msTC      : num 0.0521
#>  $ msRC      : num 0.0645
#>  $ msTRC     : num 0.04
#>  $ msCSingleT: num [1:2] 0.336 0.16
#>  $ msCSingleR: num [1:5] 0.1222 0.2127 0.1365 0.0173 0.1661
```

The next line calculates `ddf` = 12.822129. The remaining lines calculate the critical value of the F-distribution, `FCrit` = 4.680382 and statistical power = 0.7494133, which by design is close to 80%, i.e., the numbers of readers and cases were chosen to achieve this value. 

### Fixed reader random case (FRRC)
This code illustrates fixed reader random case sample size estimation. Assumed are 10 readers and 133 cases  in the pivotal study. The formulae are:

\[\Delta =\frac{JK\sigma _{Y;\tau }^{2}}{\sigma _{Y;\varepsilon }^{2}+\sigma _{Y;\tau RC}^{2}+J\sigma _{Y;\tau C}^{2}}\] 

The sampling distribution of the F-statistic under the AH is:

\[{{F}_{\left. AH \right|R}}\equiv \frac{MST}{MSTC}\tilde{\ }{{F}_{I-1,\left( I-1 \right)\left( K-1 \right),\Delta }}\] 


```r
#FRRC
ncp <- (0.5*J*K*(effectSize)^2)/(max(J*varYTC,0)+varYEps)
ddf <- (K-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power2 <- 1-pf(FCrit, 1, ddf, ncp = ncp)
```
This time non centrality parameter, `ncp` = 7.9873835, `ddf` = 132, `FCrit` = 3.912875 and statistical power = 0.8011167. Again, be design, this is close to 80%. Note that when readers are regarded as a fixed effect, fewer cases are needed to achieve the desired power. Freezing out a source of variability results in a more stable measurement and hence fewer cases are needed to achieve the desired power.

### Random reader fixed case (RRFC)
This code illustrates random reader random case sample size estimation. Assumed are 10 readers and 53 cases  in the pivotal study. The formulae are:

\[\Delta =\frac{JK\sigma _{Y;\tau }^{2}}{\sigma _{Y;\varepsilon }^{2}+\sigma _{Y;\tau RC}^{2}+K\sigma _{Y;\tau R}^{2}}\] 

The sampling distribution of the F-statistic under the AH is:

\[{{F}_{\left. AH \right|C}}\equiv \frac{MST}{MSTR}\tilde{\ }{{F}_{I-1,\left( I-1 \right)\left( J-1 \right),\Delta }}\]


```r
#RRFC
ncp <- (0.5*J*K*(effectSize)^2)/(K*varYTR+varYEps)
ddf <- (J-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power3 <- 1-pf(FCrit, 1, ddf, ncp = ncp)
```

This time non centrality parameter, `ncp` = 10.0487164, `ddf` = 9, `FCrit` = 5.117355 and statistical power = 0.8049666. Again, be design, this is close to 80%.  


## Summary
For 10 readers, the numbers of cases needed for 80% power is largest (163) for RRRC, intermediate (133) for FRRC and least for RRFC (53). For all three analyses, the expectation of 80% power is met. 


## References


