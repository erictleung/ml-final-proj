require(rpart)
if (!exists("splitdf", mode = "function")) source("splitdf.R")

#' Calculate Winner Class in Decision Tree
#'
#' @param pred
#' @param data
#' @param response
#'
#' @return prediction data frame with prediction probabilities
#'
#' @examples
find_dt_winner <- function(pred, data, response) {
    classes <- colnames(pred)
    if (length(classes) > 2) {
        winner <- apply(pred, 1,
                        function(x) which(x == max(x, na.rm = TRUE)))
        pred <- cbind(pred, prediction = classes[winner])
        original <- apply(data[, response], 1, function(x) {
            paste("X", x, sep = "")
        })
        pred <- cbind(pred, original)
        pred[["prediction"]] <- as.character(pred[["prediction"]])
        pred[["original"]] <- as.character(pred[["original"]])
    } else {
        winner <- apply(pred, 1,
                        function(x) which(x == max(x, na.rm = TRUE)))
        pred <- cbind(pred, prediction = classes[winner])
        pred <- cbind(pred, original = data.frame(data[, response]))
        colnames(pred) <- c(classes, "prediction", "original")
    }
    pred <- cbind(pred, result = pred[, "prediction"] == pred[, "original"])
    pred
}

#' Perform Decision Tree Analysis
#'
#' @param data
#' @param response
#'
#' @return list of fitted tree, test data, training data, and predictions
#'
#' @examples
run_decision_tree_type <- function(data, response, method) {
    # Split data to training and test data
    splits <- splitdf(dataframe = data, trainSplit = 0.75, seed = 1111)

    # Set up analysis
    training <- splits$trainset
    test <- splits$testset
    form <- paste(response, ".", sep = " ~ ")

    # Run decision tree
    fit <- rpart(formula = form, data = training, method = method)

    # Format results
    trainPred <- data.frame(predict(fit, training))
    testPred <- data.frame(predict(fit, test))

    # Find winner of prediction
    trainPred <- find_dt_winner(trainPred, training, response)
    testPred <- find_dt_winner(testPred, test, response)

    # Find training and test errors
    trainErr <- 1 - mean(trainPred$result)
    testErr <- 1 - mean(testPred$result)

    list(fitted = fit, test = test, train = training,
         trainPred = trainPred, testPred = testPred,
         trainErr = trainErr, testErr = testErr)
}