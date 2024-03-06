library(readxl)
library(ggplot2)
library(reshape2)

setwd("C:/Irfan/Personal/Masters/BMDSIS/plotting")

# Path to your Excel file
excel_file <- "../FeatureCountBreakdown.xlsx"

# PRJNA604580 PRJNA544411 PRJNA507253 PRJNA756018 PRJNA515538
# PRJNA812862 PRJNA552552 PRJNA375080
# PRJNA507253_gsnap PRJNA756018_gsnap
accession_number <- "PRJNA756018"

# Read the Excel file
df <- read_excel(excel_file, sheet = accession_number)

columns = c("sample",
            "3utr",
            "5utr",
            "CDS")

subset_df <- df[, columns]
columns_to_sum <- setdiff(columns, "sample")
subset_df$sum <- rowSums(subset_df[, columns_to_sum])
for (col_name in columns_to_sum) {
  subset_df[[paste0(col_name, "_percent")]] <- (subset_df[[col_name]] / subset_df$sum) * 100
}

subset_df <- subset_df[, !names(subset_df) %in% columns_to_sum]

# Get the names of columns containing "_percent"
columns_to_rename <- grep("_percent", names(subset_df), value = TRUE)

for (col in columns_to_rename) {
  new_name <- gsub("_percent", "", col)
  subset_df[[new_name]] <- subset_df[[col]]
}

subset_df <- subset_df[, !names(subset_df) %in% columns_to_rename]

columns_colour <- c( 
  "CDS" = "#FF0000", 
  "5utr" = "#FF6633", 
  "3utr" = "#FF9999"
)

df_long <- melt(subset_df, id.vars = c("sample", "sum"))

# Create the stacked bar plot with a smaller legend
ggplot(df_long, aes(x = sample, y = value, fill = variable)) +
  geom_bar(stat = "identity") +
  labs(x = NULL, y = "Percentage", fill = "Category", title=accession_number) +
  scale_fill_manual(values = columns_colour) +  # Use defined colors
  theme_minimal() + 
  theme(
    legend.position = "none", # Remove the legend 
    legend.key.size = unit(0.1, "cm"),  # Set the size of legend keys
    legend.key.height = unit(0.1, "cm"), # Set the height of legend keys
    legend.key.width = unit(0.2, "cm"),   # Set the width of legend keys\
    legend.text = element_text(size = 6),  # Set the size of legend labels
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), # , size=4
    panel.grid = element_blank(),
    plot.title = element_text(size = 8, margin = margin(b = 1))
  )

file_name <- paste0(accession_number, ".featureCount.CDS.png")
ggsave(file_name, plot = last_plot(), height = 2, units = "in")
subset_df

cols_to_calculate <- setdiff(names(subset_df), c("sample", "sum"))

# Calculate the mean and median for each column except 'exclude_column'
means <- sapply(subset_df[cols_to_calculate], mean)
medians <- sapply(subset_df[cols_to_calculate], median)
std_devs <- sapply(df[cols_to_calculate], sd)

print (std_devs)

# Print the means and medians
print("Means:")
print(means)

print("Medians:")
print(medians)
