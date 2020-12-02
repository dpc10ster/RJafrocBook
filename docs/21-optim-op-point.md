# Optimal operating point on FROC {#optim-op-point}

---
output:
  rmarkdown::pdf_document:
    fig_caption: yes        
    includes:  
      in_header: R/learn/my_header.tex
---



## Introduction {#optim-op-point-intro}
Algorithm developers are familiar with this problem: given a CAD system that yields mark-rating data, where the ratings are on a continuous scale (often termed *malignancy index* and the continuous ratings are available to the CAD algorithm designer), how does one select an optimal reporting threshold? Only mark-rating data with ratings exceeding the optimal threshold are to be displayed to the radiologist.

* From the previous chapter it is evident that performance depends of $\zeta_1$, see \@ref(froc-vs-wafroc-peformance-depends-on-zeta1).

* It is taken as an axiomatic truth that *the optimal reporting threshold $\zeta_{\text{max}}$ is that value of $\zeta_1$ that maximizes the AUC under the wAFROC*.  

* This chapter examines the effect of changing the reporting threshold $\zeta_1$ on the wAFROC AUC, with the object of determining the value that maximizes the AUC.



## Methods {#optim-op-point-methods}

The aim is determine the optimal operating point on an FROC. Two values of the $\lambda$ parameter are considered: $\lambda = 10$ and $\lambda = 1$. The first value would characterize a CAD system that generates about 10 times the number of latent NL marks as an expert radiologist, while the second value would characterize a CAD system that generates about the same number of latent NL marks as an expert radiologist. The $\nu$ parameter is kept at the same, namely $\nu = 1$. Four values of the $\mu$ parameter are considered: 1, 1.5, 2, 2.5. All else being equal, performance is expected to improve with increasing $\mu$. 

For each $\mu$ one scans a range of values of $\zeta_1$. For each $\zeta_1$ one calculates the area under the wAFROC curve - using function `UtilAnalyticalAucsRSM()`. This returns the wAFROC AUC for chosen values of parameters ($\mu$, $\lambda$, $\nu$, $\zeta_1$, and two other parameters specifying the distribution of numbers of lesions per diseased case and their weights). Repeating the procedure for different values of $\zeta_1$ one determines the value $\zeta_{\text{max}}$ that maximizes AUC -- denoted $\zeta_{\text{max}}$. Finally, using $\zeta_{\text{max}}$ one calculates the corresponding (NLF,LLF) values on the FROC and the optimal wAFROC AUC. 


### $\zeta_1$ optimization for $\lambda = 10$

Shown next is the variation of wAFROC AUC vs. $\zeta_1$ for $\lambda = 10$ and the four values of the $\mu$ parameter.


```r
# determine plotArr[[1,]], zetaMaxArr[1,] and maxFomArr[1,]
lambda <- 10
nu <- 1
mu_arr <- c(1, 1.5, 2, 2.5)
maxFomArr <- array(dim = c(2,length(mu_arr)))
zetaMaxArr <- array(dim = c(2, length(mu_arr)))
plotArr <- array(list(), dim = c(2, length(mu_arr)))
lesDistr <- Convert2lesDistr(c(0.5, 0.5))
relWeights <- c(0.5, 0.5)
for (i in 1:length(mu_arr)) {
  # if (i == 1) zeta1Arr <- seq(1.5,3.5,0.05) else zeta1Arr <- seq(0.5,2.5,0.1)
  if (i == 1) zeta1Arr <- seq(0.0,2.0,0.05) else zeta1Arr <- seq(0.0,2.0,0.1)
  x <- do_one_mu (mu_arr[i], lambda, nu, zeta1Arr, lesDistr, relWeights)
  plotArr[[1,i]] <- x$p + ggtitle(paste0("mu = ", as.character(mu_arr[i]), ", zetaMax = ",  format(x$zetaMax, digits = 3)))
  zetaMaxArr[1,i] <- x$zetaMax
  maxFomArr[1,i] <- x$maxFom
  # plotArr[[2,i]] etc. reserved for lambda = 1 results, done later
}
```


One sets $\lambda = 10$, $\nu = 1$ and $\mu$ to successive values 1, 1.5, 2 and 2.5. Diseased cases with one or two lesions, with equal probability (`lesDistr`), and equally weighted lesions are assumed (`relWeights`). The `plotArr` list contains the generated plots (`x$p` plus a title sting) of wAFROC AUC vs. $\zeta_1$, `zetaMaxArr` contains the value of $\zeta_1$ that maximizes wAFROC AUC (`x$zetaMax`) and `maxFomArr` contains the maximum achieved value of wAFROC AUC for each value of $\mu$ (`x$maxFom`). The first dimension of the arrays is reserved for the two values of $\lambda$. In the above code this index is set to 1, corresponding to $\lambda = 10$.


![(\#fig:optim-op-point-AUC-vs-zeta1-10)Variation of AUC vs. $\zeta_1$ for $\lambda = 10$; AUC is the wAFROC AUC. panels are labeled by the value of $\mu$ and zetaMax (i.e., $\zeta_{\text{max}}$, the value of $\zeta_1$ that maximizes AUC).](21-optim-op-point_files/figure-latex/optim-op-point-AUC-vs-zeta1-10-1.pdf) 


Fig. \@ref(fig:optim-op-point-AUC-vs-zeta1-10) corresponding to $\lambda = 10$ has four panels showing the variation of wAFROC AUC with $\zeta_1$. Each panel is labeled by the values of $\mu$ and  $\zeta_{\text{max}}$. For example, the panel labeled `mu = 1.5, zetaMax = 1.9` shows that AUC has a maximum at $\zeta_1 = 1.9$. For $\mu = 1$ the maximum is at the top of a broad plateau, but for higher values the maximum is better defined.


### $\zeta_1$ optimization for $\lambda = 1$

Shown next is the variation of wAFROC AUC vs. $\zeta_1$ for $\lambda = 1$ and the four values of the $\mu$ parameter.





![(\#fig:optim-op-point-AUC-vs-zeta1-01)Variation of AUC vs. $\zeta_1$ for $\lambda = 1$.](21-optim-op-point_files/figure-latex/optim-op-point-AUC-vs-zeta1-01-1.pdf) 

Fig. \@ref(fig:optim-op-point-AUC-vs-zeta1-01) corresponds to $\lambda = 1$ and employs a similar labeling scheme as Fig. \@ref(fig:optim-op-point-AUC-vs-zeta1-10). For example, the panel labeled `mu = 1, zetaMax = 0.3` shows that AUC has a maximum at $\zeta_1 = 0.3$. 


















### Summary of simulations and comments {#optim-op-point-comments-threshold-optimization}


\begin{table}

\caption{(\#tab:optim-op-point-cad-optim-table)Summary of optimal threshold values: "measure" refers to a performance measure, "mu1" refers to $\mu = 1$, etc. The row labels are as follows: AUC10 is the wAFROC AUC for lambda = 10, AUC01 is the wAFROC AUC for $\lambda = 1$, NLF10 is NLF for $\lambda = 10$, ..., LLF01 is LLF for $\lambda = 1$.}
\centering
\begin{tabular}[t]{l|r|r|r|r}
\hline
measure & mu1 & mu1.5 & mu2 & mu2.5\\
\hline
AUC10 & 0.60040 & 0.72508 & 0.84125 & 0.91996\\
\hline
AUC01 & 0.76760 & 0.87837 & 0.93851 & 0.96879\\
\hline
NLF10 & 5.00000 & 3.33333 & 2.50000 & 2.00000\\
\hline
LLF10 & 0.53183 & 0.72497 & 0.84499 & 0.91222\\
\hline
NLF01 & 0.84134 & 0.56090 & 0.42067 & 0.33654\\
\hline
LLF01 & 0.61774 & 0.77205 & 0.86350 & 0.91770\\
\hline
\end{tabular}
\end{table}

Table \@ref(tab:optim-op-point-cad-optim-table) summarizes the results of the simulations. In this table the first two rows compare the AUCs for $\lambda=10$ and $\lambda=1$ for the four values of $\mu$. The next two rows show the operating point (NLF, LLF) for $\lambda = 10$ for the four values of $\mu$ and the final two rows are the operating point for $\lambda = 1$ for the four values of $\mu$. The following trends are evident.

* All else being equal, AUC increases with increasing $\mu$. Increasing the separation of the two unit variance normal distributions that determine the ratings of NLs and LLs leads to higher performance.
* All else being equal, AUC increases with *decreasing* $\lambda$. Decreasing the tendency of the observer to generate NLs leads to increasing performance.
* For each value of $\lambda$ optimal LLF increases with increasing $\mu$.
* For $\lambda = 10$ optimal NLF increases with increasing $\mu$.
* For $\lambda = 1$ optimal NLF *peaks* around $\mu = 1.5$.

All of these observations make intuitive sense except, perhaps, that for NLF01. To understand the peaking behavior it is necessary to examine the FROC curves corresponding to the eight -- two $\lambda$ values times four $\mu$ values -- combinations of parameters. In the following eight plots, each labeled by the appropriate $\lambda-\mu$ combination, the optimal value of NLF, corresponding to $\zeta_1 = \zeta_{\text{max}}$, is shown as a blue vertical line.

#### Explanations {#optim-op-point-threshold-explanations}


```
#> Warning: Removed 26 row(s) containing missing values (geom_path).
```

![(\#fig:optim-op-point-froc-10-first-two-plots)Extended FROC plots: panel labeled 10-1 is for $\lambda = 10$ and $\mu = 1$, and that labeled 10-1.5 is for $\lambda = 10$ and $\mu = 1.5$. The blue line indicates the optimal operating point.](21-optim-op-point_files/figure-latex/optim-op-point-froc-10-first-two-plots-1.pdf) 


* In Fig. \@ref(fig:optim-op-point-froc-10-first-two-plots) panel labeled **10-1** is the *extended* FROC curve for $\lambda = 10$ and $\mu = 1$. The vertical blue line is drawn at the optimal NLF corresponding to $\zeta_{\text{max}}$ for this parameter combination.  

* Note the "magnified view" scale factors chosen for Fig. \@ref(fig:optim-op-point-froc-10-first-two-plots) panel labeled **10-1**. The x-axis runs from 0 to 0.03 while the y-axis runs from 0 to 0.1. Otherwise this curve would be almost indistinguishable from the x-axis. 

* In order to show a fuller extent of the FROC curve it is necessary to *extend* the curves beyond the *optimal* end-points. This was done by setting $\zeta_1$ = $\zeta_{\text{max}} - 0.5$, which has the effect of letting the curve run a little bit further to the right. As an example the *optimal* end-point for the curve in Fig. \@ref(fig:optim-op-point-froc-10-first-two-plots) labeled **10-1** is (NLF = 5, LLF = 0.532) while the *extended* end-point is (NLF = 6.9146246, LLF = 0.5898904). The *highest* operating point, that reached when all marks are reported, is at (NLF = 10, LLF = 0.632). This point lies about a factor 300 to the right of the displayed curve and about a factor of six higher along the y-axis. It vividly illustrates a low-performing FROC curve.

* In Fig. \@ref(fig:optim-op-point-froc-10-first-two-plots) panel labeled **10-1.5**: the vertical blue line is at NLF = 3.33 and the corresponding LLF is 0.725. The end-point of the extended curve is (NLF = 4.61, LLF = 0.759). The highest operating point, that reached when all marks are reported, is at (NLF = 6.67, LLF = 0.777). 


![(\#fig:optim-op-point-froc-10-next-two-plots)Extended FROC plots: panel labeled 10-2 is for $\lambda = 10$ and $\mu = 2$ and that labeled 10-2.5 is for $\lambda = 10$ and $\mu = 2.5$. The blue line indicates the optimal operating point.](21-optim-op-point_files/figure-latex/optim-op-point-froc-10-next-two-plots-1.pdf) 



* In Fig. \@ref(fig:optim-op-point-froc-10-next-two-plots) panel labeled **10-2**: The vertical blue line is at NLF = 2.5 corresponding to LLF = 0.845. The end-point of the extended curve is (NLF = 3.46, LLF = 0.859). The highest operating point, that reached when all marks are reported, is at (NLF = 5, LLF = 0.865). 

* In Fig. \@ref(fig:optim-op-point-froc-10-next-two-plots) panel labeled **10-2.5**: The vertical blue line is at NLF = 2 corresponding to LLF = 0.912. The end-point of the extended curve is (NLF = 2.77, LLF = 0.917). The highest operating point, that reached when all marks are reported, is at (NLF = 4, LLF = 0.918). 


* In Fig. \@ref(fig:optim-op-point-froc-10-first-two-plots) panel labeled **10-1**, AUC performance is quite low. In fact AUC = 0.6003995 (note that we are using the wAFROC FOM, whose minimum value is 0, not 0.5). The optimal operating point of the algorithm is close to the origin, specifically NLF = 5 and LLF = 0.532. Since algorithm performance is so poor, the sensible choice for the algorithm designer is to only show those marks that have, according to the algorithm, very high confidence level for being right (an operating point near the origin corresponds to a high value of $\zeta$).

* For higher values of $\mu$ shown in Fig. \@ref(fig:optim-op-point-froc-10-first-two-plots) and Fig. \@ref(fig:optim-op-point-froc-10-next-two-plots) -- e.g., panels labeled **10-1.5, 10-2 and 10-2.5** -- AUC performance progressively increases. It now makes sense for the algorithm designer to show marks with lower confidence levels, corresponding to moving up the FROC curve. While it is true that one is also showing more NLs, the increase in the number of LLs compensates -- upto a point -- showing marks beyond the optimal point would result in decreased performance, see for example the plots in Fig. \@ref(fig:optim-op-point-AUC-vs-zeta1-10).


![(\#fig:optim-op-point-froc-01-first-two-plots)Extended FROC plots: panel labeled 1-1 is for $\lambda = 1$ and $\mu = 1$ and that labeled 10-1.5 is for $\lambda = 1$ and $\mu = 1.5$. The blue line indicates the optimal operating point.](21-optim-op-point_files/figure-latex/optim-op-point-froc-01-first-two-plots-1.pdf) 


* In Fig. \@ref(fig:optim-op-point-froc-01-first-two-plots) panel labeled **1-1**: The vertical blue line is at NLF = 0.841 corresponding to LLF = 0.618. The end-point of the extended curve is (NLF = 0.933, LLF = 0.628). The highest operating point is at (NLF = 1, LLF = 0.632). 

* In Fig. \@ref(fig:optim-op-point-froc-01-first-two-plots) panel labeled **1-1.5**: The vertical blue line is at NLF = 0.561 corresponding to LLF = 0.772. The end-point of the extended curve is (NLF = 0.622, LLF = 0.776). The highest operating point is at (NLF = 0.667, LLF = 0.777). 

* It remains to explain the seemingly anomalous behavior seen in the fifth row of Table \@ref(tab:optim-op-point-cad-optim-table) - i.e., NLF peaks at $\mu = 1.5$ and thereafter NLF decreases. The relevant FROC curve is shown in Fig. \@ref(fig:optim-op-point-froc-01-first-two-plots), panel labeled **1-1.5**. The reason is that as $\mu$ increases, the end-point of the FROC keeps moving upwards and to the left, approaching NLF = 0 and LLF = 1 in the limit of infinite $\mu$. Consequently, the expected increase in NLF is cut short or terminated - *one literally runs out of FROC curve to move up on*. Another way of explaining this is that in Fig. \@ref(fig:optim-op-point-froc-01-first-two-plots) panel labeled **1-1** the abscissa of the highest operating point, which equals 1, is further to the right than in Fig. \@ref(fig:optim-op-point-froc-01-first-two-plots) panel labeled **1-1.5**, where the corresponding abscissa equals 0.667. This allows NLF to "access" larger values in Fig. \@ref(fig:optim-op-point-froc-01-first-two-plots) panel labeled **1-1** than in Fig. \@ref(fig:optim-op-point-froc-01-first-two-plots) panel labeled **1-1.5**. Moving to higher values of $\mu$, as in \@ref(fig:optim-op-point-froc-01-next-two-plots) panels labeled **1-2** and **1-2.5**, further illustrates this effect. In the panel labeled **1-2** the maximum abscissa is at 0.5 while in the panel labeled **1-2.5** the abscissa is at 0.4.

* Fig. \@ref(fig:optim-op-point-froc-01-next-two-plots) panel labeled **1-2.5** might help one better understand the need for an optimal operating point. In moving from the optimal abscissa, namely 0.337 to the maximum abscissa 0.4 one picks ups 0.000214 in LLF, a negligible amount compared to the increase in NLF, namely from 0.337 to 0.4.


* The explanations in terms of operating points may seem tedious, and indeed they are, which is the reason for choosing a scalar figure of merit, such as the AUC under the wAFROC curve for the optimization. The latter approach obviates convoluted explanations in terms of how much additional or fewer LLs or NLs occur as a result of a change in operating point.


![(\#fig:optim-op-point-froc-01-next-two-plots)Extended FROC plots: panel labeled 1-2 is for $\lambda = 1$ and $\mu = 2$ and that labeled 1-2.5 is for $\lambda = 1$ and $\mu = 2.5$. The blue line indicates the optimal operating point.](21-optim-op-point_files/figure-latex/optim-op-point-froc-01-next-two-plots-1.pdf) 



* In Fig. \@ref(fig:optim-op-point-froc-01-next-two-plots) panel labeled **1-2**: The vertical blue line is at NLF = 0.421 corresponding to LLF = 0.863. The end-point of the extended curve is (NLF = 0.467, LLF = 0.864). The highest operating point is at (NLF = 0.5, LLF = 0.865). 


* In Fig. \@ref(fig:optim-op-point-froc-01-next-two-plots) panel labeled **1-2.5**: The vertical blue line is at NLF = 0.337 corresponding to LLF = 0.918. The end-point of the extended curve is (NLF = 0.373, LLF = 0.918). The highest operating point is at (NLF = 0.4, LLF = 0.918). 



## How to use the method {#optim-op-point-how-to-use-method}
Assume that one has designed an algorithmic observer that has been optimized with respect to all other parameters except the reporting threshold. At this point the algorithm reports every suspicious region no matter how low the malignancy index. The mark-rating pairs are entered into a `RJafroc` format Excel input file. The next step is to read the data file -- `DfReadDataFile()` -- convert it to an ROC dataset -- `DfFroc2Roc()` -- and then perform a radiological search model (RSM) fit to the dataset using function `FitRsmRoc()`. This yields the necessary $\lambda, \mu, \nu$ parameters. These values are used to perform the simulations described in the embedded code in this chapter, i.e., that leading to, for example, one of the panels in Fig. \@ref(fig:optim-op-point-AUC-vs-zeta1-01). This determines the optimal reporting threshold: essentially, one scans $\zeta_1$ values looking for maximum in wAFROC AUC -- calculated using `UtilFigureOfMerit()`. This determines the optimal value of $\zeta_1$, namely $\zeta_{\text{max}}$. The RSM parameter values and $\zeta_{\text{max}}$ determine NLF, the optimal reporting point on the FROC curve. The designer sets the algorithm to only report marks with confidence levels exceeding $\zeta_{\text{max}}$.  



## Discussion {#optim-op-point-Discussion}
By selecting the area under the ROC curve one could have performed a similar optimization. One could use this method to select the optimal operating point on the ROC for a radiologist. 

## References {#optim-op-point-references}
