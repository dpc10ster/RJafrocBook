# Simulate an FROC split plot dataset {#SimufrocSpdataset}




## This vignette is under construction!!
* This is a follow-up on the recently added (v1.3.1) capability to read a split-plot dataset.
* Lacking an actual split-plot dataset to test the routines, I decided to simulate one.
* The simulated dataset is of dataType FROC and the number of cases interpreted by each reader is reader-dependent.
* This makes it *really* exercise the validity of the `DfReadDataFile` function.
* In my experience, the `dataset$truthTableStr` member is invaluable in catching data entry errors so much of this vignette focuses on it.

## The starting point is an actual crossed FROC dataset
The example shown below begins with the Excel file `inst/extdata/FrocData.xlsx` in the project directory (this corresponds to the 5-modality FED dataset `dataseet04` [@RN1882] with modalities 1, 2 and 3 removed). The first statement retrieves the name of the data file, located in a hidden directory that one need not be concerned with. The second statement reads the file using `DfReadDataFile()` and saves it to object `x1`. The next statement extracts the `truthTableStr` list member, saves it to `t1` and shows its structure.


```r
fed <- system.file("extdata", "FrocData.xlsx",
                       package = "RJafroc", mustWork = TRUE)
x1 <- DfReadDataFile(fed, newExcelFileFormat = TRUE)
t1 <- x1$truthTableStr
str(t1)
#>  num [1:2, 1:4, 1:200, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
```

* There are 100 normal and 100 abnormal cases in this two-modality four-reader crossed dataset.
* Note that `t1` is the original crossed dataset `truthTableStr`.
* Recall from earlier vignette that for the fourth subscript of `t1` the value 1 applies to cases with no lesions (normals), value 2 applies to cases with one lesion, value 3 applies to cases with two lesions and 4 applies to cases with three lesions.
* The value for any allowed interpretation is 1 and otherwise it is `NA`.

## Understanding `truthTableStr` object `t1`
* The following line yields 200 (=2*100) as reader 1 (second subscript) provides interpretations in both modalities (first subscript is blank meaning both modalities) for all 100 normal cases (third subscript is 1:100 and fourth subscript is 1) and therefore each of these interpretations yields a `TRUE` (i.e., 1).

```r
sum(!is.na(t1[,1,1:100,1]))
#> [1] 200
```
* The following line yields 0 as the third subscript is 1:100, implying normal cases, but the fourth subscript is 2:4, implyng abnormal cases and therefore each of these interpretations yields an NA and `!is.na(NA)` equals `FALSE` (i.e., zero).

```r
sum(!is.na(t1[,1,1:100,2:4]))
#> [1] 0
```

* The following line also yields 800 (=2x4x100) as readers 1:4 provide interpretations in both modalities for all normal cases and each interpretation yields a 1.

```r
sum(!is.na(t1[,,1:100,1]))
#> [1] 800
```

* The following line yields 200 (=2*100) because the fourth subscript (2) applies to abnormal cases with at least one lesion, and each abnormal case is guaranteed to have at least one lesion (i.e., a 1 entry in the `LesionID` column of the Excel Truth worksheet) and each of these interpretations yields a 1.

```r
sum(!is.na(t1[,1,101:200,2]))
#> [1] 200
```

* The following line yields 62 (=2x31) because the fourth subscript (3) applies to abnormal cases with at least two lesions, and inspection of the `LesionID` column in the original Excel file reveals that 31 abnormal cases have two lesions. 

```r
sum(!is.na(t1[,1,101:200,3]))
#> [1] 62
```

* The following line yields 22 (=2x11) because the fourth subscript (4) applies to abnormal cases with three lesions. Inspection of the `LesionID` column reveals that 11 abnormal cases have three lesions. 


```r
sum(!is.na(t1[,1,101:200,4]))
#> [1] 22
```

* The following line yields 242 (=200+31+11), the number of rows in the `Truth` worksheet.

```r
sum(!is.na(t1[1,1,,]))
#> [1] 242
```

## Modify a crossed FROC workbook to simulate a split-plot FROC design
* We create a simulated split-plot FROC dataset starting from a crossed FROC dataset. 
* The basic idea is to modify interpretations that do not belong to a specified split-plot design.
* This was done (one could say the "hard way") by manually making apppropriate changes to `inst/extdata/FrocData.xlsx` and saving the results to `inst/extdata/toyFiles/FROC/FrocDataSpVaryK1K2.xlsx`. The filename is intended to emphasize that the numbers of normal and abnormal cases can be reader-dependent, as long as they individually add up to 100.
* We divided the 100 normal and 100 abnormal cases into 4 groups of normal and abnormal cases, where each group is interpreted by one reader only.
* The first groups of cases, interpreted by reader 1 (label "1"), consists of 23 normal (case labels "100:122") and 24 abnormal (case labels "0:23") cases.
* The second groups of cases, interpreted by reader 2 (label "3"), consists of 27 normal (case labels "123:149") and 26 abnormal (case labels "24:49") cases.
* The third groups of cases, interpreted by reader 3 (label "4"), consists of 22 normal (case labels "150:171") and 23 abnormal (case labels "51:73") cases.
* The fourth groups of cases, interpreted by reader 4 (label "5"), consists of 28 normal (case labels "172:199") and 27 abnormal (case labels c("50,74:99")) cases.



<div class="figure" style="text-align: center">
<img src="images/frocData.png" alt="Truth worksheets; (a) LEFT=FrocData.xlsx, original crossed dataset; (b) RIGHT=FrocDataSpVaryK1K2.xlsx, modified split-plot dataset" width="50%" height="20%" /><img src="images/frocDataSpVaryK1K2.png" alt="Truth worksheets; (a) LEFT=FrocData.xlsx, original crossed dataset; (b) RIGHT=FrocDataSpVaryK1K2.xlsx, modified split-plot dataset" width="50%" height="20%" />
<p class="caption">(\#fig:frocDataSpVaryK1K2)Truth worksheets; (a) LEFT=FrocData.xlsx, original crossed dataset; (b) RIGHT=FrocDataSpVaryK1K2.xlsx, modified split-plot dataset</p>
</div>

* The above figure shows that the `ReaderID` column for cases `0:23` has been replaced with a 1, meaning that only reader 1 interprets these cases in both modalities. This yields 24 abnormal cases for reader 1 in each modality. Normal cases for this reader are `100:122`.
* Not shown above: **all interpretations by reader 1 occurring for cases outside of `0:23` and `100:122` in the other two worksheets (`TP` and `FP`) are deleted**.
* The `ReaderID` column for cases `24:49` are replaced by 3, corresponding to the second reader. All interpretations by this reader for cases outside of `24:49` in the other two worksheets are deleted. Normal cases for this reader are `123:149` and observations outside of this range in the `TP` and `FP` worsheets are deleted.
* The `ReaderID` column for cases `51:73` are replaced by 4, corresponding to the third reader. All interpretations by this reader for cases outside of `51:73` in the other two worksheets are deleted. Normal cases for this reader are `150:171` and observations outside of this range in the `TP` and `FP` worsheets are deleted.
* The `ReaderID` column for cases `50` and `74:79` are replaced by 5, corresponding to the fourth reader. All interpretations by this reader for cases outside of the specified range in the other two worksheets are deleted. Normal cases for this reader are `172:199` and observations outside of this range in the `TP` and `FP` worsheets are deleted. 
<!-- * The modifed file is saved to `extdata/toyFiles/FROC/FrocDataSpVaryK1K2.xlsx`. -->
* The modified file is read by the code chunk below. The read function explicitly tests that observations outside of the specified ranges in the `Truth` sheet are not present in the other two worksheets.

## Example of deletion of interpretations
<div class="figure" style="text-align: center">
<img src="images/frocDataFP.png" alt="FP worksheets; (a) LEFT=FrocDataFP.xlsx, original crossed dataset; (b) RIGHT=FrocDataSpVaryK1K2FP.xlsx, modified split-plot dataset" width="50%" height="20%" /><img src="images/frocDataSpVaryK1K2FP.png" alt="FP worksheets; (a) LEFT=FrocDataFP.xlsx, original crossed dataset; (b) RIGHT=FrocDataSpVaryK1K2FP.xlsx, modified split-plot dataset" width="50%" height="20%" />
<p class="caption">(\#fig:frocDataSpVaryK1K2FP)FP worksheets; (a) LEFT=FrocDataFP.xlsx, original crossed dataset; (b) RIGHT=FrocDataSpVaryK1K2FP.xlsx, modified split-plot dataset</p>
</div>

* The two figures above illustrate deletion of interpretations.
* The left panel shows the `FP` worksheet for the original crossed data.
* For reader 1 and modality 4 it contains cases 29, 30, 44, ..., 91, 96 that do not belong to the split-plot dataset for this reader.
* Specifically, they are outside of `0:23` and `100:122`, the allowed ranges for this reader. 
* These are deleted, see right panel of above figure. The next allowed cases for this reader are `107, 109,...., 122`.
* The procedure is repeated for all readers and both `TP` and `FP` sheets.


```r
fedsp <- system.file("extdata", "toyFiles/FROC/FrocDataSpVaryK1K2.xlsx",
                       package = "RJafroc", mustWork = TRUE)
x2 <- DfReadDataFile(fedsp, newExcelFileFormat = TRUE)
t2 <- x2$truthTableStr
```

## Understanding `truthTableStr` object `t2`
* The following line below yields 46 (= 2x23) as reader 1 (second subscript) provides interpretations in both modalities (first subscript is blank) for all normal cases (third subscript is 1:100 and fourth subscript is 1) and there are 23 normal cases interpreted by reader 1.

```r
sum(!is.na(t2[,1,1:100,1]))
#> [1] 46
```

* The following line confirms the first line, with a 1 contribution coming from each case in range 1:23.

```r
sum(!is.na(t2[,1,1:23,1]))
#> [1] 46
```

* The following line yields 48 (= 2x24) because the fourth subscript (2) applies to abnormal cases with at least one lesion, and we know that this reader has interpreted 24 abnormal cases.

```r
sum(!is.na(t2[,1,101:124,2]))
#> [1] 48
```

* The following line yields 54 (= 2x27) because the fourth subscript (1) applies to normal cases and we know that reader 2 has interpreted 27 normal cases.

```r
sum(!is.na(t2[,2,,1]))
#> [1] 54
```

* The following line yields 52 (= 2x26) because the fourth subscript (2:4) applies to abnormal cases with at least one lesion, and we know that reader 2 has interpreted 26 abnormal cases.

```r
sum(!is.na(t2[,2,,2:4]))
#> [1] 52
```

## References  