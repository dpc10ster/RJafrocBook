# Optimal operating point using ROC methodology {#optim-op-point-roc}

---
output:
  rmarkdown::pdf_document:
    fig_caption: yes        
    includes:  
      in_header: R/learn/my_header.tex
---



## Introduction {#optim-op-point-roc-intro}
Similar to previous chapter except it uses ROC AUC figure of merit.



## Methods {#optim-op-point-roc-methods}

Similar to previous chapter except it uses ROC AUC figure of merit.


### $\zeta_1$ optimization for $\lambda = 10$


Shown next is the variation of ROC AUC vs. $\zeta_1$ for $\lambda = 10$ and the four values of the $\mu$ parameter.





TBA


![(\#fig:optim-op-point-roc-AUC-vs-zeta1-10)Variation of AUC vs. $\zeta_1$ for $\lambda = 10$; AUC is the wAFROC AUC. panels are labeled by the value of $\mu$ and zetaMax (i.e., $\zeta_{\text{max}}$, the value of $\zeta_1$ that maximizes AUC).](22-optim-op-point-roc_files/figure-latex/optim-op-point-roc-AUC-vs-zeta1-10-1.pdf) 


Fig. \@ref(fig:optim-op-point-roc-AUC-vs-zeta1-10) corresponding to $\lambda = 10$ has four panels showing the variation of wAFROC AUC with $\zeta_1$. Each panel is labeled by the values of $\mu$ and  $\zeta_{\text{max}}$. For example, the panel labeled `mu = 1.5, zetaMax = 1.9` shows that AUC has a maximum at $\zeta_1 = 1.9$. For $\mu = 1$ the maximum is at the top of a broad plateau, but for higher values the maximum is better defined.


### $\zeta_1$ optimization for $\lambda = 1$

Shown next is the variation of wAFROC AUC vs. $\zeta_1$ for $\lambda = 1$ and the four values of the $\mu$ parameter.





![(\#fig:optim-op-point-roc-AUC-vs-zeta1-01)Variation of AUC vs. $\zeta_1$ for $\lambda = 1$.](22-optim-op-point-roc_files/figure-latex/optim-op-point-roc-AUC-vs-zeta1-01-1.pdf) 

Fig. \@ref(fig:optim-op-point-roc-AUC-vs-zeta1-01) corresponds to $\lambda = 1$ and employs a similar labeling scheme as Fig. \@ref(fig:optim-op-point-roc-AUC-vs-zeta1-10). For example, the panel labeled `mu = 1, zetaMax = 0.3` shows that AUC has a maximum at $\zeta_1 = 0.3$. 


















### Summary of simulations and comments {#optim-op-point-roc-comments-threshold-optimization}


\begin{table}

\caption{(\#tab:optim-op-point-roc-cad-optim-table-roc)Summary of optimal threshold values: "measure" refers to a performance measure, "mu1" refers to $\mu = 1$, etc. The row labels are as follows: AUC10 is the wAFROC AUC for lambda = 10, AUC01 is the wAFROC AUC for $\lambda = 1$, NLF10 is NLF for $\lambda = 10$, ..., LLF01 is LLF for $\lambda = 1$.}
\centering
\begin{tabular}[t]{l|r|r|r|r}
\hline
measure & mu1 & mu1.5 & mu2 & mu2.5\\
\hline
AUC10 & 0.60040 & 0.72509 & 0.84127 & 0.91997\\
\hline
AUC01 & 0.76760 & 0.87837 & 0.93851 & 0.96879\\
\hline
NLF10 & 9.98650 & 6.65767 & 4.99325 & 3.99460\\
\hline
LLF10 & 0.63210 & 0.77687 & 0.86466 & 0.91791\\
\hline
NLF01 & 0.84134 & 0.56090 & 0.42067 & 0.33654\\
\hline
LLF01 & 0.61774 & 0.77205 & 0.86350 & 0.91770\\
\hline
\end{tabular}
\end{table}

TBA

#### Explanations {#optim-op-point-roc-threshold-explanations}

![(\#fig:optim-op-point-roc-roc-10-first-two-plots)Extended FROC plots: panel labeled 10-1 is for $\lambda = 10$ and $\mu = 1$, and that labeled 10-1.5 is for $\lambda = 10$ and $\mu = 1.5$. The blue line indicates the optimal operating point.](22-optim-op-point-roc_files/figure-latex/optim-op-point-roc-roc-10-first-two-plots-1.pdf) 


TBA



![(\#fig:optim-op-point-roc-roc-10-next-two-plots)Extended FROC plots: panel labeled 10-2 is for $\lambda = 10$ and $\mu = 2$ and that labeled 10-2.5 is for $\lambda = 10$ and $\mu = 2.5$. The blue line indicates the optimal operating point.](22-optim-op-point-roc_files/figure-latex/optim-op-point-roc-roc-10-next-two-plots-1.pdf) 


TBA


![(\#fig:optim-op-point-roc-roc-01-first-two-plots)Extended FROC plots: panel labeled 1-1 is for $\lambda = 1$ and $\mu = 1$ and that labeled 10-1.5 is for $\lambda = 1$ and $\mu = 1.5$. The blue line indicates the optimal operating point.](22-optim-op-point-roc_files/figure-latex/optim-op-point-roc-roc-01-first-two-plots-1.pdf) 


TBA

![(\#fig:optim-op-point-roc-roc-01-next-two-plots)Extended FROC plots: panel labeled 1-2 is for $\lambda = 1$ and $\mu = 2$ and that labeled 1-2.5 is for $\lambda = 1$ and $\mu = 2.5$. The blue line indicates the optimal operating point.](22-optim-op-point-roc_files/figure-latex/optim-op-point-roc-roc-01-next-two-plots-1.pdf) 



* In Fig. \@ref(fig:optim-op-point-roc-roc-01-next-two-plots) panel labeled **1-2**: The vertical blue line is at NLF = 0.421 corresponding to LLF = 0.863. The end-point of the extended curve is (NLF = 0.467, LLF = 0.864). The highest operating point is at (NLF = 0.5, LLF = 0.865). 


* In Fig. \@ref(fig:optim-op-point-roc-roc-01-next-two-plots) panel labeled **1-2.5**: The vertical blue line is at NLF = 0.337 corresponding to LLF = 0.918. The end-point of the extended curve is (NLF = 0.373, LLF = 0.918). The highest operating point is at (NLF = 0.4, LLF = 0.918). 



## How to use the method {#optim-op-point-roc-how-to-use-method}
TBA  



## Discussion {#optim-op-point-roc-Discussion}
TBA 

## References {#optim-op-point-roc-references}
