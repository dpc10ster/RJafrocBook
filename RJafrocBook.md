--- 
title: "The RJafroc Book"
author: "Dev P. Chakraborty, PhD"
date: "2020-10-28"
site: bookdown::bookdown_site
output: 
   bookdown::pdf_document: default
documentclass: book
bibliography: [packages.bib, myRefs.bib]
biblio-style: apalike
link-citations: yes
github-repo: dpc10ster/RJafrocBook
description: "Updated observer-performance book based on RJafroc."
---

# Preface {-}

Placeholder


## A note on the online distribution mechanism of the book {-}
## Contributing to this book {-}
## Is this book relevant to you and what are the alternatives? {-}
## ToDos {-}

<!--chapter:end:index.Rmd-->


# (PART\*) ROC paradigm {-}
# Preliminaries {#preliminaries}

Placeholder


## Introduction {#preliminariesIntro}
## Clinical tasks
### Workflow in an imaging study 
### The screening and diagnostic workup tasks
## Imaging device development and its clinical deployment
### Physical measurements
### Quality Control and Image quality optimization
## Image quality vs. task performance
## Why physical measures of image quality are not enough
## Model observers
## Measuring observer performance: four paradigms
### Basic approach to the analysis
### Historical notes
## Hierarchy of assessment methods
## Overview of the book and how to use it
### Overview of the book
#### Part A: The ROC paradigm
#### Part B: The statistics of ROC analysis
#### Part C: The FROC paradigm
#### Part D: Advanced topics
#### Part E: Appendices (TBA)
### How to use the book
## Summary{#preliminaries-Summary}
## Discussion{#preliminaries-Discussion}
## References {#preliminaries-references}

<!--chapter:end:01-preliminaries.Rmd-->


# The Binary Task {#binaryTask0}

Placeholder


## Introduction {#binaryTask0Intro}
## The fundamental 2x2 table {#binaryTask0Truth}
## Sensitivity and specificity
### Reasons for the names sensitivity and specificity
### Estimating sensitivity and specificity
## Disease prevalence
## Accuracy
## Negative and positive predictive values 
### Example calculation of PPV, NPV and accuracy {#binaryTask0NpvPpvCode}
### Comments {#binaryTask0NpvPpvComments}
### PPV and NPV are irrelevant to laboratory tasks {#binaryTask0NpvPpvIrrel2LabTasks}
## Summary{#binaryTask0-Summary}
## Discussion{#binaryTask0-Discussion}
## References {#binaryTask0-references}

<!--chapter:end:02-binary-task.Rmd-->


# Modeling the Binary Task {#binaryTask}

Placeholder


## Introduction {#binaryTaskIntro}
## Decision variable and decision threshold
### Existence of a decision variable {#binaryTaskDecisionVariablelModel}
### Existence of a decision threshold
### Adequacy of the training session
## Changing the decision threshold: Example I 
## Changing the decision threshold: Example II
## The equal-variance binormal model
## The normal distribution
## Analytic expressions for specificity and sensitivity
## Demonstration of the concepts of sensitivity and specificity
### Estimating mu from a finite sample
### Changing the seed variable: case-sampling variability
### Increasing the numbers of cases
## Inverse variation of sensitivity and specificity and the need for a single FOM
## The ROC curve
### The chance diagonal
### The guessing observer
### Symmetry with respect to negative diagonal
### Area under the ROC curve
### Properties of the equal-variance binormal model ROC curve
### Comments 
### Physical interpretation of the mu-parameter
## Assigning confidence intervals to an operating point
## Variability in sensitivity and specificity: the Beam et al study
## Summary{#binaryTask-Summary}
## Discussion{#binaryTask-Discussion}
## References {#binaryTask-references}

<!--chapter:end:03-modeling-binary-task.Rmd-->


# Ratings Paradigm {#ratingsParadigm}

Placeholder


## Introduction
## The ROC counts table
## Operating points from counts table
### Labeling the points
### Examples
## Automating all this
## Relation between ratings paradigm and the binary paradigm
## Ratings are not numerical values
## A single "clinical" operating point from ratings data
## The forced choice paradigm
## Observer performance studies as laboratory simulations of clinical tasks
## Discrete vs. continuous ratings: the Miller study
## The controversy
## Discussion {#ratingsParadigm-discussion}
## References  {#ratingsParadigm-references} 

<!--chapter:end:04-ratings-paradigm.Rmd-->


# Empirical AUC {#empiricalAUC}

Placeholder


## Introduction {#empiricalAUC-Intro}
## The empirical ROC plot {#empirical-ROC-plot}
### Notation for cases
### An empirical operating point
## Empirical operating points from ratings data
## AUC under the empirical ROC plot
## The Wilcoxon statistic
## Bamber’s Equivalence theorem
## Importance of Bamber’s theorem
## Discussion / Summary
## Appendix 5.A: Details of Wilcoxon theorem
### Upper triangle
### Lowest trapezoid
## References {#empiricalAUC-references} 

<!--chapter:end:05-empirical-auc.Rmd-->


# Binormal model {#BinormalModel}

Placeholder


## Introduction {#BinormalModelIntro}
## The binormal model {#BinormalModelTheModel}
### Binning the data
### Invariance of the binormal model to arbitrary monotone transformations
### Expressions for sensitivity and specificity
### Binormal model in standard notation
### Properties of the binormal model ROC curve
### Density functions (pdfs) of the binormal model
## Fitting an ROC curve to data points
### A JAVA fitted ROC curve
### A simplistic straight line fit to the ROC curve
#### Least-squares estimation
### Maximum likelihood estimation (MLE)
### Code implementing MLE
### Validating the fitting model
### Estimating the covariance matrix
### Estimating the variance of Az
### Single FOM derived from ROC curve
## Discussion{#BinormalModel-Discussion}
## References {#BinormalModel-references}

<!--chapter:end:06-binormal-model.Rmd-->


# Sources of AUC variability {#sourcesVariability}

Placeholder


## Introduction {#sourcesVariabilityIntro}
## Three sources of variability {#sourcesVariability3sources}
## Dependence of AUC on the case sample
### Case sampling variability of AUC
## DeLong method {#sourcesVariabilityDeLong}
## Bootstrap method {#sourcesVariabilityBootstrap}
### Demonstration of the bootstrap method
## Jackknife method {#sourcesVariabilityJackknife}
## Calibrated simulator {#sourcesVariabilityCalSimulator}
### The need for a calibrated simulator
### Implementation of a simple calibrated simulator
#### Parametric AUC results
#### Non-parametric AUC results
## Discussion{#sourcesVariability-Discussion}
## References {#sourcesVariability-references}

<!--chapter:end:07-sources-variability-auc.Rmd-->


# (PART\*) Significance Testing {-}
# Hypothesis Testing {#HypothesisTesting}

Placeholder


## Introduction {#HypothesisTesting-introduction}
## Single-modality single-reader ROC study
## Type-I errors
## One vs. two sided tests
## Statistical power
### Factors affecting statistical power
## Comments {#HypothesisTestingComments}
## Why alpha is chosen as 5%
## Discussion {#HypothesisTestingDiscussion}
## References {#HypothesisTesting-references}

<!--chapter:end:08-hypothesis-testing.Rmd-->


# DBM method background {#DBMAnalysisBkgrnd}

Placeholder


## Introduction {#DBMAnalysisBkgrnd-introduction}
### Historical background
### The Wagner analogy
### The shortage of numbers to analyze and a pivotal breakthrough
### Organization of chapter
## Random and fixed factors{#DBMAnalysisBkgrnd-random-fixed-factors}
## Reader and case populations{#DBMAnalysisBkgrnd-reader-case-populations}
## Three types of analyses{#DBMAnalysisBkgrnd-threeAnalyses} 
## General approach{#DBMAnalysisBkgrnd-approach}
## Summary TBA {#DBMAnalysisBkgrnd-summary}
## References {#DBMAnalysisBkgrnd-references}

<!--chapter:end:09A-dbm-analysis-background.Rmd-->


# Significance Testing using the DBM Method {#DBMAnalysisSigtesting}

Placeholder


## The DBM sampling model
### Explanation of terms in the model 
### Meanings of variance components in the DBM model (**TBA this section can be improved**)
### Definitions of mean-squares 
## Expected values of mean squares 
## Random-reader random-case (RRRC) analysis {#DBMAnalysisSigtesting-RRRC-analysis}
### Calculation of mean squares: an example
### Significance testing {#DBMAnalysisSigtesting-sig-testing}
### The Satterthwaite approximation
### Decision rules, p-value and confidence intervals
#### p-value of the F-test 
#### Confidence intervals for inter-treatment FOM differences
#### Code illustrating the F-statistic, ddf and p-value for RRRC analysis, Van Dyke data
#### Code illustrating the inter-treatment confidence interval for RRRC analysis, Van Dyke data
## Sample size estimation for random-reader random-case generalization
### The non-centrality parameter
### The denominator degrees of freedom
### Example of sample size estimation, RRRC generalization
## Significance testing and sample size estimation for fixed-reader random-case generalization
## Significance testing and sample size estimation for random-reader fixed-case generalization
## Summary TBA {#DBMAnalysisSigtesting-summary}
## Things for me to think about
### Expected values of mean squares 
## References {#DBMAnalysisSigtesting-references}

<!--chapter:end:09B-dbm-analysis-significance-testing.Rmd-->


# DBM method special cases {#DBMSpecialCases}

Placeholder


## Fixed-reader random-case (FRRC) analysis {#FRRCDBMAnalysis}
### Single-reader multiple-treatment analysis {#FRRCSingleReaderDBMAnalysis}
#### Example 5: Code illustrating p-values for FRRC analysis, Van Dyke data
## Random-reader fixed-case (RRFC) analysis {#DBMSpecialCases-RRFCAnalysis}
#### Example 6: Code illustrating analysis for RRFC analysis, Van Dyke data
## References {#DBMSpecialCases-references}

<!--chapter:end:09C-dbm-analysis-miscellaneous.Rmd-->


# Introduction to the Obuchowski-Rockette method {#ORMethodIntro}

Placeholder


## Introduction {#ORMethodIntro-introduction}
## Single-reader multiple-treatment {#OR1RMTModel}
### Definitions of covariance and correlation
### Special case when variables have equal variances 
### Estimating the variance-covariance matrix
### The variance inflation factor
### Meaning of the covariance matrix in Eqn. \@ref(eq:ExampleSigma)
### Code illustrating the covariance matrix
### Significance testing {#SignificanceTesting1ROR}
#### An aside on the relation between the chisquare and the F-distribution with infinite ddf
### p-value and confidence interval {#ORMethodIntro-pvalue-ci}
### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments {#ORMethodIntro-CompareDBM2OR41R}
#### Jumping ahead 
## Multiple-reader multiple-treatment {#SignificanceTestingORMRMC}
### Structure of the covariance matrix {#StrCovMatrix}
### Physical meanings of the covariance terms {#PhysicalMeaningsOfCovMatrix}
## Summary{#ORMethodIntro-Summary}
## Discussion{#ORMethodIntro-Discussion}
## References {#ORMethodIntro-references}

<!--chapter:end:10A-or-analysis-introduction.Rmd-->


# Obuchowski Rockette (OR) Analysis {#ORAnalysisSigTesting}

Placeholder


## Introduction {#ORAnalysisSigTesting-introduction}
## Random-reader random-case {#OR_RRRC}
### Two anecdotes {#TwoAnecdotes}
### Hillis ddf {#Hills-ddf}
### Decision rule, p-value and confidence interval
## Fixed-reader random-case {#OR-FRRC}
## Random-reader fixed-case {#ORAnalysisSigTesting-RRFCAnalysis}
## Summary{#ORAnalysisSigTesting-Summary}
## Discussion{#ORAnalysisSigTesting-Discussion}
## References {#ORAnalysisSigTesting-references}

<!--chapter:end:10B-or-analysis-significance-testing.Rmd-->


# Obuchowski Rockette Applications {#ORApplications} 

Placeholder


## Introduction {#ORApplications-introduction}  
## Hand calculation {#ORApplications-dataset02-hand}
### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset02-hand}
### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset02-hand}
### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset02-hand}
## RJafroc: dataset02 {#ORApplications-dataset02-RJafroc}
### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset02-RJafroc}
### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset02-RJafroc}
### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset02-RJafroc}
## RJafroc: dataset04 {#ORApplications-dataset04-RJafroc}
### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04}
### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04}
### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04}
## RJafroc: dataset04, FROC {#ORApplications-dataset04-FROC-RJafroc}
### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04-FROC}
### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04-FROC}
### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04-FROC}
## RJafroc: dataset04, FROC/DBM {#ORApplications-dataset04-FROC-DBM-RJafroc}
### Random-Reader Random-Case (RRRC) analysis {#ORApplications-RRRC-dataset04-FROC-DBM}
### Fixed-Reader Random-Case (FRRC) analysis {#ORApplications-FRRC-dataset04-FROC-DBM}
### Random-Reader Fixed-Case (RRFC) analysis {#ORApplications-RRFC-dataset04-FROC-DBM}
## Summary{#ORApplications-Summary}
## Discussion{#ORApplications-Discussion}
## Tentative {#ToMullOver1-tentative}
## References {#ORApplications-references}

<!--chapter:end:10C-or-analysis-applications.Rmd-->


# Sample size estimation for ROC studies DBM method {#RocSampleSizeDBM}

Placeholder


## Introduction {#RocSampleSizeDBM-introduction}
## Statistical Power {#StatPower1}
### Observed vs. anticipated effect-size
### Dependence of statistical power on estimates of model parameters {#RocSampleSizeDBM-dependence-of-stats-power}
### Formulae for random-reader random-case (RRRC) sample size estimation {#RocSampleSizeDBM-RRRC-sample-size-estimation}
### Significance testing {#RocSampleSizeDBM-sig-testing}
### p-value and confidence interval {#RocSampleSizeDBM-pvalue-ci}
### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments {#RocSampleSizeDBM-CompareDBM2OR}
## Formulae for fixed-reader random-case (FRRC) sample size estimation {#RocSampleSizeDBM-FRRC-sample-size-estimation}
### Formulae for random-reader fixed-case (RRFC) sample size estimation {#RocSampleSizeDBM-RRFC-sample-size-estimation}
### Fixed-reader random-case (FRRC) analysis TBA {#RocSampleSizeDBM-FRRCAnalysis}
### Random-reader fixed-case (RRFC) analysis {#RocSampleSizeDBM-RRFCAnalysis}
### Single-treatment multiple-reader analysis {#RocSampleSizeDBM-STMRAnalysis}
## Discussion/Summary/2
## References {#RocSampleSizeDBM-references}

<!--chapter:end:11-roc-sample-size-dbm.Rmd-->


# Sample size estimation for ROC studies  OR method {#RocSampleSizeOR}

Placeholder


## Introduction {#RocSampleSizeOR-introduction}
## Statistical Power {#StatPower2}
### Sample size estimation for random-reader random-cases
### Dependence of statistical power on estimates of model parameters {#RocSampleSizeOR-dependence-of-stats-power}
### Formulae for random-reader random-case (RRRC) sample size estimation {#RocSampleSizeOR-RRRC-sample-size-estimation}
### Significance testing {#RocSampleSizeOR-sig-testing}
### p-value and confidence interval {#RocSampleSizeOR-pvalue-ci}
### Comparing DBM to Obuchowski and Rockette for single-reader multiple-treatments {#RocSampleSizeOR-CompareDBM2OR}
## Formulae for fixed-reader random-case (FRRC) sample size estimation {#RocSampleSizeOR-FRRC-sample-size-estimation}
### Formulae for random-reader fixed-case (RRFC) sample size estimation {#RocSampleSizeOR-RRFC-sample-size-estimation}
### Example 1
### Fixed-reader random-case (FRRC) analysis {#RocSampleSizeOR-FRRCAnalysis}
### Random-reader fixed-case (RRFC) analysis {#RocSampleSizeOR-RRFCAnalysis}
### Single-treatment multiple-reader analysis {#RocSampleSizeOR-STMRAnalysis}
## Discussion/Summary/3
## References {#RocSampleSizeOR-references}

<!--chapter:end:11-roc-sample-size-or.Rmd-->


# (PART\*) FROC paradigm {-}
# The FROC paradigm {#froc-paradigm}

Placeholder


## Introduction {#froc-paradigmIntro}
## Location specific paradigms
## The FROC paradigm as a search task 
### Proximity criterion and scoring the data {#froc-paradigm-scoring-the-data}
### Multiple marks in the same vicinity
### Historical context
## A pioneering FROC study in medical imaging
### Image preparation
### Image Interpretation and the 1-rating
### Scoring the data
### The free-response receiver operating characteristic (FROC) plot
### Population and binned FROC plots
### Perceptual SNR
## The "solar" analogy: search vs. classification performance
## Discussion{#froc-paradigm-Discussion}
## References {#froc-paradigm-references}

<!--chapter:end:12-froc-paradigm.Rmd-->


# Empirical plots {#froc-empirical}

Placeholder


## Introduction TBA {#froc-empirical-intro}
## Mark rating pairs {#froc-empirical-mark-rating-pairs}
### Latent vs. actual marks
### Binning rule
## FROC notation {#froc-empirical-notation}
### Comments on Table \@ref(tab:froc-empirical-notation)
### Discussion: cases with zero latent NL marks
## The empirical FROC {#froc-empirical-froc-plot}
### Definition {#froc-empirical-definition-auc-FROC}
### The semi-constrained property of the observed end-point of the FROC plot {#froc-empirical-froc-plot-semi-constrained} 
## The inferred ROC plot {#froc-empirical-ROC}
### Inferred-ROC rating
### Inferred FPF
### Inferred TPF
### Definition {#froc-empirical-definition-auc-ROC}
## The alternative FROC (AFROC) plot {#froc-empirical-AFROC}
### The constrained property of the observed end-point of the AFROC {#froc-empirical-AFROC-constrained}
### Definition {#froc-empirical-definition-auc-AFROC}
## The weighted-AFROC (wAFROC) plot {#froc-empirical-wAFROC}
### Definition {#froc-empirical-definition-auc-wAFROC}
## The AFROC1 plot {#froc-empirical-AFROC1}
### Definition {#froc-empirical-definition-auc-AFROC1}
## The weighted-AFROC1 (wAFROC1) plot {#froc-empirical-wAFROC1}
### Definition {#froc-empirical-definition-auc-wAFROC1}
## The EFROC plot {#froc-empirical-EFROC}
### Definition {#froc-empirical-definition-auc-EFROC}
## STOP
## The chance level FROC and AFROC
## Raw FROC/AFROC/ROC plots
### Code for raw plots {#raw-plots-code1}
### Explanation of the code
#### Number of lesions per diseased case
#### The structure of the FROC dataset
#### The structure of the ratings member
#### The structure of the NL member
#### The structure of the LL member
### Explanation of the code, continued
#### Effect of seed on raw plots
### Key differences from the ROC paradigm:
## Binned FROC/AFROC/ROC plots 
### Code for binned plots {#binned-plots-code1}
#### Effect of seed on binned plots
### Structure of the binned data
## Misconceptions about location-level "true-negatives"
## Comments and recommendations
### Why not use NLs on diseased cases?
### Recommendations
## Discussion{#froc-empirical-Discussion}
## Miscellaneous {#froc-empirical-miscellaneous}
### TBA Cased based vs. view-based scoring {#froc-empirical-case-vs-view}  
## References {#froc-empirical-references}

<!--chapter:end:13-froc-paradigm-empirical-plots.Rmd-->


# FROC vs. wAFROC {#froc-paradigm-froc-vs-afroc}

Placeholder


## Introduction {#froc-paradigm-froc-vs-afroc-froc-vs-afrocs-intro1}
## Introduction {#froc-paradigm-froc-vs-afroc-froc-vs-afrocs-intro}
## FROC vs. wAFROC
## Two other examples are given. 
### An example where the FROC can be used for comparisons
## Discussion{#froc-paradigm-froc-vs-afroc-froc-vs-afrocs-Discussion}
## References {#froc-paradigm-froc-vs-afroc-froc-vs-afrocs-references}

<!--chapter:end:13-froc-paradigm-froc-vs-afroc.Rmd-->


# Meanings of FROC figures of merit {#froc-meanings}

Placeholder


## This chapter is in progress {#froc-meanings-intro1}
## Introduction {#froc-meanings-intro}
## Empirical AFROC FOM-statistic
### Upper limit for AFROC FOM-statistic
### Range of AFROC FOM-statistic
## Empirical weighted-AFROC FOM-statistic 
## Two Theorems
### Theorem 1
### Theorem 2
## Understanding the AFROC and wAFROC empirical plots
### The AFROC plot {#froc-meanings-AFROC-plot}
### The weighted-AFROC (wAFROC) plot {#froc-meanings-wAFROC-plot}
## Physical interpretation of AFROC-based FOMs
### Physical interpretation of area under AFROC 
### Physical interpretation of area under wAFROC
## Discussion{#froc-meanings-Discussion}
## References {#froc-meanings-references}

<!--chapter:end:14-froc-meanings-foms-ocs.Rmd-->



<!--chapter:end:99-references.Rmd-->


# (PART\*) APPENDICES {-}
# (APPENDIX) Appendix{-} 

Placeholder


## Introduction {#rocdataformatIntro}
## Note to existing users
## The Excel data format {#rocExceldataformat}
## Illustrative toy file
## The `Truth` worksheet {#rocExcelTruthdataformat}
## The structure of an ROC dataset
## The false positive (FP) ratings {#rocExcelFPdataformat}
## The true positive (TP) ratings {#rocExcelTPdataformat}
## Correspondence between `NL` member of dataset and the `FP` worksheet
## Correspondence between `LL` member of dataset and the `TP` worksheet
## Correspondence using the `which` function 
## Summary{#rocdataformat-Summary}
## Discussion{#rocdataformat-Discussion}
## References {#rocdataformat-references}

<!--chapter:end:81-roc-data-format.Rmd-->


# FROC data format {#frocdataformat}

Placeholder


## Purpose
## Introduction {#frocdataformatIntro}
## The Excel data format {#frocExceldataformat}
## The `Truth` worksheet {#frocExcelTruthdataformat}
## The structure of an FROC dataset
## The false positive (FP) ratings
## The true positive (TP) ratings
## On the distribution of numbers of lesions in abnormal cases  
### Definition of `lesDistr` array
## Definition of `lesWghtDistr` array
## Summary{#frocdataformat-Summary}
## Discussion{#frocdataformat-Discussion}
## References {#frocdataformat-references}

<!--chapter:end:82-froc-data-format.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Classification tasks {#classification-tasks}




## Introduction TBA {#classification-tasks-intro}

This is in progress; the topic arose from an email exchange outlined below.

## email 1

1) Have multiple classes been considered in the newest version? That means there are, for example, three types of lesions (type 1, 2, 3) in an image. Then the observer may annotate the correct location, but indicate the wrong type of the lesion (e.g. the ground truth is type2, but the observer indicates it as type1).
If not, do you know any statistical analysis method that can consider this type of error?
2) If I remember correctly, the acceptance radius R was the same value for all the tested images, can we now set a different value for each test image?


## response 1
Taking your second question first:
The acceptance radius is selected by you, in consultation with expert readers, along lines described in my book. It is outside the scope of the analysis software.

Regarding your first question:
**A key point is that spatial localization (as currently handled) is a special case of localization-with-classification (which is your interest).** 

The `TP` and `FP` Excel worksheets are relatively easy to handle. If you have 3 types of lesions, and each localization mark is associated with an indicated perceived lesion type, e.g., `Type1`, `Type2` or `Type3`, and if the perceived localization and perceived type both agree with the truth, then the rating goes in the `TP` worksheet, otherwise the rating goes in the `FP` worksheet. 

The `Truth` worksheet is more complex. The number of lesions in the `Truth` worksheet for a particular case is the sum of all lesions of all types in that case. Ideally the `Truth` worksheet should have an extra column for `lesionType`, but extensive modifications to existing code is required to implement this.

In the meantime, you can “fool” the current software by doing the localization-classification book-keeping yourself. I will illustrate with one example.

Suppose case 1 has four lesions, two of `Type1`, one of `Type2` and one of `Type3.` 

Then in the Truth worksheet `lesionID` column for that case, there will be four integer entries: 1, 2, 3 and 4. The 1 refers to the first lesion (of `Type1` - you need to keep track of this), 2 to the second lesion (also of `Type1` - etc), 3 to the third lesion (`Type2` - etc) and 4 to the fourth lesion (of `Type3` - etc).

If `lesionID` 2 is correctly localized and classified (i.e., as `Type1`), then the corresponding rating belongs in the TP worksheet with `lesionID` = 2. 
If `lesionID` 3 is correctly localized and classified (i.e., as `Type2`), then the corresponding rating belongs in the TP …  with `lesionID` = 3. 
Etc.

If `lesionID` 1 is correctly localized but incorrectly classified (i.e., as `Type2` or `Type3`), then the rating belongs in the FP worksheet. 
Any mark not corresponding (in location) to an actual lesion (the classification is irrelevant) goes in the FP worksheet.

This scoring scheme would reward readers who get both location and classification correct and penalize them otherwise. More complex reward/penalization schemes can be worked out using lesion weights, but I would try the simple approach first.

One more thing: the classification types should be distinct, with little overlap. Otherwise one faces an issue similar to the “acceptance radius” issue with location.



## email 2

I'm clear now about my first question. I'll try the simple approach.

For the second question, I mean that for example, if the test images have different resolutions, the acceptance radius will be a ratio of the input image size, rather than a fixed value.
So I'm wondering if this value can be modified for each input image in the existing code ?


## response 2
Yes, what you are suggesting is reasonable. 

When we encountered this issue in the 2016 Radiology study, the images were of very different sizes - conventional chest x-rays vs. images on CRT monitors. We never encountered the need for a hard acceptance radius - if in doubt, an independent radiologist was consulted to determine if the localization was acceptable. This is a clinical issue - super accuracy (e.g., pixel level) is not required for the radiologist and the surgeon to agree that they are talking about the same lesion.

In any case, images are not input to my software (`RJafroc`) so this has to be done independently.

## email 3

I may need to add more explanations for this question. 

Since I'm evaluating actually if I can use the JAFROC-1 in the case of object detection and localization in CV (computer-vision) problems.
The state-of-the-art is to calculate firstly the IoU (Intersection over union), then predefine an IoU threshold (say 0.5) in classifying whether the prediction is a true positive or a false positive (similar to acceptance radius), finally calculate the Average Precision (AP) which represents the area under the precision-recall curve.
Since there is no True Negative cases in this scenario, ROC is not used. Instead, they use the precision-recall curve.

So I'm wondering if the JAFROC-1 will have a higher statistical power than this state-of-the-art.

## response 3

I am not familiar with precision recall curves and thanks for you brief explanation. Is the area under the precision-recall curve bounded or unbounded? If unbounded, I see problems with its usage, similar to problems with using the area under the FROC curve. [The areas under the ROC and AFROC curves are bounded.] The TN mark does not exist in FROC studies, in the sense that it is an unobservable mark: this is a misconception that I have discussed before. [TN mark does exist in ROC studies.]

In most medical imaging studies I am not comfortable with FOMs that do not include normal cases. Therefore, I do not recommend such studies and use of JAFROC1 FOM is not recommended. 

Of course, there could be situations where JAFROC1 FOM is appropriate, but, to get to your question, I have not studied power vs. precision recall curve in such situations.

Statistical power is an important consideration, but it is not the only consideration. Clinical relevance is another important consideration. You need to decide on what is the most appropriate method for your study.


## email 4
We have 4322 cases and 14 algorithmic readers. Actually, the maximum number of classes per case is 6, but the class type is already coded in the TP/FP worksheets, eg. when the predicted class type matches the ground truth class type, it will be put in TP, if not, it will be put in FP. So we can *not* (sic) get the class information from the excel file. 

## response 4
Excerpt from my earlier email: 

>
Suppose case 1 has four lesions, two of Type1, one of Type2 and one of Type3.
Then in the Truth worksheet lesionID column for that case, there will be four integer entries: 1, 2, 3 and 4. The 1 refers to the first lesion (of Type1 - you need to keep track of this), 2 to the second lesion (also of Type1 - etc), 3 to the third lesion (Type2 - etc) and 4 to the fourth lesion (of Type3 - etc).
If lesionID 2 is correctly localized and classified (i.e., as Type1), then the corresponding rating belongs in the TP worksheet with lesionID = 2. If lesionID 3 is correctly localized and classified (i.e., as Type2), then the corresponding rating belongs in the TP … with lesionID = 3. Etc.
If lesionID 1 is correctly localized but incorrectly classified (i.e., as Type2 or Type3), then the rating belongs in the FP worksheet. Any mark not corresponding (in location) to an actual lesion (the classification is irrelevant) goes in the FP worksheet.

The class type must appear in the `Truth` sheet under `lesionID`. This establishes the TRUE class type for each lesion. The way you currently have the `Truth` sheet structured the program thinks that the maximum number of classes is 144, not six.

The class type must also appear in `TP` sheet if the lesion was correctly located and classified. The FP sheet does not have a `lesionID` field. Both correctly located but incorrectly classified lesions and incorrectly localized lesions go in this sheet. 


## Abbreviations
* Correct-localization correct-classification = CL-CC
* Correct-localization incorrect-classification = CL-IC
* Incorrect-localization classification not applicable = IL-NA


## Example, File1
* This example is implemented in file `File1.xlsx`. 
* There are four classes of lesions: `C1`, `C2`, `C3`and `C4`.
* The rating scale is 1 - 10 and positive-directed. 
* The dataset has 3 cases: 9, 17 and 19. 

### `Truth` sheet
\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/classification/File1Truth} 

}

\caption{Truth worksheet for File1.xlsx}\label{fig:File1Truth}
\end{figure}

* Case 9 has two lesions, with classes `C1` and `C4`. 
* Case 17 has four lesions, with classes `C1`, `C2`, `C3`and `C4`. 
* Case 19 has one lesion, with class `C2`. 

### `TP` sheet
\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/classification/File1TP} 

}

\caption{TP worksheet for File1.xlsx}\label{fig:File1TP}
\end{figure}

* This holds CL-CC marks. 

#### Case 9
* Lesion `C1`, `lesionID` = 1, CL-CC mark rated 5. 

#### Case 17
* Lesion `C1`, `lesionID` = 1, CL-CC mark rated 6.1. 
* Lesion `C2`, `lesionID` = 2, CL-CC mark rated 7.1. 
* Lesion `C4`, `lesionID` = 4, CL-CC mark rated 2.3. 

#### Case 19
* Lesion `C2`, `lesionID` = 1, CL-CC mark rated 5.7. 

### `FP` sheet
\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/classification/File1FP} 

}

\caption{FP worksheet for File1.xlsx}\label{fig:File1FP}
\end{figure}

* This holds IL-NA and CL-IC marks. 

#### Case 9
* CL-IC mark rated 5.5, `C2` classified as `C3`. This misclassification is especially bad as `C3` does not exist on this case. 
* IL-NA mark rated 1.2. 

#### Case 17
* CL-IC mark rated 7, `C3` classified as `C2`. 
* IL-NA mark rated 2.3. 
* IL-NA mark rated 2.1. 


#### Case 19
* IL-NA mark rated 1.4. 
* CL-IC mark rated 6.1, `C2` classified as `C3`. 

### The two ratings arrays

```r
fileName <- "R/CH83-ClassificationTask/File1.xlsx"
x <- DfReadDataFile(fileName = fileName)
x$ratings$NL[1,1,,]
#>      [,1] [,2] [,3]
#> [1,]  5.5  1.2 -Inf
#> [2,]  7.0  2.3  2.1
#> [3,]  1.4  6.1 -Inf
x$ratings$LL[1,1,,]
#>      [,1] [,2] [,3] [,4]
#> [1,]  5.0 -Inf -Inf -Inf
#> [2,]  6.1  7.1 -Inf  2.3
#> [3,]  5.7 -Inf -Inf -Inf
```

### The FOM is shown next:

```r
print(UtilFigureOfMerit(x, FOM = "wAFROC1"))
#>           rdr1
#> trt1 0.2361111
```

## Example, File2
I increased the LL rating for case 19 to 10; this should increase the FOM.

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/classification/File2TP} 

}

\caption{TP worksheet for File2.xlsx}\label{fig:File2TP}
\end{figure}



```r
fileName <- "R/CH83-ClassificationTask/File2.xlsx"
x <- DfReadDataFile(fileName = fileName)
print(UtilFigureOfMerit(x, FOM = "wAFROC1"))
#>           rdr1
#> trt1 0.4583333
```


## Example, File3
Starting with original file, I transferred a CL-IC for case 17 to the TP sheet. This should increase the FOM as credit is given for CL-CC.

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/classification/File3TP} \includegraphics[width=0.5\linewidth,height=0.2\textheight]{images/classification/File3FP} 

}

\caption{TP and FP worksheets for File3.xlsx}\label{fig:File3TPFP}
\end{figure}




```r
fileName <- "R/CH83-ClassificationTask/File3.xlsx"
x <- DfReadDataFile(fileName = fileName)
print(UtilFigureOfMerit(x, FOM = "wAFROC1"))
#>           rdr1
#> trt1 0.5277778
```


## Discussion{#classification-tasks-discussion}
## Detritus
This project started with an idea on how to extend localization analysis software (RJafroc) to localization-classification tasks. I exchanged several emails with Dr. Lu discussing this. Since this is new research the required data format is not in the RJafroc-documentation. I thought I provided clear instructions, but I did assume familiarity with localization task analysis.

The class type has to be coded as sequential integers starting with 1: e.g., 1, 2, 3, 4, 5, 6. These go in the lesion ID column of the Truth sheet. If a case has class 3 and 5 lesions, there will be two entries    The 1 means the lesion with class 1, etc. If class 2 is incorrectly located or correctly located but incorrectly classified, there will be an entry for this case in the FP sheet. 

The same integers need to be used in the TP sheet. If lesion 3 is correctly located and classified then you will have an entry with 3 in the lesion ID field. 

PS: 
The class has to be coded as sequential integers starting with 1: e.g., 1, 2, 3, 4, 5, 6. If a case has two lesions, one of class 3 and the other of class 5, then there will be two entries for this case, one with lesionID = 3 and the other with lesionID = 5.  Another case with 6 lesions, all of distinct classes, will have 6 rows on entries under LesionID. 


The 1 means the lesion with class 1, etc. If class 2 is incorrectly located or correctly located but incorrectly classified, there will be an entry for this case in the FP sheet. 

The same integers need to be used in the TP sheet. If lesion 3 is correctly located and classified then you will have an entry with 3 in the lesion ID field.

## References {#classification-tasks--references}


<!--chapter:end:83-classification-task.Rmd-->

---
output:
  pdf_document: default
  html_document: default
---
# Split Plot Study Design {#SplitPlotChapter}



## Mean Square R(T)
R(T) is read as "reader nested within treatment" [@RN2508].  


\begin{equation}
\text{MS[R(T)]}=\frac{1}{I(J-1)}\sum_{i=1}^{I}\sum_{j=1}^{J}\left ( \theta_{ij} - \theta_{i\bullet} \right )^{2}
(\#eq:MSR-T-Hillis)
\end{equation}


\begin{equation}
\text{MS[R(T)]}=\frac{1}{I}\sum_{i=1}^{I}\frac{1}{J_i-1}\sum_{j=1}^{J}\left ( \theta_{ij} - \theta_{i\bullet} \right )^{2}
(\#eq:MSR-T-Hillis-Modified)
\end{equation}


## References {#SplitPlotChapter-references}


<!--chapter:end:84-split-plot.Rmd-->

