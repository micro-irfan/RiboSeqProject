  setwd("C:/Irfan/Personal/Masters/BMDSIS/plotting")
  
  file <- "contamination_PRJNA756018.csv"
  
  data <- read.csv(file, header=TRUE)
  
  data <- data[, -which(names(data) %in% c('Run'))]  
  unique_values <- c(unique(data$Organ))
  
  data$Organ <- factor(data$Organ, levels = unique_values)  # Adjust the levels as needed
  data$contaminantLevel <- rowSums(data[, c("rRNA", "tRNA", "mtDNA")])
  
  
  # Get unique levels of the Dataset variable
  dataset_levels <- unique(data$Organ)
  
  plot.new()
  title <- "PRJNA756018 Contamination Level"
  
  # Set the offset for x-axis tick marks
  tick_offset <- 0.1
  
  # Plot boxplots side by side
  boxplot(CleanReads ~ Organ, data = data,
          main = title,
          xlab = "", ylab = "Percentage %",
          col = "blue", # Specify color for the boxplot
          at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) - 0.2, # Set positions for the boxplots
          add = FALSE, # Start a new plot
          boxwex = 0.3, # Adjust width of the boxes
          names = rep("", length(dataset_levels)), # Add only one tick label per dataset
          ylim = c(10, 80), # Set the y-axis limits 
          axes = FALSE
  )
  
  # Manually add tick marks for the first boxplot
  axis(side = 1, at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + tick_offset,
       labels = FALSE, tick = TRUE, tck = 0.02, , line = 0.01, tcl = -.5)
  
  axis(side = 2, at = seq(0, 100, by = 10))
  
  boxplot(contaminantLevel ~ Organ, data = data,
          main = title,
          xlab = "", ylab = "Percentage %",
          col = "red", # Specify color for the boxplot
          at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.1, # Set positions for the boxplots
          add = TRUE, # Add to existing plot
          boxwex = 0.3, # Adjust width of the boxes
          names = levels(data$Dataset),
          axes = FALSE)
  
  boxplot(rRNA ~ Organ, data = data,
          main = title,
          xlab = "", ylab = "Percentage %",
          col = "orange", # Specify color for the boxplot
          at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.4, # Set positions for the boxplots
          add = TRUE, # Add to existing plot
          boxwex = 0.3, # Adjust width of the boxes
          names = NA,
          axes = FALSE)
  
  text(x = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.2,
       y = par("usr")[3] -.1,
       labels = dataset_levels,
       srt = 45, adj = c(1.3, 1),
       xpd = TRUE,
       cex = 0.8)
  
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
  boxplot(tRNA ~ Organ, data = data,
          main = title,
          xlab = "", ylab = "Percentage %",
          col = "orange", # Specify color for the boxplot
          at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) - 0.1, # Set positions for the boxplots
          add = FALSE, # Start a new plot
          boxwex = 0.3, # Adjust width of the boxes
          names = rep("", length(dataset_levels)), # Add only one tick label per dataset
          ylim = c(0, 12.5), # Set the y-axis limits 
          axes = FALSE
  )
  
  # Manually add tick marks for the first boxplot
  axis(side = 1, at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + tick_offset,
       labels = FALSE, tick = TRUE, tck = 0.02, , line = 0.01, tcl = -.5)
  
  axis(side = 2, at = seq(0, 12.5, by = 2.5))
  
  boxplot(mtDNA ~ Organ, data = data,
          main = title,
          xlab = "", ylab = "Percentage %",
          col = "red", # Specify color for the boxplot
          at = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.2, # Set positions for the boxplots
          add = TRUE, # Add to existing plot
          boxwex = 0.3, # Adjust width of the boxes
          names = NA,
          axes = FALSE)
  
  text(x = seq(1, length(dataset_levels), length.out = length(dataset_levels)) + 0.2,
       y = par("usr")[3] - 0.1,
       labels = dataset_levels,
       srt = 45, adj = c(1.3, 1),
       xpd = TRUE,
       cex = 0.8)
  
  abline(h = seq(0, 15, by = 2.5), lwd = 0.5, col = "gray", lty = "dotted")
  
  legend("topleft", legend = c("tRNA", "mtDNA"),
         fill = c("orange", "red"), title = "Legend", cex = 0.8)
  
  
  # grid(NA, y = seq(0, 100, by = 10), lwd = 0.5, col = "gray")
  box()
  
