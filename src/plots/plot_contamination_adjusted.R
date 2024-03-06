setwd("C:/Irfan/Personal/Masters/BMDSIS/plotting")

file <- "contaminationLevel.csv"

data <- read.csv(file, header=TRUE)

data$Dataset <- factor(data$Dataset, levels = unique(data$Dataset))
data$contaminantLevel <- rowSums(data[, c("rRNA", "tRNA", "mtDNA")])

# Get unique levels of the Dataset variable
dataset_levels <- unique(data$Dataset)

plot.new()
title <- "Contamination Level"

# Set the offset for x-axis tick marks
tick_offset <- 0.1

# Plot boxplots side by side
boxplot(Clean_Reads ~ Dataset, data = data,
        main = title,
        xlab = "", ylab = "Percentage %",
        col = "blue", # Specify color for the boxplot
        at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) - 0.2, # Set positions for the boxplots
        add = FALSE, # Start a new plot
        boxwex = 0.3, # Adjust width of the boxes
        names = levels(data$Dataset), # rep("", length(dataset_levels)), # Add only one tick label per dataset
        ylim = c(0, 90), # Set the y-axis limits 
        axes = FALSE
)

# Manually add tick marks for the first boxplot
axis(side = 1, at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + tick_offset,
     labels = FALSE, tick = TRUE, tck = 0.02, , line = 0.01, tcl = -.5)

axis(side = 2, at = seq(0, 100, by = 10))

boxplot(contaminantLevel ~ Dataset, data = data,
        main = title,
        xlab = "", ylab = "Percentage %",
        col = "red", # Specify color for the boxplot
        at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.1, # Set positions for the boxplots
        add = TRUE, # Add to existing plot
        boxwex = 0.3, # Adjust width of the boxes
        names = levels(data$Dataset),
        axes = FALSE)

boxplot(rRNA ~ Dataset, data = data,
        main = title,
        xlab = "", ylab = "Percentage %",
        col = "orange", # Specify color for the boxplot
        at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.4, # Set positions for the boxplots
        add = TRUE, # Add to existing plot
        boxwex = 0.3, # Adjust width of the boxes
        names = levels(data$Dataset),
        axes = FALSE)

text(x = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.2,
     y = par("usr")[3] - 0.5,
     labels = levels(data$Dataset),
     srt = 45, adj = c(1.1, 1),
     xpd = TRUE)

abline(h = seq(0, 100, by = 10), lwd = 0.5, col = "gray", lty = "dotted")

legend("bottomleft", legend = c("rRNA", "contaminant", "clean reads"),
       fill = c("orange", "red", "blue"), title = "Legend", cex = 0.6)

# grid(NA, y = seq(0, 100, by = 10), lwd = 0.5, col = "gray")
box()

plot.new()
title <- "tRNA and mtDNA Level"

# Set the offset for x-axis tick marks
tick_offset <- 0.1

# Plot boxplots side by side
boxplot(tRNA ~ Dataset, data = data,
        main = title,
        xlab = "", ylab = "Percentage %",
        col = "orange", # Specify color for the boxplot
        at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) - 0.1, # Set positions for the boxplots
        add = FALSE, # Start a new plot
        boxwex = 0.3, # Adjust width of the boxes
        names = levels(data$Dataset), # rep("", length(dataset_levels)), # Add only one tick label per dataset
        ylim = c(0, 25), # Set the y-axis limits 
        axes = FALSE
)

# Manually add tick marks for the first boxplot
axis(side = 1, at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + tick_offset,
     labels = FALSE, tick = TRUE, tck = 0.02, , line = 0.01, tcl = -.5)

axis(side = 2, at = seq(0, 25, by = 5))

boxplot(mtDNA ~ Dataset, data = data,
        main = title,
        xlab = "", ylab = "Percentage %",
        col = "red", # Specify color for the boxplot
        at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.2, # Set positions for the boxplots
        add = TRUE, # Add to existing plot
        boxwex = 0.3, # Adjust width of the boxes
        names = levels(data$Dataset),
        axes = FALSE)

text(x = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.2,
     y = par("usr")[3] - 0.5,
     labels = dataset_levels,
     srt = 45, adj = c(1.1, 1),
     xpd = TRUE)

abline(h = seq(0, 25, by = 2.5), lwd = 0.5, col = "gray", lty = "dotted")

legend("topright", legend = c("tRNA", "mtDNA"),
       fill = c("orange", "red"), title = "Legend", cex = 0.8)

# grid(NA, y = seq(0, 100, by = 10), lwd = 0.5, col = "gray")
box()

# Calculate summary statistics
summary_stats <- aggregate(Clean_Reads ~ Dataset, data = data,
                           FUN = function(x) c(min = min(x), max = max(x), mean = mean(x), median = median(x), sd = sd(x)))

# Print the summary statistics
print(summary_stats)

# Calculate max, min, mean, median, and sd from summary_stats
max_summary <- max(summary_stats$Clean_Reads)
min_summary <- min(summary_stats$Clean_Reads)
mean_summary <- mean(summary_stats$Clean_Reads)
median_summary <- median(summary_stats$Clean_Reads)
sd_summary <- sd(summary_stats$Clean_Reads)

# Print the results
cat("Max:", max_summary, "\n")
cat("Min:", min_summary, "\n")
cat("Mean:", mean_summary, "\n")
cat("Median:", median_summary, "\n")
cat("SD:", sd_summary, "\n")

# Calculate summary statistics
summary_stats <- aggregate(mtDNA ~ Dataset, data = data,
                           FUN = function(x) c(min = min(x), max = max(x), mean = mean(x), median = median(x), sd = sd(x)))

# Print the summary statistics
print(summary_stats)

# Calculate max, min, mean, median, and sd from summary_stats
max_summary <- max(summary_stats$mtDNA)
min_summary <- min(summary_stats$mtDNA)
mean_summary <- mean(summary_stats$mtDNA)
median_summary <- median(summary_stats$mtDNA)
sd_summary <- sd(summary_stats$mtDNA)

# Print the results
cat("Max:", max_summary, "\n")
cat("Min:", min_summary, "\n")
cat("Mean:", mean_summary, "\n")
cat("Median:", median_summary, "\n")
cat("SD:", sd_summary, "\n")


