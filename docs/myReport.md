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
#> 1 1 0.5234986
#> 2 2 0.5802099
#> 3 3 4.1128998
#> 4 4 4.8742399
#> 5 5 4.9115141
#> 6 6 5.1651961
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
