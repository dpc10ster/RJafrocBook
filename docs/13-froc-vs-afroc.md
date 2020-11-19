# FROC vs. wAFROC {#froc-vs-afroc}

```
output:
  rmarkdown::pdf_document:
    fig_caption: yes        
    includes:  
      in_header: R/learn/my_header.tex

```



## Introduction {#froc-vs-wafroc-intro}

-   TBA This chapter needs a major rewrite; 10/6/20
-   One panel is being repeated
-   Don't need columns 1 and 3 in table

The FROC curve was introduced in [@bunch1977free] and ever since it has been widely used for evaluating performance in the free-response paradigm, particularly in 1 algorithm development. Typically 1 researchers report "sensitivity was observed to be xx at yy false positives per image." Occasionally, using less ambiguous terminology, they report an observed operating point on the FROC, as in "LLF was observed to be xx at NLF = yy". The lessons learned from ROC analysis, see Section \@ref(binary-task-beam-study), that a scalar FOM is preferable to sensitivity-specificity pairs, has apparently been forgotten.

This chapter recommends adoption of the wAFROC as the preferred operating characteristic in assessing performance in the free-response paradigm, and details simulation-based studies supporting this recommendation.

## FROC vs. wAFROC

Recall, from Section \@ref(froc-paradigm-preview-rsm), that the RSM is defined by parameters $\mu, \lambda, \nu$, and a threshold parameter $\zeta_1$ which determines if latent localizations are actually marked. This section examines RSM-predicted empirical FROC, wAFROC and ROC panels for two simulated observers denoted RAD-1 and RAD-2. The former could be an algorithmic observer while the latter could be a radiologist. For typical threshold $\zeta_1$ parameters, three types of simulations are considered: RAD-2 has moderately better performance than RAD-1, RAD-2 has much better performance than RAD-1 and RAD-2 has slightly better performance than RAD-1. For each type of simulation pairs of FROC, wAFROC and ROC curves are shown, one for each observer. Finally the simulations and panels are repeated for hypothetical RAD-1 and RAD-2 observers who report all suspicious regions, i.e., $\zeta_1 = -\infty$ for each observer. Both RAD-1 and RAD-2 observers share the same $\lambda, \nu$ parameters, and the only difference between them is in the $\mu$ and $\zeta_1$ parameters.   




### Moderate difference in performance


```{.r .numberLines}
source(here("R/CH13-CadVsRadPlots/CadVsRadPlots.R"))

nu <- 1
lambda <- 1
K1 <- 500
K2 <- 700
mu1 <- 1.0
mu2 <- 1.5
zeta1_1 <- -1
zeta1_2 <- 1.5
Lmax <- 2
seed <- 1

ret <- do_one_figure (
  seed, Lmax, mu1, 
  mu2, lambda, nu, zeta1_1, zeta1_2, K1, K2)

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

* `ret$froc_plot_A`: a pair of FROC panels for the thresholds specified above, a red panel labeled "R: 1" corresponding to RAD-1 and a blue panel labeled "R: 2" corresponding to RAD-2. These are shown in panel A.
* `ret$wafroc_plot_B`: a pair of wAFROC panels, similarly labeled. These are shown in panel B.
* `ret$roc_plot_C`: a pair of ROC panels, similarly labeled. These are shown in panel C.
* `ret$froc_plot_D`: a pair of FROC panels for the both thresholds at $-\infty$. These are shown in panel D.
* `ret$froc_plot_E`: a pair of wAFROC panels for the both thresholds at $-\infty$. These are shown in panel E.
* `ret$froc_plot_F`: a pair of ROC panels for the both thresholds at $-\infty$. These are shown in panel F.
* `ret$wafroc_1_B`: the wAFROC AUC for RAD-1, i.e., the area under the curve labeled "R: 1" in panel B.
* `ret$wafroc_2_B`: the wAFROC AUC for RAD-2, i.e., the area under the curve labeled "R: 2" in panel B.
* `ret$roc_1_C`: the ROC AUC for RAD-1, i.e., the area under the curve labeled "R: 1" in panel C.
* `ret$roc_2_C`: the ROC AUC for RAD-2, i.e., the area under the curve labeled "R: 2" in panel C.
* `ret$wafroc_1_E`: the wAFROC AUC for RAD-1, i.e., the area under the curve labeled "R: 1" in panel E.
* `ret$wafroc_2_E`: the wAFROC AUC for RAD-2, i.e., the area under the curve labeled "R: 2" in panel E.
* `ret$roc_1_F`: the ROC AUC for RAD-1, i.e., the area under the curve labeled "R: 1" in panel F.
* `ret$roc_2_F`: the ROC AUC for RAD-2, i.e., the area under the curve labeled "R: 2" in panel F.






![(\#fig:froc-vs-afroc-plot1)Plots A and D: FROC curves for the RAD-1 and RAD-2 observers; B and E are corresponding wAFROC curves and C and F are corresponding ROC curves. All curves in this plot are for $\lambda = \nu = 1$. All RAD_1 curves are for $\mu = 1$ and all RAD_2 curves are for $\mu = 1.5$. For panels A, B and C, $\zeta_1 = -1$ for RAD-1 and $\zeta_1 = 1.5$ for RAD-2. For panels D, E and F, $\zeta_1 = -\infty$ for RAD-1 and RAD-2.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot1-1.pdf) 


The coordinates of the end-point of the RAD-1 FROC in panel A are (0.8258333, 0.5903846). Those of the RAD-2 FROC curve in A are (0.0491667, 0.3980769). The FROC for the RAD-1 observer extends to much larger NLF values while that for the RAD-2 observer is relatively short and steep. One suspects the RAD-2 observer is performing better than RAD-1: he is better at finding lesions and producing fewer NLs, both of which are desirable characteristics, but he is adopting a too-strict reporting criterion. If he could be induced to relax the threshold and report more NLs, his LLF would exceed that of the RAD-1 observer while still maintaining a lower NLF. However, as this involves a subjective extrapolation, it is not possible to objectively quantify this from the FROC curves. The basic issue is the lack of a common NLF range for the two panels. If a common NLF range is "forced", for example defined as the common NLF range 0 to 0.0491667, where both curves contribute, it would ignore most NLs from the RAD-1 observer.

Algorithm developers typically quote LLF at a specified NLF. According to the two panels in A, the RAD-2 observer is better if the NLF value is chosen to less than 0.0491667 (this is the maximum NLF value for the RAD-2 curve in A) but there is no basis for comparison for larger values of NLF (because the RAD-2 observer does not provide any data beyond the observed end-point). A similar problem was encountered in ROC analysis when comparing a pair of sensitivity-specificity values, where, given differing choices of thresholds, ambiguous results can be obtained, see Section \@ref(binary-task-beam-study). Indeed, this was the rationale for using AUC under the ROC curve as an unambiguous measure of performance.

Plot B shows wAFROC curves for the same datasets whose FROC curves are shown in panel A. **The wAFROC is contained within the unit square, a highly desirable characteristic, which solves the lack of a common NLF range problem with the FROC.** The wAFROC AUC under the RAD-2 observer is visibly greater than that for the RAD-1 observer, even though -- due to his higher threshold -- his AUC estimate is actually biased downward (because the RAD-2 observer is adopting a high threshold, his $\text{LLF}_{\text{max}}$ is smaller than it would have been with a lower threshold, and consequently the area under the large straight line segment from the uppermost non-trivial operating point to (1,1) is smaller). AUCs under the two wAFROC panels in B are 0.573097142857143 for RAD-1 and 0.67371 for RAD-2.


Plot C shows ROC curves. Since the curves cross, it is not clear which has the larger AUC. AUCs under the two curves in C are 0.749937142857143 for RAD-1 and 0.745282857142857 for RAD-2, which are close, but here is an example where the ordering given by the wAFROC is opposite to that given by the ROC. 

Plots D, E and F correspond to A, B and C with this important difference: the two threshold parameters are set to $-\infty$. The coordinates of the end-point of the RAD-1 FROC in panel D are (1.0025, 0.6048077). Those of the RAD-2 FROC in panel D are (0.6391667, 0.775). The RAD-2 observer has higher LLF at lower NLF, and there can be no doubt that he is better. Panels E and F confirm that RAD-2 is actually the better observer *over the entire FPF range*. AUCs under the two wAFROC curves in E are 0.560485714285714 for RAD-1 and 0.777992857142857 for RAD-2. AUCs under the two ROC curves in F are 0.751334285714286 for RAD-1 and 0.882568571428571 for RAD-2. These confirm the visual impressions of panels in panels E and F. Notice that each ROC AUC is larger than the corresponding wAFROC AUC. This is because the probability of a lesion localization (case is declared positive *and* a lesion is correctly localized) is smaller than the probability of a true positive (case is declared positive). In other words, the ROC is everywhere above the wAFROC.


### Large difference in performance






![(\#fig:froc-vs-afroc-plot2)Similar to preceding figure but with the following changes. All RAD_2 curves are for $\mu = 2$ and for panels A, B and C $\zeta_1 = 2$ for RAD-2.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot2-1.pdf) 


In Fig. \@ref(fig:froc-vs-afroc-plot2) panel A, the RAD-1 parameters are the same as in Fig. \@ref(fig:froc-vs-afroc-plot1), but the RAD-2 parameters are $\mu_{2} = 2$ and $\zeta_1 = +2$. Doubling the separation parameter over that of RAD-1 ($\mu_{1} = 1$) has a huge effect on performance. The end-point coordinates of the FROC for RAD-1 are (0.8258333, 0.5903846). The end-point coordinates of the FROC for RAD-2 are (0.015, 0.4211538). The common NLF region defined by NLF = 0 to NLF = 0.015 *would exclude almost all of the marks made by RAD-1*. The wAFROC panels in panel B show the markedly greater performance of RAD-2 over RAD-1 (the AUCs are 0.573097142857143 for RAD-1 and 0.707519285714286 for RAD-2). The inter-reader difference is larger (compared to Fig. \@ref(fig:froc-vs-afroc-plot1) panel B), despite the greater downward bias working against the RAD-2 observer. Panel C shows ROC panels for the two observers. Although the curves cross, it is evident that RAD-2 has the greater AUC. The AUCs are 0.749937142857143 for RAD-1 and 0.772155714285714 for RAD-2.

Plots D, E and F correspond to A, B and C with the difference that the two threshold parameters are set to $-\infty$. The coordinates of the end-point of the RAD-1 FROC in panel D are (1.0025, 0.6048077). Those of the RAD-2 FROC in panel D are (0.5, 0.8653846). The RAD-2 observer has higher LLF at lower NLF, and there can be no doubt that he is better. Panels E and F confirm that RAD-2 is actually the better observer *over the entire FPF range*. AUCs under the two wAFROC curves in E are 0.560485714285714 for RAD-1 and 0.872028571428571 for RAD-2. AUCs under the two ROC curves in F are 0.751334285714286 for RAD-1 and 0.934321428571429 for RAD-2. These confirm the visual impressions of panels in panels E and F. Notice that each ROC AUC is larger than the corresponding wAFROC AUC. 

### Small difference in performance and identical thresholds







![(\#fig:froc-vs-afroc-plot3)Similar to preceding figure but with the following changes. All RAD_2 curves are for $\mu = 1.1$ and for panels A, B and C, $\zeta_1 = -1$ for RAD-2.](13-froc-vs-afroc_files/figure-latex/froc-vs-afroc-plot3-1.pdf) 


The final example, Fig. \@ref(fig:froc-vs-afroc-plot3) shows that *when there is a small difference in performance*, there is less ambiguity in using the FROC as a basis for measuring performance. The RAD-1 parameters are the same as in Fig. \@ref(fig:froc-vs-afroc-plot1) but the RAD-2 parameters are $\mu = 1.1$ and $\zeta_1= -1$. In other words, the $\mu$ parameter is 10% larger and the thresholds are identical. This time there is much more common NLF range overlap in panel A and one is counting most of the marks for the RAD-1 reader. The end-point coordinates of the FROC for RAD-1 are (0.8258333, 0.5903846). The end-point coordinates of the FROC for RAD-2 are (0.7458333, 0.6644231). The common NLF region defined by NLF = 0 to NLF = 0.7458333 includes almost all of the marks made by RAD-1. The wAFROC panels in panel B show the slight greater performance of RAD-2 over RAD-1 (the AUCs are 0.573097142857143 for RAD-1 and 0.634098571428571 for RAD-2). Panel C shows ROC panels for the two observers. Although the curves cross, it is evident that RAD-2 has the greater AUC. The AUCs are 0.749937142857143 for RAD-1 and 0.772155714285714 for RAD-2.

Plots D, E and F correspond to A, B and C with the difference that the two threshold parameters are set to $-\infty$. The coordinates of the end-point of the RAD-1 FROC in panel D are (1.0025, 0.6048077). Those of the RAD-2 FROC in panel D are (0.9008333, 0.6778846). Panels E and F confirm that RAD-2 is actually the better observer over the entire FPF range. AUCs under the two wAFROC curves in E are 0.560485714285714 for RAD-1 and 0.62384 for RAD-2. AUCs under the two ROC curves in F are 0.751334285714286 for RAD-1 and 0.785654285714286 for RAD-2. These confirm the visual impressions of panels in panels E and F. Notice that each ROC AUC is larger than the corresponding wAFROC AUC. 

## Summary of simulations

The following tables summarize the numerical values from the plots in this chapter. Table \@ref(tab:froc-vs-afroc-summary-table-rdr1) refers to the RAD-1 observer, and Table \@ref(tab:froc-vs-afroc-summary-table-rdr2) refers to the RAD-2 observer.

### Summary of RAD-1 simulations






\begin{table}

\caption{(\#tab:froc-vs-afroc-summary-table-rdr1)Summary of RAD-1 simulations: A refers to panel A, B refers to panel B, etc.}
\centering
\begin{tabular}[t]{l|l|l|l}
\hline
wAFROC-B & wAFROC-E & ROC-C & ROC-F\\
\hline
0.5731 & 0.5605 & 0.7499 & 0.7513\\
\hline
\end{tabular}
\end{table}


-   The first column is labeled "wAFROC-B", meaning the RAD-1 wAFROC AUC in panel B, which are identical for the three figures (one may visually confirm that the red curves in panels A, B ad C in the three figures are identical; likewise for the red curves in panels D, E and F).
-   The second column is labeled "wAFROC-E", meaning the RAD-1 wAFROC AUC in panel E, which are identical for the three figures.
-   The third column is labeled "ROC-C", meaning the RAD-1 ROC AUC in panel C, which are identical for the three figures.
-   The fourth column is labeled "ROC-F", meaning the RAD-1 ROC AUC in panel F, which are identical for the three figures.


### Summary of RAD-2 simulations



\begin{table}

\caption{(\#tab:froc-vs-afroc-summary-table-rdr2)Summary of RAD-2 simulations: Fig refers to the figure number in this chapter, A refers to panel A, B refers to panel B, etc.}
\centering
\begin{tabular}[t]{l|l|l|l|l}
\hline
Fig & wAFROC-B & wAFROC-E & ROC-C & ROC-F\\
\hline
1 & 0.6737 & 0.778 & 0.7453 & 0.8826\\
\hline
2 & 0.7075 & 0.872 & 0.7722 & 0.9343\\
\hline
3 & 0.6341 & 0.6238 & 0.7868 & 0.7857\\
\hline
\end{tabular}
\end{table}

-   The first column refers to the figure number, for example, "1" refers to Fig. \@ref(fig:froc-vs-afroc-plot1), "2" refers to Fig. \@ref(fig:froc-vs-afroc-plot2), and "3" refers to Fig. \@ref(fig:froc-vs-afroc-plot3).
-   The second column is labeled "wAFROC-B", meaning the RAD-2 wAFROC AUC corresponding to the blue curve in panel B.
-   The third column is labeled "wAFROC-E", meaning the RAD-2 wAFROC AUC corresponding to the blue curve in panel E.
-   The fourth column is labeled "ROC-C", meaning the RAD-2 ROC AUC corresponding to the blue curve in panel C.
-   The fifth column is labeled "ROC-F", meaning the RAD-2 ROC AUC corresponding to the blue curve in panel F.

### Comments {#froc-vs-wafroc-comments}

-   For the same figure label the RAD-1 panels are identical in the three figures. This is the reason why Table \@ref(tab:froc-vs-afroc-summary-table-rdr1) has only one row. A *fixed* RAD-1 dataset is being compared to *varying* RAD-2 datasets.
-   The first RAD-2 dataset, Fig. \@ref(fig:froc-vs-afroc-plot1) A, B or C, might be considered representative of an average radiologist, the second one, Fig. \@ref(fig:froc-vs-afroc-plot2) A, B or C, is a super-expert and the third one, Fig. \@ref(fig:froc-vs-afroc-plot3) A, B or C, is only nominally better than RAD-1.
-   Plots D, E and F are for hypothetical RAD-1 and RAD-2 observers that report *all* suspicious regions. The differences between A and D are minimal for the RAD-1 observer, but marked for the RAD-2 observer. Likewise for the differences between B and E.


## Effect size comparison {#froc-vs-afroc-effect-sizes}

* The effect size is defined as the AUC -- calculated using either wAFROC or ROC -- difference between RDR-2 and RDR-1 for the same figure. For example, for Fig. \@ref(fig:froc-vs-afroc-plot2) and the wAFROC AUC effect size, one takes the difference between the AUCs under the RAD-2 (blue) minus RAD-1 (red) curves in panel B. 
* In all three figures the wAFROC effect size (ES) is larger than the corresponding ROC effect size. 
* For Fig. \@ref(fig:froc-vs-afroc-plot1) panels B and C:
   + The wAFROC effect size is 0.100612857142857, 
   + The ROC effect size is -0.00465428571428572. 
* For Fig. \@ref(fig:froc-vs-afroc-plot2) panels B and C: 
   + The wAFROC effect size is 0.134422142857143, 
   + The ROC effect size is 0.0222185714285714. 
* For Fig. \@ref(fig:froc-vs-afroc-plot3) panels B and C: 
   + The wAFROC effect size is 0.0610014285714285, 
   + The ROC effect size is 0.0368542857142857. 


These results are summarized in Table \@ref(tab:froc-vs-afroc-effect-size-rdr2). 

Since effect size enters as the *square* in sample size formulas, wAFROC yields greater statistical power than ROC. The "small difference" example, corresponding to row number 2, is more typical of modality comparison studies where the modalities being compared are only slightly different. In this case the wAFROC effect size is about twice the corresponding ROC value - see chapter on FROC sample size TBA.



\begin{table}

\caption{(\#tab:froc-vs-afroc-effect-size-rdr2)Effect size comparions for RAD-1 simulations: Fig refers to the figure number in this chapter.}
\centering
\begin{tabular}[t]{l|l|l}
\hline
Fig & ES-wAFROC & ES-ROC\\
\hline
1 & 0.1006 & -0.004654\\
\hline
2 & 0.1344 & 0.02222\\
\hline
3 & 0.061 & 0.03685\\
\hline
\end{tabular}
\end{table}



## Performance depends on $\zeta_1$ {#froc-vs-wafroc-peformance-depends-on-zeta1}
Consider the wAFROC AUCs for the RAD-2 curves in Fig. \@ref(fig:froc-vs-afroc-plot2) panels B and E. The wAFROC AUC for RAD-2 in panel B is 0.707519285714286 while that for RAD-2 in panel E is 0.872028571428571. The only difference between the simulation parameters for the two curves are $\zeta_1 = 2$ for panel B and $\zeta_1 = -\infty$ for panel E. Clearly wAFROC AUC depends on the value of $\zeta_1$. 

A similar result applies when considering the ROC curves in Fig. \@ref(fig:froc-vs-afroc-plot2) panels C and F. The ROC AUC for RAD-2 in panel C is 0.772155714285714 while that for RAD-2 in panel F is 0.934321428571429. Clearly ROC AUC also depends on the value of $\zeta_1$. 

The reason is that in panels B and C the respective AUCs are depressed due to high value of threshold parameter. The (very good) radiologist is seriously under-reporting and choosing to operate near the origin of a steep wAFROC/ROC curve. It as as if in an ROC study the reader is giving too much importance to specificity and therefore not achieving higher sensitivity.

*Since performance depends on threshold, this opens up the possibility of optimizing performance by finding the threshold that maximizes AUC. This is the subject of the next chapter.*

## Discussion {#froc-vs-wafroc-Discussion}

## References {#froc-vs-wafroc-references}
