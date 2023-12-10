library(readr)
library(ggplot2)
library(tidyverse)
library(dplyr)
setwd("~/work/611/")
job <- read_csv("/home/rstudio/work/output/cleaned.csv")



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

plot5 <- ggplot() +
  geom_density(data = job %>% filter(state == "CA"),
               aes(x = max_salary, fill = state), alpha = 0.5, position =position_dodge(width = 2)) +
  
  geom_density(data = job %>% filter(state != "CA"),
               aes(x = max_salary), color = "blue") +
  labs(title = "Density Plot of Max Salary in CA (Pink) and Other States (Blue)",
       x = "Max Salary(dollar/year)",
       y = "Density") +
  theme_minimal() +
  guides(fill = guide_legend(title = "State", override.aes = list(color = c("pink")))) +
  theme(legend.position = "top")  

ggsave(filename = "/home/rstudio/work/output/plot1.png", plot = plot1, device = "png", width=6, height=4,units = "in")
ggsave(filename = "/home/rstudio/work/output/plot2.png", plot = plot2, device = "png", width=6, height=4,units = "in")
ggsave(filename = "/home/rstudio/work/output/plot3.png", plot = plot3, device = "png", width=8, height=4,units = "in")
ggsave(filename = "/home/rstudio/work/output/plot4.png", plot = plot4, device = "png", width=6, height=4,units = "in")
ggsave(filename = "/home/rstudio/work/output/plot5.png", plot = plot5, device = "png", width=6, height=4,units = "in")


## Carry out a two sample T test to compare the max salary in CA and other part of USA
# Extract salaries for California and other states
salaries_CA <- job %>% filter(state == "CA")
salaries_other_states <- job %>% filter(state != "CA")
# Perform two-sample t-test
t_test_result <- t.test(salaries_CA$max_salary, salaries_other_states$max_salary)


## the relationship between the number of views with the location, level,  max salary
job <- job %>% mutate(isca = ifelse(state == "CA", 1, 0))
job <- job %>%
  mutate(level = case_when(
    formatted_experience_level == "Internship" ~ 1,
    formatted_experience_level == "Entry level" ~ 2,
    formatted_experience_level == "Associate" ~ 3,
    formatted_experience_level == "Mid-Senior level" ~ 4,
    formatted_experience_level == "Director" ~ 5,
    formatted_experience_level == "Executive" ~ 6 # Handles other cases or unknowns
  ))
model <- lm(views ~  isca + formatted_experience_level + max_salary, data = job)
summary(model)


