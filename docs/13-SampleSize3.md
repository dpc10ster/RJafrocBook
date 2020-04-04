# ROC-DBMH sample size using RJafroc {#SSRocDBMHRJafroc}




## Introduction
This illustrates the `RJafroc` implementation of sample-size estimation. Default $\alpha$ is 0.05 and default power (1-$\beta$) is 0.8. Three functions are provided. Each of these functions can be used with `method "DBMH"` (illustrated here, the default) or `method = "ORH"` (next chapter). Illustrated below, for the most part, is the random-reader random-case (RRRC) option, i.e., `option = "RRRC"`. The last two examples illustrate fixed-reader random-case (FRRC) `option = "FRRC"` and random-reader fixed-case (RRFC) `option = "RRFC"` options.

* `SsPowerGivenJK()` 
    Statistical power for specified numbers of readers and cases in an ROC study.
* `SsPowerTable()` 
    Generate a power table, i.e., combinations of numbers of readers and cases yielding the desired power.
* `SsSampleSizeKGivenJ` 
    Number of cases, for specified number of readers, to achieve desired power.

## Illustration of `SsPowerGivenJK()` using `method = "DBMH"`

The selected dataset corresponds to the Van Dyke data.

```r
power <- SsPowerGivenJK(dataset02, FOM = "Wilcoxon", J = 6, K = 112, option = "RRRC")
```

The returned value is a list containing the expected power `power`, the non-centrality parameter `ncp`, the denominator degrees of freedom `ddf` and the F-statistic `f`. The numerator degrees of freedom `ndf` is always `I - 1`, i.e., unity for this dataset.


```r
str(power)
#> 'data.frame':	1 obs. of  4 variables:
#>  $ powerRRRC: num 0.556
#>  $ ncpRRRC  : num 4.8
#>  $ ddfHRRRC : num 23.1
#>  $ fRRRC    : num 4.28
```

Expected power is 0.5555789.


## Illustration of `SsPowerTable()` using `method = "DBMH"`


```r
powTab <- SsPowerTable(dataset02, FOM = "Wilcoxon", method = "DBMH", option = "RRRC")
```

Now show the power table `powTab`. Note that the last column is always close to 0.8, the desired power. The 2nd and 3rd columns show the number of readers and number of cases to achieve the desired power.


```r
powTab
#>     numReaders numCases power
#> 1            3    >2000  <NA>
#> 2            3    >2000  <NA>
#> 3            4     1089   0.8
#> 4            4     1089   0.8
#> 5            5      344 0.801
#> 6            5      344 0.801
#> 7            6      251 0.801
#> 8            6      251 0.801
#> 9            7      211 0.801
#> 10           7      211 0.801
#> 11           8      188 0.801
#> 12           8      188 0.801
#> 13           9      173 0.801
#> 14           9      173 0.801
#> 15          10      163 0.802
#> 16          10      163 0.802
#> 17          11      155 0.801
#> 18          11      155 0.801
#> 19          12      149 0.802
#> 20          12      149 0.802
#> 21          13      144 0.801
#> 22          13      144 0.801
#> 23          14      140 0.802
#> 24          14      140 0.802
#> 25          15      137 0.802
#> 26          15      137 0.802
#> 27          16      134 0.802
#> 28          16      134 0.802
#> 29          17      131 0.801
#> 30          17      131 0.801
#> 31          18      129 0.801
#> 32          18      129 0.801
#> 33          19      127 0.801
#> 34          19      127 0.801
#> 35          20      126 0.802
#> 36          20      126 0.802
#> 37          21      124 0.801
#> 38          21      124 0.801
#> 39          22      123 0.802
#> 40          22      123 0.802
#> 41          23      122 0.802
#> 42          23      122 0.802
#> 43          24      121 0.803
#> 44          24      121 0.803
#> 45          25      120 0.802
#> 46          25      120 0.802
#> 47          26      119 0.802
#> 48          26      119 0.802
#> 49          27      118 0.802
#> 50          27      118 0.802
#> 51          28      117 0.801
#> 52          28      117 0.801
#> 53          29      117 0.803
#> 54          29      117 0.803
#> 55          30      116 0.802
#> 56          30      116 0.802
#> 57          31      115 0.801
#> 58          31      115 0.801
#> 59          32      115 0.803
#> 60          32      115 0.803
#> 61          33      114 0.801
#> 62          33      114 0.801
#> 63          34      114 0.803
#> 64          34      114 0.803
#> 65          35      113 0.801
#> 66          35      113 0.801
#> 67          36      113 0.802
#> 68          36      113 0.802
#> 69          37      112   0.8
#> 70          37      112   0.8
#> 71          38      112 0.802
#> 72          38      112 0.802
#> 73          39      112 0.803
#> 74          39      112 0.803
#> 75          40      111 0.801
#> 76          40      111 0.801
#> 77          41      111 0.802
#> 78          41      111 0.802
#> 79          42      111 0.803
#> 80          42      111 0.803
#> 81          43      110 0.801
#> 82          43      110 0.801
#> 83          44      110 0.802
#> 84          44      110 0.802
#> 85          45      110 0.802
#> 86          45      110 0.802
#> 87          46      110 0.803
#> 88          46      110 0.803
#> 89          47      109 0.801
#> 90          47      109 0.801
#> 91          48      109 0.802
#> 92          48      109 0.802
#> 93          49      109 0.802
#> 94          49      109 0.802
#> 95          50      109 0.803
#> 96          50      109 0.803
#> 97          51      108   0.8
#> 98          51      108   0.8
#> 99          52      108 0.801
#> 100         52      108 0.801
#> 101         53      108 0.802
#> 102         53      108 0.802
#> 103         54      108 0.802
#> 104         54      108 0.802
#> 105         55      108 0.803
#> 106         55      108 0.803
#> 107         56      107   0.8
#> 108         56      107   0.8
#> 109         57      107 0.801
#> 110         57      107 0.801
#> 111         58      107 0.801
#> 112         58      107 0.801
#> 113         59      107 0.802
#> 114         59      107 0.802
#> 115         60      107 0.802
#> 116         60      107 0.802
#> 117         61      107 0.803
#> 118         61      107 0.803
#> 119         62      107 0.803
#> 120         62      107 0.803
#> 121         63      106   0.8
#> 122         63      106   0.8
#> 123         64      106 0.801
#> 124         64      106 0.801
#> 125         65      106 0.801
#> 126         65      106 0.801
#> 127         66      106 0.802
#> 128         66      106 0.802
#> 129         67      106 0.802
#> 130         67      106 0.802
#> 131         68      106 0.802
#> 132         68      106 0.802
#> 133         69      106 0.803
#> 134         69      106 0.803
#> 135         70      106 0.803
#> 136         70      106 0.803
#> 137         71      106 0.804
#> 138         71      106 0.804
#> 139         72      105   0.8
#> 140         72      105   0.8
#> 141         73      105 0.801
#> 142         73      105 0.801
#> 143         74      105 0.801
#> 144         74      105 0.801
#> 145         75      105 0.801
#> 146         75      105 0.801
#> 147         76      105 0.802
#> 148         76      105 0.802
#> 149         77      105 0.802
#> 150         77      105 0.802
#> 151         78      105 0.802
#> 152         78      105 0.802
#> 153         79      105 0.803
#> 154         79      105 0.803
#> 155         80      105 0.803
#> 156         80      105 0.803
#> 157         81      105 0.803
#> 158         81      105 0.803
#> 159         82      105 0.803
#> 160         82      105 0.803
#> 161         83      104   0.8
#> 162         83      104   0.8
#> 163         84      104   0.8
#> 164         84      104   0.8
#> 165         85      104 0.801
#> 166         85      104 0.801
#> 167         86      104 0.801
#> 168         86      104 0.801
#> 169         87      104 0.801
#> 170         87      104 0.801
#> 171         88      104 0.801
#> 172         88      104 0.801
#> 173         89      104 0.802
#> 174         89      104 0.802
#> 175         90      104 0.802
#> 176         90      104 0.802
#> 177         91      104 0.802
#> 178         91      104 0.802
#> 179         92      104 0.802
#> 180         92      104 0.802
#> 181         93      104 0.802
#> 182         93      104 0.802
#> 183         94      104 0.803
#> 184         94      104 0.803
#> 185         95      104 0.803
#> 186         95      104 0.803
#> 187         96      104 0.803
#> 188         96      104 0.803
#> 189         97      104 0.803
#> 190         97      104 0.803
#> 191         98      104 0.804
#> 192         98      104 0.804
#> 193         99      104 0.804
#> 194         99      104 0.804
#> 195        100      103   0.8
#> 196        100      103   0.8
```

## Illustration of `SsSampleSizeKGivenJ()` using `method = "DBMH"`

This function illustrates how the number of cases for 10 readers, used in Chapter TBA, were chosen. In all but one example the default value of the `desiredPower` argument is used, namely 0.8 (if the argument is absent, its default value is used).

### RRRC


```r
ncases <- SsSampleSizeKGivenJ(dataset02, FOM = "Wilcoxon", J = 10, method = "DBMH", option = "RRRC")
str(ncases)
#> 'data.frame':	1 obs. of  2 variables:
#>  $ KRRRC    : num 163
#>  $ powerRRRC: num 0.802
```

`ncases` is a list containing the number of cases 163 and expected power 0.8015625. Compare the number of cases to the RRRC value used in Chapter TBA.

#### Non default value of `desiredPower`
This is illustrated below for 90% desired power.


```r
ncases <- SsSampleSizeKGivenJ(dataset02, FOM = "Wilcoxon", J = 10, method = "DBMH", option = "RRRC", desiredPower = 0.9)
str(ncases)
#> 'data.frame':	1 obs. of  2 variables:
#>  $ KRRRC    : num 236
#>  $ powerRRRC: num 0.9
```

The required number of cases is 236 and expected power is 0.9003501. 

### FRRC


```r
ncases <- SsSampleSizeKGivenJ(dataset02, FOM = "Wilcoxon", J = 10, method = "DBMH", option = "FRRC")
str(ncases)
#> 'data.frame':	1 obs. of  2 variables:
#>  $ KFRRC    : num 133
#>  $ powerFRRC: num 0.801
```

The required number of cases is 133 and expected power is 0.8011167. Compare the number of cases to the FRRC value used in Chapter TBA.

### RRFC


```r
ncases <- SsSampleSizeKGivenJ(dataset02, FOM = "Wilcoxon", J = 10, method = "DBMH", option = "RRFC")
str(ncases)
#> 'data.frame':	1 obs. of  2 variables:
#>  $ KRRFC    : num 53
#>  $ powerRRFC: num 0.805
```

The required number of cases is 53 and expected power is 0.8049666. Compare the number of cases to the RRFC value used in Chapter TBA.


