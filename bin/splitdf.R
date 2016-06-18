#' Split Data Frame to Training and Test Set
#'
#' @param dataframe
#' @param trainSplit
#' @param seed
#'
#' @return
#' @references http://www.gettinggeneticsdone.com/2011/02/split-data-frame-into-testing-and.html
#'
#' @examples
splitdf <- function(dataframe, trainSplit, seed=NULL) {
    if (!is.null(seed)) set.seed(seed)
    index <- 1:nrow(dataframe)
    trainindex <- sample(index, trunc(length(index)*trainSplit))
    trainset <- dataframe[trainindex, ]
    testset <- dataframe[-trainindex, ]
    list(trainset = trainset,testset = testset)
}