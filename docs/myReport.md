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
#> 1 1 1.3960111
#> 2 2 0.8430547
#> 3 3 2.9146279
#> 4 4 5.1843363
#> 5 5 6.3523684
#> 6 6 5.8711240
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
