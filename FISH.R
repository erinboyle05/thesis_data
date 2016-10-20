ATMdata <- FISHrawData %>%
          filter(Probe == "ATM") %>%
          arrange(Values)

p53data <- FISHrawData %>%
          filter(Probe == "p53") %>%
          arrange(Values)

data <- FISHrawData %>%
          filter(Probe == "ATM" | Probe == "p53") %>%
          arrange(Values)


plot <- ggplot(data = data, aes(Probe)) +
          geom_bar()+
          facet_grid(~Values)

print(plot)