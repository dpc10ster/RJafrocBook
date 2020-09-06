--- 
title: "The RJafroc Book"
author: "Dev P. Chakraborty, PhD"
date: "2020-09-06"
site: bookdown::bookdown_site
output: 
   bookdown::html_document2: default
   bookdown::pdf_document2: default
documentclass: book
bibliography: [packages.bib, myRefs.bib]
biblio-style: apalike
link-citations: yes
github-repo: dpc10ster/RJafrocBook
description: "Extended RJafroc documentation."
---





# Preface {-}
* This book is currently (as of August 2020) in preparation. Parts labeled TBA need to be updated on final revision.
* It is intended as an online update to my "physical" book [@RN2680]. Since its publication in 2017 the `RJafroc` package, on which the `R` code examples in the book depend, has evolved considerably, causing many of the examples to "break". This also gives me the opportunity to improve on the book and include additional material.
* The physical book chapters are labeled (book), to distinguish them from the chapters in this online book.

# A note on the online distribution mechanism of the book {-}
* In the hard-copy version of my book [@RN2680] the online distribution mechanism was `BitBucket`. 
* `BitBucket` allows code sharing within a _closed_ group of a few users (e.g., myself and a grad student). 
* Since the purpose of open-source code is to encourage collaborations, this was, in hindsight, an unfortunate choice. Moreover, as my experience with R-packages grew, it became apparent that the vast majority of R-packages are shared on `GitHub`, not `BitBucket`. 
* For these reasons I have switched to `GitHub`. All previous instructions pertaining to `BitBucket` are obsolete.
* In order to access `GitHub` material one needs to create a (free) `GitHub` account. 
* Go to [this link](https://github.com) and click on `Sign Up`.

# Contributing to this book {-}
* I appreciate constructive feedback on this document, e.g., corrections, comments, etc.  
* To do this raise an `Issue` on the `GitHub` [interface](https://github.com/dpc10ster/RJafrocBook). 
* Click on the `Issues` tab under `dpc10ster/RJafrocBook`, then click on `New issue`.
* When done this way, contributions from users automatically become part of the `GitHub` documentation/history of the book.

# Is this book relevant to you and what are the alternatives? {-}
* Diagnostic imaging system evaluation
* Detection
* Detection combined with localization
* Detection combined with localization and classificatin
* AI
* CV
* Alternatives




<!--chapter:end:index.Rmd-->

# NPV and PPV {#NpvPpv}



## Introduction {#NpvPpvIntro}
Sensitivity and specificity have desirable characteristics, insofar as they reward the observer for correct decisions on actually diseased and actually non-diseased cases, respectively, so these quantities are expected to be independent of disease prevalence. Stated simply, one is dividing by the relevant denominator, so increased numbers of non-diseased cases are balanced by a corresponding increased number of correct decisions on non-diseased cases, and likewise for diseased cases. However, radiologists interpret cases in a “mixed” situation where cases could be positive or negative for disease and disease prevalence plays a crucial role in their decision-making – this point will be clarified shortly. Therefore, a measure of performance that is desirable from the researcher's point of view is not necessarily desirable from the radiologist's point of view. It should be obvious that if most cases are non-diseased, i.e., disease prevalence is close to zero, specificity, being correct on non-diseased cases, is more important to the radiologist. Otherwise, the radiologist would figuratively be crying "wolf" most of the time. The radiologist who makes too many FPs would discover it from subsequent clinical audits or daily case conferences, which are held in most large imaging departments. There is a cost to unnecessary false positives – the cost of additional imaging and / or needle-biopsy to rule out cancer, not to mention the pain and emotional trauma inflicted on the patient. Conversely, if disease prevalence is high, then sensitivity, being correct on diseased cases, is more important to the radiologist. With intermediate disease prevalence a weighted average of sensitivity and specificity, where the weighting involves disease prevalence, is desirable from the radiologist's point of view. 

The radiologist is less interested in the normalized probability of a correct decision on non-diseased cases. Rather interest is in the probability that a patient diagnosed as non-diseased is actually non-diseased. The reader should notice how the two probability definitions are "turned around" - more on this below. Likewise, the radiologist is less interested in the normalized probability of correct decisions on diseased cases; rather interest is in the probability that a patient diagnosed as diseased is actually diseased. These are termed negative and positive predictive values, respectively, and denoted NPV and PPV


## Relevant equations
* These are from Chapter 2 of my book.
* PPV = Positive Predictive Value
* NPV = Negative Predictive Value
* Acc = Accuracy
* $P(D)$ is the disease prevalence and $P(!D)$ is the complement, i.e., $P(!D) = 1 - P(D)$. 

\begin{equation*} 
NPV =\frac{P(!D)(1-FPF)}{P(!D)(1-FPF)+P(D)(1-TPF)}
\end{equation*}

\begin{equation*} 
PPV =\frac{P(D)(TPF)}{P(D)(TPF)+P(!D)FPF}
\end{equation*}

\begin{equation*} 
Acc =P(!D)(1-FPF)+P(D)(TPF)
\end{equation*}


## Example calculation of PPV, NPV and accuracy
* Typical disease prevalence in the US in screening mammography is 0.005. 
* A typical operating point, for an expert mammographer, is FPF = 0.1, TPF = 0.8. What are NPV and PPV?


```r
# disease prevalence in 
# USA screening mammography
prevalence <- 0.005
FPF <- 0.1 # typical operating point
TPF <- 0.8 #        do:
specificity <- 1-FPF
sensitivity <- TPF
NPV <- (1-prevalence)*(specificity)/
  ((1-prevalence)*(specificity) + 
     prevalence*(1-sensitivity))
PPV <- prevalence*sensitivity/
  (prevalence*sensitivity + 
     (1-prevalence)*(1-specificity))
cat("NPV = ", NPV, "\nPPV = ", PPV, "\n")
#> NPV =  0.9988846 
#> PPV =  0.03864734
accuracy <-(1-prevalence)*
  (specificity)+(prevalence)*(sensitivity)
cat("accuracy = ", accuracy, "\n")
#> accuracy =  0.8995
```

* Line 3 initializes the variable `prevalence`, the disease prevalence. In other words, `prevalence <- 0.005` causes the value `0.005` to be assigned to the variable prevalence. **Do not use prevalence = 0.005 as an assignment statement**: it may work some of the time, but can cause problems when one least expects it. In `R` one does not need to worry about the type of variable - integer, float, double, or declaring variables before using them; this can lead to "sloppy" programming constructs but for the most part `R` behaves reasonably. Line 4 assigns `0.1` to `FPF` and line 5 assigns `0.8` to `TPF`. Lines 6 and 7 initialize the variables specificity and sensitivity, respectively. 

* Line 8 calculates `NPV`, using Eqn. (2.27) (all equations refer to my book) and line 9 calculates `PPV`, using Eqn. (2.28). Line 10 prints the values of `NPV` and `PPV`, with a helpful message. The `cat()` function stands for *concatenate and print the comma-separated components of the argument*. The `cat()` function starts by printing the string variable "NPV = ", then it encounters a comma, then the variable name `NPV`, so it prints the value of the variable. Then it encounters another comma, and the string "PPV = ", which it prints. Then it encounters another comma and the variable name `PPV`, so it prints the value of this variable. Finally, it encounters the last comma, and the string "\\n", which stand for a newline character, which positions any subsequent output to the next line; without it any subsequent print statements would appear on the same line, which is usually not the intent. Line 11 calculates accuracy, Eqn. (2.17) and the next line prints it. 

## Comments {#NpvPpvComments}
If a woman has a negative diagnosis, chances are very small that she has breast cancer: the probability that the radiologist is incorrect in the negative diagnosis is 1 - NPV = 0.0011154. Even is she has a positive diagnosis, the probability that she actually has cancer is still only 0.0386473. That is why following a positive screening diagnosis the woman is recalled for further imaging, and if that reveals cause for reasonable suspicion, then additional imaging is performed, perhaps augmented with a needle-biopsy to confirm actual disease status. If the biopsy turns out positive, only then is the woman referred for cancer therapy. Overall, accuracy is 0.8995. The numbers in this illustration are for expert radiologists. In practice there is wide variability in radiologist performance.


## PPV and NPV are irrelevant to laboratory tasks
According to the hierarchy of assessment methods described in Chapter 01, Table 1.1, PPV and NPV are level- 3 measurements, which are calculated from "live" interpretations. In the clinic, the radiologist adjusts the operating point to achieve a balance between sensitivity and specificity. The balance depends critically on the known disease prevalence. Based on geographical location and type of practice, the radiologist over time develops an idea of actual disease prevalence, or it can be found in various databases. For example, a breast-imaging clinic that specializes in imaging high-risk women will have higher disease prevalence than the general population and the radiologist is expected to err more on the side of reduced specificity because of the expected benefit of increased sensitivity. However, in the context of a laboratory study, where one uses enriched case sets, the concepts of NPV and PPV are meaningless. For example, it would be rather difficult to perform a laboratory study with 10,000 randomly sampled women, which would ensure about 50 actually diseased patients, which is large enough to get a reasonably precise estimate of sensitivity (estimating specificity is inherently more precise because most women are actually non-diseased). Rather, in a laboratory study one uses enriched data sets where the numbers of diseased-cases is much larger than in the general population, Eqn. (2.13). The radiologist cannot interpret these cases pretending that the actual prevalence is very low. Negative and positive predictive values, while they can be calculated from laboratory data, have very little, if any, clinical meanings, since they have no effect on radiologist thinking. As noted in Chapter 01 the whole purpose of level-3 measurements is to determine the effect on radiologist thinking. There are no diagnostic decisions riding on laboratory ROC interpretations of retrospectively acquired patient images. However, PPV and NPV do have clinical meanings when calculated from very large population based "live" studies. For example, the 2011 Fenton et al study sampled 684,956 women and used the results of "live" interpretations of their images. In contrast, laboratory ROC studies are typically conducted with 50-100 non-diseased and 50-100 diseased cases. A study using about 300 cases total would be considered a "large" ROC study.

## Summary{#NpvPpv-Summary}
## Discussion{#NpvPpv-Discussion}
## References {#NpvPpv-references}


<!--chapter:end:02-NpvPpv.Rmd-->

# ROC DATA FORMAT {#rocdataformat}




## Introduction {#rocdataformatIntro}
* The purpose of this chapter is to explain the data format of the input Excel file and to introduce the capabilities of the function `DfReadDataFile()`. Background on observer performance methods are in my book  [@RN2680].
* I will start with Receiver Operating Characteristic (ROC) data [@RN1766],  as this is by far the simplest paradigm.
* In the ROC paradigm the observer assigns a rating to each image. A rating is an ordered numeric label, and, in our convention, higher values represent greater certainty or **confidence level** for presence of disease. With human observers, a 5 (or 6) point rating scale is typically used, with 1 representing highest confidence for *absence* of disease and 5 (or 6) representing highest confidence for *presence* of disease. Intermediate values represent intermediate confidence levels for presence or absence of disease. 
* Note that location information associated with the disease, if applicable, is not collected. 
* There is no restriction to 5 or 6 ratings. With algorithmic observers, e.g., computer aided detection (CAD) algorithms, the rating could be a floating point number and have infinite precision. All that is required is that higher values correspond to greater confidence in presence of disease.

## Note to existing users
* The Excel file format has recently undergone changes resulting in 4 extra `list` members in the final created `dataset` object (i.e., 12 members instead of 8). 
* Code should run on the old format Excel files as the 4 extra list members are simply ignored. 
* Reasons for the change will become clearer in these chapters.
* Basically they are needed for generalization to other data collection paradigms instead of crossed, for example to the split-plot data acquisition paradigm, and for better data entry error control.


## The Excel data format {#rocExceldataformat}
* The Excel file has three worksheets. 
* These are named 
    + `Truth`, 
    + `NL` (or `FP`), 
    + `LL` (or `TP`).

## Illustrative toy file
* *Toy files* are artificial small datasets intended to illustrate essential features of the data format.  
* The examples shown in this chapter corresponds to Excel file `inst/extdata/toyFiles/ROC/rocCr.xlsx` in the project directory. 
* To view these files one needs to `clone` the source files from `GitHub`.

## The `Truth` worksheet {#rocExcelTruthdataformat}
* The `Truth` worksheet contains 6 columns: `CaseID`, `LesionID`, `Weight`, `ReaderID`, `ModalityID` and `Paradigm`. 
* For ROC data the first five columns contain as many rows as there are cases (images) in the dataset. 
* `CaseID`: unique integers, one per case, representing the cases in the dataset. 
* `LesionID`: integers 0 or 1, with each 0 representing a non-diseased case and each 1 representing a diseased case. 
* In the current toy dataset, the non-diseased cases are labeled `1`, `2` and `3`, while the diseased cases are labeled `70`, `71`, `72`, `73` and `74`. The values do not have to be consecutive integers; they need not be ordered; the only requirement is that they be **unique**.
* `Weight`: Not used for ROC data, a floating point value, typically filled in with 0 or 1. 
* `ReaderID`: a **comma-separated** listing of reader labels, each represented by a **unique string**, that have interpreted the case. In the example shown below each cell has the value `0, 1, 2, 3, 4` meaning that each of the readers, represented by the strings "0", "1", "2", "3" and "4", have interpreted all cases (hence the "crossed" design). **With reader names that could be confused with integers, each cell in this column has to be text formatted as otherwise Excel will not accept it.** [Try entering `0, 1, 2, 3, 4` in a numeric formatted Excel cell.]
* The reader names could just as well have been `Rdr0, Rdr1, Rdr2, Rdr3, Rdr4`. The only requirement is that they be unique strings.
* Look in in the `inst/extdata/toyFiles/ROC` directory for files `rocCrStrRdrsTrts.xlsx` and `rocCrStrRdrsNonUnique.xlsx` for examples of data files using longer strings for readers. The second file generates an error because the reader names are not unique. 
* `ModalityID`: a comma-separated listing of modalities (one or more modalities), each represented by a **unique string**, that are applied to each case. In the example each cell has the value `"0", "1"`. **With treatment names that could be confused with integers, each cell has to be text formatted as otherwise Excel will not accept it.**
* The treatment names could just as well have been `Trt0, Trt1`. Again, the only requirement is that they be unique strings.
* `Paradigm`: this column contains two cells, `ROC` and `crossed`. It informs the software that this is an ROC dataset, and the design is crossed, meaning each reader has interpreted each case in each modality (in statistical terminology: modality and reader factors are "crossed"). 
* There are 5 diseased cases in the dataset (the number of 1's in the `LesionID` column of the `Truth` worksheet). 
* There are 3 non-diseased cases in the dataset (the number of 0's in the `LesionID` column).
* There are 5 readers in the dataset (each cell in the `ReaderID` column contains the string `0, 1, 2, 3, 4`).
* There are 2 modalities in the dataset (each cell in the `ModalityID` column contains the string `0, 1`).

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/rocCrTruth} 

}

\caption{Truth worksheet for file rocCr.xlsx}(\#fig:showRocCrTruthSheet)
\end{figure}

## The structure of an ROC dataset
In the following code chunk the first statement retrieves the name of the data file, located in a hidden directory that one need not be concerned with. The second statement reads the file using the function `DfReadDataFile()` and saves it to object `x`. The third statement shows the structure of the dataset object `x`.


```r
rocCr <- system.file("extdata", "toyFiles/ROC/rocCr.xlsx",
                        package = "RJafroc", mustWork = TRUE)
x <- DfReadDataFile(rocCr, newExcelFileFormat = TRUE)
str(x)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1:2, 1:5, 1:8, 1] 1 3 2 3 2 2 1 2 3 2 ...
#>   ..$ LL   : num [1:2, 1:5, 1:5, 1] 5 5 5 5 5 5 5 5 5 5 ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: int [1:5] 1 1 1 1 1
#>   ..$ IDs    : num [1:5, 1] 1 1 1 1 1
#>   ..$ weights: num [1:5, 1] 1 1 1 1 1
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "rocCr"
#>   ..$ type         : chr "ROC"
#>   ..$ name         : logi NA
#>   ..$ truthTableStr: num [1:2, 1:5, 1:8, 1:2] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ design       : chr "FCTRL"
#>   ..$ modalityID   : Named chr [1:2] "0" "1"
#>   .. ..- attr(*, "names")= chr [1:2] "0" "1"
#>   ..$ readerID     : Named chr [1:5] "0" "1" "2" "3" ...
#>   .. ..- attr(*, "names")= chr [1:5] "0" "1" "2" "3" ...
```

* In the above code chunk flag `newExcelFileFormat` is set to `TRUE` as otherwise columns D - F in the `Truth` worksheet are ignored and the dataset is assumed to be crossed, with `dataType` automatically determined from the contents of the FP and TP worksheets. 
* Flag `newExcelFileFormat = FALSE` is for compatibility with older JAFROC format Excel files, which did not have these columns in the `Truth` worksheet. Its usage is deprecated.
* The dataset object `x` is a `list` variable with 3 members. 
* The `x$NL` member, with dimension [2, 5, 8, 1], contains the ratings of normal cases. The extra values in the third dimension, filled with `NAs`, are needed for compatibility with FROC datasets, as unlike ROC, false positives are possible on diseased cases.
* The `x$LL`, with dimension [2, 5, 5, 1], contains the ratings of abnormal cases.
* The `x$lesionVector` member is a vector with 5 ones representing the 5 diseased cases in the dataset. 
* The `x$lesionID` member is an array with 5 ones.
* The `x$lesionWeight` member is an array with 5 ones.
* The `lesionVector`, `lesionID` and `lesionWeight` members are not used for ROC datasets. They are there for compatibility with FROC datasets.
* The `dataType` member indicates that this is an `ROC` dataset. 
* The `x$modalityID` member is a vector with two elements `"0"` and `"1"`, naming the two modalities. 
* The `x$readerID` member is a vector with five elements  `"0"`, `"1"`, `"2"`, `"3"` and `"4"`, naming the five readers. 
* The `x$design` member is ; specifies the dataset design, which is "CROSSED".
* The `x$normalCases` member lists the integer names of the normal cases, . 
* The `x$abnormalCases` member lists the integer names of the abnormal cases, . 
* The `x$truthTableStr` member quantifies the structure of the dataset, as explained in prior chapters.

## The false positive (FP) ratings {#rocExcelFPdataformat}
These are found in the `FP` or `NL` worksheet, see below.

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/rocCrFp} 

}

\caption{FP worksheet for file rocCr.xlsx}(\#fig:showRocCrFpSheet)
\end{figure}

* It consists of 4 columns, each of length 30 (= # of modalities times number of readers times number of non-diseased cases). 
* `ReaderID`: the reader labels: `0`, `1`, `2`, `3` and `4`. Each reader label occurs 6 times (= # of modalities times number of non-diseased cases). 
* `ModalityID`: the modality or treatment labels: `0` and `1`. Each label occurs 15 times (= # of readers times number of non-diseased cases). 
* `CaseID`: the case labels for non-diseased cases: `1`, `2` and `3`. Each label occurs 10 times (= # of modalities times # of readers). 
* The label of a diseased case cannot occur in the FP worksheet. If it does the software generates an error. 
* `FP_Rating`: the floating point ratings of non-diseased cases. Each row of this worksheet contains a rating corresponding to the values of `ReaderID`, `ModalityID` and `CaseID` for that row.  

## The true positive (TP) ratings {#rocExcelTPdataformat}
These are found in the `TP` or `LL` worksheet, see below.

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/rocCrTp} 

}

\caption{TP worksheet for file rocCr.xlsx}(\#fig:showRocCrTpSheet)
\end{figure}

* It consists of 5 columns, each of length 50 (= # of modalities times number of readers times number of diseased cases). 
* `ReaderID`: the reader labels: `0`, `1`, `2`, `3` and `4`. Each reader label occurs 10 times (= # of modalities times number of diseased cases). 
* `ModalityID`: the modality or treatment labels: `0` and `1`. Each label occurs 25 times (= # of readers times number of diseased cases). 
* `LesionID`: For an ROC dataset this column contains fifty 1's (each diseased case has one lesion). 
* `CaseID`: the case labels for non-diseased cases: `70`, `71`, `72`, `73` and `74`. Each label occurs 10 times (= # of modalities times # of readers). The label of a non-diseased case cannot occur in the TP worksheet. 
* `TP_Rating`: the floating point ratings of diseased cases. Each row of this worksheet contains a rating corresponding to the values of `ReaderID`, `ModalityID`, `LesionID` and `CaseID` for that row.   

## Correspondence between `NL` member of dataset and the `FP` worksheet
* The list member `x$NL` is an array with `dim = c(2,5,8,1)`. 
    + The first dimension (2) comes from the number of modalities. 
    + The second dimension (5) comes from the number of readers. 
    + The third dimension (8) comes from the **total** number of cases. 
    + The fourth dimension is alway 1 for an ROC dataset. 
* The value of `x$NL[1,5,2,1]`, i.e., , corresponds to row 15 of the FP table, i.e., to `ModalityID` = 0, `ReaderID` = 4 and `CaseID` = 2.
* The value of `x$NL[2,3,2,1]`, i.e., , corresponds to row 24 of the FP table, i.e., to `ModalityID` 1, `ReaderID` 2 and `CaseID` 2.
* All values for case index > 3 are `-Inf`. For example the value of `x$NL[2,3,4,1]` is `-Inf`. This is because there are only 3 non-diseased cases. The extra length is needed for compatibility with FROC datasets.

## Correspondence between `LL` member of dataset and the `TP` worksheet
* The list member `x$LL` is an array with `dim = c(2,5,5,1)`. 
    + The first dimension (2) comes from the number of modalities. 
    + The second dimension (5) comes from the number of readers. 
    + The third dimension (5) comes from the number of diseased cases. 
    + The fourth dimension is alway 1 for an ROC dataset. 

* The value of `x$LL[1,1,5,1]`, i.e., , corresponds to row 6 of the TP table, i.e., to `ModalityID` = 0, `ReaderID` = 0 and `CaseID` = 74.
* The value of `x$LL[1,2,2,1]`, i.e., , corresponds to row 8 of the TP table, i.e., to `ModalityID` = 0, `ReaderID` = 1 and `CaseID` = 71.
* There are no -Inf values in `x$LL`: `any(x$LL == -Inf)` = FALSE.

## Correspondence using the `which` function 
* Converting from **names** to **subscripts** (indicating position in an array) can be confusing. 
* The following example uses the `which` function to help out.
* The first line says that the `abnormalCase` named 70 corresponds to subscript 1 in the LL array case dimension. 
* The second line prints the NL rating for `modalityID` = 0, `readerID` = 1 and `normalCases` = 1.
* The third line prints the LL rating for `modalityID` = 0, `readerID` = 1 and `abnormalCases` = 70.
* The last line shows what happens if one enters an invalid value for name; the result is a `numeric(0)`.
* Note that in each of these examples, the last dimension is 1 because we are dealing with an ROC dataset. 
* The reader is encouraged to examine the correspondence between the NL and LL ratings and the Excel file using this method.


```r
which(x$abnormalCases == 70)
#> integer(0)
x$NL[which(x$modalityID == "0"),which(x$readerID == "1"),which(x$normalCases == 1),1]
#> NULL
x$LL[which(x$modalityID == "0"),which(x$readerID == "1"),which(x$abnormalCases == 70),1]
#> NULL
x$LL[which(x$modalityID == "a"),which(x$readerID == "1"),which(x$abnormalCases == 70),1]
#> NULL
```


## Summary{#rocdataformat-Summary}
## Discussion{#rocdataformat-Discussion}
## References {#rocdataformat-references}




<!--chapter:end:02-roc-data-format.Rmd-->

# FROC data format {#frocdataformat}



## Purpose
* Explain the data format of the input Excel file for FROC datasets. 
* Explain the format of the FROC dataset.
* Explain the lesion distribution array returned by `UtilLesionDistr()`.
* Explain the lesion weights array returned by `UtilLesionWeightsDistr()`.
* Details on the FROC paradigm are in my book.

## Introduction {#frocdataformatIntro}
* See my book @RN2680 for full details.
* In the Free-response Receiver Operating Characteristic (FROC) paradigm [@RN761] the observer searches each case for signs of **localized disease** and marks and rates localized regions that are sufficiently suspicious for disease presence. 
* FROC data consists of **mark-rating pairs**, where each mark is a localized-region that was considered sufficiently suspicious for presence of a localized lesion and the rating is the corresponding confidence level. 
* By adopting a proximity criterion, each mark is classified by the investigator as a lesion localization (`LL`) - if it is close to a real lesion - or a non-lesion localization (`NL`) otherwise. 
* The observer assigns a rating to each region. The rating, as in the ROC paradigm, can be an integer or quasi-continuous (e.g., 0 – 100), or a floating point value, as long as higher numbers represent greater confidence in presence of a lesion at the indicated region.

## The Excel data format {#frocExceldataformat}
The Excel file has three worsheets. These are named `Truth`, `NL` or `FP` and `LL` or `TP`. 

## The `Truth` worksheet {#frocExcelTruthdataformat}

The `Truth` worksheet contains 6 columns: `CaseID`, `LesionID`, `Weight`, `ReaderID`, `ModalityID` and `Paradigm`. 

* Since a diseased case may have more than one lesion, the first five columns contain **at least** as many rows as there are cases (images) in the dataset. 
* `CaseID`: unique **integers**, one per case, representing the cases in the dataset. 
* `LesionID`: integers 0, 1, 2, etc., with each 0 representing a non-diseased case, 1 representing the *first* lesion on a diseased case, 2 representing the second lesion on a diseased case, if present, and so on. 
* The non-diseased cases are labeled `1`, `2` and `3`, while the diseased cases are labeled `70`, `71`, `72`, `73` and `74`.
* There are 3 non-diseased cases in the dataset (the number of 0's in the `LesionID` column).
* There are 5 diseased cases in the dataset (the number of 1's in the `LesionID` column of the `Truth` worksheet). 
* There are 3 readers in the dataset (each cell in the `ReaderID` column contains `0, 1, 2`).
* There are 2 modalities in the dataset (each cell in the `ModalityID` column contains `0, 1`).
* `Weight`: floating point; 0, for each non-diseased case, or values for each diseased case that add up to unity.  
* Diseased case `70` has two lesions, with `LesionID`s 1 and 2, and weights 0.3 and 0.7. Diseased case `71` has one lesion, with `LesionID` = 1, and `Weight` = 1. Diseased case `72` has three lesions, with `LesionID`s 1, 2 and 3 and weights 1/3 each. Diseased case `73` has two lesions, with `LesionID`s 1, and 2 and weights 0.1 and 0.9. Diseased case `74` has one lesion, with `LesionID` = 1 and `Weight` = 1.
* `ReaderID`: a comma-separated listing of readers, each represented by a unique **integer**, that have interpreted the case. In the example shown below each cell has the value `0, 1, 2`. **Each cell has to be text formatted. Otherwise Excel will not accept it.**
* `ModalityID`: a comma-separated listing of modalities (or treatments), each represented by a unique **integer**, that apply to each case. In the example each cell has the value `0, 1`. **Each cell has to be text formatted.**
* `Paradigm`: In the example shown below, the contents are `FROC` and `crossed`. It informs the software that this is an `FROC` dataset and the design is "crossed", as in **TBA chapter xx**.

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/frocCrTruth} 

}

\caption{Truth worksheet for file inst/extdata/toyFiles/FROC/frocCr.xlsx}(\#fig:frocCrTruth)
\end{figure}


## The structure of an FROC dataset
The example shown above corresponds to Excel file `inst/extdata/toyFiles/FROC/frocCr.xlsx` in the project directory. 


```r
frocCr <- system.file("extdata", "toyFiles/FROC/frocCr.xlsx",
                        package = "RJafroc", mustWork = TRUE)
x <- DfReadDataFile(frocCr, newExcelFileFormat = TRUE)
str(x)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1:2, 1:3, 1:8, 1:2] 1.02 2.89 2.21 3.01 2.14 ...
#>   ..$ LL   : num [1:2, 1:3, 1:5, 1:3] 5.28 5.2 5.14 4.77 4.66 4.87 3.01 3.27 3.31 3.19 ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: int [1:5] 2 1 3 2 1
#>   ..$ IDs    : num [1:5, 1:3] 1 1 1 1 1 ...
#>   ..$ weights: num [1:5, 1:3] 0.3 1 0.333 0.1 1 ...
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "frocCr"
#>   ..$ type         : chr "FROC"
#>   ..$ name         : logi NA
#>   ..$ truthTableStr: num [1:2, 1:3, 1:8, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ design       : chr "FCTRL"
#>   ..$ modalityID   : Named chr [1:2] "0" "1"
#>   .. ..- attr(*, "names")= chr [1:2] "0" "1"
#>   ..$ readerID     : Named chr [1:3] "0" "1" "2"
#>   .. ..- attr(*, "names")= chr [1:3] "0" "1" "2"
```

* This follows the general description in **TBA chapter xx**. The differences are described below.
* The `x$dataType` member indicates that this is an `FROC` dataset. 
* The `x$lesionVector` member is a vector whose contents reflect the number of lesions in each diseased case, i.e.,  in the current example.
* The `x$lesionID` member indicates the labeling of the lesions in each diseased case.


```r
x$lesionID
#> NULL
```

* This shows that the lesions on the first diseased case are labeled 1 and 2. The `-Inf` is a filler used to denote a missing value. The second diseased case has one lesion labeled 1. The third diseased case has three lesions labeled 1, 2 and 3, etc.
* The `lesionWeight` member is the clinical importance of each lesion. Lacking specific clinical reasons, the lesions should be equally weighted; this is *not* true for this toy dataset.


```r
x$lesionWeight
#> NULL
```

* The first diseased case has two lesions, the first has weight 0.3 and the second has weight 0.7. The second diseased case has one lesion with weight 1.The third diseased case has three equally weighted lesions, each with weight 1/3. Etc.

## The false positive (FP) ratings
These are found in the `FP` or `NL` worksheet, see below.
\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/frocCrNL} 

}

\caption{Fig. 2: FP/NL worksheet for file inst/extdata/toyFiles/FROC/frocCr.xlsx}(\#fig:frocCrNL)
\end{figure}

* It consists of 4 columns, of equal length. **The common length is unpredictable.** It could be zero if the dataset has no NL marks (a distinct possibility if the lesions are very easy to find and the modality and/or observer has high performance). All one knows is that the common length is an integer greater than or equal to zero.
* In the example dataset, the common length is 0.
* `ReaderID`: the reader labels: these must be `0`, `1`, or `2`, as declared in the `Truth` worksheet. 
* `ModalityID`: the modality labels: must be `0` or `1`, as declared in the `Truth` worksheet. 
* `CaseID`: the labels of cases with `NL` marks. In the FROC paradigm, `NL` events can occur on non-diseased **and** diseased cases. 
* `FP_Rating`: the floating point ratings of `NL` marks. Each row of this worksheet yields a rating corresponding to the values of `ReaderID`, `ModalityID` and `CaseID` for that row.
* For `ModalityID` 0, `ReaderID` 0 and `CaseID` 1 (the first non-diseased case declared in the `Truth` worksheet), there is a single `NL` mark that was rated , corresponding to row 2 of the `FP` worksheet.
* Diseased cases with `NL` marks are also declared in the `FP` worksheet. Some examples are seen at rows 15, 16 and 21-23 of the `FP` worksheet. 
* Rows 21 and 22 show that `caseID` = 71 got two `NL` marks, rated . 
* That this is the *only* case with two marks determines the length of the fourth dimension of the `x$NL` list member, 0 in the current example. Absent this case, the length would have been one.
* In general, the case with the most `NL` marks determines the length of the fourth dimension of the `x$NL` list member.
* The reader should convince oneself that the ratings in `x$NL` reflect the contents of the `FP` worksheet.

## The true positive (TP) ratings
These are found in the `TP` or `LL` worksheet, see below.

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/frocCrLL} 

}

\caption{Fig. 3: TP/LL worksheet for file inst/extdata/toyFiles/FROC/frocCr.xlsx}(\#fig:frocCrLL)
\end{figure}

* This worksheet can only have diseased cases. The presence of a non-diseased case in this worksheet will generate an error.
* The common vertical length, 31 in this example, is a-priori unpredictable. Given the structure of the `Truth` worsheet for this dataset, the maximum length would be 9 times 2 times 3, assuming every lesion is marked for each modality, reader and diseased case. The 9 comes from the total number of non-zero entries in the `LesionID` column of the `Truth` worksheet.
* The fact that the length is smaller than the maximum length means that there are combinations of modality, reader and diseased cases on which some lesions were not marked.
* As an example, the first lesion in `CaseID` equal to `70` was marked (and rated ) in `ModalityID` `0` and `ReaderID` `0`. 
* The length of the fourth dimension of the `x$LL` list member, 0 in the present example, is determined by the diseased case with the most lesions in the `Truth` worksheet.
* The reader should convince oneself that the ratings in `x$LL` reflect the contents of the `TP` worksheet.

## On the distribution of numbers of lesions in abnormal cases  
* Consider a much larger dataset, `dataset11`, with structure as shown below:


```r
x <- dataset11
str(x)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1:4, 1:5, 1:158, 1:4] -Inf -Inf -Inf -Inf -Inf ...
#>   ..$ LL   : num [1:4, 1:5, 1:115, 1:20] -Inf -Inf -Inf -Inf -Inf ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: int [1:115] 6 4 7 1 3 3 3 8 11 2 ...
#>   ..$ IDs    : num [1:115, 1:20] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ weights: num [1:115, 1:20] 0.167 0.25 0.143 1 0.333 ...
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "dataset11"
#>   ..$ type         : chr "FROC"
#>   ..$ name         : chr "DOBBINS-1"
#>   ..$ truthTableStr: num [1:4, 1:5, 1:158, 1:21] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ design       : chr "FCTRL"
#>   ..$ modalityID   : Named chr [1:4] "1" "2" "3" "4"
#>   .. ..- attr(*, "names")= chr [1:4] "1" "2" "3" "4"
#>   ..$ readerID     : Named chr [1:5] "1" "2" "3" "4" ...
#>   .. ..- attr(*, "names")= chr [1:5] "1" "2" "3" "4" ...
```

* Focus for now in the 115 abnormal cases. 
* The numbers of lesions in these cases is contained in `x$lesionVector`.


```r
x$lesions$perCase
#>   [1]  6  4  7  1  3  3  3  8 11  2  4  6  2 16  5  2  8  3  4  7 11  1  4  3  4
#>  [26]  4  7  3  2  5  2  2  7  6  6  4 10 20 12  6  4  7 12  5  1  1  5  1  2  8
#>  [51]  3  1  2  2  3  2  8 16 10  1  2  2  6  3  2  2  4  6 10 11  1  2  6  2  4
#>  [76]  5  2  9  6  6  8  3  8  7  1  1  6  3  2  1  9  8  8  2  2 12  1  1  1  1
#> [101]  1  3  1  2  2  1  1  1  1  3  1  1  1  2  1
```

* For example, the first abnormal case contains 6 lesions, the second contains 4 lesions, the third contains 7 lesions, etc. and the last abnormal case contains 1 lesion.
* To get an idea of the distribution of the numbers of lesions per abnormal cases, one could interrogate this vector as shown below using the `which()` function:


```r
for (el in 1:max(x$lesions$perCase)) cat(
  "abnormal cases with", el, "lesions = ", 
  length(which(x$lesionVector == el)), "\n")
#> abnormal cases with 1 lesions =  0 
#> abnormal cases with 2 lesions =  0 
#> abnormal cases with 3 lesions =  0 
#> abnormal cases with 4 lesions =  0 
#> abnormal cases with 5 lesions =  0 
#> abnormal cases with 6 lesions =  0 
#> abnormal cases with 7 lesions =  0 
#> abnormal cases with 8 lesions =  0 
#> abnormal cases with 9 lesions =  0 
#> abnormal cases with 10 lesions =  0 
#> abnormal cases with 11 lesions =  0 
#> abnormal cases with 12 lesions =  0 
#> abnormal cases with 13 lesions =  0 
#> abnormal cases with 14 lesions =  0 
#> abnormal cases with 15 lesions =  0 
#> abnormal cases with 16 lesions =  0 
#> abnormal cases with 17 lesions =  0 
#> abnormal cases with 18 lesions =  0 
#> abnormal cases with 19 lesions =  0 
#> abnormal cases with 20 lesions =  0
```

* This tells us that 25 cases contain 1 lesion
* Likewise, 23 cases contain 2 lesions
* Etc.

### Definition of `lesDistr` array
* Let us ask what is the fraction of (abnormal) cases with 1 lesion, 2 lesions etc.


```r
for (el in 1:max(x$lesions$perCase)) cat("fraction of abnormal cases with", el, "lesions = ", 
                                              length(which(x$lesions$perCase == el))/length(x$ratings$LL[1,1,,1]), "\n")
#> fraction of abnormal cases with 1 lesions =  0.2173913 
#> fraction of abnormal cases with 2 lesions =  0.2 
#> fraction of abnormal cases with 3 lesions =  0.1130435 
#> fraction of abnormal cases with 4 lesions =  0.08695652 
#> fraction of abnormal cases with 5 lesions =  0.04347826 
#> fraction of abnormal cases with 6 lesions =  0.09565217 
#> fraction of abnormal cases with 7 lesions =  0.05217391 
#> fraction of abnormal cases with 8 lesions =  0.06956522 
#> fraction of abnormal cases with 9 lesions =  0.0173913 
#> fraction of abnormal cases with 10 lesions =  0.02608696 
#> fraction of abnormal cases with 11 lesions =  0.02608696 
#> fraction of abnormal cases with 12 lesions =  0.02608696 
#> fraction of abnormal cases with 13 lesions =  0 
#> fraction of abnormal cases with 14 lesions =  0 
#> fraction of abnormal cases with 15 lesions =  0 
#> fraction of abnormal cases with 16 lesions =  0.0173913 
#> fraction of abnormal cases with 17 lesions =  0 
#> fraction of abnormal cases with 18 lesions =  0 
#> fraction of abnormal cases with 19 lesions =  0 
#> fraction of abnormal cases with 20 lesions =  0.008695652
```

* This tells us that fraction 0.217 of (abnormal) cases contain 1 lesion
* And fraction 0.2 of (abnormal) cases contain 2 lesions
* Etc.
* This information is contained the the `lesDistr` array
* It is coded in the `Utility` function `UtilLesionDistr()` 


```r
lesDistr <- UtilLesionDistr(x)
lesDistr
#>       [,1]        [,2]
#>  [1,]    1 0.217391304
#>  [2,]    2 0.200000000
#>  [3,]    3 0.113043478
#>  [4,]    4 0.086956522
#>  [5,]    5 0.043478261
#>  [6,]    6 0.095652174
#>  [7,]    7 0.052173913
#>  [8,]    8 0.069565217
#>  [9,]    9 0.017391304
#> [10,]   10 0.026086957
#> [11,]   11 0.026086957
#> [12,]   12 0.026086957
#> [13,]   16 0.017391304
#> [14,]   20 0.008695652
```

* The `UtilLesionDistr()` function returns an array with two columns and number of rows equal to the number of distinct values of lesions per case.
* The first column contains the number of distinct values of lesions per case, 14 in the current example.
* The second column contains the fraction of diseased cases with the number of lesions indicated in the first column.
* The second column must sum to unity


```r
sum(UtilLesionDistr(x)[,2])
#> [1] 1
```

* The lesion distribution array will come in handy when it comes to predicting the operating characteristics from using the Radiological Search Model (RSM), as detailed in Chapter 17 of my book.


## Definition of `lesWghtDistr` array
* This is returned by `UtilLesionWeightsDistr()`.
* This contains the same number of rows as `lesDistr`.
* The number of columns is one plus the number of rows as `lesDistr`.
* The first column contains the number of distinct values of lesions per case, 14 in the current example.
* The second column contains the weights of cases with number of lesions per case corresponding to row 1.
* The third column contains the weights of cases with number of lesions per case corresponding to row 2.
* Etc.
* Missing values are filled with `-Inf`.


```r
lesWghtDistr <- UtilLesionWeightsDistr(x)
cat("dim(lesDistr) =", dim(lesDistr),"\n")
#> dim(lesDistr) = 14 2
cat("dim(lesWghtDistr) =", dim(lesWghtDistr),"\n")
#> dim(lesWghtDistr) = 14 21
cat("lesWghtDistr = \n\n")
#> lesWghtDistr =
lesWghtDistr
#>       [,1]       [,2]       [,3]       [,4]       [,5]       [,6]       [,7]
#>  [1,]    1 1.00000000       -Inf       -Inf       -Inf       -Inf       -Inf
#>  [2,]    2 0.50000000 0.50000000       -Inf       -Inf       -Inf       -Inf
#>  [3,]    3 0.33333333 0.33333333 0.33333333       -Inf       -Inf       -Inf
#>  [4,]    4 0.25000000 0.25000000 0.25000000 0.25000000       -Inf       -Inf
#>  [5,]    5 0.20000000 0.20000000 0.20000000 0.20000000 0.20000000       -Inf
#>  [6,]    6 0.16666667 0.16666667 0.16666667 0.16666667 0.16666667 0.16666667
#>  [7,]    7 0.14285714 0.14285714 0.14285714 0.14285714 0.14285714 0.14285714
#>  [8,]    8 0.12500000 0.12500000 0.12500000 0.12500000 0.12500000 0.12500000
#>  [9,]    9 0.11111111 0.11111111 0.11111111 0.11111111 0.11111111 0.11111111
#> [10,]   10 0.10000000 0.10000000 0.10000000 0.10000000 0.10000000 0.10000000
#> [11,]   11 0.09090909 0.09090909 0.09090909 0.09090909 0.09090909 0.09090909
#> [12,]   12 0.08333333 0.08333333 0.08333333 0.08333333 0.08333333 0.08333333
#> [13,]   16 0.06250000 0.06250000 0.06250000 0.06250000 0.06250000 0.06250000
#> [14,]   20 0.05000000 0.05000000 0.05000000 0.05000000 0.05000000 0.05000000
#>             [,8]       [,9]      [,10]      [,11]      [,12]      [,13]  [,14]
#>  [1,]       -Inf       -Inf       -Inf       -Inf       -Inf       -Inf   -Inf
#>  [2,]       -Inf       -Inf       -Inf       -Inf       -Inf       -Inf   -Inf
#>  [3,]       -Inf       -Inf       -Inf       -Inf       -Inf       -Inf   -Inf
#>  [4,]       -Inf       -Inf       -Inf       -Inf       -Inf       -Inf   -Inf
#>  [5,]       -Inf       -Inf       -Inf       -Inf       -Inf       -Inf   -Inf
#>  [6,]       -Inf       -Inf       -Inf       -Inf       -Inf       -Inf   -Inf
#>  [7,] 0.14285714       -Inf       -Inf       -Inf       -Inf       -Inf   -Inf
#>  [8,] 0.12500000 0.12500000       -Inf       -Inf       -Inf       -Inf   -Inf
#>  [9,] 0.11111111 0.11111111 0.11111111       -Inf       -Inf       -Inf   -Inf
#> [10,] 0.10000000 0.10000000 0.10000000 0.10000000       -Inf       -Inf   -Inf
#> [11,] 0.09090909 0.09090909 0.09090909 0.09090909 0.09090909       -Inf   -Inf
#> [12,] 0.08333333 0.08333333 0.08333333 0.08333333 0.08333333 0.08333333   -Inf
#> [13,] 0.06250000 0.06250000 0.06250000 0.06250000 0.06250000 0.06250000 0.0625
#> [14,] 0.05000000 0.05000000 0.05000000 0.05000000 0.05000000 0.05000000 0.0500
#>        [,15]  [,16]  [,17] [,18] [,19] [,20] [,21]
#>  [1,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#>  [2,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#>  [3,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#>  [4,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#>  [5,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#>  [6,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#>  [7,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#>  [8,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#>  [9,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#> [10,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#> [11,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#> [12,]   -Inf   -Inf   -Inf  -Inf  -Inf  -Inf  -Inf
#> [13,] 0.0625 0.0625 0.0625  -Inf  -Inf  -Inf  -Inf
#> [14,] 0.0500 0.0500 0.0500  0.05  0.05  0.05  0.05
```

* Row 3 corresponds to 3 lesions per case and the weights are 1/3, 1/3 and 1/3.
* Row 13 corresponds to 16 lesions per case and the weights are 0.06250000, 0.06250000, ..., repeated 13 times.
* Note that the number of rows is less than the maximum number of lesions per case (20).
* This is because some configurations of lesions per case (e.g., cases with 13 lesions per case) do not occur in this dataset. 

## Summary{#frocdataformat-Summary}
* The FROC dataset has far less regularity in structure as compared to an ROC dataset.
* The length of the first dimension of either `x$NL` or `x$LL` list members is the total number of modalities, 2 in the current example.
* The length of the second dimension of either `x$NL` or `x$LL` list members is the total number of readers, 3 in the current example.
* The length of the third dimension of `x$NL` is the total number of cases, 8 in the current example. The first three positions account for `NL` marks on non-diseased cases and the remaining 5 positions account for `NL` marks on diseased cases.
* The length of the third dimension of `x$LL` is the total number of diseased cases, 5 in the current example. 
* The length of the fourth dimension of `x$NL` is determined by the case (diseased or non-diseased) with the most `NL` marks, 2 in the current example.
* The length of the fourth dimension of `x$LL` is determined by the diseased case with the most lesions, 3 in the current example.

## Discussion{#frocdataformat-Discussion}
## References {#frocdataformat-references}


<!--chapter:end:03-froc-data-format.Rmd-->

# Modeling the Binary Task {#modelingBinaryTask}




## Introduction {#modelingBinaryTaskIntro}
Chapter 02 introduced measures of performance associated with the binary decision task. Described in this chapter is a 2-parameter statistical model for the binary task, in other words it shows how one can predict quantities like sensitivity and specificity based on the values of the parameters of a statistical model. It introduces the fundamental concepts of a decision variable and a decision threshold (the latter is one of the parameters of the statistical model) that pervade this book, and shows how the decision threshold can be altered by varying experimental conditions. The receiver-operating characteristic (ROC) plot is introduced which shows how the dependence of sensitivity and specificity on the decision threshold is exploited by a measure of performance that is independent of decision threshold, namely the area AUC under the ROC curve. AUC turns out to be related to the other parameter of the model. 

The dependence of variability of the operating point on the numbers of cases is explored, introducing the concept of random sampling and how the results become more stable with larger numbers of cases, or larger sample sizes. These are perhaps intuitively obvious concepts but it is important to see them demonstrated. Formulae for 95% confidence intervals for estimates of sensitivity and specificity are derived and the calculations are shown explicitly.

## The equal-variance binormal model
* $N(\mu,\sigma^2)$ is the normal distribution with mean $\mu$ and variance $\sigma^2$.
* The Z-samples for non-diseased cases are distributed $N(0,1)$. 
* The Z-samples for diseased cases are distributed $N(\mu,1)$. 
* A case is diagnosed as diseased if its Z-sample ≥ a constant threshold $\zeta$, and non-diseased otherwise.

## Definitions and relevant formulae
* pdf = probability density function, denoted $\phi$.
* cdf = cumulative distribution function, denoted $\Phi$.

\begin{equation*} 
\phi\left ( z|\mu,\sigma \right )=\frac{1}{\sigma\sqrt{2\pi}}\exp\left ( -\frac{(z-\mu)^2}{2\sigma^2} \right )
\end{equation*}

\begin{equation*} 
\phi\left ( z \right )=\frac{1}{\sqrt{2\pi}}\exp\left ( -\frac{z^2}{2} \right )
\end{equation*}

\begin{equation*} 
\Phi\left ( z \right )=\int_{-\infty }^{z}\phi(t)dt
\end{equation*}


## The normal distribution pdf and cdf plots


```r
x <- seq(-3,3,0.01)
pdfData <- data.frame(z = x, pdfcdf = dnorm(x))
# plot the CDF
cdfData <- data.frame(z = x, pdfcdf = pnorm(x))
pdfcdfPlot <- ggplot(mapping = aes(x = z, y = pdfcdf)) + geom_line(data = pdfData) + geom_line(data = cdfData) +
  geom_vline(xintercept = 1, linetype = 2) + xlab(label = "z") + ylab(label = "pdf/CDF")
print(pdfcdfPlot)
```

![](03-modeling-binary-task_files/figure-latex/unnamed-chunk-1-1.pdf)<!-- --> 

The sigmoid shaped curve is the CDF, or cumulative distribution function, of the N(0,1) distribution, while the bell-shaped curve is the corresponding pdf, or probability density function. The dashed line corresponds to the reporting threshold $\zeta$. The area under the pdf to the left of $\zeta$ equals the value of CDF at the selected  $\zeta$, i.e., 0.841 (`pnorm(1)` = 0.841). 

## Binary ratings


```r
# Line 1
# ...
# ...
seed <- 100;set.seed(seed)
K1 <- 9;K2 <- 11;mu <- 1.5;zeta <- mu/2
z1 <- rnorm(K1)
z2 <- rnorm(K2) + mu
nTN <- length(z1[z1 < zeta])
nTP <- length(z2[z2 >= zeta])
Sp <- nTN/K1;Se <- nTP/K2
cat("seed = ", seed, ", K1 = ", K1, ", K2 = ", K2, 
    "Specificity = ", Sp, ", Sensitivity = ", Se, "\n")
#> seed =  100 , K1 =  9 , K2 =  11 Specificity =  0.8888889 , Sensitivity =  0.9090909
```

Line 4 sets the `seed` of the random number generator to 100: this causes the random number generator to yield the same sequence of "random" numbers every time it is run. This is useful during initial code development and for showing the various steps of the example (if `seed <- NULL` the random numbers would be different every time, making it harder for me, from a pedagogical point of view, to illustrate the steps). Line 5 initializes variables `K1` and `K2`, which represent the number of non-diseased cases and  the number of diseased cases, respectively. In this example 9 non-diseased and 11 diseased cases are simulated. Line 5 also initializes the parameter `mu <- 1.5` (`mu` corresponds to the separation  parameter of the simulation model). Finally, this line initializes `zeta`, which corresponds to the threshold for declaring cases as diseased, to `mu/2`, i.e., halfway between the means of the two distributions defining the binormal model. Later one can experiment with other values. [Note that multiple statements can be put on a single line as long as semi-colons separate them. The author prefers the “vertical length” of the program to be short, a personal preference that gives the author a better perspective of the code.] 

Line 6 calls the built-in function `rnorm()` – for random sample(s) from a normal distribution - with argument `K1`, which yields `K1` (9 in our example) samples from a unit normal distribution N(0,1). Arguments to a function are always comma separated and contained within enclosing parentheses. The samples are assigned to the variable `z1` (for z-samples for non-diseased cases). The corresponding samples for the diseased cases, line 7, denoted z2, were obtained using `rnorm(K2) + mu`. [Alternatively one could have used `rnorm(K2, mean = mu)`, which cause the value `mu` to override the default value  -  zero -  of the mean of the normal distribution.] Since `mu` was initialized to 1.5, this line yields 11 samples from a normal distribution with mean zero and unit variance and adds 1.5 to all samples (if one wishes to sample from a distribution with a different variance, for example "3", one needs to also insert the standard deviation argument, e.g., sd = sqrt(3), in the call to `rnorm()`). The modifications to the default values can be inserted, separated by commas, in any order, but the names `mean` and `sd` must match; try typing `rnorm(K1, mean1 = 0)` in the console window, one should see an error message.

## Calculating confidence intervals for sensitivity and specificity


```r
options(digits=3)
seed <- 100;set.seed(seed)
alpha <- 0.05;K1 <- 99;K2 <- 111;mu <- 5;zeta <- mu/2
cat("alpha = ", alpha, "K1 = ", K1, "K2 = ", K2, "mu = ", mu, "zeta = ", zeta, "\n")
#> alpha =  0.05 K1 =  99 K2 =  111 mu =  5 zeta =  2.5
z1 <- rnorm(K1)
z2 <- rnorm(K2) + mu
nTN <- length(z1[z1 < zeta])
nTP <- length(z2[z2 >= zeta])
Sp <- nTN/K1;Se <- nTP/K2
cat("Specificity = ", Sp, "Sensitivity = ", Se, "\n")
#> Specificity =  0.99 Sensitivity =  0.991

# Approx binomial tests
cat("approx 95% CI on Specificity = ", 
    -abs(qnorm(alpha/2))*sqrt(Sp*(1-Sp)/K1)+Sp, 
    +abs(qnorm(alpha/2))*sqrt(Sp*(1-Sp)/K1)+Sp,"\n")
#> approx 95% CI on Specificity =  0.97 1.01

# Exact binomial test
ret <- binom.test(nTN, K1, p = nTN/K1)
cat("Exact 95% CI on Specificity = ", as.numeric(ret$conf.int),"\n")
#> Exact 95% CI on Specificity =  0.945 1

# Approx binomial tests
cat("approx 95% CI on Sensitivity = ", 
    -abs(qnorm(alpha/2))*sqrt(Se*(1-Se)/K2)+Se, 
    +abs(qnorm(alpha/2))*sqrt(Se*(1-Se)/K2)+Se,"\n")
#> approx 95% CI on Sensitivity =  0.973 1.01

# Exact binomial test
ret <- binom.test(nTP, K2, p = nTP/K2)
cat("Exact 95% CI on Sensitivity = ", as.numeric(ret$conf.int),"\n")
#> Exact 95% CI on Sensitivity =  0.951 1
```

The lines upto `cat("Specificity = ", Sp, "Sensitivity = ", Se, "\\n")` are almost identical to those in the previous code chunk. Lines 14-17 calculates the approximate 95% CI for `FPF`. Note the usage of the *absolute* value of the `qnorm()` function; `qnorm` is the lower quantile function for the unit normal distribution, identical to $\Phi^{-1}$, and $z_{\alpha/2}$ is the upper quantile function. Line 19 – 21 calculates and prints the corresponding exact confidence interval, using the function `binom.test()`; one should look up the documentation on this function for further details (in the Help panel – lower right window - start typing in the function name and RStudio should complete it) and examine the structure of the returned variable ret. The remaining code repeats these calculations for `TPF`.

The approximate confidence intervals can exceed the allowed ranges, but the exact confidence intervals do not.

## Summary{#modelingBinaryTask-Summary}
## Discussion{#modelingBinaryTask-Discussion}
## References {#modelingBinaryTask-references}


<!--chapter:end:03-modeling-binary-task.Rmd-->

# Ratings Paradigm {#ratingsParadigm}





## Introduction
In Chapter 02 the binary task and associated concepts of sensitivity, specificity, true positive fraction, false positive fraction, positive and negative predictive values were introduced. Chapter 03 introduced the concepts of a random scalar decision variable, or z-sample for each case, which is compared, by the observer, to a fixed reporting threshold $\zeta$, resulting in two types of decisions, “case is non-diseased” or “case is diseased” depending on whether the realized z-sample is less than, or greater than or equal to the reporting threshold. It described a statistical model, for the binary task, characterized by two unit-variance normal distributions separated by $\mu$. The concept of an underlying receiver operating characteristic (ROC) curve with the reporting threshold defining an operating point on the curve was introduced and the advisability of using the area under the curve as a measure of performance, which is independent of reporting threshold, was stressed. 

In this chapter the more commonly used ratings method will be described, which yields greater definition to the underlying ROC curve than just one operating point obtained in the binary task, and moreover, is more efficient. In this method, the observer assigns a rating to each case. Described first is a typical ROC counts table and how operating points (i.e., pairs of FPF and TPF values) are calculated from the counts data. A labeling convention for the operating points is introduced. Notation is introduced for the observed integers in the counts table and the rules for calculating operating points are expressed as formulae and implemented in R. The ratings method is contrasted to the binary method, in terms of efficiency and practicality. A theme occurring repeatedly in this book, that the ratings are not numerical values but rather they are ordered labels is illustrated with an example.

## The ROC counts table
In a positive-directed rating scale with five discrete levels, the ratings could be the ordered labels “1”: definitely non-diseased, “2”: probably non-diseased, “3”: could be non-diseased or diseased, “4”: probably diseased, “5”: definitely diseased. At the conclusion of the ROC study an ROC counts table is constructed. This is the generalization to rating studies of the 2 x 2 decision vs. truth table introduced in Chapter 02, Table 2.1. This type of data representation is sometimes called a frequency table, but frequency  means a rate of number of events per some unit, so the author prefers the clearer term “counts”. 

Table \@ref(tab:ratingsParadigmTable1) is a representative counts table for a 5-rating study that summarizes the collected data. It is the starting point for analysis. It lists the number of counts in each ratings bin, listed separately for non-diseased and diseased cases, respectively. The data is from an actual clinical study.

\begin{table}[H]
\centering
\begin{tabular}{l|r|r|r|r|r}
\hline
  & 1 & 2 & 3 & 4 & 5\\
\hline
non-diseased & 30 & 19 & 8 & 2 & 1\\
\hline
diseased & 5 & 6 & 5 & 12 & 22\\
\hline
\end{tabular}
\end{table}

In this example, there are $K_1 = 60$ non-diseased cases and $K_2 = 50$ diseased cases. Of the 60 non-diseased cases 30 were assigned the "1" rating, 19 were assigned the "2" rating, eight the "3" rating, two the "4" rating and one received the "5" rating. The distribution of counts is tilted towards the "1" rating end, but there is some spread and one actually non-diseased case appeared definitely diseased to the observer. In contrast, the distribution of the diseased cases is tilted towards the "5" rating end. Of the 50 diseased cases, 22 received the "5" rating, 12 the "4" rating, five the "3" rating, six the "2" rating and five the "1" rating. The spread appears to be more pronounced for the diseased cases, e.g., five of the 50 cases appeared to be definitely non-diseased to the observer. A little thought should convince you that the observed tilting of the counts, towards the "1" end for actually non-diseased cases, and towards the "5" end for actually diseased cases, is reasonable. However, one should be forewarned not to jump to conclusions about the spread of the data being larger for diseased than for non-diseased cases. While it turns out to be true, the ratings are merely ordered labels, and modeling is required, to be described in Chapter 06, that uses only the ordering information implicit in the labels, not the actual values, to reach quantitative conclusions.

## Operating points from counts table
* RtngGE5 means "rating greater than or equal to 5", etc.

\begin{tabular}{l|r|r|r|r|r}
\hline
  & RtngGE5 & RtngGE4 & RtngGE3 & RtngGE2 & RtngGE1\\
\hline
FPF & 0.017 & 0.05 & 0.183 & 0.5 & 1\\
\hline
TPF & 0.440 & 0.68 & 0.780 & 0.9 & 1\\
\hline
\end{tabular}

* _It is critical to understand the following example_. The table illustrates how ROC operating points are calculated from the cell counts. One starts with non-diseased cases that were rated five or more (in this example, since 5 is the highest allowed rating, the “or more” clause is superfluous) and divides by the total number of non-diseased cases, $K_1 = 60$. This yields the abscissa of the lowest non-trivial operating point, namely  $FPF_{\ge5}$ = 1/60 = 0.017. The subscript on FPF is intended to make explicit which ratings are being cumulated. The corresponding ordinate is obtained by dividing the number of diseased cases rated "5" or more and dividing by the total number of diseased cases, $K_2 = 50$, yielding $TPF_{\ge5}$ = 22/50 = 0.440. Therefore, the coordinates of the lowest operating point are (0.017, 0.44). The abscissa of the next higher operating point is obtained by dividing the number of non-diseased cases that were rated "4" or more and dividing by the total number of non-diseased cases, i.e., $TPF_{\ge4}$ = 3/60 = 0.05. Similarly the ordinate of this operating point is obtained by dividing the number of diseased cases that were rated "4" or more and dividing by the total number of diseased cases, i.e., $FPF_{\ge4}$ = 34/50 = 0.680. The procedure, which at each stage cumulates the number of cases equal to or greater (in the sense of increased confidence level for disease presence) than a specified label, is repeated to yield the rest of the operating points listed in Table 4.1. Since they are computed directly from the data, without any assumption, they are called empirical or observed operating points. After done this once it would be nice to have a formula implementing the process, one use of which would be to code the procedure. First, one needs appropriate notation for the bin counts.

* Let $K_{1r}$ denote the number of non-diseased cases rated r, and $K_{2r}$ denote the number of diseased cases rated r. For convenience, define dummy counts  $K_{1{(R+1)}}$ = $K_{2{(R+1)}}$ = 0, where R is the number of ROC bins. This construct allows inclusion of the origin (0,0) in the formulae. The range of r is $r = 1,2,...,(R+1)$. Within each truth-state, the individual bin counts sum to the total number of non-diseased and diseased cases, respectively. The following equations summarize all this:

\begin{equation*} 
K_1=\sum_{r=1}^{R+1}K_{1r}
\end{equation*}

\begin{equation*} 
K_2=\sum_{r=1}^{R+1}K_{2r}
\end{equation*}

\begin{equation*} 
K_{1{(R+1)}} = K_{2{(R+1)}} = 0
\end{equation*}

\begin{equation*} 
r = 1,2,...,(R+1)
\end{equation*}

The operating points are defined by:

\begin{equation*} 
FPF_r=\frac {1} {K_1} \sum_{s=r}^{R+1}K_{1s}
\end{equation*}

\begin{equation*} 
TPF_r=\frac {1} {K_2} \sum_{s=r}^{R+1}K_{2s}
\end{equation*}

* The labeling of the points follows the following convention: $r=1$  corresponds to the upper right corner (1,1) of the ROC plot, a trivial operating point since it is common to all datasets. Next, $r=2$  is the next lower operating point, etc., and  $r=R$ is the lowest non-trivial operating point and finally $r=R+1$  is the origin (0,0) of the ROC plot, which is also a trivial operating point, because it is common to all datasets. In other words, the operating points are numbered starting with the upper right corner, labeled 1, and working down the curve, each time increasing the label by one. 

* Since one is cumulating counts, which can never be negative, the highest non-trivial operating point resulting from cumulating the 2 through 5 ratings has to be to the upper-right of the next adjacent operating point resulting from cumulating the 3 through 5 ratings. This in turn has to be to the upper-right of the operating point resulting from cumulating the 4 through 5 ratings. This in turn has to be to the upper right of the operating point resulting from the 5 ratings. In other words, as one cumulates ratings bins, the operating point must move monotonically up and to the right, or more accurately, the point cannot move down or to the left. If a particular bin has zero counts for non-diseased cases, and non-zero counts for diseased cases, the operating point moves vertically up when this bin is cumulated; if it has zero counts for diseased cases, and non-zero counts for non-diseased cases, the operating point moves horizontally to the right when this bin is cumulated.

## Automating all this
It is useful to replace the preceding detailed explanation with a simple algorithm that incorporates all the logic. This is done in the following code: 


```r
options(digits = 3)
FPF <- array(0,dim = R)
TPF <- array(0,dim = R)

for (r in (R+1):2) {
  FPF[(R+2)-r] <- sum(Ktr[1, r:(R+1)])/sum(Ktr[1,])
  TPF[(R+2)-r] <- sum(Ktr[2, r:(R+1)])/sum(Ktr[2,])    
}

cat("FPF =", "\n")
#> FPF =
cat(FPF, "\n")
#> 0.0167 0.05 0.183 0.5
cat("TPF = ", "\n")
#> TPF =
cat(TPF, "\n")
#> 0.44 0.68 0.78 0.9
mu <- qnorm(.5)+qnorm(.9);sigma <- 1
Az <- pnorm(mu/sqrt(2))
cat("uppermost point based estimate of mu = ", mu, "\n")
#> uppermost point based estimate of mu =  1.28
cat("corresponding estimate of Az = ", Az, "\n")
#> corresponding estimate of Az =  0.818
cat("showing observed operating points and equal variance model fitted ROC curve", "\n")
#> showing observed operating points and equal variance model fitted ROC curve
plotROC (mu, sigma, FPF, TPF)
```

![](04-ratings-paradigm_files/figure-latex/unnamed-chunk-3-1.pdf)<!-- --> 

* Notice that the values of the arrays `FPF` and `TPF` are identical to those listed in Table 4.1.

* It was shown in Chapter 03 that in the equal variance binormal model, an operating point determines the parameters $\mu$ = 1.282, Eqn. (3.21), or equivalently $A_{z;\sigma = 1}$ = 0.818, Eqn. (3.30). The last three lines of the preceding code chunk illustrate the application of these formulae using the coordinates (0.5, 0.9) of the uppermost non-trivial operating point, followed by a plot of the ROC curve and the operating points. 

* It should come as no surprise that the uppermost operating point is *exactly* on the predicted curve: after all, this point was used to calculate $\mu$ = 1.282. 

* The corresponding value of $\zeta$ can be calculated from Eqn. (3.17), namely:

\begin{equation*} 
\Phi^{-1}\left ( Sp \right )=\zeta
\end{equation*}

\begin{equation*} 
\zeta=\mu - \Phi^{-1}\left ( Se \right )
\end{equation*}

These are coded below:


```r
qnorm(1-0.5)
#> [1] 0
mu-qnorm(0.9)
#> [1] 0
```

* Either way, one gets the same result: $\zeta$ = 0. It should be clear that this makes sense: FPF = 0.5 is consistent with half of the (symmetrical) unit-normal non-diseased distribution being above $\zeta$ = 0. The transformed value $\zeta$ (zero in this example) is a genuine numerical value. *To reiterate, ratings cannot be treated as genuine numerical values, but thresholds, estimated from an appropriate model, can be treated as genuine numerical values.* 
* Exercise: calculate $\zeta$ for each of the remaining operating points. *Notice that $\zeta$ increases as one moves down the curve.*


```r
mu <- 2.17;sigma <- 1.65
Az <- pnorm(mu/sqrt(1+sigma^2))
plotROC (mu, sigma, FPF, TPF)
cat("binormal unequal variance model estimate of Az = ", Az, "\n")
#> binormal unequal variance model estimate of Az =  0.87
cat("showing observed operating points and unequal variance model fitted ROC curve", "\n")
#> showing observed operating points and unequal variance model fitted ROC curve
```

![](04-ratings-paradigm_files/figure-latex/unnamed-chunk-5-1.pdf)<!-- --> 

* The ROC curve in Fig. 4.1 (A), as determined by the uppermost operating point, passes exactly through this point but misses the others. If a different operating point were used to estimate $\mu$ = and $A_{z;\sigma = 1}$, the estimated values would have been different and the new curve would pass exactly through the *new* selected point. No single-point based choice of $\mu$ would yield a satisfactory visual fit to all the observed operating points. [The reader should confirm these statements with appropriate modifications to the code.] * __This is the reason one needs a modified model, with an extra parameter, namely the unequal variance binormal model, to fit radiologist data__ (the extra parameter is the ratio of the standard deviations of the two distributions). 

* Fig. 4.1 (B) shows the predicted ROC curve by the unequal variance binormal model, to be introduced in Chapter 06. The corresponding parameter values are $\mu$ = 2.17and $\sigma$ = 1.65. 

* Notice the improved visual quality of the fit. Each observed point is "not engraved in stone", rather both FPF and TPF are subject to sampling variability. Estimation of confidence intervals for FPF and TPF was addressed in §3.10. [A detail: the estimated confidence interval in the preceding chapter was for a single operating point; since the multiple operating points are correlated – some of the counts used to calculate them are common to two or more operating points – the method tends to overestimate the confidence interval. A modeling approach is possible to estimate confidence intervals that accounts for data correlation and this yields tighter confidence intervals.]

## Relation between ratings paradigm and the binary paradigm
* In Chapter 02 it was shown that the binary task requires a single fixed threshold parameter $\zeta$ and a decision rule, namely, to give the case a diseased rating of 2 if $Z \ge \zeta$ and a rating of 1 otherwise. 

* The R-rating task can be viewed as $(R-1)$ *simultaneously* conducted binary tasks each with its own fixed threshold  $\zeta_r, r = 1, 2, ..., R-1$. It is efficient compared to $(R-1)$  *sequentially* conducted binary tasks; *however, the onus is on the observer to maintain fixed-multiple thresholds through the duration of the study*.

* The rating method is a more efficient way of collecting the data compared to running the study repeatedly with appropriate instructions to cause the observer to adopt different fixed thresholds specific to each replication. In the clinical context such repeated studies would be impractical because it would introduce memory effects, wherein the diagnosis of a case would depend on how many times the case had been seen, along with other cases, in previous sessions. A second reason is that it is difficult for a radiologist to change the operating threshold in response to instructions. To the author's knowledge, repeated use of the binary paradigm has not been used in any clinical ROC study.  

* How does one model the binning? For convenience one defines dummy thresholds $\zeta_0 = - \infty$  and  $\zeta_R = + \infty$, in which case the thresholds satisfy the ordering requirement  $\zeta_{r-1} \le  \zeta_r$ , r = 1, 2, ..., R. The rating or binning rule is:	

\begin{equation*} 
if \left (\zeta_{r-1} \le z \le \zeta_r  \right )\Rightarrow \text rating = r
\end{equation*}

## Ratings are not numerical values
* The ratings are to be thought of as ordered labels, not as numeric values. Arithmetic operations that are allowed on numeric values, such as averaging, are not allowed on ratings. One could have relabeled the ratings in Table 4.2 as A, B, C, D and E, where A < B etc. As long as the counts in the body of the table are unaltered, such relabeling would have no effect on the observed operating points and the fitted curve. Of course one cannot average the labels A, B, etc. of different cases. The issue with numeric labels is not fundamentally different. At the root is that the difference in thresholds corresponding to the different operating points are not in relation to the difference between their numeric values. There is a way to estimate the underlying thresholds, if one assumes a specific model, for example the unequal-variance binormal model to be described in Chapter 06. The thresholds so obtained are genuine numeric values and can be averaged. [Not to hold the reader in suspense, the four thresholds corresponding to the data in Table 4.1 are   0.007676989,   0.8962713,   1.515645 and   2.396711; see §6.4.1; these values would be unchanged if, for example, the labels were doubled, with allowed values 2, 4, 6, 8 and 10, or any of an infinite number of rearrangements that preserves their ordering.]

* The temptation to regard confidence levels / ratings as numeric values can be particularly strong when one uses a large number of bins to collect the data. One could use of quasi-continuous ratings scale, implemented for example, by having a slider-bar user interface for selecting the rating. The slider bar typically extends from 0 to 100, and the rating could be recorded as a floating-point number, e.g., 63.45. Here too one cannot assume that the difference between a zero-rated case and a 10 rated case is a tenth of the difference between a zero-rated case and a 100 rated case. So averaging the ratings is not allowed. Additionally, one cannot assume that different observers use the labels in the same way. One observer's 4-rating is not equivalent to another observers 4-rating. Working directly with the ratings is a bad idea: valid analytical methods use the rankings of the ratings, not their actual values. The reason for the emphasis is that there are serious misconceptions about ratings. The author is aware of a publication stating, to the effect, that a modality resulted in an increase in average confidence level for diseased cases. Another publication used a specific numerical value of a rating to calculate the operating point for each observer – this assumes all observers use the rating scale in the same way. 

## A single "clinical" operating point from ratings data
The reason for the quotes in the title to this section is that a single operating point on a laboratory ROC plot, no matter how obtained, has little relevance to how radiologists operate in the clinic. However, some consider it useful to quote an operating point from an ROC study. For a 5-rating ROC study, Table 4.2, it is not possible to unambiguously calculate the operating point of the observer in the binary task of discriminating between non-diseased and diseased cases. One possibility would be to use the three and above ratings to define the operating point, but one might have chosen two and above. A second possibility is to instruct the radiologist that a four or higher rating, for example, implies the case would be reported “clinically” as diseased. However, the radiologist can only pretend so far that this study, which has no clinical consequences, is somehow a “clinical” study. If a single laboratory study based operating point is desired2, the best strategy , in the author's opinion, is to obtain the rating via two questions. This method is also illustrated in a book on detection theory, Ref. 3, Table 3.1. The first question is "is the case diseased?" The binary (Yes/No) response to this question allows unambiguous calculation of the operating point, as in Chapter 02. The second question is: "what is your confidence in your previous decision?" and allow three responses, namely Low, Medium and High. The dual-question approach is equivalent to a 6-point rating scale, Fig. 4.2. 

* The ordering of the ratings can be understood as follows. The four, five and six ratings are as expected. If the radiologist states the patient is diseased and the confidence level is high that is clearly the highest end of the scale, i.e., six, and the lower confidence levels, five and four, follow, as shown. If, on the other hand, the radiologist states the patient is non-diseased, and the confidence level is high, then that must be the lowest end of the scale, i.e., "1". The lower confidence levels in a negative decision must be higher than "1", namely "2" and "3", as shown. As expected, the low confidence ratings, namely "3" (non-diseased, low confidence) and "4"  (diseased, low confidence) are adjacent to each other. With this method of data-collection, there is no confusion as to what rating defines the single desired operating point as this is determined by the binary response to the first question. The 6-point rating scale is also sufficiently fine to not smooth out the ability of the radiologist to maintain distinct different levels. In the author's experience, using this scale one expects rating noise of about ±½ a rating bin, i.e., the same difficult case, shown on different occasions to the same radiologist (with sufficient time lapse or other intervening cases to minimize memory effects) is expected to elicit a "3" or "4", with roughly equal probability. 

## Observer performance studies as laboratory simulations of clinical tasks
* Observer performance paradigms (ROC, FROC, LROC and ROI) should be regarded as experiments conducted in a laboratory (i.e., controlled) setting that are intended to be representative of the actual clinical task. They should not to be confused with performance in a real "live" clinical setting: there is a known "laboratory effect"22-24. For example, in one study radiologists performed better during live clinical interpretations than they did later, on the same cases, in a laboratory ROC study22. This is expected because there is more at stake during live interpretations: e.g., the patient's health and the radiologist's reputation, than during laboratory ROC studies. The claimed "laboratory effect" has caused some controversy. A paper25 titled "Screening mammography: test set data can reasonably describe actual clinical reporting" argues against the laboratory effect. 

* Real clinical interpretations happen every day in radiology departments all over the world. In the laboratory, the radiologist is asked to interpret the images "as if in a clinical setting" and render a "diagnosis". The laboratory decisions have no clinical consequences, e.g., the radiologist will not be sued for mistakes and their ROC study decisions have no impact on the clinical management of the patients. Usually laboratory ROC studies are conducted on retrospectively acquired images. Patients, whose images were used in an ROC study, have already been imaged in the clinic and decisions have already been made on how to manage them. 

* There is no guarantee that results of the laboratory study are directly applicable to clinical practice. Indeed there is an assumption that the laboratory study correlates with clinical performance. Strict equality is not required, simply that the performance in the laboratory is related monotonically to actual clinical performance. Monotonicity assures preservation of performance orderings, e.g., a radiologist has greater performance than another does or one modality is superior to another, regardless of how they are measured, in the laboratory or in the clinic. The correlation is taken to be an axiomatic truth by researchers, when in fact it is an assumption. To the extent that the participating radiologist brings his/her full clinical expertise to bear on each laboratory image interpretation, this assumption is likely to be valid.

* This section provoked a strong negative response from a collaborator. To paraphrase him, "... *my friend, I think it is a pity in this book chapter you argue that these studies are simulations. I mean, the reason people perform these studies is because they believe in the results"*. 

* The author also believes in observer performance studies. Otherwise, he would not be writing this book. Distrust of the word "simulation" seems to be peculiar to this field. Simulations are widely used in "hard" sciences, e.g., they are used in astrophysics to determine conditions dating to 10-31 seconds after the big bang. Simulations are not to be taken lightly. Conducting clinical studies is very difficult as there are many factors not under the researcher's control. Observer performance studies of the type described in this book are the closest that one can come to the "real thing" and the author is a firm believer in them. These studies include key elements of the actual clinical task: the entire imaging system, radiologists (assuming the radiologist take these studies seriously in the sense of bringing their full clinical expertise to bear on each image interpretation) and real clinical images and as such are expected to correlate with real "live" interpretations. Proving this correlation is going to be difficult as there are many factors that complicated real interpretations. It is not clear to the author that proving or disproving this correlation is ever going to be a settled issue.  


## Discrete vs. continuous ratings: the Miller study
* There is controversy about the merits of discrete vs. continuous ratings26-28. Since the late Prof. Charles E. Metz and the late Dr. Robert F. Wagner have both backed the latter (i.e., continuous or quasi-continuous ratings) new ROC study designs sometimes tend to follow their advice. The author's recommendation is to follow the 6-point rating scale as outlined in Fig. 4.2. This section provides the background for the recommendation.

* A widely cited (22,909 citations at the time of writing) 1954 paper by Miller29 titled "The Magical Number Seven, Plus or Minus Two: Some Limits on Our Capacity for Processing Information" is relevant. It is a readable paper, freely downloadable in several languages (www.musanim.com/miller1956/). In the author's judgment, this paper has not received the attention it should have in the ROC community, and for this reason portions from it are reproduced below. [George Armitage Miller, February 3, 1920 – July 22, 2012, was one of the founders of the field of cognitive psychology.]

* Miller’s first objective was to comment on absolute judgments of unidimensional stimuli. Since all (univariate, i.e., single decision per case) ROC models assume a unidimensional decision variable, Miller's work is highly relevant. He comments on two papers by Pollack30,31. Pollack asked listeners to identify tones by assigning numerals to them, analogous to a rating task described above. The tones differed in frequency, covering the range 100 to 8000 Hz in equal logarithmic steps. A tone was sounded and the listener responded by giving a numeral (i.e., a rating, with higher values corresponding to higher frequencies). After the listener had made his response, he was told the correct identification of the tone. When only two or three tones were used, the listeners never confused them. With four different tones, confusions were quite rare, but with five or more tones, confusions were frequent. With fourteen different tones, the listeners made many mistakes. Since it is so succinct, the entire content of the first (1952) paper by Pollack is reproduced below:

* “In contrast to the extremely acute sensitivity of a human listener to discriminate small differences in the frequency or intensity between two sounds is his relative inability to identify (and name) sounds presented individually. When the frequency of a single tone is varied in equal‐logarithmic steps in the range between 100 cps and 8000 cps (and when the level of the tone is randomly adjusted to reduce loudness cues), the amount of information transferred is about 2.3 bits per stimulus presentation. This is equivalent to perfect identification among only 5 tones. The information transferred, under the conditions of measurement employed, is reasonably invariant under wide variations in stimulus conditions.”

* By “information” is meant (essentially) the number of levels, measured in bits (binary digits), thereby making it independent of the unit of measurement: 1 bit corresponds to a binary rating scale, 2 bits to a four-point rating scale and 2.3 bits to 22.3 = 4.9, i.e., about 5 ratings bins. Based on Pollack’s’ original unpublished data, Miller put an upper limit of 2.5 bits (corresponding to about 6 ratings bins) on the amount of information that is transmitted by listeners who make absolute judgments of auditory pitch. A second paper31 by Pollack was related to: (1) the frequency range of tones; (2) the utilization of objective reference tones presented with the unknown tone; and (3) the “dimensionality”—the number of independently varying stimulus aspects. Little additional gain in information transmission was associated with the first factor; a moderate gain was associated with the second; and a relatively substantial gain was associated with the third (we return to the dimensionality issue below).

* As an interesting side-note, Miller states: 

* “Most people are surprised that the number is as small as six. Of course, there is evidence that a musically sophisticated person with absolute pitch can identify accurately any one of 50 or 60 different pitches. Fortunately, I do not have time to discuss these remarkable exceptions. I say it is fortunate because I do not know how to explain their superior performance. So I shall stick to the more pedestrian fact that most of us can identify about one out of only five or six pitches before we begin to get confused.

It is interesting to consider that psychologists have been using seven-point rating scales for a long time, on the intuitive basis that trying to rate into finer categories does not really add much to the usefulness of the ratings. Pollack's results indicate that, at least for pitches, this intuition is fairly sound.

Next you can ask how reproducible this result is. Does it depend on the spacing of the tones or the various conditions of judgment? Pollack varied these conditions in a number of ways. The range of frequencies can be changed by a factor of about 20 without changing the amount of information transmitted more than a small percentage. Different groupings of the pitches decreased the transmission, but the loss was small. For example, if you can discriminate five high-pitched tones in one series and five low-pitched tones in another series, it is reasonable to expect that you could combine all ten into a single series and still tell them all apart without error. When you try it, however, it does not work. The channel capacity for pitch seems to be about six and that is the best you can do.”

* In contrast to the careful experiments conducted in the psychophysical context to elucidate this issue, the author was unable to find a single study of the number of discrete rating levels that an observer can support. Even lacking such a study, a recommendation has been made to acquire data on a quasi-continuous scale27.

* There is no question that for multidimensional data, as observed in the second study by Pollack31, the observer can support more than 7 ratings bins. To quote Miller:

* “You may have noticed that I have been careful to say that this magical number seven applies to one- dimensional judgments. Everyday experience teaches us that we can identify accurately any one of several hundred faces, any one of several thousand words, any one of several thousand objects, etc. The story certainly would not be complete if we stopped at this point. We must have some understanding of why the one-dimensional variables we judge in the laboratory give results so far out of line with what we do constantly in our behavior outside the laboratory. A possible explanation lies in the number of independently variable attributes of the stimuli that are being judged. Objects, faces, words, and the like differ from one another in many ways, whereas the simple stimuli we have considered thus far differ from one another in only one respect.”

* In the medical imaging context, a trivial way to increase the number of ratings would be to color-code the images: red, green and blue; now one can assign a red image rated 3, a green image rated 2, etc., which would be meaningless unless the color encoded relevant diagnostic information. Another ability, quoted in the publication27 advocating continuous ratings is the ability to recognize faces, again a multidimensional categorization task, as noted by Miller. Also quoted as an argument for continuous ratings is the ability of computer aided detection schemes that calculate many features for each perceived lesion and combine them into a single probability of malignancy, which is on a highly precise floating point 0 to 1 scale. Radiologists are not computers. Other arguments for greater number of bins: it cannot hurt and one should acquire the rating data at greater precision than the noise, especially if the radiologist is able to maintain the finer distinctions. The author worries that radiologists who are willing to go along with greater precision are over-anxious to co-operate with the experimentalist. In the author's experience, expert radiologists will not modify their reading style and one should be suspicious when overzealous radiologists accede to an investigators request to interpret images in a style that does not closely resemble the clinic. Radiologists, especially experts, do not like more than about four ratings. The author has worked with a famous chest radiologist (the late Dr. Robert Fraser) who refused to use more than four ratings. 

* Another reason given for using continuous ratings is it reduces instances of data degeneracy. Data is sometimes said to be degenerate if the curve-fitting algorithm, the binormal model and the proper binormal model, cannot fit it. This occurs, for example, if there are no interior points on the ROC plot. Modifying radiologist behavior to accommodate the limitations of analytical methods seems to be inherently dubious. One could simply randomly add or subtract half an integer from the observed ratings, thereby making the rating scale more granular and reduce instances of degeneracy (this is actually done in some ROC software to overcome degeneracy issues). Another possibility is to use the empirical (trapezoidal) area under the ROC curve. This quantity can always be calculated; there are no degeneracy problems with it. Actually, fitting methods now exist that are robust to data degeneracy, such as discussed in Chapter 18 and Chapter 20, so this reason for acquiring continuous data no longer applies.

* The rating task involves a unidimensional scale and the author sees no way of getting around the basic channel-limitation noted by Miller and for this reason the author recommends a 6 point scale, as in Fig. 4.2.

* On the other side of the controversy it has been argued that given a large number of allowed ratings levels the observer essentially bins the data into a much smaller number of bins (e.g., 0, 20, 40, 60, 80, 100) and adds a zero-mean noise term to appear to be "spreading out the ratings" 35. This allows easier curve-fitting with the binormal model. However, if the intent is to get the observer to spread the ratings, so that th binormal model does not fail to fit, a better approach is to use alternate models that are very robust with respect to degneracy of the data. More on thsi later (CBM and RSM).

## References  


<!--chapter:end:04-ratings-paradigm.Rmd-->

# Binormal model {#BinMod}





## Introduction {#BinModIntro}
In this chapter the univariate binormal model [@RN212] is described, in which one is dealing with one ROC rating per case, as in a single observer interpreting cases, one at a time, in a single modality. By convention the qualifier "univariate" is often omitted, i.e., it is implicit. In a later chapter a bivariate binormal model will be described where each case yields two ratings, as in a single observer interpreting cases in two modalities, or equivalently, two observers interpreting cases in a single modality. 

The equal variance binormal model was described in Chapter "Binary Paradigm". The ratings method of acquiring ROC data and calculation of operating points was illustrated in Chapter "Ratings Paradigm". It was shown that for a clinical ROC dataset the unequal-variance binormal model fitted the data better than the equal-variance binormal model. This chapter deals with details of the unequal-variance binormal model, establishes necessary notation for describing the model, and derives expressions for sensitivity, specificity and the area under the predicted ROC curve (due to its complexity it appears in an Appendix). 

The main aim of this chapter is to take the mystery out of statistical curve fitting. Accordingly, this is one chapter where the Appendices are longer than the main text, but as usual, they are essential reading as they reinforce the main text. It is not too much to expect the reader to load each file beginning with "main", click on Source and see what happens. [The reader is reminded that any file that starts with "main" contains directly executable code.]


## The binormal model {#BinModTheModel}
The unequal-variance binormal model (henceforth abbreviated to binormal model; when the author means equal variances, it will be made explicit) is defined by (capital letters indicate random variables and their lower-case counterparts are actual realized values):

\begin{equation} 
Z_{k_tt}\sim N\left ( \mu_t,\sigma_{t}^{2} \right );t=1,2
(\#eq:BinModZSampling1)
\end{equation}

where 

\begin{equation} 
\mu_1=0;\mu_2=\mu;\sigma_{1}^{2}=1;\sigma_{2}^{2}=\sigma^{2}
(\#eq:BinModZSampling2)
\end{equation}

Eqn. \@ref(eq:BinModZSampling1) states that the z-samples for non-diseased cases are distributed as a $N(0,1)$  distribution, i.e., the unit normal distribution, while the z-samples for diseased cases are distributed as a  $N(\mu,\sigma^2)$ distribution, i.e., a normal distribution with mean $\mu$  and variance $\sigma^2$. This is a 2-parameter model of the z-samples, not counting additional threshold parameters needed for data binning.

### Binning the data
In an R-rating ROC study the observed ratings r take on integer values, 1 through R, it being understood that higher ratings correspond to greater confidence for disease. Defining dummy cutoffs $\zeta_0 = -\infty$ and  $\zeta_R = +\infty$, the binning rule for a case with realized z-sample z is (Chapter "Ratings Paradigm", Eqn. 4.13):

\begin{equation} 
if \left (\zeta_{r-1} \le z \le \zeta_r  \right )\Rightarrow \text rating = r
(\#eq:BinModZBinning)
\end{equation}



```r
mu <- 1.5;sigma <- 1.5

z1 <- seq(-3, 4, by = 0.01)
z2 <- seq(-3, 6, by = 0.01)

Pdf1 <- dnorm(z1)
Pdf2 <- dnorm(z2, mu, sd = sigma)

df <- data.frame(z = c(z1, z2), pdfs = c(Pdf1, Pdf2), 
                 truth = 
                   c(rep('non-diseased', 
                         length(Pdf1)), 
                     rep('diseased', length(Pdf2))), 
                 stringsAsFactors = FALSE)

cut_point <- data.frame(z = c(-2.0, -0.5, 1, 2.5))

rocPdfs <- ggplot(df, aes(x = z, y = pdfs, color = truth)) + 
  geom_line(size = 1) + 
  scale_colour_manual(values=c("darkgrey","black")) + 
  theme(
    legend.title = element_blank(), 
    legend.position = c(0.85, 0.90), 
    legend.text = element_text(face = "bold"), 
    axis.title.x = element_text(hjust = 0.8, size = 14,face="bold"),
    axis.title.y = element_text(size = 14,face="bold")) +
  geom_vline(data = cut_point, aes(xintercept = z), 
             linetype = "dashed", size = 0.25) +
  annotation_custom(
    grob = 
      textGrob(bquote(italic("O")),
               gp = gpar(fontsize = 12)), 
    xmin = -3.2, xmax = -3.2, # adjust the position of "O"
    ymin = -0.0, ymax = -0.01) +
  scale_x_continuous(expand = c(0, 0)) + 
  scale_y_continuous(expand = c(0, 0),limits=c(NA,0.4))

for (i in 1 : length(cut_point$z)){
  rocPdfs <- rocPdfs +
    annotation_custom(
      grob = 
        textGrob(bquote(zeta[.(i)]),gp = gpar(fontsize = 12)),
      xmin = cut_point$z[i], xmax = cut_point$z[i],
      ymin = -0.025, ymax = -0.045)
}

gt <- ggplot_gtable(ggplot_build(rocPdfs))
gt$layout$clip[gt$layout$name == "panel"] <- "off"
grid.draw(gt)
```

![](06-binormal-model_files/figure-latex/unnamed-chunk-2-1.pdf)<!-- --> 

In the unequal-variance binormal model, the variance $\sigma^2$ of the z-samples for diseased cases is allowed to be different from unity. Most ROC datasets are consistent with  $\sigma > 1$. The above figure, generated with  $\mu = 1.5, \sigma = 1.5$, illustrates how realized z-samples are converted to ratings, i.e., application of the binning rule. For example, a case with  z-sample equal to -2.5 would be rated "1", and one with  z-sample equal to -1 would be rated "2", cases with z-samples greater than 2.5 would be rated "5", etc.

### Invariance of the binormal model to arbitrary monotone transformations
The binormal model is not as restrictive as might appear at first sight. Any monotone increasing transformation $Y=f(Z)$  applied to the observed z-samples, and the associated thresholds, will yield the same observed data, e.g., Table 6.1. This is because such a transformation leaves the ordering of the ratings unaltered and hence results in the same operating points. While the distributions for   will not be binormal (i.e., two independent normal distributions), one can safely "pretend" that one is still dealing with an underlying binormal model. An alternative way of stating this is that any pair of distributions is allowed as long as they are reducible to a binormal model form by a monotonic increasing transformation of  Y: e.g., $Z=f^{-1}$. [If $f$ is a monotone increasing function of its argument, so is  $f^{-1}$}.]  For this reason, the term “pair of latent underlying normal distributions” is sometimes used to describe the binormal model. The robustness of the binormal model has been investigated [@RN1216; @RN100]. The referenced paper by Dorfman et al has an excellent discussion of the robustness of the binormal model.

The robustness of the binormal model, i.e., the flexibility allowed by the infinite choices of monotonic increasing functions, application of each of which leaves the ordering of the data unaltered, is widely misunderstood. The non-Gaussian appearance of histograms of ratings in ROC studies can lead one to incorrect conclusions that the binormal model is inapplicable to these datasets. To quote a reviewer of one of the author's recent papers: 
> I have had multiple encounters with statisticians who do not understand this difference.... They show me histograms of data, and tell me that the data is obviously not normal, therefore the binormal model should not be used. 

The reviewer is correct. The misconception is illustrated next.






```r
# shows that monotone transformations have no effect on 
# AUC even though the pdfs look non-gaussian
# common statistician misconception about ROC analysis

options(digits = 7) # line 10

fArray <- c(0.1,0.5,0.9);seedArray <- c(10,11,12)
for (i in 1:3) { 
  f <- fArray[i];seed <- seedArray[i];set.seed(seed) # line 20
  K1 <- 900
  K2 <- 1000
  mu1 <- 30
  sigma1 <- 7
  mu2 <- 55;sigma2 <- 7 # line 21
  z1 <- rnorm(
    K1, 
    mean = mu1, 
    sd = sigma1)
  z1[z1>100] <- 100;z1[z1<0] <- 0
  z2 <- rnorm(
    K2, 
    mean = mu2, 
    sd = sigma2)
  z2[z2>100] <- 100;z2[z2<0] <- 0
  AUC1 <- TrapezoidalArea(z1, z2)
  Gaussians <- c(z1, z2)
  hist1 <- data.frame(x=Gaussians) #  line 27
  hist.1 <-  
    ggplot(data = hist1, mapping = aes(x = x)) +
    geom_histogram(binwidth = 5, color = "black", fill="grey") + 
    xlab(label = "Original Rating") + 
    ggtitle(label = paste0("A", i, ": ", "Gaussians"))
  print(hist.1)
  
  z <- seq(0.0, 100, 0.1) # line 32
  curveData <- 
    data.frame(x = z, 
               z =  Y(z,mu1,mu2,sigma1,sigma2,f))
  plot3 <- 
    ggplot(mapping = aes(x = x, y = z)) + 
    geom_line(data = curveData, size = 1) +
    xlab(label = "Original Rating") +
    ylab(label = "Transformed Rating") + 
    ggtitle(
      label = paste0("B", i, ": ", 
                     "Monotone Transformation"))
  print(plot3)
  
  y <- Y(c(z1, z2),mu1,mu2,sigma1,sigma2,f)
  y1 <- y[1:K1];y2 <- y[(K1+1):(K1+K2)]
  AUC2 <- TrapezoidalArea( y1, y2)
  hist2 <- data.frame(x=y)
  hist.2 <-  ggplot(data = hist2, mapping = aes(x = x)) +
    geom_histogram(binwidth = 5, color = "black", fill="grey") +
    xlab(label = "Transformed Rating") + 
    ggtitle(
      label = paste0("C", i, ": ", "Latent Gaussians"))
  print(hist.2)
  cat("seed =", seed, "f =", f, 
      "\nAUC of actual Gaussians =", AUC1, 
      "\nAUC of latent Gaussians =", AUC2, "\n")
}
#> seed = 10 f = 0.1 
#> AUC of actual Gaussians = 0.99308 
#> AUC of latent Gaussians = 0.99308
#> seed = 11 f = 0.5 
#> AUC of actual Gaussians = 0.9936689 
#> AUC of latent Gaussians = 0.9936689
#> seed = 12 f = 0.9 
#> AUC of actual Gaussians = 0.9950411 
#> AUC of latent Gaussians = 0.9950411
```


\includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-1} \includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-2} \includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-3} \includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-4} \includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-5} \includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-6} \includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-7} \includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-8} \includegraphics[width=0.33\linewidth]{06-binormal-model_files/figure-latex/unnamed-chunk-4-9} 

**Figure captions (A1 - C3):** Plots illustrating the invariance of ROC analysis to arbitrary monotone transformations of the ratings. Each of the latent Gaussian plots (C1, C2 and C3) appears not binormal. However, by using the inverse of the monotone transformations shown (B1, B2 and B3), they can be transformed to the binormal model histograms (A1, A2 and A3). Plot (A1) shows the histogram of simulated ratings from a binormal model. Two peaks, one at 30 and the other at 55 are evident (by design, all ratings in this figure are in the range 0 to 100). Plot (B1) shows the monotone transformation for $f = 0.1$. Plot (C1) shows the histogram of the transformed rating. The choice of $f$ leads to a transformed rating histogram that is peaked near the high end of the rating scale. For (A1) and (C1) the corresponding AUCs are identical (0.99308). Plot (A2) is for a different seed value, plot (B2) is the transformation for $f = 0.5$ and now the transformed histogram is almost flat, plot C2. For plots (A2) and (C2) the corresponding AUCs are identical (0.9936689). Plot (A3) is for a different seed value, (B3) is the transformation for $f = 0.9$ and the transformed histogram (C3) is peaked near the low end of the transformed rating scale. For plots (A3) and (C3) the corresponding AUCs are identical (0.9950411).

Line 20-21 sets the parameters of the simulation model. The idea is to simulate continuous ratings data in the range 0 to 100 from a binormal model. Non-diseased cases are sampled from a Gaussian centered at $\mu_1$ = 30 and standard deviation $\sigma_1 = 7$. Diseased cases are sampled from a Gaussian centered at $\mu_2$ = 55 and standard deviation $\sigma_2$ = 7. The variable $f$, which is in the range (0,1), controls the shape of the transformed distribution. If $f$ is small, the transformed distribution will be peaked towards 0 and if $f$ is unity, it will be peaked at 100. If $f$ equals 0.5, the transformed distribution is flat. Insight into the reason for this transformation is in [@RN300], Chapter 7, ibid: it has to do with transformations of random variables. The transformation $Y(Z)$, in the in-line function $Y$, not shown, implements:

\begin{equation} 
Y\left ( Z \right )=\left [ \left ( 1-f \right )\Phi\left ( \frac{Z-\mu_1}{\sigma_1} \right )+f\Phi\left ( \frac{Z-\mu_2}{\sigma_2} \right ) \right ]100
(\#eq:BinModDemoMisconception)
\end{equation}

The multiplication by 100 ensures that the transformed variable is in the range 0 to 100. The code realizes the random samples, calculates the empirical AUC using the binormal samples, displays the histogram of the binormal samples, plots the transformation function, calculates the empirical AUC using the transformed samples, and plots the histogram of the transformed samples. 

The output lists the values of the seed variable and the value of the shape parameter $f$. *For each value of seed and the shape parameter, the AUCs of the actual Gaussians and the transformed variables are identical to seven digits (set at line 10)*. For this reason, the transformed variables are termed "Latent Gaussians". The values of the parameters were chosen to explicate the binormal nature of the plots A2 and A3). This has the effect of making the AUCs close to unity. It is left as an exercise for the reader to plot ROC curves corresponding to actual Gaussian and latent Gaussian variables and show that they are identical. 

Fig. (B1) shows the transformation for $f = 0.1$. The steep initial rise of the curve has the effect of flattening the histogram of the transformed ratings at the low end of the rating scale, Fig. (C1). Conversely, the flat nature of the curve near upper end of the rating range has the effect of causing the histogram of the transformed variable to peak in that range. Fig. (B2) shows the transformation for $f = 0.5$. This time the transformed rating histogram, Fig. (C2), is almost flat over the entire range. Fig. (B3) shows the transformation for $f = 0.9$. This time the transformed rating histogram, Fig. (C3) is peaked at the low end of the transformed rating scale.

Each histogram in Fig. (C1, C2 and C3) appears to be non-Gaussian. The corresponding non-diseased and diseased ratings will fail tests of normality. [Showing this is left as an exercise for the reader.] Nevertheless, the transformed ratings are latent Gaussians in the sense that the inverses of the transformations shown in Fig. (B1, B2 and B3) will yield histograms that are strictly binormal. By appropriate changes to the monotone transformation function, the histograms shown in Fig. (C1, C2 and C3) can be made to resemble a wide variety of shapes. [As another exercise, the reader could modify the transformation function to yield quasi-bimodal histograms.] **One concludes that visual examination of the shape of the histogram of ratings yields little, if any, insight into whether the underlying binormal model assumptions are being violated.**


### Expressions for sensitivity and specificity
Let $Z_t$ denote the random z-sample for truth state $t$ ($t$ = 1 for non-diseased and $t$ = 2 for diseased cases).  Since the distribution of z-samples from disease-free cases is $N(0,1)$, the expression for specificity, Chapter "Modeling Binary Paradigm", Eqn. 3.13, applies. It is reproduced below: 

\begin{equation} 
Sp\left ( \zeta \right )=P\left ( Z_1 < \zeta \right )=\Phi\left ( \zeta \right )
(\#eq:BinModSp)
\end{equation}

To obtain an expression for sensitivity, consider that for truth state $t = 2$, the random variable $\frac{Z_2-\mu}{\sigma}$  is distributed as $N(0,1)$: 

\begin{equation*} 
\frac{Z_2-\mu}{\sigma}\sim N\left ( 0,1 \right )
\end{equation*}

Sensitivity is $P\left ( Z_2 > \zeta \right )$, which implies, because $\sigma$  is positive (subtract   from both sides of the “greater than” symbol and divide by $\sigma$):

\begin{equation} 
Se\left ( \zeta | \mu, \sigma \right )= P\left ( Z_2 > \zeta \right )=P\left ( \frac{Z_2-\mu}{\sigma} > \frac{\zeta-\mu}{\sigma} \right )
(\#eq:BinModSe)
\end{equation}

The right-hand-side can be rewritten as follows:

\begin{equation*} 
Se\left ( \zeta | \mu, \sigma \right )= 1 - P\left ( \frac{Z_2-\mu}{\sigma} \leq  \frac{\zeta-\mu}{\sigma} \right )\\
=1-\Phi\left (  \frac{\zeta-\mu}{\sigma}\right )=\Phi\left (  \frac{\mu-\zeta}{\sigma}\right )
\end{equation*}

Summarizing, the formulae for the specificity and sensitivity for the binormal model are: 

\begin{equation} 
Sp\left ( \zeta \right ) = \Phi\left ( \zeta \right )\\
Se\left ( \zeta | \mu, \sigma \right ) = \Phi\left (  \frac{\mu-\zeta}{\sigma}\right )
(\#eq:BinModSeSp)
\end{equation}

The coordinates of the operating point defined by $\zeta$ are given by:

\begin{equation} 
FPF\left ( \zeta \right ) = 1 - Sp\left ( \zeta \right ) = 1 - \Phi\left ( \zeta \right ) = \Phi\left ( -\zeta \right )
(\#eq:BinModFPF)
\end{equation}

\begin{equation} 
TPF\left ( \zeta | \mu, \sigma \right ) = \Phi\left ( \frac{\mu-\zeta}{\sigma} \right )
(\#eq:BinModTPF)
\end{equation}

These expressions allow calculation of the operating point for any $\zeta$. An equation for a curve is usually expressed as $y=f(x)$. An expression of this form for the ROC curve, i.e., the y coordinate (TPF) expressed as a function of the x coordinate (FPF), follows upon inversion of the expression for FPF, Eqn.  \@ref(eq:BinModFPF):

\begin{equation} 
\zeta = -\Phi^{-1}\left ( FPF \right )
(\#eq:BinModZeta)
\end{equation}

Substitution of Eqn. \@ref(eq:BinModZeta) in Eqn. \@ref(eq:BinModTPF) yields:

\begin{equation} 
TPF = \Phi\left ( \frac{\mu + \Phi^{-1}\left (FPF  \right )}{\sigma} \right )
(\#eq:BinModRocCurve1)
\end{equation}

This equation gives the dependence of TPF on FPF, i.e., the equation for the ROC curve. It will be put into standard notation next.  


### Binormal model in standard notation
The following notation is widely used in the literature: 

\begin{equation} 
a=\frac{\mu}{\sigma};b=\frac{1}{\sigma}
(\#eq:BinModabParameters)
\end{equation}

The reason for the $(a,b)$  instead of the  $(\mu,\sigma)$ notation is that Dorfman and Alf assumed, in their seminal paper [@RN1081], that the diseased distribution (signal distribution in signal detection theory) had unit variance, and the non-diseased distribution (noise) had standard deviation $b$ ($b > 0$) or variance $b^2$, and that the separation of the two distributions was $a$, see figure below. In this example, $a = 1.11$ and $b = 0.556$. Dorfman and Alf's fundamental contribution, namely estimating these parameters from ratings data, to be described below, led to the widespread usage of the  $(a,b)$ parameters, estimated by their software (RSCORE), and its newer variants (e.g., RSCORE –II, ROCFIT and ROCKIT). 

By dividing the z-samples by $b$, the variance of the distribution labeled "Noise" becomes unity, its mean stays at zero, and the variance of the distribution labeled "Signal" becomes $1/b$, and its mean becomes $a/b$, as shown below. It illustrates that the inverses of Eqn. \@ref(eq:BinModabParameters) are:

\begin{equation} 
\mu=\frac{a}{b};\sigma=\frac{1}{b}
(\#eq:BinModabParametersInv)
\end{equation}

Eqns. \@ref(eq:BinModabParameters) and \@ref(eq:BinModabParametersInv) allow conversion from one notation to another.

![](06-binormal-model_files/figure-latex/unnamed-chunk-5-1.pdf) ![](06-binormal-model_files/figure-latex/unnamed-chunk-5-2.pdf) 


### Properties of the binormal model ROC curve
Using the $(a,b)$ notation, Eqn. \@ref(eq:BinModRocCurve1) for the ROC curve reduces to:

\begin{equation} 
TPF = \Phi\left ( a+ b \Phi^{-1}\left (FPF  \right ) \right )
(\#eq:BinModRocCurve)
\end{equation}

Since $\Phi^{-1}(FPF)$  is an increasing function of its argument $FPF$, and $b > 0$, the argument of the  $\Phi$ function is an increasing function of $FPF$. Since $\Phi$  is a monotonically increasing function of its argument, $TPF$ is a monotonically increasing function of $FPF$. This is true regardless of the sign of $a$. If $FPF = 0$, then $\Phi^{-1}(0) = -\infty$  and $TPF = 0$. If $FPF = 1$, then $\Phi^{-1}(1) = +\infty$ and $TPF = 1$. [The fact that $TPF$ is a monotonic increasing function of $FPF$ is consistent with the following argument: to increase $FPF$, $\zeta$  must decrease, which increases the area under the diseased distribution to the right of $\zeta$, i.e., increases $TPF$.] 

Regardless of the value of $a$, as long as $b \ge 0$, the ROC curve starts at (0,0) and ends at (1,1), increasing monotonically from the origin to (1,1).

From Eqn. \@ref(eq:BinModFPF) and Eqn. \@ref(eq:BinModTPF), the expressions for $FPF$ and $TPF$ in terms of model parameters $(a,b)$ are:

\begin{equation} 
FPF\left ( \zeta \right ) = \Phi\left ( -\zeta \right )\\
(\#eq:BinModFPFab)
\end{equation}

and

\begin{equation} 
TPF = \Phi\left ( a - b \zeta \right )
(\#eq:BinModTPFab)
\end{equation}

### pdfs of the binormal model
According to Eqn. \@ref(eq:BinModZSampling1) the probability that a z-sample is smaller than a specified threshold  $\zeta$, i.e., the CDF function, is:

\begin{equation*} 
P\left ( Z \le \zeta \mid  Z\sim N\left ( 0,1 \right ) \right ) = 1-FPF\left ( \zeta \right ) = \Phi \left ( \zeta  \right )
\end{equation*}

\begin{equation*} 
P\left ( Z \le \zeta \mid  Z\sim N\left ( \mu,\sigma^2 \right ) \right ) = 1-TPF\left ( \zeta \right ) = \Phi \left ( \frac{\zeta - \mu}{\sigma}  \right )
\end{equation*}

Since the *pdf* is the derivative of the corresponding CDF function, it follows that (the subscripts N and D denote non-diseased and diseased cases, respectively):

\begin{equation*} 
pdf_N\left ( \zeta \right ) = \frac{\partial \Phi\left ( \zeta \right )}{\partial \zeta} = \phi\left ( \zeta \right ) \equiv \frac{1}{\sqrt{2 \pi}}\exp\left ( -\frac{\zeta^2}{2} \right )
\end{equation*}

\begin{equation*} 
pdf_D\left ( \zeta \right ) = \frac{\partial \Phi\left ( \frac{\zeta - \mu}{\sigma} \right )}{\partial \zeta} = \frac{1}{\sigma} \phi\left ( \frac{\zeta - \mu}{\sigma} \right ) \equiv \frac{1}{\sqrt{2 \pi}\sigma}\exp\left ( -\frac{\left (\zeta-\mu  \right )^2}{2\sigma} \right )
\end{equation*}

The second equation can be written in $(a,b)$  notation as:

\begin{equation*} 
pdf_D\left ( \zeta \right ) = b\phi\left ( b\zeta-a \right ) = \frac{b}{\sqrt{2 \pi}}\exp\left ( -\frac{\left (b\zeta - a \right )^2}{2} \right )
\end{equation*}

Generation of pdfs for specified values of binormal model parameters was illustrated above (ref. TBA to previous chapter?) for specified values of $\mu,\sigma$. Using transformations in Eqn. \@ref(eq:BinModabParameters) the code can be readily converted to accept $(a,b)$  values as inputs.


### Fitting the ROC curve
To be described next is a method for fitting data such as in \@ref(tab:ratingsParadigmTable1) to the binormal model, i.e., determining the parameters $a,b$ and the thresholds $\zeta_r , r = 1, 2, ..., R-1$, to best fit, in some to-be-defined sense, the observed cell counts. The most common method uses an algorithm called maximum likelihood. But before getting to that, I describe the least-square method, which is conceptually simpler, but not really applicable to this type of fitting.

### Least-squares estimation
By applying the function $\Phi^{-1}$  to both sides of Eqn. (6.2.17), one gets (the "inverse" function cancels the "forward" function on the right hand side):

\begin{equation*} 
\Phi^{-1}\left ( TPF \right ) = a + b \Phi^{-1}\left ( FPF \right )
\end{equation*}

This suggests that a plot of $y = \Phi^{-1}\left ( TPF \right )$  vs. $\Phi^{-1}\left ( FPF \right )$ is expected to follow a straight line with slope b and intercept a. Fitting a straight line to such data is generally performed by the method of least-squares, a capability present in most software packages and even spreadsheets, e.g., Excel. Alternatively one can simply visually draw the best straight line that fits the points, memorably referred to7 as "chi-by-eye". This was the way parameters of the binormal model were estimated prior to Dorfman and Alf's work3. The least-squares method is a quantitative way of accomplishing the same aim. If $\left ( x_t,y_t \right )$ are the data points, one constructs $S$, the sum of the squared deviations of the observed ordinates from the predicted values:

\begin{equation*} 
S  = \sum_{i=1}^{R-1}\left ( y_i - \left ( a + bx_i \right ) \right )^2
\end{equation*} 

The idea is to minimize S with respect to the parameters $(a,b)$. One approach is to differentiate this with respect to $a$ and $b$ and equate each resulting derivate expression to zero. This yields two equations in two unknowns, which are solved for $a$ and $b$. If the reader has never done this before, one should go through these steps at least once, but it would be smarter in future to use software that does all this. In `R` the least-squares fitting function is `lm(y~x)`, which in its simplest form fits a linear model   using the method of least-squares (in case you are wondering lm stands for linear model, a whole branch of statistics in itself; in this example one is using its simplest capability).


```r
# ML estimates of a and b (from Eng JAVA program)
# a <- 1.3204; b <- 0.6075 
# # these are not used in program; just there for comparison

FPF <- c(0.017, 0.050, 0.183, 0.5)  
# this is from Table 6.11, last two rows
TPF <- c(0.440, 0.680, 0.780, 0.900)
# ...do...

PhiInvFPF <- qnorm(FPF)
# apply the PHI_INV function
PhiInvTPF <- qnorm(TPF)
# ... do ... 

fit <- lm(PhiInvTPF~PhiInvFPF)
print(fit)
#> 
#> Call:
#> lm(formula = PhiInvTPF ~ PhiInvFPF)
#> 
#> Coefficients:
#> (Intercept)    PhiInvFPF  
#>      1.3288       0.6307
pointsData <- data.frame(PhiInvFPF = PhiInvFPF, 
                         PhiInvTPF = PhiInvTPF)
pointsPlot <- ggplot(data = pointsData, 
                     mapping = 
                       aes(x = PhiInvFPF, 
                           y = PhiInvTPF)) + 
  geom_point(size = 2) + 
  theme(
    axis.title.y = element_text(size = 18,face="bold"),
    axis.title.x = element_text(size = 18,face="bold")) +
  geom_abline(
    slope = fit$coefficients[2], 
    intercept = fit$coefficients[1], size = 0.75)
print(pointsPlot)
```

![](06-binormal-model_files/figure-latex/unnamed-chunk-6-1.pdf)<!-- --> 

This plot shows operating points from Table 1, transformed by the $\Phi^{-1}$ function; the slope of the line is the least-squares estimate of the $b$ parameter and the intercept is the corresponding $a$ parameter of the binormal model.

The first two lines of the output are simply a reminder about the names of the dependent and independent variables. The last line contains the least squares estimated values, $a$ = 1.3288 and $b$ = 0.6307. The corresponding maximum likelihood estimates of these parameters, as yielded by the Eng web code, Appendix B, are listed in line 4 of the main program: $a$ = 1.3204 and $b$ = 0.6075. The estimates appear to be close, particularly the estimate of $a$ , but there are a few things wrong with the least-squares approach. First, the method of least squares assumes that the data points are independent. Because of the manner in which they are constructed, namely by cumulating points, the independence assumption is not valid for ROC operating points. Cumulating the 4 and 5 responses constrains the resulting operating point to be above and to the right of the point obtained by cumulating the 5 responses only, so the data points are definitely not independent. Similarly, cumulating the 3, 4 and 5 responses constrains the resulting operating point to be above and to the right of the point obtained by cumulating the 4 and 5 responses, and so on. The second problem is the linear least-squares method assumes there is no error in measuring x; the only source of error that is accounted for is in the y-coordinate. In fact, both coordinates of an ROC operating point are subject to sampling error. Third, disregard of error in the x-direction is further implicit in the estimates of the thresholds, which according to Eqn. (6.2.19), is given by:

\begin{equation*} 
\zeta_r = - \Phi^{-1}\left ( FPF_r \right )
\end{equation*} 

These are "rigid" estimates that assume no error in the FPF values. As was shown in Chapter \@ref(modelingBinaryTask), 95% confidence intervals apply to these estimates.

[A historical note: prior to computers and easy access to statistical functions the analyst had to use a special plotting paper, termed “double probability paper”, that converted probabilities into x and y distances using the inverse function. The complement of the inverse function is sometimes termed the z-deviate.4 Since this term confused me when I entered this field ca. 1985, and it confuses me even now, I will not use it further.]

## Maximum likelihood estimation (MLE)
The approach taken by Dorfman and Alf was to maximize the likelihood function instead of S. The likelihood function is the probability of the observed data given a set of parameter values, i.e.,

\begin{equation*} 
\text {L} \equiv P\left ( data \mid \text {parameters} \right )
\end{equation*} 

Generally "data" is suppressed, so likelihood is a function of the parameters; but "data" is always implicit. With reference to Fig. 6.1, the probability of a non-diseased case yielding a count in the 2nd bin equals the area under the curve labeled "Noise" bounded by the vertical lines at $\zeta_1$ and $\zeta_2$. In general, the probability of a non-diseased case yielding a count in the $r^\text{th}$ bin equals the area under the curve labeled "Noise" bounded by the vertical lines at  $\zeta_{r-1}$ and $\zeta_r$.  Since the area to the left of a threshold is the CDF corresponding to that threshold, the required probability is $\Phi\left ( \zeta_r \right ) - \Phi\left ( \zeta_{r-1} \right )$; we are simply subtracting two expressions for specificity, Eqn. (6.2.5). 

\begin{equation*} 
\text {count in non-diseased bin } r = \Phi\left ( \zeta_r \right ) - \Phi\left ( \zeta_{r-1} \right )
\end{equation*} 

Similarly, the probability of a diseased case yielding a count in the rth bin equals the area under the curve labeled "Signal" bounded by the vertical lines at  $\zeta_{r-1}$ and $\zeta_r$. The area under the diseased distribution to the left of threshold $\zeta_r$  is the $1 - TPF$ at that threshold:

\begin{equation*} 
1 - \Phi\left ( \frac{\mu-\zeta_r}{\sigma} \right ) = \Phi\left ( \frac{\zeta_r - \mu}{\sigma} \right )
\end{equation*} 

The area between the two thresholds is:

\begin{align*} 
P\left ( \text{count in diseased bin }r \right ) &= \Phi\left ( \frac{\zeta_r - \mu}{\sigma} \right ) - \Phi\left ( \frac{\zeta_{r-1} - \mu}{\sigma} \right ) \\
&= \Phi\left ( b\zeta_r-a \right ) - \Phi\left ( b\zeta_{r-1}-a \right )
\end{align*}

Let $K_{1r}$  denote the number of non-diseased cases in the rth bin, and $K_{2r}$  denotes the number of diseased cases in the rth bin. Consider the number of counts $K_{1r}$ in non-diseased case bin $r$. Since the probability of each count is  $\Phi\left ( \zeta_{r+1}  \right ) - \Phi\left ( \zeta_r  \right )$, the probability of the observed number of counts, assuming the counts are independent, is  ${\left(\Phi\left ( \zeta_{r+1}  \right ) - \Phi\left ( \zeta_r  \right )  \right )}^{K_{1r}}$. Similarly, the probability of observing  counts in diseased case bin $r$ is ${\left (\Phi\left ( b\zeta_{r+1}-a  \right ) - \Phi\left ( b\zeta_r-a  \right )  \right )}^{K_{2r}}$, subject to the same independence assumption. The probability of simultaneously observing $K_{1r}$  counts in non-diseased case bin r and $K_{2r}$  counts in diseased case bin $r$ is the product of these individual probabilities (again, an independence assumption is being used): 

\begin{equation*} 
\left (\Phi\left ( \zeta_{r+1}  \right ) - \Phi\left ( \zeta_r  \right )  \right )^{K_{1r}} \left (\Phi\left ( b\zeta_{r+1}-a  \right ) - \Phi\left ( b\zeta_r-a  \right )  \right )^{K_{2r}}
\end{equation*} 

Similar expressions apply for all integer values of $r$ ranging from $1,2,...,R$. Therefore the probability of observing the entire data set is the product of expressions like Eqn. (6.4.5), over all values of $r$:

\begin{equation} 
\prod_{r=1}^{R}\left [\left (\Phi\left ( \zeta_{r+1}  \right ) - \Phi\left ( \zeta_r  \right )  \right )^{K_{1r}} \left (\Phi\left ( b\zeta_{r+1}-a  \right ) - \Phi\left ( b\zeta_r-a  \right )  \right )^{K_{2r}}  \right ]
(\#eq:BinModProductProb)
\end{equation} 

We are almost there. A specific combination of $K_{11},K_{12},...,K_{1R}$ counts from $K_1$ non-diseased cases and counts $K_{21},K_{22},...,K_{2R}$ from $K_2$ diseased cases can occur the following number of times (given by the multinomial factor shown below):

\begin{equation} 
\frac{K_1!}{\prod_{r=1}^{R}K_{1r}!}\frac{K_2!}{\prod_{r=1}^{R}K_{2r}!}
(\#eq:BinModCombFactor)
\end{equation} 

The likelihood function is the product of Eqn. \@ref(eq:BinModProductProb) and Eqn.  \@ref(eq:BinModCombFactor):

\begin{equation} 
\begin{split}
L\left ( a,b,\overrightarrow{\zeta} \right ) &= \left (\frac{K_1!}{\prod_{r=1}^{R}K_{1r}!}\frac{K_2!}{\prod_{r=1}^{R}K_{2r}!}  \right ) \times \\
&\quad\prod_{r=1}^{R}\left [\left (\Phi\left ( \zeta_{r+1}  \right ) - \Phi\left ( \zeta_r  \right )  \right )^{K_{1r}} \left (\Phi\left ( b\zeta_{r+1}-a  \right ) - \Phi\left ( b\zeta_r-a  \right )  \right )^{K_{2r}}  \right ]
\end{split}
(\#eq:BinModLikelihood)
\end{equation}

The left hand side of Eqn. \@ref(eq:BinModLikelihood) shows explicitly the dependence of the likelihood function on the parameters of the model, namely $a,b,\overrightarrow{\zeta}$, where the vector of thresholds $\overrightarrow{\zeta}$ is a compact notation for the set of thresholds $\zeta_1,\zeta_2,...,\zeta_R$, (note that since $\zeta_0 = -\infty$, and $\zeta_R = +\infty$, only $R-1$ free threshold parameters are involved, and the total number of free parameters in the model is $R+1$). For example, for a 5-rating ROC study, the total number of free parameters is 6, i.e., $a$, $b$ and 4 thresholds $\zeta_1,\zeta_2,\zeta_3,\zeta_4$.

Eqn.  \@ref(eq:BinModLikelihood) is forbidding but here comes a simplification. The difference of probabilities such as $\Phi\left ( \zeta_r  \right )-\Phi\left ( \zeta_{r-1}  \right )$ is guaranteed to be positive and less than one [the $\Phi$ function is a probability, i.e., in the range 0 to 1, and since $\zeta_r$ is greater than $\zeta_{r-1}$, the difference is positive and less than one]. When the difference is raised to the power of $K_{1r}$ (a non-negative integer) a very small number can result. Multiplication of all these small numbers may result in an even smaller number, which may be too small to be represented as a floating-point value, especially as the number of counts increases. To prevent this we resort to a trick. Instead of maximizing the likelihood function $L\left ( a,b,\overrightarrow{\zeta} \right )$ we choose to maximize the logarithm of the likelihood function (the base of the logarithm is immaterial). The logarithm of the likelihood function is: 

\begin{equation} 
LL\left ( a,b,\overrightarrow{\zeta} \right )=\log \left ( L\left ( a,b,\overrightarrow{\zeta} \right ) \right )
(\#eq:BinModLogLikelihood)
\end{equation} 

Since the logarithm is a monotonically increasing function of its argument, maximizing the logarithm of the likelihood function is equivalent to maximizing the likelihood function. Taking the logarithm converts the product symbols in Eqn. (6.4.8) to summations, so instead of multiplying small numbers one is adding them, thereby avoiding underflow errors. Another simplification is that one can ignore the logarithm of the multinomial factor involving the factorials, because these do not depend on the parameters of the model. Putting all this together, we get the following expression for the logarithm of the likelihood function:

\begin{equation} 
\begin{split}
LL\left ( a,b,\overrightarrow{\zeta} \right ) \propto& \sum_{r=1}^{R} K_{1r}\log \left ( \Phi\left ( \zeta_{r+1} \right ) - \Phi\left ( \zeta_r \right ) \right ) \\
&+ \sum_{r=1}^{R} K_{2r}\log \left ( \Phi\left (b \zeta_{r+1} - a \right ) - \Phi\left ( b \zeta_r - a \right ) \right ) 
\end{split}
(\#eq:BinModLL)
\end{equation} 

The left hand side of Eqn. \@ref(eq:BinModLL) is a function of the model parameters $a,b,\overrightarrow{\zeta}$ and the observed data, the latter being the counts contained in the vectors $\overrightarrow{K_1}$ and $\overrightarrow{K_2}$, where the vector notation is used as a compact form for the counts $K_{11},K_{12},...,K_{1R}$ and $K_{21},K_{22},...,K_{2R}$, respectively. The right hand side of Eqn. \@ref(eq:BinModLL) is monotonically related to the probability of observing the data given the model parameters $a,b,\overrightarrow{\zeta}$. If the choice of model parameters is poor, then the probability of observing the data will be small and log likelihood will be small. With a better choice of model parameters the probability and log likelihood will increase. With optimal choice of model parameters the probability and log likelihood will be maximized, and the corresponding optimal values of the model parameters are called maximum likelihood estimates (MLEs). These are the estimates produced by the programs RSCORE and ROCFIT. 

### Code implementing MLE


```r

# ML estimates of a and b (from Eng JAVA program)
# a <- 1.3204; b <- 0.6075 
# these are not used in program; just there for comparison

K1t <- c(30, 19, 8, 2, 1)
K2t <- c(5,  6, 5, 12, 22)
dataset <- Df2RJafrocDataset(K1t, K2t, InputIsCountsTable = TRUE)
retFit <- FitBinormalRoc(dataset)
retFit[1:5]
#> $a
#> [1] 1.320453
#> 
#> $b
#> [1] 0.6074929
#> 
#> $zetas
#>    zetaFwd1    zetaFwd2    zetaFwd3    zetaFwd4 
#> 0.007680547 0.896273068 1.515647850 2.396722099 
#> 
#> $AUC
#> [1] 0.8704522
#> 
#> $StdAUC
#>            [,1]
#> [1,] 0.03790423
print(retFit$fittedPlot)
```

![](06-binormal-model_files/figure-latex/unnamed-chunk-7-1.pdf)<!-- --> 

Note the usage of the `RJafroc` package [@R-RJafroc]. Specifically, the function `FitBinormalRoc`. The ratings table is converted to an `RJafroc` dataset object, followed by application of the fitting function. The results, contained in `retFit` should be compared to those obtained from the [website implementation of ROCFIT](http://www.rad.jhmi.edu/jeng/javarad/roc/JROCFITi.html).

### Validating the fitting model
The above ROC curve is a good visual fit to the observed operating points. Quantification of the validity of the fitting model is accomplished by calculating the Pearson goodness-of-fit test [@RN2656], also known as the chi-square test, which uses the statistic defined by [@RN1492]:

\begin{equation} 
C^2=\sum_{t=1}^{2}\sum_{r=1}^{R}\frac{\left (K_{tr}-\left \langle K_{tr} \right \rangle  \right )^2}{\left \langle K_{tr} \right \rangle}\\
K_{tr} \geq 5
(\#eq:BinModGoodnessFit)
\end{equation} 

The expected values are given by:

\begin{equation}
\begin{split}
\left \langle K_{1r} \right \rangle &=K_1\left ( \Phi\left ( \zeta_{r+1} \right ) - \Phi\left ( \zeta_r \right )  \right ) \\
\left \langle K_{2r} \right \rangle &=K_2\left ( \Phi\left ( a\zeta_{r+1}-b \right ) - \Phi\left ( a\zeta_r - b\right )  \right )
\end{split}
(\#eq:BinModGoodnessFitExpVals)
\end{equation} 

These expressions should make sense: the difference between the two CDF functions is the probability of a count in the specified bin, and multiplication by the total number of relevant cases should yield the expected counts (a non-integer). 

It can be shown that under the null hypothesis that the assumed probability distribution functions for the counts equals the true probability distributions, i.e., the model is valid, the statistic $C^2$ is distributed as:

\begin{equation} 
C^2\sim \chi_{df}^{2}
(\#eq:BinModGoodnessFitDistr)
\end{equation} 

Here $C^2\sim \chi_{df}^{2}$  is the chi-square distribution with degrees of freedom  *df* defined by:

\begin{equation} 
df=\left ( R-1 \right )+\left ( R-1 \right )-\left (2+ R-1 \right )=\left ( R-3 \right )
(\#eq:BinModGoodnessFitdf)
\end{equation} 

The right hand side of the above equation has been written in an expansive form to illustrate the general rule: for $R$ non-diseased cells in the ratings table, the degree of freedom is $R-1$: this is because when all but one cells are specified, the last is determined, because they must sum to $K_1$ . Similarly, the degree of freedom for the diseased cells is also $R-1$. Last, we need to subtract the number of free parameters in the model, which is $(2+R-1)$, i.e., the  $a,b$ parameters and the $R-1$ thresholds. It is evident that if $R = 3$ then $df = 0$. In this situation, there are only two non-trivial operating points and the straight-line fit shown will pass through both of them. With two basic parameters, fitting two points is trivial, and goodness of fit cannot be calculated.

Under the null hypothesis (i.e., model is valid) $C^2$ is distributed as $\chi_{df}^{2}$. Therefore, one computes the probability that this statistic is larger than the observed value, called the *p-value*. If this probability is very small, that means that the deviations of the observed values of the cell counts from the expected values are so large that it is unlikely that the model is correct. The degree of unlikeliness is quantified by the p-value. Poor fits lead to small p values.

At the 5% significance level, one concludes that the fit is not good if $p < 0.05$. In practice one occasionally accepts smaller values of $p$, $p > 0.001$ before completely abandoning a model. It is known that adoption of a stricter criterion, e.g., $p > 0.05$, can occasionally lead to rejection of a retrospectively valid model [@RN300].

### Estimating the covariance matrix
TBA See book chapter 6.4.3. This is implemented in RJafroc.

### Estimating the variance of Az
TBA See book chapter 6.4.4. This is implemented in RJafroc.

### Single FOM derived from ROC curve
Sensitivity and specificity are *dual* measures of overall performance. It is hard to unambiguosly compare two systems usng dual measures. What if sensitivity is higher for one system but specificity is higher for another. This is, of course, a consequence of sensitivity/specificity depending on the position of the operating point on the ROC curve. Desirable is a *single* measure of performance that takes into account performance over the entire ROC curve. Two commonly used measures are the binormla model predicted area $A_z$ under the ROC curve, and the $d'$ index. 

(Book) Appendix 6.A derives the formula for the partial area under the unequal-variance binormal model. A special case of this formula is the area under the whole ROC curve, reproduced below using both parameterizations of the model:

\begin{equation} 
A_z=\Phi\left ( \frac{a}{\sqrt{1+b^2}} \right )=\Phi\left ( \frac{\mu}{\sqrt{1+\sigma^2}} \right )
(\#eq:BinModab2Az)
\end{equation} 

The binormal fitted AUC increases as $a$ increases or as $b$ decreases. Equivalently, it increases as $\mu$ increases or as $\sigma$ decreases. An equivalent $d'$ parameter is defined as the separation of two unit-variance normal distributions yielding the same AUC as that predicted by the $(a,b)$ parameter binormal model. It is defined by:

\begin{equation} 
d'=\sqrt{2}\Phi^{-1}\left ( A_z \right )
(\#eq:BinModab2dprime)
\end{equation} 


## Discussion
The binormal model is historically very important and the contribution by Dorfman and Alf [@RN212] was seminal. Prior to their work, there was no valid way of estimating AUC from observed ratings counts. Their work and a key paper by Lusted [@RN1487] accelerated research using ROC methods. The number of publications using their algorithm, and the more modern versions developed by Metz and colleagues, is probably well in excess of 500. Because of its key role, the author has endeavored to take out some of the mystery about how the binormal model parameters are estimated. In particular, a common misunderstanding that the binormal model assumptions are violated by real datasets, when in fact it is quite robust to apparent deviations from normality, is addressed. 

A good understanding of this chapter should enable the reader to better understand alternative ROC models, discussed later.

It has been stated that the `b`-parameter of the binormal model is generally observed to be less than one, consistent with the diseased distribution being wider than the non-diseased one. The ROC literature is largely silent on the reason for this finding. One reason, namely location uncertainty, is presented in Chapter "Predictions of the RSM", where RSM stands for Radiological Search Model. Basically, if the location of the lesion is unknown, then z-samples from diseased cases can be of two types, samples from the correct lesion location, or samples from other non-lesion locations. The resulting mixture distribution will then appear to have larger variance than the corresponding samples from non-diseased cases. This type of mixing need not be restricted to location uncertainty. Even is location is known, if the lesions are non-homogenous (e.g., they contain a range of contrasts) then a similar mixture-distribution induced broadening is expected. The contaminated binormal model (CBM) - see Chapter TBA - also predicts that the diseased distribution is wider than the non-diseased one.

The fact that the `b`-parameter is less than unity implies that the predicted ROC curve is improper, meaning its slope is not monotone decreasing as the operating point moves up the curve. The result is that a portion of the curve, near (1,1) that crosses the chance-diagonal and hooks upward approaching (1,1) with infinite slope. Ways of fitting proper ROC curves are described in Chapter "Other proper ROC models". Usually the hook is not readily visible, which has been used as an excuse to ignore the problem. For example, in Fig. 6.4, one would have to "zoom-in" on the upper right corner to see it, but the reader should make no mistake about it, the hook is there as  . 

A recent example is Fig. 1 in the publication resulting from the Digital Mammographic Imaging Screening Trial (DMIST) clinical trial [@RN1784] involving 49,528 asymptomatic women from 33 clinical sites and involving 153 radiologists, where each of the film modality ROC plots crosses the chance diagonal and hooks upwards to (1,1), which as is known, results anytime  .

The unphysical nature of the hook (predicting worse than chance-level performance for supposedly expert readers) is not the only reason for seeking alternate ROC models. The binormal model is susceptible to degeneracy problems. If the dataset does not provide any interior operating points (i.e., all observed points lie on the axes defined by FPF = 0 or TPF = 1) then the model fits these points with b = 0. The resulting straight-line segment fits do not make physical sense. These problems are addressed by the contaminated binormal model16 to be discussed in Chapter "Other proper ROC models". The first paper in the series has particularly readable accounts of data degeneracy.

To this day the binormal model is widely used to fit ROC datasets. In spite of its limitations, the binormal model has been very useful in bringing a level of quantification to this field that did not exist prior to the work [@RN212] by Dorfman and Alf.


## Summary{#BinMod-Summary}
## Discussion{#BinMod-Discussion}
## References {#BinMod-references}



<!--chapter:end:06-binormal-model.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Hypothesis Testing {#HypothesisTesting}



## Introduction {#HypothesisTesting-introduction}
The problem addressed here is how to decide whether an estimate of AUC is consistent with a pre-specified value. One example of this is when a single-reader rates a set of cases in a single-modality, from which one estimates AUC, and the question is whether the estimate is statistically consistent with a pre-specified value. From a clinical point of view, this is generally not a useful exercise, but its simplicity is conducive to illustrating the broader concepts involved in this and later chapters. The clinically more useful analysis is when multiple readers interpret the same cases in two or more modalities. [With two modalities, for example, one obtains an estimate AUC for each reader in each modality, averages the AUC values over all readers within each modality, and computes the inter-modality difference in reader-averaged AUC values. The question forming the main subject of this book is whether the observed difference is consistent with zero.]

Each situation outlined above admits a binary (yes/no) answer, which is different from the estimation problem that was dealt with in connection with the maximum likelihood method in (book) Chapter 06, where one computed numerical estimates (and confidence intervals) of the parameters of the fitting model. 

**Hypothesis testing is the process of dichotomizing the possible outcomes of a statistical study and then using probabilistic arguments to choose one option over the other.**

The two options are termed the *null hypothesis* (NH) and the *alternative hypothesis* (AH). The hypothesis testing procedure is analogous to the jury trial system in the US, with 20 instead of 12 jurors, with the NH being the presumption of innocence and the AH being the defendant is guilty. The decision rule is to assume the defendant is innocent unless all 20 jurors agree the defendant is guilty. If even one juror disagrees, the defendant is deemed innocent (equivalent to choosing an $\alpha$ – defined below - of 0.05, or 1/20). 

## Single-modality single-reader ROC study
The binormal model described in Chapter 06 can be used to generate sets of ratings to illustrate the methods being described in this chapter. To recapitulate, the model is described by:

\begin{align*} 
Z_{k_11} &\sim N\left ( 0,1 \right ) \\ 
Z_{k_22} &\sim N\left ( \mu,\sigma^2 \right )
\end{align*} 

The following code chunk encodes the `Wilcoxon` function:


```r
Wilcoxon <- function (zk1, zk2)
{
  K1 = length(zk1)
  K2 = length(zk2)
  W <- 0
  for (k1 in 1:K1) {
    W <- W + sum(zk1[k1] < zk2)
    W <- W + 0.5 * sum(zk1[k1] == zk2)
  }
  W <- W/K1/K2
  return (W)
}
```

In the next code chunk we set $\mu = 1.5$ and $\sigma = 1.3$ and simulate $K_1 = 50$ non-diseased cases and  $K_2 = 52$ diseased cases. The `for`-loop draws 50 samples from the $N(0,1)$ distribution and 52 samples from the $N(\mu,\sigma^2)$ distribution, calculates the empirical AUC using the Wilcoxon, and the process is repeated 10,000 times, the AUC values are saved to a huge array `AUC_c` (the c-subscript is for case sample, where each case sample represents 102 cases). After exit from the `for`-loop we calculate the mean and standard deviation of the `AUC` values. 


```r
seed <- 1;set.seed(seed)
mu <- 1.5;sigma <- 1.3;K1 <- 50;K2 <- 52

# cheat to find the population mean and std. dev.
AUC_c <- array(dim = 10000)
for (c in 1:length(AUC_c)) {
  zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = mu, sd = sigma)  
  AUC_c[c] <- Wilcoxon(zk1, zk2)
}
meanAUC   <-  mean(AUC_c);sigmaAUC  <-  sd(AUC_c)
cat("pop mean AUC_c = ", meanAUC, 
    ", pop sigma AUC_c = ", sigmaAUC, "\n")
#> pop mean AUC_c =  0.819178 , pop sigma AUC_c =  0.04176683
```

By the simple (if unimaginative) approach of sampling 10,000 times, one has estimates of the *population* mean and standard deviation of empirical AUC, denoted below by $AUC_{pop}$ and $\sigma_{\text{AUC}}$, respectively.

The next code-chunk simulates one more independent ROC study with the same numbers of cases, and the resulting area under the empirical curve is denoted AUC in the code. 


```r
# one more trial, this is the one we want 
# to compare to meanAUC
zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = mu, sd = sigma) 
AUC <- Wilcoxon(zk1, zk2)
cat("New AUC = ", AUC, "\n")
#> New AUC =  0.8626923

z <- (AUC - meanAUC)/sigmaAUC
cat("z-statistic = ", z, "\n")
#> z-statistic =  1.04184
```

Is the new value, 0.8626923, sufficiently different from the population mean, 0.819178, to reject the null hypothesis $NH: \text{AUC} = \text{AUC}_{pop}$? Note that the answer to this question can be either yes or no: equivocation is not allowed!

The new value is "somewhat close" to the population mean, but how does one decide if "somewhat close" is close enough? Needed is the statistical distribution of the random variable $\text{AUC}$ under the hypothesis that the true mean is $\text{AUC}_{pop}$. In the limit of a large number of cases, the pdf of $\text{AUC}$  under the null hypothesis is a normal distribution  $N\left ( \text{AUC}_{pop}, \sigma_{\text{AUC}}^{2} \right )$:

\begin{equation*} 
\text{pdf}_{\text{AUC}}\left ( \text{AUC}\mid \text{AUC}_{pop}, \sigma_{\text{AUC}} \right )=\frac{1}{\sigma_{\text{AUC}}\sqrt{2\pi}}exp\left ( -\frac{1}{2} \left ( \frac{\text{AUC}-\text{AUC}_{pop}}{\sigma_{\text{AUC}}} \right )^2\right )
\end{equation*} 

The translated and scaled value is distributed as a unit normal distribution, i.e., 

\begin{equation*} 
Z \equiv \frac{\text{AUC}-\text{AUC}_{pop}}{\sigma_{\text{AUC}}}\sim N\left ( 0,1 \right )
\end{equation*} 

[The $Z$ notation here should not be confused with z-sample, decision variable or rating of a case in an ROC study; the latter, when sampled over a set of non-diseased and diseased cases, yield a realization of $\text{AUC}$. The author trusts the distinction will be clear from the context.] The observed magnitude of $z$ is 1.0418397. [Upper-case for random variable, lower-case for realized or observed value.]

**The ubiquitous p-value is the probability that the observed magnitude of $z$, or larger, occurs under the null hypothesis (NH) that the true mean of $Z$ is zero.** Stated somewhat differently, but equivalently, it is the probability that a random sample from $N(0,1)$ exceeds $z$. 

The p-value corresponding to an observed $z$ of 1.0418397 is given by:

\begin{align*} 
\Pr\left ( \lvert Z \rvert \geq \lvert z \rvert \mid Z\sim N\left ( 0,1 \right )\right )&=\Pr\left ( \lvert Z \rvert \geq 1.042 \mid Z\sim N\left ( 0,1 \right )\right )\\
&= 2\Phi\left ( -1.042 \right )\\
&= 0.2975
\end{align*} 

To recapitulate statistical notation, $\Pr\left ( \lvert Z \rvert \geq \lvert z \rvert \mid Z\sim N\left ( 0,1 \right )\right )$ is parsed as  $\Pr\left ( A\mid  B \right )$, that is, the probability $\lvert Z \rvert \geq \lvert z \rvert$  given that $Z\sim N\left ( 0,1 \right )$. The second line in the preceding equation follows from the symmetry of the unit normal distribution, i.e., the area above 1.042 must equal the area below -1.042. 

Since $z$ is a continuous variable, there is zero probability that a sampled value will exactly equal the observed value. Therefore, one must pose the statement as above, namely the probability that $Z$ is at least as extreme as the observed value (by "extreme" I mean further from zero, in either positive or negative directions). If the observed was $z$ = 2.5 then the corresponding p-value would be  $2\Phi(-2.5)$=0.01242, which is smaller than 0.2975. Under the zero-mean null hypothesis, the larger the magnitude of the observed value $z$, the smaller the p-value, and the more unlikely that the data supports the NH. **The p-value can be interpreted as the degree of unlikelihood that the data is consistent with the NH.** 

By convention one adopts a fixed value of the probability, denoted  and usually $\alpha$ = 0.05, which is termed *the significance level* of the test, and the decision rule is to reject the null hypothesis if the observed p-value < $\alpha$. $\alpha$ is also referred to as the *size* of the test. 

\begin{equation*} 
p < \alpha \Rightarrow \text{Reject NH}
\end{equation*} 

If the p-value is exactly 0.05 (unlikely with ROC analysis, but one needs to account for it), then one does not reject the NH. In the 20-juror analogy, of one juror insists the defendant is not guilty, the observed p-value is 0.05, and one does not reject the NH that the defendant is innocent (the double negatives, very common in statistics, can be confusing; in plain English, the defendant goes home).

According to the previous discussion, the critical magnitude of $z$ that determines whether to reject the null hypothesis is given by:

\begin{equation*} 
z_{\alpha / 2}=-\Phi^{-1}\left ( {\alpha/2} \right )
\end{equation*} 

For $\alpha$ = 0.05 this evaluates to 1.95996 (which is sometimes rounded up to two, good enough for "government work" as the saying goes) and the decision rule is to reject the null hypothesis only if the observed magnitude of $z$ is larger than $z_{\alpha/2}$. 

**The decision rule based on comparing the observed z to a critical value is equivalent to a decision rule based on comparing the observed p-value to $\alpha$. It is also equivalent, as will be shown later, to a decision rule based on a $\left ( 1-\alpha \right )$  confidence interval for the observed statistic. One rejects the NH if the closed confidence interval does not include zero.**

## Type-I errors
Just because one rejects the null hypothesis does not mean that the null hypothesis is false. Following the decision rule puts an upper limit on, or "caps", the probability of incorrectly rejecting the null hypothesis at $\alpha$. In other words, by agreeing to reject the NH only if $p \leq \alpha$, one has set an upper limit, namely  $\alpha$, on errors of this type, termed *Type-I* errors. These could be termed false positives in the hypothesis testing sense, not to be confused with false positive occurring on individual case-level decisions. According to the definition of $\alpha$:

\begin{equation*} 
\Pr( \text{Type I error} \mid \text{NH} )=\alpha
\end{equation*} 

To demonstrate the ideas one needs to have a very cooperative reader interpreting new sets of independent cases not just one more time, but 2000 more times (the reason for the 2000 trials will be explained below). The simulation code follows:


```r
seed <- 1;set.seed(seed)
mu <- 1.5;sigma <- 1.3;K1 <- 50;K2 <- 52

nTrials <- 2000
alpha <- 0.05 # size of test
reject = array(0, dim = nTrials)
for (trial in 1:length(reject)) {  
  zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = mu, sd = sigma)  
  AUC <- Wilcoxon(zk1, zk2)  
  z <- (AUC - meanAUC)/sigmaAUC
  p <- 2*pnorm(-abs(z)) # p value for individual trial
  if (p < alpha) reject[trial] = 1 
}

CI <- c(0,0); width <- -qnorm(alpha/2)
ObsvdTypeIErrRate <- sum(reject)/length(reject)
CI[1] <- ObsvdTypeIErrRate - 
  width*sqrt(ObsvdTypeIErrRate*(1-ObsvdTypeIErrRate)/nTrials)
CI[2] <- ObsvdTypeIErrRate + 
  width*sqrt(ObsvdTypeIErrRate*(1-ObsvdTypeIErrRate)/nTrials)
cat("alpha = ", alpha, "\n")
#> alpha =  0.05
cat("ObsvdTypeIErrRate = ", ObsvdTypeIErrRate, "\n")
#> ObsvdTypeIErrRate =  0.0535
cat("95% confidence interval = ", CI, "\n")
#> 95% confidence interval =  0.04363788 0.06336212
exact <- binom.test(sum(reject),n = 2000,p = alpha)
cat("exact 95% CI = ", as.numeric(exact$conf.int), "\n")
#> exact 95% CI =  0.04404871 0.06428544
```

The population means were calculated in an earlier code chunk. One initializes `NTrials` to 2000 and $\alpha$ to 0.05. The `for-loop` describes our captive reader interpreting independent sets of cases 2000 times. *Each completed interpretation of 102 cases is termed a trial.* For each trial one calculates the observed value of `AUC`, the observed `z` statistic and the the observed p-value. The observed p-value is compared against the fixed value $\alpha$ and one sets the corresponding `reject[trial]` flag to unity if $p < \alpha$. In other words, if the trial-specific p-value is less than $\alpha$ one counts an instance of rejection of the null hypothesis. The process is repeated 2000 times.

Upon exit from the for-loop, one calculates the observed Type-I error rate, denoted `ObsvdTypeIErrRate` by summing the reject array and dividing by 2000. One calculates a 95% confidence interval for `ObsvdTypeIErrRate` based on the binomial distribution, as in (book) Chapter 03. 

The observed Type-I error rate is a realization of a random variable, as is the estimated 95% confidence interval. The fact that the confidence interval includes $\alpha$ = 0.05 is no coincidence - it shows that the hypothesis testing procedure is working as expected. To distinguish between the selected $\alpha$ (a fixed value) and that observed in a simulation study (a realization of a random variable), the term *empirical $\alpha$* is sometimes used to denote the observed rejection rate.

It is a mistake to state that one wishes to minimize the Type-I error probability. The minimum value of $\alpha$ (a probability) is zero. Run the software with this value of $\alpha$: one finds that the NH is never rejected. The downside of minimizing the expected Type-I error rate is that the NH will never be rejected, even when the NH is patently false. The aim of a valid method of analyzing the data is not minimizing the Type-I error rate, rather, the observed Type-I error rate should equal the specified value of $\alpha$ (0.05 in our example), allowance being made for the inherent variability in it’s estimate. This is the reason 2000 trials were chosen for testing the validity of the NH testing procedure. With this choice, the 95% confidence interval, assuming that observed value is close to 0.05, is roughly ±0.01 as explained next. 

Following analogous reasoning to (book) Chapter 03, Eqn. (3.10.10), and defining $f$ as the observed rejection fraction over $T$ trials, and as usual, $F$ is a random variable and $f$ a realized value, 

\begin{equation*} 
\sigma_f = \sqrt{f(1-f)/T} \\
F \sim N\left ( f,\sigma_{f}^{2} \right )
\end{equation*} 

An approximate $(1-\alpha)100$ percent CI for $f$  is:

\begin{equation*} 
{CI}_f = \left [ f-z_{\alpha/2}\sigma_f, f+z_{\alpha/2}\sigma_f \right ]
\end{equation*} 

If $f$ is close to 0.05, then for 2000 trials, the 95% CI for $f$ is $f \pm 0.01$, i.e.,  `qnorm(alpha/2) * sqrt(.05*(.95)/2000)` = 0.009551683 ~ 0.01.

The only way to reduce the width of the CI, and thereby run a more stringent test of the validity of the analysis, is to increase the number of trials $T$. Since the width of the CI depends on the inverse square root of the number of trials, one soon reaches a point of diminishing returns. Usually $T = 2000$ trials are enough for most statisticians and the author, but examples using more simulations have been published.

## One vs. two sided tests
The test described above is termed 2-tailed. Here, briefly, is the distinction between 2-tailed vs. 1-tailed p-values:


```r
alpha  <- 0.05
# Example 1
# p value for two-sided AH
p2tailed <- pnorm(-abs(z)) + (1-pnorm(abs(z))) 
cat("pvalue 2-tailed, AH: z ne 0 = ", p2tailed, "\n")
#> pvalue 2-tailed, AH: z ne 0 =  0.2943993

# Example 2
# p value for one-sided AH gt 0
p1tailedGT <- 1-pnorm(z) 
cat("pvalue 1-tailed, AH: z gt 0 = ", p1tailedGT, "\n")
#> pvalue 1-tailed, AH: z gt 0 =  0.8528004

# Example 2
# p value for one-sided AH lt 0 
p1tailedLT <- pnorm(z)
cat("pvalue 1-tailed, AH: z lt 0 = ", p1tailedGT, "\n")
#> pvalue 1-tailed, AH: z lt 0 =  0.8528004

df <- data.frame(p2tailed = p2tailed,
                 p1tailedGT = p1tailedGT,
                 p1tailedGT = p1tailedGT)
print(df)
#>    p2tailed p1tailedGT p1tailedGT.1
#> 1 0.2943993  0.8528004    0.8528004
```

The only difference between these tests is in how the alternative hypotheses is stated. 

* For a two-tailed test the alternative hypothesis is $\text{AUC} \ne \text{AUC}_{pop}$. Large deviations, in either direction, cause rejection of the NH.
* For the first one-tailed test the alternative hypothesis is $\text{AUC} > \text{AUC}_{pop}$. Large positive observed values of $z$ result in rejection of the NH. Large negative values do not.
* For the second one-tailed test the alternative hypothesis is $\text{AUC} < \text{AUC}_{pop}$. Large negative observed values of $z$ result in rejection of the NH. Large positive values do not.
* The last two statements are illustrated below with the following code-fragments:


```r
# p1tailedGT
1-pnorm(1) # do not reject
#> [1] 0.1586553
1-pnorm(2) # reject
#> [1] 0.02275013
1-pnorm(-2) # do not reject
#> [1] 0.9772499

# p1tailedGT
pnorm(-1) # do not reject
#> [1] 0.1586553
pnorm(-2) # reject
#> [1] 0.02275013
pnorm(2) # do not reject
#> [1] 0.9772499
```

Note that the p-value of the 1-tailed tests are half that of the 2-tailed test. Further discussion of the difference between 2-tailed and 1-tailed tests, and when the latter might be appropriate, is given below.

If the null hypothesis is rejected anytime the magnitude of the observed value of $z$ exceeded the critical value $-\Phi^{-1}\left ( {\alpha/2} \right)$. This is a statement of the alternative hypothesis (AH) $\text{AUC}\neq \text{AUC}_{pop}$, in other words too high or too low values of $z$ *both* result in rejection of the null hypothesis. This is referred to as a two-sided AH and the resulting p-value is termed a *two-sided* p-value. This is the most common one used in the literature.

Suppose the additional trial performed by the radiologist was performed after an intervention following which the radiologist’s performance is expected to increase. To make matters clearer, assume the interpretations in the 10,000 trials used to estimate $\text{AUC}_{pop}$ were performed with the radiologist wearing an old pair of eye-glasses, possibly out of proper strength, and the additional trial is performed after the radiologist gets a new set of prescription eye-glasses. Because the radiologist’s eyesight has improved, the expectation is that performance should increase. In this situation, it is appropriate to use the one-sided alternative hypothesis $\text{AUC} > \text{AUC}_{pop}$. Now, large positive values of $z$ result in rejection of the null hypothesis, but large negative  values do not. The critical value of $z$ is defined by $z_\alpha = \Phi\left ( 1-\alpha \right )$, which for $\alpha$ = 0.05 is 1.645 (i.e., `qnorm(1-alpha) = 1.644854`). Compare 1.64 to the critical value  $-\Phi^{-1}\left ( {\alpha/2} \right)$ = 1.96 for a two-sided test. If the change is in the expected direction, it is more likely that one will reject the NH with a one-sided than with a two-sided test. The p-value for a one-sided test is given by: 

\begin{equation*} 
\Pr\left ( Z \geq 1.042 \mid \text{NH} \right ) = \Phi \left (-1.042  \right ) = 0.1487
\end{equation*} 

Notice that this is half the corresponding two-sided test p-value; this is because one is only interested in the area under the unit normal that is above the observed value of $z$. If the intent is to obtain a significant finding, it is tempting to use one-sided tests. The down side of a one-sided test is that even with a large excursion of the observed $z$ in the other direction one cannot reject the null hypothesis. So if the new eye-glasses are so bad as to render the radiologist practically blind (think of a botched cataract surgery) the observed $z$ would be large and negative, but one cannot reject the null hypothesis $\text{AUC}=\text{AUC}_{pop}$.

The one-sided test could be run the other way, with the alternative hypothesis being stated as $\text{AUC}<\text{AUC}_{pop}$. Now, large negative excursions of the observed value of AUC cause rejection of the null hypothesis, but large positive excursions do not. The critical value is defined by  $z_\alpha = \Phi^{-1}\left (\alpha  \right )$, which for $\alpha$ = 0.05  is -1.645. The p-value is given by (note the reversed sign compared to the previous one-sided test:

\begin{equation*} 
\Pr\left ( Z \leq 1.042 \mid \text{NH}  \right ) = \Phi(1.042) = 1 - 0.1487 = 0.8513
\end{equation*} 

This is the complement of the value for a one-sided test with the alternative hypothesis going the other way: obviously the probability that $Z$ is smaller than the observed value (1.042) plus the probability that $Z$ is larger than the same value must equal one. 

## Statistical power
So far, focus has been on the null hypothesis. The Type-I error probability was introduced, defined as the probability of incorrectly rejecting the null hypothesis, the control, or "cap" on which is  $\alpha$, usually set to 0.05. What if the null hypothesis is actually false and the study fails to reject it? This is termed a Type-II error, the control on which is denoted  $\beta$, the probability of a Type-II error. **The complement of $\beta$  is called statistical power.** 

The following table summarizes the two types of errors and the two correct decisions that can occur in hypothesis testing. In the context of hypothesis testing, a Type-II error could be termed a false negative, not to be confused with false negatives occurring on individual case-level decisions. 

Truth           Fail to reject NH        Reject NH
---------       ------------------       ----------------
NH is True        1 - $\alpha$             $\alpha$ (FPF)
NH is False       $\beta$ (FNF)            Power = 1 - $\beta$


This resembles the 2 x 2 table encountered in (book) Chapter 02, which led to the concepts of $FPF$, $TPF$ and the ROC curve. Indeed, it is possible think of an analogous plot of empirical (i.e., observed) power vs. empirical $\alpha$, which looks like an ROC plot, with empirical $\alpha$  playing the role of $FPF$ and empirical power playing the role of $TPF$, see below. If  $\alpha$ = 0, then power = 0; i.e., if Type-I errors are minimized all the way to zero, then power is zero and one makes Type-II errors all the time. On the other hand, if $\alpha$  = 1 then Power = 1, and one makes Type-I errors all the time. 

A little history is due at this point. The author's first FROC study, which led to his entry into this field [@RN621], was published in Radiology in 1986 after a lot of help from a reviewer, who we (correctly) guessed was the late Prof. Charles E. Metz. Prof. Gary T. Barnes (the author's mentor at that time at the University of Alabama at Birmingham) and the author visited Prof. Charles Metz in Chicago for a day ca. 1986, to figuratively “pick Charlie’s brain”. Prof. Metz referred to the concept outlined in the previous paragraph, as an *ROC within an ROC*. 

This curve does not summarize the result of a single ROC study. Rather it summarizes the probabilistic behavior of the two types of errors that occur when one conducts thousands of such studies, under both NH and AH conditions, each time with different values of $\alpha$, with each trial ending in a decision to reject or not reject the null hypothesis. The long sentence is best explained with an example. 


```r
seed <- 1;set.seed(seed)
muNH <- 1.5;muAH <- 2.1;sigma <- 1.3;K1 <- 50;K2 <- 52# Line 6

# cheat to find the population mean and std. dev.
AUC <- array(dim = 10000) # line 8
for (i in 1:length(AUC)) {
  zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = muNH, sd = sigma)  
  AUC[i] <- Wilcoxon(zk1, zk2)
}
sigmaAUC <- sqrt(var(AUC));meanAUC <- mean(AUC) # Line 14

T <- 2000  # Line 16
mu <- c(muNH,muAH) # Line 17
alphaArr <- seq(0.05, 0.95, length.out = 10)
EmpAlpha <- array(dim = length(alphaArr))
EmpPower <- array(dim = length(alphaArr))
for (a in 1:length(alphaArr)) { # Line 20
  alpha <- alphaArr[a] 
  reject <- array(0, dim = c(2, T))
  for (h in 1:2) {  
    for (t in 1:length(reject[h,])) {  
      zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = mu[h], sd = sigma)  
      AUC <- Wilcoxon(zk1, zk2)  
      obsvdZ <- (AUC - meanAUC)/sigmaAUC
      p <- 2*pnorm(-abs(obsvdZ)) # p value for individual t
      if (p < alpha) reject[h,t] = 1 
    }
  }
  EmpAlpha[a] <- sum(reject[1,])/length(reject[1,])
  EmpPower[a] <- sum(reject[2,])/length(reject[2,])
}
EmpAlpha <- c(0,EmpAlpha,1); EmpPower <- c(0,EmpPower,1) # Line 19

pointData <- data.frame(EmpAlpha = EmpAlpha, EmpPower = EmpPower)
zetas <- seq(-5, 5, by = 0.01)
muRoc <- 1.8
curveData <- data.frame(EmpAlpha = pnorm(-zetas),
  EmpPower = pnorm(muRoc - zetas))
alphaPowerPlot <- ggplot(mapping = aes(x = EmpAlpha, y = EmpPower)) + 
  geom_point(data = pointData, shape = 1, size = 3) + 
  geom_line(data = curveData)
print(alphaPowerPlot)
```

![](08-Hypothesis-Testing_files/figure-latex/unnamed-chunk-7-1.pdf)<!-- --> 

Relevant line numbers are shown above as comments. Line 6 creates two variables, `muNH` = 1.5 (the binormal model separation parameter under the NH) and `muAH` = 2.1 (the separation parameter under the AH). Under either hypotheses, the same diseased case standard deviation `sigma` = 1.3 and 50 non-diseased and 52 diseased cases are assumed. As before, lines 8 – 14 use the "brute force" technique to determine population AUC and standard deviation of AUC under the NH condition. Line 16 defines the number of trials `T` = 2000. Line 17 creates a vector `mu` containing the NH and AH values defined at line 6. Line 18 creates `alphaArr`, a sequence of 10 equally spaced values in the range 0.05 to 0.95, which represent 10 values for $\alpha$. Line 19 creates two arrays of length 10 each, named `EmpAlpha` and `EmpPower`, to hold the values of the observed Type-I error rate, i.e., empirical $\alpha$, and the empirical power, respectively. The program will run `T` = 2000 NH and `T` = 2000 AH trials using as $\alpha$ each successive value in `alphaArr` and save the observed Type-I error rates and observed powers to the arrays `EmpAlpha` and `EmpPower`, respectively. 

Line 20 begins a for-loop in `a`, an index into `alphaArr.` Line 21 selects the appropriate value for `alpha` (0.05 on the first pass, 0.15 on the next pass, etc.). Line 22 initializes `reject[2,2000]` with zeroes, to hold the result of each trial; the first index corresponds to hypothesis `h` and the second to trial `t`. Line 23 begins a for-loop in `h`, with `h` = 1 corresponding to the NH and `h` = 2 to the AH. Line 24 begins a for-loop in `t`, the trial index. The code within this block is similar to previous examples. It simulates ratings, computes AUC, calculates the p-value, and saves a rejection of the NH as a one at the appropriate array location `reject[h,t]`. Lines 32 – 33 calculate the empirical $\alpha$ and empirical power for each value of $\alpha$  in `alphaArr`. After padding the ends with zero and ones (the trivial points), the remaining lines plot the "ROC within an ROC".

Each of the circles in the figure corresponds to a specific value of $\alpha$. For example the lowest non-trivial corresponds to  $\alpha$ = 0.05, for which the empirical $\alpha$ is 0.049 and the corresponding empirical Power is 0.4955. True $\alpha$ increases as the operating point moves up the plot, with empirical $\alpha$ and empirical power increasing correspondingly. The $\text{AUC}$ under this curve is determined by the effect size, defined as the difference between the AH and NH values of the separation parameter. If the effect size is zero, then the circles will scatter around the chance diagonal; the scatter will be consistent with the 2000 trials used to generate each coordinate of a point. As the effect size increases, the plot approaches the perfect "ROC", i.e., approaching the top-left corner. One could use AUC under this "ROC" as a measure of the incremental performance, the advantage being that it would be totally independent of $\alpha$, but this would not be practical as it requires replication of the study under NH and AH conditions about 2000 times each and the entire process has to be repeated for several values of $\alpha$. The purpose of this demonstration was to illustrate the concept behind Metz's profound remark. 
	
It is time to move on to factors affecting statistical power in a single study.


### Factors affecting statistical power
* Effect size: effect size is defined as the difference in $\text{AUC}_{pop}$  values between the alternative hypothesis condition and the null hypothesis condition. Recall that  $\text{AUC}_{pop}$ is defined as the true or population value of the empirical ROC-AUC for the relevant hypothesis. One can use the "cheat method" to estimate it under the alternative hypothesis. The formalism is easier if one assumes it is equal to the asymptotic binormal model predicted value. The binormal model yields an estimate of the parameters, which only approach the population values in the asymptotic limit of a large number of cases. In the following, it is assumed that the parameters on the right hand side are the population values)
It follows that effect size (ES) is given by (all quantities on the right hand side of Eqn. (8.13) are population values):

\begin{equation*} 
\text{AUC} = \Phi\left ( \frac{ \mu }{\sqrt{ 1 + \sigma^2}} \right )
\end{equation*} 

It follows that effect size (ES) is given by (all quantities on the right hand side of above equation are population values):

\begin{equation*} 
ES = \Phi\left ( \frac{\mu_{AH}}{\sqrt{1+\sigma^2}} \right ) - \Phi\left ( \frac{\mu_{NH}}{\sqrt{1+\sigma^2}} \right )
\end{equation*} 


```r
EffectSize <- function (muNH, sigmaNH, muAH, sigmaAH)
{
  ES <- pnorm(muAH/sqrt(1+sigmaAH^2)) - pnorm(muNH/sqrt(1+sigmaNH^2))
  return (ES)
}

seed <- 1;set.seed(seed)
muAH <- 2.1 # NH value, defined previously, was mu = 1.5

T <- 2000
alpha <- 0.05 # size of test
reject = array(0, dim = T)
for (t in 1:length(reject)) {  
  zk1 <- rnorm(K1);zk2 <- rnorm(K2, mean = muAH, sd = sigma)  
  AUC <- Wilcoxon(zk1, zk2)  
  obsvdZ <- (AUC - meanAUC)/sigmaAUC
  p <- 2*pnorm(-abs(obsvdZ)) # p value for individual t
  if (p < alpha) reject[t] = 1 
}

ObsvdTypeIErrRate <- sum(reject)/length(reject)
CI <- c(0,0);width <- -qnorm(alpha/2)
CI[1] <- ObsvdTypeIErrRate - 
  width*sqrt(ObsvdTypeIErrRate*(1-ObsvdTypeIErrRate)/T)
CI[2] <- ObsvdTypeIErrRate + 
  width*sqrt(ObsvdTypeIErrRate*(1-ObsvdTypeIErrRate)/T)
cat("obsvdPower = ", ObsvdTypeIErrRate, "\n")
#> obsvdPower =  0.489
cat("95% confidence interval = ", CI, "\n")
#> 95% confidence interval =  0.4670922 0.5109078
cat("Effect Size = ", EffectSize(mu, sigma, muAH, sigma), "\n")
#> Effect Size =  0.08000617 0
```

The ES for the code above is 0.08 (in AUC units). It should be obvious that if effect size is zero, then power equals $\alpha$. This is because then there is no distinction between the null and alternative hypotheses conditions. Conversely, as effect size increases, statistical power increases, the limiting value being unity, when every trial results in rejection of the null hypothesis. The reader should experiment with different values of `muAH` to be convinced of the truth of these statements.

* Sample size: increase the number of cases by a factor of two, and run the above code chunk. 


```
#> pop NH mean AUC =  0.8594882 , pop NH sigma AUC =  0.02568252
#> num. non-diseased images =  100 num. diseased images =  104
#> obsvdPower =  0.313
#> 95% confidence interval =  0.2926772 0.3333228
#> Effect Size =  0.08000617 0
```

So doubling the numbers of cases (both non-diseased and diseased) results in statistical power increasing from 0.509 to 0.844. Increasing the numbers of cases decreases  $\sigma_{\text{AUC}}$, the standard deviation of the empirical AUC. The new value of $\sigma_{\text{AUC}}$ is 0.02947, which should be compared to the value 0.04177 for K1 = 50, K2 = 52. Recall that $\sigma_{\text{AUC}}$ enters the denominator of the Z-statistic, so decreasing it will increase the probability of rejecting the null hypothesis. 

* Alpha: Statistical power depends on $alpha$. The results below are for two runs of the code, the first with the original value $\alpha$ = 0.05, the second with $\alpha$ = 0.01:


```
#> alpha =  0.05 obsvdPower =  0.1545 
#> alpha =  0.01 obsvdPower =  0.0265
```

Decreasing  $\alpha$ results in decreased statistical power. 

## Comments {#HypothesisTestingComments}
The Wilcoxon statistic was used to estimate the area under the ROC curve. One could have used the binormal model, introduced in Chapter 06, to obtain maximum likelihood estimates of the area under the binormal model fitted ROC curve. The reasons for choosing the simpler empirical area are as follows. (1) With continuous ratings and 102 operating points, the area under the empirical ROC curve is expected to be a close approximation to the fitted area. (2) With maximum likelihood estimation, the code would be more complex – in addition to the fitting routine one would require a binning routine and that would introduce yet another variable in the analysis, namely the number of bins and how the bin boundaries were chosen. (3) The maximum likelihood fitting code can sometimes fail to converge, while the Wilcoxon method is always guaranteed to yield a result. The non-convergence issue is overcome by modern methods of curve fitting described in later chapters. (4) The aim was to provide an understanding of null hypothesis testing and statistical power without being bogged down in the details of curve fitting.

## Why alpha is chosen as 5%
One might ask why $\alpha$ is traditionally chosen to be 5%. It is not a magical number, rather the result of a cost benefit tradeoff. Choosing too small a value of $\alpha$ would result in greater probability $(1-\alpha)$ of the NH not being rejected, even when it is false. Sometimes it is important to detect a true difference between the measured AUC and the postulated value. For example, a new eye-laser surgery procedure is invented and the number of patients is necessarily small as one does not wish to subject a large number of patients to an untried procedure. One seeks some leeway on the Type-I error probability, possibly increasing it to $\alpha$ = 0.1, in order to have a reasonable chance of success in detecting an improvement in performance due to better eyesight after the surgery. If the NH is rejected and the change is in the right direction, then that is good news for the researcher. One might then consider a larger clinical trial and set $\alpha$ at the traditional 0.05, making up the lost statistical power by increasing the number of patients on which the surgery is tried. 

If a whole branch of science hinges on the results of a study, such as discovering the Higg's Boson in particle physics, statistical significance is often expressed in multiples of the standard deviation ($\sigma$) of the normal distribution, with the significance threshold set at a much stricter level (e.g. $5\sigma$). This corresponds to $\alpha$ ~ 1 in 3.5 million (`1/pnorm(-5)` =  3.5 x 10^6, a one-sided test of significance). There is an article in Scientific American (https://blogs.scientificamerican.com/observations/five-sigmawhats-that/) on the use of $n\sigma$, where `n` is an integer, e.g. 5, to denote the significance level of a study, and some interesting anecdotes on why such high significance levels (ie., small $\alpha$) are used in some fields of research. 

Similar concerns apply to manufacturing where the cost of a mistake could be the very expensive recall of an entire product line. For background on Six Sigma Performance, see http://www.six-sigma-material.com/Six-Sigma.html. An article downloaded 3/30/17 from https://en.wikipedia.org/wiki/Six_Sigma is included as supplemental material to this chapter (Six Sigma.pdf). It has an explanation of why $6\sigma$ translates to one defect per 3.4 million opportunities (it has to do with short-term and long-term drifts in a process). In the author's opinion, looking at other fields offers a deeper understanding of this material than simply stating that by tradition one adopts alpha = 5%.

Most observer performance studies, while important in the search for better imaging methods, are not of such "earth-shattering" importance, and it is somewhat important to detect true differences at a reasonable alpha, so alpha = 5% and beta = 20% represent a good compromise. If one adopted a $5\sigma$ criterion, the NH would never be rejected, and progress in image quality optimization would come to a grinding halt. That is not to say that a $5\sigma$ criterion cannot be used; rather if used, the number of patients needed to detect a reasonable difference (effect size) with 80% probability would be astronomically large. Truth-proven cases are a precious commodity in observer performance studies. Particle physicists working on discovering the Higg's Boson can get away with $5\sigma$ criterion because the number of independent observations and/or effect size is much larger than corresponding numbers in observer performance research.

## Discussion {#HypothesisTestingDiscussion}
In most statistics books, the subject of hypothesis testing is demonstrated in different (i.e., non-ROC) contexts. That is to be expected since the ROC-analysis field is a small sub-specialty of statistics (Prof. Howard E. Rockette, private communication, ca. 2002). Since this book is about ROC analysis, the author decided to use a demonstration using ROC analysis. Using a data simulator, one can "cheat" by conducting a very large number of simulations to estimate the population $\text{AUC}$ under the null hypothesis. This permitted us to explore the related concepts of Type-I and Type-II errors within the context of ROC analysis. Ideally, both errors should be zero, but the nature of statistics leads one to two compromises. Usually one accepts a Type-I error capped at 5% and a Type-II error capped at 20%. These translate to $\alpha$ = 0.05 and desired statistical power = 80%. The dependence of statistical power on $\alpha$, the numbers of cases and the effect size was explored. 

In TBA Chapter 11 sample-size calculations are described that allow one to estimate the numbers of readers and cases needed to detect a specified difference in inter-modality AUCs with expected statistical power = $1-\beta$. The word "detect" in the preceding sentence is shorthand for "reject the NH with incorrect rejection probability capped at $\alpha$". 

This chapter also gives the first example of validation of a hypothesis testing method. Statisticians sometimes refer to this as showing a proposed test is a "5% test". What is meant is that one needs to be assured that when the NH is true the probability of NH rejection is consistent with the expected value. Since the observed NH rejection rate over 2000 simulations is a random variable, one does not expect the NH rejection rate to exactly equal 5%, rather the constructed 95% confidence interval (also a random interval variable) should include the NH value with probability  1 - $\alpha$. 

Comparing a single reader's performance to a specified value is not a clinically interesting problem. The next few chapters describe methods for significance testing of multiple-reader multiple-case (MRMC) ROC datasets, consisting of interpretations by a group of readers of a common set of cases in typically two modalities. It turns out that the analyses yield variability estimates that permit sample size calculation. After all, sample size calculation is all about estimation of variability, the denominator of the z-statistic. The formulae will look more complex, as interest is not in determining the standard deviation of AUC, but in the standard deviation of the inter-modality reader-averaged AUC difference. However, the basic concepts remain the same. 


## References {#HypothesisTesting-references}


<!--chapter:end:08-Hypothesis-Testing.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# DBM method background {#DBMAnalysisBkgrnd}



## Introduction {#DBMAnalysisBkgrnd-introduction}
The term *treatment* is generic for *imaging system*, *modality* or *image processing*; *reader* is generic for *radiologist* or *algorithmic observer*, e.g., a computer aided detection (CAD) or artificial intelligence (AI) algorithm. The previous chapter described analysis of a single ROC dataset and comparing the observed area $AUC$ under the ROC plot to a specified value. Clinically this is not an interesting problem; rather, interest is usually in comparing performance of a group of readers interpreting a common set of cases in two or more treatments. Such data is termed multiple reader multiple case (MRMC). [An argument could be made in favor of the term “multiple-treatment multiple-reader”, since “multiple-case” is implicit in any ROC analysis that takes into account correct and incorrect decisions on cases. However, the author will stick with existing terminology.] The basic idea is that by sampling a sufficiently large number of readers and cases one can draw conclusions that apply broadly to other readers of similar skill levels interpreting other similar case sets in the selected treatments. How one accomplishes this, termed MRMC analysis, is the subject of this chapter.

This chapter describes the first truly successful method of analyzing MRMC ROC data, namely the Dorfman-Berbaum-Metz (DBM) method [@RN204]. The other method, due to Obuchowski and Rockette [@RN1450], is the subject of Chapter 10 (TBA). Both methods have been substantially improved by Hillis [@RN1866; @RN1865; @RN2508]. It is not an overstatement that ROC analysis came of age with the methods described in this chapter. Prior to the techniques described here, one knew of the existence of sources of variability affecting a measured $AUC$ value, as discussed in (book) Chapter 07, but then-known techniques [@RN412] for estimating the corresponding variances and correlations were impractical. 

### Historical background
The author was thrown (unprepared) into the methodology field ca. 1985 when, as a junior faculty member, he undertook comparing a prototype digital chest-imaging device (Picker International, ca. 1983) vs. an optimized analog chest-imaging device at the University of Alabama at Birmingham. At the outset a decision was made to use free-response ROC methodology instead of ROC, as the former accounted for lesion localization, and the author and his mentor, Prof. Gary T. Barnes, were influenced in that decision by a publication [@RN2453] to be described in (book) Chapter 12. Therefore, instead of ROC-AUC one had lesion-level sensitivity at a fixed number of location level false positives per case as the figure-of-merit (FOM). Details of the FOM are not relevant at this time. Suffice to state that methods described in this chapter, which had not been developed in 1983, while developed for analyzing reader-averaged inter-treatment ROC-AUC differences, *apply to any scalar FOM*. While the author was successful at calculating confidence intervals (this is the heart of what is loosely termed *statistical analysis*) and publishing the work [@RN621] using techniques described in a book [@RN412] titled "Evaluation of Diagnostic Systems: Methods from Signal Detection Theory", subsequent attempts at applying these methods in a follow-up paper [@RN620] led to negative variance estimates (private communication, Dr. Loren Niklason, ca. 1985). With the benefit of hindsight, negative variance estimates are not that uncommon and the method to be described in this chapter has to deal with that possibility.

The methods [@RN412] described in the cited book involved estimating the different variability components – case sampling, between-reader and within-reader variability. Between-reader and within-reader variability (the two cannot be separated as discussed in (book) Chapter 07) could be estimated from the variance of the $AUC$ values corresponding to the readers interpreting the cases within a treatment and then averaging the variances over all treatments. Estimating case-sampling and within-reader variability required splitting the dataset into a few smaller subsets (e.g., a case set with 60 cases might be split into 3 sub-sets of 20 cases each), analyzing each subset to get an $AUC$ estimate, calculating the variance of the resulting $AUC$ values [@RN412] and scaling the result to the original case size. Because it was based on few values, the estimate was inaccurate, and the already case-starved original dataset made it difficult to estimate AUCs for the subsets; moreover, the division into subsets was at the discretion of the researcher, and therefore unlikely to be reproduced by others. Estimating within-reader variability required re-reading the entire case set, or at least a part of it. ROC studies have earned a deserved reputation for taking much time to complete, and having to re-read a case set was not a viable option. [Historical note: the author recalls a barroom conversation with Dr. Thomas Mertelmeir after the conclusion of an SPIE meeting ca. 2004, where Dr. Mertelmeir commiserated mightily, over several beers, about the impracticality of some of the ROC studies required of imaging device manufacturers by the FDA.]


### The Wagner analogy
An important objective of modality comparison studies is to estimate the variance of the difference in reader-averaged AUCs between the treatments. For two treatments one sums the reader-averaged variance in each treatment and subtracts twice the covariance (a scaled version of the correlation). Therefore, in addition to estimating variances, one needs to estimate correlations. Correlations are present due to the common case set interpreted by the readers in the different treatments. If the correlation is large, i.e., close to unity, then the individual treatment variances tend to cancel, making the constant treatment-induced difference easier to detect. The author recalls a vivid analogy used by the late Dr. Robert F. Wagner to illustrate this point at an SPIE meeting ca. 2008. To paraphrase him, *consider measuring from shore the heights of the masts on two adjacent boats in a turbulent ocean. Because of the waves, the heights, as measured from shore, are fluctuating wildly, so the variance of the individual height measurements is large. However, the difference between the two heights is likely to be relatively constant, i.e., have small variance. This is because the wave that causes one mast's height to increase also increases the height of the other mast.*

### The shortage of numbers to analyze and a pivotal breakthrough
*The basic issue was that the calculation of $AUC$ reduces the relatively large number of ratings of a set of non-diseased and diseased cases to a single number.* For example, after completion of an ROC study with 5 readers and 100 non-diseased and 100 diseased cases interpreted in two treatments, the data is reduced to just 10 numbers, i.e., five readers times two treatments. It is difficult to perform statistics with so few numbers. The author recalls a conversation with Prof. Kevin Berbaum at a Medical Image Perception Society meeting in Tucson, Arizona, ca. 1997, in which he described the basic idea that forms the subject of this chapter. Namely, using jackknife pseudovalues (to be defined below) as individual case-level figures of merit. This, of course, greatly increases the amount of data that one can work with; instead of just 10 numbers one now has 2,000 pseudovalues (2 x 5 x 200). If one assumes the pseudovalues behave essentially as case-level data, then by assumption they are independent and identically distributed, and therefore satisfy the conditions for application of standard analysis of variance (ANOVA) techniques. [This assumption has been much criticized and is the basis for some preferring alternate approaches - but, as Hillis has stated, and I paraphrase, the pseudovalue based method "works", but lacks sufficient rigor.] The relevant paper had already been published in 1992 but other projects and lack of formal statistical training kept the author from fully appreciating this work until later. 

For the moment I restrict to fully paired data (i.e., each case is interpreted by all readers in all treatments). There is a long history of how this field has evolved and the author cannot do justice to all methods that are currently available. Some of the methods [@RN1441; @RN2013; @RN1451] have the advantage that they can handle explanatory variables (termed covariates) that could influence performance, e.g., years of experience, types of cases, etc. Other methods are restricted to specific choices of FOM. Specifically, the probabilistic approach [@RN2253; @RN2254; @RN2351; @RN2080] is restricted to the empirical $AUC$ under the ROC curve, and is not applicable to other FOMs, e.g., parametrically fitted ROC AUCs or, more importantly, to location specific paradigm FOMs. Instead, the author will focus on methods for which software is readily available (i.e., freely on websites), which have been widely used (the method that the author is about to describe has been used in several hundred publications) and validated via simulations, and which apply to any scalar figure of merit, and therefore widely applicable, for example, to location specific paradigms.

### Organization of chapter
The concepts of reader and case populations, introduced in (book) Chapter 07, are recapitulated. A distinction is made between *fixed* and *random* factors – statistical terms with which one must become familiar. Described next are three types of analysis that are possible with MRMC data, depending on which factors are regarded as random and which as fixed. The general approach to the analysis is described. Two methods of analysis are possible: the jackknife pseudovalue-based approach detailed in this chapter and an alternative approach is detailed in Chapter 10. The Dorfman-Berbaum-Metz (DBM) model for the jackknife pseudovalues is described that incorporates different sources of variability and correlations possible with MRMC data. Calculation of ANOVA-related quantities, termed mean squares, from the pseudovalues, are described followed by the significance testing procedure for testing the null hypothesis of no treatment effect. A relevant distribution used in the analysis, namely the F-distribution, is illustrated with R examples. The decision rule, i.e., whether to reject the NH, calculation of the ubiquitous p-value, confidence intervals and how to handle multiple treatments is illustrated with two datasets, one an older ROC dataset that has been widely used to demonstrate advances in ROC analysis, and the other a recent dataset involving evaluation of digital chest tomosynthesis vs. conventional chest imaging. The approach to validation of DBM analysis is illustrated with an R example. The chapter concludes with a section on the meaning of the pseudovalues. The intent is to explain, at an intuitive level, why the DBM method "works", even though use of pseudovalues has been questioned at the conceptual level. For organizational reasons and space limitations, details of the software are relegated to Online Appendices, but they are essential reading, preferably in front of a computer running the online software that is part of this book. The author has included material here that may be obvious to statisticians, e.g., an explanation of the Satterthwaite approximation, but are expected to be helpful to others from non-statistical backgrounds.

## Random and fixed factors{#DBMAnalysisBkgrnd-random-fixed-factors}
*This paragraph introduces some analysis of variance (ANOVA) terminology. Treatment, reader and case are factors with different numbers of levels corresponding to each factor. For an ROC study with two treatments, five readers and 200 cases, there are two levels of the treatment factor, five levels of the reader factor and 200 levels of the case factor. If a factor is regarded as fixed, then the conclusions of the analysis apply only to the specific levels of the factor used in the study. If a factor is regarded as random, the levels of the factor are regarded as random samples from a parent population of the corresponding factor, and conclusions regarding specific levels are not allowed; rather, conclusions apply to the distribution from which the levels were sampled.*

ROC MRMC studies require a sample of cases and interpretations by one or more readers in one or more treatments (in this book the term *multiple* includes as a special case *one*). A study is never conducted on a sample of treatments. It would be nonsensical to image patients using a "sample" of all possible treatments. Every variation of an imaging technique (e.g., different kilovoltage or kVp) or display method (e.g., window-level setting) or image processing techniques qualifies as a distinct treatment. The number of possible treatments is very large, and, from a practical point of view, most of them are uninteresting. Rather, interest is in comparing two or more (a few at most) treatments that, based on preliminary studies, are clinically interesting. One treatment may be computed tomography, the other magnetic resonance imaging, or one may be interested in comparing a standard image processing method to a newly proposed one, or one may be interested in comparing CAD to a group of readers. 

This brings out an essential difference between how cases, readers and treatments have to be regarded in the variability estimation procedure. Cases and readers are usually regarded as random factors (there has to be at least one random factor – if not, there are no sources of variability and nothing to apply statistics to!), while treatments are regarded as fixed factors. The random factors contribute variability, but the fixed factors do not, rather they contribute constant shifts in performance. The terms *fixed* and *random* factors are used in this specific sense, and are derived, in turn, from ANOVA methods in statistics. With two or more treatments, there are shifts in performance of treatments relative to each other, that one seeks to assess the significance of, against a background of noise contributed by the random factors. If the shifts are sufficiently large compared to the noise, then one can state, with some certainty, that they are real. Quantifying the last statement uses the methods of hypothesis testing introduced in Chapter \@ref(HypothesisTesting).

## Reader and case populations{#DBMAnalysisBkgrnd-reader-case-populations}
Consider a sample of $J$ readers. Conceptually there is a reader-population, modeled as a normal distribution $\theta_j \sim N\left ( \theta_{\bullet\{1\}},  \sigma_{br+wr}^{2} \right )$, describing the variation of skill-level of readers. Here $\theta$ is a generic FOM. Each reader $j$ is characterized by a different value of  $\theta_j$, $j=1,2,...J$ and one can conceptually think of a bell-shaped curve with variance $\sigma_{br+wr}^{2}$ describing between-reader variability of the readers. A large variance implies large spread in reader skill levels. 

Likewise, there is a case-population, also modeled as a normal distribution, describing the variations in difficulty levels of the patients. One actually has two unit-variance distributions, one for non-diseased and one for diseased cases, characterized by a separation parameter. The separation parameter is scaled (i.e., normalized) by the standard deviation of each distribution (assumed equal). Each distribution has unit variance. Conceptually an easy case set has a larger than usual scaled separation parameter while a difficult case set has a smaller than usual scaled separation parameter. The distribution of the scaled separation parameter can be modeled as a bell-shaped curve $\theta_{\{c\}} \sim N\left ( \theta_{\{\bullet\}}, \sigma_{cs+wr}^{2} \right )$  with variance $\sigma_{cs+wr}^{2}$ describing the variations in difficulty levels of different case samples. Note the need for the case-set index, introduced in (book) Chapter 07, to specify the separation parameter for a specific case-set (in principle a $j$-index is also needed as one cannot have an interpretation without a reader; for now it is suppressed. A small variance $\sigma_{cs}^{2}$  implies the different case sets have similar difficulty levels while a larger variance would imply a larger spread in difficulty levels. Just as the previous paragraph described reader-varibility, this paragraph has described case-variability.

*Anytime one has a common random component to two measurements, the measurements are correlated.* In the Wagner analogy, the common component is the random height, as a function of time, of a wave, which contributes the same amount to both height measurements (since the boats are adjacent). Since the readers interpret a common case set in all treatments one needs to account for various types of correlations that are potentially present. These occur due to the various types of pairings that can occur with MRMC data, where each pairing implies the presence of a common component to the measurements: (a) the same reader interpreting the *same cases* in different treatments, (b) different readers interpreting the *same cases* in the same treatment and (c) different readers interpreting the *same cases* in different treatments. These pairings are more clearly elucidated in (book) Chapter 10. The current chapter uses jackknife pseudovalue based analysis to model the variances and the correlations. Hillis has shown that the two approaches are essentially equivalent [@RN1866].

## Three types of analyses{#DBMAnalysisBkgrnd-threeAnalyses} 
*MRMC analysis aims to draw conclusions regarding the significances of inter-treatment shifts in performance. Ideally a conclusion (i.e., a difference is significant) should generalize to the respective populations from which the random samples were obtained. In other words, the idea is to generalize from the observed samples to the underlying populations. Three types of analyses are possible depending on which factor(s) one regards as random and which as fixed: random-reader random-case (RRRC), fixed-reader random-case (FRRC) and random-reader fixed-case (RRFC). If a factor is regarded as random, then the conclusion of the study applies to the population from which the levels of the factor were sampled. If a factor is regarded as fixed, then the conclusion applies only to the specific levels of the sampled factor. For example, if reader is regarded as a random factor, the conclusion generalizes to the reader population from which the readers used in the study were obtained. If reader is regarded as a fixed factor, then the conclusion applies to the specific readers that participated in the study. Regarding a factor as fixed effectively “freezes out” the sampling variability of the population and interest then centers only on the specific levels of the factor used in the study. Likewise, treating case as a fixed factor means the conclusion of the study is specific to the case-set used in the study.*

## General approach{#DBMAnalysisBkgrnd-approach}
This section provides an overview of the steps involved in analysis of MRMC data. Two approaches are described in parallel: a figure of merit (FOM) derived jackknife pseudovalue based approach, detailed in this chapter and an FOM based approach, detailed in the next chapter. The analysis proceeds as follows:

1.	A FOM is selected: *the selection of FOM is the single-most critical aspect of analyzing an observer performance study*. The selected FOM is denoted $\theta$. The FOM has to be an objective scalar measure of performance with larger values characterizing better performance. [The qualifier "larger" is trivially satisfied; if the figure of merit has the opposite characteristic, a sign change is all that is needed to bring it back to compliance with this requirement.] Examples are empirical $AUC$, the binormal model-based estimate $A_z$ , other advance method based estimates of $AUC$, sensitivity at a predefined value of specificity, etc. An example of a FOM requiring a sign-change is $FPF$ at a specified $TPF$, where smaller values signify better performance.
1. For each treatment $i$ and reader $j$ the figure of merit $\theta_{ij}$ is estimated from the ratings data. Repeating this over all treatments and readers yields a matrix of observed values $\theta_{ij}$. This is averaged over all readers in each treatment yielding  $\theta_{i\bullet}$. The observed effect-size $ES_{obs}$ is defined as the difference between the reader-averaged FOMs in the two treatments, i.e., $ES_{obs} = \theta_{2\bullet}-\theta_{1\bullet}$. While extensible to more than two treatments, the explanation is more transparent by restricting to two modalities.
1. If the magnitude of $ES_{obs}$ is "large" one has reason to suspect that there might indeed be a significant difference in AUCs between the two treatments, where *significant* is used in the sense of (book) Chapter 08. Quantification of this statement, specifically how large is "large", requires the conceptually more complex steps described next.
    +	In the DBM approach, the subject of this chapter, jackknife pseudovalues are calculated as described in Chapter 08. A standard ANOVA model with uncorrelated errors is used to model the pseudovalues. 
    +	In the OR approach, the subject of the next chapter, the FOM is modeled directly using a custom ANOVA model with correlated errors.
1.	Depending on the selected method of modeling the data (pseudovalue vs. FOM) a statistical model is used which includes parameters modeling the true values in each treatment, and expected variations due to different variability components in the model, e.g., between-reader variability, case-sampling variability, interactions (e.g., allowing for the possibility that the random effect of a given reader could be treatment dependent) and the presence of correlations (between pseudovalues or FOMs) because of the pairings inherent in the interpretations.
1.	In RRRC analysis one accounts for randomness in readers and cases. In FRRC analysis one regards reader as a fixed factor. In RRFC analysis one regards the case-sample (set of cases) as a fixed factor. The statistical model depends on the type of analysis.
1.	The parameters of the statistical model are estimated from the observed data. 
1.	The estimates are used to infer the statistical distribution of the observed effect size,  $ES_{obs}$, regarded as a realization of a random variable, under the null hypothesis (NH) that the true effect size is zero.
1.	Based on this statistical distribution, and assuming a two-sided test, the probability (this is the oft-quoted p-value) of obtaining an effect size at least as extreme as that actually observed, is calculated, as in (book) Chapter 08. 
1.	If the p-value is smaller than a preselected value, denoted $\alpha$, one declares the treatments different at the $\alpha$ - significance level. The quantity $\alpha$ is the control (or "cap") on the probability of making a Type I error, defined as rejecting the NH when it is true. It is common to set   $\alpha$ = 0.05 but depending on the severity of the consequences of a Type I error, as discussed in (book) Chapter 08, one might consider choosing a different value. Notice that $\alpha$ is a pre-selected number while the p-value is a realization (observation) of a random variable.
1.	For a valid statistical analysis, the empirical probability $\alpha_{emp}$ over many (typically 2000) independent NH datasets, that the p-value is smaller than  $\alpha$, should equal $\alpha$ to within statistical uncertainty.

## Summary TBA {#DBMAnalysisBkgrnd-summary}
This chapter has detailed analysis of MRMC ROC data using the DBM method. A reason for the level of detail is that almost all of the material carries over to other data collection paradigms, and a thorough understanding of the relatively simple ROC paradigm data is helpful to understanding the more complex ones. 

DBM has been used in several hundred ROC studies (Prof. Kevin Berbaum, private communication ca. 2010). While the method allows generalization of a study finding, e.g., rejection of the NH, to the population of readers and cases, the author believes this is sometimes taken too literally. If a study is done at a single hospital, then the radiologists tend to be more homogenous as compared to sampling radiologists from different hospitals. This is because close interactions between radiologists at a hospital tend to homogenize reading styles and performance. A similar issue applies to patient characteristics, which are also expected to vary more between different geographical locations than within a given location served by the hospital. This means is that single hospital study based p-values may tend to be biased downwards, declaring differences that may not be replicable if a wider sampling "net" were used using the same sample size. The price paid for a wider sampling net is that one must use more readers and cases to achieve the same sensitivity to genuine treatment effects, i.e., statistical power (i.e., there is no "free-lunch").

A third MRMC ROC method, due to Clarkson, Kupinski and Barrett19,20, implemented in open-source JAVA software by Gallas and colleagues22,44 (http://didsr.github.io/iMRMC/) is available on the web. Clarkson et al19,20 provide a probabilistic rationale for the DBM model, provided the figure of merit is the empirical $AUC$. The method is elegant but it is only applicable as long as one is using the empirical AUC as the figure of merit (FOM) for quantifying observer performance. In contrast the DBM approach outlined in this chapter, and the approach outlined in the following chapter, are applicable to any scalar FOM. Broader applicability ensures that significance-testing methods described in this, and the following chapter, apply to other ROC FOMs, such as binormal model or other fitted AUCs, and more importantly, to other observer performance paradigms, such as free-response ROC paradigm. An advantage of the Clarkson et al. approach is that it predicts truth-state dependence of the variance components. One knows from modeling ROC data that diseased cases tend to have greater variance than non-diseased ones, and there is no reason to suspect that similar differences do not exist between the variance components. 

Testing validity of an analysis method via simulation testing is only as good as the simulator used to generate the datasets, and this is where current research is at a bottleneck. The simulator plays a central role in ROC analysis. In the author's opinion this is not widely appreciated. In contrast, simulators are taken very seriously in other disciplines, such as cosmology, high-energy physics and weather forecasting. The simulator used to validate3 DBM is that proposed by Roe and Metz39 in 1997. This simulator has several shortcomings. (a) It assumes that the ratings are distributed like an equal-variance binormal model, which is not true for most clinical datasets (recall that the b-parameter of the binormal model is usually less than one). Work extending this simulator to unequal variance has been published3. (b) It does not take into account that some lesions are not visible, which is the basis of the contaminated binormal model (CBM). A CBM model based simulator would use equal variance distributions with the difference that the distribution for diseased cases would be a mixture distribution with two peaks. The radiological search model (RSM) of free-response data, Chapter 16 &17 also implies a mixture distribution for diseased cases, and it goes farther, as it predicts some cases yield no z-samples, which means they will always be rated in the lowest bin no matter how low the reporting threshold. Both CBM and RSM account for truth dependence by accounting for the underlying perceptual process. (c) The Roe-Metz simulator is out dated; the parameter values are based on datasets then available (prior to 1997). Medical imaging technology has changed substantially in the intervening decades. (d) Finally, the methodology used to arrive at the proposed parameter values is not clearly described. Needed is a more realistic simulator, incorporating knowledge from alternative ROC models and paradigms that is calibrated, by a clearly defined method, to current datasets. 

Since ROC studies in medical imaging have serious health-care related consequences, no method should be used unless it has been thoroughly validated. Much work still remains to be done in proper simulator design, on which validation is dependent.

## References {#DBMAnalysisBkgrnd-references}


<!--chapter:end:09A-DBM-Analysis-Bkgrnd.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Significance Testing using the DBM Method {#DBMAnalysisSigtesting}
DBM = Dorfman Berbaum Metz


## The DBM sampling model
The figure-of-merit has three indices:  

* A treatment index $i$, where $i$ runs from 1 to $I$, where $I$ is the total number of treatments.  
* A reader index $j$, where $j$ runs from 1 to $J$, where $J$ is the total number of readers.  
* The case-sample index $\{c\}$, where  $\{1\}$  i.e., $c$ = 1, denotes a set of cases, $K_1$ non-diseased and $K_2$ diseased, interpreted by all readers in all treatments, and other integer values of $c$ correspond to other independent sets of cases that, although not in fact interpreted by the readers, could potentially be “interpreted” using resampling methods such as the bootstrap or the jackknife. 

The approach [@RN204] taken by DBM was to use the jackknife resampling method to calculate FOM pseudovalues ${Y'}_{ijk}$ defined by (the reason for the prime will become clear shortly):

\begin{equation}
Y'_{ijk}=K\theta_{ij}-(K-1)\theta_{ij(k)}
(\#eq:pseudoValPrime)
\end{equation}

Here $\theta_{ij}$ is the estimate of the figure-of-merit for reader $j$ interpreting all cases in treatment $i$ and $\theta_{ij(k)}$ is the corresponding figure of merit with case $k$ *deleted* from the analysis. To keep the notation compact the case-sample index $\{1\}$ on every figure of merit symbol is suppressed. 

Recall from book Chapter 07 that the jackknife is a way of teasing out the case-dependence: the left hand side of Equation  \@ref(eq:pseudoValPrime) has a case index $k$, with $k$ running from 1 to $K$, where $K$ is the total number of cases:  $K=K_1+K_2$. 

Hillis et al [@RN1866] proposed a centering transformation on the pseudovalues (he terms it "normalized" pseudovalues, but to me "centering" is a more accurate and descriptive term - *Normalize: (In mathematics) multiply (a series, function, or item of data) by a factor that makes the norm or some associated quantity such as an integral equal to a desired value (usually 1). New Oxford American Dictionary, 2016*):

\begin{equation}
Y_{ijk}=Y'_{ijk}+\left (\theta_{ij} - Y'_{ij\bullet}  \right )
(\#eq:pValCentered)
\end{equation}

**Note: the bullet symbol denotes an average over the corresponding index.**

The effect of this transformation is that the average of the centered pseudovalues over the case index is identical to the corresponding estimate of the figure of merit:

\begin{equation}
Y_{ij\bullet}=Y'_{ij\bullet}+\left (\theta_{ij} - Y'_{ij\bullet}  \right )=\theta_{ij}
(\#eq:EffectOfCentering)
\end{equation}

This has the advantage that all confidence intervals are properly centered. The transformation is unnecessary if one uses the Wilcoxon as the figure-of-merit, as the pseudovalues calculated using the Wilcoxon as the figure of merit are "naturally" centered, i.e.,

$\theta_{ij} - Y'_{ij\bullet} = 0$

*It is understood that, unless explicitly stated otherwise, all calculations from now on will use centered pseudovalues.*

Consider $N$ replications of a MRMC study, where a replication means repetition of the study with the same treatments, readers and case-set $\{1\}$. For $N$ replications per treatment-reader-case combination, the DBM model for the pseudovalues is ($n$ is the replication index, usually $n$ = 1, but kept here for now):

\begin{equation}
Y_{n(ijk)}  = \mu + \tau_i+ R_j + C_k + (\tau R)_{ij}+ (\tau C)_{ik}+ (R C)_{jk} + (\tau RC)_{ijk}+ \epsilon_{n(ijk)} 
(\#eq:DefDBMModel)
\end{equation}

The term $\mu$ is a constant. By definition, the treatment effect $\tau_i$  is subject to the constraint:

\begin{equation}
\sum_{i=1}^{I}\tau_i=0\Rightarrow \tau_\bullet=0
(\#eq:constraintTau)
\end{equation}

This constraint ensures that $\mu$ has the interpretation of the average of the pseudovalues over treatments, readers and cases. 

The (nesting) notation for the replication index, i.e., $n(ijk)$, implies $n$ observations for treatment-reader-case combination $ijk$. With no replications ($N$ = 1) it is convenient to omit the n-symbol.

The parameter $\tau_i$ is estimated as follows: 

\begin{equation}
Y_{ijk} \equiv Y_{1(ijk)}\\
\tau_i = Y_{i \bullet \bullet} -Y_{\bullet \bullet \bullet} 
(\#eq:estimatingTau)
\end{equation}

*The basic assumption of the DBM model is that the pseudovalues can be regarded as independent and identically distributed observations. That being the case, the pseudovalues can be analyzed by standard ANOVA techniques.* Since pseduovalues are computed from a common dataset, this assumption is, non-intuitive. However, for the special case of Wilcoxon figure of merit, it is justified.

### Explanation of terms in the model 
The right hand side of Eqn. \@ref(eq:pseudoValPrime) consists of one fixed and 7 random effects. The current analysis assumes readers and cases as random factors (RRRC), so by definition $R_j$ and $C_k$ are random effects, and moreover, any term that includes a random factor is a random effect; for example, $(\tau R)_{ij}$ is a random effect because it includes the $R$ factor. Here is a list of the random terms: 

\begin{equation}
R_j, C_k, (\tau R)_{ij}, (\tau C)_{ik}, (RC)_{jk},  (\tau RC)_{ijk},  \epsilon_{ijk}
(\#eq:DBMRandomTerms)
\end{equation}


**Assumption:** Each of the random effects is modeled as a random sample from mutually independent zero-mean normal distributions with variances as specified below:

\begin{align}
\left.\begin{array}{rll}
{R_j}&\sim& N\left ( 0,\sigma_{R}^{2} \right ) \\[0.5em]
{C_k}&\sim& N\left ( 0,\sigma_{C}^{2} \right ) \\[0.5em]
{(\tau R)_{ij}}&\sim& N\left ( 0,\sigma_{\tau R}^{2} \right ) \\[0.5em]
{(\tau C)_{ik}}&\sim& N\left ( 0,\sigma_{\tau C}^{2} \right ) \\[0.5em]
{(RC)_{jk}}&\sim& N\left ( 0,\sigma_{RC}^{2} \right ) \\[0.5em]
{(\tau RC)_{ijk}}&\sim& N\left ( 0,\sigma_{\tau RC}^{2} \right ) \\[0.5em]
\epsilon_{ijk} &\sim& N\left ( 0,\sigma_{\epsilon}^{2} \right )
\end{array}\right\}
(\#eq:samplingOfDbmTerms)
\end{align}

Equation \@ref(eq:samplingOfDbmTerms) defines the meanings of the variance components appearing in Equation \@ref(eq:DBMRandomTerms). One could have placed a $Y$ subscript (or superscript) on each of the variances, as they describe fluctuations of the pseudovalues, not FOM values. However, this tends to clutter the notation. So here is the convention:

**Unless explicitly stated otherwise, all variance symbols in this chapter refer to pseudovalues. ** 
Another convention: $(\tau R)_{ij}$ is *not* the product of the treatment and reader factors, rather it is a single factor, namely the treatment-reader factor with $IJ$ levels, subscripted by the index $ij$ and similarly for the other product-like terms in Equation \@ref(eq:samplingOfDbmTerms).

### Meanings of variance components in the DBM model (**TBA this section can be improved**)
The variances defined in \@ref(eq:samplingOfDbmTerms) are collectively termed *variance components*. Specifically, they are jackknife pseudovalue variance components, to be distinguished from figure of merit (FOM) variance components to be introduced in TBA Chapter 10. They are in order: $\sigma_{R}^{2} ,\sigma_{C}^{2} \sigma_{\tau R}^{2},\sigma_{\tau C}^{2},\sigma_{RC}^{2}, \sigma_{\tau RC}^{2},\sigma_{\epsilon}^{2}$. They have the following meanings.

*	The term $\sigma_{R}^{2}$ is the variance of readers that is independent of treatment or case, which are modeled separately. It is not to be confused with the terms $\sigma_{br+wr}^{2}$ and $\sigma_{cs+wr}^{2}$ used in §9.3, which describe the variability of $\theta$ measured under specified conditions. [A jackknife pseudovalue is a weighted difference of FOM like quantities, TBA \@ref(eq:pseudoValPrime). Its meaning will be explored later. For now, *a pseudovalue variance is distinct from a FOM variance*.]
*	The term $\sigma_{C}^{2}$ is the variance of cases that is independent of treatment or reader.
*	The term $\sigma_{\tau R}^{2}$ is the treatment-dependent variance of readers that was excluded in the definition of $\sigma_{R}^{2}$. If one were to sample readers and treatments for the same case-set, the net variance would be  $\sigma_{R}^{2}+\sigma_{\tau R}^{2}+\sigma_{\epsilon}^{2}$. 
*	The term $\sigma_{\tau C}^{2}$ is the treatment-dependent variance of cases that was excluded in the definition of $\sigma_{C}^{2}$. So, if one were to sample cases and treatments for the same readers, the net variance would be $\sigma_{C}^{2}+\sigma_{\tau C}^{2}+\sigma_{\epsilon}^{2}$. 
*	The term $\sigma_{RC}^{2}$ is the treatment-independent variance of readers and cases that were excluded in the definitions of $\sigma_{R}^{2}$ and $\sigma_{C}^{2}$. So, if one were to sample readers and cases for the same treatment, the net variance would be  $\sigma_{R}^{2}+\sigma_{C}^{2}+\sigma_{RC}^{2}+\sigma_{\epsilon}^{2}$. 
*	The term $\sigma_{\tau RC}^{2}$ is the variance of treatments, readers and cases that were excluded in the definitions of all the preceding terms in TBA \@ref(eq:pseudoValPrime). So, if one were to sample treatments, readers and cases the net variance would be $\sigma_{R}^{2}+\sigma_{C}^{2}+\sigma_{\tau C}^{2}+\sigma_{RC}^{2}+\sigma_{\tau RC}^{2}+\sigma_{\epsilon}^{2}$. 
*	The last term, $\sigma_{\epsilon}^{2}$  describes the variance arising from different replications of the study using the same treatments, readers and cases. Measuring this variance requires repeating the study several ($N$) times with the same treatments, readers and cases, and computing the variance of $Y_{n(ijk)}$ , where the additional $n$-index refers to true replications, $n$ = 1, 2, ..., $N$. 

\begin{equation}
\sigma_{\epsilon}^{2}=\frac{1}{IJK}\sum_{i=1}^{I}\sum_{j=1}^{J}\sum_{k=1}^{k}\frac{1}{N-1}\sum_{n=1}^{N}\left ( Y_{n(ijk)} - Y_{\bullet (ijk)} \right )^2
(\#eq:EstimatingEpsilon)
\end{equation}

The right hand side of TBA \@ref(eq:pseudoValPrime) is the variance of $Y_{n(ijk)}$, for specific $ijk$, with respect to the replication index $n$, averaged over all $ijk$. In practice $N$ = 1 (i.e., there are no replications) and this variance cannot be estimated (it would imply dividing by zero). It has the meaning of *reader inconsistency*, usually termed *within-reader* variability. As will be shown later, the presence of this inestimable term does not limit ones ability to perform significance testing on the treatment effect without having to replicate the whole study, as implied in earlier work [@RN1450].

An equation like TBA \@ref(eq:pseudoValPrime) is termed a *linear model* with the left hand side, the pseudovalue "observations", modeled by a sum of fixed and random terms. Specifically it is a *mixed model*, because the right hand side has both fixed and random effects. Statistical methods have been developed for analysis of such linear models. One estimates the terms on the right hand side of TBA \@ref(eq:pseudoValPrime), it being understood that for the random effects, one estimates the variances of the zero-mean normal distributions, TBA \@ref(eq:pseudoValPrime)Eqn. (9.7), from which the samples are obtained (by assumption).

Estimating the fixed effects is trivial. The term $\mu$ is estimated by averaging the left hand side of TBA \@ref(eq:pseudoValPrime)Eqn. (9.4) over all three indices (since $N$ = 1): $\mu=Y_{\bullet \bullet \bullet}$

Because of the way the treatment effect is defined, TBA \@ref(eq:pseudoValPrime) Eqn. (9.5), averaging, which involves summing, over the treatment-index $i$, yields zero, and all of the remaining random terms yield zero upon averaging, because they are individually sampled from zero-mean normal distributions. To estimate the treatment effect one takes the difference $\tau_i=Y_{\bullet \bullet \bullet}-\mu$.

It can be easily seen that the reader and case averaged difference between two different treatments $i$ and $i'$  is estimated by $\tau_i-\tau_{i'} = Y_{i \bullet \bullet} - Y_{i' \bullet \bullet}$.

Estimating the strengths of the random terms is a little more complicated. It involves methods adapted from least squares, or maximum likelihood, and more esoteric ways. I do not feel comfortable going into these methods. Instead, results are presented and arguments are made to make them plausible. The starting point is definitions of quantities called **mean squares** and their expected values.

### Definitions of mean-squares 
Again, to be clear, one chould put a $Y$ subscript (or superscript) on each of the following definitions, but that would make the notation unnecessarily cumbersome. 

*In this chapter, all mean-square quantities are calculated using pseudovalues, not figure-of-merit values. The presence of three subscripts on Y should make this clear. Also the replication index and the nesting notation are suppressed. The notation is abbreviated so MST is the mean square corresponding to the treatment effect, etc.*

The definitions of the mean-squares below match those (where provided) in [@RN1476, page 1261]. 

\begin{align}
\left.\begin{array}{rll}
\text{MST}&=&\frac{JK\sum_{i=1}^{I}\left ( Y_{i \bullet \bullet} - Y_{ \bullet \bullet \bullet} \right )^2}{I-1}\\[0.5em]
\text{MSR}&=&\frac{IK\sum_{j=1}^{J}\left ( Y_{\bullet j \bullet} - Y_{ \bullet \bullet \bullet} \right )^2}{J-1}\\[0.5em] 
\text{MS(C)}&=&\frac{IJ\sum_{k=1}^{K}\left ( Y_{\bullet \bullet k} - Y_{ \bullet \bullet \bullet} \right )^2}{K-1}\\[0.5em] 
\text{MSTR}&=&\frac{K\sum_{i=1}^{I}\sum_{j=1}^{J}\left ( Y_{i j \bullet} - Y_{i \bullet \bullet} - Y_{\bullet j \bullet} + Y_{ \bullet \bullet \bullet} \right )^2}{(I-1)(J-1)}\\[0.5em] 
\text{MSTC}&=&\frac{J\sum_{i=1}^{I}\sum_{k=1}^{K}\left ( Y_{i \bullet k} - Y_{i \bullet \bullet} - Y_{\bullet \bullet k} + Y_{ \bullet \bullet \bullet} \right )^2}{(I-1)(K-1)}\\[0.5em] 
\text{MSRC}&=&\frac{I\sum_{j=1}^{J}\sum_{k=1}^{K}\left ( Y_{\bullet j k} - Y_{\bullet j \bullet} - Y_{\bullet \bullet k} + Y_{ \bullet \bullet \bullet} \right )^2}{(J-1)(K-1)}\\[0.5em] 
\text{MSTRC}&=&\frac{\sum_{i=1}^{I}\sum_{j=1}^{J}\sum_{k=1}^{K}\left ( Y_{i j k} - Y_{i j \bullet} - Y_{i \bullet k} - Y_{\bullet j k} + Y_{i \bullet \bullet} + Y_{\bullet j \bullet} + Y_{\bullet \bullet k} - Y_{ \bullet \bullet \bullet} \right )^2}{(I-1)(J-1)K-1)}
\end{array}\right\}
(\#eq:MeanSquares)
\end{align}

Note the absence of $MSE$, corresponding to the $\epsilon$ term on the right hand side of \@ref(eq:MeanSquares). With only one observation per treatment-reader-case combination, MSE cannot be estimated; it effectively gets absorbed into the $MSTRC$ term. 

## Expected values of mean squares 
> "In our original formulation [2], expected mean squares for the ANOVA were derived from a restricted parameterization in which mixed-factor interactions sum to zero over indexes of fixed effects. In the restricted parameterization, the mixed effects are correlated, parameters are sometimes awkward to define [17], and extension to unbalanced designs is dubious [17, 18]. In this article, we recommend the unrestricted parameterization. The restricted and unrestricted parameterizations are special cases of a general model by Scheffe [19] that allows an arbitrary covariance structure among experimental units within a level of a random factor. Tables 1 and 2 show the ANOVA tables with expected mean squares for the unrestricted formulation."
>
> --- [@RN2079]

The *observed* mean squares defined in Equation \@ref(eq:MeanSquares) can be calculated directly from the *observed* pseudovalues. The next step in the analysis is to obtain expressions for their *expected* values in terms of the variances defined in \@ref(eq:MeanSquares). Assuming no replications, i.e., $N$ = 1, the expected mean squares are as follows, Table Table \@ref(tab:ExpValMs); understanding how this table is derived, would lead the author well outside his expertise and the scope of this book; suffice to say that these are *unconstrained* estimates (as summarized in the quotation above) which are different from the *constrained* estimates appearing in the original DBM publication [@RN204]. 

Source          df               E(MS)
-------         ----             ------------------------------------------------------------
T               (I-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$ + $J\sigma_{\tau C}^{2}$ + $JK\sigma_{\tau}^{2}$ 
R               (J-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IK\sigma_{R}^{2}$ + $K\sigma_{\tau R}^{2}$
C               (K-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IJ\sigma_{C}^{2}$ + $J\sigma_{\tau C}^{2}$
TR              (I-1)(J-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$  
TC              (I-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $J\sigma_{\tau C}^{2}$
RC              (J-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ 
TRC             (I-1)(J-1)(K-1)  $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ 
$\epsilon$      $N-1=0$          $\sigma_{\epsilon}^{2}$

Table: (\#tab:ExpValMs) Unconstrained expected values of mean-squares, as in [@RN2079]

* In Table \@ref(tab:ExpValMs) the following notation is used as a shorthand:

\begin{equation}
\sigma_{\tau}^{2}=\frac{1}{I-1}\sum_{i=1}^{I}\left ( Y_{i \bullet \bullet} - Y_{\bullet \bullet \bullet} \right )^2
(\#eq:defnVarTau)
\end{equation}

Since treatment is a fixed effect, the variance symbol $\sigma_{\tau}^{2}$, which is used for notational consistency in Table \@ref(tab:ExpValMs), could cause confusion. The right hand side "looks like" a variance, indeed one that could be calculated for just two treatments but, of course, random sampling from a *distribution of treatments* is not the intent of the notation. 

## Random-reader random-case (RRRC) analysis {#DBMAnalysisSigtesting-RRRC-analysis}
Both readers and cases are regarded as random factors. The expected mean squares in Table Table \@ref(tab:ExpValMs) are variance-like quantities; specifically, they are weighted linear combinations of the variances appearing in \@ref(eq:samplingOfDbmTerms). For single factors the column headed "degrees of freedom" ($df$) is one less than the number of levels of the corresponding factor; estimating a variance requires first estimating the mean, which imposes a constraint, thereby decreasing $df$ by one. For interaction terms, $df$ is the product of the degrees of freedom for the individual factors. As an example, the term $(\tau RC)_{ijk}$ contains three individual factors, and therefore $df = (I-1)(J-1)(K-1)$. The number of degrees of freedom can be thought of as the amount of information available in estimating a mean square. As a special case, with no replications, the $\epsilon$ term has zero $df$ as $N-1 = 0$. With only one observation $Y_{1(ijk)}$ there is no information to estimate the variance corresponding to the $\epsilon$  term. To estimate this term one needs to replicate the study several times – each time the same readers interpret the same cases in all treatments – a very boring task for the reader and totally unnecessary from the researcher's point of view.

### Calculation of mean squares: an example
* We choose `dataset02` to illustrate calculation of mean squares for pseudovalues. This is referred to in the book as the "VD" dataset [@RN1993]. It consists of 114 cases, 45 of which are diseased, interpreted in two treatments by five radiologists using the ROC paradigm. 

* The first line computes the pseudovalues using the `RJafroc` function `UtilPseudoValues()`, and the second line extracts the numbers of treatments, readers and cases. The following lines calculate, using Equation \@ref(eq:MeanSquares) the mean-squares. After displaying the results of the calculation, the results are compared to those calculated by the `RJafroc` function `UtilMeanSquares()`.


```r
Y <- UtilPseudoValues(dataset02, FOM = "Wilcoxon")$jkPseudoValues

I <- dim(Y)[1];J <- dim(Y)[2];K <- dim(Y)[3]

msT <- 0
for (i in 1:I)  {
  msT <- msT + (mean(Y[i, , ]) - mean(Y))^2
}
msT <- msT * J * K/(I - 1)

msR <- 0
for (j in 1:J) {
  msR <- msR + (mean(Y[, j, ]) - mean(Y))^2
}
msR <- msR * I * K/(J - 1)

msC <- 0
for (k in 1:K) {
  msC <- msC + (mean(Y[, , k]) - mean(Y))^2
}
msC <- msC * I * J/(K - 1)

msTR <- 0
for (i in 1:I) {
  for (j in 1:J) {
    msTR <- msTR + 
      (mean(Y[i, j, ]) - mean(Y[i, , ]) - mean(Y[, j, ]) + mean(Y))^2
  }
}
msTR <- msTR * K/((I - 1) * (J - 1))

msTC <- 0
for (i in 1:I) {
  for (k in 1:K) {
    msTC <- msTC + 
      (mean(Y[i, , k]) - mean(Y[i, , ]) - mean(Y[, , k]) + mean(Y))^2
  }
  msTC <- msTC * J/((I - 1) * (K - 1))
} 

msTC <- 0
for (i in 1:I) {
  for (k in 1:K) { # OK
    msTC <- msTC + 
      (mean(Y[i, , k]) - mean(Y[i, , ]) - mean(Y[, , k]) + mean(Y))^2
  }
}
msTC <- msTC * J/((I - 1) * (K - 1))

msRC <- 0
for (j in 1:J) {
  for (k in 1:K) {
    msRC <- msRC + 
      (mean(Y[, j, k]) - mean(Y[, j, ]) - mean(Y[, , k]) + mean(Y))^2
  }
}
msRC <- msRC * I/((J - 1) * (K - 1))

msTRC <- 0
for (i in 1:I) {
  for (j in 1:J) {
    for (k in 1:K) {
      msTRC <- msTRC + (Y[i, j, k] - mean(Y[i, j, ]) - 
                          mean(Y[i, , k]) - mean(Y[, j, k]) + 
                          mean(Y[i, , ]) + mean(Y[, j, ]) + 
                          mean(Y[, , k]) - mean(Y))^2
    }
  }
}
msTRC <- msTRC/((I - 1) * (J - 1) * (K - 1))

data.frame("msT" = msT, "msR" = msR, "msC" = msC, 
           "msTR" = msTR, "msTC" = msTC, 
           "msRC" = msRC, "msTRC" = msTRC)
#>         msT       msR       msC       msTR       msTC       msRC     msTRC
#> 1 0.5467634 0.4373268 0.3968699 0.06281749 0.09984808 0.06450106 0.0399716

as.data.frame(UtilMeanSquares(dataset02)[1:7])
#>         msT       msR       msC       msTR       msTC       msRC     msTRC
#> 1 0.5467634 0.4373268 0.3968699 0.06281749 0.09984808 0.06450106 0.0399716
```

### Significance testing {#DBMAnalysisSigtesting-sig-testing}
If the NH of no treatment effect is true, i.e., if $\sigma_{\tau}^{2}$ = 0, then according to Table \@ref(tab:ExpValMs) the following holds (the last term in the row labeled $T$ in Table \@ref(tab:ExpValMs) drops out):

\begin{equation}
E\left ( MST\mid NH \right ) = \sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2} + K\sigma_{\tau R}^{2} + J\sigma_{\tau C}^{2}
(\#eq:ExpMST)
\end{equation}

Also, the following linear combination is equal to $E\left ( MST\mid NH \right )$:

\begin{align}
\begin{split}
&E\left ( MSTR \right ) + E\left ( MSTC \right )  - E\left ( MSTRC \right ) \\
&= \left (\sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2} + K\sigma_{\tau R}^{2} \right ) + \left (\sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2} + J\sigma_{\tau C}^{2} \right ) -\left (\sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2}  \right ) \\
&= \sigma_{\epsilon}^{2} + \sigma_{\tau RC}^{2} + J \sigma_{\tau C}^{2} +  K\sigma_{\tau R}^{2} \\
&= E\left ( MST\mid NH \right )
\end{split}
(\#eq:linearComb)
\end{align}

Therefore, under the NH, the ratio: 

\begin{equation}
\frac{E\left ( MST\mid NH \right )}{E\left ( MSTR \right ) + E\left ( MSTC \right )  - E\left ( MSTRC \right )} = 1
(\#eq:ConstrFRatio)
\end{equation}

In practice, one does not know the expected values – that would require averaging each of these quantities, regarded as random variables, over their respective distributions. Therefore, one defines the following statistic, denoted  $F_{DBM}$, using the observed values of the mean squares, calculated almost trivially as in the previous example, using their definitions in Equation \@ref(eq:MeanSquares):

\begin{equation}
F_{DBM} = \frac{MST}{MSTR + MSTC - MSTRC}
(\#eq:DefFStatRRRC)
\end{equation}

$F_{DBM}$ is a realization of a random variable. A non-zero treatment effect, i.e.,  $\sigma_{\tau}^{2} > 0$, will cause the ratio to be larger than one, because $E\left ( MST \right)$  will be larger, see row labeled $T$ in Table \@ref(tab:ExpValMs). Therefore values of $F_{DBM} > 1$  will tend to reject the NH. Drawing on a theorem from statistics [@RN1492], under the NH the ratio of two independent mean squares is distributed as a (central) F-statistic with degrees of freedom corresponding to those of the mean squares forming the numerator and denominator of the ratio (Theorem 12.2.5 in “An Introduction to Mathematical Statistics and Its Applications”). To perform  hypothesis testing one needs the distribution,  under the NH, of the statistic defined by Eqn. \@ref(eq:DefFStatRRRC). This is completely analogous to Chapter 08 where knowledge of the distribution of AUC under the NH enabled testing the null hypothesis that the observed value of AUC equals a pre-specified value. 

Under the NH, $F_{DBM|NH}$ is distributed according to the F-distribution characterized by two numbers: 

* A numerator degrees of freedom ($\text{ndf}$) – determined by the degrees of freedom of the numerator, $MST$, of the ratio comprising the F-statistic, i.e., $I – 1$, and 
* A denominator degrees of freedom ($\text{ddf}$) - determined by the degrees of freedom of the denominator, $MSTR + MSTC - MSTRC$, of the ratio comprising the F-statistic, to be described in the next section. 

Summarizing,

\begin{align}
\left.\begin{array}{rll}
F_{DBM|NH} \sim F_{\text{ndf},\text{ddf}} \\
\text{ndf}=I-1
\end{array}\right\}
(\#eq:NhDistrDBMDefFStatRRRC)
\end{align}

The next topic is estimating $ddf$.

### The Satterthwaite approximation
The denominator of the F-ratio is $MSTR+MSTC-MSTRC$. This is not a *simple* mean square (I am using terminology in the Satterthwaite papers - he means any mean square defined by equations such as in Equation \@ref(eq:MeanSquares)). Rather it is a *linear combination of mean squares* (with coefficients 1, 1 and -1), and the resulting value could even be negative leading to a negative $F_{DBM|NH}$, which is an illegal value for a sample from an F-distribution (a ratio of two variances). In 1941 Satterthwaite [@RN2359; @RN2360] proposed an approximate degree of freedom for a linear combination of simple mean square quantities. TBA Online Appendix 9.A explains the approximation in more detail. The end result is that the mean square quantity described in Equation \@ref(eq:DefFStatRRRC) has an approximate degree of freedom defined by (this is called the *Satterthwaite's approximation*):

\begin{equation}
ddf_{Sat}=\frac{\left ( MSTR + MSTC - MSTRC \right )^2}{\left ( \frac{MSTR^2}{(I-1)(J-1)} + \frac{MSTC^2}{(I-1)(K-1)} + \frac{MSTRC^2}{(I-1)(J-1)(K-1)}  \right )}
(\#eq:ddfSatter)
\end{equation}

The subscript $Sat$ is for Satterthwaite. From Equation \@ref(eq:ddfSatter) it should be fairly obvious that in general $ddf_{Sat}$ is not an integer. To accommodate possible negative estimates of the denominator of Equation \@ref(eq:ddfSatter), the original DBM method [@RN204] proposed, depending on the signs of $\sigma_{\tau R}^2$ and $\sigma_{\tau C}^2$, four expressions for the F-statistic and corresponding expressions for $ddf$. Rather than repeat them here, since they have been superseded by the method described below, the interested reader is referred to Eqn. 6 and Eqn. 7 in Reference [@RN1866].

Instead Hillis [@RN1865] proposed the following statistic for testing the null hypothesis: 

\begin{equation}
F_{DBM} = \frac{MST}{MSTR + \max \left (MSTC - MSTRC, 0  \right )}
(\#eq:FStatHillis)
\end{equation}

Now the denominator cannot be negative. One can think of the F-statistic $F_{DBM}$ as a signal-to-noise ratio like quantity, with the difference that both numerator and denominator are variance like quantities. If the "variance" represented by the treatment effect is larger than the variance of the noise tending to mask the treatment effect, then $F_{DBM}$  tends to be large, which makes the observed treatment "variance" stand out more clearly compared to the noise, and the NH is more likely to be rejected. Hillis in [@RN1772] has shown that the left hand side of Equation \@ref(eq:FStatHillis) is distributed as an F-statistic with $\text{ndf} = I-1$ and denominator degrees of freedom $ddf_H$ defined by:

\begin{equation}
ddf_H =\frac{\left ( MSTR + \max \left (MSTC - MSTRC,0  \right ) \right )^2}{\text{MSTR}^2}(I-1)(J-1)
(\#eq:DefddfH)
\end{equation}

Summarizing,

\begin{equation}
F_{DBM} \sim F_{\text{ndf},\text{ddf}_H} \\
\text{ndf}=I-1
(\#eq:NhDistrDBMDefFStatRRRCHillis)
\end{equation}

Instead of 4 rules, as in the original DBM method, the Hillis modification involves just one rule, summarized by Equations \@ref(eq:DefddfH) through \@ref(eq:NhDistrDBMDefFStatRRRCHillis). Moreover, the F-statistic is constrained to non-negative values. Using simulation testing [@RN1866] he has been shown that the modified DBM method has better null hypothesis behavior than the original DBM method. The latter tended to be too conservative, typically yielding Type I error rates smaller than the expected 5% for $\alpha$ = 0.05. 

### Decision rules, p-value and confidence intervals
The *critical* value of the F-distribution, denoted $F_{1-\alpha,\text{ndf},\text{ddf}_H}$, is defined such that fraction $1-\alpha$ of the distribution lies to the left of the critical value, in other words it is the $1-\alpha$ *quantile* of the F-distribution: 

\begin{equation}
\Pr\left ( F\leq F_{1-\alpha,\text{ndf},\text{ddf}_H} \mid F\sim F_{\text{ndf},\text{ddf}_H}\right ) = 1 - \alpha
(\#eq:critValFStat)
\end{equation}

The critical value $F_{1-\alpha,\text{ndf},\text{ddf}_H}$ increases as $\alpha$ decreases. The value of $\alpha$, generally chosen to be 0.05, termed the *nominal* $\alpha$, is fixed. The decision rule is that if $F_{DBM} > F_{1-\alpha, \text{ndf}, \text{ddf}_H}$ one rejects the NH and otherwise one does not. It follows, from the definition of $F_{DBM}$, Equation \@ref(eq:FStatHillis), that rejection of the NH is more likely to occur if:

* $F_{DBM}$ is large, which occurs if $MST$ is large, meaning the treatment effect is large
* $MSTR + \max \left (MSTC - MSTRC,0  \right )$ is small, see comments following TBA \@ref(eq:pseudoValPrime) Eqn. (9.23). 
*	$\alpha$ is large: for then $F_{1-\alpha,\text{ndf},\text{ddf}_H}$ decreases and is more likely to be exceeded by the observed value of $F_{DBM}$. 
*	\text{ndf} is large: the more the number of treatment pairings, the greater the chance that at least one pairing will reject the NH. This is one reason sample size calculations are rarely conducted for more than 2-treatments. 
* $\text{ddf}_H$	is large: this causes the critical value to decrease, see below, and is more likely to be exceeded by the observed value of $F_{DBM}$. 

#### p-value of the F-test 
**The p-value of the test is the probability, under the NH, that an equal or larger value of the F-statistic than observed $F_{DBM}$ could occur by chance.** In other words, it is the area under the (central) F-distribution $F_{\text{ndf},\text{ddf}}$ that lies to the right of the observed value of $F_{DBM}$:

\begin{equation}
p=\Pr\left ( F > F_{DBM} \mid F \sim F_{\text{ndf},\text{ddf}_H} \right )
(\#eq:pValueRRRC)
\end{equation}

#### Confidence intervals for inter-treatment FOM differences
If $p < \alpha$ then the NH that all treatments are identical is rejected at significance level $\alpha$. That informs the researcher that there exists at least one treatment-pair that has a difference significantly different from zero. To identify which pair(s) are different, one calculates confidence intervals for each paired difference. Hillis in [@RN1772] has shown that the $(1-\alpha)$ confidence interval for $Y_{i \bullet \bullet} - Y_{i' \bullet \bullet}$ is given by:

\begin{equation}
CI_{1-\alpha}=\left ( Y_{i \bullet \bullet} - Y_{i' \bullet \bullet} \right ) \pm t_{\alpha/2;\text{ddf}_H} \sqrt{\frac{2}{JK}\left ( MSTR + \max\left ( MSTC-MSTRC,0 \right ) \right )}
(\#eq:CIRRRCDBM)
\end{equation}

Here $t_{\alpha/2;\text{ddf}_H}$ is that value such that $\alpha/2$  of the *central t-distribution* with  $\text{ddf}_H$ degrees of freedom is contained in the upper tail of the distribution: 

\begin{equation}
\Pr\left ( T>t_{\alpha/2;\text{ddf}_H} \right )=\alpha/2
(\#eq:tDistTailProb)
\end{equation}

Since centered pseudovalues were used:   

\begin{equation}
\left ( Y_{i \bullet \bullet} - Y_{i' \bullet \bullet} \right )=\left ( \theta_{i \bullet } - \theta_{i' \bullet} \right )
\end{equation}

Therefore, Equation \@ref(eq:CIRRRCDBM) can be rewritten:

\begin{equation}
CI_{1-\alpha}=\left ( \theta_{i \bullet} - \theta_{i' \bullet} \right ) \pm t_{\alpha/2;\text{ddf}_H} \sqrt{\frac{2}{JK}\left ( MSTR + \max\left ( MSTC-MSTRC,0 \right ) \right )}
(\#eq:confIntervalRRRC)
\end{equation}

For two treatments any of the following equivalent rules could be adopted to reject the NH: 

* $F_{DBM} > F_{1-\alpha,\text{ndf},\text{ddf}_H}$
* $p < \alpha$
* $CI_{1-alpha}$ excludes zero

For more than two treatments the first two rules are equivalent and if a significant difference is found using either of them, then one can use the confidence intervals to determine which treatment pair differences are significantly different from zero. The first F-test is called the *overall F-test* and the subsequent tests the *treatment-pair t-tests*. One only conducts treatment pair t-tests if the overall F-test yields a significant result.

#### Code illustrating the F-statistic, ddf and p-value for RRRC analysis, Van Dyke data
Line 1 defines $\alpha$. Line 2 forms a data frame from previously calculated mean-squares. Line 3 calculates the denominator appearing in Equation \@ref(eq:FStatHillis). Line 4 computes the observed value of $F_{DBM}$, namely the ratio of the numerator and denominator in Equation \@ref(eq:FStatHillis). Line 5 sets $\text{ndf}$ to $I - 1$. Line 6 computes $\text{ddf}_H$. Line 7 computes the critical value of the F-distribution $F_{crit}\equiv F_{\text{ndf},\text{ddf}_H}$. Line 8 calculates the p-value, using the definition Equation \@ref(eq:pValueRRRC). Line 9 prints out the just calculated quantities. The next line uses the `RJafroc` function `StSignificanceTesting()` and the 2nd last line prints out corresponding `RJafroc`-computed quantities. Note the correspondences between the values just computed and those provide by `RJafroc`. Note that the FOM difference is not significant at the 5% level of significance as $p > \alpha$. The last line shows that $F_{DBM}$ does not exceed $F_{crit}$. The two rules are equivalent.


```r
alpha <- 0.05
retMS <- data.frame("msT" = msT, "msR" = msR, "msC" = msC, 
                    "msTR" = msTR, "msTC" = msTC, 
                    "msRC" = msRC, "msTRC" = msTRC)
F_DBM_den <- retMS$msTR+max(retMS$msTC - retMS$msTRC,0) 
F_DBM <- retMS$msT / F_DBM_den 
ndf <- (I-1)
ddf_H <- (F_DBM_den^2/retMS$msTR^2)*(I-1)*(J-1)
FCrit <- qf(1 - alpha, ndf, ddf_H)
pValueH <- 1 - pf(F_DBM, ndf, ddf_H)
data.frame("F_DBM" = F_DBM, "ddf_H"= ddf_H, "pValueH" = pValueH) # Line 9
#>      F_DBM    ddf_H    pValueH
#> 1 4.456319 15.25967 0.05166569
retRJafroc <- StSignificanceTesting(dataset02, 
                                    FOM = "Wilcoxon",
                                    method = "DBM")
data.frame("F_DBM" = retRJafroc$RRRC$FTests$FStat[1], 
           "ddf_H"= retRJafroc$RRRC$FTests$DF[2], 
           "pValueH" = retRJafroc$RRRC$FTests$p[1])
#>       F_DBM     ddf_H     pValueH
#> 1 4.4563187 15.259675 0.051665686
F_DBM > FCrit
#> [1] FALSE
```

#### Code illustrating the inter-treatment confidence interval for RRRC analysis, Van Dyke data
Line 1 computes the FOM matrix using function `UtilFigureOfMerit`. The next 9 lines compute the treatment FOM differences. The next line `nDiffs` (for "number of differences") evaluates to 1, as with two treatments, there is only one difference. The next line initializes `CI_DIFF_FOM_RRRC`, which stands for "confidence intervals, FOM differences, for RRRC analysis". The next 8 lines evaluate, using Equation \@ref(eq:confIntervalRRRC), and prints the lower value, the mid-point and the upper value of the confidence interval. Finally, these values are compared to those yielded by `RJafroc`. The FOM difference is not significant, whether viewed from the point of view of the F-statistic not exceeding the critical value, the observed p-value being larger than alpha or the 95% CI for the FOM difference including zero. 

```r
theta <- as.matrix(UtilFigureOfMerit(dataset02, FOM = "Wilcoxon"))
theta_i_dot <- array(dim = I)
for (i in 1:I) theta_i_dot[i] <- mean(theta[i,])
trtDiff <- array(dim = c(I,I))
for (i1 in 1:(I-1)) {    
  for (i2 in (i1+1):I) {
    trtDiff[i1,i2] <- theta_i_dot[i1]- theta_i_dot[i2]    
  }
}
trtDiff <- trtDiff[!is.na(trtDiff)]
nDiffs <- I*(I-1)/2
CI_DIFF_FOM_RRRC <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_RRRC[i,1] <- qt(alpha/2,df = ddf_H)*sqrt(2*F_DBM_den/J/K) + trtDiff[i]
  CI_DIFF_FOM_RRRC[i,2] <- trtDiff[i]
  CI_DIFF_FOM_RRRC[i,3] <- qt(1-alpha/2,df = ddf_H)*sqrt(2*F_DBM_den/J/K) + trtDiff[i]
  print(data.frame("Lower" = CI_DIFF_FOM_RRRC[i,1], 
                   "Mid" = CI_DIFF_FOM_RRRC[i,2], 
                   "Upper" = CI_DIFF_FOM_RRRC[i,3]))
}
#>          Lower          Mid         Upper
#> 1 -0.087959499 -0.043800322 0.00035885444
data.frame("Lower" = retRJafroc$RRRC$ciDiffTrt[1,"CILower"], 
           "Mid" = retRJafroc$RRRC$ciDiffTrt[1,"Estimate"], 
           "Upper" = retRJafroc$RRRC$ciDiffTrt[1,"CIUpper"])
#>          Lower          Mid         Upper
#> 1 -0.087959499 -0.043800322 0.00035885444
```


## Sample size estimation for random-reader random-case generalization
### The non-centrality parameter
In the significance-testing procedure just described, the relevant distribution was that of the F-statistic when the NH is true, Equation \@ref(eq:NhDistrDBMDefFStatRRRCHillis). *For sample size estimation, one needs to know the distribution of the statistic when the NH is false.* In the latter condition (i.e., the AH) the observed F-statistic, defined by Equation \@ref(eq:DefFStatRRRC), is distributed as a *non-central* F-distribution  $F_{\text{ndf},{\text{ddf}}_H,\Delta}$ with *non-centrality parameter* $\Delta$: 

\begin{equation}
F_{DBM|AH} \sim F_{\text{ndf},ddf_H,\Delta}
(\#eq:AhDistrDBMFStatRRRC)
\end{equation}

The non-centrality parameter $\Delta$ is defined, compare [@RN1476] Eqn. 6, by:

\begin{equation*}
\Delta=\frac{JK\sigma_{\tau}^2}{\sigma_{\epsilon}^2+K\sigma_{\tau R}^2+J\sigma_{\tau C}^2}
\end{equation*}

The parameters $\sigma_{\tau}^2$, $\sigma_{\tau R}^2$ and $\sigma_{\tau C}^2$ appearing in this equation are identical to three of the six variances describing the DBM model, Equation \@ref(eq:DefDBMModel). The estimates of $\sigma_{\tau R}^2$ and/or $\sigma_{\tau C}^2$ can turn out to be negative (if either of these parameters is close to zero, an estimate from a small pilot study can be negative). To avoid a possibly negative denominator, [@RN1476] suggest the following modifications (see sentence following Eqn. 4 in cited paper):

\begin{equation}
\Delta=\frac{JK\sigma_{\tau}^2}{\sigma_{\epsilon}^2+\max(K\sigma_{\tau R}^2,0)+\max(J\sigma_{\tau C}^2,0)}
(\#eq:DefDelta)
\end{equation}

The observed effect size $d$, a realization of a random variable, is defined by (the bullet represents an average over the reader index):

\begin{equation}
d=\theta_{1\bullet}-\theta_{2\bullet}
(\#eq:EffectSize)
\end{equation}

For two treatments, since the individual treatment effects must be the negatives of each other (because they sum to zero, see \@ref(eq:constraintTau)), it follows that:

\begin{equation}
\sigma_{\tau}^2=\frac{d^2}{2}
(\#eq:sigma2Tau)
\end{equation}
 
Therefore, for two treatments the numerator of the expression for $\Delta$ is $JKd^2/2$. Dividing numerator and denominator of Equation \@ref(eq:DefDelta) by $K$, one gets the final expression for $\Delta$, as coded in `RJafroc`, namely:

\begin{equation}
\Delta=\frac{Jd^2/2}{\max(\sigma_{\tau R}^2,0)+(\sigma_{\epsilon}^2+\max(J\sigma_{\tau C}^2,0))/K}
(\#eq:DeltaCoded)
\end{equation}

The variances, $\sigma_{\tau}^2$, $\sigma_{\tau R}^2$ and $\sigma_{\tau C}^2$, appearing in Equation \@ref(eq:DeltaCoded), can be calculated from the observed mean squares using the following equations, see [@RN1476] Eqn. 4, 

\begin{equation}
\left.\begin{array}{rl}
\sigma_{\epsilon}^2&={\text{MSTRC}}^*\\[1em] 
\sigma_{\tau R}^2&=\displaystyle\frac{{\text{MSTR}}^*-{\text{MSTRC}}^*}{K^*}\\[1em]
\sigma_{\tau C}^2&=\displaystyle\frac{{\text{MSTC}}^*-{\text{MSTRC}}^*}{J^*}
\end{array}\right\}
(\#eq:HBEqn4Pilot)
\end{equation}

* Here the asterisk is used to (consistently) denote quantities, including the mean squares, pertaining to the *pilot* study. 
* In particular, $J^*$ and $K^*$ denote the numbers of readers and cases, respectively, *in the pilot study*, while $J$ and $K$, appearing elsewhere, for example in Equation \@ref(eq:DeltaCoded), are the corresponding numbers for the *planned or pivotal study*. 
* The three variances, determined from the pilot study via Equation \@ref(eq:HBEqn4Pilot), are assumed to apply unchanged to the pivotal study (as they are sample-size independent parameters of the DBM model). 

### The denominator degrees of freedom
* (The numerator degrees of freedom of the non-central $F$ distribution is always unity.) It remains to calculate the appropriate denominator degrees of freedom for the pivotal study. This is denoted $df_2$, to distinguish it from $ddf_H$, where the latter applies to the pilot study as in Equation \@ref(eq:DefddfH). 
* The starting point is Equation \@ref(eq:DefddfH) with the left hand side replaced by $df_2$, and with the emphasis that *all quantities appearing in it apply to the pivotal study*. 
* The mean squares appearing in Equation \@ref(eq:DefddfH) can be related to the variances by an equation analogous to Equation \@ref(eq:HBEqn4Pilot), except that, again, all quantities in it apply to the *pivotal* study (note the absence of asterisks): 

\begin{equation}
\left.\begin{array}{rl}
\sigma_{\epsilon}^2&=MSTRC\\[1em]
\sigma_{\tau R}^2&=\displaystyle\frac{MSTR-MSTRC}{K}\\[1em]
\sigma_{\tau C}^2&=\displaystyle\frac{MSTC-MSTRC}{J}
\end{array}\right\}
(\#eq:HBEqn4Pivotal)
\end{equation}

Substituting from Equation \@ref(eq:HBEqn4Pivotal) into Equation \@ref(eq:DefddfH) with the left hand side replaced by $df_2$, and dividing numerator and denominator by $K^2$, one has the final expression as coded in `RJafroc`:

\begin{equation}
df_2 = \frac{(\max(\sigma_{\tau R}^2,0)+(\max(J\sigma_{\tau C}^2,0)+\sigma_{\epsilon}^2)/K)^2}{(\max(\sigma_{\tau R}^2,0)+\sigma_{\epsilon}^2/K)^2}(J-1)
(\#eq:ddfCoded)
\end{equation}

### Example of sample size estimation, RRRC generalization
The Van Dyke dataset is regarded as a pilot study. In the first block of code function `StSignificanceTesting()` is used to get the DBM variances (i.e., `VarTR` = $\sigma_{\tau R}^2$, etc.) and the effect size $d$. 


```r
rocData <- dataset02 # select Van Dyke dataset
retDbm <- StSignificanceTesting(dataset = rocData,
                                FOM = "Wilcoxon",
                                method = "DBM") 
VarTR <- retDbm$ANOVA$VarCom["VarTR","Estimates"]
VarTC <- retDbm$ANOVA$VarCom["VarTC","Estimates"]
VarErr <- retDbm$ANOVA$VarCom["VarErr","Estimates"]
d <- retDbm$FOMs$trtMeanDiffs["trt0-trt1","Estimate"]
```

The observed effect size is -0.04380032. The sign is negative as the reader-averaged second modality has greater FOM than the first. The next code block shows implementation of the RRRC formulae just presented. The values of $J$ and $K$ were preselected to achieve 80% power, as verified from the final line of the output. 


```r
#RRRC
J <- 10; K <- 163
den <- max(VarTR, 0) + (VarErr + J * max(VarTC, 0)) / K 
deltaRRRC <- (d^2 * J/2) / den
df2 <- den^2 * (J - 1) / (max(VarTR, 0) + VarErr / K)^2
fvalueRRRC <- qf(1 - alpha, 1, df2)
Power <- 1-pf(fvalueRRRC, 1, df2, ncp = deltaRRRC)
data.frame("J"= J,  "K" = K, "fvalueRRRC" = fvalueRRRC, "df2" = df2, "deltaRRRC" = deltaRRRC, "PowerRRRC" = Power)
#>    J   K fvalueRRRC       df2 deltaRRRC  PowerRRRC
#> 1 10 163  3.9930236 63.137871 8.1269825 0.80156249
```

## Significance testing and sample size estimation for fixed-reader random-case generalization
The extension to FRRC generalization is as follows. One sets $\sigma_R^2 = 0$ and $\sigma_{\tau R}^2 = 0$ in the DBM model \@ref(eq:DefDBMModel). The F-statistic for testing the NH and its distribution under the NH is:

\begin{equation}
F=\frac{\text{MST}}{\text{MSTC}} \sim F_{I-1,(I-1)(K-1)}
(\#eq:DefFStatFRRC-DBM1)
\end{equation}

The NH is rejected if the observed value of $F$ exceeds the critical value defined by $F_{\alpha, I-1,(I-1)(K-1)}$. For two modalities the denominator degrees of freedom is $df_2 = K-1$. The expression for the non-centrality parameter follows from \@ref(eq:DeltaCoded) upon setting $\sigma_{\tau R}^2 = 0$.

\begin{equation}
\Delta=\frac{Jd^2/2}{(\sigma_{\epsilon}^2+\max(J\sigma_{\tau C}^2,0))/K}
(\#eq:DefDeltaFRRC)
\end{equation}

These equations are coded in the following code-chunk:


```r
#FRRC
# set VarTC = 0 in RRRC formulae
J <- 10; K <- 133
den <- (VarErr + J * max(VarTC, 0)) / K
deltaFRRC <- (d^2 * J/2) / den
df2FRRC <- K - 1
fvalueFRRC <- qf(1 - alpha, 1, df2FRRC)
powerFRRC <- pf(fvalueFRRC, 1, df2FRRC, ncp = deltaFRRC, FALSE)
data.frame("J"= J,  "K" = K, "fvalueFRRC" = fvalueFRRC, "df2" = df2FRRC, "deltaFRRC" = deltaFRRC, "powerFRRC" = powerFRRC)
#>    J   K fvalueFRRC df2 deltaFRRC  powerFRRC
#> 1 10 133   3.912875 132 7.9873835 0.80111671
```

## Significance testing and sample size estimation for random-reader fixed-case generalization
The extension to RRFC generalization is as follows. One sets $\sigma_C^2 = 0$ and $\sigma_{\tau C}^2 = 0$ in the DBM model \@ref(eq:DefDBMModel). The F-statistic for testing the NH and its distribution under the NH is:

\begin{equation}
F=\frac{\text{MST}}{\text{MSTR}} \sim F_{I-1,(I-1)(J-1)}
(\#eq:DefFStatFRRC-DBM2)
\end{equation}

The NH is rejected if the observed value of $F$ exceeds the critical value defined by $F_{\alpha, I-1,(I-1)(J-1)}$. For two modalities the denominator degrees of freedom is $df_2 = J-1$. The expression for the non-centrality parameter follows from \@ref(eq:DeltaCoded) upon setting $\sigma_{\tau C}^2 = 0$.

\begin{equation}
\Delta=\frac{Jd^2/2}{\max(\sigma_{\tau R}^2,0)+\sigma_{\epsilon}^2/K}
(\#eq:DefDeltaRRFC)
\end{equation}

These equations are coded in the following code-chunk:


```r
#RRFC
# set VarTR = 0 in RRRC formulae
J <- 10; K <- 53
den <- max(VarTR, 0) + VarErr/K
deltaRRFC <- (d^2 * J/2) / den
df2RRFC <- J - 1
fvalueRRFC <- qf(1 - alpha, 1, df2RRFC)
powerRRFC <- pf(fvalueRRFC, 1, df2RRFC, ncp = deltaRRFC, FALSE)
data.frame("J"= J,  "K" = K, "fvalueRRFC" = fvalueRRFC, "df2" = df2RRFC, "deltaRRFC" = deltaRRFC, "powerRRFC" = powerRRFC)
#>    J  K fvalueRRFC df2 deltaRRFC  powerRRFC
#> 1 10 53   5.117355   9 10.048716 0.80496663
```

It is evident that for this dataset, for 10 readers, the numbers of cases needed for 80% power is largest (163) for RRRC and least for RRFC (53). For all three analyses, the expectation of 80% power is met - the numbers of cases and readers were deliberately chosen to achieve close to 80% statistical power.  

## Summary TBA {#DBMAnalysisSigtesting-summary}
This chapter has detailed analysis of MRMC ROC data using the DBM method. A reason for the level of detail is that almost all of the material carries over to other data collection paradigms, and a thorough understanding of the relatively simple ROC paradigm data is helpful to understanding the more complex ones. 

DBM has been used in several hundred ROC studies (Prof. Kevin Berbaum, private communication ca. 2010). While the method allows generalization of a study finding, e.g., rejection of the NH, to the population of readers and cases, the author believes this is sometimes taken too literally. If a study is done at a single hospital, then the radiologists tend to be more homogenous as compared to sampling radiologists from different hospitals. This is because close interactions between radiologists at a hospital tend to homogenize reading styles and performance. A similar issue applies to patient characteristics, which are also expected to vary more between different geographical locations than within a given location served by the hospital. This means is that single hospital study based p-values may tend to be biased downwards, declaring differences that may not be replicable if a wider sampling "net" were used using the same sample size. The price paid for a wider sampling net is that one must use more readers and cases to achieve the same sensitivity to genuine treatment effects, i.e., statistical power (i.e., there is no "free-lunch").

A third MRMC ROC method, due to Clarkson, Kupinski and Barrett19,20, implemented in open-source JAVA software by Gallas and colleagues22,44 (http://didsr.github.io/iMRMC/) is available on the web. Clarkson et al19,20 provide a probabilistic rationale for the DBM model, provided the figure of merit is the empirical $AUC$. The method is elegant but it is only applicable as long as one is using the empirical AUC as the figure of merit (FOM) for quantifying observer performance. In contrast the DBM approach outlined in this chapter, and the approach outlined in the following chapter, are applicable to any scalar FOM. Broader applicability ensures that significance-testing methods described in this, and the following chapter, apply to other ROC FOMs, such as binormal model or other fitted AUCs, and more importantly, to other observer performance paradigms, such as free-response ROC paradigm. An advantage of the Clarkson et al. approach is that it predicts truth-state dependence of the variance components. One knows from modeling ROC data that diseased cases tend to have greater variance than non-diseased ones, and there is no reason to suspect that similar differences do not exist between the variance components. 

Testing validity of an analysis method via simulation testing is only as good as the simulator used to generate the datasets, and this is where current research is at a bottleneck. The simulator plays a central role in ROC analysis. In the author's opinion this is not widely appreciated. In contrast, simulators are taken very seriously in other disciplines, such as cosmology, high-energy physics and weather forecasting. The simulator used to validate3 DBM is that proposed by Roe and Metz39 in 1997. This simulator has several shortcomings. (a) It assumes that the ratings are distributed like an equal-variance binormal model, which is not true for most clinical datasets (recall that the b-parameter of the binormal model is usually less than one). Work extending this simulator to unequal variance has been published3. (b) It does not take into account that some lesions are not visible, which is the basis of the contaminated binormal model (CBM). A CBM model based simulator would use equal variance distributions with the difference that the distribution for diseased cases would be a mixture distribution with two peaks. The radiological search model (RSM) of free-response data, Chapter 16 &17 also implies a mixture distribution for diseased cases, and it goes farther, as it predicts some cases yield no z-samples, which means they will always be rated in the lowest bin no matter how low the reporting threshold. Both CBM and RSM account for truth dependence by accounting for the underlying perceptual process. (c) The Roe-Metz simulator is out dated; the parameter values are based on datasets then available (prior to 1997). Medical imaging technology has changed substantially in the intervening decades. d Finally, the methodology used to arrive at the proposed parameter values is not clearly described. Needed is a more realistic simulator, incorporating knowledge from alternative ROC models and paradigms that is calibrated, by a clearly defined method, to current datasets. 

Since ROC studies in medical imaging have serious health-care related consequences, no method should be used unless it has been thoroughly validated. Much work still remains to be done in proper simulator design, on which validation is dependent.

## Things for me to think about
### Expected values of mean squares 

Assuming no replications the expected mean squares are as follows, Table Table \@ref(tab:ExpValMs); understanding how this table is derived, would lead the author well outside his expertise and the scope of this book; suffice to say that these are *unconstrained* estimates (as summarized in the quotation above) which are different from the *constrained* estimates appearing in the original DBM publication [@RN204], Table 9.2; the differences between these two types of estimates is summarized in [@RN2079]. For reference, Table 9.3 is the table published in the most recent paper that I am aware of [@RN2508]. All three tables are different! **In this chapter I will stick to Table Table \@ref(tab:ExpValMs) for the subsequent development.** 

Source          df               E(MS)
-------         ----             ------------------------------------------------------------
T               (I-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$ + $J\sigma_{\tau C}^{2}$ + $JK\sigma_{\tau}^{2}$ 
R               (J-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IK\sigma_{R}^{2}$ + $K\sigma_{\tau R}^{2}$
C               (K-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IJ\sigma_{C}^{2}$ + $J\sigma_{\tau C}^{2}$
TR              (I-1)(J-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$  
TC              (I-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $J\sigma_{\tau C}^{2}$
RC              (J-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ 
TRC             (I-1)(J-1)(K-1)  $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ 
$\epsilon$      $N-1=0$          $\sigma_{\epsilon}^{2}$

Table: Table 9.1 Unconstrained expected values of mean-squares, as in [@RN2079]

Source          df               E(MS)
-------         ----             ------------------------------------------------------------
T               (I-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$ + $J\sigma_{\tau C}^{2}$ + $JK\sigma_{\tau}^{2}$ 
R               (J-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IK\sigma_{R}^{2}$
C               (K-1)            $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ + $IJ\sigma_{C}^{2}$
TR              (I-1)(J-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$  
TC              (I-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $J\sigma_{\tau C}^{2}$
RC              (J-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $I\sigma_{RC}^{2}$ 
TRC             (I-1)(J-1)(K-1)  $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ 
$\epsilon$      0                $\sigma_{\epsilon}^{2}$

Table: Table 9.2 Constrained expected values of mean-squares, as in [@RN204] 

Source          df               E(MS)
-------         ----             ------------------------------------------------------------
T               (I-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$ + $J\sigma_{\tau C}^{2}$ + $JK\sigma_{\tau}^{2}$ 
R               (J-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $I\sigma_{RC}^{2}$ + $IK\sigma_{R}^{2}$ + $K\sigma_{\tau R}^{2}$
C               (K-1)            $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $I\sigma_{RC}^{2}$ + $IJ\sigma_{C}^{2}$ + $J\sigma_{\tau C}^{2}$
TR              (I-1)(J-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $K\sigma_{\tau R}^{2}$  
TC              (I-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $J\sigma_{\tau C}^{2}$
RC              (J-1)(K-1)       $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ + $I\sigma_{RC}^{2}$ 
TRC             (I-1)(J-1)(K-1)  $\sigma_{\epsilon}^{2}$ + $\sigma_{\tau RC}^{2}$ 
$\epsilon$      0                $\sigma_{\epsilon}^{2}$

Table: Table 9.3 As in Hillis "marginal-means ANOVA paper" [@RN2508]

## References {#DBMAnalysisSigtesting-references}


<!--chapter:end:09B-DBM-Analysis-SigTesting.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---

# DBM method special cases {#DBMSpecialCases}
Special cases of DBM analysis are described here, namely fixed-reader random-case (FRRC), sub-special case of which is Single-reader multiple-treatment analysis, and random-reader fixed-case (RRFC). 



## Fixed-reader random-case (FRRC) analysis {#FRRCDBMAnalysis}
The model is the same as in TBA \@ref(eq:pseudoValPrime) Eqn. (9.4) except one puts $\sigma_{R}^{2}$ = $\sigma_{\tau R}^{2}$ = 0 in Table Table \@ref(tab:ExpValMs). The appropriate test statistic is: 

\begin{equation}
\frac{E\left ( MST \right )}{E\left ( MSTC \right )} = \frac{\sigma_{\epsilon}^{2}+\sigma_{\tau RC}^{2}+J\sigma_{\tau C}^{2}+JK\sigma_{\tau}^{2}}{\sigma_{\epsilon}^{2}+\sigma_{\tau RC}^{2}+J\sigma_{\tau C}^{2}}
\end{equation}

Under the null hypothesis $\sigma_{\tau}^{2} = 0$:

\begin{equation}
\frac{E\left ( MST \right )}{E\left ( MSTC \right )} = 1
\end{equation}

The F-statistic is (replacing *expected* with *observed* values):

\begin{equation}
F_{DBM|R}=\frac{MST}{MSTC}
(\#eq:FStatFRRC-DBM)
\end{equation}

The observed value $F_{DBM|R}$ (the Roe-Metz notation [@RN1124] is used which indicates that the factor appearing to the right of the vertical bar is regarded as fixed) is distributed as an F-statistic with $\text{ndf}$ = $I – 1$ and $ddf = (I-1)(K-1)$; the degrees of freedom follow from the rows labeled $T$ and $TC$ in TBA Table Table \@ref(tab:ExpValMs). Therefore, the distribution of the observed value is (no Satterthwaite approximation needed this time as both numerator and denominator are simple mean-squares):

\begin{equation}
F_{DBM|R} \sim F_{I-1,(I-1)(K-1)}
(\#eq:SamplingFStatFRRC)
\end{equation}

The null hypothesis is rejected if the observed value of the F- statistic exceeds the critical value:

\begin{equation}
F_{DBM|R} > F_{1-\alpha,I-1,(I-1)(K-1)}
(\#eq:NhRejectRuleFRRC)
\end{equation}

The p-value of the test is the probability that a random sample from the F-distribution TBA \@ref(eq:pseudoValPrime) Eqn. (9.39), exceeds the observed value:

\begin{equation}
p=\Pr\left ( F> F_{DBM|R} \mid F \sim F_{I-1,(I-1)(K-1)} \right )
(\#eq:pFRRC)
\end{equation}

The $(1-\alpha)$  confidence interval for the inter-treatment reader-averaged difference FOM is given by:

\begin{equation}
CI_{1-\alpha}=\left ( \theta_{i \bullet} - \theta_{i' \bullet} \right ) \pm t_{\alpha/2,(I-1)(K-1)}\sqrt{2\frac{MST}{JK}}
(\#eq:confIntervalFRRC)
\end{equation}

### Single-reader multiple-treatment analysis {#FRRCSingleReaderDBMAnalysis}
With a single reader interpreting cases in two or more treatments, the reader factor must necessarily be regarded as fixed. The preceding analysis is applicable. One simply puts $J = 1$ in the equations above. 

#### Example 5: Code illustrating p-values for FRRC analysis, Van Dyke data

```r
alpha <- 0.05
retMS <- UtilMeanSquares(dataset02)
I <- length(dataset02$ratings$NL[,1,1,1])
J <- length(dataset02$ratings$NL[1,,1,1])
K <- length(dataset02$ratings$NL[1,1,,1])
FDbmFR <- retMS$msT / retMS$msTC
ndf <- (I-1); ddf <- (I-1)*(K-1)
pValue <- 1 - pf(FDbmFR, ndf, ddf)

theta <- as.matrix(UtilFigureOfMerit(dataset02, FOM = "Wilcoxon"))
theta_i_dot <- array(dim = I)
for (i in 1:I) theta_i_dot[i] <- mean(theta[i,])

trtDiff <- array(dim = c(I,I))
for (i1 in 1:(I-1)) {    
  for (i2 in (i1+1):I) {
    trtDiff[i1,i2] <- theta_i_dot[i1]- theta_i_dot[i2]    
  }
}
trtDiff <- trtDiff[!is.na(trtDiff)]
nDiffs <- I*(I-1)/2

std_DIFF_FOM_FRRC <- sqrt(2*retMS$msTC/J/K)
nDiffs <- I*(I-1)/2
CI_DIFF_FOM_FRRC <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_FRRC[i,1] <- qt(alpha/2,df = ddf)*std_DIFF_FOM_FRRC + trtDiff[i]
  CI_DIFF_FOM_FRRC[i,2] <- trtDiff[i]
  CI_DIFF_FOM_FRRC[i,3] <- qt(1-alpha/2,df = ddf)*std_DIFF_FOM_FRRC + trtDiff[i]
  print(data.frame("pValue" = pValue, 
                   "Lower" = CI_DIFF_FOM_FRRC[i,1], 
                   "Mid" = CI_DIFF_FOM_FRRC[i,2], 
                   "Upper" = CI_DIFF_FOM_FRRC[i,3]))
}
#>       pValue       Lower         Mid        Upper
#> 1 0.02103497 -0.08088303 -0.04380032 -0.006717613

retRJafroc <- StSignificanceTesting(dataset02, FOM = "Wilcoxon", method = "DBM")

data.frame("pValue" = retRJafroc$FRRC$FTests$p[1],
           "Lower" = retRJafroc$FRRC$ciDiffTrt[1,"CILower"], 
           "Mid" = retRJafroc$FRRC$ciDiffTrt[1,"Estimate"], 
           "Upper" = retRJafroc$FRRC$ciDiffTrt[1,"CIUpper"])
#>        pValue        Lower          Mid         Upper
#> 1 0.021034969 -0.080883031 -0.043800322 -0.0067176131
```

As one might expect, if one "freezes" reader variability, the FOM difference becomes significant, whether viewed from the point of view of the F-statistic exceeding the critical value, the observed p-value being smaller than alpha or the 95% CI for the difference FOM not including zero. 

## Random-reader fixed-case (RRFC) analysis {#DBMSpecialCases-RRFCAnalysis}
The model is the same as in TBA \@ref(eq:pseudoValPrime) Eqn. (9.4) except one puts $\sigma_C^2 = \sigma_{\tau C}^2 =0$ in Table Table \@ref(tab:ExpValMs). It follows that: 

\begin{equation}
\frac{E(MST)}{E(MSTR)}=\frac{\sigma_\epsilon^2+\sigma_{\tau RC}^2+K\sigma_{\tau R}^2+JK\sigma_{\tau}^2}{\sigma_\epsilon^2+\sigma_{\tau RC}^2+K\sigma_{\tau R}^2}
\end{equation}

Under the null hypothesis $\sigma_\tau^2 = 0$:

\begin{equation}
\frac{E(MST)}{E(MSTR)}=1
\end{equation}

Therefore, one defines the F-statistic (replacing expected values with observed values) by:

\begin{equation}
F_{DBM|C} \sim \frac{MST}{MSTR}
(\#eq:FStatRRFC-Misc)
\end{equation}

The observed value $F_{DBM|C}$ is distributed as an F-statistic with $ndf = I – 1$ and $ddf = (I-1)(J-1)$, see rows labeled $T$ and $TR$ in Table Table \@ref(tab:ExpValMs).

\begin{equation}
F_{DBM|C} \sim F_{I-1,(I-1)(J-1))}
(\#eq:SamplingFStatRRFC)
\end{equation}

The null hypothesis is rejected if the observed value of the F statistic exceeds the critical value:

\begin{equation}
F_{DBM|C} > F_{1-\alpha,I-1,(I-1)(J-1))}
(\#eq:NhRejectRuleRRFC)
\end{equation}

The p-value of the test is the probability that a random sample from the distribution exceeds the observed value:

\begin{equation}
p=\Pr\left ( F>F_{DBM|C} \mid F \sim F_{I-1,(I-1)(J-1)} \right )
(\#eq:pRRFC)
\end{equation}

The confidence interval for inter-treatment differences is given by (TBA check this):

\begin{equation}
CI_{1-\alpha}=\left ( \theta_{i \bullet} - \theta_{i' \bullet} \right ) \pm t_{\alpha/2,(I-1)(J-1)}\sqrt{2\frac{MSTR}{JK}}
(\#eq:confIntervalRRFC)
\end{equation}

#### Example 6: Code illustrating analysis for RRFC analysis, Van Dyke data


```r
FDbmFC <- retMS$msT / retMS$msTR
ndf <- (I-1)
ddf <- (I-1)*(J-1)
pValue <- 1 - pf(FDbmFC, ndf, ddf)

nDiffs <- I*(I-1)/2
CI_DIFF_FOM_RRFC <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_RRFC[i,1] <- qt(alpha/2,df = ddf)*sqrt(2*retMS$msTR/J/K) + trtDiff[i]
  CI_DIFF_FOM_RRFC[i,2] <- trtDiff[i]
  CI_DIFF_FOM_RRFC[i,3] <- qt(1-alpha/2,df = ddf)*sqrt(2*retMS$msTR/J/K) + trtDiff[i]
  print(data.frame("pValue" = pValue, 
                   "Lower" = CI_DIFF_FOM_RRFC[i,1], 
                   "Mid" = CI_DIFF_FOM_RRFC[i,2], 
                   "Upper" = CI_DIFF_FOM_RRFC[i,3]))
}
#>        pValue        Lower          Mid         Upper
#> 1 0.041958752 -0.085020224 -0.043800322 -0.0025804202
data.frame("pValue" = retRJafroc$RRFC$FTests$p[1],
           "Lower" = retRJafroc$RRFC$ciDiffTrt[1,"CILower"], 
           "Mid" = retRJafroc$RRFC$ciDiffTrt[1,"Estimate"], 
           "Upper" = retRJafroc$RRFC$ciDiffTrt[1,"CIUpper"])
#>        pValue        Lower          Mid         Upper
#> 1 0.041958752 -0.085020224 -0.043800322 -0.0025804202
```


## References {#DBMSpecialCases-references}


<!--chapter:end:09C-DBM-Analysis-Misc.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Introduction to the Obuchowski-Rockette method {#ORMethodIntro}



## Introduction {#ORMethodIntro-introduction}
* This chapter starts with a gentle introduction to the Obuchowski and Rockette method. The reason is that the method was rather opaque to me, and I suspect most non-statistician users. Part of the problem, in my opinion, is the notation, namely lack of the *case-set* index $\{c\}$. While this may seem like a trivial point to statisticians, it did present a conceptual problem for me. 

* A key difference of the Obuchowski and Rockette method from DBM is in how the error term is modeled by a non-diagonal covariance matrix. Therefore, the structure of the covariance matrix is examined in some detail.  

* To illustrate the covariance matrix, a single reader interpreting a case-set in multiple treatments is analyzed and the results compared to that using DBM fixed-reader analysis described in previous chapters. 

## Single-reader multiple-treatment {#OR1RMTModel}
Consider a single-reader providing ROC interpretations of a common case-set $\{c\}$ in multiple-treatments $i$ ($i$ = 1, 2, …, $I$). Before proceeding, we note that this is not formally equivalent to multiple-readers providing ROC interpretations in a single treatment. This is because reader is a random factor while treatment is a fixed factor. 

*In the OR method one models the figure-of-merit, not the pseudovalues; indeed this is a key differences from the DBM method.* The figure of merit $\theta$ is modeled as:

\begin{equation}
\theta_{i\{c\}}=\mu+\tau_i+\epsilon_{i\{c\}}
(\#eq:ORModel1RMT)
\end{equation}

Eqn. \@ref(eq:ORModel1RMT) models the observed figure-of-merit $\theta_{i\{c\}}$ as a constant term $\mu$, a treatment dependent term $\tau_i$ (the treatment-effect), and a random term $\epsilon_{i\{c\}}$. The term $\tau_i$ has the constraint: 

\begin{equation}
\sum_{i=1}^{I}\tau_i=0
(\#eq:ConstraintTau)
\end{equation}

The left hand side of Eqn. \@ref(eq:ORModel1RMT) is the figure-of-merit $\theta_i\{c\}$ for treatment $i$ and case-set index $\{c\}$, where $c$ = 1, 2, ..., $C$ denotes different independent case-sets sampled from the population, i.e., different *collections* of $K_1$ non-diseased and $K_2$ diseased cases.

*The case-set index is essential for clarity. Without it $\theta_i$ is a fixed quantity - the figure of merit estimate for treatment $i$ - lacking an index allowing for sampling related variability.* Obuchowski and Rockette define a *k-index*, the: 

> $k^{th}$ repetition of the study involving the same diagnostic test, reader and patient (sic)”. 

Needed is a *case-set* index rather than a *repetition* index. Repeating a study with the same treatment, reader and cases yields *within-reader* variability, when what is needed, for significance testing, is *case-sampling plus within-reader* variability. 

*It is shown below that usage of the case-set index interpretation yields the same results using the DBM or the OR methods (for empirical AUC).*

Eqn. \@ref(eq:ORModel1RMT) has an additive random error term $\epsilon_{i\{c\}}$ whose sampling behavior is described by a multivariate normal distribution with an I-dimensional zero mean vector and an $I \times I$ dimensional covariance matrix $\Sigma$:

\begin{equation}
\epsilon_{i\{c\}} \sim N_I\left ( \vec{0} ,  \Sigma\right )
(\#eq:DefinitionEpsilon)
\end{equation}

Here $N_I$ is the I-variate normal distribution (i.e., each sample yields $I$ random numbers). For the single-reader model Eqn. \@ref(eq:ORModel1RMT), the covariance matrix has the following structure :

\begin{equation}
\Sigma_{ii'}=Cov\left ( \epsilon_{i\{c\}}, \epsilon_{i'\{c\}} \right )=\left\{\begin{matrix}
\text{Var} \qquad (i=i')\\ 
Cov_1 \qquad (i\neq i')
\end{matrix}\right.
(\#eq:DefinitionSigma)
\end{equation}

The reason for the subscript "1" in $Cov_1$  will become clear when one extends this model to multiple readers. The $I \times I$ covariance matrix $\Sigma$  is: 

\begin{equation}
\Sigma=
\begin{pmatrix}
\text{Var} & Cov_1   & \ldots & Cov_1 & Cov_1 \\
Cov_1 & \text{Var}   & \ldots &Cov_1 & Cov_1 \\
\vdots & \vdots & \vdots & \vdots & \vdots \\
Cov_1 & Cov_1 & \ldots & \text{Var} & Cov_1 \\
Cov_1 & Cov_1 & \ldots & Cov_1 & \text{Var}
\end{pmatrix}
(\#eq:ExampleSigma)
\end{equation}

If $I$ = 2 then $\Sigma$  is a symmetric 2 x 2 matrix, whose diagonal terms are the common variances in the two treatments (each assumed equal to $\text{Var}$) and whose off-diagonal terms (each assumed equal to  $Cov_1$) are the co-variances. With $I$ = 3 one has a 3 x 3 symmetric matrix with all diagonal elements equal to $\text{Var}$ and all off-diagonal terms are equal to $Cov_1$, etc. 

*An important aspect of the Obuchowski and Rockette model is that the variances and co-variances are assumed to be treatment independent. This implies that $\text{Var}$ estimates need to be averaged over all treatments. Likewise,  $Cov_1$ estimates need to be averaged over all distinct treatment-treatment pairings.*

A more complex model, with more parameters and therefore more difficult to work with, would allow the variances to be treatment dependent, and the covariances to depend on the specific treatment pairings. For obvious reasons ("Occam's Razor" or the law of parsimony ) one wishes to start with the simplest model that, one hopes, captures essential characteristics of the data.

Some elementary statistical results are presented next.

### Definitions of covariance and correlation
The covariance of two scalar random variables X and Y is defined by:

\begin{equation}
Cov(X,Y) =\frac{\sum_{i=1}^{N}(x_{i}-x_{\bullet})(y_{i}-y_{\bullet})}{N-1}=E(XY)-E(X)-E(Y)
(\#eq:DefCov)
\end{equation}

Here $E(X)$ is the expectation value of the random variable $X$, i.e., the integral of x multiplied by its $\text{pdf}$ over the range of $x$: 

$$E(X)=\int \text{pdf(x)} x dx$$

The covariance can be thought of as the *common* part of the variance of two random variables. The variance, a special case of covariance, of $X$ is defined by:

$$\text{Var}(X,X) = Cov(X,X)=E(X^2)-(E(X))^2=\sigma_x^2$$

It can be shown, this is the Cauchy–Schwarz inequality, that:

$$\mid Cov(X,Y) \mid^2 \le \text{Var}(X)\text{Var}(Y)$$

A related quantity, namely the correlation $\rho$ is defined by (the $\sigma$s  are standard deviations):

$$\rho_{XY} \equiv Cor(X,Y)=\frac{Cov(X,Y)}{\sigma_X \sigma_Y}$$

It has the property:

$$\mid \rho_{XY} \mid \le 1$$

### Special case when variables have equal variances 

Assuming $X$ and $Y$ have the same variance:

$$\text{Var}(X)=\text{Var}(Y)\equiv \text{Var}\equiv \sigma^2$$

A useful theorem applicable to the OR single-reader multiple-treatment model is:

\begin{equation}
\text{Var}(X-Y)=\text{Var}(X)+\text{Var}(Y)-2Cov(X,Y)=2(\text{Var}-Cov)
(\#eq:UsefulTheorem)
\end{equation}

The right hand side specializes to the OR single-reader multiple-treatment model where the variances (for different treatments) are equal and likewise the covariances in Eqn. \@ref(eq:ExampleSigma) are equal) The correlation  $\rho_1$ is defined by (the reason for the subscript 1 on $\rho$ is the same as the reason for the subscript 1 on $\text{Cov1}$, which will be explained later): 

$$\rho_1=\frac{\text{Cov1}}{\text{Var}}$$

The I x I covariance matrix $\Sigma$  can be written alternatively as (shown below is the matrix for I = 5; as the matrix is symmetric, only elements at and above the diagonal are shown): 

\begin{equation}
\Sigma = 
\begin{bmatrix}
\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
& \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
&  & \sigma^2 & \rho_1\sigma^2 & \rho_1\sigma^2\\
&  &  & \sigma^2 & \rho_1\sigma^2\\
&  &  &  & \sigma^2
\end{bmatrix}
(\#eq:CovMtrxSigmaRhoForm)
\end{equation}

### Estimating the variance-covariance matrix
An unbiased estimate of the covariance matrix Eqn. \@ref(eq:DefinitionSigma) follows from:

\begin{equation}
\Sigma_{ii'}\mid_{ps}=\frac{1}{C-1}\sum_{c=1}^{C} \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)
(\#eq:EstimateSigmaPopulation)
\end{equation}

The subscript $ps$ denotes population sampling. As a special case, when $i = i'$, this equation yields the population sampling based variance.

\begin{equation}
\text{Var}_{i}\mid_{ps}=\frac{1}{C-1}\sum_{c=1}^{C} \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right)^2
(\#eq:EstimateVarPopulation)
\end{equation}

The I-values when averaged yield the population sampling based estimate of $\text{Var}$.

Sampling different case-sets, as required by Eqn. \@ref(eq:EstimateSigmaPopulation), is unrealistic. In reality one has $C$ = 1, i.e., a single dataset. Therefore, direct application of this formula is impossible. However, as seen when this situation was encountered before in (book) Chapter 07, one uses resampling methods to realize, for example, different bootstrap samples, which are resampling-based “stand-ins” for actual case-sets. If $B$ is the total number of bootstraps, then the estimation formula is:

\begin{equation}
\Sigma_{ii'}\mid_{bs} =\frac{1}{B-1}\sum_{b=1}^{B} \left ( \theta_{i\{b\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{b\}} - \theta_{i'\{\bullet\}} \right)
(\#eq:EstimateSigmaBootstrap)
\end{equation}

Eqn. \@ref(eq:EstimateSigmaBootstrap), the bootstrap method of estimating the covariance matrix, is a direct translation of Eqn. \@ref(eq:EstimateSigmaPopulation). Alternatively, one could have used the jackknife FOM values $\theta_{i(k)}$, i.e., the figure of merit with a case $k$ removed, repeated for all $k$, to estimate the covariance matrix:

\begin{equation}
\Sigma_{ii'}\mid_{jk} =\frac{(K-1)^2}{K} \left [ \frac{1}{K-1}\sum_{k=1}^{K} \left ( \theta_{i(k)} - \theta_{i(\bullet)} \right) \left ( \theta_{i'(k)} - \theta_{i'(\bullet)} \right) \right ]
(\#eq:EstimateSigmaJackknife)
\end{equation}

[For either bootstrap or jackknife, if $i = i'$, the equations yield the corresponding variance estimates.]

Note the subtle difference in usage of ellipses and parentheses between Eqn. \@ref(eq:EstimateSigmaPopulation) and  Eqn. \@ref(eq:EstimateSigmaJackknife). In the former, the subscript $\{c\}$ denotes a set of $K$ cases while in the latter, $(k)$ denotes the original case set with case $k$ removed, leaving $K-1$ cases. There is a similar subtle difference in usage of ellipses and parentheses between Eqn. \@ref(eq:EstimateSigmaBootstrap) and  Eqn. \@ref(eq:EstimateSigmaJackknife). The subscript enclosed in parenthesis, i.e., $(k)$, denotes the FOM with case $k$ removed, while in the bootstrap equation one uses the ellipses (curly brackets) $\{b\}$ to denote the $b^{th}$ bootstrap *case-set*, i.e., a whole set of $K_1$ non-diseased and $K_2$ diseased cases, sampled with replacement from the original dataset.   

The index $k$ ranges from 1 to $K$, where the first $K_1$ values represent non-diseased cases and the following $K_2$ values represent diseased cases. Jackknife figure of merit values, such as $\theta_{i(k)}$, are not to be confused with jackknife pseudovalues used in the DBM chapters. The jackknife FOM corresponding to a particular case is the FOM with the particular case removed while the pseudovalue is $K$ times the FOM with all cases include minus $(K-1)$ times the jackknife FOM. Unlike pseudovalues, jackknife FOM values cannot be regarded as independent and identically distributed, even when using the empirical AUC as FOM. 

### The variance inflation factor
In Eqn. \@ref(eq:EstimateSigmaJackknife), the expression for the jackknife covariance estimate contains a *variance inflation factor*:

\begin{equation}
\frac{(K-1)^2}{K}
(\#eq:JKVarianceInflationFactor)
\end{equation}

This factor multiplies the traditional expression for the covariance, shown in square brackets in Eqn. \@ref(eq:EstimateSigmaJackknife). It is only needed for the jackknife estimate. The bootstrap and the DeLong estimate, see next, do not require this factor.

A third method of estimating the covariance [@RN112], only applicable to the empirical AUC, is not discussed here; however, it is implemented in the software.

### Meaning of the covariance matrix in Eqn. \@ref(eq:ExampleSigma)
Suppose one has the luxury of repeatedly sampling case-sets, each consisting of $K$ cases from the population. A single radiologist interprets these cases in $I$ treatments. Therefore, each case-set $\{c\}$ yields $I$ figures of merit. The final numbers at ones disposal are $\theta_{i\{c\}}$, where $i$ = 1,2,...,$I$ and $c$ = 1,2,...,$C$. Considering treatment $i$, the variance of the FOM-values for the different case-sets $c$ = 1,2,...,$C$, is an estimate of $Var_i$ for this treatment: 

\begin{equation}
\sigma_i^2 \equiv Var_i = \frac{1}{C-1}\sum_{c=1}^{C}\left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right)
(\#eq:EstimateVari)
\end{equation}

The process is repeated for all treatments and the $I$-variance values are averaged. This is the final estimate of $\text{Var}$ appearing in Eqn. \@ref(eq:DefinitionEpsilon). 

To estimate the covariance matrix one considers pairs of FOM values for the same case-set $\{c\}$  but different treatments, i.e., $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$; *by definition primed and un-primed indices are different*. The process is repeated for different case-sets. The covariance is calculated as follows: 

\begin{equation}
\text{Cov}_{1;ii'} = \frac{1}{C-1}\sum_{c=1}^{C} \left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)
(\#eq:EstimateCov)
\end{equation}

The process is repeated for all combinations of different-treatment pairings and the resulting $I(I-1)/2$ values are averaged yielding the final estimate of $\text{Cov}_1$. [Recall that the Obuchowski-Rockette model does not allow treatment-dependent parameters in the covariance matrix - hence the need to average over all treatment pairings.]

Since they are derived from the same case-set, one expects the $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$ values to be correlated. As an example, for a particularly easy *case-set* one expects $\theta_{i\{c\}}$ and $\theta_{i'\{c\}}$ to be both higher than usual. The correlation $\rho_{1;ii'}$ is defined by:

\begin{equation}
\rho_{1;ii'} = \frac{1}{C-1}\sum_{c=1}^{C} \frac {\left ( \theta_{i\{c\}} - \theta_{i\{\bullet\}} \right) \left ( \theta_{i'\{c\}} - \theta_{i'\{\bullet\}} \right)}{\sigma_i \sigma_{i'} }
(\#eq:EstimateRho)
\end{equation}

Averaging over all different-treatment pairings yields the final estimate of the correlation $\rho_1$. Since the covariance is smaller than the variance, the magnitude of the correlation is smaller than 1. In most situations one expects $\rho_1$ to be positive. There is a scenario that could lead to negative correlation. With "complementary" treatments, e.g., CT vs. MRI, where one treatment is good for bone imaging and the other for soft-tissue imaging, an easy case-set in one treatment could correspond to a difficult case-set in the other treatment, leading to negative correlation.

To summarize, the covariance matrix can be estimated using the jackknife or the bootstrap, or, in the special case of the empirical AUC figure of merit, the DeLong method can be used. In (book) Chapter 07, these three methods were described in the context of estimating the *variance* of AUC. Eqn. \@ref(eq:EstimateSigmaBootstrap) and Eqn. \@ref(eq:EstimateSigmaJackknife) extend the jackknife and the bootstrap methods, respectively, to estimating the *covariance* of AUC (whose diagonal elements are the variances estimated in the earlier chapter). 

### Code illustrating the covariance matrix

To minimize clutter, the `R` functions (for estimating `Var` and `Cov1` using bootstrap, jackknife, and the DeLong methods) are not shown, but they are compiled. To display them `clone` or 'fork' the book repository and look at the `Rmd` file corresponding to this output and the sourced `R` files listed below:


```r
source(here("R/CH10-OR/Wilcoxon.R"))
source(here("R/CH10-OR/VarCov1Bs.R"))
source(here("R/CH10-OR/VarCov1Bs.R"))
source(here("R/CH10-OR/VarCov1Jk.R")) 
source(here("R/CH10-OR/VarCovMtrxDLStr.R"))
source(here("R/CH10-OR/VarCovs.R"))
```

The following code chunk extracts (using the `DfExtractDataset` function) a single-reader multiple-treatment ROC dataset corresponding to the first reader from `dataset02`, which is the Van Dyke dataset. 


```r
rocData1R <- DfExtractDataset(dataset02, rdrs = 1) #select the 1st reader to be analyzed
zik1 <- rocData1R$ratings$NL[,1,,1];K <- dim(zik1)[2];I <- dim(zik1)[1]
zik2 <- rocData1R$ratings$LL[,1,,1];K2 <- dim(zik2)[2];K1 <- K-K2;zik1 <- zik1[,1:K1]
```

The following notation is used in the code below:

* jk = jackknife method
* bs = bootstrap method, with B = number of bootstraps and `seed` = value.
* dl = DeLong method
* rj_jk = RJafroc, `covEstMethod` = "jackknife"
* rj_bs = RJafroc, `covEstMethod` = "bootstrap"

For example, `Cov1_jk` is the jackknife estimate of `Cov1`. Shown below are the results of the jackknife method, first using the code in this repository and next, as a cross-check, using `RJafroc` function `UtilORVarComponentsFactorial`:


```r
ret1 <- VarCov1_Jk(zik1, zik2)
Var <- ret1$Var
Cov1 <- ret1$Cov1 # use these (i.e., jackknife) as default values in subsequent code
data.frame ("Cov1_jk" = Cov1, "Var_jk" = Var)
#>        Cov1_jk       Var_jk
#> 1 0.0003734661 0.0006989006

ret4 <- UtilORVarComponentsFactorial(
  rocData1R, FOM = "Wilcoxon") # the functions default `covEstMethod` is jackknife
data.frame ("Cov1_rj_jk" = ret4$VarCom["Cov1", "Estimates"], 
            "Var_rj_jk" = ret4$VarCom["Var", "Estimates"])
#>     Cov1_rj_jk    Var_rj_jk
#> 1 0.0003734661 0.0006989006
```

Note that the estimates are identical and that the $\text{Cov1}$ estimate is smaller than the $\text{Var}$ estimate (their ratio is the correlation $\rho_1 = \text{Cov1}/\text{Var}$ = 0.5343623). 

Shown next are bootstrap method estimates with increasing number of bootstraps (200, 2000 and 20,000):

```r
ret2 <- VarCov1_Bs(zik1, zik2, 200, seed = 100)
data.frame ("Cov_bs" = ret2$Cov1, "Var_bs" = ret2$Var) 
#>        Cov_bs       Var_bs
#> 1 0.000283905 0.0005845354

ret2 <- VarCov1_Bs(zik1, zik2, 2000, seed = 100)
data.frame ("Cov_bs" = ret2$Cov1, "Var_bs" = ret2$Var) 
#>         Cov_bs       Var_bs
#> 1 0.0003466804 0.0006738506

ret2 <- VarCov1_Bs(zik1, zik2, 20000, seed = 100)
data.frame ("Cov_bs" = ret2$Cov1, "Var_bs" = ret2$Var) 
#>         Cov_bs       Var_bs
#> 1 0.0003680714 0.0006862668
```

With increasing number of bootstraps the values approach the jackknife estimates.

Following, as a cross check, are results of bootstrap method as calculated by the `RJafroc` function `UtilORVarComponentsFactorial`:


```r
ret5 <- UtilORVarComponentsFactorial(
  rocData1R, FOM = "Wilcoxon", 
  covEstMethod = "bootstrap", nBoots = 2000, seed = 100)
data.frame ("Cov_rj_bs" = ret5$VarCom["Cov1", "Estimates"], 
            "Var_rj_bs" = ret5$VarCom["Var", "Estimates"])
#>      Cov_rj_bs    Var_rj_bs
#> 1 0.0003466804 0.0006738506
```

Note that the two estimates shown above for $B = 2000$ are identical. This is because *the seeds are identical*. With different seeds on expect sampling related fluctuations.

Following are results of the DeLong covariance estimation method, the first output is using this repository code and the second using the `RJafroc` function `UtilORVarComponentsFactorial` with appropriate arguments:


```r
mtrxDLStr <- VarCovMtrxDLStr(rocData1R)
ret3 <- VarCovs(mtrxDLStr)
data.frame ("Cov_dl" = ret3$cov1, "Var_dl" = ret3$var)
#>         Cov_dl       Var_dl
#> 1 0.0003684357 0.0006900766

ret5 <- UtilORVarComponentsFactorial(
  rocData1R, FOM = "Wilcoxon", covEstMethod = "DeLong")
data.frame ("Cov_rj_dl" = ret5$VarCom["Cov1", "Estimates"], 
            "Var_rj_dl" = ret5$VarCom["Var", "Estimates"])
#>      Cov_rj_dl    Var_rj_dl
#> 1 0.0003684357 0.0006900766
```

Note that the two estimates are identical and that the DeLong estimate are close to the bootstrap estimates using 20,000 bootstraps. The just demonstrated close correspondence is only expected when using the Wilcoxon figure of merit, i.e., the empirical AUC.

### Significance testing {#SignificanceTesting1ROR}
The covariance matrix is needed for significance testing. Define the mean square corresponding to the treatment effect, denoted $MS(T)$, by:

\begin{equation}
MS(T)=\frac{1}{I-1}\sum_{i=1}^{I}(\theta_i-\theta_\bullet)^2
(\#eq:DefinitionMST)
\end{equation}

*Unlike the previous DBM related chapters, all mean square quantities in this chapter are based on FOMs, not pseudovalues.*

It can be shown that under the null hypothesis that all treatments have identical performances, the test statistic $\chi_{1R}$ defined below (the $1R$ subscript denotes single-reader analysis) is distributed approximately as a $\chi^2$ distribution with $I-1$ degrees of freedom, i.e., 

\begin{equation}
\chi_{\text{1R}} \equiv \frac{(I-1)MS(T)}{\text{Var}-\text{Cov1}} \sim \chi_{I-1}^{2}
(\#eq:F-1RMT)
\end{equation}

Eqn. \@ref(eq:F-1RMT) is from §5.4 in [@RN1865] with two covariance terms "zeroed out" because they are multiplied by $J-1 = 0$ (since we are restricting to $J=1$). 

Or equivalently, in terms of the F-distribution [@RN1772]:

\begin{equation}
F_{\text{1R}} \equiv \frac{MS(T)}{\text{Var}-\text{Cov1}} \sim F_{I-1, \infty}
(\#eq:DefF-1RMT)
\end{equation}

#### An aside on the relation between the chisquare and the F-distribution with infinite ddf
Define $D_{1-\alpha}$, the $(1-\alpha)$ quantile of distribution $D$, such that the probability of observing a random sample $d$ less than or equal to $D_{1-\alpha}$ is $(1-\alpha)$:

\begin{equation}
\Pr(d\leq D_{1-\alpha} \mid d \sim D)=1-\alpha
(\#eq:DefQuantile)
\end{equation}

With definition Eqn. \@ref(eq:DefQuantile), the $(1-\alpha)$ quantile of the $\chi_{I-1}^2$ distribution, i.e., $\chi_{1-\alpha,I-1}^2$, is related to the $(1-\alpha)$ quantile of the $F_{I-1,\infty}$ distribution, i.e., $F_{1-\alpha,I-1,\infty}$, as follows [see @RN1772, Eq. 22]:

\begin{equation}
\frac{\chi_{1-\alpha,I-1}^{2}}{I-1} = F_{1-\alpha,I-1,\infty}
(\#eq:Chisqr2F)
\end{equation}

Eqn. \@ref(eq:Chisqr2F) implies that the $(1-\alpha)$ quantile of the F-distribution with $ndf=(I-1)$ and $ddf =\infty$ equals the $(1-\alpha)$ quantile of the $\chi_{I-1}^2$ distribution *divided by $(I-1)$*. 

Here is an `R` illustration of this theorem for $I-1 = 4$ and $\alpha = 0.05$: 


```r
qf(0.05, 4, Inf)
#> [1] 0.1776808
qchisq(0.05,4)/4
#> [1] 0.1776808
```

### p-value and confidence interval {#ORMethodIntro-pvalue-ci}
The p-value is the probability that a sample from the $F_{I-1,\infty}$ distribution is greater than the observed value of the test statistic, namely: 

\begin{equation}
p\equiv \Pr(f>F_{1R} \mid f \sim F_{I-1,\infty})
(\#eq:pValue1RMT)
\end{equation}

The $(1-\alpha)$  confidence interval for the inter-treatment FOM difference is given by:

\begin{equation}
CI_{1-\alpha,1R} = (\theta_{i\bullet} - \theta_{i'\bullet}) \pm t_{\alpha/2,\infty} \sqrt{2(\text{Var}-\text{Cov1})}
(\#eq:CIalpha1R)
\end{equation}

Comparing Eqn. \@ref(eq:CIalpha1R) to Eqn. \@ref(eq:UsefulTheorem) shows that the term $\sqrt{2(\text{Var}-\text{Cov1})}$ is the standard error of the inter-treatment FOM difference, whose square root is the standard deviation. The term $t_{\alpha/2,\infty}$ is -1.96. Therefore, the confidence interval is constructed by adding and subtracting 1.96 times the standard deviation of the difference from the central value. [One has probably encountered the rule that a 95% confidence interval is plus or minus two standard deviations from the central value. The "2" comes from rounding up 1.96.] 

### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments {#ORMethodIntro-CompareDBM2OR41R}
We have shown two methods for analyzing a single reader in multiple treatments: the DBM method, involving jackknife derived pseudovalues and the Obuchowski and Rockette method that does not have to use the jackknife, since it could use the bootstrap, or the DeLong method, if one restricts to the Wilcoxon statistic for the figure of merit, to get the covariance matrix. Since one is dealing with a single reader in multiple treatments, for DBM one needs the fixed-reader random-case analysis described in TBA §9.8 of the previous chapter (it should be obvious that with one reader the conclusions apply to the specific reader only, so reader must be regarded as a fixed factor).

Shown below are results obtained using `RJafroc` function `StSignificanceTesting` with `analysisOption = "FRRC"` for `method` = "DBM" (which uses the jackknife), and for OR using 3 different ways of estimating the covariance matrix for the one-reader analysis (i.e., $\text{Cov1}$ and $\text{Var}$). 


```r
ret1 <- StSignificanceTesting(
  rocData1R,FOM = "Wilcoxon", method = "DBM", analysisOption = "FRRC")
data.frame("DBM:F" = ret1$FRRC$FTests["Treatment", "FStat"], 
           "DBM:ddf" = ret1$FRRC$FTests["Treatment", "DF"], 
           "DBM:P-val" = ret1$FRRC$FTests["Treatment", "p"])
#>       DBM.F DBM.ddf  DBM.P.val
#> 1 1.2201111       1 0.27168532

ret2 <- StSignificanceTesting(
  rocData1R,FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC")
data.frame("ORJack:Chisq" = ret2$FRRC$FTests["Treatment", "Chisq"], 
           "ORJack:ddf" = ret2$FRRC$FTests["Treatment", "DF"], 
           "ORJack:P-val" = ret2$FRRC$FTests["Treatment", "p"])
#>   ORJack.Chisq ORJack.ddf ORJack.P.val
#> 1    1.2201111          1   0.26933885

ret3 <- StSignificanceTesting(
  rocData1R,FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC", 
                              covEstMethod = "DeLong")
data.frame("ORDeLong:Chisq" = ret3$FRRC$FTests["Treatment", "Chisq"], 
           "ORDeLong:ddf" = ret3$FRRC$FTests["Treatment", "DF"], 
           "ORDeLong:P-val" = ret3$FRRC$FTests["Treatment", "p"])
#>   ORDeLong.Chisq ORDeLong.ddf ORDeLong.P.val
#> 1      1.2345017            1     0.26653335

ret4 <- StSignificanceTesting(
  rocData1R,FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC", 
                              covEstMethod = "bootstrap")
data.frame("ORBoot:Chisq" = ret4$FRRC$FTests["Treatment", "Chisq"], 
           "ORBoot:ddf" = ret4$FRRC$FTests["Treatment", "DF"], 
           "ORBoot:P-val" = ret4$FRRC$FTests["Treatment", "p"])
#>   ORBoot.Chisq ORBoot.ddf ORBoot.P.val
#> 1    1.3296283          1   0.24887136
```

The DBM and OR-jackknife methods yield identical F-statistics, but the denominator degrees of freedom are different, $(I-1)(K-1)$ = 113 for DBM and $\infty$ for OR. The F-statistics for OR-bootstrap and OR-DeLong are different.

Shown below is a first-principles implementation of OR significance testing for the one-reader case.

```r
alpha <- 0.05
theta_i <- c(0,0);for (i in 1:I) theta_i[i] <- Wilcoxon(zik1[i,], zik2[i,])

MS_T <- 0
for (i in 1:I) {
  MS_T <- MS_T + (theta_i[i]-mean(theta_i))^2
}
MS_T <- MS_T/(I-1)

F_1R <- MS_T/(Var - Cov1)
pValue <- 1 - pf(F_1R, I-1, Inf)

trtDiff <- array(dim = c(I,I))
for (i1 in 1:(I-1)) {    
  for (i2 in (i1+1):I) {
    trtDiff[i1,i2] <- theta_i[i1]- theta_i[i2]    
  }
}
trtDiff <- trtDiff[!is.na(trtDiff)]
nDiffs <- I*(I-1)/2
CI_DIFF_FOM_1RMT <- array(dim = c(nDiffs, 3))
for (i in 1 : nDiffs) {
  CI_DIFF_FOM_1RMT[i,1] <- trtDiff[i] + qt(alpha/2,  df = Inf)*sqrt(2*(Var - Cov1))
  CI_DIFF_FOM_1RMT[i,2] <- trtDiff[i]
  CI_DIFF_FOM_1RMT[i,3] <- trtDiff[i] + qt(1-alpha/2,df = Inf)*sqrt(2*(Var - Cov1))
  print(data.frame("theta_1" = theta_i[1],
                   "theta_2" = theta_i[2],
                   "Var" = Var,
                   "Cov1" = Cov1,
                   "MS_T" = MS_T,
                   "F_1R" = F_1R, 
                   "pValue" = pValue,
                   "Lower" = CI_DIFF_FOM_1RMT[i,1], 
                   "Mid" = CI_DIFF_FOM_1RMT[i,2], 
                   "Upper" = CI_DIFF_FOM_1RMT[i,3]))
}
#>      theta_1    theta_2           Var         Cov1          MS_T      F_1R
#> 1 0.91964573 0.94782609 0.00069890056 0.0003734661 0.00039706618 1.2201111
#>       pValue        Lower          Mid       Upper
#> 1 0.26933885 -0.078183215 -0.028180354 0.021822507
```

The following shows the corresponding output of `RJafroc`.


```r
ret_rj <- StSignificanceTesting(
  rocData1R, FOM = "Wilcoxon", method = "OR", analysisOption = "FRRC")
print(data.frame("theta_1" = ret_rj$FOMs$foms[1,1],
                 "theta_2" = ret_rj$FOMs$foms[2,1],
                 "Var" = ret_rj$ANOVA$VarCom["Var", "Estimates"],
                 "Cov1" = ret_rj$ANOVA$VarCom["Cov1", "Estimates"],
                 "MS_T" = ret_rj$ANOVA$TRanova[1,3],
                 "Chisq_1R" = ret_rj$FRRC$FTests["Treatment","Chisq"], 
                 "pValue" = ret_rj$FRRC$FTests["Treatment","p"],
                 "Lower" = ret_rj$FRRC$ciDiffTrt[1,"CILower"], 
                 "Mid" = ret_rj$FRRC$ciDiffTrt[1,"Estimate"], 
                 "Upper" = ret_rj$FRRC$ciDiffTrt[1,"CIUpper"]))
#>      theta_1    theta_2           Var         Cov1          MS_T  Chisq_1R
#> 1 0.91964573 0.94782609 0.00069890056 0.0003734661 0.00039706618 1.2201111
#>       pValue        Lower          Mid       Upper
#> 1 0.26933885 -0.078183215 -0.028180354 0.021822507
```

The first-principles and the `RJafroc` values agree exactly with each other [for $I = 2$, the F and chisquare statistics are identical]. This above code also shows how to extract the different estimates ($Var$, $\text{Cov1}$, etc.) from the object `ret_rj` returned by `RJafroc`. Specifically,

* Var: ret_rj\$ANOVA\$VarCom["Var", "Estimates"]
* Cov1: ret_rj\$ANOVA\$VarCom["Cov1", "Estimates"]
* Chisquare-statistic: ret_rj\$FRRC\$FTests["Treatment","Chisq"]
* df: ret_rj\$FRRC\$FTests[1,"DF"]
* p-value: ret_rj\$FRRC\$FTests["Treatment","p"]
* CI Lower: ret_rj\$FRRC\$ciDiffTrt[1,"CILower"]
* Mid Value: ret_rj\$FRRC\$ciDiffTrt[1,"Estimate"]
* CI Upper: ret_rj\$FRRC\$ciDiffTrt[1,"CIUpper"]

#### Jumping ahead 
If RRRC analysis were conducted, the values are [one needs to analyze a dataset like `dataset02` having more than one treatments and readers and use `analysisOption` = "RRRC"]:

* msR: ret_rj\$ANOVA\$TRanova["R", "MS"]
* msT: ret_rj\$ANOVA\$TRanova["T", "MS"]
* msTR: ret_rj\$ANOVA\$TRanova["TR", "MS"]
* Var: ret_rj\$ANOVA\$VarCom["Var", "Estimates"]
* Cov1: ret_rj\$ANOVA\$VarCom["Cov1", "Estimates"]
* Cov2: ret_rj\$ANOVA\$VarCom["Cov2", "Estimates"]
* Cov3: ret_rj\$ANOVA\$VarCom["Cov3", "Estimates"]
* varR: ret_rj\$ANOVA\$VarCom["VarR", "Estimates"]
* varTR: ret_rj\$ANOVA\$VarCom["VarTR", "Estimates"]
* F-statistic: ret_rj\$RRRC\$FTests["Treatment", "FStat"]
* ddf: ret_rj\$RRRC\$FTests["Error", "DF"]
* p-value: ret_rj\$RRRC\$FTests["Treatment", "p"]
* CI Lower: ret_rj\$RRRC\$ciDiffTrt["trt0-trt1","CILower"]
* Mid Value: ret_rj\$RRRC\$ciDiffTrt["trt0-trt1","Estimate"]
* CI Upper: ret_rj\$RRRC\$ciDiffTrt["trt0-trt1","CIUpper"]

For `RRFC` analysis, one replaces `RRRC` with `RRFC`, etc. I should note that the auto-prompt feature of `RStudio` makes it unnecessary to enter the complex string names shown above  - `RStudio` will suggest them.

## Multiple-reader multiple-treatment {#SignificanceTestingORMRMC}
The previous sections served as a gentle introduction to the single-reader multiple-treatment Obuchowski and Rockette method. This section extends it to multiple-readers interpreting a common case-set in multiple-treatments (MRMC). The extension is, in principle, fairly straightforward. Compared to Eqn. \@ref(eq:ORModel1RMT), one needs an additional $j$ index to denote reader dependence of the figure of merit, and additional terms to model reader and treatment-reader variability, and the error term needs to be modified to account for the additional random (i.e., reader) factor. 

The general Obuchowski and Rockette model for fully paired multiple-reader multiple-treatment interpretations is: 

\begin{equation}
\theta_{ij\{c\}}=\mu+\tau_i+R_j+(\tau R)_{ij}+\epsilon_{ij\{c\}}
(\#eq:ORModel)
\end{equation}

* The fixed treatment effect $\tau_i$ is subject to the usual constraint, Eqn. \@ref(eq:ConstraintTau). 
* The first two terms on the right hand side of Eqn. \@ref(eq:ORModel) have their usual meanings: a constant term $\mu$ representing performance averaged over treatments and readers, and a treatment effect $\tau_i$ ($i$ = 1,2, ..., $I$). 
* The next two terms are, by assumption, mutually independent random samples specified as follows: 
    + $R_j$ denotes the random treatment-independent figure-of-merit contribution of reader $j$ ($j$ = 1,2, ..., $J$), modeled by a zero-mean normal distribution with variance $\sigma_R^2$; 
    + $(\tau R)_{ij}$ denotes the treatment-dependent random contribution of reader $j$ in treatment $i$, modeled as a sample from a zero-mean normal distribution with variance $\sigma_{\tau R}^2$. There could be a perceived notational clash with similar variance component terms defined for the DBM model – except in that case they applied to pseudovalues. The meaning should be clear from the context. 
    
* Summarizing:

\begin{equation}
\left\{\begin{matrix}
R_j \sim N(0,\sigma_R^2)\\ 
{\tau R} \sim N(0,\sigma_{\tau R}^2)
\end{matrix}\right.
(\#eq:ORVariances)
\end{equation}

For a single dataset $c$ = 1. An estimate of $\mu$ follows from averaging over the $i$ and $j$ indices (the averages over the random terms are zeroes):

\begin{equation}
\mu = \theta_{\bullet \bullet \{1\}}
(\#eq:ORmuEstimate)
\end{equation}

Averaging over the j index and performing a subtraction yields an estimate of $\tau_i$:

\begin{equation}
\tau_i = \theta_{i \bullet \{1\}} - \theta_{\bullet \bullet \{1\}}
(\#eq:ORtauEstimate)
\end{equation}

The $\tau_i$ estimates obey the constraint Eqn. \@ref(eq:ConstraintTau). For example, with two treatments, the values of $\tau_i$ must be the negatives of each other: $\tau_1=-\tau_2$. 

The error term on the right hand side of Eqn. \@ref(eq:ORModel) is more complex than the corresponding DBM model error term. Obuchowski and Rockette model this term with a multivariate normal distribution with a length $(IJ)$ zero-mean vector and a $(IJ \times IJ)$ dimensional covariance matrix $\Sigma$. In other words, 

\begin{equation}
\epsilon_{ij\{c\}} \sim N_{IJ}(\vec{0},\Sigma)
(\#eq:OREpsSampling)
\end{equation}

Here $N_{IJ}$ is the $IJ$-variate normal distribution, $\vec{0}$ is the zero-vector with length $IJ$, denoting the vector-mean of the distribution. The counterpart of the variance, namely the covariance matrix $\Sigma$ of the distribution, is defined by 4 parameters, $\text{Var}, \text{Cov1}, \text{Cov2}, \text{Cov3}$, defined as follows:

\begin{equation}
Cov(\epsilon_{ij\{c\}},\epsilon_{i'j'\{c\}}) =
\left\{\begin{matrix}
\text{Var} \; (i=i',j=j') \\
\text{Cov1} \; (i\ne i',j=j')\\ 
\text{Cov2} \; (i = i',j \ne j')\\ 
\text{Cov3} \; (i\ne i',j \ne j')
\end{matrix}\right\}
(\#eq:ORVarCov)
\end{equation}

Apart from fixed effects, the model implied by Eqn. \@ref(eq:ORModel) and Eqn. \@ref(eq:ORVarCov) contains 6 parameters: 

$$\sigma_R^2,\sigma_{\tau R}^2,\text{Var}, \text{Cov1}, \text{Cov2}, \text{Cov3}$$

This is the same number of variance component parameters as in the DBM model, which should not be a surprise since one is modeling the data with equivalent models. The Obuchowski and Rockette model Eqn. \@ref(eq:ORModel) "looks" simpler because four covariance terms are encapsulated in the $\epsilon$ term. As with the singe-reader multiple-treatment model, the covariance matrix is assumed to be independent of treatment or reader. 

*It is implicit in the Obuchowski-Rockette model that the $Var$, $\text{Cov1}$, $Cov_2$, and $Cov_3$ estimates are averaged over all applicable treatment-reader combinations.*

### Structure of the covariance matrix {#StrCovMatrix}
To understand the structure of this matrix, recall that the diagonal elements of a square covariance matrix are the variances and the off-diagonal elements are covariances. With two indices $ij$ one can still imagine a square matrix where each dimension is labeled by a pair of indices $ij$. One $ij$ pair corresponds to the horizontal direction, and the other $ij$ pair corresponds to the vertical direction. To visualize this let consider the simpler situation of two treatments ($I = 2$) and three readers ($J = 3$). The resulting $6 \times 6$ covariance matrix would look like this: 

$$
\Sigma=
\begin{bmatrix}
(11,11) & (12,11) & (13,11) & (21,11) & (22,11) & (23,11) \\
& (12,12) & (13,12) & (21,12) & (22,12) & (23,12) \\ 
& & (13,13) & (21,13) & (22,13) & (23,13) \\ 
& & & (21,21) & (22,21) & (23,21) \\
& & & & (22,22) & (23,22) \\ 
& & & & & (23,23)
\end{bmatrix}
$$

Shown in each cell of the matrix is a pair of ij-values, serving as column indices, followed by a pair of ij-values serving as row indices, and a comma separates the pairs. For example, the first column is labeled by (11,xx), where xx depends on the row. The second column is labeled (12,xx), the third column is labeled (13,xx), and the remaining columns are successively labeled (21,xx), (22,xx) and (23,xx). Likewise, the first row is labeled by (yy,11), where yy depends on the column. The following rows are labeled (yy,12), (yy,13), (yy,21), (yy,22)and (yy,23). Note that the reader index increments faster than the treatment index.

The diagonal elements are evidently those cells where the row and column index-pairs are equal. These are (11,11), (12,12), (13,13), (21,21), (22,22) and (23,23). According to Eqn. \@ref(eq:ORVarCov) these cells represent $Var$. 

$$
\Sigma=
\begin{bmatrix}
Var & (12,11) & (13,11) & (21,11) & (22,11) & (23,11) \\
& Var & (13,12) & (21,12) & (22,12) & (23,12) \\ 
& & Var & (21,13) & (22,13) & (23,13) \\ 
& & & Var & (22,21) & (23,21) \\
& & & & Var & (23,22) \\ 
& & & & & Var
\end{bmatrix}
$$

According to Eqn. \@ref(eq:ORVarCov) cells with different treatment indices but identical reader indices represent $\text{Cov1}$. As an example, cell (21,11) has the same reader indices, namely reader 1, but different treatment indices, namely 2 and 1, so it is $\text{Cov1}$:

$$
\Sigma=
\begin{bmatrix}
\text{Var} & (12,11) & (13,11) & \text{Cov1} & (22,11) & (23,11) \\
& \text{Var} & (13,12) & (21,12) & \text{Cov1} & (23,12) \\ 
& & \text{Var} & (21,13) & (22,13) & \text{Cov1} \\ 
& & & \text{Var} & (22,21) & (23,21) \\
& & & & \text{Var} & (23,22) \\ 
& & & & & \text{Var}
\end{bmatrix}
$$

Similarly, cells with identical treatment indices but different reader indices represent $Cov_2$:

$$
\Sigma=
\begin{bmatrix}
Var & Cov_2 & Cov_2 & \text{Cov1} & (22,11) & (23,11) \\
& \text{Var} & Cov_2 & (21,12) & \text{Cov1} & (23,12) \\ 
&  & \text{Var} & (21,13) & (22,13) & \text{Cov1} \\ 
&  &  & \text{Var} & Cov_2 & Cov_2 \\
&  &  &  & \text{Var} & Cov_2 \\ 
&  &  &  &  & \text{Var}
\end{bmatrix}
$$

Finally, cells with different treatment indices and different reader indices represent $Cov_3$:

$$
\Sigma=
\begin{bmatrix}
\text{Var} & Cov_2 & Cov_2 & \text{Cov1} & Cov_3 & Cov_3 \\
& \text{Var} & Cov_2 & Cov_3 & \text{Cov1} & Cov_3 \\ 
&  & \text{Var} & Cov_3 & Cov_3 & \text{Cov1} \\ 
&  &  & \text{Var} & Cov_2 & Cov_2 \\
&  &  &  & \text{Var} & Cov_2 \\ 
&  &  &  &  & \text{Var}
\end{bmatrix}
$$

To understand these terms consider how they might be estimated. Suppose one had the luxury of repeating the study with different case-sets, c = 1, 2, ..., C. Then the variance $\text{Var}$ is estimated as follows:

\begin{equation}
\text{Var}=
\left \langle \frac{1}{C-1}\sum_{c=1}^{C} (\theta_{ij\{c\}}-\theta_{ij\{\bullet\}})^2 \right \rangle_{ij}
\epsilon_{ij\{c\}} \sim N_{IJ}(\vec{0},\Sigma)
(\#eq:EstVariance)
\end{equation}

Of course, in practice one would use the bootstrap or the jackknife as a stand-in for the c-index (with the understanding that if the jackknife is used, then a variance inflation factor has to be included on the right hand side of Eqn. \@ref(eq:EstVariance). Notice that the left-hand-side of Eqn. \@ref(eq:EstVariance) lacks treatment or reader indices. This is because implicit in the notation is averaging the observed variances over all treatments and readers, as implied by $\left \langle \right \rangle _{ij}$. Likewise, the covariance terms are estimated as follows:

\begin{equation}
Cov=\left\{\begin{matrix}
\text{Cov1}=\left \langle \frac{1}{C-1}\sum_{c=1}^{C} (\theta_{ij\{c\}}-\theta_{ij\{\bullet\}}) (\theta_{i'j\{c\}}-\theta_{i'j\{\bullet\}}) \right \rangle_{ii',jj}\\ 
Cov_2=\left \langle \frac{1}{C-1}\sum_{c=1}^{C} (\theta_{ij\{c\}}-\theta_{ij\{\bullet\}}) (\theta_{ij'\{c\}}-\theta_{ij'\{\bullet\}}) \right \rangle_{ii,jj'}\\ 
Cov_3=\left \langle \frac{1}{C-1}\sum_{c=1}^{C} (\theta_{ij\{c\}}-\theta_{ij\{\bullet\}}) (\theta_{i'j'\{c\}}-\theta_{i'j'\{\bullet\}}) \right \rangle_{ii',jj'}
\end{matrix}\right.
(\#eq:EstCovMatrix)
\end{equation}

*In Eqn. \@ref(eq:EstCovMatrix) the convention is that primed and unprimed variables are always different.*

Since there are no treatment and reader dependencies on the left-hand-sides of the above equations, one averages the estimates as follows: 

* For $\text{Cov1}$ one averages over all combinations of *different treatments and same readers*, as denoted by $\left \langle \right \rangle_{ii',jj}$. 
* For $Cov_2$ one averages over all combinations of *same treatment and different readers*, as denoted by $\left \langle \right \rangle_{ii,jj'}$. 
* For $Cov_3$ one averages over all combinations of *different treatments and different readers*, as denoted by $\left \langle \right \rangle_{ii',jj'}$. 


### Physical meanings of the covariance terms {#PhysicalMeaningsOfCovMatrix}
The meanings of the different terms follow a similar description to that given in Eqn. \@ref(StrCovMatrix). The diagonal term $\text{Var}$ is the variance of the figures-of-merit when reader $j$ interprets different case-sets $\{c\}$ in treatment $i$. Each case-set yields a number $\theta_{ij\{c\}}$ and the variance of the $C$ numbers, averaged over the $I \times J$ treatments and readers, is $\text{Var}$. It captures the total variability due to varying difficulty levels of the case-sets, inter-reader and within-reader variability. 

It is easier to see the physical meanings of $\text{Cov1}, Cov_2, Cov_3$ if one starts with the correlations. 

* $\rho_{1;ii'jj}$ is the correlation of the figures-of-merit when reader $j$ interprets case-sets in different treatments $i,i'$. Each case-set, starting with $c = 1$, yields two numbers $\theta_{ij\{1\}}$ and $\theta_{i'j\{1\}}$. The correlation of the two pairs of C-length arrays, averaged over all pairings of different treatments and same readers, is $\rho_1$. The correlation exists due to the common contribution of the shared reader. When the common variation is large, the two arrays become more correlated and $\rho_1$ approaches unity. If there is no common variation, the two arrays become independent, and $\rho_1$ equals zero. Converting from correlation to covariance, see Eqn. \@ref(eq:CovMtrxSigmaRhoForm), one has $\text{Cov1} < \text{Var}$.

* $\rho_{2;iijj'}$ is the correlation of the figures-of-merit values when different readers $j,j'$ interpret the same case-sets in the same treatment $i$. As before this yields two C-length arrays, whose correlation, upon averaging over all distinct treatment pairings and same readers, yields $\rho_2$. If one assumes that common variation between different-reader same-treatment FOMs is smaller than the common variation between same-reader different-treatment FOMs, then $\rho_2$ will be smaller than $\rho_1$. This is equivalent to stating that readers agree more with themselves in different treatments than they do with other readers in the same treatment. Translating to covariances, one has $Cov_2 < \text{Cov1} < \text{Var}$.

* $\rho_{3;ii'jj'}$ is the correlation of the figure-of-merit values when different readers $j,j'$ interpret the same case set in different treatments $i,i'$, etc., yielding $\rho_3$. This is expected to yield the least correlation. 

Summarizing, one expects the following ordering for the terms in the covariance matrix:

\begin{equation}
Cov_3 \leq  Cov_2 \leq  \text{Cov1} \leq  \text{Var}
(\#eq:CovOrderings)
\end{equation}

## Summary{#ORMethodIntro-Summary}
## Discussion{#ORMethodIntro-Discussion}
## References {#ORMethodIntro-references}


<!--chapter:end:10A-OR-AnalysisIntro.Rmd-->

---
output:
  html_document: default
  pdf_document: default
---
# Obuchowski Rockette (OR) Analysis {#ORAnalysisSigTesting}



## Introduction {#ORAnalysisSigTesting-introduction}
In previous chapters the DBM significance testing procedure [@RN204] for analyzing MRMC ROC data, along with improvements [@RN2508], has been described. Because the method assumes that jackknife pseudovalues can be regarded as independent and identically distributed case-level figures of merit, it has been rightly criticized by Hillis and others [@zhou2009statistical]. Hillis states that the method "works" but lacks firm statistical foundations [@RN1772; @RN1865; @RN1866]. I would add that it "works" as long as one restricts to the empirical AUC figure of merit. In my book I gave a justification for why the method "works". Specifically, the *empirical AUC pseudovalues qualify as case-level FOMs* - this property has also been noted by [@RN1395]. However, this property applies *only* to the empirical AUC, so an alternate approach that applies to any figure of merit is highly desirable. 

Hillis' has proposed that a method based on an earlier publication [@RN1450], which does not depend on pseudovalues, is preferable from both conceptual and practical points of view. This chapter is named "OR Analysis", where OR stands for Obuchowski and Rockette. The OR method has advantages in being able to handle more complex study designs [@RN2508] that are addressed in subsequent chapters, and applications to other FOMs (e.g., the FROC paradigm uses a rather different FOM from empirical ROC-AUC) are best performed with the OR method.

This chapter delves into the significance testing procedure employed in OR analysis. 

Multiple readers interpreting a case-set in multiple treatments is analyzed and the results, DBM vs. OR, are compared for the same dataset. The special cases of fixed-reader and fixed-case analyses are described. Single treatment analysis, where interest is in comparing average performance of readers to a fixed value, is described. Three methods of estimating the covariance matrix are described.

Before proceeding, it is understood that datasets analyzed in this chapter follow a _factorial_ design, sometimes call fully-factorial or fully-crossed design. Basically, the data structure is symmetric, e.g., all readers interpret all cases in all modalities. The next chapter will describe the analysis of _split-plot_ datasets, where, for example, some readers interpret all cases in one modality, while the remaining readers interpret all cases in the other modality.

## Random-reader random-case {#OR_RRRC}
In conventional ANOVA models, such as used in DBM, the covariance matrix of the error term is diagonal with all diagonal elements equal to a common variance, represented in the DBM model by the scalar $\epsilon$ term. Because of the correlated structure of the error term, in OR analysis, a customized ANOVA is needed. The null hypothesis (NH) is that the true figures-of-merit of all treatments are identical, i.e., 

\begin{equation}
NH:\tau_i=0\;\; (i=1,2,...,I)
(\#eq:ORModelNH)
\end{equation}

The analysis described next considers both readers and cases as random effects. The F-statistic is denoted $F_{ORH}$, defined by: 

\begin{equation}
F_{ORH}=\frac{MS(T)}{MS(TR)+J\max(\text{Cov2}-\text{Cov3},0)}
(\#eq:F-ORH-RRRC)
\end{equation}

Eqn. \@ref(eq:F-ORH-RRRC) incorporates Hillis’ modification of the original OR F-statistic. The modification ensures that the constraint Eqn. \@ref(eq:CovOrderings) is always obeyed and also avoids a possibly negative (and hence illegal) F-statistic. The relevant mean squares are defined by (note that these are calculated using *FOM* values, not *pseudovalues*):

\begin{align}
\left.\begin{array}{rcl}
MS(T)&=&\frac{J}{I-1}\sum_{i=1}^{I}(\theta_{i\bullet}-\theta_{\bullet\bullet})^2\\
\\ 
MS(R)&=&\frac{I}{J-1}\sum_{j=1}^{J}(\theta_{\bullet j}-\theta_{\bullet\bullet})^2\\
\\
MS(TR)&=&\frac{1}{(I-1)(J-1)}\sum_{i=1}^{I}\sum_{j=1}^{J}(\theta_{ij}-\theta_{i\bullet}-\theta_{\bullet j}+\theta_{\bullet\bullet})
\end{array}\right\}
(\#eq:MS-OR)
\end{align}

The original paper [@RN1450] actually proposed a different test statistic $F_{OR}$:

\begin{equation}
F_{OR}=\frac{MS(T)}{MS(TR)+J(\text{Cov2}-\text{Cov3})}
(\#eq:F-OR)
\end{equation}

Note that Eqn. \@ref(eq:F-OR) lacks the constraint, subsequently proposed by Hillis, which ensures that the denominator cannot be negative. The following distribution was proposed for the test statistic. 

\begin{equation}
F_{OR}\sim F_{\text{ndf},\text{ddf}}
(\#eq:SamplingDistr-F-OR)
\end{equation}

The original degrees of freedom were defined by:

\begin{align}
\begin{split}
\text{ndf}&=I-1\\
\text{ddf}&=(I-1)\times(J-1)
\end{split}
(\#eq:ORdegreesOfFreedom)
\end{align}

It turns out that the Obuchowski-Rockette test statistic is very conservative, meaning it is highly biased against rejecting the null hypothesis (the data simulator used in the validation described in their publication did not detect this behavior). Because of the conservative behavior, the predicted sample sizes tended to be quite large (if the test statistic does not reject the NH as often as it should, one way to overcome this tendency is to use a larger sample size). In this connection I have two informative anecdotes.

### Two anecdotes {#TwoAnecdotes}

* The late Dr. Robert F. Wagner once stated to the author (ca. 2001) that the sample-size tables published by Obuchowski [@RN1971;@RN1972], using the version of Eqn. \@ref(eq:F-ORH-RRRC) with the *ddf* as originally suggested by Obuchowski and Rockette, predicted such high number of readers and cases that he was doubtful about the chances of anyone conducting a practical ROC study! 

* The second story is that the author once conducted NH simulations and analyses using a Roe-Metz simulator [@RN1125] and the significance testing described in the Obuchowski-Rockette paper: the method did not reject the null hypothesis even once in 2000 trials! Recall that with $\alpha = 0.05$ a valid test should reject the null hypothesis about $100\pm20$ times in 2000 trials. The author recalls (ca. 2004) telling Dr. Steve Hillis about this issue, and he suggested a different denominator degrees of freedom *ddf*, see next, substitution of which magically solved the problem, i.e., the simulations rejected the null hypothesis 5% of the time. 

### Hillis ddf {#Hills-ddf}
Hillis' proposed new *ddf* is shown below (*ndf* is unchanged), with the subscript $H$ denoting the Hillis modification:

\begin{equation}
\text{ddf}_H = \frac{\left [ MS(TR) + J \max(\text{Cov2}-\text{Cov3},0)\right ]^2}{\frac{\left [ MS(TR) \right ]^2}{(I-1)(J-1)}}
(\#eq:ddfH-RRRC)
\end{equation}

From the previous chapter, the ordering of the covariances is as follows:

\begin{equation*}
\text{Cov3} \leq  \text{Cov2} \leq  \text{Cov1} \leq  \text{Var}
\end{equation*}

If $\text{Cov2} < \text{Cov3}$ (which is the *exact opposite* of the expected ordering), $\text{ddf}_H$ reduces to $(I-1)\times(J-1)$, the value originally proposed by Obuchowski and Rockette. With Hillis' proposed changes, under the null hypothesis the observed statistic $F_{ORH}$, defined in Eqn. \@ref(eq:F-ORH-RRRC), is distributed as an F-statistic with $\text{ndf} = I-1$ and *ddf* = $\text{ddf}_H$ degrees of freedom [@RN1772;@RN1865;@RN1866]: 

\begin{equation}
F_{ORH}\sim F_{\text{ndf},\text{ddf}_H}
(\#eq:SamplingDistr-F-ORH-RRRC)
\end{equation}

If the expected ordering is true, i.e., $\text{Cov2} > \text{Cov3}$ , which is the more likely situation, then $\text{ddf}_H$ is *larger* than $(I-1)\times(J-1)$, i.e., the Obuchowski-Rockette *ddf*, and the p-value decreases and there is a larger probability of rejecting the NH. The modified OR method is more likely to have the correct NH behavior, i.e, it will reject the NH 5% of the time when alpha is set to 0.05 (statisticians refer to this as "passing the 5% test"). The correct NH behavior has been confirmed in simulation testing using the Roe-Metz simulator (@RN1866).

### Decision rule, p-value and confidence interval
The critical value of the F-statistic for rejection of the null hypothesis is $F_{1-\alpha,\text{ndf},\text{ddf}_H}$, i.e., that value such that fraction $(1-\alpha)$ of the area under the distribution lies to the left of the critical value. From Eqn. \@ref(eq:F-ORH-RRRC):

* Rejection of the NH is more likely if $MS(T)$ increases, meaning the treatment effect is larger; 

* $MS(TR)$ is smaller, meaning there is less contamination of the treatment effect by treatment-reader variability; 
* The greater of $\text{Cov2}$ or $\text{Cov3}$, which is usually $\text{Cov2}$, decreases, meaning there is less "noise" in the measurement due to between-reader variability. Recall that $\text{Cov2}$ involves different-reader same-treatment pairings.  
* $\alpha$ increases, meaning one is allowing a greater probability of Type I errors; 
* $\text{ndf}$ increases, as this lowers the critical value of the F-statistic. With more treatment pairings, the chance that at least one paired-difference will reject the NH is larger. 
* $\text{ddf}_H$ increases, as this lowers the critical value of the F-statistic. 

The p-value of the test is the probability, under the NH, that an equal or larger value of the F-statistic than $F_{ORH}$ could be observed by chance. In other words, it is the area under the F-distribution $F_{\text{ndf},\text{ddf}_H}$ that lies above the observed value $F_{ORH}$:

\begin{equation}
p=\Pr(F>F_{ORH} \mid F\sim F_{\text{ndf},\text{ddf}_H})
(\#eq:pValueOR-RRRC)
\end{equation}

The $(1-\alpha)$ confidence interval for $\theta_{i \bullet} - \theta_{i' \bullet}$ is given by:

\begin{equation}
\begin{split}
CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}} =& \theta_{i \bullet} - \theta_{i' \bullet} \\ 
&\pm t_{\alpha/2, \text{ddf}_H}\sqrt{\textstyle\frac{2}{J}(MS(TR)+J\max(\text{Cov2}-\text{Cov3},0))}
\end{split}
(\#eq:CI-DiffFomRRRC)
\end{equation}

Define $\text{df}_i$, the degrees of freedom for modality $i$: 

\begin{equation}
\text{df}_i = (\text{MS(R)}_i + J\max(\text{Cov2}_{i}, 0))^2/\text{MS(R)}_i^2 * (J - 1)
(\#eq:CI-RRRC-df-IndvlTrt)
\end{equation}

Here $\text{MS(R)}_i$ is the reader mean-square for modality $i$, and $\text{Cov2}_i$ is $\text{Cov2}$ for modality $i$. Note that all quantities with an $i$ index are calculated using data from modality $i$ only.

The $(1-\alpha)$ confidence interval for $\theta_{i \bullet}$, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$, is given by:

\begin{equation}
CI_{1-\alpha,RRRC,\theta_{i \bullet}} = \theta_{i \bullet} \pm t_{\alpha/2, \text{df}_i}\sqrt{\textstyle\frac{1}{J}(\text{MS(R)}_i + J\max(\text{Cov2}_{i}, 0))}
(\#eq:CI-RRRC-IndvlTrt)
\end{equation}

## Fixed-reader random-case {#OR-FRRC}
Using the vertical bar notation $\mid R$ to denote that reader is regarded as a fixed effect [@RN1124], the F -statistic for testing the null hypothesis $NH: \tau_i = 0 \; (i=1,1,2,...I)$ is [@RN1865]: 

\begin{equation}
F_{ORH \mid R}=\frac{MS(T)}{\text{Var}-\text{Cov1}+(J-1)\max(\text{Cov2}-\text{Cov3},0)}
(\#eq:DefFStatFRRC-OR)
\end{equation}

[Note that for $J$ = 1, Eqn. \@ref(eq:DefFStatFRRC-OR) reduces to Eqn. \@ref(eq:DefF-1RMT), i.e., the single-reader analysis described in the previous chapter.] 

$F_{ORH \mid R}$ is distributed as an F-statistic with $\text{ndf} = I-1$ and $\text{ddf} = \infty$:

\begin{equation}
F_{ORH \mid R} \sim F_{I-1,\infty}
(\#eq:FStatDistrFRRC-OR)
\end{equation}

One can get rid of the infinite denominator degrees of freedom by recognizing, as in the previous chapter, that $(I-1) F_{I-1,\infty}$ is distributed as a $\chi^2$ distribution with $I-1$ degrees of freedom, i.e., as $\chi^2_{I-1}$. Therefore, one has, analogous to Eqn. \@ref(eq:F-1RMT),

\begin{equation}
\chi^2_{ORH \mid R} \equiv (I-1)F_{ORH \mid R} \sim \chi^2_{I-1}
(\#eq:ChisqStatFRRC-OR)
\end{equation}

The critical value of the $\chi^2$ statistic is $\chi^2_{1-\alpha,I-1}$, which is that value such that fraction $(1-\alpha)$ of the area under the $\chi^2_{I-1}$ distribution lies to the left of the critical value. The null hypothesis is rejected if the observed value of the $\chi^2$ statistic exceeds the critical value, i.e.,

$$\chi^2_{ORH \mid R} > \chi^2_{1-\alpha,I-1}$$

The p-value of the test is the probability that a random sample from the chi-square distribution $\chi^2_{I-1}$ exceeds the observed value of the test statistic $\chi^2_{ORH \mid R}$ statistic defined in Eqn. \@ref(eq:ChisqStatFRRC-OR):

\begin{equation}
p=\Pr(\chi^2 > \chi^2_{ORH \mid R} \mid \chi^2 \sim \chi^2_{I-1})
(\#eq:pValueFRRC-OR)
\end{equation}

The $(1-\alpha)$ (symmetric) confidence interval for the difference figure of merit is given by:

\begin{equation}
\begin{split}
CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}} =&(\theta_{i \bullet} - \theta_{i' \bullet}) \\ 
&\pm t_{\alpha/2, \infty}\sqrt{\textstyle\frac{2}{J}(\text{Var}-\text{Cov1}+(J-1)\max(\text{Cov2}-\text{Cov3},0))}
\end{split}
(\#eq:CIDiffFomFRRC-OR)
\end{equation}

The NH is rejected if any of the following equivalent conditions is met (these statements are also true for `RRRC` analysis, and `RRFC` analysis to be described next):

* The observed value of the $\chi^2$ statistic exceeds the critical value $\chi^2_{1-\alpha,I-1}$.
* The p-value is less than $\alpha$.
* The $(1-\alpha)$ confidence interval for at least one treatment-pairing does not include zero.

Additional confidence intervals are stated below: 

* The confidence interval for the reader-averaged FOM for each treatment, denoted $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$. 
* The confidence interval for treatment FOM differences for each reader, denoted $CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}}$.  

\begin{equation}
CI_{1-\alpha,FRRC,\theta_{i \bullet}} = \theta_{i \bullet} \pm z_{\alpha/2}\sqrt{\textstyle\frac{1}{J}(\text{Var}_i+(J-1)\max(\text{Cov2}_i,0)}
(\#eq:CIIndTrtFomFRRC-OR)
\end{equation}

\begin{equation}
CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}} = (\theta_{i j} - \theta_{i' j}) \pm z_{\alpha/2}\sqrt{2(\text{Var}_j - \text{Cov1}_j)}
(\#eq:CIIndRdrDiffFomFRRC-OR)
\end{equation}

In these equations $\text{Var}_i$ and $\text{Cov2}_i$ are computed using the data for treatment $i$ only, and $\text{Var}_j$ and $\text{Cov1}_j$ are computed using the data for reader $j$ only.  

## Random-reader fixed-case {#ORAnalysisSigTesting-RRFCAnalysis}
When case is treated as a fixed factor, the appropriate F-statistic for testing the null hypothesis $NH: \tau_i = 0 \; (i=1,1,2,...I)$ is: 

\begin{equation}
F_{ORH \mid C}=\frac{MS(T)}{MS(TR)}
(\#eq:DefFStatRRFC)
\end{equation}

$F_{ORH \mid C}$ is distributed as an F-statistic with $ndf = I-1$ and $ddf = (I-1)(J-1)$:

\begin{equation}
\left.\begin{array}{rcl}
\text{ndf}&=&I-1\\ 
\text{ddf}&=&(I-1)(J-1)\\
F_{ORH \mid C} &\sim& F_{\text{ndf},\text{ddf}}
\end{array}\right\}
(\#eq:FStatRRFC)
\end{equation}

Here is a situation where the degrees of freedom agree with those originally proposed by Obuchowski-Rockette. The critical value of the statistic is $F_{1-\alpha,I-1,(I-1)(J-1)}$, which is that value such that fraction $(1-\alpha)$ of the distribution lies to the left of the critical value. The null hypothesis is rejected if the observed value of the F statistic exceeds the critical value:

$$F_{ORH \mid C}>F_{1-\alpha,I-1,(I-1)(J-1)}$$

The p-value of the test is the probability that a random sample from the distribution exceeds the observed value:

$$p=\Pr(F>F_{ORH \mid C} \mid F \sim F_{1-\alpha,I-1,(I-1)(J-1)})$$

The $(1-\alpha)$ confidence interval for the reader-averaged difference FOM, $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$, is given by:

\begin{equation}
CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}} = (\theta_{i \bullet} - \theta_{i' \bullet}) \pm t_{\alpha/2, (I-1)(J-1)}\sqrt{\textstyle\frac{2}{J}MS(TR)}
(\#eq:CIDiffFomRRFC)
\end{equation}

The $(1-\alpha)$ confidence interval for the reader-averaged FOM for each treatment, $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$, is given by:

\begin{equation}
CI_{1-\alpha,RRFC,\theta_{i \bullet}} = \theta_{i \bullet} \pm t_{\alpha/2, J-1}\sqrt{\textstyle\frac{1}{J}\text{MS(R)}_i}
(\#eq:CIRRFCIndTrt)
\end{equation}

Here $\text{MS(R)}_i$ is the reader mean-square for modality $i$.

## Summary{#ORAnalysisSigTesting-Summary}
## Discussion{#ORAnalysisSigTesting-Discussion}
## References {#ORAnalysisSigTesting-references}


<!--chapter:end:10B-OR-AnalysisSigTesting.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Obuchowski Rockette Applications {#ORApplications} 



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

## Hand calculation {#ORApplications-dataset02-hand}

Dataset `dataset02` is well-know in the literature [@RN1993] as it has been widely used to illustrate advances in ROC methodology. The following code extract the numbers of modalities, readers and cases for `dataset02` and defines strings `modalityID`, `readerID` and `diffTRName` that are needed for the hand-calculations.


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
* The first step is to calculate the figures of merit using `UtilFigureOfMerit()`. 
* Note that the `FOM` argument has to be explicitly specified as there is no default.


```r
foms <- UtilFigureOfMerit(dataset02, FOM = "Wilcoxon")
print(foms, digits = 4)
#>        rdr0   rdr1   rdr2   rdr3   rdr4
#> trt0 0.9196 0.8588 0.9039 0.9731 0.8298
#> trt1 0.9478 0.9053 0.9217 0.9994 0.9300
```

* For example, for the first treatment, `"trt0"`, the second reader `"rdr1"` figure of merit is 0.8587762.
* The next step is to calculate the variance-covariance matrix and the mean-squares.
* The function `UtilORVarComponentsFactorial()` returns these quantities, which are saved to `vc`. 
* The `Factorial` in the function name is because this code applies to the factorial design. A different function is used for a split-plot design.


```r
vc <- UtilORVarComponentsFactorial(
  dataset02, FOM = "Wilcoxon", covEstMethod = "jackknife")
print(vc, digits = 4)
#> $TRanova
#>          SS DF       MS
#> T  0.004796  1 0.004796
#> R  0.015345  4 0.003836
#> TR 0.002204  4 0.000551
#> 
#> $VarCom
#>       Estimates   Rhos
#> VarR  0.0015350     NA
#> VarTR 0.0002004     NA
#> Cov1  0.0003466 0.4320
#> Cov2  0.0003441 0.4289
#> Cov3  0.0002390 0.2979
#> Var   0.0008023     NA
#> 
#> $IndividualTrt
#>      DF msREachTrt varEachTrt cov2EachTrt
#> trt0  4   0.003083  0.0010141   0.0004840
#> trt1  4   0.001305  0.0005905   0.0002042
#> 
#> $IndividualRdr
#>      DF msTEachRdr varEachRdr cov1EachRdr
#> rdr0  1  0.0003971  0.0006989   3.735e-04
#> rdr1  1  0.0010829  0.0011061   7.602e-04
#> rdr2  1  0.0001597  0.0008423   3.553e-04
#> rdr3  1  0.0003445  0.0001506   1.083e-06
#> rdr4  1  0.0050161  0.0012136   2.430e-04
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
print(F_ORH_RRRC, digits = 4)
#> [1] 4.456
```

* The F-statistic has numerator degrees of freedom $\text{ndf} = I - 1$ and denominator degrees of freedom, `ddf`, to be calculated next.
* From the previous chapter, `ddf` is calculated using Eqn. \@ref(eq:ddfH-RRRC)). The numerator of `ddf` is identical to `den^2`, where `den` was calculated in the preceding code block. The implementation follows:


```r
ddf <- den^2*(I-1)*(J-1)/(vc$TRanova["TR", "MS"])^2
print(ddf, digits = 4)
#> [1] 15.26
```

* The next step is calculation of the p-value for rejecting the NH
* The relevant equation is Eqn. \@ref(eq:pValueOR-RRRC) whose implementation follows: 


```r
p <- 1 - pf(F_ORH_RRRC, I - 1, ddf)
print(p, digits = 4)
#> [1] 0.05167
```

* The difference is not significant at $\alpha$ = 0.05. 
* The next step is to calculate confidence intervals.
* Since `I` = 2, their is only one paired difference in reader-averaged FOMs, namely, the first treatment minus the second.


```r
trtMeans <- rowMeans(foms)
trtMeanDiffs <- trtMeans[1] - trtMeans[2]
names(trtMeanDiffs) <- "trt0-trt1"
print(trtMeans, digits = 4)
#>   trt0   trt1 
#> 0.8970 0.9408
print(trtMeanDiffs, digits = 4)
#> trt0-trt1 
#>   -0.0438
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
print(CI_RRRC, digits = 4)
#>      Lower      Upper 
#> -0.0879595  0.0003589
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
print(CI_RRRC_IndvlTrt, digits = 4)
#>      Estimate  StdErr   DFi CILower CIUpper     Cov2i
#> trt0   0.8970 0.03317 12.74  0.8252  0.9689 0.0004840
#> trt1   0.9408 0.02157 12.71  0.8941  0.9875 0.0002042
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
print(FTests, digits = 4)
#>                  MS Chisq DF       p
#> Treatment 0.0047962 5.476  1 0.01928
#> Error     0.0008759    NA NA      NA
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
print(ciDiffTrtFRRC, digits = 4)
#>           Estimate  StdErr     z   PrGTz  CILower   CIUpper
#> trt0-trt1  -0.0438 0.01872 -2.34 0.01928 -0.08049 -0.007115
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
print(ciAvgRdrEachTrt, digits = 4)
#>      Estimate  StdErr  DF CILower CIUpper
#> trt0   0.8970 0.02429 113  0.8494  0.9446
#> trt1   0.9408 0.01678 113  0.9080  0.9737
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
print(ciDiffTrtEachRdr, digits = 3)
#>                 Estimate StdErr      z  PrGTz CILower  CIUpper
#> rdr0::trt0-trt1  -0.0282 0.0255 -1.105 0.2693 -0.0782  0.02182
#> rdr1::trt0-trt1  -0.0465 0.0263 -1.769 0.0768 -0.0981  0.00501
#> rdr2::trt0-trt1  -0.0179 0.0312 -0.573 0.5668 -0.0790  0.04330
#> rdr3::trt0-trt1  -0.0262 0.0173 -1.518 0.1290 -0.0601  0.00764
#> rdr4::trt0-trt1  -0.1002 0.0441 -2.273 0.0230 -0.1865 -0.01381
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
print(FTests_RRFC, digits = 4)
#>    DF       MS     F       p
#> T   1 0.004796 8.704 0.04196
#> TR  4 0.000551    NA      NA
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

print(ciDiffTrt_RRFC, digits = 4)
#>           Estimate  StdErr DF     t   PrGTt  CILower  CIUpper
#> trt0-trt1  -0.0438 0.01485  4 -2.95 0.04196 -0.08502 -0.00258
```
* As expected because the overall F-test showed significance, the confidence interval does not include zero (the p-value is identical to that found by the F-test). 
* This completes the hand calculations.

## RJafroc: dataset02 {#ORApplications-dataset02-RJafroc}

The second example shows application of the `RJafroc` package function `StSignificanceTesting()` to `dataset02`. This function encapsulates all formulae discussed previously and accomplishes the analyses with a single function call. It returns an object, denoted `st1` below, that contains all results of the analysis. It is a `list` with the following components:

* `FOMs`, this in turn is a `list` containing the following data frames: 
    + `foms`, the individual treatment-reader figures of merit, i.e., $\theta_{i j}$, 
    + `trtMeans`, the treatment figures of merit averaged over readers, i.e., $\theta_{i \bullet}$,
    + `trtMeanDiffs`, the inter-treatment figures of merit differences averaged over readers, i.e., $\theta_{i \bullet}-\theta_{i' \bullet}$.

* `ANOVA`, a `list` containing the following data frames: 
    + `TRanova`, the treatment-reader ANOVA table,
    + `VarCom`, Obuchowski-Rockette variance-covariances and correlations,
    + `IndividualTrt`, the mean-squares, `Var` and `Cov2` calculated over individual treatments,
    + `IndividualRdr`, the mean-squares, `Var` and `Cov1` calculated over individual readers.

* `RRRC`, a `list` containing the following data frames: 
    + `FTests`, the results of the F-test,
    + `ciDiffTrt`, the confidence intervals for inter-treatment FOM differences, averaged over readers, denoted $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$ in the previous chapter,
    + `ciAvgRdrEachTrt`, the confidence intervals for individual treatment FOMs, averaged over readers, denoted $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$ in the previous chapter.

* `FRRC`, a `list` containing the following data frames: 
    + `FTests`, the results of the F-tests, which in this case specializes to chi-square tests,
    + `ciDiffTrt`, the confidence intervals for inter-treatment FOM differences, averaged over readers, denoted $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$ in the previous chapter,
    + `ciAvgRdrEachTrt`, the confidence intervals for individual treatment FOMs, averaged over readers, denoted $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$ in the previous chapter,
    + `ciDiffTrtEachRdr`, the confidence intervals for inter-treatment FOM differences for individual readers, denoted $CI_{1-\alpha,FRRC,\theta_{ij} - \theta_{i'j}}$ in the previous chapter,
    + `IndividualRdrVarCov1`, the individual reader variance-covariances and means squares.

* `RRFC`, a `list` containing the following data frames: 
    + `FTests`, the results of the F-tests, which in this case specializes to chi-square tests,
    + `ciDiffTrt`, the confidence intervals for inter-treatment FOM differences, averaged over readers, denoted $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$ in the previous chapter,
    + `ciAvgRdrEachTrt`, the confidence intervals for indvidual treatment FOMs, averaged over readers, denoted $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$ in the previous chapter.

In the interest of clarity, in the first example using the `RJafroc` package the components of the returned object `st1` are listed separately and described explicitly. In the interest of brevity, in subsequent examples the object is listed in its entirety.

Online help on the `StSignificanceTesting()` function is available:


```r
?`StSignificanceTesting`
```

The lower right `RStudio` panel contains the online description. Click on the small up-and-right pointing arrow icon to expand this to a new window. 

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset02-RJafroc}
* Since `analysisOption` is not explicitly specified in the following code, the function `StSignificanceTesting` performs all three analyses: `RRRC`, `FRRC` and `RRFC`.
* Likewise, the significance level of the test, also an argument, `alpha`, defaults to 0.05. 
* The code below applies `StSignificanceTesting()` and saves the returned object to `st1`. 
* The first member of this object, a  `list` named `FOMs`, is then displayed. 
* `FOMs` contains three data frames: 
    + `FOMS$foms`, the figures of merit for each treatment and reader, 
    + `FOMS$trtMeans`, the figures of merit for each treatment averaged over readers, and 
    + `FOMS$trtMeanDiffs`, the inter-treatment difference figures of merit averaged over readers. The difference is always the first treatment minus the second, etc., in this example, `trt0` minus `trt1`.


```r
st1 <- StSignificanceTesting(dataset02, FOM = "Wilcoxon", method = "OR")
print(st1$FOMs, digits = 4)
#> $foms
#>        rdr0   rdr1   rdr2   rdr3   rdr4
#> trt0 0.9196 0.8588 0.9039 0.9731 0.8298
#> trt1 0.9478 0.9053 0.9217 0.9994 0.9300
#> 
#> $trtMeans
#>      Estimate
#> trt0   0.8970
#> trt1   0.9408
#> 
#> $trtMeanDiffs
#>           Estimate
#> trt0-trt1  -0.0438
```

* Displayed next are the variance components and mean-squares contained in the `ANOVA` `list`. 
    * `ANOVA$TRanova` contains the treatment-reader ANOVA table, i.e. the sum of squares, the degrees of freedom and the mean-squares, for treatment, reader and treatment-reader factors, i.e., `T`, `R` and `TR`.
    * `ANOVA$VarCom` contains the OR variance components and the correlations.
    * `ANOVA$IndividualTrt` contains the quantities necessary for individual treatment analyses.
    * `ANOVA$IndividualRdr` contains the quantities necessary for individual reader analyses.


```r
print(st1$ANOVA, digits = 4)
#> $TRanova
#>          SS DF       MS
#> T  0.004796  1 0.004796
#> R  0.015345  4 0.003836
#> TR 0.002204  4 0.000551
#> 
#> $VarCom
#>       Estimates   Rhos
#> VarR  0.0015350     NA
#> VarTR 0.0002004     NA
#> Cov1  0.0003466 0.4320
#> Cov2  0.0003441 0.4289
#> Cov3  0.0002390 0.2979
#> Var   0.0008023     NA
#> 
#> $IndividualTrt
#>      DF msREachTrt varEachTrt cov2EachTrt
#> trt0  4   0.003083  0.0010141   0.0004840
#> trt1  4   0.001305  0.0005905   0.0002042
#> 
#> $IndividualRdr
#>      DF msTEachRdr varEachRdr cov1EachRdr
#> rdr0  1  0.0003971  0.0006989   3.735e-04
#> rdr1  1  0.0010829  0.0011061   7.602e-04
#> rdr2  1  0.0001597  0.0008423   3.553e-04
#> rdr3  1  0.0003445  0.0001506   1.083e-06
#> rdr4  1  0.0050161  0.0012136   2.430e-04
```

* Displayed next are the results of the RRRC significance test, contained in `st1$RRRC`.


```r
print(st1$RRRC$FTests, digits = 4)
#>              DF       MS FStat       p
#> Treatment  1.00 0.004796 4.456 0.05167
#> Error     15.26 0.001076    NA      NA
```

* `st1$RRRC$FTests` contains the results of the F-tests: the degrees of freedom, the mean-squares, the observed value of the F-statistic and the p-value for rejecting the NH, listed separately, where applicable, for the treatment and error terms. 
* For example, the treatment mean squares is `st1$RRRC$FTests["Treatment", "MS"]` whose value is 0.00479617.


```r
print(st1$RRRC$ciDiffTrt, digits = 3)
#>           Estimate StdErr   DF     t  PrGTt CILower  CIUpper
#> trt0-trt1  -0.0438 0.0207 15.3 -2.11 0.0517  -0.088 0.000359
```

* `st1$RRRC$ciDiffTrt` contains the results of the confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.


```r
print(st1$RRRC$ciAvgRdrEachTrt, digits = 4)
#>      Estimate  StdErr    DF CILower CIUpper      Cov2
#> trt0   0.8970 0.03317 12.74  0.8252  0.9689 0.0004840
#> trt1   0.9408 0.02157 12.71  0.8941  0.9875 0.0002042
```

* `st1$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset02-RJafroc}

* Displayed next are the results of FRRC analysis, contained in `st1$FRRC`.
* `st1$FRRC$FTests` contains the results of the F-tests: the degrees of freedom, the mean-squares, the observed value of the F-statistic and the p-value for rejecting the NH, listed separately, where applicable, for the treatment and error terms. 
* For example, the treatment mean squares is `st1$FRRC$FTests["Treatment", "MS"]` whose value is 0.00479617.


```r
print(st1$FRRC$FTests, digits = 4)
#>                  MS Chisq DF       p
#> Treatment 0.0047962 5.476  1 0.01928
#> Error     0.0008759    NA NA      NA
```

* Note that this time the output lists a chi-square distribution observed value, 5.47595324, with degree of freedom $df = I -1 = 1$.
* The listed mean-squares and the p-value agree with the previously performed hand calculations.
* For FRRC analysis the value of the chi-square statistic is significant and the p-value is smaller than $\alpha$.


```r
print(st1$FRRC$ciDiffTrt, digits = 4)
#>           Estimate  StdErr     z   PrGTz  CILower   CIUpper
#> trt0-trt1  -0.0438 0.01872 -2.34 0.01928 -0.08049 -0.007115
```

* `st1$FRRC$ciDiffTrt` contains confidence intervals for inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* The confidence interval excludes zero, and the p-value, listed under `PrGTz` (for probability greater than `z`) is smaller than 0.05.
* One could be using the t-distribution with infinite degrees of freedom, but this is identical to the normal distribution. Hence the listed value is a `z` statistic, i.e., `z = -0.043800322/0.018717483` = -2.34007543.


```r
print(st1$FRRC$ciAvgRdrEachTrt, digits = 4)
#>      Estimate  StdErr  DF CILower CIUpper
#> trt0   0.8970 0.02429 113  0.8494  0.9446
#> trt1   0.9408 0.01678 113  0.9080  0.9737
```

* `st1$FRRC$st1$FRRC$ciAvgRdrEachTrt` contains confidence intervals for individual treatment FOMs, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.



```r
print(st1$FRRC$ciDiffTrtEachRdr, digits = 3)
#>                 Estimate StdErr      z  PrGTz CILower  CIUpper
#> rdr0::trt0-trt1  -0.0282 0.0255 -1.105 0.2693 -0.0782  0.02182
#> rdr1::trt0-trt1  -0.0465 0.0263 -1.769 0.0768 -0.0981  0.00501
#> rdr2::trt0-trt1  -0.0179 0.0312 -0.573 0.5668 -0.0790  0.04330
#> rdr3::trt0-trt1  -0.0262 0.0173 -1.518 0.1290 -0.0601  0.00764
#> rdr4::trt0-trt1  -0.1002 0.0441 -2.273 0.0230 -0.1865 -0.01381
```

* `st1$FRRC$st1$FRRC$ciDiffTrtEachRdr` contains confidence intervals for inter-treatment difference FOMs, for each reader, i.e., $CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}}$.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset02-RJafroc}


```r
print(st1$RRFC$FTests, digits = 4)
#>    DF       MS     F       p
#> T   1 0.004796 8.704 0.04196
#> TR  4 0.000551    NA      NA
```

* `st1$RRFC$FTests` contains results of the F-test: the degrees of freedom, the mean-squares, the observed value of the F-statistic and the p-value for rejecting the NH, listed separately, where applicable, for the treatment and treatment-reader terms. The latter is also termed the "error term". 
* For example, the treatment-reader mean squares is `st1$RRFC$FTests["TR", "MS"]` whose value is \ensuremath{5.51030622\times 10^{-4}}.


```r
print(st1$RRFC$ciDiffTrt, digits = 4)
#>           Estimate  StdErr DF     t   PrGTt  CILower  CIUpper
#> trt0-trt1  -0.0438 0.01485  4 -2.95 0.04196 -0.08502 -0.00258
```

* `st1$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment paired difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.



```r
print(st1$RRFC$ciAvgRdrEachTrt, digits = 4)
#>      Estimate  StdErr DF CILower CIUpper
#> Trt0   0.8970 0.02483  4  0.8281  0.9660
#> Trt1   0.9408 0.01615  4  0.8960  0.9857
```

* `st1$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.

## RJafroc: dataset04 {#ORApplications-dataset04-RJafroc}
* The third example uses the Federica Zanca dataset [@RN1882], i.e., `dataset04`, which has five modalities and four readers. 
* It illustrates the situation when multiple treatment pairings are involved. In contrast, the previous example had only one treatment pairing.
* Since this is an FROC dataset, in order to keep it comparable with the previous example, one converts it to an inferred-ROC dataset.
* The function `DfFroc2Roc(dataset04)` converts, using the highest-rating, the FROC dataset to an inferred-ROC dataset.
* The results are contained in `st2`. 
* As noted earlier, this time the object is listed in its entirety.


```r
ds <- DfFroc2Roc(dataset04) # convert to ROC
I <- length(ds$ratings$NL[,1,1,1])
J <- length(ds$ratings$NL[1,,1,1])
cat("I = ", I, ", J = ", J, "\n")
#> I =  5 , J =  4
st2 <- StSignificanceTesting(ds, FOM = "Wilcoxon", method = "OR")
print(st2, digits = 3)
#> $FOMs
#> $FOMs$foms
#>       rdr1  rdr2  rdr3  rdr4
#> trt1 0.904 0.798 0.812 0.866
#> trt2 0.864 0.845 0.821 0.872
#> trt3 0.813 0.816 0.753 0.857
#> trt4 0.902 0.832 0.789 0.880
#> trt5 0.841 0.773 0.771 0.848
#> 
#> $FOMs$trtMeans
#>      Estimate
#> trt1    0.845
#> trt2    0.850
#> trt3    0.810
#> trt4    0.851
#> trt5    0.808
#> 
#> $FOMs$trtMeanDiffs
#>            Estimate
#> trt1-trt2 -0.005100
#> trt1-trt3  0.035325
#> trt1-trt4 -0.005412
#> trt1-trt5  0.036775
#> trt2-trt3  0.040425
#> trt2-trt4 -0.000312
#> trt2-trt5  0.041875
#> trt3-trt4 -0.040737
#> trt3-trt5  0.001450
#> trt4-trt5  0.042187
#> 
#> 
#> $ANOVA
#> $ANOVA$TRanova
#>         SS DF       MS
#> T  0.00759  4 0.001897
#> R  0.02188  3 0.007294
#> TR 0.00555 12 0.000462
#> 
#> $ANOVA$VarCom
#>       Estimates  Rhos
#> VarR   1.28e-03    NA
#> VarTR -1.09e-05    NA
#> Cov1   2.95e-04 0.374
#> Cov2   2.33e-04 0.296
#> Cov3   2.12e-04 0.269
#> Var    7.89e-04    NA
#> 
#> $ANOVA$IndividualTrt
#>      DF msREachTrt varEachTrt cov2EachTrt
#> trt1  3   0.002422   0.000711    0.000211
#> trt2  3   0.000523   0.000751    0.000266
#> trt3  3   0.001855   0.000876    0.000246
#> trt4  3   0.002578   0.000727    0.000220
#> trt5  3   0.001766   0.000882    0.000222
#> 
#> $ANOVA$IndividualRdr
#>      DF msTEachRdr varEachRdr cov1EachRdr
#> rdr1  4   0.001551   0.000689    0.000215
#> rdr2  4   0.000794   0.000824    0.000346
#> rdr3  4   0.000786   0.001009    0.000354
#> rdr4  4   0.000153   0.000635    0.000265
#> 
#> 
#> $RRRC
#> $RRRC$FTests
#>             DF       MS FStat      p
#> Treatment  4.0 0.001897  3.47 0.0305
#> Error     16.8 0.000547    NA     NA
#> 
#> $RRRC$ciDiffTrt
#>            Estimate StdErr   DF       t  PrGTt   CILower  CIUpper
#> trt1-trt2 -0.005100 0.0165 16.8 -0.3084 0.7616 -0.040021  0.02982
#> trt1-trt3  0.035325 0.0165 16.8  2.1361 0.0477  0.000404  0.07025
#> trt1-trt4 -0.005412 0.0165 16.8 -0.3273 0.7475 -0.040334  0.02951
#> trt1-trt5  0.036775 0.0165 16.8  2.2238 0.0402  0.001854  0.07170
#> trt2-trt3  0.040425 0.0165 16.8  2.4445 0.0258  0.005504  0.07535
#> trt2-trt4 -0.000312 0.0165 16.8 -0.0189 0.9851 -0.035234  0.03461
#> trt2-trt5  0.041875 0.0165 16.8  2.5322 0.0216  0.006954  0.07680
#> trt3-trt4 -0.040737 0.0165 16.8 -2.4634 0.0249 -0.075659 -0.00582
#> trt3-trt5  0.001450 0.0165 16.8  0.0877 0.9312 -0.033471  0.03637
#> trt4-trt5  0.042187 0.0165 16.8  2.5511 0.0208  0.007266  0.07711
#> 
#> $RRRC$ciAvgRdrEachTrt
#>      Estimate StdErr    DF CILower CIUpper     Cov2
#> trt1    0.845 0.0286  5.46   0.774   0.917 0.000211
#> trt2    0.850 0.0199 27.72   0.809   0.891 0.000266
#> trt3    0.810 0.0266  7.04   0.747   0.873 0.000246
#> trt4    0.851 0.0294  5.40   0.777   0.925 0.000220
#> trt5    0.808 0.0258  6.78   0.747   0.870 0.000222
#> 
#> 
#> $FRRC
#> $FRRC$FTests
#>                 MS Chisq DF       p
#> Treatment 0.001897  13.6  4 0.00868
#> Error     0.000558    NA NA      NA
#> 
#> $FRRC$ciDiffTrt
#>            Estimate StdErr       z  PrGTz  CILower CIUpper
#> trt1-trt2 -0.005100 0.0167 -0.3054 0.7601 -0.03783  0.0276
#> trt1-trt3  0.035325 0.0167  2.1151 0.0344  0.00259  0.0681
#> trt1-trt4 -0.005412 0.0167 -0.3241 0.7459 -0.03815  0.0273
#> trt1-trt5  0.036775 0.0167  2.2019 0.0277  0.00404  0.0695
#> trt2-trt3  0.040425 0.0167  2.4204 0.0155  0.00769  0.0732
#> trt2-trt4 -0.000312 0.0167 -0.0187 0.9851 -0.03305  0.0324
#> trt2-trt5  0.041875 0.0167  2.5073 0.0122  0.00914  0.0746
#> trt3-trt4 -0.040737 0.0167 -2.4392 0.0147 -0.07347 -0.0080
#> trt3-trt5  0.001450 0.0167  0.0868 0.9308 -0.03128  0.0342
#> trt4-trt5  0.042187 0.0167  2.5260 0.0115  0.00945  0.0749
#> 
#> $FRRC$ciAvgRdrEachTrt
#>      Estimate StdErr  DF CILower CIUpper
#> trt1    0.845 0.0183 199   0.809   0.881
#> trt2    0.850 0.0197 199   0.812   0.889
#> trt3    0.810 0.0201 199   0.770   0.849
#> trt4    0.851 0.0186 199   0.814   0.887
#> trt5    0.808 0.0197 199   0.770   0.847
#> 
#> $FRRC$ciDiffTrtEachRdr
#>                 Estimate StdErr       z   PrGTz  CILower CIUpper
#> rdr1::trt1-trt2  0.04000 0.0308  1.2989 0.19400 -0.02036  0.1004
#> rdr1::trt1-trt3  0.09130 0.0308  2.9646 0.00303  0.03094  0.1517
#> rdr1::trt1-trt4  0.00190 0.0308  0.0617 0.95081 -0.05846  0.0623
#> rdr1::trt1-trt5  0.06285 0.0308  2.0408 0.04127  0.00249  0.1232
#> rdr1::trt2-trt3  0.05130 0.0308  1.6658 0.09576 -0.00906  0.1117
#> rdr1::trt2-trt4 -0.03810 0.0308 -1.2372 0.21603 -0.09846  0.0223
#> rdr1::trt2-trt5  0.02285 0.0308  0.7420 0.45811 -0.03751  0.0832
#> rdr1::trt3-trt4 -0.08940 0.0308 -2.9029 0.00370 -0.14976 -0.0290
#> rdr1::trt3-trt5 -0.02845 0.0308 -0.9238 0.35559 -0.08881  0.0319
#> rdr1::trt4-trt5  0.06095 0.0308  1.9791 0.04780  0.00059  0.1213
#> rdr2::trt1-trt2 -0.04650 0.0309 -1.5039 0.13260 -0.10710  0.0141
#> rdr2::trt1-trt3 -0.01815 0.0309 -0.5870 0.55719 -0.07875  0.0424
#> rdr2::trt1-trt4 -0.03330 0.0309 -1.0770 0.28147 -0.09390  0.0273
#> rdr2::trt1-trt5  0.02520 0.0309  0.8150 0.41505 -0.03540  0.0858
#> rdr2::trt2-trt3  0.02835 0.0309  0.9169 0.35918 -0.03225  0.0889
#> rdr2::trt2-trt4  0.01320 0.0309  0.4269 0.66943 -0.04740  0.0738
#> rdr2::trt2-trt5  0.07170 0.0309  2.3190 0.02040  0.01110  0.1323
#> rdr2::trt3-trt4 -0.01515 0.0309 -0.4900 0.62414 -0.07575  0.0454
#> rdr2::trt3-trt5  0.04335 0.0309  1.4021 0.16090 -0.01725  0.1039
#> rdr2::trt4-trt5  0.05850 0.0309  1.8921 0.05848 -0.00210  0.1191
#> rdr3::trt1-trt2 -0.00875 0.0362 -0.2418 0.80896 -0.07969  0.0622
#> rdr3::trt1-trt3  0.05900 0.0362  1.6302 0.10307 -0.01194  0.1299
#> rdr3::trt1-trt4  0.02310 0.0362  0.6383 0.52331 -0.04784  0.0940
#> rdr3::trt1-trt5  0.04060 0.0362  1.1218 0.26196 -0.03034  0.1115
#> rdr3::trt2-trt3  0.06775 0.0362  1.8719 0.06122 -0.00319  0.1387
#> rdr3::trt2-trt4  0.03185 0.0362  0.8800 0.37885 -0.03909  0.1028
#> rdr3::trt2-trt5  0.04935 0.0362  1.3635 0.17271 -0.02159  0.1203
#> rdr3::trt3-trt4 -0.03590 0.0362 -0.9919 0.32124 -0.10684  0.0350
#> rdr3::trt3-trt5 -0.01840 0.0362 -0.5084 0.61118 -0.08934  0.0525
#> rdr3::trt4-trt5  0.01750 0.0362  0.4835 0.62872 -0.05344  0.0884
#> rdr4::trt1-trt2 -0.00515 0.0272 -0.1893 0.84987 -0.05848  0.0482
#> rdr4::trt1-trt3  0.00915 0.0272  0.3363 0.73664 -0.04418  0.0625
#> rdr4::trt1-trt4 -0.01335 0.0272 -0.4907 0.62366 -0.06668  0.0400
#> rdr4::trt1-trt5  0.01845 0.0272  0.6781 0.49770 -0.03488  0.0718
#> rdr4::trt2-trt3  0.01430 0.0272  0.5256 0.59918 -0.03903  0.0676
#> rdr4::trt2-trt4 -0.00820 0.0272 -0.3014 0.76312 -0.06153  0.0451
#> rdr4::trt2-trt5  0.02360 0.0272  0.8674 0.38572 -0.02973  0.0769
#> rdr4::trt3-trt4 -0.02250 0.0272 -0.8270 0.40825 -0.07583  0.0308
#> rdr4::trt3-trt5  0.00930 0.0272  0.3418 0.73249 -0.04403  0.0626
#> rdr4::trt4-trt5  0.03180 0.0272  1.1688 0.24249 -0.02153  0.0851
#> 
#> $FRRC$IndividualRdrVarCov1
#>      varEachRdr cov1EachRdr
#> rdr1   0.000689    0.000215
#> rdr2   0.000824    0.000346
#> rdr3   0.001009    0.000354
#> rdr4   0.000635    0.000265
#> 
#> 
#> $RRFC
#> $RRFC$FTests
#>    DF       MS   F      p
#> T   4 0.001897 4.1 0.0253
#> TR 12 0.000462  NA     NA
#> 
#> $RRFC$ciDiffTrt
#>            Estimate StdErr DF       t  PrGTt  CILower  CIUpper
#> trt1-trt2 -0.005100 0.0152 12 -0.3355 0.7431 -0.03822  0.02802
#> trt1-trt3  0.035325 0.0152 12  2.3237 0.0385  0.00220  0.06845
#> trt1-trt4 -0.005412 0.0152 12 -0.3560 0.7280 -0.03854  0.02771
#> trt1-trt5  0.036775 0.0152 12  2.4191 0.0324  0.00365  0.06990
#> trt2-trt3  0.040425 0.0152 12  2.6592 0.0208  0.00730  0.07355
#> trt2-trt4 -0.000312 0.0152 12 -0.0206 0.9839 -0.03344  0.03281
#> trt2-trt5  0.041875 0.0152 12  2.7546 0.0175  0.00875  0.07500
#> trt3-trt4 -0.040737 0.0152 12 -2.6797 0.0200 -0.07386 -0.00761
#> trt3-trt5  0.001450 0.0152 12  0.0954 0.9256 -0.03167  0.03457
#> trt4-trt5  0.042187 0.0152 12  2.7751 0.0168  0.00906  0.07531
#> 
#> $RRFC$ciAvgRdrEachTrt
#>      Estimate StdErr DF CILower CIUpper
#> Trt1    0.845 0.0246  3   0.767   0.923
#> Trt2    0.850 0.0114  3   0.814   0.887
#> Trt3    0.810 0.0215  3   0.741   0.878
#> Trt4    0.851 0.0254  3   0.770   0.931
#> Trt5    0.808 0.0210  3   0.742   0.875
```

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04}

* `st2$RRRC$FTests` contains the results of the F-test.
* In this example `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st2$RRRC$ciDiffTrt` contains the confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. 

* `st2$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.
* Looking at the `Estimate` column one confirms that `trt5` has the smallest FOM while `trt4` has the highest.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04}

* `st2$FRRC$FTests` contains results of the F-tests, which in this situation is actually a chi-square test of the NH.
* Again, `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st2$FRRC$ciDiffTrt` contains confidence intervals for the inter-treatment paired difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. 

* `st2$FRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.
* The `Estimate` column confirms that `trt5` has the smallest FOM while `trt4` has the highest.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04}

* `st2$RRFC$FTests` contains the results of the F-test of the NH.
* Again, `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st2$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* The `PrGTt` column shows that six pairings are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. 

* `st2$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.
* The `Estimate` column confirms that `trt5` has the smallest FOM while `trt4` has the highest (the `Estimates` column is identical for RRRC, FRRC and RRFC analyses).

## RJafroc: dataset04, FROC {#ORApplications-dataset04-FROC-RJafroc}
* The fourth example uses `dataset04`, but this time we use the FROC data, specifically, we do not convert it to inferred-ROC. 
* Since this is an FROC dataset, one needs to use an FROC figure of merit. 
* In this example the weighted AFROC figure of merit `FOM = "wAFROC"` is specified. This is the recommended figure of merit when both normal and abnormal cases are present in the dataset.
* If the dataset does not contain normal cases, then the weighted AFROC1 figure of merit `FOM = "wAFROC1"` should be specified. 
* The results are contained in `st3`. 
* As noted earlier, this time the object is listed in its entirety.


```r
ds <- dataset04 # do NOT convert to ROC
FOM <- "wAFROC" 
st3 <- StSignificanceTesting(ds, FOM = FOM, method = "OR")
print(st3, digits = 3)
#> $FOMs
#> $FOMs$foms
#>       rdr1  rdr3  rdr4  rdr5
#> trt1 0.779 0.725 0.704 0.805
#> trt2 0.787 0.727 0.723 0.804
#> trt3 0.730 0.716 0.672 0.773
#> trt4 0.810 0.743 0.694 0.829
#> trt5 0.749 0.682 0.655 0.771
#> 
#> $FOMs$trtMeans
#>      Estimate
#> trt1    0.753
#> trt2    0.760
#> trt3    0.723
#> trt4    0.769
#> trt5    0.714
#> 
#> $FOMs$trtMeanDiffs
#>           Estimate
#> trt1-trt2 -0.00686
#> trt1-trt3  0.03061
#> trt1-trt4 -0.01604
#> trt1-trt5  0.03884
#> trt2-trt3  0.03747
#> trt2-trt4 -0.00918
#> trt2-trt5  0.04570
#> trt3-trt4 -0.04665
#> trt3-trt5  0.00823
#> trt4-trt5  0.05488
#> 
#> 
#> $ANOVA
#> $ANOVA$TRanova
#>         SS DF      MS
#> T  0.00927  4 0.00232
#> R  0.03540  3 0.01180
#> TR 0.00204 12 0.00017
#> 
#> $ANOVA$VarCom
#>       Estimates  Rhos
#> VarR   0.002209    NA
#> VarTR -0.000305    NA
#> Cov1   0.000422 0.455
#> Cov2   0.000336 0.362
#> Cov3   0.000304 0.328
#> Var    0.000928    NA
#> 
#> $ANOVA$IndividualTrt
#>      DF msREachTrt varEachTrt cov2EachTrt
#> trt1  3    0.00221   0.000877    0.000333
#> trt2  3    0.00171   0.000939    0.000380
#> trt3  3    0.00171   0.000970    0.000297
#> trt4  3    0.00386   0.000859    0.000311
#> trt5  3    0.00298   0.000995    0.000359
#> 
#> $ANOVA$IndividualRdr
#>      DF msTEachRdr varEachRdr cov1EachRdr
#> rdr1  4   0.001014   0.000883    0.000412
#> rdr3  4   0.000509   0.000897    0.000436
#> rdr4  4   0.000698   0.001171    0.000495
#> rdr5  4   0.000604   0.000762    0.000345
#> 
#> 
#> $RRRC
#> $RRRC$FTests
#>             DF       MS FStat        p
#> Treatment  4.0 0.002317   7.8 0.000117
#> Error     36.8 0.000297    NA       NA
#> 
#> $RRRC$ciDiffTrt
#>           Estimate StdErr   DF      t    PrGTt  CILower  CIUpper
#> trt1-trt2 -0.00686 0.0122 36.8 -0.563 5.77e-01 -0.03155  0.01784
#> trt1-trt3  0.03061 0.0122 36.8  2.512 1.65e-02  0.00592  0.05531
#> trt1-trt4 -0.01604 0.0122 36.8 -1.316 1.96e-01 -0.04073  0.00866
#> trt1-trt5  0.03884 0.0122 36.8  3.188 2.92e-03  0.01415  0.06354
#> trt2-trt3  0.03747 0.0122 36.8  3.075 3.96e-03  0.01278  0.06217
#> trt2-trt4 -0.00918 0.0122 36.8 -0.753 4.56e-01 -0.03387  0.01552
#> trt2-trt5  0.04570 0.0122 36.8  3.750 6.07e-04  0.02100  0.07040
#> trt3-trt4 -0.04665 0.0122 36.8 -3.828 4.85e-04 -0.07135 -0.02195
#> trt3-trt5  0.00823 0.0122 36.8  0.675 5.04e-01 -0.01647  0.03292
#> trt4-trt5  0.05488 0.0122 36.8  4.504 6.52e-05  0.03018  0.07957
#> 
#> $RRRC$ciAvgRdrEachTrt
#>      Estimate StdErr    DF CILower CIUpper     Cov2
#> trt1    0.753 0.0298  7.71   0.684   0.822 0.000333
#> trt2    0.760 0.0284 10.69   0.697   0.823 0.000380
#> trt3    0.723 0.0269  8.62   0.661   0.784 0.000297
#> trt4    0.769 0.0357  5.24   0.679   0.860 0.000311
#> trt5    0.714 0.0333  6.59   0.635   0.794 0.000359
#> 
#> 
#> $FRRC
#> $FRRC$FTests
#>                 MS Chisq DF       p
#> Treatment 0.002317  15.4  4 0.00393
#> Error     0.000602    NA NA      NA
#> 
#> $FRRC$ciDiffTrt
#>           Estimate StdErr      z   PrGTz  CILower CIUpper
#> trt1-trt2 -0.00686 0.0173 -0.395 0.69260 -0.04085  0.0271
#> trt1-trt3  0.03061 0.0173  1.765 0.07753 -0.00338  0.0646
#> trt1-trt4 -0.01604 0.0173 -0.925 0.35518 -0.05003  0.0180
#> trt1-trt5  0.03884 0.0173  2.240 0.02511  0.00485  0.0728
#> trt2-trt3  0.03747 0.0173  2.161 0.03073  0.00348  0.0715
#> trt2-trt4 -0.00918 0.0173 -0.529 0.59662 -0.04317  0.0248
#> trt2-trt5  0.04570 0.0173  2.635 0.00841  0.01171  0.0797
#> trt3-trt4 -0.04665 0.0173 -2.690 0.00715 -0.08064 -0.0127
#> trt3-trt5  0.00823 0.0173  0.474 0.63515 -0.02576  0.0422
#> trt4-trt5  0.05488 0.0173  3.164 0.00155  0.02089  0.0889
#> 
#> $FRRC$ciAvgRdrEachTrt
#>      Estimate StdErr  DF CILower CIUpper
#> trt1    0.753 0.0217 199   0.711   0.796
#> trt2    0.760 0.0228 199   0.715   0.805
#> trt3    0.723 0.0216 199   0.680   0.765
#> trt4    0.769 0.0212 199   0.728   0.811
#> trt5    0.714 0.0228 199   0.670   0.759
#> 
#> $FRRC$ciDiffTrtEachRdr
#>                 Estimate StdErr       z   PrGTz  CILower   CIUpper
#> rdr1::trt1-trt2 -0.00773 0.0307 -0.2520 0.80105 -0.06788  0.052416
#> rdr1::trt1-trt3  0.04957 0.0307  1.6154 0.10622 -0.01057  0.109724
#> rdr1::trt1-trt4 -0.03087 0.0307 -1.0058 0.31451 -0.09102  0.029282
#> rdr1::trt1-trt5  0.03047 0.0307  0.9928 0.32083 -0.02968  0.090616
#> rdr1::trt2-trt3  0.05731 0.0307  1.8674 0.06185 -0.00284  0.117457
#> rdr1::trt2-trt4 -0.02313 0.0307 -0.7538 0.45097 -0.08328  0.037016
#> rdr1::trt2-trt5  0.03820 0.0307  1.2448 0.21322 -0.02195  0.098349
#> rdr1::trt3-trt4 -0.08044 0.0307 -2.6212 0.00876 -0.14059 -0.020293
#> rdr1::trt3-trt5 -0.01911 0.0307 -0.6226 0.53352 -0.07926  0.041041
#> rdr1::trt4-trt5  0.06133 0.0307  1.9986 0.04566  0.00118  0.121482
#> rdr3::trt1-trt2 -0.00201 0.0304 -0.0661 0.94726 -0.06152  0.057504
#> rdr3::trt1-trt3  0.00913 0.0304  0.3008 0.76357 -0.05038  0.068646
#> rdr3::trt1-trt4 -0.01822 0.0304 -0.6002 0.54836 -0.07774  0.041287
#> rdr3::trt1-trt5  0.04262 0.0304  1.4035 0.16046 -0.01690  0.102129
#> rdr3::trt2-trt3  0.01114 0.0304  0.3669 0.71367 -0.04837  0.070654
#> rdr3::trt2-trt4 -0.01622 0.0304 -0.5341 0.59329 -0.07573  0.043296
#> rdr3::trt2-trt5  0.04462 0.0304  1.4697 0.14165 -0.01489  0.104137
#> rdr3::trt3-trt4 -0.02736 0.0304 -0.9010 0.36758 -0.08687  0.032154
#> rdr3::trt3-trt5  0.03348 0.0304  1.1027 0.27014 -0.02603  0.092996
#> rdr3::trt4-trt5  0.06084 0.0304  2.0037 0.04510  0.00133  0.120354
#> rdr4::trt1-trt2 -0.01899 0.0368 -0.5166 0.60543 -0.09104  0.053061
#> rdr4::trt1-trt3  0.03132 0.0368  0.8519 0.39429 -0.04074  0.103370
#> rdr4::trt1-trt4  0.00927 0.0368  0.2521 0.80099 -0.06279  0.081320
#> rdr4::trt1-trt5  0.04845 0.0368  1.3179 0.18753 -0.02360  0.120503
#> rdr4::trt2-trt3  0.05031 0.0368  1.3685 0.17116 -0.02174  0.122361
#> rdr4::trt2-trt4  0.02826 0.0368  0.7687 0.44209 -0.04379  0.100311
#> rdr4::trt2-trt5  0.06744 0.0368  1.8345 0.06658 -0.00461  0.139495
#> rdr4::trt3-trt4 -0.02205 0.0368 -0.5998 0.54864 -0.09410  0.050003
#> rdr4::trt3-trt5  0.01713 0.0368  0.4661 0.64118 -0.05492  0.089186
#> rdr4::trt4-trt5  0.03918 0.0368  1.0659 0.28649 -0.03287  0.111236
#> rdr5::trt1-trt2  0.00131 0.0289  0.0453 0.96385 -0.05526  0.057881
#> rdr5::trt1-trt3  0.03243 0.0289  1.1237 0.26116 -0.02414  0.089006
#> rdr5::trt1-trt4 -0.02432 0.0289 -0.8425 0.39953 -0.08089  0.032256
#> rdr5::trt1-trt5  0.03384 0.0289  1.1724 0.24102 -0.02273  0.090414
#> rdr5::trt2-trt3  0.03112 0.0289  1.0783 0.28089 -0.02545  0.087698
#> rdr5::trt2-trt4 -0.02563 0.0289 -0.8878 0.37466 -0.08220  0.030948
#> rdr5::trt2-trt5  0.03253 0.0289  1.1271 0.25969 -0.02404  0.089106
#> rdr5::trt3-trt4 -0.05675 0.0289 -1.9661 0.04929 -0.11332 -0.000177
#> rdr5::trt3-trt5  0.00141 0.0289  0.0488 0.96109 -0.05516  0.057981
#> rdr5::trt4-trt5  0.05816 0.0289  2.0149 0.04391  0.00159  0.114731
#> 
#> $FRRC$IndividualRdrVarCov1
#>      varEachRdr cov1EachRdr
#> rdr1   0.000883    0.000412
#> rdr3   0.000897    0.000436
#> rdr4   0.001171    0.000495
#> rdr5   0.000762    0.000345
#> 
#> 
#> $RRFC
#> $RRFC$FTests
#>    DF      MS    F        p
#> T   4 0.00232 13.7 0.000202
#> TR 12 0.00017   NA       NA
#> 
#> $RRFC$ciDiffTrt
#>           Estimate  StdErr DF      t    PrGTt CILower  CIUpper
#> trt1-trt2 -0.00686 0.00921 12 -0.745 4.71e-01 -0.0269  0.01321
#> trt1-trt3  0.03061 0.00921 12  3.324 6.06e-03  0.0106  0.05068
#> trt1-trt4 -0.01604 0.00921 12 -1.741 1.07e-01 -0.0361  0.00403
#> trt1-trt5  0.03884 0.00921 12  4.218 1.19e-03  0.0188  0.05891
#> trt2-trt3  0.03747 0.00921 12  4.069 1.56e-03  0.0174  0.05754
#> trt2-trt4 -0.00918 0.00921 12 -0.997 3.39e-01 -0.0292  0.01089
#> trt2-trt5  0.04570 0.00921 12  4.963 3.29e-04  0.0256  0.06576
#> trt3-trt4 -0.04665 0.00921 12 -5.066 2.77e-04 -0.0667 -0.02659
#> trt3-trt5  0.00823 0.00921 12  0.894 3.89e-01 -0.0118  0.02829
#> trt4-trt5  0.05488 0.00921 12  5.959 6.62e-05  0.0348  0.07494
#> 
#> $RRFC$ciAvgRdrEachTrt
#>      Estimate StdErr DF CILower CIUpper
#> Trt1    0.753 0.0235  3   0.678   0.828
#> Trt2    0.760 0.0207  3   0.694   0.826
#> Trt3    0.723 0.0207  3   0.657   0.788
#> Trt4    0.769 0.0311  3   0.670   0.868
#> Trt5    0.714 0.0273  3   0.627   0.801
```

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04-FROC}

* `st3$RRRC$FTests` contains the results of the F-tests.
* The p-value is much smaller than that obtained after converting to an ROC dataset. Specifically, for FROC analysis, the p-value is \ensuremath{1.17105004\times 10^{-4}} while that for ROC analysis is 0.03054456. The F-statistic and the `ddf` are both larger for FROC analysis, both of of which result in increased probability of rejecting the NH, i.e., FROC analysis has greater power than ROC analysis.
* The increased power of FROC analysis has been confirmed in simulation studies [@RN1331].

* `st3$RRRC$ciDiffTrt` contains the confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. The findings are consistent with the prior ROC analysis, the difference being the smaller p-values. 

* `st3$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.
* Looking at the `Estimate` column one confirms that `trt5` has the smallest FOM while `trt4` has the highest (the `Estimates` column is identical for RRRC, FRRC and RRFC analyses).

* `st3$RRRC$st1$RRRC$ciDiffTrtEachRdr` contains confidence intervals for inter-treatment difference FOMs, for each reader, i.e., $CI_{1-\alpha,RRRC,\theta_{i j} - \theta_{i' j}}$.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04-FROC}

* `st3$FRRC$FTests` contains results of the F-test of the NH.
* Again, `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st3$FRRC$ciDiffTrt` contains the confidence intervals for the inter-treatment paired difference FOMs averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. The findings are consistent with the prior ROC analysis, the difference being the smaller p-values. 

* `st3$FRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.
* Looking at the `Estimate` column one confirms that `trt5` has the smallest FOM while `trt4` has the highest.

* `st3$FRRC$st1$FRRC$ciDiffTrtEachRdr` contains confidence intervals for inter-treatment difference FOMs, for each reader, i.e., $CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}}$.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04-FROC}

* `st3$RRFC$FTests` contains results of the F-test of the NH.
* Again, `ndf` = 4 because there are I = 5 treatments. Since the p-value is less than 0.05, at least one treatment-pairing FOM difference is significantly different from zero.

* `st3$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.

* `st3$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.
* The `Estimate` column confirms that `trt5` has the smallest FOM while `trt4` has the highest (the `Estimates` column is identical for RRRC, FRRC and RRFC analyses).

## RJafroc: dataset04, FROC/DBM {#ORApplications-dataset04-FROC-DBM-RJafroc}
* The fourth example again uses `dataset04`, i.e., FROC data, *but this time using DBM analysis*.
* The key difference below is in the call to `StSignificanceTesting()` function, where we set `method = "DBM"`.
* Since DBM analysis is pseudovalue based, and the figure of merit is not the empirical AUC under the ROC, one expects to see differences from the previously presented OR analysis, contained in `st3`.


```r
st4 <- StSignificanceTesting(ds, FOM = FOM, method = "DBM") 
# Note: using DBM analysis
print(st4, digits = 3)
#> $FOMs
#> $FOMs$foms
#>       rdr1  rdr3  rdr4  rdr5
#> trt1 0.779 0.725 0.704 0.805
#> trt2 0.787 0.727 0.723 0.804
#> trt3 0.730 0.716 0.672 0.773
#> trt4 0.810 0.743 0.694 0.829
#> trt5 0.749 0.682 0.655 0.771
#> 
#> $FOMs$trtMeans
#>      Estimate
#> trt1    0.753
#> trt2    0.760
#> trt3    0.723
#> trt4    0.769
#> trt5    0.714
#> 
#> $FOMs$trtMeanDiffs
#>           Estimate
#> trt1-trt2 -0.00686
#> trt1-trt3  0.03061
#> trt1-trt4 -0.01604
#> trt1-trt5  0.03884
#> trt2-trt3  0.03747
#> trt2-trt4 -0.00918
#> trt2-trt5  0.04570
#> trt3-trt4 -0.04665
#> trt3-trt5  0.00823
#> trt4-trt5  0.05488
#> 
#> 
#> $ANOVA
#> $ANOVA$TRCanova
#>            SS   DF     MS
#> T       1.853    4 0.4633
#> R       7.081    3 2.3603
#> C     289.602  199 1.4553
#> TR      0.407   12 0.0339
#> TC     95.772  796 0.1203
#> RC    126.902  597 0.2126
#> TRC   226.479 2388 0.0948
#> Total 748.096 3999     NA
#> 
#> $ANOVA$VarCom
#>        Estimates
#> VarR    0.002209
#> VarC    0.060862
#> VarTR  -0.000305
#> VarTC   0.006369
#> VarRC   0.023545
#> VarErr  0.094841
#> 
#> $ANOVA$IndividualTrt
#>       DF  Trt1  Trt2  Trt3  Trt4  Trt5
#> msR    3 0.442 0.343 0.342 0.772 0.597
#> msC  199 0.375 0.416 0.372 0.358 0.415
#> msRC 597 0.109 0.112 0.134 0.110 0.127
#> 
#> $ANOVA$IndividualRdr
#>       DF   rdr1   rdr3  rdr4   rdr5
#> msT    4 0.2027 0.1019 0.140 0.1208
#> msC  199 0.5064 0.5278 0.630 0.4285
#> msTC 796 0.0942 0.0922 0.135 0.0833
#> 
#> 
#> $RRRC
#> $RRRC$FTests
#>             DF     MS FStat        p
#> Treatment  4.0 0.4633   7.8 0.000117
#> Error     36.8 0.0594    NA       NA
#> 
#> $RRRC$ciDiffTrt
#>           Estimate StdErr   DF      t    PrGTt  CILower  CIUpper
#> trt1-trt2 -0.00686 0.0122 36.8 -0.563 5.77e-01 -0.03155  0.01784
#> trt1-trt3  0.03061 0.0122 36.8  2.512 1.65e-02  0.00592  0.05531
#> trt1-trt4 -0.01604 0.0122 36.8 -1.316 1.96e-01 -0.04073  0.00866
#> trt1-trt5  0.03884 0.0122 36.8  3.188 2.92e-03  0.01415  0.06354
#> trt2-trt3  0.03747 0.0122 36.8  3.075 3.96e-03  0.01278  0.06217
#> trt2-trt4 -0.00918 0.0122 36.8 -0.753 4.56e-01 -0.03387  0.01552
#> trt2-trt5  0.04570 0.0122 36.8  3.750 6.07e-04  0.02100  0.07040
#> trt3-trt4 -0.04665 0.0122 36.8 -3.828 4.85e-04 -0.07135 -0.02195
#> trt3-trt5  0.00823 0.0122 36.8  0.675 5.04e-01 -0.01647  0.03292
#> trt4-trt5  0.05488 0.0122 36.8  4.504 6.52e-05  0.03018  0.07957
#> 
#> $RRRC$ciAvgRdrEachTrt
#>      Estimate StdErr    DF CILower CIUpper
#> trt1    0.753 0.0298  7.71   0.684   0.822
#> trt2    0.760 0.0284 10.69   0.697   0.823
#> trt3    0.723 0.0269  8.62   0.661   0.784
#> trt4    0.769 0.0357  5.24   0.679   0.860
#> trt5    0.714 0.0333  6.59   0.635   0.794
#> 
#> 
#> $FRRC
#> $FRRC$FTests
#>            DF    MS FStat       p
#> Treatment   4 0.463  3.85 0.00416
#> Error     796 0.120    NA      NA
#> 
#> $FRRC$ciDiffTrt
#>           Estimate StdErr  DF      t   PrGTt  CILower CIUpper
#> trt1-trt2 -0.00686 0.0173 796 -0.395 0.69271 -0.04090  0.0272
#> trt1-trt3  0.03061 0.0173 796  1.765 0.07791 -0.00343  0.0647
#> trt1-trt4 -0.01604 0.0173 796 -0.925 0.35546 -0.05008  0.0180
#> trt1-trt5  0.03884 0.0173 796  2.240 0.02539  0.00480  0.0729
#> trt2-trt3  0.03747 0.0173 796  2.161 0.03103  0.00343  0.0715
#> trt2-trt4 -0.00918 0.0173 796 -0.529 0.59677 -0.04322  0.0249
#> trt2-trt5  0.04570 0.0173 796  2.635 0.00858  0.01166  0.0797
#> trt3-trt4 -0.04665 0.0173 796 -2.690 0.00730 -0.08069 -0.0126
#> trt3-trt5  0.00823 0.0173 796  0.474 0.63528 -0.02581  0.0423
#> trt4-trt5  0.05488 0.0173 796  3.164 0.00161  0.02084  0.0889
#> 
#> $FRRC$ciAvgRdrEachTrt
#>      Estimate StdErr  DF CILower CIUpper
#> trt1    0.753 0.0217 199   0.711   0.796
#> trt2    0.760 0.0228 199   0.715   0.805
#> trt3    0.723 0.0216 199   0.680   0.765
#> trt4    0.769 0.0212 199   0.728   0.811
#> trt5    0.714 0.0228 199   0.669   0.759
#> 
#> $FRRC$ciDiffTrtEachRdr
#>                 Estimate StdErr  DF       t   PrGTt   CILower   CIUpper
#> rdr1::trt1-trt2 -0.00773 0.0307 199 -0.2520 0.80131 -0.068250  0.052784
#> rdr1::trt1-trt3  0.04957 0.0307 199  1.6154 0.10781 -0.010942  0.110092
#> rdr1::trt1-trt4 -0.03087 0.0307 199 -1.0058 0.31573 -0.091384  0.029650
#> rdr1::trt1-trt5  0.03047 0.0307 199  0.9928 0.32203 -0.030050  0.090984
#> rdr1::trt2-trt3  0.05731 0.0307 199  1.8674 0.06332 -0.003209  0.117825
#> rdr1::trt2-trt4 -0.02313 0.0307 199 -0.7538 0.45186 -0.083650  0.037384
#> rdr1::trt2-trt5  0.03820 0.0307 199  1.2448 0.21469 -0.022317  0.098717
#> rdr1::trt3-trt4 -0.08044 0.0307 199 -2.6212 0.00944 -0.140959 -0.019925
#> rdr1::trt3-trt5 -0.01911 0.0307 199 -0.6226 0.53423 -0.079625  0.041409
#> rdr1::trt4-trt5  0.06133 0.0307 199  1.9986 0.04702  0.000816  0.121850
#> rdr3::trt1-trt2 -0.00201 0.0304 199 -0.0661 0.94733 -0.061885  0.057868
#> rdr3::trt1-trt3  0.00913 0.0304 199  0.3008 0.76389 -0.050743  0.069010
#> rdr3::trt1-trt4 -0.01822 0.0304 199 -0.6002 0.54904 -0.078102  0.041652
#> rdr3::trt1-trt5  0.04262 0.0304 199  1.4035 0.16202 -0.017260  0.102493
#> rdr3::trt2-trt3  0.01114 0.0304 199  0.3669 0.71406 -0.048735  0.071018
#> rdr3::trt2-trt4 -0.01622 0.0304 199 -0.5341 0.59389 -0.076093  0.043660
#> rdr3::trt2-trt5  0.04462 0.0304 199  1.4697 0.14323 -0.015252  0.104502
#> rdr3::trt3-trt4 -0.02736 0.0304 199 -0.9010 0.36867 -0.087235  0.032518
#> rdr3::trt3-trt5  0.03348 0.0304 199  1.1027 0.27148 -0.026393  0.093360
#> rdr3::trt4-trt5  0.06084 0.0304 199  2.0037 0.04645  0.000965  0.120718
#> rdr4::trt1-trt2 -0.01899 0.0368 199 -0.5166 0.60600 -0.091485  0.053502
#> rdr4::trt1-trt3  0.03132 0.0368 199  0.8519 0.39531 -0.041177  0.103810
#> rdr4::trt1-trt4  0.00927 0.0368 199  0.2521 0.80125 -0.063227  0.081760
#> rdr4::trt1-trt5  0.04845 0.0368 199  1.3179 0.18904 -0.024044  0.120944
#> rdr4::trt2-trt3  0.05031 0.0368 199  1.3685 0.17271 -0.022185  0.122802
#> rdr4::trt2-trt4  0.02826 0.0368 199  0.7687 0.44300 -0.044235  0.100752
#> rdr4::trt2-trt5  0.06744 0.0368 199  1.8345 0.06807 -0.005052  0.139935
#> rdr4::trt3-trt4 -0.02205 0.0368 199 -0.5998 0.54932 -0.094544  0.050444
#> rdr4::trt3-trt5  0.01713 0.0368 199  0.4661 0.64168 -0.055360  0.089627
#> rdr4::trt4-trt5  0.03918 0.0368 199  1.0659 0.28778 -0.033310  0.111677
#> rdr5::trt1-trt2  0.00131 0.0289 199  0.0453 0.96389 -0.055610  0.058227
#> rdr5::trt1-trt3  0.03243 0.0289 199  1.1237 0.26251 -0.024485  0.089352
#> rdr5::trt1-trt4 -0.02432 0.0289 199 -0.8425 0.40055 -0.081235  0.032602
#> rdr5::trt1-trt5  0.03384 0.0289 199  1.1724 0.24242 -0.023077  0.090760
#> rdr5::trt2-trt3  0.03112 0.0289 199  1.0783 0.28219 -0.025794  0.088044
#> rdr5::trt2-trt4 -0.02563 0.0289 199 -0.8878 0.37573 -0.082544  0.031294
#> rdr5::trt2-trt5  0.03253 0.0289 199  1.1271 0.26105 -0.024385  0.089452
#> rdr5::trt3-trt4 -0.05675 0.0289 199 -1.9661 0.05068 -0.113669  0.000169
#> rdr5::trt3-trt5  0.00141 0.0289 199  0.0488 0.96113 -0.055510  0.058327
#> rdr5::trt4-trt5  0.05816 0.0289 199  2.0149 0.04526  0.001240  0.115077
#> 
#> 
#> $RRFC
#> $RRFC$FTests
#>           DF     MS FStat        p
#> Treatment  4 0.4633  13.7 0.000202
#> Error     12 0.0339    NA       NA
#> 
#> $RRFC$ciDiffTrt
#>           Estimate  StdErr DF      t    PrGTt CILower  CIUpper
#> trt1-trt2 -0.00686 0.00921 12 -0.745 4.71e-01 -0.0269  0.01321
#> trt1-trt3  0.03061 0.00921 12  3.324 6.06e-03  0.0106  0.05068
#> trt1-trt4 -0.01604 0.00921 12 -1.741 1.07e-01 -0.0361  0.00403
#> trt1-trt5  0.03884 0.00921 12  4.218 1.19e-03  0.0188  0.05891
#> trt2-trt3  0.03747 0.00921 12  4.069 1.56e-03  0.0174  0.05754
#> trt2-trt4 -0.00918 0.00921 12 -0.997 3.39e-01 -0.0292  0.01089
#> trt2-trt5  0.04570 0.00921 12  4.963 3.29e-04  0.0256  0.06576
#> trt3-trt4 -0.04665 0.00921 12 -5.066 2.77e-04 -0.0667 -0.02659
#> trt3-trt5  0.00823 0.00921 12  0.894 3.89e-01 -0.0118  0.02829
#> trt4-trt5  0.05488 0.00921 12  5.959 6.62e-05  0.0348  0.07494
#> 
#> $RRFC$ciAvgRdrEachTrt
#>      Estimate StdErr DF CILower CIUpper
#> trt1    0.753 0.0235  3   0.678   0.828
#> trt2    0.760 0.0207  3   0.694   0.826
#> trt3    0.723 0.0207  3   0.657   0.788
#> trt4    0.769 0.0311  3   0.670   0.868
#> trt5    0.714 0.0273  3   0.627   0.801
```

### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04-FROC-DBM}

* `st4$RRRC$FTests` contains the results of the F-test of the NH.

* `st4$RRRC$ciDiffTrt` contains the confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.

* `st4$RRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRRC,\theta_{i \bullet}}$.

### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04-FROC-DBM}

* `st4$FRRC$FTests` contains results of the F-test of the NH, which is actually a chi-square statistic.

* `st4$FRRC$ciDiffTrt` contains confidence intervals for the inter-treatment difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet} - \theta_{i' \bullet}}$.
* With I = 5 treatments there are 10 distinct treatment-pairings. 
* Looking at the `PrGTt` (for probability greater than `t`) column, one finds six pairings that are significant: `trt1-trt3`, `trt1-trt5`, etc. The smallest p-value is for the `trt4-trt5` pairing. The findings are consistent with the prior ROC analysis, the difference being the smaller p-values. 

* `st4$FRRC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,FRRC,\theta_{i \bullet}}$.

* `st4$FRRC$ciDiffTrtEachRdr` contains confidence intervals for inter-treatment difference FOMs, for each reader, i.e., $CI_{1-\alpha,FRRC,\theta_{i j} - \theta_{i' j}}$.

### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04-FROC-DBM}

* `st4$RRFC$FTests` contains the results of the F-test of the NH.

* `st4$RRFC$ciDiffTrt` contains confidence intervals for the inter-treatment paired difference FOMs, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet} - \theta_{i' \bullet}}$.

* `st4$RRFC$ciAvgRdrEachTrt` contains confidence intervals for each treatment, averaged over readers, i.e., $CI_{1-\alpha,RRFC,\theta_{i \bullet}}$.
* The `Estimate` column confirms that `trt5` has the smallest FOM while `trt4` has the highest (the `Estimates` column is identical for RRRC, FRRC and RRFC analyses).


## Summary{#ORApplications-Summary}
## Discussion{#ORApplications-Discussion}
## Tentative {#ToMullOver1-tentative}


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
st5 <- StSignificanceTesting(ds, FOM = FOM, method = "OR")
print(st5, digits = 4)
```

A comparison was run between results of OR and DBM for the FROC dataset. Except for `FRRC`, where differences are expected (because `ddf` in the former is $\infty$, while that in the later is $(I-1)\times(J-1))$, the results for the p-values were identical. This was true for the following FOMs: `wAFROC`, with equal and unequal weights, and `MaxLLF`. The confidence intervals (again, excluding `FRRC`) were identical for `FOM` = `wAFROC`. Slight differences were observed for `FOM` = `MaxLLF`.  

## References {#ORApplications-references}


<!--chapter:end:10C-OR-AnalysisApplications.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Sample size estimation for ROC studies DBM method {#RocSampleSizeDBM}



## Introduction {#RocSampleSizeDBM-introduction}
The question addressed here is "how many readers and cases", usually abbreviated to "sample-size", should one employ to conduct a "well-planned" ROC study. The reasons for the quotes around "well-planned" will shortly become clear. If cost were no concern, the reply would be: "as many readers and cases as one can get". There are other causes affecting sample-size, e.g., the data collection paradigm and analysis, however, this chapter is restricted to the MRMC ROC data collection paradigm, with data analyzed by the DBM method described in a previous chapter. The next chapter will deal with data analyzed by the OR method.

It turns out that provided one can specify conceptually valid effect-sizes between different paradigms (i.e., in the same "units"), the methods described in this chapter are extensible to other paradigms; see TBA Chapter 19 for sample size estimation for FROC studies. *For this reason it is important to understand the concepts of sample-size estimation in the simpler ROC context.*
 
For simplicity and practicality, this chapter, and the next, is restricted to analysis of two-treatment data ($I = 2$). The purpose of most imaging system assessment studies is to determine, for a given diagnostic task, whether radiologists perform better using a new treatment over the conventional treatment, and whether the difference is statistically significant. Therefore, the two-treatment case is the most common one encountered. While it is possible to extend the methods to more than two treatments, the extensions are not, in my opinion, clinically interesting. 
	
Assume the figure of merit (FOM) $\theta$ is chosen to be the area AUC under the ROC curve (empirical or fitted is immaterial as far as the formulae are concerned; however, the choice will affect statistical power). The statistical analysis determines the significance level of the study, i.e., the probability or p-value for incorrectly rejecting the null hypothesis (NH) that the two $\theta$s are equal: $NH: \theta_1 = \theta_2$, where the subscripts refer to the two treatments and the bullet represents the average over the reader index. If the p-value is smaller than a pre-specified $\alpha$, typically set at 5%, one rejects the NH and declares the treatments different at the $\alpha$ significance level. Statistical power is the probability of correctly rejecting the null hypothesis when the alternative hypothesis $AH: \theta_1 \neq  \theta_2$ is true, (TBA Chapter 08). 

The value of the *true* difference between the treatments, known as the *true effect-size* is, of course, unknown. If it were known, there would be no need to conduct the ROC study. One would simply adopt the treatment with the higher $\theta$. Sample-size estimation involves making an educated guess regarding the true effect-size , called the *anticipated effect size*, and denoted by $d$. To quote Harold Kundel [@RN1383]: "any calculation of power amounts to specification of the anticipated effect-size". Increasing the anticipated effect size  will increase statistical power but may represent an unrealistic expectation of the true difference between the treatments, in the sense that it overestimates the ability of technology to achieve this much improvement. Conversely, an unduly small $d$ might be clinically insignificant, besides requiring a very large sample-size to achieve sufficient statistical power. 

Statistical power depends on the magnitude of $d$ divided by the standard deviation $\sigma(d)$ of $d$, i.e. $D=\frac{\left | d \right |}{\sigma (d)}$. The sign is relevant as it determines whether the project is worth pursuing at all (see TBA §11.8.4). The ratio is termed [@cohen1988statistical] Cohen's D. When this signal-to-noise-ratio-like quantity is large, statistical power approaches 100%. Reader and case variability and data correlations determine $\sigma(d)$. No matter how small the anticipated $d$, as long as it is finite, then, using sufficiently large numbers of readers and cases $\sigma(d)$ can be made sufficiently small to achieve near 100% statistical power. Of course, a very small effect-size may not be clinically significant. There is a key difference between *statistical significance* and *clinical significance*. An effect-size in AUC units could be so small, e.g., 0.001, as to be clinically insignificant, but by employing a sufficiently large sample size one could design a study to detect this small - and clinically meaningless - difference with near unit probability, i.e., high statistical power.

What determines clinical significance? A small effect-size, e.g., 0.01 AUC units, could be clinically significant if it applies to a large population, where the small benefit in detection rate is amplified by the number of patients benefiting from the new treatment. In contrast, for an "orphan" disease, i.e., one with very low prevalence, an effect-size of 0.05 might not be enough to justify the additional cost of the new treatment. The improvement might have to be 0.1 before it is worth it for a new treatment to be brought to market. One hates to monetize life and death issues, but there is no getting away from it, as cost/benefit issues determine clinical significance. The arbiters of clinical significance are engineers, imaging scientists, clinicians, epidemiologists, insurance companies and those who set government health care policies. The engineers and imaging scientists determine whether the effect-size the clinicians would like is feasible from technical and scientific viewpoints. The clinician determines, based on incidence of disease and other considerations, e.g., altruistic, malpractice, cost of the new device and insurance reimbursement, what effect-size is justifiable. Cohen has suggested that d values of 0.2, 0.5, and 0.8 be considered small, medium, and large, respectively, but he has also argued against their indiscriminate usage. However, after a study is completed, clinicians often find that an effect-size that biostatisticians label as small may, in certain circumstances, be clinically significant and an effect-size that they label as large may in other circumstances be clinically insignificant. Clearly, this is a complex issue. Some suggestions on choosing a clinically significant effect size are made in (TBA §11.12).

Having developed a new imaging modality the R&D team wishes to compare it to the existing standard with the short-term goal of making a submission to the FDA to allow them to perform pre-market testing of the device. The long-term goal is to commercialize the device. Assume the R&D team has optimized the device based on physical measurements, (TBA Chapter 01), perhaps supplemented with anecdotal feedback from clinicians based on a few images. Needed at this point is a pilot study. A pilot study, conducted with a relatively small and practical sample size, is intended to provide estimates of different sources of variability and correlations. It also provides an initial estimate of the effect-size, termed the *observed effect-size*, $d$. Based on results from the pilot the sample-size tools described in this chapter permit estimation of the numbers of readers and cases that will reduce $\sigma(d)$  sufficiently to achieve the desired power for the larger "pivotal" study. [A distinction could be made in the notation between observed and anticipated effect sizes, but it will be clear from the context. Later, it will be shown how one can make an educated guess about the anticipated effect size from an observed effect size.]
  
This chapter is concerned with multiple-reader MRMC studies that follow the fully crossed factorial design meaning that each reader interprets a common case-set in all treatments. Since the resulting pairings (i.e., correlations) tend to decrease $\sigma(d)$ (since the variations occur in tandem, they tend to cancel out in the difference, see (TBA Chapter 09, Introduction), for Dr. Robert Wagner's sailboat analogy) it yields more statistical power compared to an unpaired design, and consequently this design is frequently used. Two sample-size estimation procedures for MRMC are the Hillis-Berbaum method [@RN1476] and the Obuchowski-Rockette [@RN1971] method. With recent work by Hillis, the two methods have been shown to be substantially equivalent. 

This chapter will focus on the DBM approach. Since it is based on a standard ANOVA model, it is easier to extend the NH testing procedure described in Chapter 09 to the alternative hypothesis, which is relevant for sample size estimation. [TBA Online Appendix 11.A shows how to translate the DBM formulae to the OR method [@RN2137].] 

Given an effect-size, and choosing this wisely is the most difficult part of the process, the method described in this chapter uses pseudovalue variance components estimated by the DBM method to predict sample-sizes (i.e., different combinations of numbers of readers and cases) necessary to achieve a desired power. 

## Statistical Power {#StatPower1}
The concept of statistical power was introduced in [TBA Chapter 08] but is worth repeating. There are two possible decisions following a test of a null hypothesis (NH): reject or fail to reject the NH. Each decision is associated with a probability on an erroneous conclusion. If the NH is true and one rejects it, the probability of the ensuing Type-I error is denoted $\alpha$. If the NH is false and one fails to reject it, the probability of the ensuing Type II- error is denoted $\beta$. Statistical power is the complement of $\beta$, i.e., 

\begin{equation}
Power = 1 - \beta
(\#eq:DefinitionStatPower)
\end{equation}

Typically, one aims for $\beta = 0.2$  or less, i.e., a statistical power of 80% or more. Like $\alpha$ = 0.05, this is a *convention* and more nuanced cost-benefit considerations may cause the researcher to adopt a different value.

### Observed vs. anticipated effect-size
*Assuming no other similar studies have already been conducted with the treatments in question, the observed effect-size, although "merely an estimate", is the best information available at the end of the pilot study regarding the value of the true effect-size. From the two previous chapters one knows that the significance testing software will report not only the observed effect-size, but also a 95% confidence interval associate with it. It will be shown later how one can use this information to make an educated guess regarding the value of the anticipated effect-size.*

### Dependence of statistical power on estimates of model parameters {#RocSampleSizeDBM-dependence-of-stats-power}
Examination of the expression for  , Eqn. (11.5), shows that statistical power increases if:

* The numerator is large. This occurs if: (a) the anticipated effect-size $d$ is large. Since effect-size enters as the *square*, TBA Eqn. (11.8), it is has a particularly strong effect; (b) If $J \times K$ is large. Both of these results should be obvious, as a large effect size and a large sample size should result in increased probability of rejecting the NH. 
* The denominator is small. The first term in the denominator is  $\left ( \sigma_{\epsilon}^2 + \sigma_{\tau RC}^2 \right )$. These two terms cannot be separated. This is the residual variability of the jackknife pseudovalues. It should make sense that the smaller the variability, the larger is the non-centrality parameter and the statistical power. 
* The next term in the denominator is $K\sigma_{\tau R}^2$, the treatment-reader variance component multiplied by the total number of cases. The reader variance $\sigma_{R}^2$ has no effect on statistical power, because it has an equal effect on both treatments and cancels out in the difference. Instead, it is the treatment-reader variance $\sigma_{R}^2$  that contributes "noise" tending to confound the estimate of the effect-size. 
* The variance components estimated by the ANOVA procedure are realizations of random variables and as such subject to noise (there actually exists a beast such as variance of a variance). The presence of the $K$ term, usually large, can amplify the effect of noise in the estimate of $\sigma_{R}^2$, making the sample size estimation procedure less accurate.
* The final term in the denominator is  $J\sigma_{\tau C}^2$. The variance $\sigma_{C}^2$ has no impact on statistical power, as it cancels out in the difference. The treatment-case variance component introduces "noise" into the estimate of the effect size, thereby decreasing power. Since it is multiplied by J, the number of readers, and typically $J<<K$, the error amplification effect on accuracy of the sample size estimate is not as bad as with the treatment-reader variance component.
* Accuracy of sample size estimation, essentially estimating confidence intervals for statistical power, is addressed in [@RN2027].

### Formulae for random-reader random-case (RRRC) sample size estimation {#RocSampleSizeDBM-RRRC-sample-size-estimation}


### Significance testing {#RocSampleSizeDBM-sig-testing}

### p-value and confidence interval {#RocSampleSizeDBM-pvalue-ci}

### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments {#RocSampleSizeDBM-CompareDBM2OR}
Having performed a pilot study and planning to perform a pivotal study, sample size estimation follows the following procedure, which assumes that both reader and case are treated as random factors. Different formulae, described later, apply when either reader or case is treated as a fixed factor.

* Perform DBM analysis on the pilot data. This yields the observed effect size as well as estimates of all relevant variance components and mean squares appearing in TBA Eqn. (11.5) and Eqn. (11.7).
* This is the difficult but critical part: make an educated guess regarding the effect-size, $d$, that one is interested in "detecting" (i.e., hoping to reject the NH with probability $1-\beta$). The author prefers the term "anticipated" effect-size to "true" effect-size (the latter implies knowledge of the true difference between the modalities which, as noted earlier, would obviate the need for a pivotal study). 
* Two scenarios are considered below. In the first scenario, the effect-size is assumed equal to that observed in the pilot study, i.e., $d = d_{obs}$. 
* In the second, so-called "best-case" scenario, one assumes that the anticipate value of $d$ is the observed value plus two-sigma of the confidence interval, in the correct direction, of course, i.e., $d=\left | d_{obs} \right |+2\sigma$. Here $\sigma$ is one-fourth the width of the 95% confidence interval for $d_{obs}$. Anticipating more than $2\sigma$  greater than the observed effect-size would be overly optimistic. The width of the CI implies that chances are less than 2.5% that the anticipated value is at or beyond the overly optimistic value. These points will become clearer when example datasets are analyzed below.
*	Calculate statistical power using the distribution implied by Eqn. (11.4), to calculate the probability that a random value of the relevant F-statistic will exceed the critical value, as in §11.3.2.
* If power is below the desired or "target" power, one tries successively larger value of $J$ and / or $K$ until the target power is reached. 


## Formulae for fixed-reader random-case (FRRC) sample size estimation {#RocSampleSizeDBM-FRRC-sample-size-estimation}
It was shown in TBA §9.8.2 that for fixed-reader analysis the non-centrality parameter is defined by:

\begin{equation}
\Delta=\frac{JK\sigma_{\tau}^2}{\sigma_{\epsilon}^2+\sigma_{\tau RC}^2+J\sigma_{\tau C}^2}
(\#eq:DeltaFRRC)
\end{equation}

The sampling distribution of the F-statistic under the AH is:

\begin{equation}
F_{AH|R}\equiv \frac{MST}{MSTC}\sim F_{I-1,(I-1)(K-1),\Delta}
(\#eq:SamplingFFRRC)
\end{equation}

### Formulae for random-reader fixed-case (RRFC) sample size estimation {#RocSampleSizeDBM-RRFC-sample-size-estimation}
It is shown in TBA §9.9 that for fixed-case analysis the non-centrality parameter is defined by:

\begin{equation}
\Delta=\frac{JK\sigma_{\tau}^2}{\sigma_{\epsilon}^2+\sigma_{\tau RC}^2+K\sigma_{\tau R}^2}
(\#eq:DeltaFRRFC)
\end{equation}

Under the AH, the test statistic is distributed as a non-central F-distribution as follows:

\begin{equation}
F_{AH|C}\equiv \frac{MST}{MSTR}\sim F_{I-1,(I-1)(J-1),\Delta}
(\#eq:SamplingFRRFC)
\end{equation}

### Fixed-reader random-case (FRRC) analysis TBA {#RocSampleSizeDBM-FRRCAnalysis}
It is a realization of a random variable, so one has some leeway in the choice of anticipated effect size - more on this later. 
Here $J^*$ and $K^*$ refer to the number of readers and cases in the *pilot* study. 

### Random-reader fixed-case (RRFC) analysis {#RocSampleSizeDBM-RRFCAnalysis}

### Single-treatment multiple-reader analysis {#RocSampleSizeDBM-STMRAnalysis}

## Discussion/Summary/2

## References {#RocSampleSizeDBM-references}


<!--chapter:end:11-ROCSampleSizeDBM.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Sample size estimation for ROC studies  OR method {#RocSampleSizeOR}



## Introduction {#RocSampleSizeOR-introduction}

 

## Statistical Power {#StatPower2}


\begin{equation}
Power = 1 - \beta
(\#eq:DefinitionStatPower1)
\end{equation}


### Sample size estimation for random-reader random-cases
For convenience the OR model is repeated below with the case-set index suppressed:

\begin{equation}
Y_{n(ijk)}=\mu+\tau_i+R_j+C_k+(\tau R)_{ij}+(\tau C)_{ik}+(RC)_{jk}+(\tau RC)_{ijk}+\epsilon_ {n(ijk)}
(\#eq:ORModelSsOR)
\end{equation}

As usual, the treatment effects $\tau_i$  are subject to the constraint that they sum to zero. The observed effect size (a random variable) is defined by:

\begin{equation}
d=\theta_{1\bullet}-\theta_{2\bullet}
(\#eq:EffectSize1)
\end{equation}

It is a realization of a random variable, so one has some leeway in the choice of anticipated effect size. In the significance-testing procedure described in TBA Chapter 09 interest was in the distribution of the F-statistic when the NH is true. For sample size estimation, one needs to know the distribution of the statistic when the NH is false. It was shown that then the observed F-statistic TBA Eqn. (9.35) is distributed as a non-central F-distribution  $F_{ndf,ddf,\Delta}$ with non-centrality parameter $\Delta$: 

\begin{equation}
F_{DBM|AH} \sim F_{ndf,ddf,\Delta}
(\#eq:FDBMSampling1)
\end{equation}

The non-centrality parameter   was defined, Eqn. TBA (9.34), by:

\begin{equation}
\Delta=\frac{JK\sigma_{Y;\tau}^2}{\left ( \sigma_{Y;\epsilon}^2 + \sigma_{Y;\tau RC}^2 \right )+K\sigma_{Y;\tau R}^2+J\sigma_{Y;\tau C}^2}
(\#eq:DefDelta1)
\end{equation}

To minimize confusion, this equation has been rewritten here using the subscript $Y$ to explicitly denote pseudo-value derived quantities (in TBA Chapter 09 this subscript was suppressed. 

The estimate of $\sigma_{Y;\tau C}^2$ can turn out to bee negative. To avoid a negative denominator, Hillis suggests the following modification:

\begin{equation}
\Delta=\frac{JK\sigma_{Y;\tau}^2}{\left ( \sigma_{Y;\epsilon}^2 + \sigma_{Y;\tau RC}^2 \right )+K\sigma_{Y;\tau R}^2+\max \left (J\sigma_{Y;\tau C}^2 ,0 \right )}
(\#eq:DefDeltaHillis1)
\end{equation}

This expression depends on three variance components, $(\sigma_{Y;\epsilon}^2 + \sigma_{Y;\tau RC}^2)$ - the two terms are inseparable - $\sigma_{Y;\tau R}^2$ and $\sigma_{Y;\tau C}^2$. The $ddf$ term appearing in TBA Eqn. (11.4) was defined by TBA Eqn. (9.24) - this quantity does not change between NH and AH:

\begin{equation}
ddf_H=\frac{\left [MSTR+\max(MSTR-MSTRC,0)  \right ]^2}{\frac{[MSTR]^2}{(I-1)(J-1)}}
(\#eq:ddfH1)
\end{equation}

The mean squares in this expression can be expressed in terms of the three variance-components appearing in TBA Eqn. (11.6). Hillis and Berbaum [@RN1476] have derived these expression and they will not be repeated here (Eqn. 4 in the cited reference). RJafroc implements a function to calculate the mean squares, `UtilMeanSquares()`, which allows ddf to be calculated using Eqn. TBA (11.7). The sample size functions in this package need only the three variance-components (the formula for $ddf_H$ is implemented internally). 

For two treatments, since the individual treatment effects must be the negatives of each other (because they sum to zero), it is easily shown that:

\begin{equation}
\sigma_{Y;\tau}^2=\frac{d^2}{2}
(\#eq:sigma2Tau1)
\end{equation}
 

### Dependence of statistical power on estimates of model parameters {#RocSampleSizeOR-dependence-of-stats-power}
Examination of the expression for  , Eqn. (11.5), shows that statistical power increases if:

* The numerator is large. This occurs if: (a) the anticipated effect-size $d$ is large. Since effect-size enters as the *square*, TBA Eqn. (11.8), it is has a particularly strong effect; (b) If $J \times K$ is large. Both of these results should be obvious, as a large effect size and a large sample size should result in increased probability of rejecting the NH. 
* The denominator is small. The first term in the denominator is  $\left ( \sigma_{Y;\epsilon}^2 + \sigma_{Y;\tau RC}^2 \right )$. These two terms cannot be separated. This is the residual variability of the jackknife pseudovalues. It should make sense that the smaller the variability, the larger is the non-centrality parameter and the statistical power. 
* The next term in the denominator is $K\sigma_{Y;\tau R}^2$, the treatment-reader variance component multiplied by the total number of cases. The reader variance $\sigma_{Y;R}^2$ has no effect on statistical power, because it has an equal effect on both treatments and cancels out in the difference. Instead, it is the treatment-reader variance $\sigma_{Y;R}^2$  that contributes "noise" tending to confound the estimate of the effect-size. 
* The variance components estimated by the ANOVA procedure are realizations of random variables and as such subject to noise (there actually exists a beast such as variance of a variance). The presence of the $K$ term, usually large, can amplify the effect of noise in the estimate of $\sigma_{Y;R}^2$, making the sample size estimation procedure less accurate.
* The final term in the denominator is  $J\sigma_{Y;\tau C}^2$. The variance $\sigma_{Y;C}^2$ has no impact on statistical power, as it cancels out in the difference. The treatment-case variance component introduces "noise" into the estimate of the effect size, thereby decreasing power. Since it is multiplied by J, the number of readers, and typically $J<<K$, the error amplification effect on accuracy of the sample size estimate is not as bad as with the treatment-reader variance component.
* Accuracy of sample size estimation, essentially estimating confidence intervals for statistical power, is addressed in [@RN2027].

### Formulae for random-reader random-case (RRRC) sample size estimation {#RocSampleSizeOR-RRRC-sample-size-estimation}


### Significance testing {#RocSampleSizeOR-sig-testing}

### p-value and confidence interval {#RocSampleSizeOR-pvalue-ci}

### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments {#RocSampleSizeOR-CompareDBM2OR}
Having performed a pilot study and planning to perform a pivotal study, sample size estimation follows the following procedure, which assumes that both reader and case are treated as random factors. Different formulae, described later, apply when either reader or case is treated as a fixed factor.

* Perform OR analysis on the pilot data. This yields the observed effect size as well as estimates of all relevant variance components and mean squares appearing in TBA Eqn. (11.5) and Eqn. (11.7).
* This is the difficult but critical part: make an educated guess regarding the effect-size, $d$, that one is interested in "detecting" (i.e., hoping to reject the NH with probability $1-\beta$). The author prefers the term "anticipated" effect-size to "true" effect-size (the latter implies knowledge of the true difference between the modalities which, as noted earlier, would obviate the need for a pivotal study). 
* Two scenarios are considered below. In the first scenario, the effect-size is assumed equal to that observed in the pilot study, i.e., $d = d_{obs}$. 
* In the second, so-called "best-case" scenario, one assumes that the anticipate value of $d$ is the observed value plus two-sigma of the confidence interval, in the correct direction, of course, i.e., $d=\left | d_{obs} \right |+2\sigma$. Here $\sigma$ is one-fourth the width of the 95% confidence interval for $d_{obs}$. Anticipating more than $2\sigma$  greater than the observed effect-size would be overly optimistic. The width of the CI implies that chances are less than 2.5% that the anticipated value is at or beyond the overly optimistic value. These points will become clearer when example datasets are analyzed below.
*	Calculate statistical power using the distribution implied by Eqn. (11.4), to calculate the probability that a random value of the relevant F-statistic will exceed the critical value, as in §11.3.2.
* If power is below the desired or "target" power, one tries successively larger value of $J$ and / or $K$ until the target power is reached. 


## Formulae for fixed-reader random-case (FRRC) sample size estimation {#RocSampleSizeOR-FRRC-sample-size-estimation}
It was shown in TBA §9.8.2 that for fixed-reader analysis the non-centrality parameter is defined by:

\begin{equation}
\Delta=\frac{JK\sigma_{Y;\tau}^2}{\sigma_{Y;\epsilon}^2+\sigma_{Y;\tau RC}^2+J\sigma_{Y;\tau C}^2}
(\#eq:DeltaFRRC1)
\end{equation}

The sampling distribution of the F-statistic under the AH is:

\begin{equation}
F_{AH|R}\equiv \frac{MST}{MSTC}\sim F_{I-1,(I-1)(K-1),\Delta}
(\#eq:SamplingFFRRC1)
\end{equation}

### Formulae for random-reader fixed-case (RRFC) sample size estimation {#RocSampleSizeOR-RRFC-sample-size-estimation}
It is shown in TBA §9.9 that for fixed-case analysis the non-centrality parameter is defined by:

\begin{equation}
\Delta=\frac{JK\sigma_{Y;\tau}^2}{\sigma_{Y;\epsilon}^2+\sigma_{Y;\tau RC}^2+K\sigma_{Y;\tau R}^2}
(\#eq:DeltaFRRFC1)
\end{equation}

Under the AH, the test statistic is distributed as a non-central F-distribution as follows:

\begin{equation}
F_{AH|C}\equiv \frac{MST}{MSTR}\sim F_{I-1,(I-1)(J-1),\Delta}
(\#eq:SamplingFRRFC1)
\end{equation}

### Example 1
In the first example the Van Dyke dataset is regarded as a pilot study. Two implementations are shown, a direct application of the relevant formulae, including usage of the mean squares, which in principle can be calculated from the three variance-components. This is then compared to the `RJafroc` implementation. 

Shown first is the "open" implementation. 


```r
alpha <- 0.05;cat("alpha = ", alpha, "\n")
#> alpha =  0.05
rocData <- dataset02 # select Van Dyke dataset
retDbm <- StSignificanceTesting(dataset = rocData, FOM = "Wilcoxon", method = "DBM") 
varYTR <- retDbm$ANOVA$VarCom["VarTR","Estimates"]
varYTC <- retDbm$ANOVA$VarCom["VarTC","Estimates"]
varYEps <- retDbm$ANOVA$VarCom["VarErr","Estimates"]
effectSize <- retDbm$FOMs$trtMeanDiffs["trt0-trt1","Estimate"]
cat("effect size = ", effectSize, "\n")
#> effect size =  -0.043800322

#RRRC
J <- 10; K <- 163
ncp <- (0.5*J*K*(effectSize)^2)/(K*varYTR+max(J*varYTC,0)+varYEps)
MS <- UtilMeanSquares(rocData, FOM = "Wilcoxon", method = "DBM")
ddf <- (MS$msTR+max(MS$msTC-MS$msTRC,0))^2/(MS$msTR^2)*(J-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power <- 1-pf(FCrit, 1, ddf, ncp = ncp)
data.frame("J"= J,  "K" = K, "FCrit" = FCrit, "ddf" = ddf, "ncp" = ncp, "RRRCPower" = Power)
#>    J   K     FCrit       ddf       ncp  RRRCPower
#> 1 10 163 4.1270572 34.334268 8.1269825 0.79111255

#FRRC
J <- 10; K <- 133
ncp <- (0.5*J*K*(effectSize)^2)/(max(J*varYTC,0)+varYEps)
ddf <- (K-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power <- 1-pf(FCrit, 1, ddf, ncp = ncp)
data.frame("J"= J,  "K" = K, "FCrit" = FCrit, "ddf" = ddf, "ncp" = ncp, "RRRCPower" = Power)
#>    J   K    FCrit ddf       ncp  RRRCPower
#> 1 10 133 3.912875 132 7.9873835 0.80111671

#RRFC
J <- 10; K <- 53
ncp <- (0.5*J*K*(effectSize)^2)/(K*varYTR+varYEps)
ddf <- (J-1)
FCrit <- qf(1 - alpha, 1, ddf)
Power <- 1-pf(FCrit, 1, ddf, ncp = ncp)
data.frame("J"= J,  "K" = K, "FCrit" = FCrit, "ddf" = ddf, "ncp" = ncp, "RRRCPower" = Power)
#>    J  K    FCrit ddf       ncp  RRRCPower
#> 1 10 53 5.117355   9 10.048716 0.80496663
```

For 10 readers, the numbers of cases needed for 80% power is largest (163) for RRRC and least for RRFC (53). For all three analyses, the expectation of 80% power is met - the numbers of cases and readers were chosen to achieve close to 80% statistical power. Intermediate quantities such as the critical value of the F-statistic, `ddf` and `ncp` are shown. The reader should confirm that the code does in fact implement the relevant formulae. Shown next is the `RJafroc` implementation. The relevant file is mainSsDbm.R, a listing of which follows: 

### Fixed-reader random-case (FRRC) analysis {#RocSampleSizeOR-FRRCAnalysis}

### Random-reader fixed-case (RRFC) analysis {#RocSampleSizeOR-RRFCAnalysis}

### Single-treatment multiple-reader analysis {#RocSampleSizeOR-STMRAnalysis}

## Discussion/Summary/3

## References {#RocSampleSizeOR-references}


<!--chapter:end:11-ROCSampleSizeOR.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Split Plot Study Design {#SplitPlotChapter}



## Mean Square R(T)
R(T) is read as "reader nested within treatment" [@RN2508].  


\begin{equation}
\text{MS[R(T)]}=\frac{1}{I(J-1)}\sum_{i=1}^{I}\sum_{j=1}^{J}\left ( \theta_{ij} - \theta_{i\bullet} \right )^{2}
(\#eq:MSR-T-Hillis)
\end{equation}


\begin{equation}
\text{MS[R(T)]}=\frac{1}{I}\sum_{i=1}^{I}\frac{1}{J_i-1}\sum_{j=1}^{J}\left ( \theta_{ij} - \theta_{i\bullet} \right )^{2}
(\#eq:MSR-T-Hillis-Modified)
\end{equation}


## References {#SplitPlotChapter-references}


<!--chapter:end:91-SplitPlot.Rmd-->



<!--chapter:end:99-References.Rmd-->

