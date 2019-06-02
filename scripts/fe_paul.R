
library(dplyr)
str(bank_train)

# Custom Function to bin featues: 

bin_features <- function(df, lst, cut_rate) {
  
  for (i in lst) {
    df[, paste0(i,'_bin')] <- .bincode(df[, i],
                                       breaks = quantile(df[, i], seq(0, 1, by = 1/cut_rate)),
                                       include.lowest = TRUE)
  }
  return(df)
}

# First: binning numerical variables in 3 bins:

bank_train_FE1 <- copy(bank_train)

features_list <- c('age','balance','duration','campaign')

bank_train_FE1 <- bin_features(bank_train_FE1, features_list, 3)

# Second: binning numerical variables in 4 bins:

bank_train_FE2 <- copy(bank_train)

features_list <- c('age','balance','duration','campaign')

bank_train_FE2 <- bin_features(bank_train_FE2, features_list, 4)

# Third: binning numerical variables in 5 bins:

bank_train_FE3 <- copy(bank_train)

features_list <- c('age','balance','duration','campaign')

bank_train_FE3 <- bin_features(bank_train_FE3, features_list, 5)

# Fourth: binning numerical variables in 10 bins:

bank_train_FE4 <- copy(bank_train)

features_list <- c('age','balance','duration','campaign')

bank_train_FE4 <- bin_features(bank_train_FE4, features_list, 10)
