# Download files
uciURL="http://archive.ics.uci.edu/ml/machine-learning-databases/"
wineDir="wine-quality/"
baseURL=$(uciURL)$(wineDir)
redWine="winequality-red.csv"
whiteWine="winequality-white.csv"
descriptWine="winequality.names"

# Setup New Directories
rawData="raw-data"
rawDir="./raw-data/"

.PHONY : all clean download

all : download

# Download data
download :
	mkdir -p $(rawData)
	curl -o $(rawDir)$(redWine) $(baseURL)$(redWine)
	curl -o $(rawDir)$(whiteWine) $(baseURL)$(whiteWine)
	curl -o $(rawDir)$(descriptWine) $(baseURL)$(descriptWine)

clean :
	rm ./raw-data/*
	rmdir raw-data
