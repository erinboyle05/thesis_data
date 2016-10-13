#This script downloads and prepares the necessary data files.
#If any of the files or datasets exist, that portion of script will not run. 

if (!file.exists("NEI_data.zip")) {
        
        file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(file_url, "NEI_data.zip", mode = "wb")
        unzip("NEI_data.zip")
}
if (!exists("NEI")) {
        NEI <- readRDS("summarySCC_PM25.rds")
        
}

if (!exists("SCC")) {
        SCC <- readRDS("Source_Classification_Code.rds")
}