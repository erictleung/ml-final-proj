# CS559/659 Machine Learning Final Project

Here is my machine learning project on using various methods to predict wine
quality and wine type based on physiochemical measurements.


## Prerequisites

- cURL
- make
- [R][r] (>= 3.2.3)
    - [rpart][rpart] (>= 4.1-10)
    - [rmarkdown][rmd] (>= 0.9.6)
    - [knitr][knitr] (>= 1.13)
    - [e1071][e1071] (>= 1.6-7)

[r]: https://www.r-project.org/
[rpart]: https://cran.r-project.org/web/packages/rpart/index.html
[rmd]: https://cran.r-project.org/web/packages/rmarkdown/index.html
[knitr]: https://cran.r-project.org/web/packages/knitr/index.html
[e1071]: https://cran.r-project.org/web/packages/e1071/index.html


## Run Analysis and Create Report

```shell
git clone https://github.com/erictleung/ml-final-proj.git
make report
```


## Data

The data comes from the [University of California Irvine Machine Learning
Repository][uci] and can be found at the [Wine Quality Data Set][wine].

The data has two datasets: one related to red wine, another is for white wine.
Each type of wine is from Portugal.

The data includes eleven input variables (such as citric acid content and pH)
and there is one output variable on quality, which is on a scale between zero
and ten.

[uci]: http://archive.ics.uci.edu/ml/index.html
[wine]: http://archive.ics.uci.edu/ml/datasets/Wine+Quality


## Questions Asked

- Putting the data together, can we distinguish between white and red wine?
- Can we predict perceived wine quality based on the input variables?
- Are there any variables that contain redundant information? (In other words,
  are there any correlative variables?)
- What variables are most important in predicting perceived wine quality?


## Repository Structure

```
.
├── Makefile
├── README.md
├── bin
│   ├── decision-trees.R
│   ├── naive-bayes.R
│   ├── splitdf.R
│   └── svm.R
└── report
    ├── leung-final-report.Rmd
    └── refs.bib

2 directories, 8 files
```
