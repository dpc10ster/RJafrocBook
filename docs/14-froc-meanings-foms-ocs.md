# Meanings of FROC figures of merit {#froc-meanings}




## This chapter is in progress {#froc-meanings-intro1}
As of 10/6/20

## Introduction {#froc-meanings-intro}
The previous chapter focused on empirical *plots* possible with FROC data. Examples are the FROC, AFROC, wAFROC, inferred ROC, etc. Expressions were given for computing operating points for each plot. Because of the ambiguity in interpreting sensitivity-specificity pairs in ROC analysis, operating points should almost never be used as figures of merit. Rather one should focus on area measures derived from operating characteristics. 

In this chapter, the empirical area under a plot is generically denoted $A_{oc}$, where the "oc" subscript denotes the applicable operating characteristic. For example, the area under the empirical weighted-AFROC is denoted $A_{\text{wAFROC}}$. Calculating areas from operating points using planimetry or geometry is tedious. Needed are formulae for calculating them directly from ratings. An example of this was encountered before in TBA Chapter 05, where it was shown that the area under the empirical ROC plot $A_{\text{ROC}}$ equaled the Wilcoxon statistic. 

A distinction is being made between *empirical AUC under a plot*, i.e., an area measure, and an *FOM-statistic*, generically denoted $\theta$, that is computed directly from the ratings. The FOM-statistic is a scalar function of the ratings intended to quantify performance. While any function of the ratings is a possible FOM-statistic, whether a proposed function is useful depends upon whether it can be related to the area under a meaningful operating characteristic. This chapter derives formulae for FOM-statistics $\theta_{\text{oc}}$, which yield the same values as the empirical areas $A_{\text{oc}}$ under the corresponding empirical operating characteristics. The meanings of these FOM-statistics are discussed1. 

Here is the organization of the chapter. Expressions for the empirical AFROC FOM-statistic $\theta_{\text{AFROC}}$ and the empirical weighted-AFROC FOM-statistic $\theta_{\text{wAFROC}}$ are presented and their limiting values for chance-level and perfect performances are explored. Two important theorems are stated, whose proofs are in Online Appendix 14.A. The first theorem proves the equality between the empirical wAFROC FOM-statistic $\theta_{\text{wAFROC}}$ and the area $A_{\text{wAFROC}}$ under the empirical wAFROC plot. A similar equality applies to the empirical AFROC FOM-statistic $\theta_{\text{AFROC}}$ and the area $A_{\text{AFROC}}$ under the empirical AFROC plot. The second theorem derives an expression for the area under the straight-line extension of the wAFROC (or AFROC) from the observed end-point to (1,1), and explains why it is essential to include this area. A section explaining, with a small simulated-dataset, how NL and LL ratings and lesion weights determine the AFROC and wAFROC empirical plots follows. It shows explicitly that the wAFROC gives equal importance to all diseased cases, a desirable statistical characteristic, while the AFROC gives excessive importance to cases with more lesions. The small numbers of cases makes the explanations easier to follow and permits "hand-calculation" of the operating points. This is followed by physical interpretation of the corresponding AUCs / FOM-statistics. It shows explicitly how the comparisons implied in FOM-statistic properly credit and penalize the observer for correct and incorrect decisions, respectively. This section gives probabilistic meanings to the AFROC and wAFROC AUCs.  

Detailed derivations of FOM-statistics applicable to the areas under the empirical FROC plot, the AFROC1 and wAFROC1 plots are not given. Instead, the results for all plots are summarized in TBA Online Appendix 14.C, which shows that the definitions "work", i.e., the FOM-statistics yield the correct areas as determined by numerical integrations.


## Empirical AFROC FOM-statistic
The empirical AFROC AUC was defined in §13.4.2 as the area under the empirical AFROC. The corresponding FOM-statistic   is defined2 in terms of a quasi-Wilcoxon statistic  by (the kernel function   was defined in Eqn. (5.10)):

\begin{equation} 
\theta_{\text{AFROC}}=\frac{1}{K_1 L_T}\sum_{k_1=1}^{K_1}\sum_{k_2=1}^{K_2}\sum_{l_2=1}^{L_{k_2}}\psi\left ( max_{l_1}\left ( z_{k_1 1 l_1 1} \mid z_{k_1 1 l_1 1} \geq \zeta_1\right ), z_{k_2 2 l_2 2} \right )
(\#eq:froc-meanings-theta-afroc)
\end{equation}


FROC notation was summarized in Table \@ref(tab:froc-paradigm-frocNotation). The conditioning $z_{k_1 1 l_1 1} \geq \zeta_1$ ensures that only marked regions contribute to $\theta_{\text{AFROC}}$. [In Chapter \@ref(froc-paradigm-empirical-plots), the relevant formulae ensured that only marked regions contributed to operating points. A similar requirement needs to be imposed in expressions for FOM-statistics.] 

The FOM-statistic $\theta_{\text{AFROC}}$ achieves its highest value, unity, if and only if every lesion is rated higher than every mark on every non-diseased case, for then the $\psi$ function always yields unity, and the summations yield :

\begin{equation}
\left. 
\begin{aligned}
\theta_{\text{AFROC}}=& \frac{1}{K_1 \sum_{k_2=1}^{K_2}L_{k_2}}\sum_{k_1=1}^{K_1}\sum_{k_2=1}^{K_2}\sum_{l_2=1}^{L_{k_2}}  1 \\
= & \frac{1}{K_1 \sum_{k_2=1}^{K_2}L_{k_2}}\sum_{k_1=1}^{K_1}\sum_{k_2=1}^{K_2}L_{k_2} \\
= & \frac{1}{K_1}\sum_{k_1=1}^{K_1}1\\
= & 1
\end{aligned}
\right \}
(\#eq:froc-meanings-theta-afroc-unity)
\end{equation}


If, on the other hand, every lesion is rated lower than every mark on every non-diseased case, the $\psi$ function yields zero, and the FOM-statistic is zero. Therefore,

\begin{equation}
0 \leq \theta_{\text{AFROC}} \leq 1
(\#eq:froc-meanings-theta-afroc-limits)
\end{equation}


Eqn. \@ref(eq:froc-meanings-theta-afroc-limits) shows that $\theta_{\text{AFROC}}$ behaves like a probability but its range is *twice* that of $\theta_{\text{ROC}}$; recall that $0.5 \leq \theta_{\text{ROC}} \leq 1$. This has the consequence that treatment or modality related differences between $\theta_{\text{AFROC}}$ (i.e., effect sizes) are larger relative to the corresponding ROC effect sizes (just as temperature differences in the Fahrenheit scale are larger than the same differences expressed in the Celsius scale). This has important implications for FROC sample size estimation, Chapter TBA. 


This is explained further in Chapter 18. Eqn. (14.3) is another reason why the "chance diagonal" of the AFROC corresponding to AUC = 0.5, does not reflect chance-level performance. An area under the AFROC equal to 0.5 is actually reasonable performance, being smack in the middle of the allowed range. An example of this was given in §13.4.2.2 for the case of an expert radiologist who does not mark any cases. 


## Empirical weighted-AFROC FOM-statistic 
The empirical weighted-AFROC plot and lesion weights were defined in TBA §13.7. The empirical weighted-AFROC FOM-statistic [@RN1385] is defined in terms of a quasi-Wilcoxon statistic:


\begin{equation} 
\theta_{\text{wAFROC}}=\frac{1}{K_1 K_2}\sum_{k_1=1}^{K_1}\sum_{k_2=1}^{K_2}\sum_{l_2=1}^{L_{k_2}}W_{k_2 l_2}\psi\left ( max_{l_1}\left ( z_{k_1 1 l_1 1} \mid z_{k_1 1 l_1 1} \geq \zeta_1\right ), z_{k_2 2 l_2 2} \right )
(\#eq:froc-meanings-theta-wafroc)
\end{equation}


The weights obey the constraint:


\begin{equation} 
\sum_{l_2=1}^{L_{k_2}}W_{k_2 l_2} = 1
(\#eq:froc-meanings-theta-constraint-weights)
\end{equation}


In the special case of one lesion per diseased case, $\theta_{\text{AFROC}}$ and $\theta_{\text{wAFROC}}$ are identical. However, for more than one lesion per diseased case, they are not. For equally weighted lesions,  

\begin{equation} 
W_{k_2 l_2} = \frac{1}{L_{k_2}}
(\#eq:froc-meanings-theta-equal-weights)
\end{equation}


For example, for equally weighted lesions, for a case with three lesions, each weight equals one-third (1/3).



## Two Theorems
The area $A_{\text{wAFROC}}$ under the wAFROC plot is obtained by summing the areas of individual trapezoids defined by drawing vertical lines from each pair of adjacent operating points to the x-axis. A sample plot is shown Fig. \@ref(fig:froc-meanings-theorems). 




![(\#fig:froc-meanings-theorems)An example wAFROC plot; from left to right, the two shaded areas correspond to $A_i$ and  $A_0$, respectively, defined below.](14-froc-meanings-foms-ocs_files/figure-latex/froc-meanings-theorems-1.pdf) 


The operating point labeled $i$ has coordinates $\left (  \text{FPF}_i, \text{wLLF}_i \right )$ given by Eqn. \@ref(eq:froc-paradigm-FPF) and Eqn. \@ref(eq:froc-paradigm-wLLFr), respectively, reproduced here for convenience:  

\begin{equation}
\left.
\begin{aligned} 
FPF_i \equiv FPF \left ( \zeta_i \right ) =& \frac{1}{K_1} \sum_{k_1=1}^{K_1} \mathbb{I} \left ( FP_{k_1 1} \geq \zeta_i\right )\\
=& \frac{1}{K_1} \sum_{k_1=1}^{K_1} \mathbb{I} \left ( \max_{l_1}\left ( z_{k_1 1 l_1 1}  \mid z_{k_1 1 l_1 1} \geq \zeta_i  \right )\right )\\
\end{aligned}
\right \}
(\#eq:froc-meanings-FPF)
\end{equation}


\begin{equation}
\text{wLLF}_i \equiv \text{wLLF}_{\zeta_i} = \frac{1}{K_2}\sum_{k_2=1}^{K_2}\sum_{l_2=1}^{L_{k_2}}W_{k_2 l_2} \mathbb{I}\left ( z_{k_2 l_2 2} \geq \zeta_i \right )
(\#eq:froc-meanings-wLLFi)
\end{equation}


As usual, the summation in Eqn. \@ref(eq:froc-meanings-FPF) is conditioned on marked NLs. The conditioning is unnecessary for LLs. 

TBA Online Appendix 14.A proves the following theorems: 


### Theorem 1
The area $A_{\text{wAFROC}}$ under the empirical wAFROC plot equals the weighted-AFROC FOM-statistic $\theta_{\text{wAFROC}}$ defined by Eqn. \@ref(eq:froc-meanings-theta-wafroc):

\begin{equation}
\theta_{\text{wAFROC}} = A_{\text{wAFROC}}
(\#eq:froc-meanings-theorem1)
\end{equation}


This is the FROC counterpart of Bamber's Wilcoxon vs. empirical ROC area equivalence theorem [@RN2174], derived in Chapter TBA 05.  

### Theorem 2
The area $A_0$ under the straight-line extension of the wAFROC from the observed end-point $\left ( \text{FPF}_1, \text{wLLF}_1 \right )$ to (1,1) is given by:

\begin{equation}
A_0 = \frac{\left ( 1 - \text{FPF}_1 \right )\left ( 1 + \text{wLLF}_1 \right )}{2}
(\#eq:froc-meanings-A0)
\end{equation}


According to Eqn. \@ref(eq:froc-meanings-A0), $A_0$ increases as $\text{FPF}_1$ decreases, i.e., as more non-diseased cases are *not marked* and as $\text{wLLF}_1$ increases, i.e., as more lesions, especially those with greater weights, *are marked*. Both observations are in keeping with the behavior of a valid FOM. 


**Failing to include the area under the straight-line extension results in not counting the positive contribution to the FOM of unmarked cases, each of which represents a perfect decision. For an optimal observer whose operating characteristic is the vertical line from (0,0) to (0,1) followed by the horizontal line from (0,1) to (1,1), the area under the straight-line extension comprises the entire AUC for the wAFROC. Excluding it would yield zero AUC for an optimal observer, which is obviously incorrect.**


## Understanding the AFROC and wAFROC empirical plots

```{.r .numberLines}
seed <- 1;set.seed(seed)
K1 <- 4;K2 <- 4
L_max <- 2;Lk2 <- ceiling(runif(K2) * L_max) 
mu <- 2;lambda <- 1;nu <- 1 ;zeta1 <- -1
frocData <- SimulateFrocDataset(
  mu = mu, 
  lambda = lambda, 
  nu = nu,
  zeta1 = zeta1,
  I = 1, 
  J = 1, 
  K1 = K1, 
  K2 = K2, 
  perCase = Lk2)

FP <- apply(frocData$ratings$NL, 3, max)
FP <- FP[1:K1]
frocData$lesions$weights[3, ] <- c(0.6, 0.4)
frocData$lesions$weights[4, ] <- c(0.4, 0.6)

p1 <- PlotEmpiricalOperatingCharacteristics(
  frocData,trts = 1, 
  rdrs = 1, 
  opChType = "AFROC", 
  legend.position = "NULL")
p1 <- p1$Plot + ggtitle("A")

p2 <- PlotEmpiricalOperatingCharacteristics(
  frocData,
  trts = 1, 
  rdrs = 1, 
  opChType = "wAFROC", 
  legend.position = "NULL")
p2 <- p2$Plot + ggtitle("B")

cat("AFROC AUC = ", as.numeric(UtilFigureOfMerit(frocData, FOM = "AFROC")),"\n")
#> AFROC AUC =  0.7708333
```

```{.r .numberLines}
cat("wAFROC AUC = ", as.numeric(UtilFigureOfMerit(frocData, FOM = "wAFROC")),"\n")
#> wAFROC AUC =  0.7875
```


![(\#fig:froc-meanings-linearPlot-wafroc)Left: AFROC plot; right: corresponding wAFROC plot.](14-froc-meanings-foms-ocs_files/figure-latex/froc-meanings-linearPlot-wafroc-1.pdf) 


Parameters of the following simulation are $\mu = 2$, $\lambda = 1$, $\nu = 1$, $\zeta_1 = -1$  and $L_{max} = 2$. It simulates a dataset consisting of $K_1 = 4$ non-diseased cases and $K_2 = 4$ diseased cases. The first two diseased cases have one lesion each, and the remaining two have two lesions each. 


```r
Lk2
#> [1] 1 1 2 2
```

Let us examine the ratings.



```r
frocData$ratings$NL[1,1,,]
#>            [,1]      [,2]
#> [1,]       -Inf      -Inf
#> [2,]  0.4874291      -Inf
#> [3,]  0.7383247 0.5757814
#> [4,] -0.3053884      -Inf
#> [5,]  1.5117812      -Inf
#> [6,]       -Inf      -Inf
#> [7,]       -Inf      -Inf
#> [8,]       -Inf      -Inf
frocData$ratings$LL[1,1,,]
#>            [,1]    [,2]
#> [1,]  0.8523430    -Inf
#> [2,] -0.2146999    -Inf
#> [3,]  1.5884892    -Inf
#> [4,]  2.9438362 1.98381
```


The length of the third dimension of the NL array is eight (4 non-diseased + 4 diseased cases). The fifth sequential case corresponds to NLs on the first diseased case, etc. The simulated z-samples displayed in §14.5.2 are shown in Table \@ref(tab:froc-meanings-table-non-diseased) for non-diseased and in Table \@ref(tab:froc-meanings-table-diseased) for diseased cases. The columns labeled   list the case-location indexing subscripts, the columns labeled   list the corresponding z-samples, when realized and otherwise NAs are listed. Column 5 in Table \@ref(tab:froc-meanings-table-non-diseased) illustrates the conversion of the NL z-samples to FP z-samples according to the highest-rating assumption (the first non-diseased case illustrates the rule that in the absence of any marks the FP rating is  ∞). The tables show that the simulator did not realize any z-sample on the first non-diseased case (alternatively, if it did, the z-sample(s) fell below  ; one cannot tell the difference), and for the second lesion on the third diseased case. Because non-diseased cases have no lesions, all z-samples listed in Table \@ref(tab:froc-meanings-table-non-diseased) are NLs. In contrast, in Table \@ref(tab:froc-meanings-table-diseased), each case can generate NLs and LLs. The second column of Table \@ref(tab:froc-meanings-table-diseased) lists the number of lesions per diseased case  . Columns 3 and 4 illustrate NL indexing and z-samples and columns 5 and 6 illustrate LL indexing and z-samples. Column 8 illustrates the conversion of the NL and LL z-samples to TP z-samples according to the highest-rating assumption. The last columns of Table \@ref(tab:froc-meanings-table-non-diseased) and Table \@ref(tab:froc-meanings-table-diseased) label the correspondences of the z-samples to the operating points shown in Fig. 14.3 and Fig. 14.5. Unrealized z-samples, if any, are indicated by an asterisk.


Table \@ref(tab:froc-meanings-table-non-diseased): Layout of mark-rating pairs on **non-diseased** cases, illustrating calculation of NL and FP ratings and corresponding to green NL circles in Fig. \@ref(fig:froc-meanings-linearPlot-afroc) and Fig. \@ref(fig:froc-meanings-linearPlot-wafroc). The first column is the case number. The second column has the location of NLs and the third column the corresponding ratings. The fourth column has the FP ratings. The last column labels correspond to those shown in Fig. \@ref(fig:froc-meanings-afroc-wafroc). NA = not applicable; * = unmarked location.


\begin{table}

\caption{(\#tab:froc-meanings-table-non-diseased)Layout of mark-rating  pairs on non-diseased cases.}
\centering
\begin{tabular}[t]{l|l|l|l|l}
\hline
case\# & $k_t t l_s s$ & $z_{k_t t l_s s}$ & $FP_{k_t t}$ & Label\\
\hline
1 & 1111 & NA & $-\infty$ & \*\\
\hline
1 & 1121 & NA & $-\infty$ & \*\\
\hline
2 & 2111 & 0.487 & 0.487 & F\\
\hline
2 & 2121 & NA & 0.487 & F\\
\hline
3 & 3111 & 0.738 & 0.738 & E\\
\hline
3 & 3121 & 0.576 & 0.738 & E\\
\hline
4 & 4111 & -0.305 & -0.305 & H\\
\hline
4 & 4121 & NA & -0.305 & H\\
\hline
\end{tabular}
\end{table}


Table \@ref(tab:froc-meanings-table-diseased): Layout of mark-rating pairs on **diseased** cases, illustrating the locations of NL and LL ratings, corresponding to green NL and red LL circles, respectively, in Fig. \@ref(fig:froc-meanings-linearPlot-afroc) and Fig. \@ref(fig:froc-meanings-linearPlot-wafroc). The first column is the case number. The second column has the number of lesions in the case. The third column has the location of NLs and the fourth column the corresponding ratings. The fifth column has the location of LLs and the sixth column the corresponding ratings. The last column labels correspond to those shown in Fig. \@ref(fig:froc-meanings-afroc-wafroc). NA = not applicable; * = unmarked location


\begin{table}

\caption{(\#tab:froc-meanings-table-diseased)Layout of mark-rating pairs on diseased cases.}
\centering
\begin{tabular}[t]{l|l|l|l|l|l|l|l}
\hline
case\# & $L_{k_2}$ & $k_t t l_s s$ & $z_{k_t t l_s s}$ & $k_t t l_s s$ & $z_{k_t t l_s s}$ & $W_{k_2 l_2}$ & Label\\
\hline
1 & 1 & 1211 & 1.512 & 1212 & 0.852 & 1 & D\\
\hline
1 & 1 & 1221 & NA & 1222 & NA & NA & \\
\hline
2 & 1 & 2211 & NA & 2212 & -0.215 & 1 & G\\
\hline
2 & 1 & 2221 & NA & 2222 & NA & NA & \\
\hline
3 & 2 & 3211 & NA & 3212 & 1.588 & 0.6 & C\\
\hline
3 & 2 & 3221 & NA & 3222 & NA & 0.4 & \*\\
\hline
4 & 2 & 4211 & NA & 4212 & 2.944 & 0.4 & A\\
\hline
4 & 2 & 4221 & NA & 4222 & 1.984 & 0.6 & B\\
\hline
\end{tabular}
\end{table}



### The AFROC plot {#froc-meanings-AFROC-plot}
Understanding the data at a basic level, especially how z-samples are transformed to ratings, is aided by examples with very few cases. The following example is based on the same data involving 8 cases that were used to generate Table \@ref(tab:froc-meanings-table-non-diseased) and Table \@ref(tab:froc-meanings-table-diseased). It involves use of a linear or "one-dimensional" depiction of the ratings described next.

In Fig. \@ref(fig:froc-meanings-linearPlot-afroc), plot A, FPs and LLs, represented by green and red circles, respectively, are shown ordered, from left to right, with higher z-samples to the right, henceforth referred to as a linear plot. Each circle is labeled using the $k_t t l_s s$  notation. For example, the right-most red circle corresponds to the LL z-sample originating from the first lesion in the fourth diseased case, i.e., $z_{4212}$. Consistent with the three unique values in the fifth column of Table \@ref(tab:froc-meanings-table-non-diseased), there are three green circles (FPs) ^[Not counting $FP_{11}$, which occurs at $z = -\infty$, representing the first non-diseased case with no marks.]. Likewise, consistent with the five unique values in the sixth column of Table \@ref(tab:froc-meanings-table-diseased), there are five red circles (LLs) ^[Not counting $z_{3222} = -\infty$ representing the unmarked second lesion on the third diseased case.]. 








![(\#fig:froc-meanings-linearPlot-afroc)Plot A (AFROC generation) a one-dimensional depiction of the data in Table \@ref(tab:froc-meanings-table-non-diseased) and Table \@ref(tab:froc-meanings-table-diseased), showing z-samples used for plotting the AFROC; the red circles correspond to latent lesion localizations (LLs) and the green to latent false positives (FPs). Plot B (wAFROC generation): Data in same tables but this time including the weights, for plotting the weighted-AFROC plot; the sizes of the red circles code the lesions weights; the weights are shown below each z-sample.](14-froc-meanings-foms-ocs_files/figure-latex/froc-meanings-linearPlot-afroc-1.pdf) 



Starting from $\infty$, moving a virtual threshold continuously to the left generates the AFROC plot, see plot A in Fig. \@ref(fig:froc-meanings-linearPlot-afroc). As each FP is crossed, the operating point moves to the right by 

$$\frac{1}{K_1} = 0.025$$

As each LL is crossed, the operating point moves up by 

$$\sum_{k_2=1}^{K_2}L_{k_2}=\frac{1}{6}$$

Since it has one lesion, crossing the z-sample for the first case would result in an upward movement of 1/6, and likewise for the second case. Since the third case contains two lesions, crossing the corresponding z-samples would result in a net upward movement of the operating point by 1/3. *This behavior shows explicitly that the non-weighted method gives greater importance to diseased cases with more lesions, i.e., such case make a greater contribution to AUC.* The jumps from lesions in the same case need not be contiguous; they could be distributed, with intervening jumps from lesions on other cases but eventually the jumps will occur and contribute to the net upward movement. As an example, the jumps due to the two lesions on the fourth case are contiguous: see points A and B, in Fig. \@ref(fig:froc-meanings-linearPlot-wafroc). However, the jumps due to the two lesions on the 3rd case are not contiguous: the first lesion gives the point C, but the unmarked lesion on this case, indicated by the asterisk in Table \@ref(tab:froc-meanings-table-diseased), eventually contributes when the operating point moves diagonally from point H to (1,1). 











![(\#fig:froc-meanings-afroc-wafroc)A: The empirical AFROC plot for the data shown in Table \@ref(tab:froc-meanings-table-non-diseased) and Table \@ref(tab:froc-meanings-table-diseased). The labels correspond to the last columns of the tables. The corresponding one-dimensional depiction is plot A in Fig. \@ref(fig:froc-meanings-linearPlot-afroc). The area under the empirical plot is 0.7708. B: The empirical weighted-AFROC (wAFROC) plot for the data shown in Table \@ref(tab:froc-meanings-table-non-diseased) and Table \@ref(tab:froc-meanings-table-diseased). The operating point labels correspond to the last columns of the tables. The corresponding one-dimensional plot is plot B in Fig. \@ref(fig:froc-meanings-linearPlot-afroc). The area under the wAFROC is 0.7875. ](14-froc-meanings-foms-ocs_files/figure-latex/froc-meanings-afroc-wafroc-1.pdf) 



### The weighted-AFROC (wAFROC) plot {#froc-meanings-wAFROC-plot}
Plot B in Fig. \@ref(fig:froc-meanings-linearPlot-afroc), which is analogous to plot A in the same figure\, is a one-dimensional depiction of the data in Table \@ref(tab:froc-meanings-table-non-diseased) and Table \@ref(tab:froc-meanings-table-diseased) but this time the lesion weights, shown in Table \@ref(tab:froc-meanings-table-diseased), are incorporated, as indicated by varying the *size* of each red circle to indicate its weight (in Fig. \@ref(fig:froc-meanings-linearPlot-wafroc) all red circles were of the same size). In addition, each lesion is labeled with its rating and weight. [The listed weights in Table \@ref(tab:froc-meanings-table-diseased) were assigned arbitrarily subject to the rule that the weights on a case must sum to unity.]


Moving a virtual threshold continuously to the left generates the wAFROC plot, Fig. 14.5. The movement of the operating point in response to crossing FPs is the same as before. However, as each LL is crossed the operating point moves up by an amount that depends on the lesion: 

$$\frac{W_{k_2 l_2}}{K_2} = \frac{W_{k_2 l_2}}{4}$$

Since the first two diseased cases have one lesion each (i.e., unit weights), crossing the corresponding z-samples results in upward jumps of 0.25, Fig. 14.5 (C to D and F to G). According to the weights in Fig. 14.4, crossing the z-sample of the first lesion in the third diseased case, results in an upward jump of 0.6/4. That from the second lesion in the same case results in an upward jump of 0.4/4, for a net upward jump of the third case of 0.25, the same as for the first two diseased cases. Likewise crossing the z-samples of the two lesions in the 4th disease case results in upward jump of 0.4/4 = 0.1 (O to A), for the 1st lesion and 0.6/4 = 0.15 (B to C), for the 2nd lesion, for a net upward jump of ¼, which is the same as for the first three diseased cases. This shows explicitly that the weighting method gives each diseased case the same importance, regardless of the number of lesions in it, a property not shared by the area under the AFROC. 

Fig. 14.5: The empirical weighted-AFROC (wAFROC) plot for the data shown in Table \@ref(tab:froc-meanings-table-non-diseased) and Table \@ref(tab:froc-meanings-table-diseased). The operating point labels correspond to the last columns of the tables. The corresponding one-dimensional plot is Fig. 14.4. The area under the wAFROC is 0.7875. This plot was generated by mainPlotwAfroc.R.


## Physical interpretation of AFROC-based FOMs
From the preceding sections, it is seen that the AFROC-based trapezoidal plots consist of upward and rightward jumps, starting from the origin (0,0) and ending at (1,1). This is true regardless of whether the z-samples are binned or not: i.e., at the "microscopic" level the jumps always exist. Each upward jump is associated with a LL rating exceeding a virtual threshold. Each rightward jump is associated with a FP rating exceeding the threshold. Upward jumps tend to increase the area under the AFROC-based plots and rightward jumps tend to decrease it. This makes physical sense in terms of correct decisions being rewarded and incorrect ones being penalized, and can be seen from two extreme-case examples. If there are only upward jumps, then the trapezoidal plot rises from the origin to (0,1), where all lesions are correctly localized without any generating FPs and performance is perfect – the straight-line extension to (1,1) ensures that the net area is unity. If there are only horizontal jumps, that takes the operating point from the origin to (1,0), where none of the lesions are localized and every non-diseased image has at least one NL mark, representing worst possible performance. Here, despite the straight line extension to (1,1) the net area is zero.


### Physical interpretation of area under AFROC 
The area under the AFROC has the following physical interpretation: it is the fraction of LL vs. FP z-sample comparisons where the LL sample is equal (counting as half a comparison) or greater (counting as a full comparison) than the FP z-sample. From Tables 1 and 2, there are four FPs and six LLs for 24 possible comparisons. Inspection of the tables reveals that there are 4 x 4 = 16 comparisons contributing ones, two comparisons (from the 2nd diseased case) contributing ones, and one comparison (from the 2nd lesion on the 3rd diseased case) contributing 0.5, which sum to 18.5. Dividing by 24 yields 18.5/24 = 0.7708, the empirical AFROC-AUC, §14.5.1. In probabilistic terms:

The area under the AFROC is the probability that a lesion is rated higher than any mark on a non-diseased case.

### Physical interpretation of area under wAFROC
The area under the wAFROC has the following physical interpretation: it is the lesion-weight adjusted fraction of diseased cases vs. non-diseased case comparisons where LL z-samples are equal (counting as half a comparison times the weight of the lesion in question) or greater (counting as a full comparison times the weight of the lesion) than FP z-samples. Note that there are still 24 LL vs. FP comparisons but the counting proceeds differently. The fourth diseased case contributes 0.4 x 4 + 0.6 x 4, i.e., 4 (compared to 8 in the preceding example). The third diseased case contributes 0.6 x 4 + 0.4 x 0.5, i.e., 2.6 (compared to 4.5 in the preceding example). The second diseased case contributes 1 x 2 = 2 (compared to 2 in the preceding example), and the first diseased case contributes 1 x 4 = 4 (compared to 4 in the preceding example). Summing these values and dividing by 16 (the total number of diseased cases vs. non-diseased cases comparisons) one gets 12.6/16 = 0.7875, which is the area under the wAFROC, §14.5.1. In probabilistic terms:

The area under the weighted-AFROC is the lesion-weight adjusted probability that a lesion is rated higher than any mark on a non-diseased case.\







## Discussion{#froc-meanings-Discussion}
The primary aim of this chapter was to develop expressions for FOMs (i.e., functions of ratings) and show their equivalences to the empirical AUCs under corresponding operating characteristics. Unlike the ROC, the AFROC and wAFROC figures of merit are represented by quasi-Wilcoxon like constructs, not the well-known Wilcoxon statistic5. 

The author is aware from users of his software that their manuscript submissions have sometimes been held up with the critique that the meaning of the AFROC FOM-statistic is "not intuitively clear"6. An example was given in a previous chapter. This is one reason the author has tried to make the meaning clear, perhaps at the risk of making it painfully clear. Clinical interpretations do not always fit into convenient easy to analyze paradigms. Not understanding something is not a reason for preferring a simpler method. Use of the simpler ROC paradigm to analyze location specific tasks results in loss of statistical power and sacrifices better understanding of what is limiting performance. It is unethical to analyze a study with a method with lower statistical power when one with greater power is available7-9. The title of the paper by Halpern et al is "The continuing unethical conduct of underpowered clinical trials". The AFROC FOM-statistic was proposed in 1989 and it has been used, at the time of writing, in over 107 publications . 

The subject material of this chapter is not that difficult. However, it does require the researcher to be receptive an unbiased. Dirac addressed an analogous then-existing concern about quantum mechanics, namely it did not provide a satisfying "picture" of what is going on, as did classical mechanics . To paraphrase him, the purpose of science (quantum physics in his case) is not to provide satisfying pictures but to explain data. FROC data is inherently more complex than the ROC paradigm and one should not expect a simple FOM-statistic. The detailed explanations given in this chapter should allow one to understand the wAFROC and AFROC FOMs.

A misconception regarding the wAFROC FOM-statistic is that the weighting may sacrifice statistical power and render the method equivalent to ROC analysis in terms of statistical power. Analysis of clinical datasets and simulation studies suggests that this is not the case; loss of power is minimal. As noted earlier, the highest rating carries more information than a randomly selected rating. 

Bamber's equivalence theorem led to much progress in non-parametric analysis of ROC data. The proofs of the equivalences between the areas under the AFROC and wAFROC and the corresponding quasi-Wilcoxon statistics provide a starting point. To realize the full potential of these proofs, similar work like that conducted by DeLong et al10 is needed for the FROC paradigm. This work is not going to be easy; one reason being the relative dearth of researchers working in this area, but it is possible. Indeed work has been published by Popescu11 on non-parametric analysis of the exponentially transformed FROC  (EFROC) plot which, like the AFROC and wAFROC, is completely contained within the unit square. This work should be extended to the wAFROC. For reasons stated in Chapter 13, non-parametric analysis of FROC curves12-14 is not expected to be fruitful.

Current terminology prefixes each of the AFROC-based FOMs with the letter "J" for Jackknife. The author recommends dropping this prefix, which has to do with significance testing procedure rather than the actual definition of the FOM-statistic. For example, the correct way is to refer to the AFROC figure of merit, not the JAFROC figure of merit. For continuity, the software packages implementing the methods are still referred to as JAFROC (Windows) or RJAfroc (cross-platform, open-source).

To gain deeper insight into the FROC paradigm, it is necessary to look at methods used to measure visual search, the subject of the next chapter.


## References {#froc-meanings-references}

