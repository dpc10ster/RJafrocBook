# FROC vs. wAFROC {#froc-vs-afroc}



## Introduction {#froc-vs-wafroc-intro}

-   TBA This chapter needs a major rewrite; 10/6/20
-   One plot is being repeated
-   Need to add comparisons to ROC
-   Don't need columns 1 and 3 in table

The FROC curve was introduced in [@bunch1977free] and ever since it has been widely used for evaluating performance in the free-response paradigm, particularly in 1 algorithm development. Typically 1 researchers report "sensitivity was observed to be xx at yy false positives per image." Occasionally, using less ambiguous terminology, they report an observed operating point on the FROC, as in "LLF was observed to be xx at NLF = yy". The lessons learned from ROC analysis, see Section \@ref(binary-task-beam-study), that a scalar FOM is preferable to sensitivity-specificity pairs, has apparently been forgotten.

This chapter recommends adoption of the wAFROC as the preferred operating characteristic in assessing performance in the free-response paradigm, and details simulation-based studies supporting this recommendation.

## FROC vs. wAFROC

Recall, from Section \@ref(froc-paradigm-preview-rsm), that the RSM is defined by parameters $\mu, \lambda, \nu$, and a threshold parameter $\zeta_1$ which determines if latent localizations are actually marked. This section examines RSM-predicted empirical FROC, wAFROC and ROC plots for two simulated observers denoted RAD-1 and RAD-2. The former could be an algorithmic observer while the latter could be a radiologist. For typical threshold $\zeta_1$ parameters, three types of simulations are considered: RAD-2 has moderately better performance than RAD-1, RAD-2 has much better performance than RAD-1 and RAD-2 has slightly better performance than RAD-1. For each type of simulation pairs of FROC, wAFROC and ROC curves are shown, one for each observer. Finally the simulations and plots are repeated for hypothetical RAD-1 and RAD-2 observers who report all suspicious regions, i.e., $\zeta_1 = -\infty$ for each observer. Both RAD-1 and RAD-2 observers share the same $\lambda, \nu$ parameters, and the only difference between them is in the $\mu$ and $\zeta_1$ parameters.   

### Moderate difference in performance




```{.r .numberLines}
source(here("R/CH13-CadVsRadPlots/CadVsRadPlots.R"))

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

ret <- do_one_figure (
  seed, Lmax, muCad, 
  muRad, lambda, nu, zeta1Cad, zeta1Rad, K1, K2)

froc_plot_1A <- ret$froc_plot_A
wafroc_plot_1B <- ret$wafroc_plot_B
roc_plot_1C <- ret$roc_plot_C
froc_plot_1D <- ret$froc_plot_D
wafroc_plot_1E <- ret$wafroc_plot_E
roc_plot_1F <- ret$roc_plot_F
wafroc_1_1B <- ret$wafroc_1_B
wafroc_2_1B <- ret$wafroc_2_B
roc_1_1C <- ret$roc_1_C
roc_2_1C <- ret$roc_2_C
wafroc_1_1E <- ret$wafroc_1_E
wafroc_2_1E <- ret$wafroc_2_E
roc_1_1F <- ret$roc_1_F
roc_2_1F <- ret$roc_2_F
```

The $\lambda$ and $\nu$ parameters are defined at lines 3 and 4 of the preceding code: $\lambda = \nu = 1$. The number of simulated cases is defined, lines 5-6, by $K_1 = 500$ and $K_2 = 700$. The simulated RAD-1 observer $\mu$ parameter is defined at line 7 by $\mu_{1} = 1$ and that of the simulated RAD-2 observer is defined at line 8 by $\mu_{2} = 1.5$. Based on these choices one expect RAD-2 to be moderately better than RAD-1. The corresponding threshold parameters are (lines 9 -10) $\zeta_{1} = -1$ for RAD-1 and $\zeta_{1} = 1.5$ for RAD-2. The maximum number of lesions per case is defined at line 11 by `Lmax` = 2. The actual number of lesions per case is determined determined by random sampling within the helper function `do_one_figure()` called at lines 14-16. This function returns a large list `ret`, whose contents are as follows:

* `ret$froc_plot_A`: a pair of FROC plots for the thresholds specified above, a red plot labeled "R: 1" corresponding to RAD-1 and a blue plot labeled "R: 2" corresponding to RAD-2. These are shown in panel A.
* `ret$wafroc_plot_B`: a pair of wAFROC plots, similarly labeled. These are shown in panel B.
* `ret$roc_plot_C`: a pair of ROC plots, similarly labeled. These are shown in panel C.
* `ret$froc_plot_D`: a pair of FROC plots for the both thresholds at $-\infty$. These are shown in panel D.
* `ret$froc_plot_E`: a pair of wAFROC plots for the both thresholds at $-\infty$. These are shown in panel E.
* `ret$froc_plot_F`: a pair of ROC plots for the both thresholds at $-\infty$. These are shown in panel F.
* `ret$wafroc_1_B`: the wAFROC AUC for RAD-1, i.e., the area under the curve labeled "R: 1" in panel B.
* `ret$wafroc_2_B`: the wAFROC AUC for RAD-2, i.e., the area under the curve labeled "R: 2" in panel B.
* `ret$roc_1_C`: the ROC AUC for RAD-1, i.e., the area under the curve labeled "R: 1" in panel C.
* `ret$roc_2_C`: the ROC AUC for RAD-2, i.e., the area under the curve labeled "R: 2" in panel C.
* `ret$wafroc_1_E`: the wAFROC AUC for RAD-1, i.e., the area under the curve labeled "R: 1" in panel E.
* `ret$wafroc_2_E`: the wAFROC AUC for RAD-2, i.e., the area under the curve labeled "R: 2" in panel E.
* `ret$roc_1_F`: the ROC AUC for RAD-1, i.e., the area under the curve labeled "R: 1" in panel F.
* `ret$roc_2_F`: the ROC AUC for RAD-2, i.e., the area under the curve labeled "R: 2" in panel F.

![(\#fig:froc-vs-afroc-plot1)Plots A and B are for 1 $\zeta_1 = -1$ and 2 $\zeta_1 = 1.5$ and plots C and D are plots for 1 $\zeta_1 = -\infty$ and 2 $\zeta_1 = -\infty$. Plots A and C: FROC curves for the 1 and 2 observers. B and D: corresponding wAFROC curves.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot1-1.pdf) 




The coordinates of the end-point of the RAD-1 FROC in plot A are (0.8258333, 0.5903846). Those of the RAD-2 FROC plot in A are (0.0491667, 0.3980769). The FROC for the RAD-1 observer extends to much larger NLF values while that for the RAD-2 observer is relatively short and steep. One suspects the RAD-2 observer is performing better than RAD-1: he is better at finding lesions and producing fewer NLs, both of which are desirable characteristics, but he is adopting a too-strict reporting criterion. If he could be induced to relax the threshold and report more NLs, his LLF would exceed that of the RAD-1 observer while still maintaining a lower NLF. However, as this involves a subjective extrapolation, it is not possible to objectively quantify this from the FROC curves. The basic issue is the lack of a common NLF range for the two plots. If a common NLF range is "forced", for example defined as the common NLF range 0 to 0.0491667, where both curves contribute, it would ignore most NLs from the RAD-1 observer.

Algorithm developers typically quote LLF at a specified NLF. According to the two plots in A, the RAD-2 observer is better if the NLF value is chosen to less than 0.0491667 (this is the maximum NLF value for the RAD-2 plot in A) but there is no basis for comparison for larger values of NLF (because the RAD-2 observer does not provide any data beyond the observed end-point). A similar problem was encountered in ROC analysis when comparing a pair of sensitivity-specificity values, where, given differing choices of thresholds, ambiguous results can be obtained, see Section \@ref(binary-task-beam-study). Indeed, this was the rationale for using AUC under the ROC curve as an unambiguous measure of performance.

Plot B shows wAFROC curves for the same datasets whose FROC curves are shown in plot A. **The wAFROC is contained within the unit square, a highly desirable characteristic, which solves the lack of a common NLF range problem with the FROC.** The wAFROC AUC under the RAD-2 observer is visibly greater than that for the RAD-1 observer, even though -- due to his higher threshold -- his AUC estimate is actually biased downward (because the RAD-2 observer is adopting a high threshold, his $\text{LLF}_{\text{max}}$ is smaller than it would have been with a lower threshold, and consequently the area under the large straight line segment from the uppermost non-trivial operating point to (1,1) is smaller). AUCs under the two wAFROC plots in B are 0.573097142857143 for RAD-1 and 0.67371 for RAD-2.


Plot C shows ROC curves. Since the curves cross, it is not clear which has the larger AUC. AUCs under the two curves in C are 0.749937142857143 for RAD-1 and 0.745282857142857 for RAD-2, which are close, but here is an example where the ordering given by the wAFROC is opposite to that given by the ROC. 

Plots D, E and F correspond to A, B and C with this important difference: the two threshold parameters are set to $-\infty$. The coordinates of the end-point of the RAD-1 FROC in panel D are (1.0025, 0.6048077). Those of the RAD-2 FROC in panel D are (0.6391667, 0.775). The RAD-2 observer has higher LLF at lower NLF, and there can be no doubt that he is better. Panels E and F confirm that RAD-2 is actually the better observer *over the entire FPF range*. AUCs under the two wAFROC curves in E are 0.560485714285714 for RAD-1 and 0.777992857142857 for RAD-2. AUCs under the two ROC curves in F are 0.751334285714286 for RAD-1 and 0.882568571428571 for RAD-2. These confirm the visual impressions of plots in panels E and F. Notice that each ROC AUC is larger than the corresponding wAFROC AUC. This is because the probability of a lesion localization (case is declared positive *and* a lesion is correctly localized) is smaller than the probability of a true positive (case is declared positive). In other words, the ROC is everywhere above the wAFROC.


### Large difference in performance






![(\#fig:froc-vs-afroc-plot2)Plots A and B are for 1 $\zeta_1 = -1$ and 2 $\zeta_1 = 2$ and plots C and D are plots for 1 $\zeta_1 = -\infty$ and 2 $\zeta_1 = -\infty$. A and C: FROC curves for the RAD-1 and RAD-2 observers. B and D: corresponding wAFROC curves.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot2-1.pdf) 

TBA Fig. \@ref(fig:froc-vs-afroc-plot2) (A) FROC curves for RAD-1 observer and the RAD-2 observer. The RAD-1 observer is identical to that shown in Fig. \@ref(fig:froc-vs-afroc-plot1). The RAD-2 observer is characterized by $\mu = 2$ and $\zeta_1 = 2$. This time it is impossible to compare the two FROC curves, as the common range is very small. However, wAFROC, plot B, clearly shows the expected superiority of the RAD-2 observer, in spite of the severe underestimate of the corresponding AUC.


In Fig. \@ref(fig:froc-vs-afroc-plot2) panel A, the RAD-1 parameters are the same as in Fig. \@ref(fig:froc-vs-afroc-plot1), but the RAD-2 parameters are $\mu_{2} = 2$ and $\zeta_1 = +2$. Doubling the separation parameter over that of RAD-1 ($\mu_{1} = 1$) has a huge effect on performance. The end-point coordinates of the FROC for RAD-1 are (0.8258333, 0.5903846). The end-point coordinates of the FROC for RAD-2 are (0.015, 0.4211538). The common NLF region defined by NLF = 0 to NLF = 0.015 *would exclude almost all of the marks made by RAD-1*. The wAFROC plots in panel B show the markedly greater performance of RAD-2 over RAD-1 (the AUCs are 0.573097142857143 for RAD-1 and 0.707519285714286 for RAD-2). The inter-reader difference is larger (compared to Fig. \@ref(fig:froc-vs-afroc-plot1) plot B), despite the greater downward bias working against the RAD-2 observer. Panel C shows ROC plots for the two observers. Although the curves cross, it is evident that RAD-2 has the greater AUC. The AUCs are 0.749937142857143 for RAD-1 and 0.772155714285714 for RAD-2.

Plots D, E and F correspond to A, B and C with the difference that the two threshold parameters are set to $-\infty$. The coordinates of the end-point of the RAD-1 FROC in panel D are (1.0025, 0.6048077). Those of the RAD-2 FROC in panel D are (0.5, 0.8653846). The RAD-2 observer has higher LLF at lower NLF, and there can be no doubt that he is better. Panels E and F confirm that RAD-2 is actually the better observer *over the entire FPF range*. AUCs under the two wAFROC curves in E are 0.560485714285714 for RAD-1 and 0.872028571428571 for RAD-2. AUCs under the two ROC curves in F are 0.751334285714286 for RAD-1 and 0.934321428571429 for RAD-2. These confirm the visual impressions of plots in panels E and F. Notice that each ROC AUC is larger than the corresponding wAFROC AUC. 

### Small difference in performance and identical thresholds





![(\#fig:froc-vs-afroc-plot3)Plots A and B are for 1 $\zeta_1 = -1$ and 2 $\zeta_1 = -1$ and plots C and D are plots for 1 $\zeta_1 = -\infty$ and 2 $\zeta_1 = -\infty$. A and C: FROC curves for the RAD-1 and RAD-2 observers. B and D: corresponding wAFROC curves.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot3-1.pdf) 


Notice also that in all three figures the wAFROC effect size (the difference in AUCs) is larger than the corresponding ROC effect size. 

* For Fig. \@ref(fig:froc-vs-afroc-plot1), the wAFROC effect size is 0.100612857142857 and the ROC effect size is -0.00465428571428572. 
* For Fig. \@ref(fig:froc-vs-afroc-plot2), the wAFROC effect size is 0.134422142857143 and the ROC effect size is 0.0222185714285714. 
* For Fig. \@ref(fig:froc-vs-afroc-plot3), the wAFROC effect size is 0.0610014285714285 and the ROC effect size is 0.0368542857142857. 



The final example, Fig. \@ref(fig:froc-vs-afroc-plot3) shows that *when there is a small difference in performance*, there is less ambiguity in using the FROC as a basis for measuring performance. The RAD-1 parameters are the same as in Fig. \@ref(fig:froc-vs-afroc-plot1) but the RAD-2 parameters are $\mu = 1.1$ and $\zeta_1= -1$. In other words, the $\mu$ parameter is 10% larger and the thresholds are identical. This time there is much more common NLF range overlap in plot A and one is counting most of the marks for the RAD-1 reader. The end-point coordinates of the FROC for RAD-1 are (0.8258333, 0.5903846). The end-point coordinates of the FROC for RAD-2 are (0.7458333, 0.6644231). The common NLF region defined by NLF = 0 to NLF = 0.7458333 includes almost all of the marks made by RAD-1. The wAFROC plots in panel B show the slight greater performance of RAD-2 over RAD-1 (the AUCs are 0.573097142857143 for RAD-1 and 0.634098571428571 for RAD-2). Panel C shows ROC plots for the two observers. Although the curves cross, it is evident that RAD-2 has the greater AUC. The AUCs are 0.749937142857143 for RAD-1 and 0.772155714285714 for RAD-2.

Plots D, E and F correspond to A, B and C with the difference that the two threshold parameters are set to $-\infty$. The coordinates of the end-point of the RAD-1 FROC in panel D are (1.0025, 0.6048077). Those of the RAD-2 FROC in panel D are (0.9008333, 0.6778846). Panels E and F confirm that RAD-2 is actually the better observer over the entire FPF range. AUCs under the two wAFROC curves in E are 0.560485714285714 for RAD-1 and 0.62384 for RAD-2. AUCs under the two ROC curves in F are 0.751334285714286 for RAD-1 and 0.785654285714286 for RAD-2. These confirm the visual impressions of plots in panels E and F. Notice that each ROC AUC is larger than the corresponding wAFROC AUC. 


## Summary of simulations

In order to get a better overview, the following tables summarize the numerical values from the plots in this chapter. Table \@ref(tab:froc-vs-afroc-summary-table-cad) refers to RAD-1, and Table \@ref(tab:froc-vs-afroc-summary-table-rad) refers to the RAD-2 observer.

### Summary of RAD-1 simulations




\begin{table}

\caption{(\#tab:froc-vs-afroc-summary-table-cad)Summary of RAD-1 simulations: A refers to plot A, B refers to plot B, etc.}
\centering
\begin{tabular}[t]{l|l|l|l|l|l}
\hline
FROC-A & FROC-D & wAFROC-B & wAFROC-E & ROC-C & ROC-F\\
\hline
(0.8258, 0.5904) & (1.002, 0.6048) & 0.5731 & 0.5605 & 0.7499 & 0.7513\\
\hline
\end{tabular}
\end{table}


-   The first column is labeled "FROC-A", meaning the RAD-1 FROC plots labeled A, which are identical for the three figures Fig. \@ref(fig:froc-vs-afroc-plot1), Fig. \@ref(fig:froc-vs-afroc-plot2) and Fig. \@ref(fig:froc-vs-afroc-plot3).
-   The second column is labeled "FROC-D", meaning the 1 FROC plots labeled D, which are identical for the three figures.
-   The third column is labeled "wAFROC-B", meaning the 1 wAFROC plots labeled B, which are identical for the three figures.
-   The last column is labeled "wAFROC-E", meaning the 1 wAFROC plots labeled E, which are identical for the three figures.

### Summary of RAD-2 simulations



\begin{table}

\caption{(\#tab:froc-vs-afroc-summary-table-rad)Summary of RAD-2 simulations: Fig refers to the figure number in this chapter, A refers to plot A, B refers to plot B, etc.}
\centering
\begin{tabular}[t]{l|l|l|l|l|l|l}
\hline
Fig & FROC-A & FROC-D & wAFROC-B & wAFROC-E & ROC-C & ROC-F\\
\hline
1 & (0.04917, 0.3981) & (0.6392, 0.775) & 0.6737 & 0.778 & 0.7453 & 0.8826\\
\hline
2 & (0.015, 0.4212) & (0.5, 0.8654) & 0.7075 & 0.872 & 0.7722 & 0.9343\\
\hline
3 & (0.7458, 0.6644) & (0.9008, 0.6779) & 0.6341 & 0.6238 & 0.7868 & 0.7857\\
\hline
\end{tabular}
\end{table}

-   The first column refers to the figure number, for example, "1" refers to Fig. \@ref(fig:froc-vs-afroc-plot1), "2" refers to Fig. \@ref(fig:froc-vs-afroc-plot2), and "3" refers to Fig. \@ref(fig:froc-vs-afroc-plot3).
-   The second column is labeled "FROC-A", meaning the RAD-2 FROC plot labeled A.
-   The third column is labeled "FROC-D", meaning the RAD-2 FROC plots labeled D.
-   The fourth column is labeled "wAFROC-B", meaning the RAD-2 wAFROC plots labeled B.
-   The last column is labeled "wAFROC-E", meaning the RAD-2 wAFROC plots labeled E.



## Comments {#froc-vs-wafroc-comments}

-   For the same figure label (A, B, C or D) the 1 plots are identical in the three figures. This is the reason why Table \@ref(tab:froc-vs-afroc-summary-table-cad) has only one row.
-   A *fixed* RAD-1 dataset is being compared to *varying* RAD-2 datasets.
-   The first RAD-2 dataset, Fig. \@ref(fig:froc-vs-afroc-plot1) A or B, might be considered an average radiologist, the second one, Fig. \@ref(fig:froc-vs-afroc-plot2) A or B, is a super-expert and the third one, Fig. \@ref(fig:froc-vs-afroc-plot3) A or B, is only nominally better than RAD-1.
-   Plots C and D are for hypothetical RAD-1 and RAD-2 readers that report all suspicious regions. The differences between A and C are minimal for the RAD-1 observer, but marked for the RAD-2 observer. Likewise for the differences between B and D.

## TBA FROC gives incorrect performance ordering {#froc-vs-wafroc-froc-incorrect-ordering}
A basic principle of ROC methodology is that two points on the same operating characteristic represent the same performance.
Presented next are four plots arranged to best show the effect of a change in threshold for RAD-1 and RAD-2. The plots are related to Fig. \@ref(fig:froc-vs-afroc-plot1) and Fig. \@ref(fig:froc-vs-afroc-plot2), but they are arranged differently. The explanation follows after the figure.



![(\#fig:froc-vs-afroc-plot4)1/2 FROC/wAFROC plots for two values of threshold. See below.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot4-1.pdf) 

TBA Fig. \@ref(fig:froc-vs-afroc-plot4): Plot A is the RAD-1 FROC for two values of $\zeta_1$: the green plot is for $\zeta_1 = -1$ and the red plot, which is mostly buried under the blue plot but the short red extension is visible, is for $\zeta_1 = -\infty$. Plot B is the RAD-1 wAFROC for two values of $\zeta_1$: the green plot is for $\zeta_1 = -1$ and the red plot is for $\zeta_1 = -\infty$. Plot C is the RAD-2 FROC for two values of $\zeta_1$: the green plot is for $\zeta_1 = 2$ and the red plot, which is partially buried under the blue plot but the long red extension is visible, is for $\zeta_1 = -\infty$. Plot D is the RAD-2 wAFROC for two values of $\zeta_1$: the green plot is for $\zeta_1 = 2$ and the red plot is for $\zeta_1 = -\infty$.

In the ROC paradigm, two points on the same underlying ROC curve represent the same intrinsic performance -- all that is happening is that the observers are employing different thresholds that represent different tradeoffs between sensitivity and specificity, see the [@RN1087] study referenced in \@ref(binary-task-beam-study). If the FROC curve is to be meaningful, then two curves that differ only in thresholds must also represent identical performance.

In the following the red curve always refers to $\zeta_1 = -\infty$ while the blue curve always refers to $\zeta_1 = -1$.

1.  Plot A: The RAD-1 blue plot is completely buried (i.e., identical curves) under the RAD-1 red plot, except for a short red extension. This is because the two plots correspond to identical values of the RSM parameters $\mu, \lambda, \nu$, the only difference is in the threshold parameter $\zeta_1$: the blue corresponds to $\zeta_1 = -1$ while the red corresponds to $\zeta_1 = -\infty$. If the only difference in the curves is due to the effect of threshold, one has to conclude that the intrinsic performances of the two observers, i.e., 1 with different thresholds, are in fact identical. In fact this is an incorrect conclusion, see below, which argues against the notion that the FROC curve is meaningful.
2.  Plot B: this time the RAD-1 curve extends all the way from (0,0) to (1,1) and so does the RAD-2 curve (most of which is buried under the blue one). A relatively small performance difference is evident: the blue curve has higher wAFROC-AUC = 0.573097142857143, than the red one, wAFROC-AUC = 0.560485714285714. The reason for this can be understood by noting that with the chosen $\mu = 1$ threshold $\zeta_1 = -1$ one is starting out on the relatively flat portion of the FROC. Upon extending it to higher NLF by lowering the threshold to $\zeta_1 = -\infty$, the increase in the LLF is modest, but NLF has increased substantially. Since relatively few additional lesions are being localized but the penalty is more NLs, intrinsic performance for the red curve is expected to decrease. The difference in performance is 0.0126114285714286. *The wAFROC gives the correct ordering of the two observers, one that is missed by the FROC.* The argument is more convincing upon comparing the observers' in Fig. \@ref(fig:froc-vs-afroc-plot4) C and D.
3.  Plot C: the RAD-2 FROC plot is partially buried under the RAD-1 plot, a short near vertical segment from (0,0) to (0.015, 0.4211538), in the region near the origin. Thereafter the RAD-2 FROC plot resumes a sweeping curve all the way to (0.5, 0.8653846). Since the two curves are identical except for changing thresholds, one must conclude based on the FROC, that the two performances are identical.
4.  Plot D: the RAD-2 blue curve extends all the way from (0,0) to (1,1) and so does the RAD-2 red curve (a short portion of which, near the origin, is buried under the blue one). A large performance difference is evident: the red curve has higher wAFROC-AUC = 0.872028571428571, than the blue one, wAFROC-AUC = 0.707519285714286. The explanation for this is that with the chosen 2 parameters -- $\mu = 2$ and initial threshold $\zeta_1 = 2$ -- one is starting on the relatively steep portion of the FROC and extending it to both higher LLF and higher NLF. Since many additional lesions are being localized, and one is counting only the highest rated NL on each non-diseased case, the penalty of more NLs is more than outweighed by the increased number of lesions localized. The difference in performance is 0.164509285714286. Again, the wAFROC gives the correct ordering of the two observers, one that is missed by the FROC.

The essential reason why the wAFROC gives the correct ordering but the FROC does not is that the wAFROC, being contained in the unit square, gives the complete picture. The FROC, not so constrained to the unit square, does not. 

Note that the direction of the threshold-change effect depends on the starting point on the FROC: if one starts on the relatively flat portion of the FROC, then lowering the threshold all the way to $-\infty$ decreases performance; if one starts on the relatively steep portion, then lowering the threshold all the way to $-\infty$ increases performance. An intermediate starting point can be found where there is no threshold-change effect.

The argument depends critically on the area under the straight line extension from the end-point to (1,1) being included in the wAFROC-AUC. If this were not allowed one could argue that the end-point of the blue curve (0.014, 0.4211538) -- quite visible as the sharp inflection in plot D -- lies on the same wAFROC curve as the end-point of the red curve (0.366, 0.8653846) -- not so readily visible. The justification for the straight line extension is deferred to Chapter \@ref(froc-meanings).




## Finding optimal operating point on the FROC

**Optimal operating point for 2**




```
#>   mu_arr
#> 1    1.0
#> 2    1.5
#> 3    2.0
#> 4    2.5
#>   zetaMaxArr
#> 1        0.3
#> 2       -0.3
#> 3       -0.3
#> 4       -0.2
#>   max_fomArray
#> 1    0.5941014
#> 2    0.7850043
#> 3    0.8778243
#> 4    0.9321043
#>      nlfArr
#> 1 0.3820886
#> 2 0.4119409
#> 3 0.3089557
#> 4 0.2317039
```

![(\#fig:froc-vs-afroc-plot5)TBA. See below.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot5-1.pdf) 

**Optimal operating point for 1**



```r
print(as.data.frame(mu_arr))
#>   mu_arr
#> 1    1.0
#> 2    1.5
#> 3    2.0
#> 4    2.5
print(as.data.frame(zetaMaxArr))
#>   zetaMaxArr
#> 1        2.0
#> 2        2.0
#> 3        1.3
#> 4        1.4
print(as.data.frame(max_fomArray))
#>   max_fomArray
#> 1    0.4536600
#> 2    0.5451357
#> 3    0.6901686
#> 4    0.8201436
print(as.data.frame(nlfArr))
#>      nlfArr
#> 1 0.2275013
#> 2 0.1516675
#> 3 0.4840024
#> 4 0.3230266
```

![(\#fig:froc-vs-afroc-plot6)TBA. See below.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot6-1.pdf) 

## Discussion {#froc-vs-wafroc-Discussion}

## References {#froc-vs-wafroc-references}
