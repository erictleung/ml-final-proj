require(rpart)
if (!exists("splitdf", mode = "function")) source("splitdf.R")

run_decision_tree <- function(data, response) {
    splits <- splitdf(dataframe = data, trainSplit = 0.75, seed = 1111)
    training <- splits$trainset
    test <- splits$testset
    form <- paste(response, ".", sep = " ~ ")
    fit <- rpart(formula = form, data = training, method = "class")
    pred <- predict(fit, test)
    list(fitted = fit, test = test, train = training, pred = pred)
}