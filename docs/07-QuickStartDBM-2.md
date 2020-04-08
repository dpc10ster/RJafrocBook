# QUICK START DBM2 {#QuickStartDBM2}



## Introduction
This chapter illustrates significance testing using the DBMH method. But, instead of the unwieldy output in *QuickStartDBMH.html*, it generates an Excel output file containing the following worksheets:

* `Summary`
* `FOMs`
* `RRRC`
* `FRRC`
* `RRFC`
* `ANOVA`


## Generating the Excel output file

This illustrates the `UtilOutputReport()` function. The significance testing `method` is "DBMH", the default, and the figure of merit `FOM` is  "Wilcoxon". Note `ReportFileExt` = "xlsx"` telling
the function to create an Excel output file. The Excel output is created in a temporary file.


```r
ret <- UtilOutputReport(dataset03, FOM = "Wilcoxon", overWrite = TRUE, ReportFileExt = "xlsx")
#> 
#> Output file name is: 	 /var/folders/d1/mx6dcbzx3v39r260458z2b200000gn/T//RtmphsQKJI/RJafrocUtilOutputReport41ac338852ac.xlsx
```


## ORH significance testing
Simply change `method = "DBMH"` (the default) to `method = "ORH"`.



```r
ret <- UtilOutputReport(dataset03, FOM = "Wilcoxon", method = "ORH", overWrite = TRUE, ReportFileExt = "xlsx")
#> 
#> Output file name is: 	 /var/folders/d1/mx6dcbzx3v39r260458z2b200000gn/T//RtmphsQKJI/RJafrocUtilOutputReport41ac5b7c4958.xlsx
```

