# FROC data format {#frocdataformat}



## Introduction
* In the free-response ROC (__FROC__) paradigm [@RN85] the observer's task is to: 
  + indicate (i.e., __mark__ the location of) and 
  +  __rate__ (i.e., assign an ordered label representing the degree of suspicion) regions in the image that are perceived as suspicious for presence of disease. 
  + Accordingly, FROC data consists of __mark-rating pairs__, where each mark indicates a region ^[In order to avoid confusion with the ROI-paradigm, I do not like to use the term ROI to describe the marks made by the observer.] that was considered suspicious for presence of a localized lesion and the rating is the corresponding confidence level. 
  + The number of mark-rating pairs on any particular case is a-priori unpredictable. It is a non-negative random integer (i.e., 0, 1, 2, ...) that depends on the case, the reader and the modality. The relatively unstructured nature of FROC data makes  FROC paradigm data seemingly more difficult to analyze than ROC paradigm data ^[I say "seemingly", because the only real difference between ROC and FROC analyses is in the selection of the figure of merit.].
* By adopting a proximity criterion, each mark is classified by the investigator as a lesion localization (LL) - if it is close to a real lesion - or a non-lesion localization (NL) otherwise. 
* The rating can be an integer or quasi- continuous (e.g., 0 – 100), or a floating point value, as long as higher numbers represent greater confidence in presence of one or more lesions in the ROI  ^[As with the ROC paradigm, the directionaliy of the rating is not a limitation.].
* For human observer studies a 5-point rating scale is recommended:
    + 1: Very low, but finite possibility that the region is diseased. 
    + 2: Low possibility that the region is diseased. 
    + 3: Moderate possibility that the region is diseased. 
    + 4: High possibility that the region is diseased. 
    + 5: Very high possibility that the region is diseased.
* The actual adjectives used to describe the labels are unimportant. What is important is the ordering of the labels and that the observer holds them relatively constant for the duration of the study.
* With algorithmic readers, e.g., computer aided detection (CAD) algorithms, a floating point rating, if possible, should be retained.
* In the most common study design, termed multiple-reader multiple-case (__MRMC__), the rating collection procedure is repeated for all cases, treatments and readers.

## An actual MRMC FROC dataset

Such a dataset [@RN1882] is included as `dataset04`. It has the following structure:
  

```r
str(dataset04)
#> List of 8
#>  $ NL          : num [1:5, 1:4, 1:200, 1:7] -Inf -Inf 1 -Inf -Inf ...
#>  $ LL          : num [1:5, 1:4, 1:100, 1:3] 4 5 4 5 4 3 5 4 4 3 ...
#>  $ lesionNum   : int [1:100] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ lesionID    : num [1:100, 1:3] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ lesionWeight: num [1:100, 1:3] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ dataType    : chr "FROC"
#>  $ modalityID  : Named chr [1:5] "1" "2" "3" "4" ...
#>   ..- attr(*, "names")= chr [1:5] "1" "2" "3" "4" ...
#>  $ readerID    : Named chr [1:4] "1" "3" "4" "5"
#>   ..- attr(*, "names")= chr [1:4] "1" "3" "4" "5"
```

### Overview of the FROC data structure

* The `dataset` structure is a `list` variable with 8 members.
* Ratings of actually non-diseased regions are stored in the `NL` list member.
* Ratings of actually diseased regions are stored in the `LL` list member.

#### The `lesionNum` list member

* The `lesionNum` list member is an array of length 100, filled with integers ranging from 1 to 3, the latter being the maximum number of actul lesions (per case) in the dataset. The length of this array equals the number of diseased cases `K2`, 100 in the current example. For this dataset, the contents of `lesionNum` are shown below:


```r
dataset04$lesionNum[1:20]
#>  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
dataset04$lesionNum[21:40]
#>  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
dataset04$lesionNum[41:60]
#>  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 1 1 2
dataset04$lesionNum[61:80]
#>  [1] 1 1 1 1 1 1 1 1 2 2 1 1 1 2 2 2 2 2 2 1
dataset04$lesionNum[81:100]
#>  [1] 2 2 2 2 3 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3
```

* The above entries tell us that while most cases contain only one lesion each, some contain 2 or even 3 lesions per case.

#### The `lesionID` list member

* The `lesionID` list member is a `[100 x 3]` array. 
* Essentially it establishes a way of distinguishing between different lesions on a case by naming them, or what amounts to the same thing, by labeling them.
* The problem of distinguishing between different lesions on a case is peculiar to the FROC paradigm.
* With only one conceptual lesion per diseased case, the ROC paradigm does not face this problem.
* The second dimension of this array indicates that there is at least one diseased case that has three lesions.
    

```r
dataset04$lesionID[1:10,]
#>       [,1] [,2] [,3]
#>  [1,]    1 -Inf -Inf
#>  [2,]    1 -Inf -Inf
#>  [3,]    1 -Inf -Inf
#>  [4,]    1 -Inf -Inf
#>  [5,]    1 -Inf -Inf
#>  [6,]    1 -Inf -Inf
#>  [7,]    1 -Inf -Inf
#>  [8,]    1 -Inf -Inf
#>  [9,]    1 -Inf -Inf
#> [10,]    1 -Inf -Inf
```

* This indicates that the first ten diseased cases each contain one lesion.
* The lesion on case 1 is __labeled__ by the value 1. The `-Inf` denote missing values. Since there is only one lesion, the placeholders for possible 2 or 3 lesions (not present on this case, but needed to hold lesion labels in other cases) need to be filled with negative infinites.
* The previous paragraph may appear confusing. The following example may help clarify it.


```r
dataset04$lesionID[90:100,]
#>       [,1] [,2] [,3]
#>  [1,]    1    2 -Inf
#>  [2,]    1    2    3
#>  [3,]    1    2    3
#>  [4,]    1    2    3
#>  [5,]    1    2    3
#>  [6,]    1    2    3
#>  [7,]    1    2    3
#>  [8,]    1    2    3
#>  [9,]    1    2    3
#> [10,]    1    2    3
#> [11,]    1    2    3
```

* Now we see more interesting values.
* Diseeased case 90 has two lesions.
* These are labeled 1 and 2 respectively. 
* The key point is this: each lesion on a case has a _name_. The names are used  in the data file creation process.
* When an observer assigns a rating to a particular lesion on a casee, the experimenter needs to record this information correctly. 
* For example, if the lesion named "1" is marked and rated a particular value, this value needs to be entered in the spread-sheet as belonging to the lesion named "1". 
* As we saw for ROC data, the `TP/LL` worksheet has a `lesionID` column. Since the ROC paradigm does not allow multiple lesions per case, each diseased case conceptually containing one lesion, so the question of distinct lesion names of the same diseased case does not arise. 
* At least one investigator made the mistake of assuming the lesion name, i.e., the `lesionID` field had no meaning, and randomly assigned the rating to the lesions.

#### The `LesionWeight` list member
    
* The `LesionWeight` list member is also a `[100 x 3]` array filled with values that add up to unity for each case.
    

```r
dataset04$lesionWeight
#>             [,1]      [,2]      [,3]
#>   [1,] 1.0000000      -Inf      -Inf
#>   [2,] 1.0000000      -Inf      -Inf
#>   [3,] 1.0000000      -Inf      -Inf
#>   [4,] 1.0000000      -Inf      -Inf
#>   [5,] 1.0000000      -Inf      -Inf
#>   [6,] 1.0000000      -Inf      -Inf
#>   [7,] 1.0000000      -Inf      -Inf
#>   [8,] 1.0000000      -Inf      -Inf
#>   [9,] 1.0000000      -Inf      -Inf
#>  [10,] 1.0000000      -Inf      -Inf
#>  [11,] 1.0000000      -Inf      -Inf
#>  [12,] 1.0000000      -Inf      -Inf
#>  [13,] 1.0000000      -Inf      -Inf
#>  [14,] 1.0000000      -Inf      -Inf
#>  [15,] 1.0000000      -Inf      -Inf
#>  [16,] 1.0000000      -Inf      -Inf
#>  [17,] 1.0000000      -Inf      -Inf
#>  [18,] 1.0000000      -Inf      -Inf
#>  [19,] 1.0000000      -Inf      -Inf
#>  [20,] 1.0000000      -Inf      -Inf
#>  [21,] 1.0000000      -Inf      -Inf
#>  [22,] 1.0000000      -Inf      -Inf
#>  [23,] 1.0000000      -Inf      -Inf
#>  [24,] 1.0000000      -Inf      -Inf
#>  [25,] 1.0000000      -Inf      -Inf
#>  [26,] 1.0000000      -Inf      -Inf
#>  [27,] 1.0000000      -Inf      -Inf
#>  [28,] 1.0000000      -Inf      -Inf
#>  [29,] 1.0000000      -Inf      -Inf
#>  [30,] 1.0000000      -Inf      -Inf
#>  [31,] 1.0000000      -Inf      -Inf
#>  [32,] 1.0000000      -Inf      -Inf
#>  [33,] 1.0000000      -Inf      -Inf
#>  [34,] 1.0000000      -Inf      -Inf
#>  [35,] 1.0000000      -Inf      -Inf
#>  [36,] 1.0000000      -Inf      -Inf
#>  [37,] 1.0000000      -Inf      -Inf
#>  [38,] 1.0000000      -Inf      -Inf
#>  [39,] 1.0000000      -Inf      -Inf
#>  [40,] 1.0000000      -Inf      -Inf
#>  [41,] 1.0000000      -Inf      -Inf
#>  [42,] 1.0000000      -Inf      -Inf
#>  [43,] 1.0000000      -Inf      -Inf
#>  [44,] 1.0000000      -Inf      -Inf
#>  [45,] 1.0000000      -Inf      -Inf
#>  [46,] 1.0000000      -Inf      -Inf
#>  [47,] 1.0000000      -Inf      -Inf
#>  [48,] 1.0000000      -Inf      -Inf
#>  [49,] 1.0000000      -Inf      -Inf
#>  [50,] 1.0000000      -Inf      -Inf
#>  [51,] 1.0000000      -Inf      -Inf
#>  [52,] 1.0000000      -Inf      -Inf
#>  [53,] 1.0000000      -Inf      -Inf
#>  [54,] 1.0000000      -Inf      -Inf
#>  [55,] 1.0000000      -Inf      -Inf
#>  [56,] 0.5000000 0.5000000      -Inf
#>  [57,] 0.5000000 0.5000000      -Inf
#>  [58,] 1.0000000      -Inf      -Inf
#>  [59,] 1.0000000      -Inf      -Inf
#>  [60,] 0.5000000 0.5000000      -Inf
#>  [61,] 1.0000000      -Inf      -Inf
#>  [62,] 1.0000000      -Inf      -Inf
#>  [63,] 1.0000000      -Inf      -Inf
#>  [64,] 1.0000000      -Inf      -Inf
#>  [65,] 1.0000000      -Inf      -Inf
#>  [66,] 1.0000000      -Inf      -Inf
#>  [67,] 1.0000000      -Inf      -Inf
#>  [68,] 1.0000000      -Inf      -Inf
#>  [69,] 0.5000000 0.5000000      -Inf
#>  [70,] 0.5000000 0.5000000      -Inf
#>  [71,] 1.0000000      -Inf      -Inf
#>  [72,] 1.0000000      -Inf      -Inf
#>  [73,] 1.0000000      -Inf      -Inf
#>  [74,] 0.5000000 0.5000000      -Inf
#>  [75,] 0.5000000 0.5000000      -Inf
#>  [76,] 0.5000000 0.5000000      -Inf
#>  [77,] 0.5000000 0.5000000      -Inf
#>  [78,] 0.5000000 0.5000000      -Inf
#>  [79,] 0.5000000 0.5000000      -Inf
#>  [80,] 1.0000000      -Inf      -Inf
#>  [81,] 0.5000000 0.5000000      -Inf
#>  [82,] 0.5000000 0.5000000      -Inf
#>  [83,] 0.5000000 0.5000000      -Inf
#>  [84,] 0.5000000 0.5000000      -Inf
#>  [85,] 0.3333333 0.3333333 0.3333333
#>  [86,] 0.5000000 0.5000000      -Inf
#>  [87,] 0.5000000 0.5000000      -Inf
#>  [88,] 0.5000000 0.5000000      -Inf
#>  [89,] 0.5000000 0.5000000      -Inf
#>  [90,] 0.5000000 0.5000000      -Inf
#>  [91,] 0.3333333 0.3333333 0.3333333
#>  [92,] 0.3333333 0.3333333 0.3333333
#>  [93,] 0.3333333 0.3333333 0.3333333
#>  [94,] 0.3333333 0.3333333 0.3333333
#>  [95,] 0.3333333 0.3333333 0.3333333
#>  [96,] 0.3333333 0.3333333 0.3333333
#>  [97,] 0.3333333 0.3333333 0.3333333
#>  [98,] 0.3333333 0.3333333 0.3333333
#>  [99,] 0.3333333 0.3333333 0.3333333
#> [100,] 0.3333333 0.3333333 0.3333333
```
    
    + The `dataType` list member equals the string `"FROC"`, identifying it as an FROC dataset.
    + The `modalityID` list member is a string array identifying the names of the treatments (see below).
    + The `readerID` list member is a string array, identifying the names of the readers  (see below).

Examination of the output reveals that:

* The `dataset` structure is a list with 8 members.
* This is a 5-treatment 4-reader dataset (the lengths of the first and second dimensions, respectively, of the `NL` and `LL` arrays). The names of the treatments are in the `modalityID` array:
* Location-level ratings of non-diseased regions are stored in the `NL` list member of the dataset.
* Location-level ratings of diseased regions are stored in the `LL` list member of the dataset.  

### Details of the `modalityID` and `readerID` list members
* The names of the treatments are in the `modalityID` list member:

```r
attributes(dataset04$modalityID)
#> $names
#> [1] "1" "2" "3" "4" "5"
```

* For example, the name of the second treatment is `"2"`. The names can be longer strings, but use of very long string names may mess up the output formats of the analysis report. 

* The names of the readers are in the `readerID` array:


```r
attributes(dataset04$readerID)
#> $names
#> [1] "1" "3" "4" "5"
```

For example, the name of the second reader is `"3"`. Apparently reader `"2"` "dropped out" of the study. A similar caveat regarding long reader names applies.

### Details of the `NL` and `LL` list members
TBA
* For either `NL` or `LL` list members, the fourth dimension can have length greater than unity.
* For the `NL` list member this length is determined by the treatment-reader-case combination yielding the most `NL` marks per case.
* For the `LL` list member this length is determined by the case with the most true lesions.
* `dataset02` is a 2-treatment 5-reader dataset (the lengths of the first and second dimensions, respectively, of the `NL` and `LL` list members).


#### Numbers of non-diseased and diseased cases
* TBA

```r
length(dataset04$NL[1,1,,1])
#> [1] 200
length(dataset04$LL[1,1,,1])
#> [1] 100
```

* The third dimension of the `NL` array is the total number of __all__ cases, i.e., 200, and the third dimension of the `LL` array,  i.e., 100, is the total number of diseased cases.

* Subtracting the number of diseased cases from the number of all cases yields the number of non-diseased cases.

* Therefore, in this dataset, there are 100 diseased cases and 100 non-diseased cases.

### Why dimension the `NL` array for the total number of cases?
* Because, in addition to `LLs`, `NLs` are possible on diseased cases.
* Only `LLs` are possible on diseased cases.
* Only `NLs` are possible on non-diseased cases.
* The missing values are filled in with `-Inf`.

#### Ratings on a non-diseased case

* For treatment 1, reader 1 and case 1 (the first non-diseased case), the NL ratings are: 

```r
dataset04$NL[1,1,1,]
#> [1] -Inf -Inf -Inf -Inf -Inf -Inf -Inf
```

#### The meaning of a negative infinity rating
* Obviously, a real rating cannot be negative infinity ^[If an observer is so highly confident in the _absence_ of a localized lesion, he will simply _not mark_ the location in question; if he did, then, logically, he should mark _all_ areas in the image that are definitely not lesions; in the FROC paradigm only regions with a reasonable degree of suspicion are marked. The radiologist only wishes to draw attention to regions that are reasonably suspicious; the definition of "reasonable" is determined by clinical considerations.]. This value is reserved for __missing ratings__, and more generally, __missing marks__ ^[Since there is a one-to-one correspondence between marks and ratings.]. For example, since all values in the above code chunk are negative infinities, this means this treatment-reader-case combination did not yield any mark-rating pairs. This possibility, alluded to above, is only possible with FROC data. All other paradigms (ROC, LROC and ROI) yield at least one rating per case. 
* The length of the fourth dimension of the `NL` array is determined by that treatment-reader-case combination yielding the maximum number of `NLs`. Consider the following chunk:


```r
for (i in 1:5) 
  for (j in 1:4) 
    for (k in 1:200) 
      if (all(dataset04$NL[i,j,k,] != -Inf)) 
        cat(i, j, k, all(dataset04$NL[i,j,k,] != -Inf),"\n")
#> 5 4 192 TRUE
```

* This shows that the fourth dimension of the `NL` array has to be of length 7 because _one, and only reader_, specifically reader "4", made 7 `NL` marks on a diseased case in treatment "5"!

### Ratings on a diseased case
Unlike non-diseased cases, diseased cases can have both `NL` and `LL` ratings.

* For treatment 1, reader 1, case 51 (the 1st diseased case) the NL ratings are: 


```r
dataset04$NL[1,1,51,]
#> [1] -Inf -Inf -Inf -Inf -Inf -Inf -Inf
dataset04$lesionNum[1]
#> [1] 1
dataset04$LL[1,1,1,]
#> [1]    4 -Inf -Inf
mean(is.finite(dataset04$LL))
#> [1] 0.3043333
```

. There are only two finite values because this case has two ROI-level-abnormal regions, and 2 plus 2 makes for the assumed 4-regions per case. The corresponding `$lesionNum` field is 1.


```r
mean(is.finite(dataset04$NL[,,1:50,]))
#> [1] 0.05942857
dataset04$NL[1,1,51,]
#> [1] -Inf -Inf -Inf -Inf -Inf -Inf -Inf
dataset04$lesionNum[1]
#> [1] 1
dataset04$LL[1,1,1,]
#> [1]    4 -Inf -Inf
mean(is.finite(dataset04$LL))
#> [1] 0.3043333
```


```r
mean(is.finite(dataset04$NL[,,1:50,]))
#> [1] 0.05942857
dataset04$NL[1,1,51,]
#> [1] -Inf -Inf -Inf -Inf -Inf -Inf -Inf
dataset04$lesionNum[1]
#> [1] 1
dataset04$LL[1,1,1,]
#> [1]    4 -Inf -Inf
mean(is.finite(dataset04$LL))
#> [1] 0.3043333
```


* The ratings of the 2 ROI-level-abnormal ROIs on this case are 4. The mean rating over all ROI-level-abnormal ROIs is 3.6785323.  

```r
mean(is.finite(dataset04$NL[,,1:50,]))
#> [1] 0.05942857
dataset04$NL[1,1,51,]
#> [1] -Inf -Inf -Inf -Inf -Inf -Inf -Inf
dataset04$lesionNum[1]
#> [1] 1
dataset04$LL[1,1,1,]
#> [1]    4 -Inf -Inf
mean(is.finite(dataset04$LL))
#> [1] 0.3043333
```

## The FROC  Excel data file
An Excel file in JAFROC format containing simulated ROI data corresponding to `dataset04`, is included with the distribution. The first command (below) finds the location of the file and the second command reads it and saves it to a dataset object `ds`.  

```r
fileName <- system.file(
    "extdata", "includedFrocData.xlsx", package = "RJafroc", mustWork = TRUE)
ds <- DfReadDataFile(fileName)
ds$dataType
#> [1] "FROC"
```


### The FROC Excel file organization

The `DfReadDataFile` function automatically recognizes that this is an *ROI* dataset. Its structure is similar to the JAFROC format Excel file, with some important differences, noted below. It contains three worksheets: 

#### The Truth worksheet organization


#### The FP/NL worksheet organization


#### The TP/LL worksheet organization



![](images/FROC-TP-Truth-1.png){width=40%}![](images/FROC-TP-Truth-2.png){width=40%}
![](images/FROC-TP-Truth-3.png){width=40%}![](images/FROC-TP-Truth-4.png){width=40%}
![](images/FROC-TP-Truth-5.png){width=40%}


* The `Truth` worksheet - this indicates which cases are diseased and which are non-diseased and the number of ROI-level-abnormal region on each case.  
    + There are 50 normal cases (labeled 1-50) under column `CaseID` and 40 abnormal cases (labeled 51-90).  
    + The `LesionID` field for each normal case (e.g., `CaseID` = 1) is zero and there is one row per case. For abnormal cases, this field has a variable number of entries, ranging from 1 to 4. As an example, there are two rows for `CaseID` = 51 in the Excel file: one with `LesionID` = 2 and one with `LesionID` = 3.   
    + The `Weights` field is always zero (this field is not used in ROI analysis).  

![](images/ROI-FP-1.png){width=40%}
![](images/ROI-FP-2.png){width=40%}

* The `FP` (or `NL`)  worksheet - this lists the ratings of ROI-level-normal regions.  
    + For `ReaderID` = 1, `ModalityID` = 1 and `CaseID` = 1 there are 4 rows, corresponding to the 4 ROI-level-normal regions in this case. The corresponding ratings are . The pattern repeats for other treatments and readers, but the rating are, of course, different.  
    + Each `CaseID` is represented in the `FP` worksheet (a rare exception could occur if a case-level abnormal case has 4 abnormal regions).

![](images/ROI-TP-1.png){width=40%}

* The `TP` (or `LL`) worksheet - this lists the ratings of ROI-level-abnormal regions.  
    + Because normal cases generate TPs, one does not find any entry with `CaseID` = 1-50 in the `TP` worksheet.   
    + The lowest `CaseID` in the `TP` worksheet is 51, which corresponds to the first abnormal case.   
    + There are two entries for this case, corresponding to the two ROI-level-abnormal regions present in this case. Recall that corresponding to this `CaseID` in the `Truth` worksheet there were two entries with `LesionID` = 2 and 3. These must match the `LesionID`'s listed for this case in the `TP` worksheet. Complementing these two entries, in the `FP` worksheet for `CaseID` = 51, there are 2 entries corresponding to the two ROI-level-normal regions in this case.   
    + One should be satisfied that for each abnormal case the sum of the number of entries in the `TP` and `FP` worksheets is always 4.  
