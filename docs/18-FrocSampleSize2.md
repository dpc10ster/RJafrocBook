# FROC sample size estimation using specified ROC effect {#SSFroc2}




## Introduction
This example uses the FED dataset as a pilot FROC study and function `SsFrocNhRsmModel()` to construct the NH model (encapsulating some of the code in the previous chapter).

## Constructing the NH model for the dataset
One starts by extracting the first two treatments from `dataset04`, which represent the NH dataset, see previous chapter. Next one constructs the NH model - note that the lesion distribution `lesionPmf` can be specified here independently of that in the pilot dataset. This allows some control over selection of the diseased cases in the pivotal study.


```r
frocNhData <- DfExtractDataset(dataset04, trts = c(1,2))
ret <- SsFrocNhRsmModel(frocNhData, lesionPmf = c(0.7, 0.2, 0.1))
muMed <- ret$muMed
lambdaMed <- ret$lambdaMed
nuMed <- ret$nuMed
lesDistr <- ret$lesDistr
lesWghtDistr <- ret$lesWghtDistr
scaleFactor <- ret$scaleFactor
```


The fitting model is defined by `muMed = r muMed`,  `lambdaMed = 5.6140941`  and  `nuMed = 0.3696988` and `lesionPmf`. The effect size scale factor is 2.1542102.



```r
aucRocNH <- PlotRsmOperatingCharacteristics(muMed, lambdaMed, nuMed, 
                                            lesDistr = lesDistr, 
                                            lesWghtDistr = lesWghtDistr, OpChType = "ROC")$aucROC
aucwAfrocNH <- PlotRsmOperatingCharacteristics(muMed, lambdaMed, nuMed, 
                                               lesDistr = lesDistr, 
                                               lesWghtDistr = lesWghtDistr, OpChType = "wAFROC")$aucwAFROC
```

The null hypothesis ROC AUC is 0.8790725 and the corresponding NH wAFROC AUC is 0.7231709. 

## Extracting the wAFROC variance components

The next code block applies `StSignificanceTesting()` to `frocNhData`, using `FOM = "wAFROC"` and extracts the variance components.


```r
varCompwAFROC  <- StSignificanceTesting(frocNhData, FOM = "wAFROC", method = "DBMH", option = "RRRC")$varComp
```


## wAFROC power for specified ROC effect size, number of readers J and number of cases K

The following example is for ROC effect size = 0.05, 5 readers (`J`) and 100 cases (`K`) in the **pivotal study**. 



```r
ROC_ES <- 0.05
effectSizewAFROC <- scaleFactor * ROC_ES
J <- 5;K <- 100

varYTR <- varCompwAFROC$varTR 
varYTC <- varCompwAFROC$varTC
varYEps <- varCompwAFROC$varErr
ret <- SsPowerGivenJKDbmVarComp (J = J, K = K, effectSize = effectSizewAFROC, 
                                 varYTR, varYTC, varYEps, option = "RRRC")
powerwAFROC <- ret$powerRRRC
  
cat("ROC-ES = ", ROC_ES, ", wAFROC-ES = ", ROC_ES * scaleFactor, ", Power-wAFROC = ", powerwAFROC, "\n")
#> ROC-ES =  0.05 , wAFROC-ES =  0.1077105 , Power-wAFROC =  0.976293
```

## wAFROC number of cases for 80% power for a given number of readers J



```r

varYTR <- varCompwAFROC$varTR 
varYTC <- varCompwAFROC$varTC
varYEps <- varCompwAFROC$varErr
ret2 <- SsSampleSizeKGivenJ(dataset = NULL, J = 6, effectSize = effectSizewAFROC, method = "DBMH", 
                      list(varYTR = varYTR, varYTC = varYTC, varYEps = varYEps))

cat("ROC-ES = ", ROC_ES, ", wAFROC-ES = ", ROC_ES * scaleFactor, 
    ", K80RRRC = ", ret2$KRRRC, ", Power-wAFROC = ", ret2$powerRRRC, "\n")
#> ROC-ES =  0.05 , wAFROC-ES =  0.1077105 , K80RRRC =  42 , Power-wAFROC =  0.804794
```


## wAFROC Power for a given number of readers J and cases K



```r

ret3 <- SsPowerGivenJK(dataset = NULL, J = 6, K = ret2$KRRRC, effectSize = effectSizewAFROC, method = "DBMH", 
                    list(varYTR = varYTR, varYTC = varYTC, varYEps = varYEps))

cat("ROC-ES = ", ROC_ES, ", wAFROC-ES = ", ROC_ES * scaleFactor, 
    ", powerRRRC = ", ret3$powerRRRC, "\n")
#> ROC-ES =  0.05 , wAFROC-ES =  0.1077105 , powerRRRC =  0.804794
```


The estimated power is close to 80% as the number of cases (`ret2$KRRRC = 42`) was chosen deliberately from the previous code block.


## References


