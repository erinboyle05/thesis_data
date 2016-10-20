require(tidyr)
require(dplyr)
require(ggplot2)

VHdata <- VHVLdata %>%
          select(CLL.ID:CDR3.Heavy) %>%
          separate(VH.gene, c("VH.family","VH.gene", "VH.allele"),
             extra = "drop", fill = "right") %>%
          separate(D.gene, c("D.family", "D.gene", "D.allele"), extra = "drop", fill = "right") %>%
          separate(JH.gene, c("JH.family", "JH.gene"), extra = "drop", fill = "right") %>%
          arrange(VH.family, VH.gene, VH.allele) %>%
          group_by(VH.family, VH.gene, VH.allele) %>%
          mutate(mut.status = ifelse(`%.mut` >= 3, "M","U"))
          
VLdata <- VHVLdata %>%
          select(CLL.ID, VL.gene:CDR3Light) %>%
          separate(VL.gene, c("VL.family", "VL.gene","VL.allele"),
                   extra = "drop", fill = "right") %>%
          separate(JL.gene, c("JL.family","JL.gene"), extra = "drop", fill = "right") %>%
          mutate(mut.status = ifelse(`%mut` >= 3, "M", "U"))
