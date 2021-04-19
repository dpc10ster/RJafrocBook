# The radiological search model {#rsm}





## TBA How much finished {#rsm-how-much-finished}
10%



## Introduction {#rsm-intro}

Brief accounts of the radiological search model (RSM) were presented earlier in connection with the simulator used to generate FROC data. This chapter describes the statistical model in more detail. It embodies the essential ideas of the Nodine-Kundel model of visual search described in the previous chapter. *It turns out that all that is needed to model seemingly as complex a process as visual search, at least to first order, is one additional parameter*. All models of ROC data involve two parameters (not counting thresholds). For example, the unequal variance binormal model in Chapter \@ref(binormal-model) requires the (a,b) parameters. Alternative ROC models described in Chapter 20 also require two parameters. The model described below contains three parameters: $\mu$, $\lambda$ and $\nu$. The $\mu$ parameter is the simplest to understand: it is the perceptual signal-to-noise ratio *pSNR* of latent LL ratings relative to latent NL ratings. The parameters $\lambda$ and $\nu$ describe the search process, i.e., the first stage of the Nodine-Kundel model (glancing or global impression). They describe the ability of the observer to find latent LLs while not finding latent NLs. It turns out that it is easier to understand the search process via intermediate primed parameters, $\lambda'$ and  $\nu'$; however, unlike $\lambda$ and $\nu$ the primed parameters depend on  $\mu$, i.e., *they are not intrinsic*. So in what follows I will introduce, in order, $\mu$, $\lambda'$ and $\nu'$ and explain their meanings via software examples, as well as how one might measure them via eye-tracking measurements. Finally, a model re-parameterization is proposed, which takes into account that $\lambda'$ and  $\nu'$ must depend on $\mu$, and this is where the un-primed parameters $\lambda$ and $\nu$ are introduced, *which are expected to be intrinsic*, i.e., independent of $\mu$.

TBA [The online appendices explain Poisson and binomial sampling at a simple level. It is my experience that users of my software are generally not trained in statistics.]


## The radiological search model {#rsm-details}
The Radiological Search Model (RSM) for the free-response paradigm is a statistical parameterization of the Nodine-Kundel model. It consists of:

* A *search stage* corresponding to the initial glance in the Nodine-Kundel sense, in which suspicious regions, i.e., the latent marks, are flagged for subsequent scanning. The total number of latent marks on a case is $\geq 0$, so some cases may have zero latent marks, a fact that will turn out to have important consequences for the shapes of all RSM predicted operating characteristics.

* A *decision stage* during which each latent mark is scanned, features are extracted and analyzed and the observer obtains a decision variable (i.e., a z-sample) at each latent mark. Typically radiologists spend ~ 1 s per site and high-resolution foveal inspection is necessary to extract relevant details of the region being examined and make a decision whether or not to mark it. The number of realized z-samples equals the number of latent marks on the case.

* Latent marks can be either latent NLs (corresponding to non-diseased regions) or latent LLs (corresponding to diseased regions). The number of latent NLs on a case is denoted $l_1$. The number of latent LLs on a diseased case is denoted $l_2$. Latent NLs can occur on non-diseased and diseased cases, but latent LLs can only occur on diseased cases. Assume for now that every diseased case has $L$ actual lesions. Later this is extended to arbitrary number of lesions per diseased case. Since the number of latent LLs cannot exceed the number of lesions, $0 \leq l_2 \leq L$ . The symbol $l_s$  denotes a location with site-level truth state $s$, where $s = 1$ for a NL and $s = 2$ for a LL^[In this chapter distributional assumptions are made for the numbers of latent NLs and LLs and for the associated z-samples. Since one is dealing with a parametric model one does not need to show explicitly case and location dependence as in the empirical description in Chapter \@ref(#froc-empirical). This allows for a simpler notation, as the reader may have noticed, unencumbered by the plethora of subscripts in Table \#ref(#froc-empirical-notation).].

## RSM assumptions {#rsm-assumptions}

The number of latent NLs, $l_1 \geq 0$, is an integer random variable sampled from the Poisson distribution with mean $\lambda'$:

\begin{equation} 
l_1 \sim \text{Poi}\left ( \lambda' \right ) 
(\#eq:rsm-poisson-sampling)
\end{equation}


The probability mass function *pmf* of the Poisson distribution is defined by:

\begin{equation} 
\text{pmf}_{Poi}\left ( l_1, \lambda' \right ) = exp\left ( -\lambda' \right ) \frac{{(\lambda')^{l_1}}}{(l_1')!}
(\#eq:rsm-poisson-pmf)
\end{equation}

The number of latent LLs, $l_2$, where $0 \leq l_2 \leq L$, is an integer random variable sampled from the binomial distribution $B$ with success probability $\nu'$ and trial size $L$: 


\begin{equation} 
l_2 \sim \text{Bin}\left ( L, \nu' \right ) 
(\#eq:rsm-binomial-sampling)
\end{equation}

The *pmf* of the binomial distribution is defined by:

\begin{equation} 
\text{pmf}_{Bin}\left ( l_2, \nu' \right ) = \binom{L}{l_2} \left (\nu'  \right )^{l_2} \left (1-\nu'  \right )^{L-l_2}
(\#eq:rsm-binomial-pmf)
\end{equation}


Each latent mark is associated with a z-sample. That for a latent NL is denoted $z_{l_1}$ while that for a latent LL is denoted $z_{l_2}$. Latent NLs can occur on non-diseased and diseased cases while latent LLs can only occur on diseased cases.

1. For latent NLs, the z-samples are obtained by sampling $N \left ( 0, 1 \right )$:

\begin{equation} 
z_{l_1} \sim N \left ( 0, 1 \right )
(\#eq:rsm-sampling-l1)
\end{equation}

2. For latent LLs, the z-samples are obtained by sampling $N \left ( \mu, 1 \right )$:

\begin{equation} 
z_{l_2} \sim N \left ( \mu, 1 \right )
(\#eq:rsm-sampling-l2)
\end{equation}

3. In an FROC study with R ratings, the observer adopts $R$ ordered cutoffs $\zeta_r$, where $\left ( r = 1, 2, ..., R \right )$. Defining  $\zeta_0 = -\infty$ and $\zeta_{R+1} = \infty$, then if $\zeta_r \leq z_{l_s} < \zeta_{r+1}$ the corresponding latent site is marked and rated in bin $r$, and if $z_{l_s} \leq \zeta_1$ the site is not marked. 

4. The location of the mark is at the center of the latent site that exceeded a cutoff and an infinitely precise proximity criterion is adopted. Consequently, there is no confusing a mark made because of a latent LL z-sample exceeding the cutoff with one made because of a latent NL z-sample exceeding the cutoff, and vice-versa. Therefore, any mark made because of a latent NL z-sample that satisfies $\zeta_r \leq z_{l_1} < \zeta_{r+1}$ will be scored as a non-lesion localization (NL) and rated $r$. Likewise, any mark made because of a latent LL z-sample that satisfies $\zeta_r \leq z_{l_2} < \zeta_{r+1}$ will be scored as a lesion-localization (LL) and rated $r$. 

5. In addition unmarked LLs (latent or not) are assigned the zero rating. By "latent or not" I mean that even lesions that were not flagged by the search stage, and therefore do not qualify as latent LLs, are assigned the zero rating. This is because they represent observable events.

6. By choosing $R$ large enough, the above discrete rating model is applicable to continuous z-samples.

## Summary of RSM {#rsm-summary}
* First stage: initial glance, observer identifies latent NLs and latent LLs:
    + Number of NLs ~ Poisson with mean $\lambda'$,  
    + Number of LLs ~ binomial with success probability $\nu'$ and trial size $L$.
*	Second stage: detailed scrutiny, observer calculates z-sample at each latent mark: 
    + z-sample for latent NL $\sim N(0,1)$,  
    + z-sample for latent LL $\sim N(\mu,1)$.
*	Latent mark is actually marked if $z \geq \zeta_1$.   
*	The rating assigned to a mark is the index of the nearest threshold that was just equaled or exceeded by the z-sample. 
* Unmarked latent NLs are unobservable events, but unmarked LLs, latent or not, are assigned the zero rating.
 

## Physical interpretation of RSM parameters {#rsm-parameter-interpretations}
The parameters $\mu$, $\lambda'$ and $\nu'$ have the following meanings:

### The $\mu$ parameter {#rsm-mu-parameter}
The $\mu$ parameter is the lesion contrast-to-noise-ratio, or more accurately, the perceptual signal to noise ratio *pSNR* introduced in TBA Chapter 12, between latent NLs and latent LLs. It is not the pSNR of the latent LL relative to its immediate surround. For structured backgrounds - as opposed to homogeneous backgrounds - pSNR is determined by the competition for latent marks from other regions, outside the immediate surround, that could be mistaken for lesions.  

The $\mu$ parameter is similar to detectability index $d'$, which is the separation parameter of two unit normal distributions required to achieve the observed probability of correct choice (PC) in a two alternative forced choice (2AFC) task between cued (i.e., pointed to by toggle-able arrows ) NLs and cued LLs. One measures the locations of the latent marks using eye-tracking apparatus TBA3 and clusters the data, then runs a 2AFC study as follows. Pairs of images are shown, each with a cued location, one a latent NL and the other a latent LL, where all locations were recorded in prior eye-tracking sessions for the specific radiologist. The radiologist's task is to pick the image with the latent LL. The probability correct $\text{PC}$ in this task is related to the $d'$ parameter by:

\begin{equation} 
\mu = \sqrt{2} \Phi^{-1} \left ( \text{PC} \right )
(\#eq:rsm-mu-2afc)
\end{equation}

The radiologist on whom the eye-tracking measurements were performed and the one who performs the two alternative forced choice tasks must be the same, as two radiologists may not agree on latent NL marks. A complication in conducting such a study is that because of memory effects, a lesion can only be shown once; this could result in a limited number of comparisons and a consequential imprecise estimate of $\mu$.

### The $\lambda'$ parameter {#rsm-summary-lambda-prime-parameter}

The $\lambda'$ parameter determines the tendency of the observer to generate latent NLs. The mean number of latent NLs per case is an estimate of $\lambda'$. This can also be measured via eye-tracking apparatus. This time it is only necessary to cluster the marks and classify each mark as a latent NL or latent LL according to the adopted acceptance radius. An eye-tracking based estimate would be the total number of latent NLs in the dataset divided by the total number of cases.

Consider two observers, one with $\lambda' = 1$ and the other with $\lambda' = 2$. While one cannot predict the exact number of latent NLs on any specific case, one can predict the average number of latent NLs on a given case set. 


```r
seed <- 1;set.seed(seed)
samples1 <- rpois(100,1)
mean(samples1)
```

```
## [1] 1.01
```

```r
samples1[1:10]
```

```
##  [1] 0 1 1 2 0 2 3 1 1 0
```

```r
seed <- 1;set.seed(seed)
samples2 <- rpois(100,2)
mean(samples2)
```

```
## [1] 2.02
```

```r
samples2[1:10]
```

```
##  [1] 1 1 2 4 1 4 4 2 2 0
```

In this example, the number of samples has been set to 100 (the first argument to `rpois()`). 

* For the first observer, $\lambda' = 1$ (the second argument to `rpois()`), the first case generated zero latent NLs, the 2nd and 3rd cases generated one NL each, the third case generated 2 NLs, etc. 

* For the second observer, the first and second case generated one latent NL each, the third generated two, etc. While one cannot predict what will happen on any specific case, one can predict that the average or `mean()` number of latent NL marks per case for the 1st observer will be close to 1 (the observed values is 1.01) and that for the 2nd one will be close to 2 (the observed values is 2.02).

Estimates should be accompanied by confidence intervals. The following code illustrates Poisson sampling and estimation of an exact confidence interval for the mean for 100 samples from two Poisson distributions. 



```r
K <- 100
lambdaP <- c(1,2)
cat ("K = ", K,", lambdaP 1st reader = ", lambdaP[1],", lambdaP 2nd reader = ", lambdaP[2],"\n")
```

```
## K =  100 , lambdaP 1st reader =  1 , lambdaP 2nd reader =  2
```

```r
seed <- 1;set.seed(seed);samples1 <- rpois(K,lambda = lambdaP[1]);cat("obs. mean, reader 1 = ", mean(samples1), "\n")
```

```
## obs. mean, reader 1 =  1.01
```

```r
seed <- 1;set.seed(seed);samples2 <- rpois(K,lambda = lambdaP[2]);cat("obs. mean, reader 2 = ", mean(samples2), "\n")
```

```
## obs. mean, reader 2 =  2.02
```

```r
ret11 <- poisson.exact(sum(samples1),K)
ret21 <- poisson.exact(sum(samples2),K)

cat ("Rdr. 1: 95% CI = ", ret11$conf.int[1:2],"\n")
```

```
## Rdr. 1: 95% CI =  0.8226616 1.227242
```

```r
cat ("Rdr. 2: 95% CI = ", ret21$conf.int[1:2],"\n")
```

```
## Rdr. 2: 95% CI =  1.751026 2.318599
```


For reader 1 the estimate of the Poisson parameter (the mean parameter of the Poisson distribution is frequently referred to as the Poisson parameter) is 1.01 with 95% confidence interval (0.823, 1.227); for reader 2 the corresponding estimates are 2.02 with 95% confidence interval (1.751, 2.319). As the number of cases increases, the confidence interval shrinks. For example, with 10000 cases, i.e., 100 times the value in the previous example:


```r
K <- 10000
lambdaP <- c(1,2)
cat ("K = ", K,", lambdaP 1st reader = ", lambdaP[1],", lambdaP 2nd reader = ", lambdaP[2],"\n")
```

```
## K =  10000 , lambdaP 1st reader =  1 , lambdaP 2nd reader =  2
```

```r
seed <- 1;set.seed(seed);samples1 <- rpois(K,lambda = lambdaP[1]);cat("obs. mean, reader 1 = ", mean(samples1), "\n")
```

```
## obs. mean, reader 1 =  1.0055
```

```r
seed <- 1;set.seed(seed);samples2 <- rpois(K,lambda = lambdaP[2]);cat("obs. mean, reader 2 = ", mean(samples2), "\n")
```

```
## obs. mean, reader 2 =  2.006
```

```r
ret12 <- poisson.exact(sum(samples1),K)
ret22 <- poisson.exact(sum(samples2),K)

cat ("Rdr. 1: 95% CI = ", ret12$conf.int[1:2],"\n")
```

```
## Rdr. 1: 95% CI =  0.9859414 1.025349
```

```r
cat ("Rdr. 2: 95% CI = ", ret22$conf.int[1:2],"\n")
```

```
## Rdr. 2: 95% CI =  1.978335 2.033955
```

This time for reader 1, the estimate of the Poisson parameter is 1.01 with 95% confidence interval (0.986, 1.025); for reader 2 the corresponding estimate is 2.01 with 95% confidence interval (1.978, 2.034). The width of the confidence interval is inversely proportional to the square root of the number of cases (the example below is for reader 1):



```r
ret11$conf.int[2] - ret11$conf.int[1]
```

```
## [1] 0.40458
```

```r
ret12$conf.int[2] - ret12$conf.int[1]
```

```
## [1] 0.03940756
```

Since the number of cases was increased by a factor of 100, the width decreased by a factor of 10, the square-root of the ratio of the numbers of cases.

### The $\nu'$ parameter {#rsm-summary-nu-parameter}
The $\nu'$ parameter determines the ability of the observer to find lesions. Assuming the same number of lesions per diseased case, the mean fraction of latent LLs per diseased case is an estimate of $\nu'$. It too can be measured via eye-tracking apparatus performed on a radiologist. An eye-tracking based estimate would be the total number of latent LLs in the dataset divided by the total number of lesions. Consider two observers, one with  $\nu' = 0.5$ and the other with $\nu' = 0.9$. Again, while one cannot predict the precise number of latent LLs on any specific diseased case, or which specific lesions will be correctly localized, one can predict the average number of latent LLs. The code follows:



```r
K2 <- 100;L <- 1;nuP1 <- 0.5;nuP2 <- 0.9;
cat ("K2 = ", K2,", nuP 1st reader = ", 0.5,", nuP 2nd reader = ", 0.9,"\n")
```

```
## K2 =  100 , nuP 1st reader =  0.5 , nuP 2nd reader =  0.9
```

```r
seed <- 1;set.seed(seed);samples1 <- rbinom(K2,L,nuP1);cat("mean, reader 1 = ", mean(samples1)/L, "\n")
```

```
## mean, reader 1 =  0.48
```

```r
seed <- 1;set.seed(seed);samples2 <- rbinom(K2,L,nuP2);cat("mean, reader 2 = ", mean(samples2)/L, "\n")
```

```
## mean, reader 2 =  0.94
```

```r
ret1 <- binom.exact(sum(samples1),K2*L)
ret2 <- binom.exact(sum(samples2),K2*L)

cat ("Rdr. 1: 95% CI = ", ret1$conf.int[1:2],"\n")
```

```
## Rdr. 1: 95% CI =  0.3790055 0.5822102
```

```r
cat ("Rdr. 2: 95% CI = ", ret2$conf.int[1:2],"\n")
```

```
## Rdr. 2: 95% CI =  0.8739701 0.9776651
```

This code also uses 100 samples (`K2`). The result shows that for reader 1 the estimate of the binomial success rate parameter is 0.48 with 95% confidence interval (0.38, 0.58). For reader 2 the corresponding estimates are 0.94 with 95% confidence interval (0.87, 0.98). As the number of diseased cases increases, the confidence interval shrinks in inverse proportion to the square root of cases. 

As a more complicated but clinically realistic example, consider a dataset with 100 cases in all where 97 have one lesion per case, two have two lesions per case and one has three lesions per case (these are typical lesion distributions observed in screening mammography). The code follows:



```r
K2 <- c(97,2,1);Lk <- c(1,2,3);nuP1 <- 0.5;nuP2 <- 0.9;
samples1 <- array(dim = c(sum(K2),length(K2)))
cat("K2[1] =", K2[1],", K2[2] =", K2[2],", K2[3] =", K2[3], ", nuP1 =", nuP1, ", nuP2 =", nuP2, "\n")
```

```
## K2[1] = 97 , K2[2] = 2 , K2[3] = 1 , nuP1 = 0.5 , nuP2 = 0.9
```

```r
seed <- 1;set.seed(seed)
for (l in 1:length(K2)) {
  samples1[1:K2[l],l] <- rbinom(K2[l],Lk[l],nuP1)
}
cat("obsvd. mean, reader 1 = ", sum(samples1[!is.na(samples1)])/sum(K2*Lk), "\n")
```

```
## obsvd. mean, reader 1 =  0.4903846
```

```r
samples2 <- array(dim = c(sum(K2),length(K2)))
seed <- 1;set.seed(seed)
for (l in 1:length(K2)) {
  samples2[1:K2[l],l] <- rbinom(K2[l],Lk[l],nuP2)
}
cat("obsvd. mean, reader 2 = ", sum(samples2[!is.na(samples2)])/sum(K2*Lk), "\n")
```

```
## obsvd. mean, reader 2 =  0.9326923
```

```r
ret1 <- binom.exact(sum(samples1[!is.na(samples1)]),sum(K2*Lk))
ret2 <- binom.exact(sum(samples2[!is.na(samples2)]),sum(K2*Lk))

cat ("Rdr. 1: 95% CI = ", ret1$conf.int[1:2],"\n")
```

```
## Rdr. 1: 95% CI =  0.3910217 0.5903092
```

```r
cat ("Rdr. 2: 95% CI = ", ret2$conf.int[1:2],"\n")
```

```
## Rdr. 2: 95% CI =  0.8662286 0.9725125
```


## Model re-parameterization {#rsm-re-parameterization}
While the parameters $\mu$, $\lambda'$ and $\nu'$ are physically meaningful, and can be estimated from eye-tracking measurements, a little thought reveals that they cannot be varied independently of each other. Rather, $\mu$ is an intrinsic  parameter whose value, together with two other intrinsic parameters $\lambda$ and $\nu$, determine the physically more meaningful parameters $\lambda'$ and $\nu'$, respectively. The following is a convenient re-parameterization:

\begin{equation} 
\nu' = 1 - exp\left ( - \mu \nu \right )
(\#eq:rsm-nup)
\end{equation}

\begin{equation} 
\lambda' = \frac{\lambda}{\mu}
(\#eq:rsm-lambdap)
\end{equation}

The parameterization is not unique, but is relatively simple. The need for the first re-parameterization (involving $\nu'$) was foreseen (using different notation) in the original search model TBA papers4,5 but the need for the second re-parameterization (involving $\lambda'$) was discovered more recently. Since it determines $\nu'$, the $\nu$ parameter can be considered as the intrinsic (i.e., $\mu$-independent) ability to find lesions; specifically, it is the rate of increase of $\nu'$  with $\mu$ at small $\mu$:


\begin{equation} 
\nu' = \left (\frac{\partial \nu'}{\partial \mu}  \right )_{\mu = 0}
(\#eq:rsm-nup-limit)
\end{equation}


The dependence of $\nu'$ on $\mu$ is consistent with the fact that higher contrast lesions are easier to find. Any observer, even one without special expertise, can find a high contrast lesion. This is why $\nu'$ is not an intrinsic property. Conversely, lower contrast lesions will be more difficult to find even by expert observers. The colloquial term *find* is used as shorthand for *flagged for further inspection by the holistic 1st stage of the search mechanism, thus qualifying as a latent site*. In other words, *finding* a lesion means the lesion was perceived as a suspicious region, which makes it a latent site, independent of whether or not the region was actually marked. Finding refers to the search stage. Marking refers to the decision stage, where the region's z-sample is determined and compared to a marking threshold.

According to Eqn. \@ref(eq:rsm-nup), as $\mu \rightarrow \infty$, $\nu' \rightarrow 1$, and in the opposite limit as $\mu \rightarrow 0$, $\nu' \rightarrow 0$. Recall the analogy to finding the sun made in TBA Chapter 12: objects with very high perceptual SNR are certain to be found and conversely, objects with zero perceptual SNR are found only by chance.

According to Eqn. \@ref(eq:rsm-lambdap) the value of $\mu$ also determines $\lambda'$: as $\mu \rightarrow \infty$, $\lambda' \rightarrow 0$, and conversely, as $\mu \rightarrow 0$, $\lambda' \rightarrow \infty$,. This too is clear from the sun analogy of TBA Chapter 12. Since the sun has very high contrast, there is no reason for the observer to find other suspicious regions, which have no possibility of resembling the sun. On the other hand, attempting to locate a faint star hidden by clouds is guaranteed to generate several latent NLs (because the expected small SNR from the faint real star is comparable to that from a number of regions in the background).

The re-parameterization used here is not unique, but is simple and has the right limiting behaviors.

## Discussion / Summary {#rsm-discussion-summary}
This chapter has described a statistical parameterization of the Nodine-Kundel model. The 3-parameter model of search in the context in the medical imaging accommodates key aspects of the process: search, the ability to find lesions while minimizing finding non-lesions, is described by two parameters, specifically, $\lambda'$ and $\nu'$ . The ability to correctly mark a found lesion (while not marking found non-lesions) is characterized by the third parameter of the model, $\mu$. While the primed parameters have relatively simple physical meaning, they depend on $\mu$. Consequently, it is necessary to define them in terms of intrinsic parameters. 

The next chapter explores the predictions of the radiological search model.

## References {#rsm-references}
1.	Chakraborty DP. Computer analysis of mammography phantom images (CAMPI): An application to the measurement of microcalcification image quality of directly acquired digital images. Medical Physics. 1997;24(8):1269-1277.
2.	Chakraborty DP, Eckert MP. Quantitative versus subjective evaluation of mammography accreditation phantom images. Medical Physics. 1995;22(2):133-143.
3.	Chakraborty DP, Yoon H-J, Mello-Thoms C. Application of threshold-bias independent analysis to eye-tracking and FROC data. Academic Radiology. 2012;In press.
4.	Chakraborty DP. ROC Curves predicted by a model of visual search. Phys Med Biol. 2006;51:3463–3482.
5.	Chakraborty DP. A search model and figure of merit for observer data acquired according to the free-response paradigm. Phys Med Biol. 2006;51:3449–3462.

