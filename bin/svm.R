require(e1071)
if (!exists("splitdf", mode = "function")) source("splitdf.R")

#' Calculate Winner Class in Decision Tree
#'
#' @param pred
#' @param data
#' @param response
#'
#' @return
#'
#' @examples
find_svm_winner <- function(pred, data, response) {
    pred <- cbind(pred, original = data[, response])
    pred <- cbind(pred, result = pred[, "original"] == pred[, 1])
    names(pred) <- c("prediction", "original", "results")
    pred
}

run_svm_type <- function(data, response) {
    data <- as.data.frame(data)
    data[, response] <- as.factor(data[, response])

    # Split data to training and test data
    splits <- splitdf(dataframe = data, trainSplit = 0.75, seed = 1111)

    # Set up analysis
    training <- splits$trainset
    test <- splits$testset
    form <- as.formula(paste(response, ".", sep = " ~ "))

    # Run decision tree
    fit <- svm(form, data = training, kernel = "linear")

    # Format results
    trainPred <- data.frame(predict(fit, training))
    testPred <- data.frame(predict(fit, test))

    # Find winner of prediction
    trainPred <- find_svm_winner(trainPred, training, response)
    testPred <- find_svm_winner(testPred, test, response)

    # Find training and test errors
    trainErr <- 1 - mean(trainPred$result)
    testErr <- 1 - mean(testPred$result)

    list(fitted = fit, test = test, train = training,
         trainPred = trainPred, testPred = testPred,
         trainErr = trainErr, testErr = testErr)
}