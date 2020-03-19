# FROC sample size estimation and comparison to ROC {#SSFroc1}




## Introduction
* FROC sample size estimation is not fundamentally different from the previously outlined procedure (see vignettes corresponding to Chapter 11) for the ROC paradigm. To recapitulate, based on analysis of a pilot ROC dataset and using a specified FOM, e.g., `FOM = Wilcoxon`, and either `method = "DBMH"` or `method = "ORH"` for significance testing, one estimates the intrinsic variability of the data expressed in terms of variance components or the covariance matrix. The second step is to postulate a clinically realistic effect-size, e.g., the anticipated AUC difference between the two treatments. Given these values, the sample size functions implemented in `RJafroc` (beginning with `Ss`) allow one to estimate the number of readers and cases necessary to detect (i.e., reject the null hypothesis) the specified effect size at specified Type II error rate, typically chosen to be 20% (corresponding to 80% statistical power) and specified Type I error rate, typically chosen to be 5%.

* In FROC analysis the only difference, **indeed the critical difference**, is the choice of FOM; e.g., `FOM = "wAFROC"` instead of the inferred ROC-AUC, `FOM = "HrAuc"`. The FROC dataset is analyzed using either the DBMH or the ORH method. This yields the necessary variance components or the covariance matrix corresponding to the wAFROC-AUC. The next step is to specify the effect-size **in wAFROC-AUC units**, and therein lies the rub. What value does one use? The ROC-AUC has a historically well-known interpretation: the classification ability at separating diseased patients from non-diseased patients, while the wAFROC-AUC does not. Needed is a way of relating the effect-size in ROC-AUC units to one in wAFROC-AUC units: as should be obvious this requires a physical model, e.g., the RSM, that predicts both ROC and wAFROC curves and the respective AUCs.

1.	One chooses an ROC-AUC effect-size that is realistic, one that clinicians understand and can therefore participate in, in the effect-size postulation process. 
2.	One converts the ROC effect-size to a wAFROC-AUC effect-size. The method for this is described in the next section.
3.	One uses the sample size tools in in `RJafroc` to determine sample size or power. 


* **It is important to recognize is that all quantities have to be in the same units**. When performing ROC analysis, everything (variance components and effect-size) has to be in units of the selected FOM, e.g., `FOM = "Wilcoxon"` which is identical to the empirical ROC-AUC. When doing wAFROC analysis, everything has to be in units of the wAFROC-AUC. The variance components and effect-size in wAFROC-AUC units will be different from their corresponding ROC counterparts. In particular, as shown next, an ROC-AUC effect-size of 0.05 generally corresponds to a larger effect-size in wAFROC-AUC units. The reason for this is that the range over which wAFROC-AUC can vary, namely 0 to 1, is twice the corresponding ROC-AUC range.  

* The next section explains the steps used to implement step #2 above. 

## Relating an ROC effect-size to a wAFROC effect-size

* If the original data is FROC, one needs to first convert it to ROC, using `DfFroc2Roc()`: **the RSM fits ROC data**.

* For each treatment and reader the inferred ROC data is fitted by `FitRsmRoc()`, yielding estimates of the RSM *physical* (or primed) parameters (not the *intrinsic* values).  

* The following example uses the *first two* treatments of the "FED" dataset, `dataset04`, which is a 5 treatment 4 radiologist FROC dataset acquired by Dr. Federica Zanca et. al. [@RN1882]. The dataset has 5 treatments and 4 readers and 200 cases and was acquired on a 5-point integer scale, i.e., it is already binned. If not one needs to bin the dataset using `DfBinDataset()`. I need to emphasize this point: **if the dataset represents continuous ratings, as with a CAD algorithm, one must bin the dataset to (ideally) about 5 bins**. The number of parameters that must be estimated increases with the number of bins (for each bin one needs to estimate a cutoff parameter).

* The reason for using RSM parameter values only for the first two treatments is that these were found [@RN1882] to be almost equivalent (more precisely, the NH could not be rejected for the first two treatments, so it makes sense to regard them as "almost" NH treatments.

* The following code block defines the pilot FROC data `frocData` (corresponding to `dataset04`, which is the "FED" dataset, but with only treatments 1 and 2 extracted, using `DfExtractDataset()`) and `rocData`, i.e., the highest-rating ROC dataset inferred from the FROC dataset using `DfFroc2Roc()`.


```r
frocData <- DfExtractDataset(dataset04, trts = c(1,2))
rocData <- DfFroc2Roc(frocData)
```

The next code block determines `lesDist`, the lesion distribution array, which has `Lmax` (maximum number of lesions per diseased case over the dataset) rows and two columns. The first column contains the integers 1, 2, ..., `Lmax` and the second column contains the fraction of diseased cases with the number of lesions per case specified in the first column. The second column will sum to unity. The RSM fitting algorithm needs to know how lesion-rich the dataset is, as the RSM predicted ROC-AUC depends on the lesion-richness of the dataset. For reasons that will become clear below, one also needs `lesWghts`, the distribution of the lesion weights.


```r
lesDistr <- UtilLesionDistr(frocData)
lesWghts <- UtilLesionWeightsDistr(frocData) # this is needed later
```

The meanings of `lesDistr` and `lesWghts` is clear from examining their values:


```r
print(lesDistr)
#>      [,1] [,2]
#> [1,]    1 0.69
#> [2,]    2 0.20
#> [3,]    3 0.11
print(lesWghts)
#>      [,1]      [,2]      [,3]      [,4]
#> [1,]    1 1.0000000      -Inf      -Inf
#> [2,]    2 0.5000000 0.5000000      -Inf
#> [3,]    3 0.3333333 0.3333333 0.3333333
```

For this dataset `Lmax` is 3, and 69 percent of the diseased cases have one lesion, 20 percent have two lesions and 11 percent have three lesions. Since the lesions are equally weighted, on cases with one lesion the weight of the lesion is unity, on cases with two lesions the weights of each lesion is 0.5 and on cases with three lesions the weight of each lesion is 1/3.

The next code block determines the number of treatments and readers (`I` and `J`) from the dimensions of the `frocData$NL` array. It creates an array `RsmParms` to hold the RSM fitted parameter values. For each treatment and reader it applies the fitting algorithm `FitRsmRoc()`. The first three returned values are `mu`, `lambdaP` and `nuP`, corresponding to RSM parameters ${\mu}$, ${\lambda^{'}}$ and ${\nu^{'}}$ .


```r
I <- dim(frocData$NL)[1]
J <- dim(frocData$NL)[2]
RsmParms <- array(dim = c(I,J,3))
for (i in 1:I) {
  for (j in 1:J)  {
    x1 <- FitRsmRoc(rocData, trt = i, rdr = j, lesDistr)
    RsmParms[i,j,1] <- x1[[1]] # mu
    RsmParms[i,j,2] <- x1[[2]] # lambdaP
    RsmParms[i,j,3] <- x1[[3]] # nuP
  }
}
```


I recommend taking the median of each of the parameters, over all treatment-reader indices, as representing the average NH dataset. The median is less sensitive to outliers than the mean.  



```r
muMed <- median(RsmParms[,,1]) 
lambdaPMed <- median(RsmParms[,,2])
nuPMed <- median(RsmParms[,,3])
```


The defining values of the fitting model are `muMed` = 3.3105557,  `lambdaPMed` = 1.714368 and `nuPMed` = 0.7036567. Note that these obey the constraints `lambdaPMed > 0` and `0 < nuP < 1`. One then converts the physical parameters to the intrinsic values:



```r
temp <- UtilPhysical2IntrinsicRSM(muMed, lambdaPMed, nuPMed)
lambdaMed <- temp$lambda
nuMed <- temp$nu
```

In terms of intrinsic parameters, the defining values of the fitting model are `muMed` = 3.3105557,  `lambdaMed` = 5.6755108 and `nuMed` = 0.3673814. We are now ready to calcuate the expected NH FOMs using the ROC -AUC and the wAFROC FOM.  


```r
aucRocNH <- PlotRsmOperatingCharacteristics(muMed, lambdaMed, nuMed, 
                                            lesDistr = lesDistr, 
                                            lesWghtDistr = lesWghts, OpChType = "ROC")$aucROC
aucwAfrocNH <- PlotRsmOperatingCharacteristics(muMed, lambdaMed, nuMed, 
                                              lesDistr = lesDistr, 
                                              lesWghtDistr = lesWghts, OpChType = "wAFROC")$aucwAFROC
```


* The plotting function `PlotRsmOperatingCharacteristics()` returns a number of other objects, most importantly the plot, but here we use only the AUC, which is obtained by numerical integration of the predicted operating characteristics. However, it calls for the **intrinsic** RSM parameters, which is why we had to convert the **physical** to the **intrinsic** values. 

* One has `aucRocNH = 0.8791301` and `aucwAfrocNH = 0.7198311`. Note that the wAFROC-FOM is smaller than the ROC-FOM as it includes the localization constraint. 
* To induce the alternative hypothesis condition, one increments $\mu_{NH}$ by $\Delta_{\mu}$. The resulting ROC-AUC and wAFROC-AUC are calculated, again by numerical integration of the RSM predicted ROC and wAFROC curves, leading to the corresponding effect-sizes (note that in each equation below one takes the difference between the AH value minus the NH value):

* The next step is to calculate the effect size (new value minus the NH value) using ROC and wAFROC FOMs for a series of specifed `deltaMu` values. This generates values that can be used to interpolate a wAFROC effect size for a specified ROC effect size. 



```r
deltaMu <- seq(0.01, 0.2, 0.01) # values of deltaMu to scan below
esRoc <- array(dim = length(deltaMu));eswAfroc <- array(dim = length(deltaMu))
for (i in 1:length(deltaMu)) {
  esRoc[i] <- PlotRsmOperatingCharacteristics(
    muMed + deltaMu[i], lambdaMed, nuMed, lesDistr = lesDistr, 
    lesWghtDistr = lesWghts, OpChType = "ROC")$aucROC - aucRocNH
  eswAfroc[i] <- PlotRsmOperatingCharacteristics(
    muMed+ deltaMu[i], lambdaMed, nuMed, lesDistr = lesDistr, 
    lesWghtDistr = lesWghts, OpChType = "wAFROC")$aucwAFROC - aucwAfrocNH
  cat("ES_ROC = ", esRoc[i], ", ES_wAFROC = ", eswAfroc[i],"\n")
}
#> ES_ROC =  0.0006197813 , ES_wAFROC =  0.001329066 
#> ES_ROC =  0.001234752 , ES_wAFROC =  0.002650005 
#> ES_ROC =  0.00184496 , ES_wAFROC =  0.003962878 
#> ES_ROC =  0.002450451 , ES_wAFROC =  0.005267748 
#> ES_ROC =  0.003051273 , ES_wAFROC =  0.006564677 
#> ES_ROC =  0.003647472 , ES_wAFROC =  0.007853725 
#> ES_ROC =  0.004239094 , ES_wAFROC =  0.009134954 
#> ES_ROC =  0.004826184 , ES_wAFROC =  0.01040842 
#> ES_ROC =  0.005408788 , ES_wAFROC =  0.0116742 
#> ES_ROC =  0.00598695 , ES_wAFROC =  0.01293233 
#> ES_ROC =  0.006560717 , ES_wAFROC =  0.01418289 
#> ES_ROC =  0.007130131 , ES_wAFROC =  0.01542592 
#> ES_ROC =  0.007695238 , ES_wAFROC =  0.0166615 
#> ES_ROC =  0.00825608 , ES_wAFROC =  0.01788967 
#> ES_ROC =  0.008812701 , ES_wAFROC =  0.0191105 
#> ES_ROC =  0.009365145 , ES_wAFROC =  0.02032404 
#> ES_ROC =  0.009913453 , ES_wAFROC =  0.02153036 
#> ES_ROC =  0.01045767 , ES_wAFROC =  0.0227295 
#> ES_ROC =  0.01099783 , ES_wAFROC =  0.02392152 
#> ES_ROC =  0.01153399 , ES_wAFROC =  0.02510649
```

Here is a plot of wAFROC effect size (y-axis) vs. ROC effect size.



```r
df <- data.frame(es_ROC = esRoc, es_wAFROC = eswAfroc)
p <- ggplot(data = df, aes(x = es_ROC, y = es_wAFROC)) +
  geom_smooth(method = "lm", se = FALSE, color = "black", formula = y ~ x) +
  geom_point(size = 4) +
  scale_color_manual(values = "black") + 
  theme(axis.title.y = element_text(size = 10,face="bold"),
        axis.title.x = element_text(size = 10,face="bold")) +
  scale_x_continuous(expand = c(0, 0)) + 
  scale_y_continuous(expand = c(0, 0)) 
print(p)
```

<img src="17-FrocSampleSize1_files/figure-epub3/unnamed-chunk-9-1.png" style="display: block; margin: auto;" />

The plot is very close to linear. This makes it easy to design an interpolation function. In the following code block the first line fits `eswAfroc` vs. `esRoc` using the linear model `lm()` function constrained to pass through the origin (the minus one): `scaleFactor <- lm(eswAfroc ~ -1 + esRoc)`. One expects this constraint since for `deltaMu = 0` the effect size must be zero no matter how it is measured. 


```r
scaleFactor<-lm(eswAfroc~-1+esRoc) # fit values to straight line thru origin
effectSizeROC <- seq(0.01, 0.1, 0.01)
effectSizewAFROC <- effectSizeROC*scaleFactor$coefficients[1] # r2 = summary(scaleFactor)$r.squared
```


The scaleFactor of the straight line fit is `scaleFactor`, where scaleFactor = 2.1688609 and `R2` = 0.9999904. Therefore, the conversion from ROC to wAFROC effect size is: `effectSizewAFROC = scaleFactor * effectSizeROC`. **The wAFROC effect size is twice the ROC effect size.** All that remains is to calculate the variance componenents using the two FOMs:

## Computing the respective variance components

The code block applies `StSignificanceTesting()` to `rocData` and `frocData`, using the appropriate FOM, and extracts the variance components.


```r
temp1 <- StSignificanceTesting(rocData, FOM = "Wilcoxon", method = "DBMH", option = "RRRC")
temp2 <- StSignificanceTesting(frocData, FOM = "wAFROC", method = "DBMH", option = "RRRC")
varCompROC <- temp1$varComp
varCompwAFROC <- temp2$varComp
```

The observed wAFROC effect-size is -0.0068562. This is a very small effect size; the corresponding ROC effect-size is -0.0051; the sign does not affect the calculations, which is too small to reach 80% power. It is not surprising that the study [@RN1882] did not find a significant difference between these two treatments

The respective variance components are:



```r
print(varCompROC)
#>          varR       varC        varTR       varTC       varRC     varErr
#> 1 0.000827738 0.03812335 0.0001526507 0.009644327 0.003544196 0.09484637
print(varCompwAFROC)
#>          varR       varC         varTR      varTC      varRC    varErr
#> 1 0.001854229 0.06117805 -0.0004439279 0.01016519 0.01355883 0.0967256
```


Only terms involving treatment are relevant to sample size. The wAFROC `varTC` and `varError` values are slightly larger than the ROC ones - as expected because, again, the range of the wAFROC FOM is twice that of the ROC FOM. 

## Comparing ROC power to wAFROC power for equivalent effect-sizes

We are now ready to compare ROC and wAFROC powers for equivalent effect sizes. The following example is for 5 readers (`JTest`) and 100 cases (`KTest`) in the **pivotal study**. 


```r
powerROC <- array(dim = length(effectSizeROC));powerwAFROC <- array(dim = length(effectSizeROC))

JTest <- 5;KTest <- 100
for (i in 1:length(effectSizeROC)) {
  varYTR <- varCompROC$varTR # these are pseudovalue based variance components assuming FOM = "Wilcoxon"
  varYTC <- varCompROC$varTC
  varYEps <- varCompROC$varErr
  ret <- SsPowerGivenJKDbmVarComp (J = JTest, K = KTest, effectSize = effectSizeROC[i], varYTR, varYTC, varYEps, option = "RRRC")
  powerROC[i] <- ret$powerRRRC
  
  varYTR <- varCompwAFROC$varTR # these are pseudovalue based variance components assuming FOM = "wAFROC"
  varYTC <- varCompwAFROC$varTC
  varYEps <- varCompwAFROC$varErr
  ret <- SsPowerGivenJKDbmVarComp (J = JTest, K = KTest, effectSize = effectSizewAFROC[i], varYTR, varYTC, varYEps, option = "RRRC")
  powerwAFROC[i] <- ret$powerRRRC
  
  cat("ROC-ES = ", effectSizeROC[i], ", wAFROC-ES = ", effectSizewAFROC[i], 
      ", Power-ROC = ", powerROC[i], ", Power-wAFROC = ", powerwAFROC[i], "\n")
}
#> ROC-ES =  0.01 , wAFROC-ES =  0.02168861 , Power-ROC =  0.06443046 , Power-wAFROC =  0.1266316 
#> ROC-ES =  0.02 , wAFROC-ES =  0.04337722 , Power-ROC =  0.108789 , Power-wAFROC =  0.3605744 
#> ROC-ES =  0.03 , wAFROC-ES =  0.06506583 , Power-ROC =  0.1847115 , Power-wAFROC =  0.6686875 
#> ROC-ES =  0.04 , wAFROC-ES =  0.08675444 , Power-ROC =  0.2907927 , Power-wAFROC =  0.8897125 
#> ROC-ES =  0.05 , wAFROC-ES =  0.108443 , Power-ROC =  0.4195443 , Power-wAFROC =  0.9777308 
#> ROC-ES =  0.06 , wAFROC-ES =  0.1301317 , Power-ROC =  0.5573812 , Power-wAFROC =  0.9973522 
#> ROC-ES =  0.07 , wAFROC-ES =  0.1518203 , Power-ROC =  0.6881601 , Power-wAFROC =  0.9998172 
#> ROC-ES =  0.08 , wAFROC-ES =  0.1735089 , Power-ROC =  0.7983611 , Power-wAFROC =  0.9999927 
#> ROC-ES =  0.09 , wAFROC-ES =  0.1951975 , Power-ROC =  0.8809508 , Power-wAFROC =  0.9999998 
#> ROC-ES =  0.1 , wAFROC-ES =  0.2168861 , Power-ROC =  0.936068 , Power-wAFROC =  1
```


Since the wAFROC effect size is about a factor of two larger than the ROC effect size, wAFROC power is larger than that for ROC. The effect is magnified as the effect size enters as the square in the formula for the power (this overwhelms the slight increase in variability of wAFROC-FOM relative to ROC-FOM noted previously). The following is a plot of the respective powers.



```r
df <- data.frame(power_ROC = powerROC, power_wAFROC = powerwAFROC)
p <- ggplot(mapping = aes(x = power_ROC, y = power_wAFROC)) +
  geom_line(data = df, size = 2)+
  scale_color_manual(values = "black") + 
  theme(axis.title.y = element_text(size = 10,face="bold"),
        axis.title.x = element_text(size = 10,face="bold"))  +
  scale_x_continuous(expand = c(0, 0)) + 
  scale_y_continuous(expand = c(0, 0))
print(p)
```

<img src="17-FrocSampleSize1_files/figure-epub3/unnamed-chunk-14-1.png" style="display: block; margin: auto;" />



## References


