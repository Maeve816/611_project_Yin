library(readr)
library(ggplot2)
library(tidyverse)
job_postings <- read_csv("project/source_data/updated/job_postings.csv")


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

write_csv(job,"generate/cleaned.csv")

