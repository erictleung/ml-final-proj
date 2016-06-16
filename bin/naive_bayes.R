require(cvTools)

calc_params <- function(train, res) {
    means <- colMeans(train)
    std <- apply(X = train, MARGIN = 2, FUN = sd)

    list(means=means, std=std)
}

naive_train <- function(input, res) {
    paramsList <- list()
    for (i in unique(res)) {
        subdata <- input[res == i, ]  # grab particular class in data
        paramsList[[i]] <- calc_params(subdata, i)
    }
    paramsList
}

naive_test <- function(test, res, params) {
    results <- matrix(0, nrow = nrow(test), ncol = 3)  # actual, pred, yes/no
    results <- data.frame(results)
    for (i in 1:nrow(test)) {
        classProbs <- matrix(0, nrow = length(params))
        for (j in 1:length(params)) {
            tempMean <- params[[j]][["means"]]
            tempStd <- params[[j]][["std"]]
            tempProbs <- mapply(dnorm, test[i, ], tempMean, tempStd)
            classProbs[j, ] <- prod(tempProbs)
        }
        total <- sum(classProbs)
        classProbs <- classProbs / total
        chooseParams <- names(params)
        maxVal <- max(classProbs)

        results[i, 1] <- res[i]
        results[i, 2] <- chooseParams[which(classProbs %in% maxVal)]
        results[i, 3] <- results[i, 1] == results[i, 2]
    }
    results
}

cv_bayes <- function(data, res, kfold) {
    folds <- cvFolds(nrow(data), K = kfold, type = "random")
    folds
}