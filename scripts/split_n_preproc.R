####
#### THIS SCRIPT SPLIT THE TRAIN SET AND 
####

seed <- ifelse(exists('seed'), seed, 2019)
set.seed(seed)

# Splitting Train Set into two parts ----

index <-
  createDataPartition(bank_train$y,
                      p = 0.8,
                      list = FALSE,
                      times = 1)
bank_train_A <- bank_train[index,]
bank_train_B <- bank_train[-index,]

print(paste0(
  ifelse(exists('start_time'), paste0('[', round(
    difftime(Sys.time(), start_time, units = 'mins'), 1
  ), 'm]: '), ''),
  'Train Set is split!'))


# Center and Scale Train Sets and Test Set ----
preProcValues <-
  preProcess(bank_train_A, method = c("center", "scale"))
bank_train_A_proc <- predict(preProcValues, bank_train_A)
bank_train_B_proc <- predict(preProcValues, bank_train_B)
bank_test_proc <- predict(preProcValues, bank_test)


print(paste0(
  ifelse(exists('start_time'), paste0('[', round(
    difftime(Sys.time(), start_time, units = 'mins'), 1
  ), 'm]: '), ''),
  'Data Sets are centered and scaled!'
))
