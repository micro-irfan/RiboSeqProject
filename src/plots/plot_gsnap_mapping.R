library(readxl)
library(ggplot2)
library(reshape2)

setwd("C:/Irfan/Personal/Masters/BMDSIS/plotting")

# Path to your Excel file
excel_file <- "../ReadMappingResults.xlsx"

# Read the Excel file
# PRJNA756018_gsnap PRJNA507253_gsnap PRJNA552552_gsnap
sample_name <- "PRJNA507253_gsnap"
df <- read_excel(excel_file, sheet = sample_name)

#df <- df %>%
#  filter(Len != 15 & Len != 25)

df$sample <- paste(df$Accession, df$method, sep = "_")

columns = c("sample", 
            "Number of reads unmapped: Unknown",
            "Number of reads mapped to multiple loci", 
            "Uniquely mapped reads number")

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
  "Uniquely mapped reads number" = "#FF0000", 
  "Number of reads mapped to multiple loci" = "#FF6633", 
  "Number of reads mapped to too many loci" = "#FF9966", 
  "Number of reads unmapped: Unknown" = "#FFE6E6",
  "Number of reads unmapped: too many mismatches" = "#FF9999",
  "Number of reads unmapped: too short" = "#FFCCCC", 
  "Number of reads unmapped: other" = "#FFE6E6"
)

df_long <- melt(subset_df, id.vars = c("sample", "sum"))

# Create a dummy data frame with no rows
empty_df <- data.frame(sample = character(0), value = numeric(0), variable = factor(levels = character(0)))

# Create a plot with just the legend
ggplot(df_long, aes(x = sample, y = value, fill = variable)) +
  geom_bar(stat = "identity", width = 0) +  # Use width = 0 to hide bars
  theme_void() +  # Remove all non-data elements
  theme(legend.position = "left") +  # Position the legend to the right
  scale_fill_manual(values = columns_colour)  # Use mapped colors

# Create the stacked bar plot with a smaller legend
ggplot(df_long, aes(x = sample, y = value, fill = variable)) +
  geom_bar(stat = "identity") +
  labs(x = NULL, y = "Percentage", fill = "Category", title=sample_name) +
  scale_fill_manual(values = columns_colour) +  # Use defined colors
  theme_minimal() + 
  theme(
    legend.position = "none", # Remove the legend 
    legend.key.size = unit(0.2, "cm"),  # Set the size of legend keys
    legend.key.height = unit(0.2, "cm"), # Set the height of legend keys
    legend.key.width = unit(0.2, "cm"),   # Set the width of legend keys
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size=4), # , size=4
    panel.grid = element_blank(),
    plot.title = element_text(size = 8, margin = margin(b = 1))
  )

file_name <- paste(sample_name, 'gsnap.mapping.png', sep = ".")

ggsave(file_name, plot = last_plot(), height = 3, units = "in")
