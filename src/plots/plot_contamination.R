

setwd("C:/Irfan/Personal/Masters/BMDSIS/plotting")

file <- "contaminationLevel.csv"

data <- read.csv(file, header=TRUE)

data$Dataset <- factor(data$Dataset, levels = unique(data$Dataset))

# Get unique levels of the Dataset variable
dataset_levels <- unique(data$Dataset)

# png("CleanReadsandContaminants.png", width = 800, height = 600) 
plot.new()
title <- "Non-Contaminants and rRNA %"

# Set the offset for x-axis tick marks
tick_offset <- 0.1

# Plot boxplots side by side
boxplot(Clean_Reads ~ Dataset, data = data,
        main = title,
        xlab = "", ylab = "Percentage %",
        col = "blue", # Specify color for the boxplot
        at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) - 0.1, # Set positions for the boxplots
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

boxplot(rRNA ~ Dataset, data = data,
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
     labels = levels(data$Dataset),
     srt = 45, adj = c(1.1, 1),
     xpd = TRUE)

abline(h = seq(0, 100, by = 10), lwd = 0.5, col = "gray", lty = "dotted")

# grid(NA, y = seq(0, 100, by = 10), lwd = 0.5, col = "gray")
box()

## tRNA and mtDNA

# png("CleanReadsandContaminants.png", width = 800, height = 600) 
plot.new()
title <- "tRNA and mtDNA %"

# Set the offset for x-axis tick marks
tick_offset <- 0.1

# Plot boxplots side by side
boxplot(tRNA ~ Dataset, data = data,
        main = title,
        xlab = "", ylab = "Percentage %",
        col = "blue", # Specify color for the boxplot
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

abline(h = seq(0, 25, by = 5), lwd = 0.5, col = "gray", lty = "dotted")

# grid(NA, y = seq(0, 100, by = 10), lwd = 0.5, col = "gray")
box()



