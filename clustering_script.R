library(dplyr)
library(ggplot2)
library(cluster)
library(factoextra)
library(readxl)
library(tidyr)

# Load and clean data
clutter <- read_xlsx("promotion_master.xlsx")
clutter <- clutter %>%
  filter(!is.na(Survived)) %>%
  select(-Final_Third_Pass)

# Separate ID and scaling columns
id_columns <- clutter %>% select(Squad, Season_End_Year, Country, Survived)
scale_columns <- clutter %>% select(-Squad, -Season_End_Year, -Country, -Survived)

# Scale the data
scaled_clutter <- scale(scale_columns)

# Determine optimal number of clusters (Elbow method)
wss <- sapply(1:10, function(k) {
  kmeans(scaled_clutter, centers = k, nstart = 25)$tot.withinss
})
plot(1:10, wss, type = 'b', pch = 19,
     xlab = 'Number of Clusters', ylab = 'Total Within Sum of Squares')

# Fit K-means
set.seed(42)
kmeans_result <- kmeans(scaled_clutter, centers = 3, nstart = 25)
id_columns$cluster <- kmeans_result$cluster

# Label styles
id_columns$style <- factor(id_columns$cluster, labels = c("Counter-Attack", "Balanced", "Possession"))
clutter <- cbind(id_columns, scale_columns)
