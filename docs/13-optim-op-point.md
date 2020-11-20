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

* It is taken as an axiomatic truth that *the optimal reporting threshold $\zeta_{1\text{max}}$ is that value of $\zeta_1$ that maximizes the AUC under the wAFROC*.  

* This chapter examines the effect of changing the reporting threshold $\zeta_1$ on the wAFROC AUC, with the object of determining the value that maximizes the AUC. 



## Methods {#optim-op-point-methods}
The aim is determine the optimal operating point on an FROC. Two values of the $\lambda$ parameter are considered: $\lambda = 10$ and $\lambda = 1$. The first value would characterize a CAD system that generates about 10 times the number of latent NL marks as an expert radiologist, while the second value would characterize a CAD system that generates about the same number of latent NL marks as an expert radiologist. The $\nu$ parameter is kept at the same, namely $\nu = 1$. Four values of the $\mu$ parameter are considered: 1, 1.5, 2, 2.5. All else being equal, performance is expected to improve with increasing $\mu$. For each $\mu$ one scans $\zeta_1$, repeating the simulations and AUC and other computations for each value of $\zeta_1$. One determines that value of $\zeta_1$ that maximizes AUC; this is denoted $\zeta_{1\text{max}}$. Finally, using the optimal $\zeta_1$ one calculates the corresponding (NLF,LLF) values, i.e., *the optimal operating point on the FROC* and the wAFROC AUC. A large number of cases is used, namely the number of non-diseased cases is $K_1 = 5000$ and the number of diseased cases is $K_2 = 7000$. This minimizes sampling variability while not requiring excessive computation times. 

### Simulations for $\lambda = 10$




![(\#fig:optim-op-point-plot5)Variation of AUC vs. $\zeta_1$ for $\lambda = 10$; AUC is the wAFROC AUC. The plots are labeled by the value of $\mu$ and zetaMax (the value of $\zeta_1$ that maximizes AUC).](13-optim-op-point_files/figure-latex/optim-op-point-plot5-1.pdf) 


Fig. \@ref(fig:optim-op-point-plot5) corresponding to $\lambda = 10$ has four panels showing the variation of wAFROC AUC with $\zeta_1$. Each panel is labeled by the values of $\mu$ and  $\zeta_{1\text{max}}$. For example, the panel labeled `mu = 1.5, zetaMax = 1.9` shows that AUC has a maximum at $\zeta_1 = 1.9$. For $\mu = 1$ the maximum is at the top of a broad plateau, but for higher values the maximum is better defined. 


### Simulations for $\lambda = 1$





![(\#fig:optim-op-point-plot6)Variation of AUC vs. $\zeta_1$ for $\lambda = 1$; AUC is the wAFROC AUC. The plots are labeled by the value of $\mu$ and zetaMax (the value of $\zeta_1$ that maximizes AUC).](13-optim-op-point_files/figure-latex/optim-op-point-plot6-1.pdf) 

Fig. \@ref(fig:optim-op-point-plot6) corresponds to $\lambda = 1$ and employs a similar labeling scheme as Fig. \@ref(fig:optim-op-point-plot5). For example, the panel labeled `mu = 1, zetaMax = 0.4` shows that AUC has a maximum at $\zeta_1 = 0.4$. For each maximum the optimal operating point on the FROC is determined as well as the wAFROC AUCs.


















### Comments {#optim-op-point-comments-threshold-optimization}

\begin{table}

\caption{(\#tab:optim-op-point-cad-optim-table)Summary of CAD optimal threshold simulations: "measure" refers to a performance measure, "mu1" refers to $\mu = 1$, etc. The row labels are as follows: AUC10 is the wAFROC AUC for lambda = 10, AUC01 is the wAFROC AUC for $\lambda = 01$, NLF10 is NLF for $\lambda = 1$, ..., LLF01 is LLF for $\lambda = 1$.}
\centering
\begin{tabular}[t]{l|r|r|r|r}
\hline
measure & mu1 & mu1.5 & mu2 & mu2.5\\
\hline
AUC10 & 0.50224 & 0.55628 & 0.69876 & 0.83833\\
\hline
AUC01 & 0.60507 & 0.78199 & 0.88091 & 0.93461\\
\hline
NLF10 & 0.00567 & 0.19583 & 0.39842 & 0.63308\\
\hline
LLF10 & 0.00963 & 0.27575 & 0.63134 & 0.86064\\
\hline
NLF01 & 0.33925 & 0.42092 & 0.28742 & 0.18475\\
\hline
LLF01 & 0.45813 & 0.75553 & 0.85349 & 0.90996\\
\hline
\end{tabular}
\end{table}

In Table \@ref(tab:optim-op-point-cad-optim-table) the first two rows compare the AUCs, the next two rows show the operating point (NLF, LLF) for $\lambda = 10$ and the final two rows are the operating point for $\lambda = 1$. The following trends are evident.

* All else being equal, AUC increases with increasing $\mu$. Increasing the separation of the two unit variance normal distributions that determine the ratings of NLs and LLs leads to higher performance
* All else being equal, AUC increases with decreasing $\lambda$. Decreasing the propensity of the observer to generate NLs leads to increasing performance. 
* For each value of $\lambda$ optimal LLF increases with increasing $\mu$. 
* For $\lambda = 10$ optimal NLF increases with increasing $\mu$. 
* For $\lambda = 0$ optimal NLF peaks around $\mu = 1.5$. 


![(\#fig:optim-op-point-plot7a)The vertical red lines show the locations of the optimal NLFs. The plot labeled 10-1 is the FROC plot for $\lambda = 10$ and $\mu = 1$. The plot labeled 10-1.5 is the FROC plot for $\lambda = 10$ and $\mu = 1.5$.](13-optim-op-point_files/figure-latex/optim-op-point-plot7a-1.pdf) 


* In Fig. \@ref(fig:optim-op-point-plot7a) the plot labeled 10-1 is a FROC plot for $\lambda = 10$ and $\mu = 1$; AUC performance is quite low, AUC = 0.5022367 and the optimal operating point of the algorithm is near the origin, specifically, NLF = 0.0056667 and LLF = 0.0096337. If the algorithm is this poor, the sensible choice for the algorithm designer is to only show those marks that have, according to the algorithm, high confidence level for being right (note that an operating point near the origin corresponds to a high value of $\zeta_1$). For higher values of $\mu$ AUC performance increases and it makes sense to then show marks with a somewhat lower confidence level, corresponding to moving up the curve. While it is true that one is possibly showing more NLs, the fraction of LLs increases even more. This trend is seen to be true for all operating points listed in the third and fourth rows of Table \@ref(tab:optim-op-point-cad-optim-table). Performance of the algorithm is very poor and it makes sense to set a high threshold corresponding to a low value of NLF = 0.0056667. The observer is only shown very high confidence level marks. 
* In the plot labeled 10-1.5 the FROC plot is for $\lambda = 10$ and $\mu = 1.5$. Performance is better and it makes sense to set the threshold at a lower value, corresponding to a higher NLF = 0.1958333, and because of the increased algorithm performance it makes sense to show him lower confidence level marks. 

STOP

![(\#fig:optim-op-point-plot7b)The vertical red lines show the locations of the optimal NLFs. The plot labeled 10-2 is the FROC plot for $\lambda = 10$ and $\mu = 2$. The plot labeled 10-2.5 is FROC plot for $\lambda = 10$ and $\mu = 2.5$.](13-optim-op-point_files/figure-latex/optim-op-point-plot7b-1.pdf) 


Fig. \@ref(fig:optim-op-point-plot7b): Plot labeled 10-1: The vertical red line is at NLF = 0.3984167. Plot labeled 10-1.5: The vertical red line is at NLF = 0.6330833.


![(\#fig:optim-op-point-plot7c)The vertical red lines show the locations of the optimal NLFs. The plot labeled 1-1 is the FROC plot for $\lambda = 1$ and $\mu = 1$. The plot labeled 10-1.5 is the FROC plot for $\lambda = 1$ and $\mu = 1.5$.](13-optim-op-point_files/figure-latex/optim-op-point-plot7c-1.pdf) 

Fig. \@ref(fig:optim-op-point-plot7c): Plot labeled 1-1: The vertical red line is at NLF = 0.33925. Plot labeled 1-1.5: The vertical red line is at NLF = 0.4209167.


![(\#fig:optim-op-point-plot7d)The vertical red lines show the locations of the optimal NLFs. The plot labeled 1-2 is the FROC plot for $\lambda = 1$ and $\mu = 2$. The plot labeled 1-2.5 is the FROC plot for $\lambda = 1$ and $\mu = 2.5$.](13-optim-op-point_files/figure-latex/optim-op-point-plot7d-1.pdf) 

Fig. \@ref(fig:optim-op-point-plot7d): Plot labeled 1-2: The vertical red line is at NLF = 0.2874167. Plot labeled 1-2.5: The vertical red line is at NLF = 0.18475.



## Discussion {#optim-op-point-Discussion}

## References {#optim-op-point-references}
