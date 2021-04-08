# Optimal operating point on FROC {#optim-op-point}

---
output:
  rmarkdown::pdf_document:
    fig_caption: yes        
    includes:  
      in_header: R/learn/my_header.tex
---









## How much finished {#optim-op-point-how-much-finished}
40%
Major update to 21-optim-op-point.Rmd - need to resolve plots in vary mu


## Introduction {#optim-op-point-intro}

This chapter deals with finding the optimal reporting threshold of an algorithmic observer, such as CAD. We assume that designer level FROC data is available for the algorithm: the data consists of mark-rating pairs, with the continuous-scale ratings extending from low to high values, and a decision needs to be made as to which of these marks, if any, are to be reported to the radiologist. This is a familiar problem faced by a CAD algorithm designer, and to the best of my knowledge, it has not been solved. 

A proposed approach is to set the operating point on the ROC curve such as to maximize the Youden-index. The Youden-index is defined as the sum of sensitivity and specificity minus one. Typically it is maximized at the point that is closest to the (0,1) point on the ROC. However, in practice, CAD manufacturers set a site-specific reporting threshold in consultation with the radiologists who will be using the algorithm. For example, if radiologists are comfortable with more false marks as the price of potentially greater lesion-level sensitivity, the reporting threshold is adjusted downward. At sites where the radiologists are uncomfortable with more false marks being shown, the reporting threshold is adjusted upward.

This chapter describes a method of finding the optimal reporting threshold based on maximizing the AUC under the wAFROC curve. For completeness it is compared to the Youden-index based method.  



## Methods {#optim-op-point-methods}

The RSM (radiological search model) parameters are $\lambda$, $\nu$, $\mu$ and $\zeta_1$. The ROC, FROC and wAFROC curves are completely defined by them. The parameters have the following meanings:

* The $\mu$ parameter is the perceptual signal to noise ratio of lesions measured under location-known-exactly conditions. These have a direct effect on the search mechanism, since, as $\mu$ increases, lesions are more likely to be found and non-diseased regions are less likely to be mistaken for lesions. Higher values of $\mu$ lead to increased overall performance of the algorithm.

* The $\lambda$ parameter determines the number of non-lesion localizations, NLs, per case (location level "false positives"). Lower values lead to fewer NL marks and increased overall performance of the algorithm.

* The $\nu$ parameter determines the probability of a lesion localizations, LLs, (location level "true positives"). Higher values lead to more LL marks.

* The $\zeta_1$ parameter determines if a suspicious region found by the algorithm is actually marked. The higher this value, the fewer the reported marks.


In the following sections each of the first three parameters is varied in turn and the corresponding optimal $\zeta_1$ determined by maximizing one of two figures of merit (FOMs) namely, the wAFROC-AUC and the Youden-index. 


### Functions to be maximized
The functions to be maximized, `wAFROC` and `Youden`, are defined next: 

* wAFROC-AUC is computed by `UtilAnalyticalAucsRSM`. Lines 2 - 19 returns `-wAFROC`, the *negative* of wAFROC-AUC. The negative sign is needed because the `optimize()` function, used later, finds the *minimum* of wAFROC-AUC. The first argument is $\zeta_1$, the variable to be varied to find the maximum. The remaining arguments passed to the function, needed to calculate the FOMs, are $\mu$, $\lambda$, $\nu$, `lesDistr` and `relWeights.` The last two specify the number of lesions per case and their weights. The following code below uses `lesDistr = c(0.5,0.5)`, i.e., half of the diseased cases contain one lesion and the rest contain two lesions, and `relWeights = c(0.5,0.5)`, which specifies equal weights to all lesions.


* The Youden-index is defined as the sum of sensitivity and specificity minus 1. Sensitivity is computed by `RSM_yROC` and specificity by `(1 - RSM_xROC)`. Lines 22 - 42 returns `-Youden`, the *negative* of the Youden-index. 




```{.r .numberLines}

wAFROC <- function (
  zeta1, 
  mu, 
  lambda, 
  nu, 
  lesDistr, 
  relWeights) {
  x <- UtilAnalyticalAucsRSM(
    mu, 
    lambda, 
    nu, zeta1, 
    lesDistr, 
    relWeights)$aucwAFROC
  # return negative of aucwAFROC 
  # (as optimize finds minimum of function)
  return(-x)
  
}


Youden <- function (
  zeta1, 
  mu, 
  lambda, 
  nu, 
  lesDistr, 
  relWeights) {
  # add sensitivity and specificity 
  # and subtract 1, i.e., Youden's index
  x <- RSM_yROC(
    zeta1, 
    mu, 
    lambda, 
    nu, 
    lesDistr) + 
    (1 - RSM_xROC(zeta1, lambda/mu)) - 1
  # return negative of Youden-index 
  # (as optimize finds minimum of function)
  return(-x)
  
}
```


### Vary lambda  {#optim-op-point-vary-lambda}

For $\mu = 2$ and $\nu = 1$, wAFROC-AUC and Youden-index based optimizations were performed for $\lambda = 1, 5, 10, 15$. The following quantities were calculated:

* `zetaOptArr`, a [2,4] array, the optimal thresholds $\zeta_1$; 
* `fomMaxArr`, a [2,4] array, the maximized values of wAFROC-AUC, using either wAFROC based or Youden-index based optimization; note that in the latter we report wAFROC-AUC even though the optimized quantity is the Youden-index.
* `rocAucArr`, a [2,4] array, the AUCs under the ROC curves corresponding to optimizations based on wAFROC-AUC or Youden-index;   
* `nlfOptArr`, a [2,4] array, the abscissa of the optimal reporting point on the FROC curve corresponding to optimizations based on wAFROC-AUC or Youden-index;   
* `llfOptArr`, a [2,4] array, the ordinate of the optimal reporting point on the FROC curve corresponding to optimizations based on wAFROC-AUC or Youden-index.   

In each of these arrays the first index, `y` in the following code, denotes whether wAFROC-AUC is being maximized (`y` = 1, see lines 14 - 20) - or if Youden-index is being optimized (`y` = 2, see lines 39 - 45). The second index `i` in the following code,  corresponds to $\lambda$.



```{.r .numberLines}
mu <- 2
nu <- 1
lambdaArr <- c(1,5,10,15)
fomMaxArr <- array(dim = c(2,length(lambdaArr)))
zetaOptArr <- array(dim = c(2,length(lambdaArr)))
rocAucArr <- array(dim = c(2,length(lambdaArr)))
nlfOptArr <- array(dim = c(2,length(lambdaArr)))
llfOptArr <- array(dim = c(2,length(lambdaArr)))
lesDistr <- c(0.5, 0.5)
relWeights <- c(0.5, 0.5)
for (y in 1:2) {
  for (i in 1:length(lambdaArr)) {
    if (y == 1) {
      x <- optimize(wAFROC, 
                    interval = c(-5,5), 
                    mu, 
                    lambdaArr[i], 
                    nu, 
                    lesDistr, 
                    relWeights)
      zetaOptArr[y,i] <- x$minimum
      fomMaxArr[y,i] <- -x$objective # safe to use objective here
      rocAucArr[y,i] <- UtilAnalyticalAucsRSM(
        mu, 
        lambdaArr[i], 
        nu, 
        zeta1 = x$minimum, 
        lesDistr, 
        relWeights)$aucROC
      nlfOptArr[y,i] <- RSM_xFROC(
        z = x$minimum, 
        mu, 
        lambda = lambdaArr[i])
      llfOptArr[y,i] <- RSM_yFROC(
        z = x$minimum, 
        mu, 
        nu)
    } else if (y == 2) {
      x <- optimize(Youden, 
                    interval = c(-5,5), 
                    mu, 
                    lambdaArr[i], 
                    nu, 
                    lesDistr, 
                    relWeights)
      zetaOptArr[y,i] <- x$minimum
      fomMaxArr[y,i] <- UtilAnalyticalAucsRSM(
        mu, 
        lambdaArr[i], 
        nu, 
        zeta1 = x$minimum, 
        lesDistr, 
        relWeights)$aucwAFROC
      rocAucArr[y,i] <- UtilAnalyticalAucsRSM(
        mu, 
        lambdaArr[i], 
        nu, 
        zeta1 = x$minimum, 
        lesDistr, 
        relWeights)$aucROC
      nlfOptArr[y,i] <- RSM_xFROC(
        z = x$minimum, 
        mu, 
        lambda = lambdaArr[i])
      llfOptArr[y,i] <- RSM_yFROC(
        z = x$minimum, mu, nu)
    } else stop("incorrect y")
  }
}
```



Table \@ref(tab:optim-op-point-table1) summarizes the results. The column labeled "FOM" shows the quantity being maximized, "lambda" corresponds to the 4 values of $\lambda$, "zeta1" is the optimal value of $\zeta_1$ that maximizes FOM, "wAFROC" is the wAFROC-AUC, "ROC" is the AUC under the ROC curve, i.e., ROC-AUC, and "OptOpPt" is the optimal operating point on the FROC curve. 

Focusing on the wAFROC-AUC based optimizations (first four rows of table), it is seen that as $\lambda$ increases:

* The optimal threshold $\zeta_1$ increases;
* wAFROC-AUC decreases;
* ROC-AUC decreases;
* The optimal operating point moves to lower LLF values, i.e., lower values of lesion-level "sensitivity".
* TBA comment on broad maxima for $\zeta_1$ = 0.310 to 0.386 

The $\lambda$ Poisson parameter controls the average number of latent (i.e., perceived; it is marked if its confidence level exceeds $\zeta_1$) non-lesion localizations (NLs or location-level "false-positives") per case. For example, for $\mu = 2$ and $\lambda = 1$, the average number of latent NLs per case is $\lambda' = \lambda /\mu = 0.5$, i.e., an average of one latent NL every two non-diseased case. With increasing numbers of NLs it is necessary to increase the reporting threshold and LLF decreases. Also, overall CAD performance, regardless of how it is measured (i.e., wAFROC-AUC or ROC-AUC), decreases.   

Similar trends are observed for the Youden-index based optimizations (last four rows of table). However, Youden-index based optimizations compared as a group to wAFROC-AUC based optimizations show that the former yield higher reporting thresholds, lower wAFROC-AUC, lower ROC-AUC and lower LLF values. 








<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:optim-op-point-table1)Summary of optimization results for $\mu = 2$, $\nu = 1$ and different values of $\lambda$. The wAFROC column always displays wAFROC-AUC, even though the optimized quantity may the Youden-index, as in the last four rows.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> FOM </th>
   <th style="text-align:left;"> lambda </th>
   <th style="text-align:left;"> zeta1 </th>
   <th style="text-align:left;"> wAFROC </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> OptOpPt </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> -0.235 </td>
   <td style="text-align:left;"> 0.880 </td>
   <td style="text-align:left;"> 0.937 </td>
   <td style="text-align:left;"> (0.296, 0.854) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 0.810 </td>
   <td style="text-align:left;"> 0.768 </td>
   <td style="text-align:left;"> 0.875 </td>
   <td style="text-align:left;"> (0.522, 0.763) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> 1.373 </td>
   <td style="text-align:left;"> 0.699 </td>
   <td style="text-align:left;"> 0.825 </td>
   <td style="text-align:left;"> (0.424, 0.635) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 15 </td>
   <td style="text-align:left;"> 1.697 </td>
   <td style="text-align:left;"> 0.660 </td>
   <td style="text-align:left;"> 0.788 </td>
   <td style="text-align:left;"> (0.336, 0.535) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 0.802 </td>
   <td style="text-align:left;"> 0.856 </td>
   <td style="text-align:left;"> 0.915 </td>
   <td style="text-align:left;"> (0.106, 0.765) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:left;"> 1.438 </td>
   <td style="text-align:left;"> 0.750 </td>
   <td style="text-align:left;"> 0.842 </td>
   <td style="text-align:left;"> (0.188, 0.616) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 10 </td>
   <td style="text-align:left;"> 1.690 </td>
   <td style="text-align:left;"> 0.693 </td>
   <td style="text-align:left;"> 0.801 </td>
   <td style="text-align:left;"> (0.227, 0.538) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 15 </td>
   <td style="text-align:left;"> 1.832 </td>
   <td style="text-align:left;"> 0.658 </td>
   <td style="text-align:left;"> 0.776 </td>
   <td style="text-align:left;"> (0.251, 0.490) </td>
  </tr>
</tbody>
</table>



As regards displaying FROC curves with superimposed optimal operating points, one could generate 8 plots, each corresponding to a row of the preceding table, but there is a more efficient method. The FROC curve is defined in terms of the RSM parameters as follows:



\begin{equation}
\left. 
\begin{aligned}
NLF \left ( \zeta, \lambda' \right ) =& \lambda' \Phi \left (-\zeta \right ) \\
LLF\left ( \zeta, \mu, \nu', \overrightarrow{f_L} \right ) =& \nu' \Phi \left ( \mu - \zeta \right ) 
\end{aligned}
\right \}
(\#eq:rsm-froc-predictions)
\end{equation}

Here $\overrightarrow{f_L}$ is the lesion-distribution vector, `c(0.5, 0.5)` in the current example. 

The *end-point* of the FROC defined by $\left ( \lambda', \nu' \right )$ is not to be confused with the *optimal* value of $\zeta_1$; the former corresponds to $\zeta_1 = -\infty$ while the latter is a finite value of $\zeta_1$ as found by the optimization procedure.


The *physical* parameters $\lambda'$ and $\nu'$, that determine the FROC, are related to the *intrinsic* parameters $\mu$, $\lambda$ and $\nu$ by: 

\begin{equation}
\left. 
\begin{aligned}
\lambda' =& \frac{\lambda  }{\mu} \\
\nu' =& 1 - exp\left (-\mu \nu \right ) 
\end{aligned}
\right \}
(\#eq:rsm-intrinsic-physical)
\end{equation}


Since the $\Phi$ function ranges from one to unity, the *four FROC curves for different values of $\lambda$ are scaled versions of a single curve whose x-axis ranges from 0 to 1*. The single curve corresponds to $\lambda' = 1$ and the true curves are obtained by scaling this curve along the x-axis by the appropriate $\lambda'$ factor. With this understanding one can display 4 FROC curves with a single FROC curve where the x-axis is $NLF \left ( \zeta, \lambda' = 1 \right )$. The true FROC curve is defined by:  



\begin{equation}
\left. 
\begin{aligned}
NLF \left ( \zeta, \lambda' \right ) =& \lambda' NLF \left ( \zeta, \lambda' = 1 \right ) \\
LLF\left ( \zeta, \mu, \nu', \overrightarrow{f_L} \right ) =& \nu' \Phi \left ( \mu - \zeta \right ) 
\end{aligned}
\right \}
(\#eq:rsm-froc-predictions2)
\end{equation}









<div class="figure">
<img src="21-optim-op-point_files/figure-html/optim-op-point-vary-lambda-1.png" alt="Left panel: maximized wAFROC AUC was used to find optimal $\zeta_1$. Right panel: maximized Youden-index was used to find optimal $\zeta_1$. Dot colors: black means $\lambda = 1$, red means $\lambda = 5$, green means $\lambda = 10$ and blue means $\lambda = 15$." width="672" />
<p class="caption">(\#fig:optim-op-point-vary-lambda)Left panel: maximized wAFROC AUC was used to find optimal $\zeta_1$. Right panel: maximized Youden-index was used to find optimal $\zeta_1$. Dot colors: black means $\lambda = 1$, red means $\lambda = 5$, green means $\lambda = 10$ and blue means $\lambda = 15$.</p>
</div>


The left panel in \@ref(fig:optim-op-point-vary-lambda) shows the optimal operating points when wAFROC-AUC is maximized. The 4 operating points are color coded as follows:

* The black dot corresponds to $\lambda = 1$, i.e., $\lambda' = 1/2 = 0.5$. In other words, the true FROC is obtained by *shrinking* the plot shown, including the superposed black dot, along the x-axis by a factor of 2.  
* The red dot corresponds to $\lambda' = 2.5$. In other words, the true FROC is obtained by *magnifying* that shown, including the red dot, along the x-axis by a factor of 2.5.   
* The green dot corresponds to $\lambda' = 5$. 
* The blue dot corresponds to $\lambda' = 7.5$.  

These plots illustrate the previous comments, namely, as $\lambda$ increases, *the optimal operating point moves down the scaled curve*.

The right panel shows the optimal operating point when the Youden-index is maximized. It shows the same general features as the previous example but the group of four operating points in the right panel are below-left those in the left panel, representing higher values of optimal $\zeta_1$, i.e., a more stringent criteria. As seen in the preceding table the overly strict critera obtained using Youden-index based optimization, leads to lower true performance: i.e., lower wAFROC-AUC and lower ROC-AUC.


The FROC curve does not represent true performance. To visualize true performance one compares wAFROC curves.    








<div class="figure">
<img src="21-optim-op-point_files/figure-html/optim-op-point-vary-lambda-wafroc-1.png" alt="wAFROC curves for wAFROC-AUC and Youden-index based optimizations: both curves correspond to $\mu = 2$, $\nu = 1$ and $\lambda = 1$. The optimal reporting theshold $\zeta_1$ is determined by the selected FOM. The red curve corresponds to FOM = wAFROC-AUC and the blue curve corresponds to FOM = Youden-index. The stricter reporting threshold found by the Youden-index based method sacrifices a considerable amount of area under the wAFROC.  The two wAFROC-AUCs are 0.880 and 0.856, respectively." width="672" />
<p class="caption">(\#fig:optim-op-point-vary-lambda-wafroc)wAFROC curves for wAFROC-AUC and Youden-index based optimizations: both curves correspond to $\mu = 2$, $\nu = 1$ and $\lambda = 1$. The optimal reporting theshold $\zeta_1$ is determined by the selected FOM. The red curve corresponds to FOM = wAFROC-AUC and the blue curve corresponds to FOM = Youden-index. The stricter reporting threshold found by the Youden-index based method sacrifices a considerable amount of area under the wAFROC.  The two wAFROC-AUCs are 0.880 and 0.856, respectively.</p>
</div>


Each curve ends at the optimal threshold listed in Table \@ref(tab:optim-op-point-table1), namely $\zeta_1$ = -0.235 for the red curve and $\zeta_1$ = 0.802 for the blue curve. The lower performance represented by the blue curve, based on Youden-index maximization, is due to the adoption of an overly strict threshold.



### Vary nu {#optim-op-point-vary-nu}

For $\mu = 2$ and $\lambda= 5$, wAFROC-AUC and Youden-index based optimizations were performed for $\nu = 0.1,0.5,1,2$. Table \@ref(tab:optim-op-point-table2) summarizes the results. 















<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:optim-op-point-table2)Summary of optimization results for $\mu = 2$, $\lambda = 5$ and different values of $\nu$. The wAFROC column always displays wAFROC-AUC, even though the optimized quantity may the Youden-index, as in the last four rows.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> FOM </th>
   <th style="text-align:left;"> nu </th>
   <th style="text-align:left;"> zeta1 </th>
   <th style="text-align:left;"> wAFROC </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> OptOpPt </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 0.1 </td>
   <td style="text-align:left;"> 2.275 </td>
   <td style="text-align:left;"> 0.522 </td>
   <td style="text-align:left;"> 0.551 </td>
   <td style="text-align:left;"> (0.029, 0.071) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 0.5 </td>
   <td style="text-align:left;"> 1.376 </td>
   <td style="text-align:left;"> 0.660 </td>
   <td style="text-align:left;"> 0.771 </td>
   <td style="text-align:left;"> (0.211, 0.464) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 0.810 </td>
   <td style="text-align:left;"> 0.768 </td>
   <td style="text-align:left;"> 0.875 </td>
   <td style="text-align:left;"> (0.522, 0.763) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> -0.311 </td>
   <td style="text-align:left;"> 0.841 </td>
   <td style="text-align:left;"> 0.915 </td>
   <td style="text-align:left;"> (1.555, 0.971) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 0.1 </td>
   <td style="text-align:left;"> 1.336 </td>
   <td style="text-align:left;"> 0.473 </td>
   <td style="text-align:left;"> 0.588 </td>
   <td style="text-align:left;"> (0.227, 0.135) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 0.5 </td>
   <td style="text-align:left;"> 1.398 </td>
   <td style="text-align:left;"> 0.660 </td>
   <td style="text-align:left;"> 0.770 </td>
   <td style="text-align:left;"> (0.203, 0.459) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 1.438 </td>
   <td style="text-align:left;"> 0.750 </td>
   <td style="text-align:left;"> 0.842 </td>
   <td style="text-align:left;"> (0.188, 0.616) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 1.461 </td>
   <td style="text-align:left;"> 0.793 </td>
   <td style="text-align:left;"> 0.874 </td>
   <td style="text-align:left;"> (0.180, 0.692) </td>
  </tr>
</tbody>
</table>


Focusing on the wAFROC-AUC based optimizations (first four rows of table), it is seen that as $\nu$ increases: 

* The optimal threshold $\zeta_1$ decreases, resulting in more marks being reported; wAFROC-AUC increases; ROC-AUC increases and the optimal operating point on the FROC moves to higher LLF values, i.e., higher values of lesion-level "sensitivity".

All of these are opposite to the effect of increasing $\lambda$. The $\nu'$ binomial success probability parameter, defined in Eqn. \@ref(eq:rsm-intrinsic-physical), is the probability of a latent lesion localization (LL or "true-positive"). For example, for $\mu = 2$ and $\nu = 0.1$, $\nu' = 1 - \exp(-\mu \nu)$ = 0.1812692, i.e., an average of 18 percent of lesions present are found by the algorithm.   

Similar trends are observed for the Youden-index based optimizations (last four rows of table). Youden-index based optimizations (last four rows of table) compared to wAFROC-AUC based optimizations show that the former yields higher reporting thresholds, lower wAFROC-AUC, lower ROC-AUC and lower LLF values. 









<div class="figure">
<img src="21-optim-op-point_files/figure-html/optim-op-point-vary-nu-1.png" alt="Left panel: maximized wAFROC-AUC was used to find optimal $\zeta_1$. Right panel: maximized Youden-index was used to find optimal $\zeta_1$. Dot colors: black means $\nu = 0.1$, red means $\nu = 0.5$, green means $\nu = 1$ and blue means $\nu = 2$." width="672" />
<p class="caption">(\#fig:optim-op-point-vary-nu)Left panel: maximized wAFROC-AUC was used to find optimal $\zeta_1$. Right panel: maximized Youden-index was used to find optimal $\zeta_1$. Dot colors: black means $\nu = 0.1$, red means $\nu = 0.5$, green means $\nu = 1$ and blue means $\nu = 2$.</p>
</div>


Fig. \@ref(fig:optim-op-point-vary-nu) shows the FROC curves with optimal operating points superimposed. The left panel corresponds to wAFROC-AUC based optimizations while the right panel corresponds to Youden-index based optimizations. These illustrate the previous comments, namely, as $\nu$ increases, *the optimal operating point moves up the FROC curve*.


To visualize true performance one compares wAFROC curves.    






<div class="figure">
<img src="21-optim-op-point_files/figure-html/optim-op-point-vary-nu-wafroc-1.png" alt="wAFROC curves for wAFROC-AUC and Youden-index based optimizations: both curves correspond to $\mu = 2$, $\lambda = 5$ and $\nu = 2$. The optimal reporting theshold $\zeta_1$ is determined by the selected FOM. The red curve corresponds to FOM = wAFROC-AUC and the blue curve corresponds to FOM = Youden-index. The stricter reporting threshold found by the Youden-index based method sacrifices a considerable amount of area under the wAFROC.  The two wAFROC-AUCs are 0.841 and 0.793, respectively." width="672" />
<p class="caption">(\#fig:optim-op-point-vary-nu-wafroc)wAFROC curves for wAFROC-AUC and Youden-index based optimizations: both curves correspond to $\mu = 2$, $\lambda = 5$ and $\nu = 2$. The optimal reporting theshold $\zeta_1$ is determined by the selected FOM. The red curve corresponds to FOM = wAFROC-AUC and the blue curve corresponds to FOM = Youden-index. The stricter reporting threshold found by the Youden-index based method sacrifices a considerable amount of area under the wAFROC.  The two wAFROC-AUCs are 0.841 and 0.793, respectively.</p>
</div>


Each curve ends at the optimal threshold listed in Table \@ref(tab:optim-op-point-table2), namely $\zeta_1$ = -0.311 for the red curve and $\zeta_1$ = 1.461 for the blue curve. The lower performance represented by the blue curve, based on Youden-index maximization, is due to the adoption of an overly strict threshold. 





### Vary mu {#optim-op-point-vary-mu}

For $\nu = 1$ and $\lambda= 1$ wAFROC-AUC and Youden-index based optimizations were performed for 4 values of $\mu = 0.75,1,1.25,1.5$. Table \@ref(tab:optim-op-point-table2) summarizes the results.  














<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:optim-op-point-table3)Summary of optimization results for $\nu = 1$, $\lambda = 1$ and different values of $\mu$. The wAFROC column always displays wAFROC-AUC, even though the optimized quantity may the Youden-index, as in the last four rows.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> FOM </th>
   <th style="text-align:left;"> mu </th>
   <th style="text-align:left;"> zeta1 </th>
   <th style="text-align:left;"> wAFROC </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> OptOpPt </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 0.75 </td>
   <td style="text-align:left;"> 1.422 </td>
   <td style="text-align:left;"> 0.518 </td>
   <td style="text-align:left;"> 0.587 </td>
   <td style="text-align:left;"> (0.103, 0.132) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 0.310 </td>
   <td style="text-align:left;"> 0.603 </td>
   <td style="text-align:left;"> 0.745 </td>
   <td style="text-align:left;"> (0.378, 0.477) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 1.25 </td>
   <td style="text-align:left;"> -0.132 </td>
   <td style="text-align:left;"> 0.699 </td>
   <td style="text-align:left;"> 0.823 </td>
   <td style="text-align:left;"> (0.442, 0.654) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 1.5 </td>
   <td style="text-align:left;"> -0.268 </td>
   <td style="text-align:left;"> 0.777 </td>
   <td style="text-align:left;"> 0.875 </td>
   <td style="text-align:left;"> (0.404, 0.747) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 0.75 </td>
   <td style="text-align:left;"> 0.367 </td>
   <td style="text-align:left;"> 0.493 </td>
   <td style="text-align:left;"> 0.668 </td>
   <td style="text-align:left;"> (0.476, 0.343) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:left;"> 0.386 </td>
   <td style="text-align:left;"> 0.603 </td>
   <td style="text-align:left;"> 0.741 </td>
   <td style="text-align:left;"> (0.350, 0.462) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 1.25 </td>
   <td style="text-align:left;"> 0.461 </td>
   <td style="text-align:left;"> 0.691 </td>
   <td style="text-align:left;"> 0.802 </td>
   <td style="text-align:left;"> (0.258, 0.560) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 1.5 </td>
   <td style="text-align:left;"> 0.563 </td>
   <td style="text-align:left;"> 0.760 </td>
   <td style="text-align:left;"> 0.850 </td>
   <td style="text-align:left;"> (0.191, 0.641) </td>
  </tr>
</tbody>
</table>


As evident from Eqn. \@ref(eq:rsm-intrinsic-physical), increasing $\mu$, while holding $\lambda$ and $\nu$ constant, simultaneously decreases $\lambda'$ and increases $\mu'$. As the latter two parameters work in opposite directions (increasing one has a similar effect as decreasing the other) the simultaneous changes result in an amplified effect. The values in the table can be understood from this. 

Focusing on the wAFROC-AUC based optimizations (first four rows of table), it is seen that as $\mu$ increases the reporting threshold $\zeta_1$ decreases, both wAFROC-AUC and ROC-AUC increase, the FROC end-point moves to the upper left, and the optimal operating point moves to higher LLF values.


* From Table \@ref(tab:optim-op-point-table3) for the lowest value $\mu = 0.75$ the end-point of the FROC, corresponding to $\zeta_1 = -\infty$, is the farthest to the right and lowest in the vertical direction, and the optimal operating point is closest to the origin, i.e., (0.103, 0.132). wAFROC-AUC performance = 0.518 is least as is ROC-AUC = 0.587. ^[With even lower performance - achieved by choosing, for example, a smaller value of $\mu$, both wAFROC and ROC AUCs approach 0.5 and the optimal operating point is at the origin - basically the algorithm is so poor that none of its marks should be shown to the radiologist.] 

* As $\mu$ increases, the FROC end-point moves to the upper left and the optimal operating point moves up.

* At the highest value $\mu = 1.5$ the end-point of the FROC is the closest to (0,1), and the optimal operating point is farthest from the origin, i.e., (0.404, 0.747). wAFROC-AUC performance = 0.777 is greatest as is ROC-AUC = 0.875. With good performance one shows lower confidence level marks: $\zeta_1$ = -0.268 than is possible with poorer performance. With even higher values of $\mu$ both wAFROC and ROC AUCs approach 1 and the optimal operating point approaches (0,1) - the algorithm is so good that all of its marks should be shown to the radiologist. 

* At the lowest value $\mu = 0.75$ the end-point of the FROC is at (0.476, 0.343). wAFROC-AUC performance = 0.493 and ROC-AUC = 0.668, both of which are smaller than the values obtained using wAFROC-AUC maximization. 

* At the highest value $\mu = 1.5$ the end-point of the FROC at (0.191, 0.641). wAFROC-AUC performance = 0.760 and ROC-AUC = 0.850, both of which are smaller that the values obtained using wAFROC-AUC maximization. 

* TBA With one exception the operating points in the right panel are below-left (i.e., represent higher thresholds) those in the left panel. The Youden-index based optimization yields stricter reporting threshold. Somewhat paradoxically, for the lowest value of $\mu$ the method predicts a lenient threshold.  









Fig. \@ref(fig:optim-op-point-vary-mu) shows FROC curves with superimposed optimal operating points. 


<div class="figure">
<img src="21-optim-op-point_files/figure-html/optim-op-point-vary-mu-1.png" alt="Left panel: maximized wAFROC-AUC was used to find optimal $\zeta_1$. Right panel: maximized Youden-index was used to find optimal $\zeta_1$. Dot colors: black means $\mu = 0.75$, red means $\mu = 1$, green means $\lambda = 1.25$ and blue means $\mu = 1.5$." width="672" />
<p class="caption">(\#fig:optim-op-point-vary-mu)Left panel: maximized wAFROC-AUC was used to find optimal $\zeta_1$. Right panel: maximized Youden-index was used to find optimal $\zeta_1$. Dot colors: black means $\mu = 0.75$, red means $\mu = 1$, green means $\lambda = 1.25$ and blue means $\mu = 1.5$.</p>
</div>


For each of the four values of $\mu$ the left panel in Fig. \@ref(fig:optim-op-point-vary-mu) shows the optimal operating point when wAFROC-AUC is maximized. It shows the FROC curves with optimal operating points superimposed. These illustrate the previous comments, namely, as $\mu$ increases, *the optimal operating point moves up the FROC curve*.



The right panel in Fig. \@ref(fig:optim-op-point-vary-mu) shows the optimal operating point when the Youden-index is maximized. 



To visualize true performance one compares wAFROC curves.    






<div class="figure">
<img src="21-optim-op-point_files/figure-html/optim-op-point-vary-mu-wafroc-1.png" alt="wAFROC curves for wAFROC-AUC and Youden-index based optimizations: both curves correspond to $\lambda = 1$, $\nu = 1$ and $\mu = 1.5$. The optimal reporting theshold $\zeta_1$ is determined by the selected FOM. The red curve corresponds to FOM = wAFROC-AUC and the blue curve corresponds to FOM = Youden-index. The stricter reporting threshold found by the Youden-index based method sacrifices a considerable amount of area under the wAFROC. The two wAFROC-AUCs are 0.777 and 0.760, respectively." width="672" />
<p class="caption">(\#fig:optim-op-point-vary-mu-wafroc)wAFROC curves for wAFROC-AUC and Youden-index based optimizations: both curves correspond to $\lambda = 1$, $\nu = 1$ and $\mu = 1.5$. The optimal reporting theshold $\zeta_1$ is determined by the selected FOM. The red curve corresponds to FOM = wAFROC-AUC and the blue curve corresponds to FOM = Youden-index. The stricter reporting threshold found by the Youden-index based method sacrifices a considerable amount of area under the wAFROC. The two wAFROC-AUCs are 0.777 and 0.760, respectively.</p>
</div>


Each curve ends at the optimal threshold listed in Table \@ref(tab:optim-op-point-table3), namely $\zeta_1$ = -0.268 for the red curve, and $\zeta_1$ = 0.563 for the blue curve. The lower performance represented by the blue curve, based on Youden-index maximization, is due to the adoption of an overly strict threshold. 




## Using the method {#optim-op-point-how-to-use-method}
Assume that one has designed an algorithmic observer that has been optimized with respect to all other parameters except the reporting threshold. At this point the algorithm reports every suspicious region, no matter how low the malignancy index. The mark-rating pairs are entered into a `RJafroc` format Excel input file. The next step is to read the data file -- `DfReadDataFile()` -- convert it to an ROC dataset -- `DfFroc2Roc()` -- and then perform a radiological search model (RSM) fit to the dataset using function `FitRsmRoc()`. This yields the necessary $\lambda, \mu, \nu$ parameters. These values are used to perform the computations described in the embedded code in this chapter, see for example Section \@ref(optim-op-point-vary-lambda). This determines the optimal reporting threshold. The RSM parameter values and the reporting threshold determine the optimal reporting point on the FROC curve. The designer sets the algorithm to only report marks with confidence levels exceeding this threshold. 




## An application {#optim-op-point-application}

TBA Fit the LROC dataset to the RSM.


```r
ds <- datasetCadSimuFroc
dsCad <- DfExtractDataset(ds, rdrs = 1)
dsCadRoc <- DfFroc2Roc(dsCad)
dsCadRocBinned <- DfBinDataset(dsCadRoc, opChType = "ROC")
lesDistr <- c(1)
fit <- FitRsmRoc(dsCadRocBinned, lesDistr)
mu <- fit$mu
lambdaP <- fit$lambdaP
nuP <- fit$nuP
x <- UtilPhysical2IntrinsicRSM(mu, lambdaP, nuP)
lambda <- x$lambda
nu <- x$nu
```






Table \@ref(tab:optim-op-point-table4) summarizes the results.




<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>(\#tab:optim-op-point-table4)Summary of optimization results for example FROC dataset. The wAFROC column always displays wAFROC-AUC, even though the optimized quantity may the Youden-index, as in the last four rows.</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> FOM </th>
   <th style="text-align:left;"> lambda </th>
   <th style="text-align:left;"> zeta1 </th>
   <th style="text-align:left;"> wAFROC </th>
   <th style="text-align:left;"> ROC </th>
   <th style="text-align:left;"> OptOpPt </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> wAFROC </td>
   <td style="text-align:left;"> 18.680 </td>
   <td style="text-align:left;"> 1.739 </td>
   <td style="text-align:left;"> 0.774 </td>
   <td style="text-align:left;"> 0.815 </td>
   <td style="text-align:left;"> (0.278, 0.679) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Youden </td>
   <td style="text-align:left;"> 18.680 </td>
   <td style="text-align:left;"> 1.982 </td>
   <td style="text-align:left;"> 0.770 </td>
   <td style="text-align:left;"> 0.798 </td>
   <td style="text-align:left;"> (0.161, 0.627) </td>
  </tr>
</tbody>
</table>








Fig. \@ref(fig:optim-op-point-application-froc) shows FROC curves with superimposed optimal operating points. 


<div class="figure">
<img src="21-optim-op-point_files/figure-html/optim-op-point-application-froc-1.png" alt="Left panel: maximized wAFROC-AUC was used to find optimal $\zeta_1$. Right panel: maximized Youden-index was used." width="672" />
<p class="caption">(\#fig:optim-op-point-application-froc)Left panel: maximized wAFROC-AUC was used to find optimal $\zeta_1$. Right panel: maximized Youden-index was used.</p>
</div>





<div class="figure">
<img src="21-optim-op-point_files/figure-html/optim-op-point-application-wafroc-1.png" alt="Red line and dots: wAFROC-AUC based optimization; blue line and dots: Youden-index based optimization. The two wAFROC-AUCs are 0.774 and 0.770, respectively." width="672" />
<p class="caption">(\#fig:optim-op-point-application-wafroc)Red line and dots: wAFROC-AUC based optimization; blue line and dots: Youden-index based optimization. The two wAFROC-AUCs are 0.774 and 0.770, respectively.</p>
</div>



## Discussion {#optim-op-point-discussion}

Described is a method for finding the optimal operating point on an FROC curve. The method varies the reporting threshold to maximize the area under the wAFROC. An alternate method, based on maximization of the well-known Youden-index, was also tested. Both methods are illustrated using the radiological search model to parameterize the FROC data. In all cases studied the Youden-index based method selected a stricter reporting threshold than optimal, resulting in lower wAFROC-AUC as compared to wAFROC-AUC based optimization. In some situations the differences were relatively large. The results are illustrated using FROC curves, which are quite familiar to CAD designers. 

The method was applied to a quasi-FROC dataset created from an originally LROC dataset. For this dataset the optimized wAFROC-AUC was marginally superior to that using the Youden-index.  





## References {#optim-op-point-references}
