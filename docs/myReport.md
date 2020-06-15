---
output:
  pdf_document: default
  html_document: default
---



# Example running external scripts

source method

```r
source(here("R/example.R"))
```

<img src="myReport_files/figure-html/unnamed-chunk-1-1.png" width="672" />

```r
# source(here("R/example2.R"))
print(head(data.frame(x,y)))
#>   x         y
#> 1 1 0.1866675
#> 2 2 2.3359553
#> 3 3 1.5452315
#> 4 4 4.5955349
#> 5 5 7.0977821
#> 6 6 5.5575616
```


<!-- read chunk (does not run code) -->
<!-- ```{r echo=FALSE} -->
<!-- read_chunk('R/example.R') -->
<!-- ``` -->

<!-- run the variablesXY chunk and use the variables it creates -->
<!-- ```{r variablesXY} -->
<!-- # <<variablesXY>> -->
<!-- # head(data.frame(x,y)) -->

<!-- ``` -->

<!-- run the plotXY chunk and create the plot -->
<!-- ```{r plotXY} -->
<!-- # <<plotXY>> -->
<!-- ``` -->
