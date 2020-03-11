# Choosing a realistic effect size{#SSJafrocEffectSize}



## Introduction
* The value of the true `FOM` difference between the treatments, i.e., the true effect-size (ES) is, of course, unknown. If it were known, there would be no need to conduct an ROC study. One would simply adopt the treatment with the higher `FOM`. Sample-size estimation involves making an educated guess regarding the ES, called the *anticipated* ES, and denoted by `d`. To quote [@RN1983]: "any calculation of power amounts to specification of the anticipated effect-size". Increasing the anticipated ES  will increase statistical power but may represent an unrealistic expectation of the true difference between the treatments, in the sense that it overestimates the ability of technology to achieve this much improvement. An unduly small  might be clinically insignificant, besides requiring a very large sample-size to achieve sufficient power.

* There is a key difference between *statistical* significance and *clinical* significance. An effect-size in AUC units could be so small, e.g., 0.001, as to be clinically insignificant, but by employing a sufficiently large sample size one could design a study to detect this small and clinically meaningless difference with high probability, i.e., high statistical power.

* What determines clinical significance? A small effect-size, e.g., 0.01 AUC units, could be clinically significant if it applies to a large population, where the small benefit in detection rate is amplified by the number of patients benefiting from the new treatment. In contrast, for an "orphan" disease, i.e., one with very low prevalence, an effect-size of 0.05 might not be enough to justify the additional cost of the new treatment. The improvement might have to be 0.1 before it is worth it for a new treatment to be brought to market. One hates to monetize life and death issues, but there is no getting away from it, as cost/benefit issues determine clinical significance. The arbiters of clinical significance are engineers, imaging scientists, clinicians, epidemiologists, insurance companies and those who set government health care policies. The engineers and imaging scientists determine whether the effect-size the clinicians would like is feasible from technical and scientific viewpoints. The clinician determines, based on incidence of disease and other considerations, e.g., altruistic, malpractice, cost of the new device and insurance reimbursement, what effect-size is justifiable. Cohen has suggested that d values of 0.2, 0.5, and 0.8 be considered small, medium, and large, respectively, but he has also argued against their indiscriminate usage. However, after a study is completed, clinicians often find that an effect-size that biostatisticians label as small may, in certain circumstances, be clinically significant and an effect-size that they label as large may in other circumstances be clinically insignificant. Clearly, this is a complex issue. Some suggestions on choosing a clinically significant effect size are made in **Chapter 11**.

* Does one even need to perform a pivotal study? If the pilot study returns a significant difference, one has rejected the NH and that is all there is to it. There is no need to perform the pivotal study, unless one "tweaks" the new treatment and/or casts a wider sampling net to make a stronger argument, perhaps to the FDA, that the treatments are indeed generalizable, and that the difference is in the right direction (new treatment FOM > conventional treatment FOM). If a significant difference is observed in the opposite direction (e.g., new treatment FOM < conventional treatment FOM) one cannot justify a pivotal study with an expected effect-size in the "other or favored" direction; see example below. Since the Van Dyke pilot study came close to rejecting the NH and the observed effect size, see below, is not too small, a pivotal study is justified.  

* This vignette discusses choosing a realistic effect size based on the pilot study. Illustrated first is using Van Dyke dataset, regarded as the pilot study.

## Illustration of `SsPowerGivenJK()` using `method = "ORH"`

```r
rocData <- dataset02 ##"VanDyke.lrc"
#fileName <- dataset03 ## "Franken1.lrc"
retDbm <- StSignificanceTesting(dataset = rocData, FOM = "Wilcoxon", method = "DBMH")
str(retDbm$ciDiffTrtRRRC)
#> 'data.frame':	1 obs. of  8 variables:
#>  $ TrtDiff : chr "Trt0-Trt1"
#>  $ Estimate: num -0.0438
#>  $ StdErr  : num 0.0207
#>  $ DF      : num 15.3
#>  $ t       : num -2.11
#>  $ PrGTt   : num 0.0517
#>  $ CILower : num -0.088
#>  $ CIUpper : num 0.000359
```

* Lacking any other information, the observed effect-size is the best estimate of the effect-size to be anticipated. The output shows that the FOM difference, for treatment 0 minus treatment 1, is -0.0438003. In the actual study treatment `1` is the new modality which hopes to improve upon `0`, the conventional modality. Since the sign is negative, the difference is going the right way and is justified in moving forward with planning a pivotal study. [If the difference went the other way, there is little justification for a pivotal study]. 

* The standard error of the difference is 0.0207486.

* An optimistic, but not unduly so, effect size is given by: 


```r
effectSizeOpt <- abs(retDbm$ciDiffTrtRRRC$Estimate) + 2*retDbm$ciDiffTrtRRRC$StdErr
```

* The observed effect-size is a realization of a random variable. The lower limit of the 95% confidence interval is given by -0.0879595 and the upper limit by 3.5885444\times 10^{-4}. CI's generated like this, with independent sets of data, are expected to encompass the true value with 95% probability. The lower end (greatest magnitude of the difference) of the confidence interval is -0.0852976, and this is the optimistic estimate. Since the sign is immaterial, one uses as the optimistic estimate the value 0.0852976. 

* **While the sign is immaterial for sample size estimates, the decision to conduct the pivotal most certainly is material. If the sign went the other way, with the new modality lower than the conventional modality, one would be unjustified in conducting a pivotal study.**  

## References


