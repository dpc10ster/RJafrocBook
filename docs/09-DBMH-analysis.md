# Dorfman Berbaum Metz Hillis (DBMH) Analysis {#DBMHnalysis}



## Introduction
In this chapter the term "treatment" is used as a generic for "imaging system", "modality" or "image processing" and "reader" is used as a generic for "radiologist" or algorithmic observer, e.g., a computer aided detection (CAD) algorithm. In the context of illustrating hypothesis-testing methods the previous chapter described analysis of a single ROC dataset and comparing the observed area $AUC$ under the ROC plot to a specified value. Clinically this is not the most interesting problem; rather, interest is usually in comparing performance of a group of readers interpreting a common set of cases in two or more treatments. Such data is termed multiple reader multiple case (MRMC). [An argument could be made in favor of the term “multiple-treatment multiple-reader”, since “multiple-case” is implicit in any ROC analysis that takes into account correct and incorrect decisions on cases. However, the author will stick with existing terminology.] The basic idea is that by sampling a sufficiently large number of readers and a sufficiently large number of cases one might be able to draw conclusions that apply broadly to other readers of similar skill levels interpreting other similar case sets in the selected treatments. How one accomplishes this, termed MRMC analysis, is the subject of this chapter. 

This chapter describes the first truly successful method of analyzing MRMC ROC data, namely the Dorfman-Berbaum-Metz (DBM) method [@RN204]. The other method, due to Obuchowski and Rockette [@RN1450], is the subject of Chapter 10. Both methods have been substantially improved by Hillis [@RN1866; @RN1865; @RN2508]. Hence the title of this chapter: "Dorfman Berbaum Metz Hillis (DBMH) Analysis". It is not an overstatement that ROC analysis came of age with the methods described in this chapter. Prior to the techniques described here, one knew of the existence of sources of variability affecting a measured $AUC$ value, as discussed in (book) Chapter 07, but then-known techniques [@RN412] for estimating the corresponding variances and correlations were impractical. 

### Historical background
The author was thrown (unprepared) into the methodology field ca. 1985 when, as a junior faculty member, he undertook comparing a prototype digital chest-imaging device (Picker International, ca. 1983) vs. an optimized analog chest-imaging device at the University of Alabama at Birmingham. At the outset a decision was made to use free-response ROC methodology instead of ROC, as the former accounted for lesion localization, and the author and his mentor, Prof. Gary T. Barnes, were influenced in that decision by a publication [@RN2453] to be described in (book) Chapter 12. Therefore, instead of ROC-AUC one had lesion-level sensitivity at a fixed number of location level false positives per case as the figure-of-merit (FOM). Details of the FOM are not relevant at this time. Suffice to state that methods described in this chapter, which had not been developed in 1983, while developed for analyzing reader-averaged inter-treatment ROC-AUC differences, *apply to any scalar FOM*. While the author was successful at calculating confidence intervals (this is the heart of what is loosely termed "statistical analysis") and publishing the work [@RN621] using techniques described in a book [@RN412] titled "Evaluation of Diagnostic Systems: Methods from Signal Detection Theory", subsequent attempts at applying these methods in a follow-up paper [@RN620] led to negative variance estimates (private communication, Dr. Loren Niklason, ca. 1985). With the benefit of hindsight, negative variance estimates are not that uncommon and the method to be described in this chapter has to deal with that possibility.

The methods [@RN412] described in the cited book involved estimating the different variability components – case sampling, between-reader and within-reader variability. Between-reader and within-reader variability (the two cannot be separated as discussed in (book) Chapter 07) could be estimated from the variance of the $AUC$ values corresponding to the readers interpreting the cases within a treatment and then averaging the variances over all treatments. Estimating case-sampling and within-reader variability required splitting the dataset into a few smaller subsets (e.g., a case set with 60 cases might be split into 3 sub-sets of 20 cases each), analyzing each subset to get an $AUC$ estimate and calculating the variance of the resulting $AUC$ values [@RN412] and scaling the result to the original case size. Because it was based on few values, the estimate was inaccurate, and the already case-starved original dataset made it difficult to estimate AUCs for the subsets; moreover, the division into subsets was at the discretion of the researcher, and therefore unlikely to be reproduced by others. Estimating within-reader variability required re-reading the entire case set, or at least a part of it. ROC studies have earned a deserved reputation for taking much time to complete, and having to re-read a case set was not a viable option. [Historical note: the author recalls a barroom conversation with Dr. Thomas Mertelmeir after the conclusion of an SPIE meeting ca. 2004, where Dr. Mertelmeir commiserated mightily, over several beers, about the impracticality of some of the ROC studies required of imaging device manufacturers by the FDA.]


### The Wagner analogy
An important objective of modality comparison studies is to estimate the variance of the difference in reader-averaged AUCs between the treatments. For two treatments one sums the reader-averaged variance in each treatment and subtracts twice the covariance (a scaled version of the correlation). Therefore, in addition to estimating variances, one needs to estimate correlations. Correlations are present due to the common case set interpreted by the readers in the different treatments. If the correlation is large, i.e., close to unity, then the individual treatment variances tend to cancel, making the constant treatment-induced difference easier to detect. The author recalls a vivid analogy used by the late Dr. Robert F. Wagner to illustrate this point at an SPIE meeting ca. 2008. To paraphrase him, *consider measuring from shore the heights of the masts on two adjacent boats in a turbulent ocean. Because of the waves, the heights, as measured from shore, are fluctuating wildly, so the variance of the individual height measurements is large. However, the difference between the two heights is likely to be relatively constant, i.e., have small variance. This is because the wave that causes one mast's height to increase also increases the height of the other mast.*

### The shortage of numbers to analyze and a pivotal breakthrough
*The basic issue was that the calculation of $AUC$ reduces the relatively large number of ratings of a set of non-diseased and diseased cases to a single number.* For example, after completion of an ROC study with 5 readers and 100 non-diseased and 100 diseased cases interpreted in two treatments, the data is reduced to just 10 numbers, i.e., five readers times two treatments. It is difficult to perform statistics with so few numbers. The author recalls a conversation with Prof. Kevin Berbaum at a Medical Image Perception Society meeting in Tucson, Arizona, ca. 1997, in which he described the basic idea that forms the subject of this chapter. Namely, using the jackknife pseudovalues, Eqn. (7.6), as individual case-level figures of merit. This, of course, greatly increases the amount of data that one can work with; instead of just 10 numbers one now has 2,000 pseudovalues (2 x 5 x 200). If one assumes the pseudovalues behave essentially as case-level data, then by assumption they are independent and identically distributed , and therefore they satisfy the conditions for application of standard analysis of variance (ANOVA) techniques10. The relevant paper1 had already been published in 1992 but other distractions and lack of formal statistical training kept the author from fully appreciating this work until later. 
 
Although methods are available for more complex study designs including partially paired data [@RN2128; @RN1880], I will restrict to fully paired data (i.e., each case is interpreted by all readers in all treatments). There is a long history of how this field has evolved and the author cannot do justice to all methods that are currently available. Some of the methods [@RN1441; @RN2013; @RN1451] have the advantage that they can handle explanatory variables (termed covariates) that could influence performance, e.g., years of experience, types of cases, etc. Other methods are restricted to specific choices of FOM. Specifically, the probabilistic approach [@RN2253; @RN2254; @RN2351; @RN2080] is restricted to the empirical $AUC$ under the ROC curve, and therefore are not applicable to other FOMs, e.g., parametrically fitted ROC AUCs or, more importantly, to location specific paradigm FOMs. Instead, the author will focus on methods for which software is readily available (i.e., freely on websites), which have been widely used (the method that the author is about to describe has been used in several hundred publications) and validated via simulations, and which apply to any scalar figure of merit, and therefore widely applicable, even to location specific paradigms.

### Organization of the chapter
The organization of the chapter is as follows. The concepts of reader and case populations, introduced in (book) Chapter 07, are recapitulated. A distinction is made between *fixed* and *random* factors – statistical terms with which one must become familiar. Described next are three types of analysis that are possible with MRMC data, depending on which factors are regarded as random and which as fixed. The general approach to the analysis is described. Two methods of analysis are possible: the jackknife pseudovalue-based approach detailed in this chapter and an alternative approach is detailed in Chapter 10. The Dorfman-Berbaum-Metz (DBM) model for the jackknife pseudovalues is described that incorporates different sources of variability and correlations possible with MRMC data. Calculation of ANOVA-related quantities, termed mean squares, from the pseudovalues, are described followed by the significance testing procedure for testing the null hypothesis of no treatment effect. A relevant distribution used in the analysis, namely the F-distribution, is illustrated with R examples. The decision rule, i.e., whether to reject the NH, calculation of the ubiquitous p-value, confidence intervals and how to handle multiple treatments is illustrated with two datasets, one an older ROC dataset that has been widely used to demonstrate advances in ROC analysis, and the other a recent dataset involving evaluation of digital chest tomosynthesis vs. conventional chest imaging. The approach to validation of DBMH analysis is illustrated with an R example. The chapter concludes with a section on the meaning of the pseudovalues. The intent is to explain, at an intuitive level, why the DBM method "works", even though use of pseudovalues has been questioned3 at the conceptual level. For organizational reasons and space limitations, details of the software are relegated to Online Appendices, but they are essential reading, preferably in front of a computer running the online software that is part of this book. The author has included material here that may be obvious to statisticians, e.g., an explanation of the Satterthwaite approximation, but are expected to be helpful to others from non-statistical backgrounds.

## Random and fixed factors
*This paragraph introduces some analysis of variance (ANOVA) terminology. Treatment, reader and case are factors with different numbers of levels corresponding to each factor. For an ROC study with two treatments, five readers and 200 cases, there are two levels of the treatment factor, five levels of the reader factor and 200 levels of the case factor. If a factor is regarded as fixed, then the conclusions of the analysis apply only to the specific levels of the factor used in the study. If a factor is regarded as random, the levels of the factor are regarded as random samples from a parent population of the corresponding factor and conclusions regarding specific levels are not allowed; rather, conclusions apply to the distribution from which the levels are, by assumption, sampled.*

ROC MRMC studies require a sample of cases and interpretations by one or more readers in one or more treatments (in this book the term "multiple" includes as a special case "one"). A study is never conducted on a sample of treatments. It would be nonsensical to image patients using a "sample" of all possible treatments known to exist. Every variation of an imaging technique (e.g., different kilovoltage or kVp) or display method (e.g., window-level setting) or image processing techniques qualifies as a distinct treatment. The number of possible treatments is very large, and, from a practical point of view, most of them are uninteresting. Rather, interest is in comparing two or more (a few at most) treatments that, based on preliminary studies, are clinically interesting. One treatment may be computed tomography, the other magnetic resonance imaging, or one may be interested in comparing a standard image processing method to a newly proposed one, or one may be interested in comparing CAD to a group of readers. 

This brings out an essential difference between how cases, readers and treatments have to be regarded in the variability estimation procedure. Cases and readers are usually regarded as random factors (there has to be at least one random factor – if not, there are no sources of variability and nothing to apply statistics to!), while treatments are regarded as fixed factors. The random factors contribute stochastic (i.e., random) variability, but the fixed factors do not, rather they contribute constant shifts in performance. The terms fixed and random factors are used in this specific sense, and are derived, in turn, from ANOVA methods in statistics10,25. With two or more treatments, there are shifts in performance of treatments relative to each other, that one seeks to assess the significance of against a background of noise contributed by the random factors. If the shifts are sufficiently large compared to the noise, then one can state, with some certainty, that they are real. Quantifying the last statement uses the methods of hypothesis testing introduced in Chapter \@ref(HypothesisTesting) or Chapter [Hypothesis Testing].

## Reader and case populations and data correlations
As discussed in (book) §7.2, conceptually there is a reader-population, generally modeled as a normal distribution $\theta_j \sim N\left ( \theta_{\bullet\{1\}},  \sigma_{br+wr}^{2} \right )$, describing the variation of skill-level of readers. The notation closely follows that in the cited section, the only change being that the binormal model estimate $A_z$ has been replaced by a generic FOM, denoted $\theta$. Each reader $j$ is characterized by a different value of  $\theta_j$, $j=1,2,...J$ and one can conceptually think of a bell-shaped curve with variance $\sigma_{br+wr}^{2}$ describing between-reader variability of the readers. A large variance implies large spread in reader skill levels. 

Likewise, there is a case-population, also modeled as a normal distribution, describing the variations in difficulty levels of the patients. One actually has two unit-variance distributions, one per diseased state, characterized by a separation parameter and conceptually an easy case set has a larger than usual separation parameter while a difficult case set has a smaller than usual separation parameter. The distribution of the separation parameter can be modeled as a bell-shaped curve $\theta_{\{c\}} \sim N\left ( \theta_{\{\bullet\}}, \sigma_{cs+wr}^{2} \right )$  with variance $\sigma_{cs+wr}^{2}$ describing the variations in difficulty levels of different case samples. Note the need for the case-set index, introduced in Chapter 07, to specify the separation parameter for a specific case-set (in principle a $j$-index is also needed as one cannot have an interpretation without a reader; for now it is suppressed; one can think of the stated equation as applying to the average reader). A small variance $\sigma_{cs}^{2}$  implies the different case sets have similar difficulty levels while a larger variance would imply a larger spread in difficulty levels.

*Anytime one has a common random component to two measurements, the measurements are correlated.* In the Wagner analogy, the common component is the random height, as a function of time, of a wave, which contributes the same amount to both height measurements (since the boats are adjacent). Since the readers interpret a common case set in all treatments one needs to account for various types of correlations that are potentially present. These occur due to the various types of pairings that can occur with MRMC data, where each pairing implies the presence of a common component to the measurements: (a) the same reader interpreting the same cases in different treatments, (b) different readers interpreting the same cases in the same treatment and (c) different readers interpreting the same cases in different treatments. These pairings are more clearly elucidated in (book) Chapter 10. The current chapter uses jackknife pseudovalue based analysis to model the variances and the correlations. Hillis has shown that the two approaches are essentially equivalent [@RN1866].


## Three types of analyses 
*MRMC analysis attempts to draw conclusions regarding the significances of inter-treatment shifts in performance. Ideally a conclusion (i.e., a difference is significant: yes/no; the "yes" applies if the p-value is less than alpha) should generalize to the respective populations from which the random samples were obtained. In other words, the idea is to generalize from the observed samples to the underlying populations. Three types of analyses are possible depending on which factor(s) one regards as random and which as fixed: random-reader random-case (RRRC), fixed-reader random-case (FRRC) and random-reader fixed-case (RRFC). If a factor is regarded as random, then the conclusion of the study applies to the population from which the levels of the factor were sampled. If a factor is regarded as fixed, then the conclusion applies only to the specific levels of the sampled factor. For example, if reader is regarded as a random factor, the conclusion generalizes to the reader population from which the readers used in the study were obtained. If reader is regarded as a fixed factor, then the conclusion applies to the specific readers that participated in the study. Regarding a factor as fixed effectively “freezes out” the sampling variability of the population and interest then centers only on the specific levels of the factor used in the study. For fixed reader analysis, conclusions about the significances of differences between pairs of readers are allowed; these are not allowed if reader is treated as a random factor. Likewise, treating case as a fixed factor means the conclusion of the study is specific to the case-set used in the study.*

## General approach
This section provides an overview of the steps involved in analysis of MRMC data. Two approaches are described in parallel: a figure of merit (FOM) derived jackknife pseudovalue based approach, detailed in this chapter and an FOM based approach, detailed in the next chapter. The analysis proceeds as follows:
 	
1.	A FOM is selected: *the selection of FOM is the single-most critical aspect of analyzing an observer performance study*. The selected FOM is denoted $\theta$. To keep the notation reasonably compact the usual circumflex "hat" symbol used previously to denote an estimate is suppressed. The FOM has to be an objective scalar measure of performance with larger values characterizing better performance. [The qualifier "larger" is trivially satisfied; if the figure of merit has the opposite characteristic, a sign change is all that is needed to bring it back to compliance with this requirement.] Examples are empirical $AUC$, the binormal model-based estimate $A_z$ , other advance method based estimates of $AUC$, sensitivity at a predefined value of specificity, etc. An example of a FOM requiring a sign-change is $FPF$ at a specified $TPF$, where smaller values signify better performance.
1. For each treatment $i$ and reader $j$ the figure of merit $\theta_{ij}$ is estimated from the ratings data. Repeating this over all treatments and readers yields a matrix of observed values $\theta_{ij}$. This is averaged over all readers in each treatment yielding  $\theta_{i\bullet}$. The observed effect-size $ES_{obs}$ is defined as the difference between the reader-averaged FOMs in the two treatments, i.e., $ES_{obs}$ = $\theta_{2\bullet}$ - $\theta_{1\bullet}$. While extensible to more than two treatments, the explanation is more transparent by restricting to two modalities.
1. If the magnitude of $ES_{obs}$ is "large" one has reason to suspect that there might indeed be a significant difference in AUCs between the two treatments, where significant is used in the sense of (book) Chapter 08. Quantification of this statement, specifically how large is "large", requires the conceptually more complex steps described next.
   +	In the DBMH approach, the subject of this chapter, jackknife pseudovalues are calculated as described in Chapter 08. A standard ANOVA model with uncorrelated errors is used to model the pseudovalues. 
   +	In the ORH approach, the subject of the next chapter, the FOM is modeled directly using a custom ANOVA model with correlated errors.
1.	Depending on the selected method of modeling the data (pseudovalue vs. FOM) a statistical model is used which includes parameters modeling the true values in each treatment, and expected variations due to different variability components in the model, e.g., between-reader variability, case-sampling variability, interactions (e.g., modeling the possibility that the random effect of a given reader could be treatment dependent) and the presence of correlations (between pseudovalues or FOMs) because of the pairings inherent in the interpretations.
1.	In RRRC analysis one accounts for randomness in readers and cases. In FRRC analysis one regards reader as a fixed factor. In RRFC analysis one regards case as a fixed factor. The statistical model depends on the type of analysis.
1.	The parameters of the statistical model are estimated from the observed data. 
1.	The estimates are used to infer the statistical distribution of the observed effect size,  $ES_{obs}$, regarded as a realization of a random variable, under the null hypothesis (NH) that the true effect size is zero.
1.	Based on this statistical distribution, and assuming a two-sided test, the probability (this is the oft-quoted p-value) of obtaining an effect size at least as extreme as that actually observed, is calculated, as in Chapter 08. 
1.	If the p-value is smaller than a preselected value, denoted $\alpha$, one declares the treatments different at the $\alpha$ - significance level. The quantity $\alpha$ is the control (or cap) on the probability of making a Type I error, defined as rejecting the NH when it is true. It is common to set   $\alpha$ = 0.05 but depending on the severity of the consequences of a Type I error, as discussed in (book) Chapter 08, one might consider choosing a different value. Notice that $\alpha$ is a pre-selected number while the p-value is a realization of a random variable.
1.	For a valid statistical analysis, the empirical probability $\alpha_{emp}$ over many (typically 2000) independent NH datasets, that the p-value is smaller than  $\alpha$, should equal $\alpha$ to within statistical uncertainty.


## The Dorfman-Berbaum-Metz (DBM) method
The figure-of-merit has three indices:  
1. A treatment index $i$, where $i$ runs from 1 to $I$, where $I$ is the total number of treatments. 
1. A reader index $j$, where $j$ runs from 1 to $J$, where $J$ is the total number of readers. 
1. The often-suppressed case-sample index $\{c\}$, where  $\{1\}$  i.e., $c$ = 1, denotes a set of cases,   $K_1$ non-diseased and $K_2$ diseased, interpreted by all readers in all treatments, and other integer values of $c$ correspond to other independent sets of cases that, although not in fact interpreted by the readers, could potentially be “interpreted” using resampling methods such as the bootstrap or the jackknife. 

The approach [@RN204] taken by Dorfman-Berbaum-Metz (DBM) was to use the jackknife resampling method described in (book) Chapter 7 to calculate FOM pseudovalues ${Y'}_{ijk}$ defined by (the reason for the prime will become clear shortly):

\begin{equation*}
Y'_{ijk}=K\theta_{ij}-(K-1)\theta_{ij\{k\}}
\end{equation*}

Here $\theta_{ij}$ is the estimate of the figure-of-merit for reader $j$ interpreting all cases in treatment $i$ and $\theta_{ij\{k\}}$ is the corresponding figure of merit with case $k$ *deleted* from the analysis. To adhere to convention and to keep the notation simple the $\{1\}$ index on every figure of merit symbol is suppressed (unless it is absolutely necessary for clarity). 

Recall from book Chapter 07 that the jackknife is a way of teasing out the case-dependence: the left hand side of Eqn. (9.1) literally has a case index $k$, with $k$ running from 1 to $K$, where $K$ is the total number of cases:  $K=K_1+K_2$. 

Hillis has proposed a centering transformation on the pseudovalues (Hillis calls them "normalized" pseudovalues but to the author "centering" is a more accurate and descriptive term - *Normalize: (In mathematics) multiply (a series, function, or item of data) by a factor that makes the norm or some associated quantity such as an integral equal to a desired value (usually 1). New Oxford American Dictionary, 2016*):

\begin{equation*}
Y_{ijk}=Y'_{ijk}+\left (\theta_{ij} - Y'_{ij\bullet}  \right )
\end{equation*}


The effect of this transformation is that the average of the centered pseudovalues over the case index is identical to the corresponding estimate of the figure of merit:

\begin{equation*}
Y_{ij\bullet}=Y'_{ij\bullet}+\left (\theta_{ij} - Y'_{ij\bullet}  \right )=\theta_{ij}
\end{equation*}

This has the advantage that all confidence intervals are correctly centered. The transformation is unnecessary if one uses the Wilcoxon as the figure-of-merit, as the pseudovalues calculated using the Wilcoxon as the figure of merit are automatically centered. It is left as an exercise for the reader to show that this statement is true.

*It is understood that, unless explicitly stated otherwise, all calculations from now on will use centered pseudovalues.*

Consider $N$ replications of a MRMC study, where a replication means repetition of the study with the same treatments, readers and case-set $\{1\}$. For $N$ replications per treatment-reader-case combination, the DBM model for the pseudovalues is ($n$ is the replication index, usually $n$ = 1, but kept here for now):

\begin{equation*}
Y_{n(ijk)}  = \mu + \tau_i+ R_j + C_k + (\tau R)_{ij}+ (\tau C)_{ik}+ (R C)_{jk} + (\tau RC)_{ijk}+ \epsilon_{n(ijk)} 
\end{equation*}

The notation for the replication index, i.e., $n(ijk)$, implies $n$ observations for treatment-reader-case combination $ijk$. 

*The basic assumption of the DBM model, Eqn. (9.4), is that the pseudovalues can be regarded as independent and identically distributed observations. If that is true, the pseudovalue data can be analyzed by standard ANOVA techniques.*

### Explanation of terms in the model 
The term $\mu$ is a constant. By definition, the treatment effect $\tau_i$  is subject to the constraint:

\begin{equation*}
\sum_{i=1}^{I}\tau_i=0\Rightarrow \tau_\bullet=0
\end{equation*}

It is shown below, Eqn. (9.9), that this constraint ensures that $\mu$  has the interpretation as the average of the pseudovalues over treatments, readers, cases and replications, if any. 

The right hand side of Eqn. (9.4) consists of one fixed and 7 random effects. The current analysis assumes readers and cases as random factors (RRRC), so by definition $R_j$ and $C_k$ are random effects, and moreover, any term that includes a random factor is a random effect; for example, $(\tau R)_{ij}$ is a random effect because it includes the $R$ factor. Here is a list of the random terms: 

\begin{equation*}
R_j, C_k, (\tau R)_{ij}, (\tau C)_{ik}, (RC)_{jk},  (\tau RC)_{ijk},  \epsilon_{ijk}
\end{equation*}


**Assumption:** Each of the random effects is modeled as a random sample from mutually independent zero-mean normal distributions with variances as specified below:

\begin{equation*}
R_j  \sim N\left ( 0,\sigma_{R}^{2} \right ) \\
C_k \sim N\left ( 0,\sigma_{C}^{2} \right ) \\
(\tau R)_{ij} \sim N\left ( 0,\sigma_{\tau R}^{2} \right ) \\
(\tau C)_{ik} \sim N\left ( 0,\sigma_{\tau C}^{2} \right ) \\
(RC)_{jk} \sim N\left ( 0,\sigma_{RC}^{2} \right ) \\
(\tau RC)_{ijk} \sim N\left ( 0,\sigma_{\tau RC}^{2} \right ) \\
\epsilon_{ijk} \sim N\left ( 0,\sigma_{\epsilon}^{2} \right )
\end{equation*}

One could have placed a $Y$ subscript (or superscript) on each of the variances, as they describe fluctuations of the pseudovalues, not FOM values – the latter are the subject of the next chapter. However, this tends to make the notation cumbersome. So here is the convention:

*Unless explicitly stated otherwise, all variance symbols in this chapter refer to pseudovalues. * 

Another convention: $(\tau R)_{ij}$ is *not* the product of the treatment and reader factors, rather it is a single factor, namely the treatment-reader factor with $IJ$ levels, subscripted by the index $ij$ and similarly for the other product-like terms in Eqn. (9.7).

### Meanings of variance components in the DBM model
The variances defined in Eqn. (9.7) are collectively termed variance components. Specifically, they are jackknife pseudovalue variance components, to be distinguished from figure of merit (FOM) variance components to be introduced in Chapter 10. They are in order: $\sigma_{R}^{2} ,\sigma_{C}^{2} \sigma_{\tau R}^{2},\sigma_{\tau C}^{2},\sigma_{RC}^{2}, \sigma_{\tau RC}^{2},\sigma_{\epsilon}^{2}$. They have the following meanings (all references to "variance" mean "variance of pseudovalues").

*	The term $\sigma_{R}^{2}$ is the variance of readers that is independent of treatment or case, which are modeled separately. It is not to be confused with the terms $\sigma_{br+wr}^{2}$ and $\sigma_{cs+wr}^{2}$ used in §9.3, which describe the variability of $\theta$ measured under specified conditions. [A jackknife pseudovalue is a weighted difference of FOM like quantities, Eqn. (9.1). Its meaning will be explored later. For now, *a pseudovalue variance is distinct from a FOM variance*.]
*	The term $\sigma_{C}^{2}$ is the variance of cases that is independent of treatment or reader.
*	The term $\sigma_{\tau R}^{2}$ is the treatment-dependent variance of readers that was excluded in the definition of $\sigma_{R}^{2}$. If one were to sample readers and treatments for the same case-set, the net variance would be  $\sigma_{R}^{2}+\sigma_{\tau R}^{2}+\sigma_{\epsilon}^{2}$. 
*	The term $\sigma_{\tau C}^{2}$ is the treatment-dependent variance of cases that was excluded in the definition of $\sigma_{C}^{2}$. So, if one were to sample cases and treatments for the same readers, the net variance would be $\sigma_{C}^{2}+\sigma_{\tau C}^{2}+\sigma_{\epsilon}^{2}$. 
*	The term $\sigma_{RC}^{2}$ is the treatment-independent variance of readers and cases that were excluded in the definitions of $\sigma_{R}^{2}$ and $\sigma_{C}^{2}$. So, if one were to sample readers and cases for the same treatment, the net variance would be  $\sigma_{R}^{2}+\sigma_{C}^{2}+\sigma_{RC}^{2}+\sigma_{\epsilon}^{2}$. 
*	The term $\sigma_{\tau RC}^{2}$ is the variance of treatments, readers and cases that were excluded in the definitions of all the preceding terms in Eqn. (9.7). So, if one were to sample treatments, readers and cases the net variance would be $\sigma_{R}^{2}+\sigma_{C}^{2}+\sigma_{\tau C}^{2}+\sigma_{RC}^{2}+\sigma_{\tau RC}^{2}+\sigma_{\epsilon}^{2}$. 
*	The last term, $\sigma_{\epsilon}^{2}$  describes the variance arising from different replications of the study using the same treatments, readers and cases. Measuring this variance requires repeating the study several ($N$) times with the same treatments, readers and cases, and computing the variance of $Y_{n(ijk)}$ , where the additional $n$-index refers to true replications, $n$ = 1, 2, ..., $N$. 

\begin{equation*}
\sigma_{\epsilon}^{2}=\frac{1}{IJK}\sum_{i=1}^{I}\sum_{j=1}^{J}\sum_{k=1}^{k}\frac{1}{N-1}\sum_{n=1}^{N}\left ( Y_{n(ijk)} - Y_{\bullet (ijk)} \right )^2
\end{equation*}

The right hand side of Eqn. (9.8) is the variance of $Y_{n(ijk)}$, for specific $ijk$, with respect to the replication index $n$, averaged over all $ijk$. In practice $N$ = 1 (i.e., there are no replications) and this variance cannot be estimated (it would imply dividing by zero). It has the meaning of *reader inconsistency*, usually termed *within-reader* variability. As will be shown later, the presence of this inestimable term does not limit ones ability to perform significance testing on the treatment effect without having to replicate the whole study, as implied in earlier work [@RN1450].

An equation like Eqn. (9.7) is termed a *linear model* with the left hand side, the pseudovalue "observations", modeled by a sum of fixed and random terms. Specifically it is a *mixed model*, because the right hand side has both fixed and random effects. Statistical methods have been developed for analysis of such linear models. One estimates the terms on the right hand side of Eqn. (9.7), it being understood that for the random effects, one estimates the variances of the zero-mean normal distributions, Eqn. (9.7), from which the samples are obtained (by assumption).
 
Estimating the fixed effects is trivial. The term   is estimated by averaging the left hand side of Eqn. Eqn. (9.4) over all three indices (since N = 1):

  	.	(9.9)

Because of the way the treatment effect is defined, Eqn. (9.5), averaging, which involves summing, over the treatment-index i, yields zero, and all of the remaining random terms yield zero upon averaging, because they are individually sampled from zero-mean normal distributions. To estimate the treatment effect one takes the difference as shown below:

  	.	(9.10)

It can be easily seen that the reader and case averaged difference between two treatments   and   is estimated by

  	.	(9.11)
	
Estimating the strengths of the random terms is a little more complicated. It involves methods adapted from least squares, or maximum likelihood, and more esoteric ways. The author does not care to go into these methods. Instead, results are presented and arguments are made to make them plausible. The starting point is definitions of quantities called mean squares and their expected values.



## Random-reader random-case analysis (RRRC)


## Fixed-reader random-case analysis


## Random-reader fixed-case (RRFC) analysis


## DBMH analysis: Example 1, Van Dyke Data


## DBMH analysis: Example 2, VolumeRad data


## Validation of DBMH analysis



## The meaning of pseudovalues


## Summary
This chapter has detailed analysis of MRMC ROC data using the DBMH method. A reason for the level of detail is that almost all of the material carries over to other data collection paradigms, and a thorough understanding of the relatively simple ROC paradigm data is helpful to understanding the more complex ones. 

DBMH has been used in several hundred ROC studies (Prof. Kevin Berbaum, private communication ca. 2010). While the method allows generalization of a study finding, e.g., rejection of the NH, to the population of readers and cases, the author believes this is sometimes taken too literally. If a study is done at a single hospital, then the radiologists tend to be more homogenous as compared to sampling radiologists from different hospitals. This is because close interactions between radiologists at a hospital tend to homogenize reading styles and performance. A similar issue applies to patient characteristics, which are also expected to vary more between different geographical locations than within a given location served by the hospital. This means is that single hospital study based p-values may tend to be biased downwards, declaring differences that may not be replicable if a wider sampling "net" were used using the same sample size. The price paid for a wider sampling net is that one must use more readers and cases to achieve the same sensitivity to genuine treatment effects, i.e., statistical power (i.e., there is no "free-lunch").

A third MRMC ROC method, due to Clarkson, Kupinski and Barrett19,20, implemented in open-source JAVA software by Gallas and colleagues22,44 (http://didsr.github.io/iMRMC/) is available on the web. Clarkson et al19,20 provide a probabilistic rationale for the DBM model, provided the figure of merit is the empirical $AUC$. The method is elegant but it is only applicable as long as one is using the empirical AUC as the figure of merit (FOM) for quantifying observer performance. In contrast the DBMH approach outlined in this chapter, and the approach outlined in the following chapter, are applicable to any scalar FOM. Broader applicability ensures that significance-testing methods described in this, and the following chapter, apply to other ROC FOMs, such as binormal model or other fitted AUCs, and more importantly, to other observer performance paradigms, such as free-response ROC paradigm. An advantage of the Clarkson et al. approach is that it predicts truth-state dependence of the variance components. One knows from modeling ROC data that diseased cases tend to have greater variance than non-diseased ones, and there is no reason to suspect that similar differences do not exist between the variance components. 

Testing validity of an analysis method via simulation testing is only as good as the simulator used to generate the datasets, and this is where current research is at a bottleneck. The simulator plays a central role in ROC analysis. In the author's opinion this is not widely appreciated. In contrast, simulators are taken very seriously in other disciplines, such as cosmology, high-energy physics and weather forecasting. The simulator used to validate3 DBMH is that proposed by Roe and Metz39 in 1997. This simulator has several shortcomings. (a) It assumes that the ratings are distributed like an equal-variance binormal model, which is not true for most clinical datasets (recall that the b-parameter of the binormal model is usually less than one). Work extending this simulator to unequal variance has been published3. (b) It does not take into account that some lesions are not visible, which is the basis of the contaminated binormal model (CBM). A CBM model based simulator would use equal variance distributions with the difference that the distribution for diseased cases would be a mixture distribution with two peaks. The radiological search model (RSM) of free-response data, Chapter 16 &17 also implies a mixture distribution for diseased cases, and it goes farther, as it predicts some cases yield no z-samples, which means they will always be rated in the lowest bin no matter how low the reporting threshold. Both CBM and RSM account for truth dependence by accounting for the underlying perceptual process. (c) The Roe-Metz simulator is out dated; the parameter values are based on datasets then available (prior to 1997). Medical imaging technology has changed substantially in the intervening decades. (d) Finally, the methodology used to arrive at the proposed parameter values is not clearly described. Needed is a more realistic simulator, incorporating knowledge from alternative ROC models and paradigms that is calibrated, by a clearly defined method, to current datasets. 

Since ROC studies in medical imaging have serious health-care related consequences, no method should be used unless it has been thoroughly validated. Much work still remains to be done in proper simulator design, on which validation is dependent.


## References  

