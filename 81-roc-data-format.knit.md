# (PART\*) APPENDICES {-}

# (APPENDIX) Appendix{-} 

# ROC DATA FORMAT {#rocdataformat}




## Introduction {#rocdataformatIntro}
* The purpose of this chapter is to explain the data format of the input Excel file and to introduce the capabilities of the function `DfReadDataFile()`. Background on observer performance methods are in my book  [@chakraborty2017observer].
* I will start with Receiver Operating Characteristic (ROC) data [@metz1978rocmethodology],  as this is by far the simplest paradigm.
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











