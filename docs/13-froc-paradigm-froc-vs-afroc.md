# FROC vs. wAFROC {#froc-paradigm-froc-vs-afroc}




## Introduction {#froc-paradigm-froc-vs-afroc-froc-vs-afrocs-intro1}
* This chapter needs a major rewrite; 10/6/20
* One plot is being repeated
* Need to add comparisons to ROC
* Don't need columns 1 and 3 in table

## Introduction {#froc-paradigm-froc-vs-afroc-froc-vs-afrocs-intro}
The FROC curve was introduced in [@bunch1977free] and ever since has been widely used for evaluating performance in the free-response paradigm, particularly in CAD algorithm development. Typically CAD researchers report "sensitivity was observed to be xx at yy false positives per image." Alternatively, using less ambiguous terminology, they report an observed operating point on the FROC, as in "LLF was observed to be xx at NLF = yy". 

In the previous chapter I issued a recommendation against its continued usage. Instead, I recommended adoption of the wAFROC / AUC as the preferred operating characteristic / figure of merit in assessing performance in the free-response paradigm. This chapter details some studies supporting my recommendation.

## FROC vs. wAFROC
This section examines RSM-predicted FROC and wAFROC plots for a simulated CAD and a simulated RAD observer. Recall that the RSM is defined by 3 parameters $\mu, \lambda, \nu$ and a lowest threshold parameter $\zeta_1$ which determines if latent localizations are actually marked. Both observers share the same $\lambda, \nu$. These are defined at lines 3 and 4 of the following code: $\lambda = \nu = 1$. The simulated CAD observer is defined at line 7 by by $\mu_{CAD} = 1$ and the simulated RAD observer is defined at line 8 by $\mu_{RAD} = 1.5$. The corresponding threshold parameters are (lines 9 -10) $\zeta_{1} = -1$ for CAD and $\zeta_{1} = 1.5$ for RAD. 

The number of simulated cases is defined, lines 5-6, by $K_1 = 500$ and $K_2 = 700$. Relatively large numbers of cases were chosen to minimize sampling variability. 

The maximum number of lesions per case is defined at line 7 `Lmax` = 2. The actual number of lesions per case `Lk2` is determined at line 14 (`Lk2` is a $K_2$ length array consisting of random integers 1 or 2).

Line 16 calls the helper function `GenerateCadVsRadPlots()` (the file containing this function is sourced at line 1) which calculates the FROC and wAFROC plots and other statistics. The FROC is extracted at line 18 and labeled A, while the wAFROC is extracted at line 19 and labeled B. 



```{.r .numberLines}
source(here("R/CH13-GenerateCadVsRadPlots/GenerateCadVsRadPlots.R"))

nu <- 1
lambda <- 1
K1 <- 500
K2 <- 700
muCad <- 1.0
muRad <- 1.5
zeta1Cad <- -1
zeta1Rad <- 1.5
Lmax <- 2
seed <- 1
set.seed(seed)
Lk2 <- floor(runif(K2, 1, Lmax + 1))

ret <- GenerateCadVsRadPlots (muCad, muRad, zeta1Cad, zeta1Rad, K1, K2, Lk2, seed)

froc1A <- ret$froc$Plot + labs(tag = "A")
wafroc1B <- ret$wafroc$Plot + labs(tag = "B")
fomCad1B <- ret$fomCad
fomRad1B <- ret$fomRad

zeta1Cad <- -Inf
zeta1Rad <- -Inf

ret <- GenerateCadVsRadPlots (muCad, muRad, zeta1Cad, zeta1Rad, K1, K2, Lk2, seed)

froc1C <- ret$froc$Plot + labs(tag = "C")
wafroc1D <- ret$wafroc$Plot + labs(tag = "D")
fomCad1D <- ret$fomCad
fomRad1D <- ret$fomRad
```





Because of the chosen parameters the RAD observer has greater classification and search performances than CAD ^[Even though the *intrinsic* search parameters $\lambda, \nu$ are identical, because of the higher $\mu$ parameter, search performance is effectively much better for RAD - the distinction between intrinsic and physical parameters is clarified in Chapter TBA.] and, *for plots A and B*, a higher reporting threshold. One expects the FROC for the CAD observer to extend to much larger NLF values while that for the RAD observer is expected to be relatively short and steep, as in Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot1), plot A. The coordinates of the end-point of the CAD FROC in plot A are (0.8258333, 0.5903846). Those of the RAD FROC plot in A are (0.0491667, 0.3980769).


![(\#fig:froc-paradigm-froc-vs-afroc-plot1)Plots A and B are for CAD $\zeta_1 = -1$ and RAD $\zeta_1 = 1.5$ and plots C and D are plots for CAD $\zeta_1 = -\infty$ and RAD $\zeta_1 = -\infty$. A and C: FROC curves for the CAD and RAD observers. B and D: corresponding wAFROC curves.](13-froc-paradigm-froc-vs-afroc_files/figure-latex/froc-paradigm-froc-vs-afroc-plot1-1.pdf) 


From plot A one suspects the RAD observer is performing better than CAD. There is a much steeper rise along the LLF axis and a much shorter traverse along the NLF axis for the RAD observer as compared to CAD. The RAD observer is better at finding lesions and producing fewer NLs, both of which are desirable characteristics. One suspects that if this observer could be induced to relax the threshold and report more NLs, then LLF would exceed that of the CAD observer while $\text{NLF}_{\text{max}}$ would remain smaller than the corresponding value for CAD. However, it is difficult to quantify this suspicion from the FROC curves. This is *due to the lack of a common NLF range for the two plots* ^[If a common NLF range is forced, for example defined as the common NLF range 0 to 0.0491667 where both curves contribute, it would ignore most NLs from the CAD observer.]. 


CAD algorithm developers typically quote LLF at a specified NLF. According to the two plots in A, the RAD observer is better if the NLF value is chosen to less than 0.0491667 (this is the maximum NLF value for the RAD plot in A) while the CAD observer is better for larger values of NLF. A similar problem was encountered in ROC analysis when comparing a pair of sensitivity-specificity values, where, given differing choices of thresholds, ambiguous results can be obtained, as in Fig. TBA. Indeed, this was the rationale for using AUC under the ROC curve as an unambiguous measure of performance. Like the ROC, the wAFROC is contained within the unit square.


wAFROC curves, for the same datasets whose FROC curves are shown in plot A, are shown in plot B. The AUC under the RAD observer is visibly greater than that for the CAD observer, even though due to the choice of a higher threshold the AUC estimate is actually biased downward against RAD ^[Because the RAD observer is adopting $\zeta_1 = 1.5$, $\text{LLF}_{\text{max}}$ is smaller than it would have been with a less strict criterion, and consequently the area under the large straight line segment from the uppermost non-trivial operating point to (1,1) is smaller than would have been the case with $\zeta_1 = -\infty$]. AUCs under the two wAFROC plots in B are 0.573097142857143 for CAD and 0.67371 for RAD, consistent with the visual impression of RAD > CAD. 


**The basic problem with the FROC-based comparison, namely the lack of a common NLF range in order to compare the two plots, is solved by the wAFROC-based comparison, in which the FPF range is identical for the two observers, namely 0 to 1.** 


Lines 23-24 set the two threshold parameters to $-\infty$ each ^[This is impractical with the RAD observer but possible with CAD.] and line 24 calls the function `GenerateCadVsRadPlots()` again with these new values. The FROC is extracted at line 28 and labeled C, while the wAFROC is extracted at line 29 and labeled D. 

The coordinates of the end-point of the CAD FROC in plot C are (1.0025, 0.6048077). Those of the RAD FROC plot in C are (0.6391667, 0.775).


With the new thresholds one expects *all* latent localizations to be actually marked, in other words one would observe the entire extent of the curves. Plot C in Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot1) corresponds to $\zeta_1 = -\infty$, so the entire latent FROC curves are visible for both observers. This confirms the expectation that RAD is actually the better observer. Plot D shows corresponding wAFROC curves and the corresponding AUCs are 0.560485714285714 and 0.777992857142857. The differences from the previous values (corresponding to B) namely 0.573097142857143 for CAD and 0.67371 for RAD, is much larger for the RAD observer than for the CAD observer. This is because the CAD observer was already adopting a low threshold $\zeta_1 = -1$, so lowering it to $-\infty$ is expected to have a small effect: AUC under the wAFROC decreased slightly from 0.573097142857143 to 0.560485714285714 (since the initial threshold was already low, lowering it further does not appreciably increase $\text{LLF}_{\text{max}}$, rather it increases $\text{FPF}_{\text{max}}$ and the net AUC decreases slightly). In contrast, AUC for the RAD observer increases from 0.67371 to 0.777992857142857.  


## Two other examples are given. 








In Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot2) (A), which exaggerates the difference between CAD and RAD, the CAD parameters are the same as in Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot1), but the RAD parameters are $\mu = 2$ and $\zeta_1 = +2$. Doubling the separation parameter over that of CAD has a huge effect on performance. The end-point coordinates of the FROC for RAD are (0.015, 0.4211538). This time AUC under the common region defined by NLF = 0 to NLF = 0.015 would exclude almost all of the NL and LL marks made by CAD. The wAFROCs in plot B show the markedly greater performance of RAD compared to CAD (the AUCs are 0.573097142857143 for CAD and 0.707519285714286 for RAD). The difference is larger, in spite of the downward bias working against the wAFROC RAD AUC, Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot1) (D).



![(\#fig:froc-paradigm-froc-vs-afroc-plot2)Plots A and B are for CAD $\zeta_1 = -1$ and RAD $\zeta_1 = 2$ and plots C and D are plots for CAD $\zeta_1 = -\infty$ and RAD $\zeta_1 = -\infty$. A and C: FROC curves for the CAD and RAD observers. B and D: corresponding wAFROC curves.](13-froc-paradigm-froc-vs-afroc_files/figure-latex/froc-paradigm-froc-vs-afroc-plot2-1.pdf) 



Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot2) (A) FROC curves for CAD observer and the RAD observer. The CAD observer is identical to that shown in Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot1). The RAD observer is characterized by $\mu = 2$ and $\zeta_1 = 2$. This time it is impossible to compare the two FROC curves, as the common range is very small. However, wAFROC, plot B, clearly shows the expected superiority of the RAD observer, in spite of the severe underestimate of the corresponding AUC. AUCs under the two wAFROC plots are 0.608 for CAD and 0.708 for RAD. Plots C and D correspond to A and B, respectively, with $\zeta_1$ = $-\infty$ for both readers. AUCs under the two wAFROC plots are 0.573097142857143 for CAD and 0.707519285714286 for RAD.

### An example where the FROC can be used for comparisons

The final example, Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot3) shows that *when there is a small difference in performance*, there is less ambiguity in using the FROC as a basis for measuring performance. The CAD parameters are the same as in Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot1) but the RAD parameters are $\mu = 1.1$ and $\zeta_1= -1$. This time there is much more common overlap in plot (A) and the area measure is counting most of the marks for both readers (but still not accounting for unmarked non-diseased cases). The superior wAFROC-based performance of RAD is also apparent in (B). 






![(\#fig:froc-paradigm-froc-vs-afroc-plot3)Plots A and B are for CAD $\zeta_1 = -1$ and RAD $\zeta_1 = -1$ and plots C and D are plots for CAD $\zeta_1 = -\infty$ and RAD $\zeta_1 = -\infty$. A and C: FROC curves for the CAD and RAD observers. B and D: corresponding wAFROC curves.](13-froc-paradigm-froc-vs-afroc_files/figure-latex/froc-paradigm-froc-vs-afroc-plot3-1.pdf) 






\begin{table}

\caption{(\#tab:froc-paradigm-froc-vs-afroc-summary-table)TBA Representative counts table.}
\centering
\begin{tabular}[t]{l|l|l|l|l|l|l|l}
\hline
CAD-FROC & RAD-FROC & CAD-FROC1 & RAD-FROC1 & CAD-wAFROC & RAD-wAFROC & CAD-wAFROC1 & RAD-wAFROC1\\
\hline
(0.826, 0.59) & (0.0492, 0.398) & (1, 0.605) & (0.639, 0.775) & 0.573 & 0.674 & 0.56 & 0.778\\
\hline
(0.826, 0.59) & (0.015, 0.421) & (1, 0.605) & (0.5, 0.865) & 0.573 & 0.708 & 0.56 & 0.872\\
\hline
(0.826, 0.59) & (0.746, 0.664) & (1, 0.605) & (0.901, 0.678) & 0.573 & 0.708 & 0.56 & 0.872\\
\hline
\end{tabular}
\end{table}


A misconception exists that using the rating of only one NL mark, as in wAFROC, must sacrifice statistical power. In fact, the chosen mark is a special one, namely the highest rated NL mark on a non-diseased case, which carries more information than a randomly chosen NL mark. If the sampling distribution of the z-sample were uniform, then the highest sample is a sufficient statistic, meaning that it carries all the information in the samples. The highest rated z-sampler from a normal distribution is not a sufficient statistic, so there is some loss of information, but not as much as would occur with a randomly picked z-sample.


(A)	 
(B)

(C)	 
(D)
Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot3): (A, B) FROC/wAFROC curves for CAD and RAD observers. The CAD observer is identical to that shown in Fig. \@ref(fig:froc-paradigm-froc-vs-afroc-plot2) (A, B). The RAD observer is characterized by mu = 1.1 and $\zeta_1$ = -1. This time it is possible to compare the two FROC curves, as the common NLF range is large. Both FROC and wAFROC show the expected slight superiority of the RAD observer. AUCs under the two wAFROC plots are 0.608 for CAD and 0.634 for RAD. Plots C and D correspond to A and B, respectively, with $\zeta_1$ = $-\infty$ for both observers. Since $\zeta_1$ in A and B is already quite small, lowering it to  $-\infty$ does not pick up too many marks. AUCs under the two wAFROC plots in D are 0.601 for CAD and 0.624 for RAD.
13.16.4: Other issues with the FROC
Loss of statistical power is not the only issue with the FROC. Because it counts NLs on both diseased and non-diseased cases, the curve depends on disease-prevalence in the dataset. Because the numbers of LLs per case is variable, the curve gives undue importance to those diseased cases with unusually large numbers of lesions. As noted in 13.16.2, the clinical importance of a NL on a non-diseased case differs from that on a diseased case. The FROC curve ignores this distinction.







## Discussion{#froc-paradigm-froc-vs-afroc-froc-vs-afrocs-Discussion}


## References {#froc-paradigm-froc-vs-afroc-froc-vs-afrocs-references}

