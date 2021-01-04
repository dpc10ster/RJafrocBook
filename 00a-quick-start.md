# (PART\*) Quick Start {-}

# DBM analysis text output {#quick-start-dbm-text}





## How much finished {#quick-start-dbm-text-how-much-finished}
90%



## Introduction {#quick-start-dbm-text-intro}
This chapter is intended for those seeking a quick-and-easy transition from Windows `JAFROC` to `RJafroc`. Described first is the structure of an `RJafroc` dataset followed by how to read a JAFROC  format Excel file to create an `RJafroc` dataset.

## Reading a JAFROC format file {#quick-start-dbm-text-read-file}

There is a file `RocData.xlsx` contained in directory `R/quick-start`. This is identical to embedded `dataset02`, the Van Dyke dataset in the ROC literature [@RN1993]. Here are screen shots of the three worksheets comprising this Excel file. 



<div class="figure" style="text-align: center">
<img src="R/quick-start/RocTruth.png" alt="Three worksheets - Truth, FP and TP, comprising Excel file `R/quick-start/Roc.xlsx`" width="50%" height="20%" /><img src="R/quick-start/RocFP.png" alt="Three worksheets - Truth, FP and TP, comprising Excel file `R/quick-start/Roc.xlsx`" width="50%" height="20%" /><img src="R/quick-start/RocTP.png" alt="Three worksheets - Truth, FP and TP, comprising Excel file `R/quick-start/Roc.xlsx`" width="50%" height="20%" />
<p class="caption">(\#fig:quick-start-dbm-roc-xlsx)Three worksheets - Truth, FP and TP, comprising Excel file `R/quick-start/Roc.xlsx`</p>
</div>


Next, one uses `DfReadDataFile()` as follows, to read the data file into an `R` object.



```r
fileName <- "R/quick-start/Roc.xlsx"
ds2 <- DfReadDataFile(fileName)
str(ds2)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1:2, 1:5, 1:114, 1] 1 3 2 3 2 2 1 2 3 2 ...
#>   ..$ LL   : num [1:2, 1:5, 1:45, 1] 5 5 5 5 5 5 5 5 5 5 ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: int [1:45] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ IDs    : num [1:45, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ weights: num [1:45, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "Roc"
#>   ..$ type         : chr "ROC"
#>   ..$ name         : logi NA
#>   ..$ truthTableStr: num [1:2, 1:5, 1:114, 1:2] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ design       : chr "FCTRL"
#>   ..$ modalityID   : Named chr [1:2] "0" "1"
#>   .. ..- attr(*, "names")= chr [1:2] "0" "1"
#>   ..$ readerID     : Named chr [1:5] "0" "1" "2" "3" ...
#>   .. ..- attr(*, "names")= chr [1:5] "0" "1" "2" "3" ...
```


The following illustration uses a different dataset.


## Dataset structure {#quick-start-dbm-text-dataset-structure}
Data set `dataset03` corresponding to the Franken ROC dataset [@RN1995] is embedded in `RJafroc`. The structure of this dataset is shown below.


```r
ds <- dataset03
str(ds)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1:2, 1:4, 1:100, 1] 3 3 4 3 3 3 4 1 1 3 ...
#>   ..$ LL   : num [1:2, 1:4, 1:67, 1] 5 5 4 4 5 4 4 5 2 2 ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: num [1:67] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ IDs    : num [1:67, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ weights: num [1:67, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "dataset03"
#>   ..$ type         : chr "ROC"
#>   ..$ name         : chr "FRANKEN"
#>   ..$ truthTableStr: num [1:2, 1:4, 1:100, 1:2] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ design       : chr "FCTRL"
#>   ..$ modalityID   : Named chr [1:2] "TREAT1" "TREAT2"
#>   .. ..- attr(*, "names")= chr [1:2] "TREAT1" "TREAT2"
#>   ..$ readerID     : Named chr [1:4] "READER_1" "READER_2" "READER_3" "READER_4"
#>   .. ..- attr(*, "names")= chr [1:4] "READER_1" "READER_2" "READER_3" "READER_4"
```

* `ds` is a list with 3 members. 
    + `ratings`
    + `lesions`
    + `descriptions`
* `ratings` is a list with three members
    + `NL` This contains the NL/FP ratings
    + `LL` This contains the LL/TP ratings
    + `LL_IL` This contains the LROC incorrect localization ratings
* `lesions` is a list with 3 members
    + `perCase` number of lesions per diseased case array
    + `IDs` lesion IDs array (labels attached to each lesion)
    + `weights` lesion weights array
* `descriptions` is a list with 7 members
    + `fileName` name of the original file the data came from, if available, or the embedded dataset name
    + `type` The type of dataset, "ROC", "FROC", "LROC" or "ROI"
    + `name` The name of the dataset
    + `truthTableStr` The structure of the truth table, for internal use, for checking data consistency
    + `design` The design of the dataset, FCTRL, SPLIT-PLOT-A or SPLIT-PLOT-C
    + `modalityID` The IDs of the modalities
    + `readerID` The IDs of the readers


The false positive ratings are contained in `NL`, an array with dimensions `[1:2,1:4,1:100,1]`. 


```r
str(ds$ratings$NL)
#>  num [1:2, 1:4, 1:100, 1] 3 3 4 3 3 3 4 1 1 3 ...
```

The first index corresponds to the two treatments. The second index corresponds to the four readers. The third index corresponds to the 100 cases. The fourth dimension, with length one, corresponds to one FP/NL per case; the redundant index is needed for consistency with FROC data, where multiple NLs per case are possible.


```r
str(ds$ratings$NL[1,1,34:100,1])
#>  num [1:67] -Inf -Inf -Inf -Inf -Inf ...
all(ds$ratings$ratings$ratings$NL[,,34:100,1] == -Inf)
#> [1] TRUE
```


The entries in this array for cases 34 through 100 are all `-Inf` (this is tested for by the `all()` function, which yields `TRUE` if all of its arguments are true). In the ROC paradigm false positive are not possible on diseased cases (but they are possible for FROC data). So the actual FP ratings are contained in the first 33 elements of the array. 



```r
str(ds$ratings$LL)
#>  num [1:2, 1:4, 1:67, 1] 5 5 4 4 5 4 4 5 2 2 ...
```

`LL` is an array with dimensions `[1:2,1:4,1:67,1]`. This implies 67 diseased cases and by subtraction from 100 there must be 33 non-diseased cases. The redundant dimension, with length one, is needed for consistency with FROC data, where multiple lesions per case are possible.


```r
str(ds$lesions$perCase)
#>  num [1:67] 1 1 1 1 1 1 1 1 1 1 ...
```


`perCase` is a vector with length 67, implying 100 - 67 = 33 non-diseased cases. Each element of `perCase` is unity, corresponding to one lesion per diseased case for ROC data.



```r
str(ds$lesions$IDs)
#>  num [1:67, 1] 1 1 1 1 1 1 1 1 1 1 ...
str(ds$lesions$weights)
#>  num [1:67, 1] 1 1 1 1 1 1 1 1 1 1 ...
```


The list members `lesionID` and `lesionWeight` are arrays with dimensions `[1:67,1]` containing ones. Again, these imply 67 diseased cases. The extra dimension, with length one, is needed for consistency with FROC data. The variables `perCase`, `IDs` and `weights`, while not needed for ROC data, are there for consistency with FROC data.


```r
str(ds$descriptions$type)
#>  chr "ROC"
```


The `type` list member is the character string `"ROC"`, for an ROC dataset. Other possibilities are `"FROC"`, `"LROC"` and `"ROI"`.

    

```r
str(ds$descriptions$modalityID)
#>  Named chr [1:2] "TREAT1" "TREAT2"
#>  - attr(*, "names")= chr [1:2] "TREAT1" "TREAT2"
```


The `modalityID` list member is a character string with two entries, `"TREAT1"` and `"TREAT2"`, corresponding to the two modalities. 

    

```r
str(ds$descriptions$readerID)
#>  Named chr [1:4] "READER_1" "READER_2" "READER_3" "READER_4"
#>  - attr(*, "names")= chr [1:4] "READER_1" "READER_2" "READER_3" "READER_4"
```

The `readerID` list member is a character string with four entries, `"READER_1"`,  `"READER_2"`, `"READER_3"` and `"READER_4"` corresponding to the four readers. 
    

Here are the actual ratings for cases 1 through 33.


```r
ds$ratings$NL[1,1,1:33,1]
#>  [1] 3 1 2 2 2 2 2 4 1 1 4 2 1 2 4 2 1 2 1 2 4 2 3 2 2 2 4 3 2 2 2 5 3
```

This says that for treatment 1 and reader 1, (non-diseased) case 1 was rated 3, case 2 was rated 1, cases 3-7 were rated 2, case 8 was rated 4, etc. As another example, for treatment 2 and reader 3, the FP ratings are: 


```r
ds$ratings$NL[2,3,1:33,1]
#>  [1] 3 1 2 2 2 2 4 4 2 3 2 2 1 3 2 4 2 3 2 2 2 2 2 4 2 2 1 2 2 2 2 4 2
```


This says that for treatment 2 and reader 3, (non-diseased) case 1 was rated 3, case 2 was rated 1, cases 3-6 were rated 2, cases 7-8 were rated 4, etc. 


## Analyzing the ROC dataset {#quick-start-dbm-text-analyze-dataset}

This illustrates the `StSignificanceTesting()` function. The significance testing method is specified as `"DBM"` and the figure of merit `FOM` is specified as "Wilcoxon".


```r
ret <- StSignificanceTesting(ds, FOM = "Wilcoxon", method = "DBM")
```

## Explanation of the output {#quick-start-dbm-text-explanation}
The function returns a list with 5 members: 

* `FOMs`: figures of merit.
* `ANOVA`: ANOVA tables.
* `RRRC`: random-reader random-case analyses results.
* `FRRC`: fixed-reader random-case analyses results.
* `RRFC`" random-reader fixed-case analyses results.

Let us consider them one by one. 

* `FOMs` is a list of 3
    + `foms` is a [2x4] dataframe: the figure of merit for each of of the four observers in the two treatments.
    + `trtMeans` is a [2x1] dataframe: the average figure of merit over all readers for each treatment.
    + `trtMeanDiffs` a [1x1] dataframe: the difference(s) of the reader-averaged figures of merit for all different treatment pairings. In this example, with only two treatments, there is only one different treatment pairing.
    

```r
ret$FOMs$foms
#>           rdrREADER_1 rdrREADER_2 rdrREADER_3 rdrREADER_4
#> trtTREAT1  0.85345997  0.86499322  0.85730439  0.81524197
#> trtTREAT2  0.84961556  0.84350972  0.84011759  0.81433740
ret$FOMs$trtMeans
#>             Estimate
#> trtTREAT1 0.84774989
#> trtTREAT2 0.83689507
ret$FOMs$trtMeanDiffs
#>                        Estimate
#> trtTREAT1-trtTREAT2 0.010854817
```

* ANOVA is a list of 4
    + `TRCanova` is a [8x3] dataframe: the treatment-reader-case ANOVA table, see below, where SS is the sum of squares, DF is the denominator degrees of freedom and MS is the mean squares, and T = treatment, R = reader, C = case, TR = treatment-reader, TC = treatment-case, RC = reader-case, TRC = treatment-reader-case.  
    + `VarCom` is a [6x1] dataframe: the variance components, see below, where `varR` is the reader variance, `varC` is the case variance, `varTR` is the treatment-reader variance, `varTC` is the treatment-case variance, `varRC` is the reader-case variance, and `varTRC` is the treatment-reader-case variance.
    + `IndividualTrt` is a [3x3] dataframe: the individual treatment variance components averaged over all readers, see below, where `msR` is the mean square reader, `msC` is the mean square case and `msRC` is the mean square reader-case.
    + `IndividualRdr` is a [3x5] dataframe: the individual reader variance components averaged over treatments, see below, where `msT` is the mean square treatment, `msC` is the mean square case and `msTC` is the mean square treatment-case.
    

```r
ret$ANOVA$TRCanova
#>                  SS  DF           MS
#> T       0.023565410   1 0.0235654097
#> R       0.205217999   3 0.0684059998
#> C      52.528398680  99 0.5305898857
#> TR      0.015060792   3 0.0050202641
#> TC      6.410048814  99 0.0647479678
#> RC     39.242953812 297 0.1321311576
#> TRC    22.660077641 297 0.0762965577
#> Total 121.085323149 799           NA
ret$ANOVA$VarCom
#>             Estimates
#> VarR    3.7755679e-05
#> VarC    5.1250915e-02
#> VarTR  -7.1276294e-04
#> VarTC  -2.8871475e-03
#> VarRC   2.7917300e-02
#> VarErr  7.6296558e-02
ret$ANOVA$IndividualTrt
#>       DF   TrtTREAT1   TrtTREAT2
#> msR    3 0.049266349 0.024159915
#> msC   99 0.293967531 0.301370323
#> msRC 297 0.105047872 0.103379843
ret$ANOVA$IndividualRdr
#>      DF   rdrREADER_1 rdrREADER_2 rdrREADER_3   rdrREADER_4
#> msT   1 0.00073897606 0.023077021 0.014769293 0.00004091217
#> msC  99 0.20387477465 0.223441908 0.214246773 0.28541990211
#> msTC 99 0.09155873437 0.080279256 0.061228980 0.06057067104
```

* RRRC, a list of 3 containing results of random-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below, where `FStat` is the F-statistic and `p` is the p-value. The first row is the treatment effect and the second is the error term. 
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different treatments, see below, where `StdErr` is the standard error of the estimate, `t` is the t-statistic and `PrGTt` is the p-value.
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each treatment, see below, where `CILower` is the lower 95% confidence interval and `CIUpper` is the upper 95% confidence interval.
    

```r
ret$RRRC$FTests
#>           DF           MS     FStat          p
#> Treatment  1 0.0235654097 4.6940577 0.11883786
#> Error      3 0.0050202641        NA         NA
ret$RRRC$ciDiffTrt
#>                        Estimate       StdErr DF         t      PrGTt
#> trtTREAT1-trtTREAT2 0.010854817 0.0050101218  3 2.1665774 0.11883786
#>                           CILower     CIUpper
#> trtTREAT1-trtTREAT2 -0.0050896269 0.026799261
ret$RRRC$ciAvgRdrEachTrt
#>             Estimate      StdErr         DF    CILower    CIUpper
#> trtTREAT1 0.84774989 0.024402152  70.121788 0.79908282 0.89641696
#> trtTREAT2 0.83689507 0.023566416 253.644028 0.79048429 0.88330585
```

* FRRC, a list of 4 containing results of fixed-reader random-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below.
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different treatments, see below.
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each treatment
    + `ciDiffTrtEachRdr`: is a [4x7] dataframe: the confidence intervals for each different-treatment pairing for each reader. 
    

```r
ret$FRRC$FTests
#>           DF          MS      FStat          p
#> Treatment  1 0.023565410 0.36395597 0.54769704
#> Error     99 0.064747968         NA         NA
ret$FRRC$ciDiffTrt
#>                        Estimate      StdErr DF          t      PrGTt
#> trtTREAT1-trtTREAT2 0.010854817 0.017992772 99 0.60328764 0.54769704
#>                          CILower    CIUpper
#> trtTREAT1-trtTREAT2 -0.024846746 0.04655638
ret$FRRC$ciAvgRdrEachTrt
#>             Estimate      StdErr DF    CILower    CIUpper
#> trtTREAT1 0.84774989 0.027109386 99 0.79395898 0.90154079
#> trtTREAT2 0.83689507 0.027448603 99 0.78243109 0.89135905
ret$FRRC$ciDiffTrtEachRdr
#>                                       Estimate      StdErr DF           t
#> rdrREADER_1::trtTREAT1-trtTREAT2 0.00384441429 0.042792227 99 0.089839080
#> rdrREADER_2::trtTREAT1-trtTREAT2 0.02148349163 0.040069753 99 0.536152334
#> rdrREADER_3::trtTREAT1-trtTREAT2 0.01718679331 0.034993994 99 0.491135520
#> rdrREADER_4::trtTREAT1-trtTREAT2 0.00090456807 0.034805365 99 0.025989329
#>                                       PrGTt      CILower     CIUpper
#> rdrREADER_1::trtTREAT1-trtTREAT2 0.92859660 -0.081064648 0.088753476
#> rdrREADER_2::trtTREAT1-trtTREAT2 0.59305592 -0.058023592 0.100990575
#> rdrREADER_3::trtTREAT1-trtTREAT2 0.62441761 -0.052248882 0.086622469
#> rdrREADER_4::trtTREAT1-trtTREAT2 0.97931817 -0.068156827 0.069965963
```

    
* RRFC, a list of 3 containing results of random-reader fixed-case analyses
    + `FTtests`: is a [2x4] dataframe: results of the F-tests, see below. 
    + `ciDiffTrt`: is a [1x7] dataframe: the confidence intervals between different treatments, see below. 
    + `ciAvgRdrEachTrt`: is a [2x5] dataframe: the confidence intervals for the average reader over each  over each treatment.  

    

```r
ret$RRFC$FTests
#>           DF           MS     FStat          p
#> Treatment  1 0.0235654097 4.6940577 0.11883786
#> Error      3 0.0050202641        NA         NA
ret$RRFC$ciDiffTrt
#>                        Estimate       StdErr DF         t      PrGTt
#> trtTREAT1-trtTREAT2 0.010854817 0.0050101218  3 2.1665774 0.11883786
#>                           CILower     CIUpper
#> trtTREAT1-trtTREAT2 -0.0050896269 0.026799261
ret$RRFC$ciAvgRdrEachTrt
#>             Estimate      StdErr DF    CILower    CIUpper
#> trtTREAT1 0.84774989 0.011098012  3 0.81243106 0.88306871
#> trtTREAT2 0.83689507 0.007771730  3 0.81216196 0.86162818
```


## References {#quick-start-dbm-text-references}
