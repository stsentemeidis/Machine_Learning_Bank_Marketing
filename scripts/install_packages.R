####
#### THIS SCRIPT CHECK IF NECESSARY PACKAGES ARE INSTALLED AND LOADED
####

packages_list <- c(
  'Amelia',
  'data.table',
  'pROC',
  'ggthemes',
  'dplyr',
  'tibble',
  'tidyr',
  'corrplot',
  'GGally',
  'ggmap',
  'ggplot2',
  'grid',
  'gridExtra',
  'caret',
  'dbscan',
  'glmnet',
  'leaderCluster',
  'MLmetrics',
  'ranger',
  'xgboost',
  'doParallel',
  'factoextra',
  'foreach',
  'parallel',
  'kableExtra',
  'knitr',
  'RColorBrewer',
  'shiny',
  'beepr',
  'tufte',
  'flexclust',
  'factoextra'
  'caretEnsemble'
)

# Palette Colour
color1 = 'white'
color2 = 'black'
color3 = 'black'
color4 = 'darkturquoise'
font1 = 'Impact'
font2 = 'Helvetica'
BarFillColor <- "#330066"
HBarFillColor <- "#000099"
BarLineColor <- "#FFFAFA"
MissingColor <- "#FF6666"

for (i in packages_list) {
  if (!i %in% installed.packages()) {
    install.packages(i, dependencies = TRUE)
    library(i, character.only = TRUE)
    warnings(paste0(i, ' has been installed'))
  } else {
    warnings(paste0(i, ' is already installed'))
    library(i, character.only = TRUE)
  }
}

print(paste0(
  ifelse(exists('start_time'), paste0('[', round(
    difftime(Sys.time(), start_time, units = 'mins'), 1
  ),
  'm]: '), ''),
  'All necessary packages installed and loaded'
))

