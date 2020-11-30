# The radiological search model {#rsm}




## Introduction {#rsm-intro}

Brief summaries of the radiological search model (RSM) were presented earlier in connection with the simulator used to generate FROC data. This chapter describes the statistical model in more detail. It embodies the essential ideas of the Nodine-Kundel model of visual search described in the previous chapter. It turns out that all that is needed to model seemingly as complex a process as visual search, at least to first order, is one additional parameter. All models of ROC data involve two parameters (not counting thresholds). For example, the unequal variance binormal model Chapter 06 requires the (a,b) parameters. Alternative ROC models described in Chapter 20 also require two parameters. The model described below contains three parameters,  ,  , and  . The   parameter is the simplest to understand: it is the perceptual signal-to-noise ratio (pSNR) of latent LLs relative to latent NLs. The parameters  , and   describe the search process, i.e., the first stage of the Nodine-Kundel model (glancing or global impression). Essentially, they describe the ability of the observer to find latent LLs while not finding latent NLs. It turns out that it is easier to understand the search process via intermediate primed parameters,   and  ; however, unlike  ,  , the primed parameters depend on  , i.e., they are not intrinsic. So the following will introduce, in order,  ,  and  , and explain their meaning via software examples. Physical meanings for these parameters will be given as well as how one might measure them via eye-tracking measurements. Finally, a model re-parameterization is proposed, which takes into account that   and   must depend on , and this is where the parameters   and   are introduced, which are expected to be intrinsic, i.e., independent of .

The online appendices explain Poisson and binomial sampling at a simple level. It is the author's experience that users of the author's software are generally not trained in statistics.



Brief summaries of the radiological search model (RSM) were presented earlier in connection with the simulator used to generate FROC data. This chapter describes the statistical model in more detail. It embodies the essential ideas of the Nodine-Kundel model of visual search described in the previous chapter. It turns out that all that is needed to model seemingly as complex a process as visual search, at least to first order, is one additional parameter. All models of ROC data involve two parameters (not counting thresholds). For example, the unequal variance binormal model Chapter 06 requires the (a,b) parameters. Alternative ROC models described in Chapter 20 also require two parameters. The model described below contains three parameters,  ,  , and  . The   parameter is the simplest to understand: it is the perceptual signal-to-noise ratio (pSNR) of latent LLs relative to latent NLs. The parameters  , and   describe the search process, i.e., the first stage of the Nodine-Kundel model (glancing or global impression). Essentially, they describe the ability of the observer to find latent LLs while not finding latent NLs. It turns out that it is easier to understand the search process via intermediate primed parameters,   and  ; however, unlike  ,  , the primed parameters depend on  , i.e., they are not intrinsic. So the following will introduce, in order,  ,  and  , and explain their meaning via software examples. Physical meanings for these parameters will be given as well as how one might measure them via eye-tracking measurements. Finally, a model re-parameterization is proposed, which takes into account that   and   must depend on , and this is where the parameters   and   are introduced, which are expected to be intrinsic, i.e., independent of .

The online appendices explain Poisson and binomial sampling at a simple level. It is the author's experience that users of the author's software are generally not trained in statistics.
16.2: The radiological search model (RSM)
The Radiological Search Model (RSM) for the free-response paradigm is a statistical parameterization of the Nodine-Kundel model. It consists of:

A search stage corresponding to the initial glance in the Nodine-Kundel sense, in which suspicious regions, i.e., the latent marks, are flagged for subsequent scanning. The total number of latent marks on a case is  , so some cases may have zero latent marks, a fact that will turn out to have important consequences for the shapes of all RSM predicted operating characteristics.
A decision stage during which each latent mark is scanned, features are extracted and analyzed and the observer obtains a decision variable (i.e., a z-sample) at each latent mark. Typically radiologists spend >1 s per site and high-resolution foveal examination is necessary to extract relevant details of the region being examined and make a decision whether to mark it. The number of z-samples equals the number of latent marks on the case.

Latent marks can be either latent NLs (corresponding to non-diseased regions) or latent LLs (corresponding to diseased regions). The number of latent NLs on a case is denoted  . The number of latent LLs on a diseased case is denoted  . Latent NLs can occur on non-diseased and diseased cases, but latent LLs can only occur on diseased cases. Assume that every diseased case has L actual lesions. Later this is extended to arbitrary number of lesions per diseased case. Since the number of latent LLs cannot exceed the number of lesions,  . (The symbol   is for location and the subscript is the site-level truth state s; case-level subscripts are temporarily suppressed for brevity.)

Distributional assumptions are made for the numbers of latent NLs and latent LLs and on the associated z-samples. Since in this chapter one is dealing with a parametric model of search, one does not need to show explicitly case and location dependence as in Chapter 13. This allows for a simpler notation unencumbered by a plethora of subscripts.

## RSM assumptions {#rsm-assumptions}

The number of latent NLs,  , is an integer random variable sampled from the Poisson distribution with mean  :

 	.	(16.1)

The reason for the prime will become clear in 16.4. The probability mass function (pmf) of the Poisson distribution is defined by:

 	.	(16.2)

The number of latent LLs,  ,  , is an integer random variable sampled from the binomial distribution with success probability   and trial size  : 


 	.	(16.3)


The pmf of the binomial distribution is defined by:

 	.	(16.4)

Each latent mark is associated with a z-sample. That for a latent NL is denoted   while that for a latent LL is denoted  . Latent NLs can occur on non-diseased and diseased cases while latent LLs can only occur on diseased cases.

1.	For latent NLs, the z-samples are obtained by sampling  :

 	.	(16.5)


2.	For latent LLs, the z-samples are obtained by sampling  :

 	.	(16.6)

3.	In an FROC study with R ratings, the observer adopts R ordered cutoffs  (r = 1, 2, ..., R). Defining   and  , if   the corresponding latent site is marked and rated in bin r, and if   the site is not marked. 

4.	The location of the mark is at the center of the latent site that exceeded a cutoff and an infinitely precise proximity criterion is adopted. Consequently, there is no confusing a mark made because of a latent LL z-sample exceeding the cutoff as one made because of a latent NL z-sample exceeding the cutoff, and vice-versa. Therefore, any mark made because of a latent NL z-sample that satisfies  will be scored as non-lesion localization (NL) and rated r. Any mark made because of a latent LL z-sample that satisfies   will be scored as a lesion-localization (LL) and rated r. Notice that unmarked LLs (latent or not) are assigned the zero rating. By "latent or not" the author means that even lesions that were not flagged by the search stage, and therefore do not qualify as latent LLs, are assigned the zero rating.

5.	By choosing R large enough, the above discrete rating model becomes applicable to continuous z-samples; see Chapter 05, 5.6.

 

## Summary of RSM defining equations {#rsm-summary-rsm-equations}

The RSM is summarized in Table 16.1.

Table 16.1: Summary of RSM defining equations
Latent NL site sampling	 
 
 ; 

Latent LL site sampling	 
 
 ; 

z-sampling for latent NLs on case with truth state t	 
Applies to NL z-samples on non-diseased and diseased cases
z-sampling for latent LLs	 
 

Marking and binning rule for NLs	 
 

Marking and binning rule for LLs	 

Unmarked latent NL sites	 
Unobservable events
Unmarked lesions, latent or not	 
Inferred zero rating for latent LLs


## Physical interpretation of RSM parameters {#rsm-parameter-interpretations}
The parameters  , and   have the following meanings.

### The   parameter {#rsm-mu-parameter}
The parameter   is the perceptual signal to noise ratio, pSNR, introduced in Chapter 12, between latent NLs and latent LLs. It is not the perceptual signal-to-noise ratio of the latent LL relative to its immediate surround; the immediate surround provides background context and is what makes the lesion conspicuous, i.e., it is part of pSNR; the competition for latent marks is other regions that could be mistaken for lesions, i.e., latent NLs. The immediate surround has no chance of being mistaken for a lesion; calculating pSNR the conventional way using the immediate surround, as in computer analysis of mammography phantom images1,2 (CAMPI), will yield an infinite value (because the contrast is measured relative to the surround, i.e., the latter has zero noise).

The   parameter is similar to detectability index  , which is the separation parameter of two unit normal distributions required to achieve the observed probability of correct choice (PC) in a two alternative forced choice (2AFC) task between cued (i.e., pointed to by toggle-able arrows ) NLs and cued LLs. One measures the locations of the latent marks using eye-tracking apparatus3 and clusters the data as described in Chapter 15, then runs a 2AFC study as follows. Pairs of images are shown, each with a cued location, one a latent NL (a big-cluster, as defined in Chapter 15) and the other a latent LL, where all locations were recorded in prior eye-tracking sessions for the specific radiologist. The radiologist's task is to pick the image with the latent LL. The probability correct (PC) in this task is related to the   parameter by:

 	.	(16.7)

It is essential that the radiologist on whom the eye-tracking measurements were performed and the one who performs the two alternative forced choice tasks be the same. Two radiologists will not agree on latent marks. This will be more evident for the latent NL marks, since greater disagreement is expected on what truly does not exist, and was "conjured" in the radiologist's mind (which varies between radiologists). Disagreement is also expected, but to a lesser degree, on the latent LLs; one expects less disagreement on what truly exists (as this is independent of the radiologist). However, the set of latent LLs for the two observers are expected to be different. Specifically, a region perceived as a latent LL by one might be missed by the other. A complication in conducting such a study is that because of memory effects, a lesion can only be shown once; this could result in a limited number of comparisons and a consequential imprecise estimate of  .

### The   parameter {#rsm-summary-lambda-parameter}

The   parameter determines the tendency of the observer to generate latent NLs. The mean number of latent NLs per case estimates  ; this is a property of the Poisson distribution. It can also be measured via eye-tracking apparatus. This time it is only necessary to cluster the marks and classify each mark as a latent NL or latent LL according to the adopted acceptance radius. An eye-tracking based estimate would be the total number of latent NLs (the big-clusters in the previous chapter) in the dataset divided by the total number of cases.

Consider two observers, one with  = one and the other with  = two. While one cannot predict the number of latent NLs on any specific case, one can predict the average number of latent NLs on a given case set. Use R (copy and paste the commands into the Console window) to demonstrate this:

16.3.2.1: Code snippets
> seed <- 1;set.seed(seed);samples1 <- rpois(100,1);mean(samples1)
[1] 1.01
> seed <- 1;set.seed(seed);samples2 <- rpois(100,2);mean(samples2)
[1] 2.02
> samples1[1:10]
[1] 0 1 1 2 0 2 3 1 1 0
> samples2[1:10]
[1] 1 1 2 4 1 4 4 2 2 0

In this example, the number of samples has been set to 100 (the first argument to rpois()). For the first observer,  = one, the first case generated zero latent NLs, the 2nd and 3rd generated one NL each, etc. For the second observer, the first and second case generated one latent NL each, the third generated two, etc. While one cannot predict what will happen on any specific case, one can predict that the average number of latent NL marks per case for the 1st observer will be close to 1 (the observed values is 1.01) and that for the 2nd one will be close to 2 (the observed values is 2.02).

Estimates should be accompanied by confidence intervals. The code is in file mainPoissonExample.R in Online Appendix 16.A.1, which illustrates Poisson sampling and estimation of an exact confidence interval for the mean of a number of a given number of samples from a Poisson distribution. Source the code to get the following output.

16.3.2.2: Code output
> source('~/book2/04 C FROC analysis/C16 Radiological Search Model/software/mainPoissonExample.R')
K =  100 , lambdaP 1st reader =  1 , lambdaP 2nd reader =  2
obs. mean, reader 1 =  1.01
obs. mean, reader 2 =  2.02
Rdr. 1: 95% CI =  0.8226616 1.227242
Rdr. 2: 95% CI =  1.751026 2.318599


This code uses 100 samples (K, line 5 in listing). For reader 1 the estimate of the Poisson parameter (the mean parameter of the Poisson distribution is frequently referred to as the Poisson parameter) is 1.01 with 95% confidence interval (0.823, 1.227); for reader 2 the corresponding estimate is 2.02 with 95% confidence interval (1.751, 2.319). As the number of cases increases, the confidence interval shrinks. For example, with 10000 cases, i.e., 100 times the value in the previous example:

16.3.2.3: Code output
> source('~/book2/04 C FROC analysis/C16 Radiological Search Model/software/mainPoissonExample.R')
K =  10000 , lambdaP 1st reader =  1 , lambdaP 2nd reader =  2
obs. mean, reader 1 =  1.0055
obs. mean, reader 2 =  2.006
Rdr. 1: 95% CI =  0.9859414 1.025349
Rdr. 2: 95% CI =  1.978335 2.033955

This time for reader 1, the estimate of the Poisson parameter is 1.01 with 95% confidence interval (0.986, 1.025); for reader 2 the corresponding estimate is 2.01 with 95% confidence interval (1.978, 2.034). The width of the confidence interval is inversely proportional to the square root of the number of cases (the example below is for reader 1):

16.3.2.4: Code snippet
> -(0.8226616-1.2272416) # reader 1
[1] 0.40458
> -(0.9859414-1.0253490) # reader 1
[1] 0.0394076

Since the number of cases was increased by a factor of 100, the width decreased by a factor of 10.

### The   parameter {#rsm-summary-nu-parameter}
The  parameter determines the ability of the observer to find lesions. Assuming the same number of lesions per diseased case, the mean fraction of latent LLs per diseased case is an estimate of  . It too can be measured via eye-tracking apparatus performed on a radiologist. An eye-tracking based estimate would be the total number of latent LLs (big clusters each of which localizes a lesion) in the dataset divided by the total number of lesions. Consider two observers, one with  = 0.5 and the other with  = 0.9. Again, while one cannot predict the precise number of latent LLs on any specific diseased case, or which specific lesions will be correctly localized, one can predict the average number of latent LLs. The code is in file mainBinomialExample1.R in Online Appendix 16.B.1. Source it to get the following output.

16.3.3.1: Code output
> source('~/book2/04 C FROC analysis/C16 Radiological Search Model/software/mainBinomialExample1.R')
K2 =  100 , nuP 1st reader =  0.5 , nuP 2nd reader =  0.9
mean, reader 1 =  0.48
mean, reader 2 =  0.94
Rdr. 1: 95% CI =  0.3790055 0.5822102
Rdr. 2: 95% CI =  0.8739701 0.9776651

This code uses 100 samples (K2, line 5 in listing). The result shows that for reader 1 the estimate of the binomial success rate parameter is 0.48 with 95% confidence interval (0.38, 0.58); for reader 2 the corresponding estimate is 0.94 with 95% confidence interval (0.87, 0.98). As the number of diseased cases increases, the confidence interval shrinks in inverse proportion to the square root of cases. [Example, increasing the number of cases by a factor of 100, for reader 1 the CI width ratio is: (0.4854532-0.5051496)/(0.3790055-0.5822102) = 0.097.]

As a more complicated but clinically realistic example, consider a dataset with 100 cases in all where 97 have one lesion per case, two have two lesions per case and one has three lesions per case (these are typical lesion distributions observed in screening mammography). The code is in file mainBinomialExample2.R in Online Appendix 16.C.1. Source it to get the following output.

16.3.3.2: code output

```
> source('~/book2/04 C FROC analysis/C16 Radiological Search Model/software/mainBinomialExample2.R')
K2[1] = 97 , K2[2] = 2 , K2[3] = 1 , nuP1 = 0.5 , nuP2 = 0.9
obsvd. mean, reader 1 =  0.4903846
obsvd. mean, reader 2 =  0.9326923
Rdr. 1: 95% CI =  0.3910217 0.5903092
Rdr. 2: 95% CI =  0.8662286 0.9725125
```

## Model re-parameterization {#rsm-re-parameterization}
While the parameters  , and   are physically meaningful, and can be estimated from eye-tracking measurements, a little thought reveals that they cannot be varied independently of each other. Rather,   is the intrinsic  parameter whose value, together with two other intrinsic parameters   and  , determines the physically more meaningful parameters and  , respectively, according to the following re-parameterization:

 	.	(16.8)

 	.	(16.9)

The parameterization is not unique, but the one adopted is relatively simple. The need for the first re-parameterization (involving  ) was foreseen (using different notation) in the original search model papers4,5 but the need for the second re-parameterization (involving  ) was discovered more recently. Since it determines  , the   parameter can be considered as the intrinsic (i.e.,  -independent) ability to find lesions; specifically, it is the rate of increase of   with   at small  :


 	.	(16.10)

The dependence of   on   is consistent with the fact that higher contrast lesions will be easier to find by any observer. This is why   is not an intrinsic property - any observer, even one without special expertise, can find a high contrast lesion. Conversely, lower contrast lesions will be more difficult to find even by expert observers. The colloquial term "find" is used as shorthand for "flagged for further inspection by the holistic 1st stage of the search mechanism, thus qualifying as a latent site". In other words, "finding" a lesion means the lesion was perceived as a suspicious region, which makes it a latent site, independent of whether or not the region was actually marked. Finding refers to the search stage. Marking refers to the decision stage, where the region's z-sample is determined and compared to a marking threshold.

According to Eqn. (16.8), as  ,  , and in the opposite limit as  ,  . Recall the analogy to finding the sun made in Chapter 12: objects with very high perceptual SNR are certain to be found and conversely, objects with zero perceptual SNR are found only by chance and are marked based on cost-benefit considerations.

According to Eqn. (16.9) the value of   also determines  : as     and conversely, as   then  . This too is clear from the sun analogy of Chapter 12. Since the sun has very high contrast, there is no reason for the observer to find other suspicious regions, which have no possibility of resembling the sun. On the other hand, attempting to locate a faint star hidden by clouds is guaranteed to generate several latent NLs (because the expected small SNR from the real star is comparable to that from a number of regions in the background).

The re-parameterization used here is not unique, but is simple and has the right limiting behaviors.

## Discussion / Summary {#rsm-discussion-summary}
This chapter has described a statistical parameterization of the Nodine-Kundel model. The 3-parameter model of search in the context in the medical imaging context accommodates key aspects of the process: search, the ability to find lesions while minimizing finding non-lesions, is described by two parameters, specifically,  . The ability to correctly mark a found lesion (while not marking found non-lesions) is characterized by the third parameter of the model,  . While the primed parameters have relatively simple physical meaning, they depend on  . Consequently, it is necessary to define them in terms of intrinsic parameters. The modeled dependence on   is not unique.

The next chapter explores the predictions of the radiological search model.

## References {#rsm-references}
1.	Chakraborty DP. Computer analysis of mammography phantom images (CAMPI): An application to the measurement of microcalcification image quality of directly acquired digital images. Medical Physics. 1997;24(8):1269-1277.
2.	Chakraborty DP, Eckert MP. Quantitative versus subjective evaluation of mammography accreditation phantom images. Medical Physics. 1995;22(2):133-143.
3.	Chakraborty DP, Yoon H-J, Mello-Thoms C. Application of threshold-bias independent analysis to eye-tracking and FROC data. Academic Radiology. 2012;In press.
4.	Chakraborty DP. ROC Curves predicted by a model of visual search. Phys Med Biol. 2006;51:3463–3482.
5.	Chakraborty DP. A search model and figure of merit for observer data acquired according to the free-response paradigm. Phys Med Biol. 2006;51:3449–3462.

