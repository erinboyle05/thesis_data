# Load required packages -----

library(pacman)
pacman::p_load(plyr, openxlsx, tidyr, dplyr, Rcpp, ggplot2, lubridate, reshape2)

# Get and format data -----

## Clinical flow data =====

# ClinicalFlowdata <- read.xlsx("data/Report_Flow_Cytometry-Clinical.xlsx", sheet = 1,
#                               startRow = 2, colNames = TRUE, detectDates = TRUE, 
#                               cols = c(1:2, 4:64), skipEmptyRows = TRUE)
# 
# ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "ND", replacement = 0, fixed = TRUE)
# ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "+/-", replacement = NA, fixed = TRUE)
# ClinicalFlowdata[-2] <- lapply(ClinicalFlowdata[-2], gsub, pattern = "-", replacement = "0", fixed = TRUE)
# ClinicalFlowdata <- lapply(ClinicalFlowdata, gsub, pattern = "+", replacement = NA, fixed = TRUE)
# ClinicalFlowdata[4:63] <- lapply(ClinicalFlowdata[4:63], as.numeric)
# ClinicalFlowdata <- as.data.frame(ClinicalFlowdata)
# colnames(ClinicalFlowdata)[4:63] <- paste("clin.ungate", colnames(ClinicalFlowdata)[4:63], sep = ".")
# ClinicalFlowdata <- filter(ClinicalFlowdata, Sample.Source == "Blood")
# ClinicalFlowdata$Date <- as.Date(ClinicalFlowdata$Date)

## CRC flow data =====

# CRCFlowdata <- read.xlsx("data/Report_Flow_Cytometry-CRC.xlsx", sheet = 1,
#                               startRow = 2, colNames = TRUE, detectDates = TRUE,
#                               cols = c(1,3,5:43), skipEmptyRows = TRUE)
# colnames(CRCFlowdata)[3:41] <- paste("crc", colnames(CRCFlowdata)[3:41], sep = ".")
# colnames(CRCFlowdata)[2] <- "Date"

## Research flow data =====

ResearchFlowdata <- read.xlsx("data/Report_Flow_Cytometry-Research.xlsx", sheet = 1,
                              startRow = 2, colNames = TRUE, detectDates = TRUE,
                              cols = c(1:2, 4:40), skipEmptyRows = TRUE)

ResearchFlowdata <- lapply(ResearchFlowdata, gsub, pattern = "ND", replacement = 0, fixed = TRUE)
ResearchFlowdata[3:39] <- lapply(ResearchFlowdata[3:39], as.numeric)
ResearchFlowdata <- as.data.frame(ResearchFlowdata)
colnames(ResearchFlowdata)[3:39] <- paste("res", colnames(ResearchFlowdata)[3:39], sep = ".")
colnames(ResearchFlowdata)[2] <- "Date"
ResearchFlowdata$Date <- as.Date(ResearchFlowdata$Date)
ResearchFlowdata$SubjectID <- as.character(ResearchFlowdata$SubjectID)


## FISH data =====

# FISHrawData <- read.xlsx("data/Report_Cytogenetics-FISH.xlsx", sheet = 1,
#                       colNames = TRUE, detectDates = TRUE, skipEmptyRows = TRUE,
#                       cols = c(1:2, 4:6, 9:14))


## Survival data =====

# Survivaldata <- read.xlsx("data/Report_Survival.xlsx", sheet = 1, cols = c(1:14),
#                           colNames = TRUE, detectDates = TRUE, skipEmptyRows = TRUE)
# Survivaldata$DOB <- convertToDate(Survivaldata$DOB)

## VHVL data =====

VHVLdata <- read.xlsx("data/CLLDATABASE-082316.xlsx",sheet = 1, colNames = TRUE,
                      detectDates = TRUE, skipEmptyRows = TRUE,
                      col = c(1:9,11,17:21,23,26))
names(VHVLdata)[names(VHVLdata) == "CLL.ID"] <- "SubjectID"
VHVLdata$SubjectID <- as.numeric(VHVLdata$SubjectID)
VHVLdata <- VHVLdata[!is.na(VHVLdata$SubjectID),]
VHVLdata$SubjectID <- sprintf("CLL%04d", VHVLdata$SubjectID)
VHVLdata$`%.mut` <- VHVLdata$`%.mut` * 100
VHVLdata$`%mut` <- VHVLdata$`%mut` * 100
VHVLdata <- tbl_df(VHVLdata)


#VHVL data cleanup and format -----

VHdata <- VHVLdata %>%
          select(SubjectID:CDR3.Heavy) %>%
          separate(VH.gene, c("VH.family","VH.gene", "VH.allele"),
             extra = "drop", fill = "right") %>%
          separate(D.gene, c("D.family", "D.gene", "D.allele"), extra = "drop", fill = "right") %>%
          separate(JH.gene, c("JH.family", "JH.gene"), extra = "drop", fill = "right") %>%
          # arrange(VH.family, VH.gene, VH.allele) %>%
          mutate(mut.status = ifelse(`%.mut` >= 3, "M","U"))

VLdata <- VHVLdata %>%
          select(SubjectID, VL.gene:CDR3Light) %>%
          separate(VL.gene, c("VL.family", "VL.gene","VL.allele"),
                   extra = "drop", fill = "right") %>%
          separate(JL.gene, c("JL.family","JL.gene"), extra = "drop", fill = "right") %>%
          mutate(mut.status = ifelse(`%mut` >= 3, "M", "U"))


# FISH data cleanup and format -----

# ATMdata <- FISHrawData %>%
#           filter(Probe == "ATM") %>%
#           arrange(Values)
# 
# p53data <- FISHrawData %>%
#           filter(Probe == "p53") %>%
#           arrange(Values)
# 
# data <- FISHrawData %>%
#           filter(Probe == "ATM" | Probe == "p53") %>%
#           arrange(Values)

# Survival data cleanup and format ----

# Survivaldata <- Survivaldata %>%
#           mutate(agedeath = new_interval(DOB, DeathDate) / years(1)) %>%
#           mutate(BirthYear = format(DOB, "%Y"))

# Melt data -----


# ClinFlowMelt <- ClinicalFlowdata %>%
#           select(-Sample.Source) %>%
#           melt(id.vars = c("SubjectID", "Date"),na.rm = TRUE) %>%
#           arrange(SubjectID, Date)
# 
# 
# CRCFlowMelt <- CRCFlowdata %>%
#           melt(id.vars = c("SubjectID", "Date"), na.rm = TRUE) %>%
#           arrange(SubjectID, Date)


ResFlowMelt <- ResearchFlowdata %>%
          select(-Date) %>%
          melt(id.vars = "SubjectID", na.rm = TRUE)
ResFlowMelt$value <- as.character(ResFlowMelt$value)

# Phenotypedata <- bind_rows(ClinFlowMelt, CRCFlowMelt, ResFlowMelt)

VHdatamelt <- VHdata %>%
          select(c(1:4, 16))%>%
          melt(id.vars = "SubjectID", na.rm = TRUE)



# Combine data -----

longdata <- bind_rows(ResFlowMelt, VHdatamelt)
widedata <- full_join(VHdata, ResearchFlowdata, by = "SubjectID")

IGHVfammean <- widedata %>%
  group_by(VH.family) %>%
  summarise_each(funs(mean(., na.rm = TRUE)))