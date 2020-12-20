erf <- function(x){
  return (2 * pnorm(sqrt(2) * x) - 1)
}

xROC <- function(zeta, lambdaP){
  # returns FPF, the abscissa of ROC curve
  return( 1 - exp( (-lambdaP / 2) + 0.5 * lambdaP * erf(zeta / sqrt(2))))
}

yROC <- function(zeta, mu, lambdaP, nuP, lesionDistribution){
  # returns TPF, the ordinate of ROC curve
  fl <- lesionDistribution[, 2] / sum(lesionDistribution[, 2])
  TPF <- 0
  for (i in 1:nrow(lesionDistribution)){
    TPF <- TPF + fl[i] * (1 - (1 - nuP/2 + nuP/2  *erf( (zeta - mu) / sqrt(2) ))^lesionDistribution[i, 1] * exp( (-lambdaP / 2) + 0.5 * lambdaP * erf(zeta / sqrt(2))))
  }
  return (TPF)
}

intROC <- function(FPF, mu, lambdaP, nuP, lesionDistribution){
  # returns TPF, the ordinate of ROC curve; takes FPF as the variable.
  # AUC is calculated by integrating this function in terms of FPF
  tmp <- 1 / lambdaP * log(1 - FPF) + 1
  tmp[tmp < 0] <- pnorm(-20)
  zeta <- qnorm(tmp)
  TPF <- yROC(zeta, mu, lambdaP, nuP, lesionDistribution)
  return (TPF)
}

yFROC <- function(zeta, mu, nuP){
  # returns LLF, the ordinate of FROC, AFROC curve
  LLF <- nuP * (1 - pnorm(zeta - mu))
  return(LLF)
}

# intAFROC <- function(FPF, mu, lambdaP, nuP){
#   # returns LLF, the ordinate of AFROC curve; takes FPF as the variable. 
#   # AUC is calculated by integrating this function wrt FPF
#   tmp <- 1 / lambdaP * log(1 - FPF) + 1
#   tmp[tmp < 0] <- pnorm(-20)
#   zeta <- qnorm(tmp)
#   LLF <- yFROC(zeta, mu, nuP)
#   return(LLF)
# }