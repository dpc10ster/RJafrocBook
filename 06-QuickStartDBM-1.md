# QUICK START DBM1 {#QuickStartDBM1}



## Introduction
* This chapter is intended for those seeking a quick transition from Windows **JAFROC** to `RJafroc`.
* Described first is the structure of an `RJafroc` dataset followed by how to read
a *JAFROC*  format Excel file to create an `RJafroc` dataset.

## An ROC dataset
Dataset `dataset03` corresponding to the Franken ROC data [@RN1995] is predefined. The following code shows the structure of this dataset.


```r
str(dataset03)
#> List of 12
#>  $ NL           : num [1:2, 1:4, 1:100, 1] 3 3 4 3 3 3 4 1 1 3 ...
#>  $ LL           : num [1:2, 1:4, 1:67, 1] 5 5 4 4 5 4 4 5 2 2 ...
#>  $ lesionVector : num [1:67] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ lesionID     : num [1:67, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ lesionWeight : num [1:67, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ dataType     : chr "ROC"
#>  $ modalityID   : Named chr [1:2] "TREAT1" "TREAT2"
#>   ..- attr(*, "names")= chr [1:2] "TREAT1" "TREAT2"
#>  $ readerID     : Named chr [1:4] "READER_1" "READER_2" "READER_3" "READER_4"
#>   ..- attr(*, "names")= chr [1:4] "READER_1" "READER_2" "READER_3" "READER_4"
#>  $ design       : chr "CROSSED"
#>  $ normalCases  : int [1:33] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ abnormalCases: int [1:67] 34 35 36 37 38 39 40 41 42 43 ...
#>  $ truthTableStr: num [1:2, 1:4, 1:100, 1:2] 1 1 1 1 1 1 1 1 1 1 ...
```

* It is a list with 8 members. The false positive ratings are contained in `{NL}`, an array
with dimensions `[1:2,1:4,1:100,1]`. The first index corresponds to treatments, and since the 
dataset has 2 treatments, the corresponding dimension is 2. The second index corresponds to 
readers, and since the dataset has 4 readers, the corresponding dimension is 4. The third index 
corresponds to the total number of cases. Since the dataset has 100 cases, the corresponding 
dimension is 100. But, as you can see from the code below, the entries in this array for cases 34
through 100 are `-Inf`: i.e., `all(dataset03$NL[1,1,34:100,1] == -Inf)` = TRUE.
* This is because in the ROC paradigm false positive are not possible on diseased cases. So the actual FP ratings are contained in the first 33 elements of the array. How did I know that there are 33 non-diseased cases? This can be understood in several ways.

* `LL` is an array with dimensions `[1:2,1:4,1:67,1]`. This implies 67 diseased cases, and by subtraction from 100, there must be 33 non-diseased cases.
* The list member `lesionVector` is a vector with length 67, implying 33 non-diseased cases. 
* The list members `lesionID` and `lesionWeight` are arrays with dimensions `[1:67,1]` containing ones. Again, these imply 67 diseased cases.
* The fields `lesionVector`, `lesionID` and `lesionWeight`, while not needed for ROC data, are needed for the FROC paradigm.

The `dataType` list member is the character string `"ROC"`, characterizing the ROC dataset. 
    

```r
dataset03$dataType
#> [1] "ROC"
```

The `modalityID` list member is a character string with two entries, `"TREAT1"` and `"TREAT2"`, corresponding to the two modalities. 
    

```r
dataset03$modalityID
#>   TREAT1   TREAT2 
#> "TREAT1" "TREAT2"
```

The `readerID` list member is a character string with four entries, `"READER_1"`,  `"READER_2"`, `"READER_3"` and `"READER_4"` corresponding to the four readers. 
    

```r
dataset03$readerID
#>   READER_1   READER_2   READER_3   READER_4 
#> "READER_1" "READER_2" "READER_3" "READER_4"
```

Here are the actual ratings for cases 1:34.


```r
dataset03$NL[1,1,1:33,1]
#>  [1] 3 1 2 2 2 2 2 4 1 1 4 2 1 2 4 2 1 2 1 2 4 2 3 2 2 2 4 3 2 2 2 5 3
```

* This says that for treatment 1 and reader 1, (non-diseased) case 1 was rated 3, case 2 was rated 1, cases 3-7 were rated 2, case 8 was rated 4, etc. 

* As another example, for treatment 2 and reader 3, the FP ratings are: 


```r
dataset03$NL[2,3,1:33,1]
#>  [1] 3 1 2 2 2 2 4 4 2 3 2 2 1 3 2 4 2 3 2 2 2 2 2 4 2 2 1 2 2 2 2 4 2
```

## Creating a dataset from a JAFROC format file

There is a file `RocData.xlsx` that is part of the package installation. Since it is a system
file one must get its name as follows.


```r
fileName <- "RocData.xlsx"
sysFileName <- system.file(paste0("extdata/",fileName), package = "RJafroc", mustWork = TRUE)
```

Next, one uses `DfReadDataFile()` as follows, assuming it is a JAFROC format file.


```r
ds <- DfReadDataFile(sysFileName, newExcelFileFormat = FALSE)
str(ds)
#> List of 12
#>  $ NL           : num [1:2, 1:5, 1:114, 1] 1 3 2 3 2 2 1 2 3 2 ...
#>  $ LL           : num [1:2, 1:5, 1:45, 1] 5 5 5 5 5 5 5 5 5 5 ...
#>  $ lesionVector : int [1:45] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ lesionID     : num [1:45, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ lesionWeight : num [1:45, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ dataType     : chr "ROC"
#>  $ modalityID   : Named chr [1:2] "0" "1"
#>   ..- attr(*, "names")= chr [1:2] "0" "1"
#>  $ readerID     : Named chr [1:5] "0" "1" "2" "3" ...
#>   ..- attr(*, "names")= chr [1:5] "0" "1" "2" "3" ...
#>  $ design       : chr "CROSSED"
#>  $ normalCases  : int [1:69] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ abnormalCases: int [1:45] 70 71 72 73 74 75 76 77 78 79 ...
#>  $ truthTableStr: num [1:2, 1:5, 1:114, 1:2] 1 1 1 1 1 1 1 1 1 1 ...
```
 
Analysis is illustrated for `dataset03`, but one could have used the newly created dataset `ds`.

## Analyzing the ROC dataset

This illustrates the `StSignificanceTesting()` function. The significance testing method is specified as `"DBMH"` and the figure of merit `FOM` is specified as "Wilcoxon".


```r
ret <- StSignificanceTesting(dataset03, FOM = "Wilcoxon", method = "DBMH")
print(ret)
#> $fomArray
#>           RdrREADER_1 RdrREADER_2 RdrREADER_3 RdrREADER_4
#> TrtTREAT1   0.8534600   0.8649932   0.8573044   0.8152420
#> TrtTREAT2   0.8496156   0.8435097   0.8401176   0.8143374
#> 
#> $anovaY
#>       Source           SS  DF          MS
#> 1     Row1_T   0.02356541   1 0.023565410
#> 2     Row2_R   0.20521800   3 0.068406000
#> 3     Row3_C  52.52839868  99 0.530589886
#> 4    Row4_TR   0.01506079   3 0.005020264
#> 5    Row5_TC   6.41004881  99 0.064747968
#> 6    Row6_RC  39.24295381 297 0.132131158
#> 7   Row7_TRC  22.66007764 297 0.076296558
#> 8 Row8_Total 121.08532315 799          NA
#> 
#> $anovaYi
#>   Source  DF  TrtTREAT1  TrtTREAT2
#> 1      R   3 0.04926635 0.02415991
#> 2      C  99 0.29396753 0.30137032
#> 3     RC 297 0.10504787 0.10337984
#> 
#> $varComp
#>           varR       varC         varTR        varTC     varRC     varErr
#> 1 3.775568e-05 0.05125091 -0.0007127629 -0.002887147 0.0279173 0.07629656
#> 
#> $FTestStatsRRRC
#>      fRRRC ndfRRRC ddfRRRC     pRRRC
#> 1 4.694058       1       3 0.1188379
#> 
#> $ciDiffTrtRRRC
#>               TrtDiff   Estimate      StdErr DF        t     PrGTt      CILower
#> 1 TrtTREAT1-TrtTREAT2 0.01085482 0.005010122  3 2.166577 0.1188379 -0.005089627
#>      CIUpper
#> 1 0.02679926
#> 
#> $ciAvgRdrEachTrtRRRC
#>   Treatment      Area     StdErr        DF   CILower   CIUpper
#> 1 TrtTREAT1 0.8477499 0.02440215  70.12179 0.7990828 0.8964170
#> 2 TrtTREAT2 0.8368951 0.02356642 253.64403 0.7904843 0.8833058
#> 
#> $FTestStatsFRRC
#>      fFRRC ndfFRRC ddfFRRC    pFRRC
#> 1 0.363956       1      99 0.547697
#> 
#> $ciDiffTrtFRRC
#>             Treatment   Estimate     StdErr DF         t    PrGTt     CILower
#> 1 TrtTREAT1-TrtTREAT2 0.01085482 0.01799277 99 0.6032876 0.547697 -0.02484675
#>      CIUpper
#> 1 0.04655638
#> 
#> $ciAvgRdrEachTrtFRRC
#>   Treatment      Area     StdErr DF   CILower   CIUpper
#> 1 TrtTREAT1 0.8477499 0.02710939 99 0.7939590 0.9015408
#> 2 TrtTREAT2 0.8368951 0.02744860 99 0.7824311 0.8913591
#> 
#> $msAnovaEachRdrFRRC
#>   Source DF  RdrREADER_1 RdrREADER_2 RdrREADER_3  RdrREADER_4
#> 1      T  1 0.0007389761  0.02307702  0.01476929 4.091217e-05
#> 2      C 99 0.2038747746  0.22344191  0.21424677 2.854199e-01
#> 3     TC 99 0.0915587344  0.08027926  0.06122898 6.057067e-02
#> 
#> $ciDiffTrtEachRdrFRRC
#>        Reader           Treatment     Estimate     StdErr DF          t
#> 1 RdrREADER_1 TrtTREAT1-TrtTREAT2 0.0038444143 0.04279223 99 0.08983908
#> 2 RdrREADER_2 TrtTREAT1-TrtTREAT2 0.0214834916 0.04006975 99 0.53615233
#> 3 RdrREADER_3 TrtTREAT1-TrtTREAT2 0.0171867933 0.03499399 99 0.49113552
#> 4 RdrREADER_4 TrtTREAT1-TrtTREAT2 0.0009045681 0.03480536 99 0.02598933
#>       PrGTt     CILower    CIUpper
#> 1 0.9285966 -0.08106465 0.08875348
#> 2 0.5930559 -0.05802359 0.10099057
#> 3 0.6244176 -0.05224888 0.08662247
#> 4 0.9793182 -0.06815683 0.06996596
#> 
#> $FTestStatsRRFC
#>      fRRFC ndfRRFC ddfRRFC     pRRFC
#> 1 4.694058       1       3 0.1188379
#> 
#> $ciDiffTrtRRFC
#>             Treatment   Estimate      StdErr DF        t     PrGTt      CILower
#> 1 TrtTREAT1-TrtTREAT2 0.01085482 0.005010122  3 2.166577 0.1188379 -0.005089627
#>      CIUpper
#> 1 0.02679926
#> 
#> $ciAvgRdrEachTrtRRFC
#>   Treatment      Area     StdErr DF   CILower   CIUpper
#> 1 TrtTREAT1 0.8477499 0.01109801  3 0.8124311 0.8830687
#> 2 TrtTREAT2 0.8368951 0.00777173  3 0.8121620 0.8616282
```

## Explanation of the output
The function returns a long unwieldy list. Let us consider them one by one. The function `UtilOutputReport()`, which can generate an Excel file report, making it much easier to visualize the results, is described in another chapter.

### FOMs
* `fomArray` contains the `[1:2,1:4]` FOM values.


```r
ret$fomArray
#>           RdrREADER_1 RdrREADER_2 RdrREADER_3 RdrREADER_4
#> TrtTREAT1   0.8534600   0.8649932   0.8573044   0.8152420
#> TrtTREAT2   0.8496156   0.8435097   0.8401176   0.8143374
```

This shows the 2 x 4 array of FOM values. 

### Pseudovalue ANOVA table

* `anovaY`, where the Y denotes that these are pseudovalue based, is the ANOVA table.



```r
ret$anovaY
#>       Source           SS  DF          MS
#> 1     Row1_T   0.02356541   1 0.023565410
#> 2     Row2_R   0.20521800   3 0.068406000
#> 3     Row3_C  52.52839868  99 0.530589886
#> 4    Row4_TR   0.01506079   3 0.005020264
#> 5    Row5_TC   6.41004881  99 0.064747968
#> 6    Row6_RC  39.24295381 297 0.132131158
#> 7   Row7_TRC  22.66007764 297 0.076296558
#> 8 Row8_Total 121.08532315 799          NA
```

### Pseudovalue ANOVA table, each treatment

* `anovaYi` is the ANOVA table for individual treatments.



```r
ret$anovaYi
#>   Source  DF  TrtTREAT1  TrtTREAT2
#> 1      R   3 0.04926635 0.02415991
#> 2      C  99 0.29396753 0.30137032
#> 3     RC 297 0.10504787 0.10337984
```

The `0` and `1` headers come from the treatment names.

### Pseudovalue Variance Components

* `varComp` is the variance components (needed for sample size estimation).



```r
ret$varComp
#>           varR       varC         varTR        varTC     varRC     varErr
#> 1 3.775568e-05 0.05125091 -0.0007127629 -0.002887147 0.0279173 0.07629656
```

### Random-reader random-case (RRRC) analysis

* `ret$FTestStatsRRRC$fRRRC` is the F-statistic for testing the NH that the
treatments have identical FOMs. RRRC means random-reader random-case generalization.



```r
ret$FTestStatsRRRC$fRRRC
#> [1] 4.694058
```

#### F-statistic and p-value for RRRC analysis
* `ret$FTestStatsRRRC$ddfRRRC` is the denominator degrees of freedom of the F-statistic.


```r
ret$FTestStatsRRRC$ddfRRRC
#> [1] 3
```

* `ret$FTestStatsRRRC$pRRRC` is the p-value of the test.


```r
ret$FTestStatsRRRC$pRRRC
#> [1] 0.1188379
```

#### Confidence Intervals for RRRC analysis

* `ciDiffTrtRRRC` is the 95% confidence interval of reader-averaged differences between treatments.



```r
ret$ciDiffTrtRRRC
#>               TrtDiff   Estimate      StdErr DF        t     PrGTt      CILower
#> 1 TrtTREAT1-TrtTREAT2 0.01085482 0.005010122  3 2.166577 0.1188379 -0.005089627
#>      CIUpper
#> 1 0.02679926
```

* `ciAvgRdrEachTrtRRRC` is the 95% confidence interval of reader-averaged FOMs for each treatments.


```r
ret$ciAvgRdrEachTrtRRRC
#>   Treatment      Area     StdErr        DF   CILower   CIUpper
#> 1 TrtTREAT1 0.8477499 0.02440215  70.12179 0.7990828 0.8964170
#> 2 TrtTREAT2 0.8368951 0.02356642 253.64403 0.7904843 0.8833058
```

### Fixed-reader random-case (FRRC) analysis

#### F-statistic and p-value for FRRC analysis

* `ret$FTestStatsFRRC$fFRRC` is the F-statistic for fixed-reader random-case analysis.



```r
ret$FTestStatsFRRC$fFRRC
#> [1] 0.363956
```

* `ret$FTestStatsFRRC$ndfFRRC` is the numerator degrees of freedom of the F-statistic, always one less than the number of treatments.



```r
ret$FTestStatsFRRC$ndfFRRC
#> [1] 1
```

* `ret$FTestStatsFRRC$ddfFRRC` is the denominator degreesof freedom of the F-statistic, for fixed-reader random-case analysis.


```r
ret$FTestStatsFRRC$ddfFRRC
#> [1] 99
```

* `ret$FTestStatsFRRC$pFRRC` is the p-value for fixed-reader random-case analysis.


```r
ret$FTestStatsFRRC$pFRRC
#> [1] 0.547697
```

#### Confidence Intervals for FRRC analysis

* `ciDiffTrtFRRC` is the 95% CI of reader-average differences between treatments for fixed-reader random-case analysis


```r
ret$ciDiffTrtFRRC
#>             Treatment   Estimate     StdErr DF         t    PrGTt     CILower
#> 1 TrtTREAT1-TrtTREAT2 0.01085482 0.01799277 99 0.6032876 0.547697 -0.02484675
#>      CIUpper
#> 1 0.04655638
```

* `ret$ciAvgRdrEachTrtFRRC` is the 95% CI of reader-average FOMs of each treatment for fixed-reader random-case analysis



```r
ret$ciAvgRdrEachTrtFRRC
#>   Treatment      Area     StdErr DF   CILower   CIUpper
#> 1 TrtTREAT1 0.8477499 0.02710939 99 0.7939590 0.9015408
#> 2 TrtTREAT2 0.8368951 0.02744860 99 0.7824311 0.8913591
```

#### ANOVA for FRRC analysis

* `ret$msAnovaEachRdrFRRC` is the mean-squares ANOVA for each reader



```r
ret$msAnovaEachRdrFRRC
#>   Source DF  RdrREADER_1 RdrREADER_2 RdrREADER_3  RdrREADER_4
#> 1      T  1 0.0007389761  0.02307702  0.01476929 4.091217e-05
#> 2      C 99 0.2038747746  0.22344191  0.21424677 2.854199e-01
#> 3     TC 99 0.0915587344  0.08027926  0.06122898 6.057067e-02
```


#### Confidence Intervals for FRRC analysis

* `ciDiffTrtFRRC` is the CI for reader-averaged treatment differences, for fixed-reader random-case analysis



```r
ret$ciDiffTrtFRRC
#>             Treatment   Estimate     StdErr DF         t    PrGTt     CILower
#> 1 TrtTREAT1-TrtTREAT2 0.01085482 0.01799277 99 0.6032876 0.547697 -0.02484675
#>      CIUpper
#> 1 0.04655638
```

### Random-reader fixed-case (RRFC) analysis

#### F-statistic and p-value for RRFC analysis
* `ret$FTestStatsRRFC$fRRFC` is the F-statistic for for random-reader fixed-case analysis


```r
ret$FTestStatsRRFC$fRRFC
#> [1] 4.694058
```

* `ret$FTestStatsRRFC$ddfRRFC` is the ddf for for random-reader fixed-case analysis


```r
ret$FTestStatsRRFC$ddfRRFC
#> [1] 3
```

* `ret$FTestStatsRRFC$pRRFC` is the p-value for for random-reader fixed-case analysis


```r
ret$FTestStatsRRFC$pRRFC
#> [1] 0.1188379
```

#### Confidence Intervals for RRFC analysis

* `ciDiffTrtRRFC` is the CI for reader-averaged inter-treatment FOM differences for random-reader fixed-case analysis


```r
ret$ciDiffTrtRRFC
#>             Treatment   Estimate      StdErr DF        t     PrGTt      CILower
#> 1 TrtTREAT1-TrtTREAT2 0.01085482 0.005010122  3 2.166577 0.1188379 -0.005089627
#>      CIUpper
#> 1 0.02679926
```

* `ciAvgRdrEachTrtRRFC` is the CI for treatment FOMs for each reader for random-reader fixed-case analysis


```r
ret$ciAvgRdrEachTrtRRFC
#>   Treatment      Area     StdErr DF   CILower   CIUpper
#> 1 TrtTREAT1 0.8477499 0.01109801  3 0.8124311 0.8830687
#> 2 TrtTREAT2 0.8368951 0.00777173  3 0.8121620 0.8616282
```

## ORH significance testing
Simply change `method = "DBMH"` to `method = "ORH"`.


```r
ret <- StSignificanceTesting(dataset03, FOM = "Wilcoxon", method = "ORH")
str(ret)
#> List of 14
#>  $ fomArray            : num [1:2, 1:4] 0.853 0.85 0.865 0.844 0.857 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:2] "TrtTREAT1" "TrtTREAT2"
#>   .. ..$ : chr [1:4] "RdrREADER_1" "RdrREADER_2" "RdrREADER_3" "RdrREADER_4"
#>  $ meanSquares         :'data.frame':	1 obs. of  3 variables:
#>   ..$ msT : num 0.000236
#>   ..$ msR : num 0.000684
#>   ..$ msTR: num 5.02e-05
#>  $ varComp             :'data.frame':	1 obs. of  6 variables:
#>   ..$ varR : num 2.33e-05
#>   ..$ varTR: num -0.000684
#>   ..$ cov1 : num 0.000792
#>   ..$ cov2 : num 0.000484
#>   ..$ cov3 : num 0.000513
#>   ..$ var  : num 0.00153
#>  $ FTestStatsRRRC      :'data.frame':	1 obs. of  4 variables:
#>   ..$ fRRRC  : num 4.69
#>   ..$ ndfRRRC: num 1
#>   ..$ ddfRRRC: num 3
#>   ..$ pRRRC  : num 0.119
#>  $ ciDiffTrtRRRC       :'data.frame':	1 obs. of  8 variables:
#>   ..$ Treatment: chr "TrtTREAT1-TrtTREAT2"
#>   ..$ Estimate : num 0.0109
#>   ..$ StdErr   : num 0.00501
#>   ..$ DF       : num 3
#>   ..$ t        : num 2.17
#>   ..$ PrGTt    : num 0.119
#>   ..$ CILower  : num -0.00509
#>   ..$ CIUpper  : num 0.0268
#>  $ ciAvgRdrEachTrtRRRC :'data.frame':	2 obs. of  6 variables:
#>   ..$ Treatment: Factor w/ 2 levels "TrtTREAT1","TrtTREAT2": 1 2
#>   ..$ Area     : num [1:2] 0.848 0.837
#>   ..$ StdErr   : num [1:2] 0.0244 0.0236
#>   ..$ DF       : num [1:2] 70.1 253.6
#>   ..$ CILower  : num [1:2] 0.799 0.79
#>   ..$ CIUpper  : num [1:2] 0.896 0.883
#>  $ FTestStatsFRRC      :'data.frame':	1 obs. of  4 variables:
#>   ..$ fFRRC  : num 0.364
#>   ..$ ndfFRRC: num 1
#>   ..$ ddfFRRC: num Inf
#>   ..$ pFRRC  : num 0.546
#>  $ ciDiffTrtFRRC       :'data.frame':	1 obs. of  8 variables:
#>   ..$ Treatment: chr "TrtTREAT1-TrtTREAT2"
#>   ..$ Estimate : num 0.0109
#>   ..$ StdErr   : num 0.018
#>   ..$ DF       : num Inf
#>   ..$ t        : num 0.603
#>   ..$ PrGTt    : num 0.546
#>   ..$ CILower  : num -0.0244
#>   ..$ CIUpper  : num 0.0461
#>  $ ciAvgRdrEachTrtFRRC :'data.frame':	2 obs. of  6 variables:
#>   ..$ Treatment: Factor w/ 2 levels "TrtTREAT1","TrtTREAT2": 1 2
#>   ..$ Area     : num [1:2] 0.848 0.837
#>   ..$ StdErr   : num [1:2] 0.0271 0.0274
#>   ..$ DF       : num [1:2] Inf Inf
#>   ..$ CILower  : num [1:2] 0.795 0.783
#>   ..$ CIUpper  : num [1:2] 0.901 0.891
#>  $ ciDiffTrtEachRdrFRRC:'data.frame':	4 obs. of  9 variables:
#>   ..$ Reader   : Factor w/ 4 levels "RdrREADER_1",..: 1 2 3 4
#>   ..$ Treatment: Factor w/ 1 level "TrtTREAT1-TrtTREAT2": 1 1 1 1
#>   ..$ Estimate : num [1:4] 0.003844 0.021483 0.017187 0.000905
#>   ..$ StdErr   : num [1:4] 0.0428 0.0401 0.035 0.0348
#>   ..$ DF       : num [1:4] Inf Inf Inf Inf
#>   ..$ t        : num [1:4] 0.0898 0.5362 0.4911 0.026
#>   ..$ PrGTt    : num [1:4] 0.928 0.592 0.623 0.979
#>   ..$ CILower  : num [1:4] -0.08 -0.0571 -0.0514 -0.0673
#>   ..$ CIUpper  : num [1:4] 0.0877 0.1 0.0858 0.0691
#>  $ varCovEachRdr       :'data.frame':	4 obs. of  3 variables:
#>   ..$ Reader: Factor w/ 4 levels "RdrREADER_1",..: 1 2 3 4
#>   ..$ Var   : num [1:4] 0.00148 0.00152 0.00138 0.00173
#>   ..$ Cov1  : num [1:4] 0.000562 0.000716 0.000765 0.001124
#>  $ FTestStatsRRFC      :'data.frame':	1 obs. of  4 variables:
#>   ..$ fRRFC  : num 4.69
#>   ..$ ndfRRFC: num 1
#>   ..$ ddfRRFC: num 3
#>   ..$ pRRFC  : num 0.119
#>  $ ciDiffTrtRRFC       :'data.frame':	1 obs. of  8 variables:
#>   ..$ Treatment: chr "TrtTREAT1-TrtTREAT2"
#>   ..$ Estimate : num 0.0109
#>   ..$ StdErr   : num 0.00501
#>   ..$ DF       : num 3
#>   ..$ t        : num 2.17
#>   ..$ PrGTt    : num 0.119
#>   ..$ CILower  : num -0.00509
#>   ..$ CIUpper  : num 0.0268
#>  $ ciAvgRdrEachTrtRRFC :'data.frame':	2 obs. of  6 variables:
#>   ..$ Treatment: Factor w/ 2 levels "TrtTREAT1","TrtTREAT2": 1 2
#>   ..$ Area     : num [1:2] 0.848 0.837
#>   ..$ StdErr   : num [1:2] 0.0111 0.00777
#>   ..$ DF       : num [1:2] 3 3
#>   ..$ CILower  : num [1:2] 0.812 0.812
#>   ..$ CIUpper  : num [1:2] 0.883 0.862
```


## References
