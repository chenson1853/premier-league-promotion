# visualization_script.R

library(tidyverse)

# Plot 1: PCA Clusters
ggplot(pca_data, aes(PC1, PC2, color = as.factor(cluster))) +
  geom_point(size = 3) +
  labs(title = "Team Clusters by PCA", color = "Cluster") +
  theme_minimal()

# Plot 2: Survival by Cluster
ggplot(promstats, aes(x = Cluster, fill = factor(Survived))) +
  geom_bar(position = "fill") +
  labs(title = "Survival Rate by Cluster", y = "Proportion", fill = "Survived") +
  theme_minimal()

# Plot 3: xG vs xGA with survival outcome
ggplot(promstats, aes(x = xG_per_90, y = xGA_per_90, color = factor(Survived))) +
  geom_point(size = 3) +
  labs(title = "xG vs xGA Colored by Survival", color = "Survived") +
  theme_minimal()
