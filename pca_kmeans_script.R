library(dplyr)
library(ggplot2)
library(cluster)
library(factoextra)
library(readxl)
library(tidyr)

# Load cleaned and scaled data
clusters <- read_xlsx("cluster.xlsx")
scaled_data <- clusters %>%
  select(-Squad, -Season_End_Year, -Country, -Survived, -Style, -NonGoalKickLaunchPct,
         -Defense, -Same_Manager, -Never_in_TopFlight, -Adj_npxG_per90, -Adj_npxGA_per90,
         -Seasons_in_2nd_Tier, -TopScorerPct, -cluster, -npxG_per_90, -npxGA_per_90)
scaled_data <- scale(scaled_data)

# Perform PCA
pca_result <- prcomp(scaled_data, center = TRUE, scale. = TRUE)
summary(pca_result)
biplot(pca_result)

# Extract PCA scores and apply K-means
pca_scores <- pca_result$x[, 1:4]
set.seed(44)
kmeans_result <- kmeans(pca_scores, centers = 4, nstart = 25)

# Plot clusters
plot(pca_scores, col = kmeans_result$cluster)
