library(readr)
library(ggplot2)
library(tidyverse)
job_postings <- read_csv("updated/job_postings.csv")


## dealing with missings
is.na(job_postings) %>% colSums() ## check for uninformation columns
columns_to_keep <- setdiff(names(job_postings), c("med_salary", "closed_time","skills_desc",
                                                  "application_url","remote_allowed","posting_domain",
                                                  "compensation_type","applies"))
job_postings <- job_postings %>% select(all_of(columns_to_keep))
job <- job_postings[complete.cases(job_postings), ]
is.na(job) %>% colSums()

## check the traits of data
job %>% group_by(pay_period) %>% tally() %>% arrange(desc(n)) ## change to yearly
job <- job %>%
  mutate(
    max_salary = case_when(
      pay_period == "HOURLY" ~ max_salary * 40 * 52,
      pay_period == "MONTHLY" ~ max_salary * 12,
      TRUE ~ max_salary
    ),
    min_salary = case_when(
      pay_period == "HOURLY" ~ min_salary * 40 * 52,
      pay_period == "MONTHLY" ~ min_salary * 12,
      TRUE ~ min_salary
    ),
    pay_period = "YEARLY"
  )

job <- job[job$max_salary>=1000,] ## exclude those do not make sense

## histogram of max_salary (yearly), some obeservations do not seem right (<1000)
ggplot(job, aes(x = max_salary)) +
  geom_histogram(bins=200)+  # Adjust binwidth as needed
  labs(title = "Histogram of Max Salary",
       x = "Max Salary",
       y = "Frequency")

ggplot(job, aes(x = min_salary)) +
  geom_histogram(bins=200)+  # Adjust binwidth as needed
  labs(title = "Histogram of Min Salary",
       x = "Min Salary",
       y = "Frequency")



job %>% group_by(formatted_work_type) %>% tally() %>% arrange(desc(n)) 
ggplot(job, aes(x = formatted_work_type, fill = formatted_work_type)) +
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

ggplot(data = job, aes(x = reorder(state, -table(state)[state]), fill = state)) +
  geom_bar() +
  labs(
    title = "Histogram of State Abbreviations",
    x = "State Abbreviation",
    y = "Frequency"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 4),  # Adjust size as needed
    legend.key.size = unit(0.5, "lines")  # Adjust the legend key size as needed
  )
