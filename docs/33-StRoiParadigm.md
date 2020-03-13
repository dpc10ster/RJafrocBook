# Analyzing data acquired according to the ROI paradigm {#ROIDataAnalysis}





## Introduction; this vignette is under construction!

## Note to self (10/29/19) !!!DPC!!!
The FOM and DeLong method implementations need checking with a toy dataset.

## Introduction
* For an ROI dataset `StSignificanceTesting()` automatically defaults to `method = "ORH"`, `covEstMethod = "DeLong"` and `FOM = "ROI"`.  

* The covariance estimation method is based on the original DeLong method [@RN112], which is valid only for the trapezoidal AUC, i.e. ROC data, as extended by [@RN1233] to ROI data, see formula below.  

* The essential differences from conventional ROC analyses are in the definition of the ROI figure of merit, see below, and the procedure developed by [@RN1233] for estimating the covariance matrix. Once the covariances are known, `method = "ORH"` can be applied to perform significance testing, as described in [@RN1450] and [@RN2680, Chapter 10].

## The ROI figure of merit  
Let ${X_{kr}}$ denote the rating for the r^th^ **lesion-containing** ROI in the k^th^ case and let $n_{k}^L$ be the total number of lesion-containing ROIs in the k^th^ case. Similarly, let ${Y_{kr}}$ denote the rating for the r^th^ **lesion-free** ROI in the k^th^ case and $n_{k}^N$ denote the total number of lesion-free ROIs in the k^th^ case. Let ${N_L}$ denote the total number of lesion-containing ROIs in the image set and ${N_N}$ denote the total number of lesion-free ROIs. These are given by ${N_L}=\sum\nolimits_{k}{n_{k}^L}$ and ${N_N}=\sum\nolimits_{k}{n_{k}^N}$. The ROI figure of merit $\theta$\ is defined by: \[\theta =\frac{1}{{N_L}{N_N}}\sum\nolimits_{k}{\sum\nolimits_{{{k}'}}{\sum\limits_{r=1}^{n_{k}^L}{\sum\limits_{{r}'=1}^{n_{k'}^N}{\psi ({X_{kr}},{Y_{{k}'{r}'}})}}}}\]    

The kernel function $\Psi(X,Y)$ is defined by:

\[\psi (X,Y)=\left\{ \begin{aligned}
  & 1.0\ \ \ \text{if}\ Y<X \\ 
 & 0.5\ \ \ \text{if}\ Y=X \\ 
 & 0.0\ \ \ \text{if}\ Y>X \\ 
\end{aligned} \right.\]


The ROIs are *effectively regarded as mini-cases* and one calculates the FOM as the Wilcoxon statistic considering the mini-cases as actual cases. The correlations between the ratings of ROIs on the same case are accounted for in the analysis.


## Calculation of the ROI figure of merit.


```r
UtilFigureOfMerit(datasetROI, FOM = "ROI")
#>           Rdr1      Rdr2      Rdr3      Rdr4      Rdr5
#> Trt1 0.9057239 0.8842834 0.8579279 0.9350207 0.8352103
#> Trt2 0.9297186 0.9546035 0.8937652 0.9531716 0.8770076
fom <- UtilFigureOfMerit(datasetROI, FOM = "ROI")
```

* If the correct `FOM` is not supplied, it defaults to `FOM = ROI`.   
* This is a 2-treatment 5-reader dataset.  
* For treatment 1, reader 1 the figure of merit is 0.9057239.  
* For treatment 2, reader 5 the figure of merit is 0.8770076.  
* Etc.  

## Significance testing

When `dataset$dataType == "ROI"` the FOM defaults to "ROI" (meaning the above formula) and the covariance estimation method defaults to `covEstMethod = "DeLong"`.


```r
ret <- StSignificanceTesting(datasetROI, FOM = "Wilcoxon")
#> ROI dataset: forcing method = `ORH`, covEstMethod = `DeLong` and FOM = `ROI`.
str(ret)
#> List of 14
#>  $ fomArray            : num [1:2, 1:5] 0.906 0.93 0.884 0.955 0.858 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:2] "Trt1" "Trt2"
#>   .. ..$ : chr [1:5] "Rdr1" "Rdr2" "Rdr3" "Rdr4" ...
#>  $ meanSquares         :'data.frame':	1 obs. of  3 variables:
#>   ..$ msT : num 0.00361
#>   ..$ msR : num 0.00256
#>   ..$ msTR: num 0.000207
#>  $ varComp             :'data.frame':	1 obs. of  6 variables:
#>   ..$ varR : num 0.00108
#>   ..$ varTR: num 0.000153
#>   ..$ cov1 : num 0.000247
#>   ..$ cov2 : num 0.000187
#>   ..$ cov3 : num 0.000154
#>   ..$ var  : num 0.000333
#>  $ FTestStatsRRRC      :'data.frame':	1 obs. of  4 variables:
#>   ..$ fRRRC  : num 9.76
#>   ..$ ndfRRRC: num 1
#>   ..$ ddfRRRC: num 12.8
#>   ..$ pRRRC  : num 0.00817
#>  $ ciDiffTrtRRRC       :'data.frame':	1 obs. of  8 variables:
#>   ..$ Treatment: chr "Trt1-Trt2"
#>   ..$ Estimate : num -0.038
#>   ..$ StdErr   : num 0.0122
#>   ..$ DF       : num 12.8
#>   ..$ t        : num -3.12
#>   ..$ PrGTt    : num 0.00817
#>   ..$ CILower  : num -0.0643
#>   ..$ CIUpper  : num -0.0117
#>  $ ciAvgRdrEachTrtRRRC :'data.frame':	2 obs. of  6 variables:
#>   ..$ Treatment: Factor w/ 2 levels "Trt1","Trt2": 1 2
#>   ..$ Area     : num [1:2] 0.884 0.922
#>   ..$ StdErr   : num [1:2] 0.0232 0.0197
#>   ..$ DF       : num [1:2] 12.2 10.1
#>   ..$ CILower  : num [1:2] 0.833 0.878
#>   ..$ CIUpper  : num [1:2] 0.934 0.966
#>  $ FTestStatsFRRC      :'data.frame':	1 obs. of  4 variables:
#>   ..$ fFRRC  : num 16.6
#>   ..$ ndfFRRC: num 1
#>   ..$ ddfFRRC: num Inf
#>   ..$ pFRRC  : num 4.58e-05
#>  $ ciDiffTrtFRRC       :'data.frame':	1 obs. of  8 variables:
#>   ..$ Treatment: chr "Trt1-Trt2"
#>   ..$ Estimate : num -0.038
#>   ..$ StdErr   : num 0.00933
#>   ..$ DF       : num Inf
#>   ..$ t        : num -4.08
#>   ..$ PrGTt    : num 4.58e-05
#>   ..$ CILower  : num -0.0563
#>   ..$ CIUpper  : num -0.0197
#>  $ ciAvgRdrEachTrtFRRC :'data.frame':	2 obs. of  6 variables:
#>   ..$ Treatment: Factor w/ 2 levels "Trt1","Trt2": 1 2
#>   ..$ Area     : num [1:2] 0.884 0.922
#>   ..$ StdErr   : num [1:2] 0.0163 0.0129
#>   ..$ DF       : num [1:2] Inf Inf
#>   ..$ CILower  : num [1:2] 0.852 0.896
#>   ..$ CIUpper  : num [1:2] 0.916 0.947
#>  $ ciDiffTrtEachRdrFRRC:'data.frame':	5 obs. of  9 variables:
#>   ..$ Reader   : Factor w/ 5 levels "Rdr1","Rdr2",..: 1 2 3 4 5
#>   ..$ Treatment: Factor w/ 1 level "Trt1-Trt2": 1 1 1 1 1
#>   ..$ Estimate : num [1:5] -0.024 -0.0703 -0.0358 -0.0182 -0.0418
#>   ..$ StdErr   : num [1:5] 0.01025 0.01448 0.01648 0.00928 0.01398
#>   ..$ DF       : num [1:5] Inf Inf Inf Inf Inf
#>   ..$ t        : num [1:5] -2.34 -4.86 -2.17 -1.96 -2.99
#>   ..$ PrGTt    : num [1:5] 1.93e-02 1.20e-06 2.97e-02 5.05e-02 2.79e-03
#>   ..$ CILower  : num [1:5] -0.0441 -0.0987 -0.0681 -0.0363 -0.0692
#>   ..$ CIUpper  : num [1:5] -3.90e-03 -4.19e-02 -3.53e-03 3.88e-05 -1.44e-02
#>  $ varCovEachRdr       :'data.frame':	5 obs. of  3 variables:
#>   ..$ Reader: Factor w/ 5 levels "Rdr1","Rdr2",..: 1 2 3 4 5
#>   ..$ Var   : num [1:5] 0.000269 0.000227 0.000481 0.000168 0.000522
#>   ..$ Cov1  : num [1:5] 0.000216 0.000122 0.000345 0.000125 0.000424
#>  $ FTestStatsRRFC      :'data.frame':	1 obs. of  4 variables:
#>   ..$ fRRFC  : num 17.5
#>   ..$ ndfRRFC: num 1
#>   ..$ ddfRRFC: num 4
#>   ..$ pRRFC  : num 0.0139
#>  $ ciDiffTrtRRFC       :'data.frame':	1 obs. of  8 variables:
#>   ..$ Treatment: chr "Trt1-Trt2"
#>   ..$ Estimate : num -0.038
#>   ..$ StdErr   : num 0.00909
#>   ..$ DF       : num 4
#>   ..$ t        : num -4.18
#>   ..$ PrGTt    : num 0.0139
#>   ..$ CILower  : num -0.0633
#>   ..$ CIUpper  : num -0.0128
#>  $ ciAvgRdrEachTrtRRFC :'data.frame':	2 obs. of  6 variables:
#>   ..$ Treatment: Factor w/ 2 levels "Trt1","Trt2": 1 2
#>   ..$ Area     : num [1:2] 0.884 0.922
#>   ..$ StdErr   : num [1:2] 0.0175 0.0157
#>   ..$ DF       : num [1:2] 4 4
#>   ..$ CILower  : num [1:2] 0.835 0.878
#>   ..$ CIUpper  : num [1:2] 0.932 0.965
```

* While `ret` is a list with many (22) members, their meanings should be clear from the notation. As an example:  

+    The variance components are given by:


```r
ret$varComp
#>          varR        varTR         cov1         cov2         cov3          var
#> 1 0.001082359 0.0001526084 0.0002465125 0.0001870571 0.0001543764 0.0003333119
```

### RRRC analysis  


```r
ret$FTestStatsRRRC$fRRRC
#> [1] 9.763602
ret$FTestStatsRRRC$ndfRRRC
#> [1] 1
ret$FTestStatsRRRC$ddfRRRC
#> [1] 12.82259
ret$FTestStatsRRRC$pRRRC
#> [1] 0.008173042
```

* The F-statistic is , with `ndf = 1` and `ddf` = , which yields a p-value of .   

* The confidence interval for the reader averaged difference between the two treatments is given by:
    

```r
ret$ciDiffTrtRRRC
#>   Treatment    Estimate     StdErr       DF         t       PrGTt     CILower
#> 1 Trt1-Trt2 -0.03802005 0.01216768 12.82259 -3.124676 0.008173042 -0.06434373
#>       CIUpper
#> 1 -0.01169636
```

* The FOM difference (treatment 1 minus 2) is -0.03802, which is significant, p-value = 0.008173, F-statistic = 9.7636016, ddf = 12.8225898. The confidence interval is (-0.0643437, -0.0116964).

### FRRC analysis  


```r
ret$FTestStatsFRRC$fFRRC
#> [1] 16.6135
ret$FTestStatsFRRC$ndfFRRC
#> [1] 1
ret$FTestStatsFRRC$ddfFRRC
#> [1] Inf
ret$FTestStatsFRRC$pFRRC
#> [1] 4.582365e-05
```

* The F-statistic is 16.6135014, with `ndf = 1` and `ddf` = `Inf`, which yields a p-value of 4.5823651\times 10^{-5}. 

*  The confidence interval for the reader averaged difference between the two treatments is given by:
    

```r
ret$ciDiffTrtFRRC
#>   Treatment    Estimate      StdErr  DF         t        PrGTt     CILower
#> 1 Trt1-Trt2 -0.03802005 0.009327861 Inf -4.075966 4.582365e-05 -0.05630232
#>       CIUpper
#> 1 -0.01973778
```

### RRFC analysis  


```r
ret$FTestStatsRRFC$fRRFC
#> [1] 17.48107
ret$FTestStatsRRFC$ndfRRFC
#> [1] 1
ret$FTestStatsRRFC$ddfRRFC
#> [1] 4
ret$FTestStatsRRFC$pRRFC
#> [1] 0.01390667
```

* The F-statistic is 17.4810666, with `ndf = 1` and `ddf` = 4, which yields a p-value of 0.0139067. 

* The confidence interval for the reader averaged difference between the two treatments is given by:
    

```r
ret$ciDiffTrtRRFC
#>   Treatment    Estimate     StdErr DF         t      PrGTt     CILower
#> 1 Trt1-Trt2 -0.03802005 0.00909345  4 -4.181037 0.01390667 -0.06326751
#>       CIUpper
#> 1 -0.01277258
```

## Summary  
TBA

## References  
