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
#> 1 1 1.478432
#> 2 2 1.224225
#> 3 3 2.596171
#> 4 4 5.112679
#> 5 5 5.774290
#> 6 6 5.263578
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
