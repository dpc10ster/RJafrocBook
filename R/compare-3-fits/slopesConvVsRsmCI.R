slopesConvVsRsmCI <- function(datasetNames) {
  
  path <- "R/compare-3-fits/"
  
  avgAucPro <- array(dim = length(datasetNames))
  avgAucRsm <- avgAucPro;avgAucCbm <- avgAucPro;slopeProRsm <- avgAucPro 
  avgR2ProRsm <- avgAucPro;slopeCbmRsm <- avgAucPro ;avgR2CbmRsm <- avgAucPro 
  rhoMuRsmMuCbm <- avgAucPro;rhoNupRsmAlphaCbm <- avgAucPro
  
  clParms <- NULL # parameters passed to cluster
  for (f in 1:length(datasetNames)){
    retFileName <- paste0("R/compare-3-fits/RSM6/", "allResults", datasetNames[f])
    if (file.exists(retFileName)){
      load(retFileName)
      # following allows elimination of the Datasets directory TBA
      #theData <- get(sprintf("dataset%02d", f)) # the datasets already exist as R objects
      theData <- loadDataFile(path = path, datasetNames[f])
      I <- length(theData$descriptions$modalityID)
      J <- length(theData$descriptions$readerID)
      aucRsm <- array(dim = c(I, J));aucCbm <- array(dim = c(I, J));aucPro <- array(dim = c(I, J))
      muRsm <- array(dim = c(I, J));muCbm <- array(dim = c(I, J))
      nupRsm <- array(dim = c(I, J));alphaCbm <- array(dim = c(I, J))
      s <- 1
      for (i in 1:I){
        for (j in 1:J){
          aucRsm[i, j] <- allResults[[s]]$retRsm$AUC
          aucPro[i, j] <- allResults[[s]]$aucProp
          aucCbm[i, j] <- allResults[[s]]$retCbm$AUC
          muRsm[i, j] <- allResults[[s]]$retRsm$mu
          nupRsm[i, j] <- allResults[[s]]$retRsm$nuP
          muCbm[i, j] <- allResults[[s]]$retCbm$mu
          alphaCbm[i, j] <- allResults[[s]]$retCbm$alpha
          s <- s + 1
        }
      }
      
      avgAucRsm[f] <- mean(aucRsm);avgAucPro[f] <- mean(aucPro);avgAucCbm[f] <- mean(aucCbm)
      rhoMuRsmMuCbm[f] <- cor(as.vector(muRsm), as.vector(muCbm),method = "pearson")
      rhoNupRsmAlphaCbm[f]<- cor(as.vector(nupRsm), as.vector(alphaCbm),method = "pearson")

      df <- data.frame(aucRsm = as.vector(aucRsm), aucPro = as.vector(aucPro))
      m <- lm(aucPro ~ 0 + aucRsm, data = df)
      slopeProRsm[f] <- coef(m)
      avgR2ProRsm[f] <- summary(m)$r.squared
      
      df <- data.frame(aucRsm = as.vector(aucRsm), aucCbm = as.vector(aucCbm))
      m <- lm(aucCbm ~ 0 + aucRsm, data = df)
      slopeCbmRsm[f] <- coef(m)
      avgR2CbmRsm[f] <- summary(m)$r.squared
      
      clParms <- c(clParms, list(list(aucRsm = aucRsm, aucCbm = aucCbm, aucPro = aucPro, 
                                      nupRsm = nupRsm, alphaCbm = alphaCbm,
                                      muRsm = muRsm, muCbm = muCbm)))
    }else{
      stop("Results file does not exist. Must analyze all datasets before running this.")
    }
  }

  # bootstrap cluster code follows 
  names(clParms) <- datasetNames
  cl <- makeCluster(detectCores())
  registerDoParallel(cl)
  B <- 200
  seed <- 1 # don't use NULL as then results keep changing
  bootStrapResults <- foreach (b = 1:B, .options.RNG = seed, .combine = "rbind", .packages = "RJafroc") %dorng% {
    slopeCbmRsm <- rep(NA, length(datasetNames));avgR2CbmRsm <- slopeCbmRsm
    slopeProRsm <- slopeCbmRsm;avgR2ProRsm <- slopeCbmRsm
    rhoMuRsmMuCbm <- rep(NA, length(datasetNames));rhoNupRsmAlphaCbm <- rep(NA, length(datasetNames))
    aucRsm <- array(dim = c(length(datasetNames)))
    aucPro <- aucRsm
    aucCbm <- aucRsm
    for (f in 1:length(datasetNames)){
      retFileName <- paste0("R/compare-3-fits/RSM6/", "allResults", datasetNames[f])
      if (file.exists(retFileName)){
        I <- length(clParms[[datasetNames[f]]]$aucRsm[,1])
        J <- length(clParms[[datasetNames[f]]]$aucRsm[1,])
        AucRsm <- array(dim = c(I,J,length(datasetNames)));AucPro <- AucRsm;AucCbm <- AucRsm
        
        jBs <- ceiling(runif(J) * J) # here is were we bootstrap readers
        
        AucRsm[,,f]  <-  clParms[[datasetNames[f]]]$aucRsm[ , jBs]
        AucPro[,,f]  <-  clParms[[datasetNames[f]]]$aucPro[ , jBs]
        AucCbm[,,f]  <-  clParms[[datasetNames[f]]]$aucCbm[ , jBs]
        
        aucRsm[f] <- mean(AucRsm[,,f]);aucPro[f] <- mean(AucPro[,,f]);aucCbm[f] <- mean(AucCbm[,,f])
        
        # constrained fit thru origin; aucPro vs. aucRsm 
        df1 <- data.frame(aucRsm = as.vector(clParms[[datasetNames[f]]]$aucRsm[ , jBs]), 
                          aucPro = as.vector(clParms[[datasetNames[f]]]$aucPro[, jBs]))
        m <- lm(aucPro ~ 0 + aucRsm, data = df1)
        slopeProRsm[f] <- coef(m);avgR2ProRsm[f] <- summary(m)$r.squared
        
        # constrained fit thru origin; aucCbm vs. aucRsm 
        df2 <- data.frame(aucRsm = as.vector(clParms[[datasetNames[f]]]$aucRsm[ , jBs]), 
                          aucCbm = as.vector(clParms[[datasetNames[f]]]$aucCbm[, jBs]))
        m <- lm(aucCbm ~ 0 + aucRsm, data = df2)
        slopeCbmRsm[f] <- coef(m);avgR2CbmRsm[f] <- summary(m)$r.squared
        
        # correlation between muRsm and muCbm
        df1 <- data.frame(muRsm = as.vector(clParms[[datasetNames[f]]]$muRsm[ , jBs]), 
                          muCbm = as.vector(clParms[[datasetNames[f]]]$muCbm[, jBs]))
        rhoMuRsmMuCbm[f] <- cor(df1$muRsm, df1$muCbm,method = "pearson")
        
        # correlation between nupRsm and alphaCbm
        df2 <- data.frame(nupRsm = as.vector(clParms[[datasetNames[f]]]$nupRsm[ , jBs]), 
                          alphaCbm = as.vector(clParms[[datasetNames[f]]]$alphaCbm[, jBs]))
        rhoNupRsmAlphaCbm[f] <- cor(df2$nupRsm, df2$alphaCbm,method = "pearson")
        
      }else{
        stop("Results file does not exist.")
      }
    }
    # following is return of bootstrap code, for each value of b
    # average is over 14 datasets
    c(mean(slopeProRsm), mean(avgR2ProRsm), 
      mean(slopeCbmRsm), mean(avgR2CbmRsm), 
      mean(rhoMuRsmMuCbm), mean(rhoNupRsmAlphaCbm),
      mean(aucRsm), mean(aucPro), mean(aucCbm))
  }
  stopCluster(cl)
  
  slopeProRsm <- data.frame(value = bootStrapResults[ , 1])
  avgR2ProRsm <- data.frame(value = bootStrapResults[ , 2])
  slopeCbmRsm <- data.frame(value = bootStrapResults[ , 3])
  avgR2CbmRsm <- data.frame(value = bootStrapResults[ , 4])
  rhoMuRsmMuCbm <- data.frame(value = bootStrapResults[ , 5])
  rhoNupRsmAlphaCbm <- data.frame(value = bootStrapResults[ , 6])
  aucRsm <- data.frame(value = bootStrapResults[ , 7])
  aucPro <- data.frame(value = bootStrapResults[ , 8])
  aucCbm <- data.frame(value = bootStrapResults[ , 9])
  
  ciAvgAucRsm <- quantile(aucRsm$value, c(0.025, 0.975), type = 1)
  # cat("The empirical 95% CI of avgAucRsm is", paste(ciAvgAucRsm, collapse = ", "), "\n")
  
  ciAvgAucPro <- quantile(aucPro$value, c(0.025, 0.975), type = 1)
  # cat("The empirical 95% CI of avgAucPro is", paste(ciAvgAucPro, collapse = ", "), "\n")
  
  ciAvgAucCbm <- quantile(aucCbm$value, c(0.025, 0.975), type = 1)
  # cat("The empirical 95% CI of avgAucCbm is", paste(ciAvgAucCbm, collapse = ", "), "\n")
  
  histSlopeProRsm <- ggplot(slopeProRsm, aes(x = value)) + 
    geom_histogram(color = "white", binwidth = (max(slopeProRsm$value) - min(slopeProRsm$value))/30) +
    xlab("slopeProRsm")
  #print(histSlopeProRsm)
  cislopeProRsm <- quantile(slopeProRsm$value, c(0.025, 0.975), type = 1)
  # cat("The empirical 95% CI of slopeProRsm is", paste(cislopeProRsm, collapse = ", "), "\n")
  
  histSlopeCbmRsm <- ggplot(slopeCbmRsm, aes(x = value)) + 
    geom_histogram(color = "white", binwidth = (max(slopeCbmRsm$value) - min(slopeCbmRsm$value))/30) +
    xlab("slopeCbmRsm")
  #print(histSlopeCbmRsm)
  cislopeCbmRsm <- quantile(slopeCbmRsm$value, c(0.025, 0.975), type = 1)
  # cat("The empirical 95% CI of slopeCbmRsm is", paste(cislopeCbmRsm, collapse = ", "), "\n")
  
  # h3 <- ggplot(rhoMuRsmMuCbm, aes(x = value)) + geom_histogram(color = "white") +
  #   xlab("rhoMuRsmMuCbm")
  # print(h3)
  # ciRhoMuRsmMuCbm <- quantile(rhoMuRsmMuCbm$value, c(0.025, 0.975), type = 1)
  # cat("The empirical 95% CI of rhoMuRsmMuCbm is", paste(ciRhoMuRsmMuCbm, collapse = ", "), "\n")
  # 
  # h4 <- ggplot(rhoNupRsmAlphaCbm, aes(x = value)) + geom_histogram(color = "white", binwidth = 0.003) +
  #   xlab("rhoNupRsmAlphaCbm")
  # print(h4)
  # ciRhoNupRsmAlphaCbm <- quantile(rhoNupRsmAlphaCbm$value, c(0.025, 0.975), type = 1, na.rm = TRUE)
  # cat("The empirical 95% CI of rhoNupRsmAlphaCbm is", paste(ciRhoNupRsmAlphaCbm, collapse = ", "), "\n")
  
  return(list(
    ciAvgAucRsm = ciAvgAucRsm,
    ciAvgAucPro = ciAvgAucPro,
    ciAvgAucCbm = ciAvgAucCbm,
    histSlopeProRsm = histSlopeProRsm,
    histSlopeCbmRsm = histSlopeCbmRsm,
    cislopeProRsm = cislopeProRsm,
    cislopeCbmRsm = cislopeCbmRsm
  ))
}