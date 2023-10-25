library(readr)
library(ggplot2)
library(tidyverse)
job <- read_csv("generate/cleaned.csv")



## histogram of max_salary (yearly), some obeservations do not seem right (<1000)
plot1 <- ggplot(job, aes(x = max_salary)) +
  geom_histogram(bins=200)+  # Adjust binwidth as needed
  labs(title = "Histogram of Max Salary",
       x = "Max Salary",
       y = "Frequency")

plot2 <- ggplot(job, aes(x = min_salary)) +
  geom_histogram(bins=200)+  # Adjust binwidth as needed
  labs(title = "Histogram of Min Salary",
       x = "Min Salary",
       y = "Frequency")



job %>% group_by(formatted_work_type) %>% tally() %>% arrange(desc(n)) 
plot3 <- ggplot(job, aes(x = formatted_work_type, fill = formatted_work_type)) +
  geom_bar() +
  labs(title = "Bar Plot of Work Type",
       x = "Different Types",
       y = "Count")

## location
job %>% group_by(location) %>% tally() %>% arrange(desc(n))
jobl <- job$location 
addresses <- jobl %>% str_split(", ") %>% lapply(function(inner_list) {
  if (tail(inner_list, 1) == "United States") {
    inner_list[[1]]
  } else {
    inner_list[[length(inner_list)]]
  }
})  %>% unlist() %>% as.matrix()
addresses_unique <- addresses %>% unique()

## use chatgpt to change addresses into the abbreviated state name
state_abbreviations <-  c(
  "USA", "CA", "IL", "NY", "FL", "VA", "CA", "CA", "CA", "MI",
  "MN", "AZ", "TX", "KS", "NM", "ID", "VA", "NV", "MA", "PA",
  "NJ", "DC", "LA", "OH", "FL", "TX", "MD", "MO", "TX", "CO",
  "OR", "NC", "IN", "ND", "CA", "TX", "NY", "WA", "DE", "MT",
  "TN", "MI", "UT", "GA", "CT", "SC", "NY", "NY", "WI", "OH",
  "NJ", "DC", "NV", "OK", "SC", "FL", "IL", "MO", "AR", "MA",
  "CO", "TN", "TN", "KY", "CA", "ND", "IL", "IA", "HI", "NC",
  "MS", "TN", "NY", "NC", "MO", "SC", "ME", "WA", "NE", "AL",
  "CT", "IA", "NC", "NM", "RI", "TX", "OK", "MN", "KY", "CO",
  "GA", "MO", "TX", "AZ", "PA", "AL", "FL", "MI", "AL", "ME",
  "CA", "FL", "OR", "OH", "MN", "AZ", "MI", "OH", "SD", "LA",
  "CA", "PA", "PA", "CO", "TX", "CA", "NH", "DC", "DC", "FL",
  "UT", "UT", "GA", "WY", "NV", "AR", "ND", "SC", "CA", "WV",
  "NH", "DE", "MA", "OR", "MT", "KY", "SD", "OK", "MD", "RI",
  "AZ", "WI", "IN", "NE", "AK", "WV", "KS", "OH", "MA", "PA",
  "TN", "WY", "FL", "CA"
)

# Now, the "location" variable in the "job" dataset contains state abbreviations
index <- match(addresses,addresses_unique)
job$state <- state_abbreviations[index]

plot4 <- ggplot(data = job, aes(x = reorder(state, -table(state)[state]), fill = state)) +
  geom_bar() +
  labs(
    title = "Histogram of Job in Different States",
    x = "State Abbreviation",
    y = "Frequency"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 4),  # Adjust size as needed
    legend.key.size = unit(0.5, "lines")  # Adjust the legend key size as needed
  )


ggsave(filename = "generate/plot1.png", plot = plot1, device = "png", width=6, height=4,units = "in")
ggsave(filename = "generate/plot2.png", plot = plot2, device = "png", width=6, height=4,units = "in")
ggsave(filename = "generate/plot3.png", plot = plot3, device = "png", width=6, height=4,units = "in")
ggsave(filename = "generate/plot4.png", plot = plot4, device = "png", width=6, height=4,units = "in")

