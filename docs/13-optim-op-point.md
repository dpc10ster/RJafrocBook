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
The aim is determine the optimal operating point on an FROC. Two values of the $\lambda$ parameter are considered: $\lambda = 10$ and $\lambda = 1$. The first value would characterize a CAD system that generates about 10 times the number of latent NL marks as an expert radiologist, while the second value would characterize a CAD system that generates about the same number of latent NL marks as an expert radiologist. The $\nu$ parameter is kept at the same, namely $\nu = 1$. Four values of the $\mu$ parameter are considered: 1, 1.5, 2, 2.5. All else being equal, performance is expected to improve with increasing $\mu$. For each $\mu$ one scans $\zeta_1$, repeating the simulations and AUC and other computations for each value of $\zeta_1$. One determines that value of $\zeta_1$ that maximizes AUC; this is denoted $\zeta_{\text{max}}$. Finally, using the optimal $\zeta_1$ one calculates the corresponding (NLF,LLF) values, i.e., *the optimal operating point on the FROC* and the wAFROC AUC. A large number of cases is used, namely the number of non-diseased cases is $K_1 = 5000$ and the number of diseased cases is $K_2 = 7000$. This minimizes sampling variability while not requiring excessive computation times. 

### Simulations for $\lambda = 10$




![(\#fig:optim-op-point-plot5)Variation of AUC vs. $\zeta_1$ for $\lambda = 10$; AUC is the wAFROC AUC. The plots are labeled by the value of $\mu$ and zetaMax (i.e., $\zeta_{\text{max}}$, the value of $\zeta_1$ that maximizes AUC).](13-optim-op-point_files/figure-latex/optim-op-point-plot5-1.pdf) 


Fig. \@ref(fig:optim-op-point-plot5) corresponding to $\lambda = 10$ has four panels showing the variation of wAFROC AUC with $\zeta_1$. Each panel is labeled by the values of $\mu$ and  $\zeta_{\text{max}}$. For example, the panel labeled `mu = 1.5, zetaMax = 1.9` shows that AUC has a maximum at $\zeta_1 = 1.9$. For $\mu = 1$ the maximum is at the top of a broad plateau, but for higher values the maximum is better defined. 


### Simulations for $\lambda = 1$





![(\#fig:optim-op-point-plot6)Variation of AUC vs. $\zeta_1$ for $\lambda = 1$.](13-optim-op-point_files/figure-latex/optim-op-point-plot6-1.pdf) 

Fig. \@ref(fig:optim-op-point-plot6) corresponds to $\lambda = 1$ and employs a similar labeling scheme as Fig. \@ref(fig:optim-op-point-plot5). For example, the panel labeled `mu = 1, zetaMax = 0.4` shows that AUC has a maximum at $\zeta_1 = 0.4$. For each maximum the optimal operating point on the FROC is determined as well as the wAFROC AUCs.


















### Summary of simulations and comments {#optim-op-point-comments-threshold-optimization}


\begin{table}

\caption{(\#tab:optim-op-point-cad-optim-table)Summary of optimal threshold values: "measure" refers to a performance measure, "mu1" refers to $\mu = 1$, etc. The row labels are as follows: AUC10 is the wAFROC AUC for lambda = 10, AUC01 is the wAFROC AUC for $\lambda = 1$, NLF10 is NLF for $\lambda = 10$, ..., LLF01 is LLF for $\lambda = 1$.}
\centering
\begin{tabular}[t]{l|r|r|r|r}
\hline
measure & mu1 & mu1.5 & mu2 & mu2.5\\
\hline
AUC10 & 0.50224 & 0.55628 & 0.69876 & 0.83833\\
\hline
AUC01 & 0.60507 & 0.78199 & 0.88091 & 0.93461\\
\hline
NLF10 & 0.00687 & 0.19144 & 0.40378 & 0.63462\\
\hline
LLF10 & 0.00879 & 0.26769 & 0.62753 & 0.85659\\
\hline
NLF01 & 0.34458 & 0.42455 & 0.28963 & 0.18407\\
\hline
LLF01 & 0.45876 & 0.75189 & 0.85264 & 0.91039\\
\hline
\end{tabular}
\end{table}

Table \@ref(tab:optim-op-point-cad-optim-table) summarizes the results of the simulations. In this table the first two rows compare the AUCs for $\lambda=10$ and $\lambda=1$ for the four values of $\mu$. The next two rows show the operating point (NLF, LLF) for $\lambda = 10$ for the four values of $\mu$ and the final two rows are the operating point for $\lambda = 1$ for the four values of $\mu$. The following trends are evident.

* All else being equal, AUC increases with increasing $\mu$. Increasing the separation of the two unit variance normal distributions that determine the ratings of NLs and LLs leads to higher performance
* All else being equal, AUC increases with decreasing $\lambda$. Decreasing the propensity of the observer to generate NLs leads to increasing performance. 
* For each value of $\lambda$ optimal LLF increases with increasing $\mu$. 
* For $\lambda = 10$ optimal NLF increases with increasing $\mu$. 
* For $\lambda = 1$ optimal NLF *peaks* around $\mu = 1.5$. 

All of these observations make intuitive sense except, perhaps, that for NLF01. To understand the peaking behavior it is necessary to examine the FROC curves corresponding to the eight -- 2 $\lambda$ values and 4 $\mu$ values -- combinations of parameters. In the following eight plots the optimal value of NLF for each plot, corresponding to $\zeta_{\text{max}}$, are shown as red vertical lines. 

![(\#fig:optim-op-point-plot7a)The vertical red lines show the locations of the optimal NLFs. The plot labeled 10-1 is the FROC plot for $\lambda = 10$ and $\mu = 1$. The plot labeled 10-1.5 is the FROC plot for $\lambda = 10$ and $\mu = 1.5$.](13-optim-op-point_files/figure-latex/optim-op-point-plot7a-1.pdf) 


* In Fig. \@ref(fig:optim-op-point-plot7a) the plot labeled 10-1 is the *extended* FROC curve for $\lambda = 10$ and $\mu = 1$. The meaning of *extended* is explained in the immediately following footnote.
* The vertical red line is drawn at the *predicted* optimal NLF corresponding to $\zeta_{\text{max}}$ for this parameter combination, not the *empirical* NLF ^[Meaning of *extended*: due to sampling effects the predicted end-point will not, in general, coincide with the *empirical* end-point, but will be near it. In order to show a fuller extent of the FROC curve it is necessary to *extend* the observed curve beyond the predicted end-point. This was done by setting $\zeta_1$ = $\zeta_{\text{max}} - 0.5$, which has the effect of letting the curve run a little bit further to the right. As a concrete example the predicted end-point for the curve in question is (0.0068714, LLF = 0.0087887) while the empirical end-point is (0.0056667, LLF = 0.0096337) and the extended curve shown ends at (0.0364167, LLF = 0.0274704).].  
* In Fig. \@ref(fig:optim-op-point-plot7a) AUC performance is quite low. In fact AUC = 0.5022367. The optimal operating point of the algorithm is actually rather close to the origin, specifically NLF = 0.0068714 and LLF = 0.0087887.
* Since algorithm performance is so poor, the sensible choice for the algorithm designer is to only show those marks that have, according to the algorithm, very high confidence level for being right (note that an operating point near the origin corresponds to a high value of $\zeta$). 
* For higher values of $\mu$ shown in Fig. \@ref(fig:optim-op-point-plot7a) -- e.g., the plots labeled 10-1.5, 10-2 and 10-2.5 -- AUC performance progressively increases. It now makes sense to show marks with lower confidence levels corresponding to moving up the FROC curve. While it is true that one is also showing more NLs, the increase in the number of LLs shown is enough to compensate. This trend is seen to be true for all operating points listed in the third and fourth rows of Table \@ref(tab:optim-op-point-cad-optim-table). 
* It remains to explain the seemingly anomalous behavior seen in the fifth row of Table \@ref(tab:optim-op-point-cad-optim-table) - NLF shows a peak as a function of $\mu$. The relevant FROC curves are shown in In Fig. \@ref(fig:optim-op-point-plot7b). The basic reason is that as $\mu$ increases, the end-point of the FROC keeps moving upwards and to the left (approaching NLF = 0 and LLF = 1 in the limit of infinite $\mu$). Because of this effect the expected increase in NLF seen in the third row of the table is terminated - one literally runs out of FROC curve to move up on. Another way of explaining this is that in In Fig. \@ref(fig:optim-op-point-plot7a) the true end-point, i.e., that corresponding to $\zeta_1 = -\infty$, is much further to the right, than in Fig. \@ref(fig:optim-op-point-plot7b). This allows NLF to keep increasing in Fig. \@ref(fig:optim-op-point-plot7a) but not in Fig. \@ref(fig:optim-op-point-plot7b). 

STOP

![(\#fig:optim-op-point-plot7b)The vertical red lines show the locations of the optimal NLFs. The plot labeled 10-2 is the FROC plot for $\lambda = 10$ and $\mu = 2$. The plot labeled 10-2.5 is FROC plot for $\lambda = 10$ and $\mu = 2.5$.](13-optim-op-point_files/figure-latex/optim-op-point-plot7b-1.pdf) 


Fig. \@ref(fig:optim-op-point-plot7b): Plot labeled 10-1: The vertical red line is at NLF = 0.4037833. Plot labeled 10-1.5: The vertical red line is at NLF = 0.634621.


![(\#fig:optim-op-point-plot7c)The vertical red lines show the locations of the optimal NLFs. The plot labeled 1-1 is the FROC plot for $\lambda = 1$ and $\mu = 1$. The plot labeled 10-1.5 is the FROC plot for $\lambda = 1$ and $\mu = 1.5$.](13-optim-op-point_files/figure-latex/optim-op-point-plot7c-1.pdf) 

Fig. \@ref(fig:optim-op-point-plot7c): Plot labeled 1-1: The vertical red line is at NLF = 0.3445783. Plot labeled 1-1.5: The vertical red line is at NLF = 0.4245538.


![(\#fig:optim-op-point-plot7d)The vertical red lines show the locations of the optimal NLFs. The plot labeled 1-2 is the FROC plot for $\lambda = 1$ and $\mu = 2$. The plot labeled 1-2.5 is the FROC plot for $\lambda = 1$ and $\mu = 2.5$.](13-optim-op-point_files/figure-latex/optim-op-point-plot7d-1.pdf) 

Fig. \@ref(fig:optim-op-point-plot7d): Plot labeled 1-2: The vertical red line is at NLF = 0.2896299. Plot labeled 1-2.5: The vertical red line is at NLF = 0.1840689.



## Discussion {#optim-op-point-Discussion}

## References {#optim-op-point-references}
