# ------------------------------------------
#  Load Required Libraries
# ------------------------------------------
library(tidyverse)
library(fastDummies)
library(janitor)


# ------------------------------------------
#  Load Raw Data
# ------------------------------------------
# Replace with your actual file path
data_raw <- read.csv("C:/Users/musah yussif/Downloads/data analysis projects/Project 2/German_Credit_data/german_credit_data_biased_training.csv")

# Optional: clean column names
data <- clean_names(data_raw)  # converts to snake_case

# Quick look at the data
glimpse(data)
summary(data)

# ------------------------------------------
#  Check for Missing Values
# ------------------------------------------
colSums(is.na(data))


# ------------------------------------------
# 🔤 Encode Binary Categorical Variables
# ------------------------------------------
data <- data %>%
  mutate(
    sex = ifelse(sex == "male", 1, 0),
    foreign_worker = ifelse(foreign_worker == "yes", 1, 0),
    risk = ifelse(risk == "Risk", 1, 0)  # 1 = Risk, 0 = No Risk
  )

# ------------------------------------------
# 🔁 One-Hot Encode Multi-Class Categorical Variables
# ------------------------------------------
data <- dummy_cols(
  data,
  select_columns = c("checking_status", "credit_history", "loan_purpose", "housing", "job",
                     "existing_savings", "employment_duration", "others_on_loan",
                     "owns_property", "installment_plans", "telephone"),
  remove_selected_columns = TRUE,
  remove_first_dummy = TRUE
)
names(data)
head(data[, grepl("loan_purpose", names(data))])

# ------------------------------------------
# 🔢 Convert Relevant Columns to Numeric
# ------------------------------------------

data <- data %>%
  mutate(
    loan_amount = as.numeric(loan_amount),
    age = as.numeric(age),
    installment_percent = as.numeric(installment_percent),
    existing_credits_count = as.numeric(existing_credits_count),
    current_residence_duration = as.numeric(current_residence_duration),
    dependents = as.numeric(dependents)
  )
str(data)

# ------------------------------------------
# 📊 Scale Numerical Variables (Optional)
# ------------------------------------------
data <- data %>%
  mutate(across(
    .cols = c(loan_amount, age, installment_percent),
    .fns = scale
  ))


# ------------------------------------------
# Save the Cleaned Dataset
# ------------------------------------------

# Create 'data/cleaned' directory if it doesn't exist
if (!dir.exists("data/cleaned")) {
  dir.create("data/cleaned", recursive = TRUE)
}

# Save the final cleaned (and optionally scaled) dataset
write.csv(data, "data/cleaned/credit_data_cleaned.csv", row.names = FALSE)

# -----------------------------------------
#Ready for EDA
# ------------------------------------------

cat("Data preprocessing complete. Cleaned data saved to 'data/cleaned/credit_data_cleaned.csv'.\n")

