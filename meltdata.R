require(reshape2)
ClinFlowMelt <- ClinicalFlowdata %>%
          select(-Sample.Source) %>%
          melt(id.vars = c("SubjectID", "Date"),na.rm = TRUE) %>%
          arrange(SubjectID, Date)


CRCFlowMelt <- CRCFlowdata %>%
          melt(id.vars = c("SubjectID", "Date"), na.rm = TRUE) %>%
          arrange(SubjectID, Date)


ResFlowMelt <- ResearchFlowdata %>%
          melt(id.vars = c("SubjectID", "Date"), na.rm = TRUE) %>%
          arrange(SubjectID, Date)

Phenotypedata <- bind_rows(ClinFlowMelt, CRCFlowMelt, ResFlowMelt)