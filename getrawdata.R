require(plyr)
require(openxlsx)
require(tidyr)
require(dplyr)

ClinicalFlowdata <- read.xlsx("data/Report_Flow_Cytometry-Clinical.xlsx", sheet = 1,
                              startRow = 2, colNames = TRUE, detectDates = TRUE, 
                              cols = c(1:2, 4:64), skipEmptyRows = TRUE)

ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "ND", replacement = 0, fixed = TRUE)
ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "+/-", replacement = NA, fixed = TRUE)
ClinicalFlowdata[-2] <- lapply(ClinicalFlowdata[-2], gsub, pattern = "-", replacement = "0", fixed = TRUE)
ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "+", replacement = NA, fixed = TRUE)
ClinicalFlowdata[4:63] <- lapply(ClinicalFlowdata[4:63], as.numeric)
ClinicalFlowdata <- as.data.frame(ClinicalFlowdata)


CRCFlowdata <- read.xlsx("data/Report_Flow_Cytometry-CRC.xlsx", sheet = 1,
                              startRow = 2, colNames = TRUE, detectDates = TRUE,
                              cols = c(1,3,5:43), skipEmptyRows = TRUE)


ResearchFlowdata <- read.xlsx("data/Report_Flow_Cytometry-Research.xlsx", sheet = 1,
                              startRow = 2, colNames = TRUE, detectDates = TRUE,
                              cols = c(1:2, 4:40), skipEmptyRows = TRUE)

ResearchFlowdata <- lapply(ResearchFlowdata, gsub, pattern = "ND", replacement = 0, fixed = TRUE)
ResearchFlowdata[3:39] <- lapply(ResearchFlowdata[3:39], as.numeric)
ResearchFlowData <- as.data.frame(ResearchFlowdata)


FISHrawData <- read.xlsx("data/Report_Cytogenetics-FISH.xlsx", sheet = 1,
                      colNames = TRUE, detectDates = TRUE, skipEmptyRows = TRUE)
