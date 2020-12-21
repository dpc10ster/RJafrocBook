effectiveAB <- function(mu, lambda, nu, lesionDistribution){
  lambdaP <- lambda / mu
  if (abs(nu * mu) <= 1e-6 ) nuP <- 1e-6 else nuP <- (1-exp(-nu * mu))
  
  FPFmax <- xROC(-Inf, lambdaP)
  meanN <- integrate(meanNInt, -Inf, Inf, lambdaP = lambdaP, FPFmax = FPFmax)$value
  varN <- integrate(varNInt, -Inf, Inf, lambdaP = lambdaP, FPFmax = FPFmax)$value - meanN^2 # https://en.wikipedia.org/wiki/Variance
  stdErrN <- sqrt(varN)
  
  TPFmax <- yROC(-Inf, mu, lambdaP, nuP, lesionDistribution)
  meanD <- integrate(meanDInt, -Inf, Inf, mu = mu, lambdaP = lambdaP, nuP = nuP, lesionDistribution = lesionDistribution, TPFmax = TPFmax)$value
  varD <- integrate(varDInt, -Inf, Inf, mu = mu, lambdaP = lambdaP, nuP = nuP, lesionDistribution = lesionDistribution, TPFmax = TPFmax)$value - meanD^2 # https://en.wikipedia.org/wiki/Variance
  stdErrD <- sqrt(varD)
  
  return(list(
    a = (meanD - meanN) / stdErrD,
    b = stdErrN / stdErrD
  ))
}

pdfN <- function(z, lambdaP){
  # verified using pdfN(1, 1) and (xROC(1, 1) - xROC(1 + 1e-8, 1)) / 1e-8
  # following expression is identical to book equation 17.21
  return(lambdaP * exp(-z^2/2) * exp(-lambdaP/2 * (1 - erf(z/sqrt(2)))) / sqrt(2 * pi))
}

meanNInt <- function(z, lambdaP, FPFmax){
  # divide by FPFmax to normalize integral to unity
  # multiply by z as we want average of z using
  # the prescribed normalized pdf
  return(pdfN(z, lambdaP) / FPFmax * z)
}

varNInt <- function(z, lambdaP, FPFmax){
  # divide by FPFmax to normalize integral to unity
  # multiply by z^2 as we want average of z^2 using
  # the prescribed normalized pdf
  return(pdfN(z, lambdaP) / FPFmax * z^2)
}


# A is first term on rhs of book 17.22
A <- function(mu,nu,z,L) 
{
  return((1-0.5*nu+0.5*nu*erf((0.5*(z-mu))*sqrt(2)))^L)
}

# B is second term on rhs of book 17.22
B <- function(lambda,z) 
{
  return(exp(-0.5*lambda+0.5*lambda*erf(0.5*z*sqrt(2))))
}


#dA is deriv. of A wrt z, Maple generated
dA <- function(mu,nu,z,L)
{
  return((1-(1/2)*nu+(1/2)*nu*erf((1/2*(z-mu))*sqrt(2)))^(L-1)*L*nu*exp(-(1/2)*(z-mu)^2)/(sqrt(2*pi)))
}


#dB is deriv. of B wrt z, Maple generated
dB <- function(lambda,z)
{
  return((1/2)*lambda*exp(-(1/2)*z^2)*sqrt(2)*exp(-(1/2)*lambda+(1/2)*lambda*erf((1/2)*z*sqrt(2)))/sqrt(pi))
}

# replaced this with pdfD below on 12/21/20
pdfD <- function(z, mu, lambdaP, nuP, lesionDistribution){
  # verified using pdfD(1, 1, 1, 0.5, rbind(c(1, 50), c(2, 50))) and 
  # (yROC(1, 1, 1, 0.5, rbind(c(1, 50), c(2, 50))) - yROC(1 + 1e-8, 1, 1, 0.5, rbind(c(1, 50), c(2, 50)))) / 1e-8
  # But where does following expression come from?
  fl <- lesionDistribution[, 2] / sum(lesionDistribution[, 2])
  pdfTemp <- 0
  for (L in 1:nrow(lesionDistribution)){
    pdfTemp <- pdfTemp + 
      fl[L] * (((1 - nuP/2 + nuP/2  *erf( (z - mu) / sqrt(2) ))^(lesionDistribution[L, 1] - 1) * exp( (-lambdaP / 2) + 0.5 * lambdaP * erf(z / sqrt(2)))) * (lesionDistribution[L, 1] * nuP/sqrt(2 * pi) * exp(-(z - mu)^2/2) + (1 - nuP/2 + nuP/2  *erf( (z - mu) / sqrt(2) )) * lambdaP/sqrt(2*pi) * exp(-z^2/2)))
  }
  return (pdfTemp)
}


# added 12/21/20
# using Maple generated derivatives wrt z
# but this does not pass the test
pdfD1 <- function(z, mu, lambdaP, nuP, lesionDistribution){
  # NOT verified using pdfD1(1, 1, 1, 0.5, rbind(c(1, 50), c(2, 50))) and 
  # (yROC(1, 1, 1, 0.5, rbind(c(1, 50), c(2, 50))) - yROC(1 + 1e-8, 1, 1, 0.5, rbind(c(1, 50), c(2, 50)))) / 1e-8
  fl <- lesionDistribution[, 2] / sum(lesionDistribution[, 2])
  pdfTemp <- 0
  for (L in 1:nrow(lesionDistribution)){
    # AB is the two terms in book 17.22
    # dA is deriv. of A wrt z
    # dB is deriv. of B wrt z
    pdfTemp <- pdfTemp + fl[L] * dA(mu,nuP,z,L) * B(lambdaP,z) + A(mu,nuP,z,L) * dB(lambdaP,z) 
  }
  return (pdfTemp)
}

meanDInt <- function(z, mu, lambdaP, nuP, lesionDistribution, TPFmax){
  # divide by TPFmax to normalize integral to unity
  # multiply by z as we want average of z using
  # the prescribed normalized pdf
  return(pdfD(z, mu, lambdaP, nuP, lesionDistribution) / TPFmax * z)
}

varDInt <- function(z, mu, lambdaP, nuP, lesionDistribution, TPFmax){
  # divide by TPFmax to normalize integral to unity
  # multiply by z^2 as we want average of z^2 using
  # the prescribed normalized pdf
  return(pdfD(z, mu, lambdaP, nuP, lesionDistribution) / TPFmax * z^2)
}
