require(cvTools)
if (!exists("splitdf", mode = "function")) source("splitdf.R")

#' Calculate Parameters for Naive Bayes
#'
#' @param train a data.frame with only numerical values
#' @param res a column vector of response variables corresponding to the train
#'
#' @return list
#'
#' @examples
#' setosa <- subset(iris, Species == "setosa")
#' train <- setosa[, !names(setosa) %in% "Species"]
#' res <- setosa[, "Species"]
#' params <- calc_params(train, res)
calc_params <- function(train, res) {
    means <- colMeans(train)
    std <- apply(X = train, MARGIN = 2, FUN = sd)

    list(means = means, std = std)
}

#' Train Naive Bayes
#'
#' @param input a data.frame with only numerical values and without response
#' @param res a column vector of response variables corresponding to the train
#'
#' @return list of parameters
#'
#' @examples
#' train <- iris[, !names(iris) %in% "Species"]
#' res <- iris[, "Species"]
#' naive_train(train, res)
naive_train <- function(input, res) {
    paramsList <- list()
    for (i in unique(res)) {
        subdata <- input[res == i, ]  # grab particular class in data
        paramsList[[i]] <- calc_params(subdata, i)
    }
    paramsList
}

#' Run Naive Bayes to Test Prediction
#'
#' @param test data.frame with only numerical values and without response
#' @param res a column vector of response variables corresponding to the train
#' @param params parameters calculated using `naive_train()`
#'
#' @return list with predictions and error
#'
#' @examples
#' train <- iris[, !names(iris) %in% "Species"]
#' res <- iris[, "Species"]
#' paramsList <- naive_train(train, res)
#' prediction <- naive_test(train, res, paramsList)
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
        total <- sum(classProbs)  # get normalizing total
        classProbs <- classProbs / total  # normalize over total
        chooseParams <- names(params)
        maxVal <- max(classProbs)  # find out which class value won

        results[i, 1] <- as.character(res[i])  # save actual class
        results[i, 2] <- chooseParams[which(classProbs %in% maxVal)]  # winner
        results[i, 3] <- results[i, 1] == results[i, 2]  # correct or not
    }
    error <- 1 - mean(results$results[, 3])  # find error of prediction
    list(results = results, error = error)
}

#' Perform Cross-Validation Naive Bayes
#'
#' Default is 5-fold cross-validation if no input on what k-fold
#' cross-validation is wanted
#'
#' @param data data.frame of numerical data without response variables
#' @param res a column vector of responses corresponding to input data
#' @param kfold number of k-fold cross-validation
#'
#' @return cross-validation error
#'
#' @examples
#' train <- iris[, !names(iris) %in% "Species"]
#' res <- iris[, "Species"]
#' cvErr <- cv_bayes(train, res, kfold = 10)
cv_bayes <- function(data, res, kfold = 5) {
    if (kfold > nrow(data)) kfold <- nrow(data)  # at most do leave-one-out
    folds <- cvFolds(nrow(data), K = kfold, type = "random")
    groups <- folds$which  # save group numbers for later use
    results <- c()  # save cross-validation here
    for (i in 1:unique(groups)) {
        tempTrain <- data[groups == i, ]
        tempTrainRes <- res[groups == i, ]
        tempCv <- data[groups != i, ]
        tempCvRes <- res[groups != i, ]

        tempParams <- naive_train(input = tempTrain, res = tempTrainRes)
        tempResults <- naive_test(test = tempCv,
                              res = tempCvRes,
                              params = tempParams)
        results <- c(results, tempResults$error)
    }
    mean(results)
}

run_naive_bayes <- function(data, response) {
    splits <- splitdf(dataframe = data, trainSplit = 0.75, seed = 1111)
    training <- splits$trainset
    trainDat <- training[, !names(training) == response]
    trainRes <- training[, response]
    test <- splits$testset
    testDat <- test[, !names(test) == response]
    testRes <- test[, response]
    predResults <- cv_bayes(data = trainDat, res = trainRes, kfold = 10)
    trainParams <- naive_train(input = trainDat, res = trainRes)
    testResults <- naive_test(test = testDat, res = testRes, trainParams)
    list(prediction=predResults, test=testResults)
}