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

![](myReport_files/figure-epub3/unnamed-chunk-1-1.png)<!-- -->

```r
# source(here("R/example2.R"))
print(head(data.frame(x,y)))
#>   x        y
#> 1 1 2.252275
#> 2 2 2.919807
#> 3 3 2.526587
#> 4 4 2.648630
#> 5 5 2.289681
#> 6 6 5.859748
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
