# The Binary Task {#binaryTask0}




## Introduction {#binaryTask0Intro}
In the previous chapter four observer performance paradigms were introduced: the receiver operating characteristic (ROC), the free-response ROC (FROC), the location ROC (LROC) and the region of interest (ROI). In the chapters comprising this section, i.e., Chapter 02 - Chapter 07, focus is on the ROC paradigm, where each case is rated for confidence in presence of disease. While a multiple point rating scale is generally used, in this chapter it is assumed that the ratings are binary, and the allowed values are "1" vs. "2". Equivalently, the ratings could be "non-diseased" vs. "diseased", "negative" vs. "positive", etc. In the literature this method of data acquisition is also termed the "yes/no" procedure1,2. The reason for restricting, for now, to the binary task is that the multiple rating task can be shown to be equivalent to a number of simultaneously conducted binary tasks. So understanding the simpler method is a good starting point.

Since the truth is also binary, this chapter could be named the binary-truth binary-decision task. The starting point is a 2 x 2 table summarizing the outcomes in such studies and useful fractions that can be defined from the counts in this table, the most important ones being true positive fraction (TPF) and false positive fraction (FPF). These are used to construct measures of performance, some of which are desirable from the researcher's point of view, but others are more relevant to radiologists. The concept of disease prevalence is introduced and used to formulate relations between the different types of measures. An R example of calculation of these quantities is given that is only slightly more complicated than the demonstration in the prior chapter. 

## Decision vs. truth: the fundamental 2x2 table of ROC analysis {#binaryTask0Truth}
In this book, the term case is used for images obtained for diagnostic purposes, of a patient; often multiple images of a patient, sometimes from different modalities, are involved in an interpretation; all images of a single patient, that are used in the interpretation, are collectively referred to as a case. A familiar example is the 4-view presentation used in screening mammography, where two views of each breast are available for viewing.

Let D represent the radiologist’s decision, with   representing the decision “case is non-diseased” and   representing the decision “case is diseased”. Let T denote the truth with   representing “case is actually non-diseased” and   representing “case is actually diseased”. It is assumed that, prior to the interpretation, the radiologist does not know the truth state of the case and the decision is based on information contained in the case. Each decision, one of two values, will be associated with one of two truth states, resulting in an entry in one of 4 cells arranged in a 2 x 2 layout, termed the decision vs. truth table, Table 2.1, which is of fundamental importance in observer performance. The cells are labeled as follows. The abbreviation TN, for true negative, represents a   decision on a   case. Likewise, FN, for false negative, represents a   decision on a  case (also termed a "miss"). Similarly, FP, for false positive, represents a   decision on a  case (a "false-alarm") and TP, for true positive, represents a  decision on a   case (a "hit"). 



\begin{table}

\caption{(\#tab:binaryTask0truthTable)Truth Table.}
\centering
\begin{tabular}[t]{l|l|l}
\hline
  & T=1 & T=2\\
\hline
D=1 & TN & FN\\
\hline
D=2 & FP & TP\\
\hline
\end{tabular}
\end{table}

Table \@ref(tab:binaryTask0truthTable2) shows the numbers (indicated by the hash symbol prefix) of decisions in each of the four categories defined in Table \@ref(tab:binaryTask0truthTable). Specifically, n(TN) is the number of true negative decisions, n(FN) is the number of false negative decisions, etc. The last row is the sum of the corresponding columns. The sum of the number of true negative decisions n(TN) and the number of false positive decisions n(FP) must equal the total number of non-diseased cases, denoted $K_1$. Likewise, the sum of the number of false negative decisions n(FN) and the number of true positive decisions n(TP) must equal the total number of diseased cases, denoted $K_2$. The last column is the sum of the corresponding rows. The sum of the number of true negative n(TN) and false negative n(FN) decisions is the total number of negative decisions, denoted n(N). Likewise, the sum of the number of false positive n(FP) and true positive n(TP) decisions is the total number of positive decisions, denoted n(P). Since each case yields a decision, the bottom-right corner cell is n(N) + n(P), which must also equal $K_1+K_2$, the total number of cases $K$. These statements are summarized in Eqn. \@ref(eq:binaryTask0TruthTableEqns).

\begin{equation} 
\left.\begin{matrix}
K_1=n(TN)+n(FP)\\ 
K_2=n(FN)+n(TN)\\ 
n(N)=n(TN)+n(FN)\\ 
n(P)=n(TP)+n(FP)\\
K=K_1+K_2=n(N)+n(P)
\end{matrix}\right\}
(\#eq:binaryTask0TruthTableEqns)
\end{equation} 



\begin{table}

\caption{(\#tab:binaryTask0truthTable2)Cell counts.}
\centering
\begin{tabular}[t]{l|l|l|l}
\hline
  & T=1 & T=2 & RowSums\\
\hline
D=1 & n(TN) & n(FN) & n(N)=n(TN)+n(FN)\\
\hline
D=2 & n(FP) & n(TP) & n(P)=n(FP)+n(TP)\\
\hline
ColSums & $K_1$=n(TN)+n(FP) & $K_2$=n(FN)+n(TP) & $K=K_1+K_2$=n(N)+n(P)\\
\hline
\end{tabular}
\end{table}

## Sensitivity and specificity
The notation $P(D|T)$ indicates the probability of diagnosis D given truth state T (the vertical bar symbol is used to denote a conditional probability, i.e., what is to the left of the vertical bar depends on the condition appearing to the right of the vertical bar being true). 

## Summary{#binaryTask0-Summary}
## Discussion{#binaryTask0-Discussion}
## References {#binaryTask0-references}

