
library(ggplot2)
library(dplyr)
library(tidyr)

setwd("C:/Irfan/Personal/Masters/BMDSIS/plotting")

data <- read.csv("read_length_dist.human.breakdown.contaminants.csv", header=TRUE)


# Summarize the data to calculate mean and standard deviation
summary_data <- data %>%
  group_by(sample, contaminant) %>%
  summarise(across(22:42, list(mean = mean, sd = sd)))

# Reshape the data from wide to long format
summary_data_long <- summary_data %>%
  pivot_longer(cols = starts_with("X"), names_to = c(".value", "column"), names_sep = "_")

# Convert mean and sd columns to numeric
summary_data_long <- summary_data_long %>%
  mutate(across(starts_with("X"), as.numeric))

summary_data_long <- summary_data_long %>%
  mutate(across(starts_with("X"), as.numeric),
         across(starts_with("sd"), as.numeric))

# Reshape data for easier plotting
data_long <- pivot_longer(summary_data_long, cols = starts_with("X"), names_to = "header", values_to = "value")

# Calculate upper and lower bounds for error bars
# Calculate lower and upper bounds
sd_values <- data_long %>%
  mutate(lower = if_else(column == "sd", 0, pmax(0, value - value / 2)),
         upper = if_else(column == "sd", value, value + value / 2))

mean_values <- data_long %>%
  filter(column == "mean") %>%
  select(sample, contaminant, header, mean_value = value)

test <- data_long %>%
  left_join(mean_values, by = c("header", "sample", "contaminant")) %>%
  mutate(mean_value = if_else(column == "sd", mean_value, value))

# Calculate lower and upper bounds
test <- test %>%
  mutate(lower = if_else(column == "sd", mean_value - (value / 2), NA_real_),
         upper = if_else(column == "sd", mean_value + (value / 2), NA_real_))

test <- test %>%
  mutate(lower = if_else(column == "sd" & lower<0, 0, lower))

test <- test %>%
  mutate(header = gsub("^X", "", header))

test <- test %>%
  mutate(
    value = value / 100,
    lower = lower / 100,
    upper = upper / 100
  )

result <- test %>%
  filter(column == "sd") %>%
  select(sample, contaminant, column, header, mean_value, value, lower, upper)

ggplot(test, aes(x = header, y = value, color = column)) +
  geom_line(data = subset(test, column == "mean"), aes(color = contaminant, group = interaction(sample, contaminant))) +
  geom_errorbar(data = subset(test, column == "sd"), color = "black", alpha = 0.8, aes(x = header, ymin = lower, ymax = upper), width = 0.2) +
  facet_grid(vars(sample)) +
  labs(x = "Read Length", y = "Fraction") +
  geom_vline(xintercept = c('28', '29', '30'), linetype = "dashed", color = "red", alpha = 0.5) + 
  theme_minimal() +
  scale_y_continuous(breaks = seq(0, 0.6, by = 0.1), limits = c(0, 0.5))

ggsave("contaminant.read_length.distribution.png", plot = last_plot(), height = 8, units = "in")


