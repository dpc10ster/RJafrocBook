---
output:
  pdf_document: default
  html_document: default
---
# Sample size estimation for ROC studies {#RocSampleSize}



## Introduction
The question addressed in this chapter is "how many readers and cases", usually abbreviated to "sample-size", should one employ to conduct a "well-planned" ROC study. The reasons for the quotes around "well-planned" will shortly become clear. If cost were no concern, the reply would be: "as many readers and cases as one can get". There are other causes affecting sample-size, e.g., the data collection paradigm and analysis, however, this chapter is restricted to the MRMC ROC data collection paradigm, with data analyzed by the DBMH or the ORH methods described in previous chapters. It turns out that provided one can specify conceptually valid effect-sizes between different paradigms (i.e., in the same "units"), the methods described in this chapter are extensible to other paradigms; see TBA Chapter 19 for sample size estimation for FROC studies. *For this reason it is important to understand the concepts of sample-size estimation in the simpler ROC context.*
 
For simplicity and practicality, this chapter is restricted to analysis of two-treatment data (I = 2). The purpose of most imaging system assessment studies is to determine, for a given diagnostic task, whether radiologists perform better using a new treatment over the conventional treatment, and whether the difference is statistically significant. Therefore, the two-treatment case is the most common one encountered. While it is possible to extend the methods to more than two treatments, the extensions are not, in my opinion, clinically interesting. 
	
Assume the figure of merit (FOM) $\theta$  is chosen to be the area AUC under the ROC curve (empirical or fitted is immaterial as far as the formulae are concerned; however, the choice will affect statistical power - the dependence has not been studied). The statistical analysis determines the significance level of the study, i.e., the probability or p-value for incorrectly rejecting the null hypothesis (NH) that the two  $\theta$s are equal: $NH: \theta_1 = \theta_2$, where the subscripts refer to the two treatments. If the p-value is smaller than a pre-specified $\alpha$, typically set at 5%, one rejects the NH and declares the treatments different at the $\alpha$ significance level. Statistical power is the probability of correctly rejecting the null hypothesis when the alternative hypothesis $AH: \theta_1 \neq  \theta_2$ is true, (TBA Chapter 08). 

The value of the *true* difference between the treatments, i.e., the *true effect-size* is, of course, unknown. If it were known, there would be no need to conduct the ROC study. One would simply adopt the treatment with the higher $\theta$. Sample-size estimation involves making an educated guess regarding the true effect-size , called the *anticipated effect size*, and denoted by $d$. To quote Harold Kundel [@RN1383]: "any calculation of power amounts to specification of the anticipated effect-size". Increasing the anticipated effect size  will increase statistical power but may represent an unrealistic expectation of the true difference between the treatments, in the sense that it overestimates the ability of technology to achieve this much improvement. An unduly small  might be clinically insignificant, besides requiring a very large sample-size to achieve sufficient statistical power. 

Statistical power depends on the magnitude of $d$ divided by the standard deviation $\sigma(d)$ of $d$, i.e. $D=\frac{\left | d \right |}{\sigma (d)}$. The sign is relevant as it determines whether the project is worth pursuing at all (see §11.8.4). The ratio is termed [@cohen1988statistical] Cohen's D. When this signal-to-noise-ratio-like quantity is large, statistical power approaches 100%. Reader and case variability and data correlations determine  $\sigma(d)$. No matter how small the anticipated $d$, as long as it is finite, then, using sufficient numbers of readers and cases  $\sigma(d)$ can be made sufficiently small to achieve near 100% statistical power. Of course, a very small effect-size may not be clinically significant. There is a key difference between statistical significance and clinical significance. An effect-size in AUC units could be so small, e.g., 0.001, as to be clinically insignificant, but by employing a sufficiently large sample size one could design a study to detect this small and clinically meaningless difference with near unit probability, i.e., high statistical power.

What determines clinical significance? A small effect-size, e.g., 0.01 AUC units, could be clinically significant if it applies to a large population, where the small benefit in detection rate is amplified by the number of patients benefiting from the new treatment. In contrast, for an "orphan" disease, i.e., one with very low prevalence, an effect-size of 0.05 might not be enough to justify the additional cost of the new treatment. The improvement might have to be 0.1 before it is worth it for a new treatment to be brought to market. One hates to monetize life and death issues, but there is no getting away from it, as cost/benefit issues determine clinical significance. The arbiters of clinical significance are engineers, imaging scientists, clinicians, epidemiologists, insurance companies and those who set government health care policies. The engineers and imaging scientists determine whether the effect-size the clinicians would like is feasible from technical and scientific viewpoints. The clinician determines, based on incidence of disease and other considerations, e.g., altruistic, malpractice, cost of the new device and insurance reimbursement, what effect-size is justifiable. Cohen has suggested that d values of 0.2, 0.5, and 0.8 be considered small, medium, and large, respectively, but he has also argued against their indiscriminate usage. However, after a study is completed, clinicians often find that an effect-size that biostatisticians label as small may, in certain circumstances, be clinically significant and an effect-size that they label as large may in other circumstances be clinically insignificant. Clearly, this is a complex issue. Some suggestions on choosing a clinically significant effect size are made in (TBA §11.12).

Having developed a new imaging modality the R&D team wishes to compare it to the existing standard with the short-term goal of making a submission to the FDA to allow them to perform pre-market testing of the device. The long-term goal is to commercialize the device. Assume the R&D team has optimized the device based on physical measurements, (TBA Chapter 01), perhaps supplemented with anecdotal feedback from clinicians based on a few images. Needed at this point is a pilot study. A pilot study, conducted with a relatively small and practical sample size, is intended to provide estimates of different sources of variability and correlations. It also provides an initial estimate of the effect-size, termed the *observed effect-size*, $d$. Based on results from the pilot the sample-size tools described in this chapter permit estimation of the numbers of readers and cases that will reduce $\sigma(d)$  sufficiently to achieve the desired power for the larger "pivotal" study. [A distinction could be made in the notation between observed and anticipated effect sizes, but it will be clear from the context. Later, it will be shown how one can make an educated guess about the anticipated effect size from an observed effect size.]
  
This chapter is concerned with multiple-reader MRMC studies that follow the fully crossed factorial design meaning that each reader interprets a common case-set in all treatments. Since the resulting pairings (i.e., correlations) tend to decrease $\sigma(d)$  (since the variations occur in tandem, they tend to cancel out in the difference, see (TBA Chapter 09, Introduction), for Dr. Robert Wagner's sailboat analogy) it yields more statistical power compared to an unpaired design, and consequently this design is frequently used. Two sample-size estimation procedures for MRMC are the Hillis-Berbaum method [@RN1476] and the Obuchowski-Rockette [@RN1971] method. With recent work by Hillis, the two methods have been shown to be substantially equivalent. 

This chapter will focus on the DBMH approach. Since it is based on a standard ANOVA model, it is easier to extend the NH testing procedure described in Chapter 09 to the alternative hypothesis, which is relevant for sample size estimation. [TBA Online Appendix 11.A shows how to translate the DBMH formulae to the ORH method [@RN2137].] 

Given an effect-size, and choosing this wisely is the most difficult part of the process, the method described in this chapter uses pseudovalue variance components estimated by the DBMH method to predict sample-sizes (i.e., different combinations of numbers of readers and cases) necessary to achieve a desired power. 

## Statistical Power {#StatPower1}
The concept of statistical power was introduced in [TBA Chapter 08] but it is worth repeating. There are two possible decisions following a test of a null hypothesis (NH): reject or fail to reject the NH. Each decision is associated with a probability on an erroneous conclusion. If the NH is true and one rejects it, the probability of the ensuing Type-I error is  $\alpha$. If the NH is false and one fails to reject it, the probability of the ensuing Type II- error is $\beta$. Statistical power is the complement of $\beta$, i.e., 

\begin{equation}
Power = 1 - \beta
(\#eq:DefinitionStatPower)
\end{equation}

Thus, statistical power is defined as the probability of (correctly) rejecting the null hypothesis when the null hypothesis is false. Typically, one aims for $\beta = 0.2$  or less, i.e., a statistical power of 80% or more. Again, like $\alpha$ = 0.05, this is a convention, and more nuanced cost-benefit considerations may cause the researcher to adopt a different value in the study design.

### Sample size estimation for random-reader random-cases

### Estimation of the covariance matrix

### Meaning of the covariance matrix in \@ref(eq:ExampleSigma)

### Code illustrating the covariance matrix

### Significance testing

### p-value and confidence interval

### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments


## Multiple-reader multiple-treatment ORH model

### Structure of the covariance matrix {#StrCovMatrix}

### Physical meanings of the covariance terms

### ORH random-reader random-case analysis

#### Decision rule, p-value and confidence interval

### Fixed-reader random-case (FRRC) analysis

### Random-reader fixed-case (RRFC) analysis

### Single-treatment multiple-reader analysis

## Discussion/Summary

## References  

