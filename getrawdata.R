require(plyr)
require(openxlsx)
require(tidyr)
require(dplyr)
require(Rcpp)

ClinicalFlowdata <- read.xlsx("data/Report_Flow_Cytometry-Clinical.xlsx", sheet = 1,
                              startRow = 2, colNames = TRUE, detectDates = TRUE, 
                              cols = c(1:2, 4:64), skipEmptyRows = TRUE)

ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "ND", replacement = 0, fixed = TRUE)
ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "+/-", replacement = NA, fixed = TRUE)
ClinicalFlowdata[-2] <- lapply(ClinicalFlowdata[-2], gsub, pattern = "-", replacement = "0", fixed = TRUE)
ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "+", replacement = NA, fixed = TRUE)
ClinicalFlowdata[4:63] <- lapply(ClinicalFlowdata[4:63], as.numeric)
ClinicalFlowdata <- as.data.frame(ClinicalFlowdata)
colnames(ClinicalFlowdata)[4:63] <- paste("clin.ungate", colnames(ClinicalFlowdata)[4:63], sep = ".")
ClinicalFlowdata <- filter(ClinicalFlowdata, Sample.Source == "Blood")
ClinicalFlowdata$Date <- as.Date(ClinicalFlowdata$Date)

CRCFlowdata <- read.xlsx("data/Report_Flow_Cytometry-CRC.xlsx", sheet = 1,
                              startRow = 2, colNames = TRUE, detectDates = TRUE,
                              cols = c(1,3,5:43), skipEmptyRows = TRUE)
colnames(CRCFlowdata)[3:41] <- paste("crc", colnames(CRCFlowdata)[3:41], sep = ".")
colnames(CRCFlowdata)[2] <- "Date"

ResearchFlowdata <- read.xlsx("data/Report_Flow_Cytometry-Research.xlsx", sheet = 1,
                              startRow = 2, colNames = TRUE, detectDates = TRUE,
                              cols = c(1:2, 4:40), skipEmptyRows = TRUE)

ResearchFlowdata <- lapply(ResearchFlowdata, gsub, pattern = "ND", replacement = 0, fixed = TRUE)
ResearchFlowdata[3:39] <- lapply(ResearchFlowdata[3:39], as.numeric)
ResearchFlowdata <- as.data.frame(ResearchFlowdata)
colnames(ResearchFlowdata)[3:39] <- paste("res", colnames(ResearchFlowdata)[3:39], sep = ".")
colnames(ResearchFlowdata)[2] <- "Date"
ResearchFlowdata$Date <- as.Date(ResearchFlowdata$Date)

FISHrawData <- read.xlsx("data/Report_Cytogenetics-FISH.xlsx", sheet = 1,
                      colNames = TRUE, detectDates = TRUE, skipEmptyRows = TRUE,
                      cols = c(1:2, 4:6, 9:14))

Survivaldata <- read.xlsx("data/Report_Survival.xlsx", sheet = 1, cols = 1:14,
                          colNames = TRUE, detectDates = TRUE, skipEmptyRows = TRUE)
Survivaldata$DOB <- convertToDate(Survivaldata$DOB)

VHVLdata <- read.xlsx("data/CLLDATABASE-082316.xlsx",sheet = 1, colNames = TRUE,
                      detectDates = TRUE, skipEmptyRows = TRUE,
                      col = c(1:9,11,17:21,23,26))
VHVLdata$`%.mut` <- VHVLdata$`%.mut` * 100
VHVLdata$`%mut` <- VHVLdata$`%mut` * 100
VHVLdata <- tbl_df(VHVLdata)


