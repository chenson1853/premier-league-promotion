
# Promotion Survival Project - Championship & Serie B Combined

# Load libraries
library(tidyverse)
library(readxl)
library(worldfootballR)
library(ggplot2)

# Load data
champ_data <- read_csv("data/championship_combined.csv")
serieb_data <- read_csv("data/serieb_combined.csv")

# Combine datasets
combined_data <- bind_rows(champ_data, serieB_data)

# Basic cleaning and checks
combined_data <- combined_data %>%
  mutate(
    League = if_else(Country == "ENG", "Championship", "Serie B"),
    Safe = as.factor(Survived)
  ) %>%
  drop_na()

# Basic summary statistics
summary_stats <- combined_data %>%
  group_by(League, Safe) %>%
  summarise(across(where(is.numeric), list(mean = mean, sd = sd), .names = "{.col}_{.fn}"), .groups = 'drop')

print(summary_stats)

# PCA and KMeans clustering
combined_scaled <- combined_data %>%
  select(where(is.numeric)) %>%
  scale()

pca_result <- prcomp(combined_scaled, center = TRUE, scale. = TRUE)
combined_data_pca <- as.data.frame(pca_result$x[, 1:4])
set.seed(42)
kmeans_result <- kmeans(combined_data_pca, centers = 3, nstart = 25)
combined_data$Cluster <- kmeans_result$cluster

# Plot PCA clusters
ggplot(combined_data_pca, aes(x = PC1, y = PC2, color = as.factor(kmeans_result$cluster))) +
  geom_point() +
  labs(title = "PCA Clustering of Promoted Teams", x = "PC1", y = "PC2", color = "Cluster")

# Save combined data
write_csv(combined_data, "combined_promotion_data.csv")
