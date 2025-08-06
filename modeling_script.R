# modeling_script.R

# Load packages
library(tidyverse)
library(mgcv)     # For GAMs
library(broom)    # For tidy model outputs

# Logistic regression: predicting survival from cluster assignment
logit_model <- glm(Survived ~ Cluster, data = promstats, family = binomial())
summary(logit_model)

# Optional: try other predictors
logit_xg <- glm(Survived ~ xG_per_90 + xGA_per_90, data = promstats, family = binomial())
summary(logit_xg)

# GAM example: predicting survival with nonlinear relationship
gam_model <- gam(Survived ~ s(PSxG_Minus_xG_per_90), data = promstats, family = binomial())
summary(gam_model)

# Save model summaries
saveRDS(logit_model, "output/logit_model.rds")
saveRDS(gam_model, "output/gam_model.rds")

# Create summary table
tidy(logit_model)
