####
#### THIS SCRIPT DEFINES PARAMETERS AND FUNCTIONS FOR MODELING
####

seed <- ifelse(exists('seed'), seed, 2019)
set.seed(seed)

time_fit_start <- 0
time_fit_end <- 0
all_results <- data.frame()
all_real_results <- data.frame()


# Cross-Validation Settings ----
fitControl <-
  trainControl(
    method = 'repeatedcv',
    number = 10,
    repeats = 3,
    verboseIter = TRUE
    # allowParallel = TRUE
  )

print(paste0(
  ifelse(exists('start_time'), paste0('[', round(
    difftime(Sys.time(), start_time, units = 'mins'), 1
  ),
  'm]: '), ''),
  'Fit Control will use ',
  fitControl$method,
  ' with ',
  fitControl$number,
  ' folds and ',
  fitControl$repeats,
  ' repeats.'
))


# Default tuneGrid for Random Forest ? ----


# Default tuneGrid for XGBoost ? ----


# Function to get the best results in caret ----
get_best_result = function(caret_fit) {
  best = which(rownames(caret_fit$results) == rownames(caret_fit$bestTune))
  best_result = caret_fit$results[best, ]
  rownames(best_result) = NULL
  best_result
}

print(paste0(
  ifelse(exists('start_time'), paste0('[', round(
    difftime(Sys.time(), start_time, units = 'mins'), 1
  ),
  'm]: '), ''),
  'Modeling Parameters and Functions ready!'
))


