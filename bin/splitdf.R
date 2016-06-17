# Source:
# http://www.gettinggeneticsdone.com/2011/02/split-data-frame-into-testing-and.html
splitdf <- function(dataframe, trainSplit, seed=NULL) {
    if (!is.null(seed)) set.seed(seed)
    index <- 1:nrow(dataframe)
    trainindex <- sample(index, trunc(length(index)*trainSplit))
    trainset <- dataframe[trainindex, ]
    testset <- dataframe[-trainindex, ]
    list(trainset = trainset,testset = testset)
}