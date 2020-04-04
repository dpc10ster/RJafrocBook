# Negative and Positive Predictive Values {#NpvPpv}



## Introduction
Sensitivity and specificity have desirable characteristics, insofar as they reward the observer for correct decisions on actually diseased and actually non-diseased cases, respectively, so these quantities are expected to be independent of disease prevalence. Stated simply, one is dividing by the relevant denominator, so increased numbers of non-diseased cases are balanced by a corresponding increased number of correct decisions on non-diseased cases, and likewise for diseased cases. However, radiologists interpret cases in a “mixed” situation where cases could be positive or negative for disease and disease prevalence plays a crucial role in their decision-making – this point will be clarified shortly. Therefore, a measure of performance that is desirable from the researcher's point of view is not necessarily desirable from the radiologist's point of view. It should be obvious that if most cases are non-diseased, i.e., disease prevalence is close to zero, specificity, being correct on non-diseased cases, is more important to the radiologist. Otherwise, the radiologist would figuratively be crying "wolf" most of the time. The radiologist who makes too many FPs would discover it from subsequent clinical audits or daily case conferences, which are held in most large imaging departments. There is a cost to unnecessary false positives – the cost of additional imaging and / or needle-biopsy to rule out cancer, not to mention the pain and emotional trauma inflicted on the patient. Conversely, if disease prevalence is high, then sensitivity, being correct on diseased cases, is more important to the radiologist. With intermediate disease prevalence a weighted average of sensitivity and specificity, where the weighting involves disease prevalence, is desirable from the radiologist's point of view. 

The radiologist is less interested in the normalized probability of a correct decision on non-diseased cases. Rather interest is in the probability that a patient diagnosed as non-diseased is actually non-diseased. The reader should notice how the two probability definitions are "turned around" - more on this below. Likewise, the radiologist is less interested in the normalized probability of correct decisions on diseased cases; rather interest is in the probability that a patient diagnosed as diseased is actually diseased. These are termed negative and positive predictive values, respectively, and denoted NPV and PPV


## Relevant equations
* These are from Chapter 2 of my book.
* PPV = Positive Predictive Value
* NPV = Negative Predictive Value
* Acc = Accuracy
* $P(D)$ is the disease prevalence and $P(!D)$ is the complement, i.e., $P(!D) = 1 - P(D)$. 

\begin{equation*} 
NPV =\frac{P(!D)(1-FPF)}{P(!D)(1-FPF)+P(D)(1-TPF)}
\end{equation*}

\begin{equation*} 
PPV =\frac{P(D)(TPF)}{P(D)(TPF)+P(!D)FPF}
\end{equation*}

\begin{equation*} 
Acc =P(!D)(1-FPF)+P(D)(TPF)
\end{equation*}


## Example calculation of PPV, NPV and accuracy
* Typical disease prevalence in the US in screening mammography is 0.005. 
* A typical operating point, for an expert mammographer, is FPF = 0.1, TPF = 0.8. What are NPV and PPV?


```r
# disease prevalence in 
# USA screening mammography
prevalence <- 0.005
FPF <- 0.1 # typical operating point
TPF <- 0.8 #        do:
specificity <- 1-FPF
sensitivity <- TPF
NPV <- (1-prevalence)*(specificity)/
  ((1-prevalence)*(specificity) + 
     prevalence*(1-sensitivity))
PPV <- prevalence*sensitivity/
  (prevalence*sensitivity + 
     (1-prevalence)*(1-specificity))
cat("NPV = ", NPV, "\nPPV = ", PPV, "\n")
#> NPV =  0.9988846 
#> PPV =  0.03864734
accuracy <-(1-prevalence)*
  (specificity)+(prevalence)*(sensitivity)
cat("accuracy = ", accuracy, "\n")
#> accuracy =  0.8995
```

* Line 3 initializes the variable `prevalence`, the disease prevalence. In other words, `prevalence <- 0.005` causes the value `0.005` to be assigned to the variable prevalence. **Do not use prevalence = 0.005 as an assignment statement**: it may work some of the time, but can cause problems when one least expects it. In `R` one does not need to worry about the type of variable - integer, float, double, or declaring variables before using them; this can lead to "sloppy" programming constructs but for the most part `R` behaves reasonably. Line 4 assigns `0.1` to `FPF` and line 5 assigns `0.8` to `TPF`. Lines 6 and 7 initialize the variables specificity and sensitivity, respectively. 

* Line 8 calculates `NPV`, using Eqn. (2.27) (all equations refer to my book) and line 9 calculates `PPV`, using Eqn. (2.28). Line 10 prints the values of `NPV` and `PPV`, with a helpful message. The `cat()` function stands for *concatenate and print the comma-separated components of the argument*. The `cat()` function starts by printing the string variable "NPV = ", then it encounters a comma, then the variable name `NPV`, so it prints the value of the variable. Then it encounters another comma, and the string "PPV = ", which it prints. Then it encounters another comma and the variable name `PPV`, so it prints the value of this variable. Finally, it encounters the last comma, and the string "\\n", which stand for a newline character, which positions any subsequent output to the next line; without it any subsequent print statements would appear on the same line, which is usually not the intent. Line 11 calculates accuracy, Eqn. (2.17) and the next line prints it. 

## Discussion
If a woman has a negative diagnosis, chances are very small that she has breast cancer: the probability that the radiologist is incorrect in the negative diagnosis is 1 - NPV = 0.0011154. Even is she has a positive diagnosis, the probability that she actually has cancer is still only 0.0386473. That is why following a positive screening diagnosis the woman is recalled for further imaging, and if that reveals cause for reasonable suspicion, then additional imaging is performed, perhaps augmented with a needle-biopsy to confirm actual disease status. If the biopsy turns out positive, only then is the woman referred for cancer therapy. Overall, accuracy is 0.8995. The numbers in this illustration are for expert radiologists. In practice there is wide variability in radiologist performance.
