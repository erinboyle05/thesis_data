require(reshape2)
ClinFlowMelt <- ClinicalFlowdata %>%
    melt(na.rm = TRUE) %>%
    arrange(SubjectID, Date)


CRCFlowMelt <- CRCFlowdata %>%
    melt(id.vars = c("SubjectID", "Sample.Date"), na.rm = TRUE) %>%
    arrange(SubjectID, Sample.Date)


ResFlowMelt <- ResearchFlowdata %>%
    melt(id.vars = c("SubjectID", "SampleDate"), na.rm = TRUE) %>%
    arrange(SubjectID, SampleDate)