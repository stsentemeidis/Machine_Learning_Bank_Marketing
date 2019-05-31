####
#### THIS SCRIPT FITS A LOGISTIC REGRESSION MODEL AND MAKE PREDICTIONS
####

seed <- ifelse(exists('seed'), seed, 2019)
set.seed(seed)

pipeline_glm <- function(target, train_set, valid_set, test_set,
                        trControl = NULL, tuneGrid = NULL,
                        suffix = NULL, calculate = FALSE, seed = 2019,
                        n_cores = 1){

suffix <- ifelse(is.null(suffix), NULL, paste0('_', suffix))  

if (is.null(trControl)){
  trControl <- trainControl()
}

# Linear Regression ----
if (calculate == TRUE) {
  library(doParallel)
  cl <- makePSOCKcluster(n_cores)
  clusterEvalQ(cl, library(foreach))
  registerDoParallel(cl)
  print(paste0(
    ifelse(exists('start_time'), paste0('[', round(
      difftime(Sys.time(), start_time, units = 'mins'), 1
    ),
    'm]: '), ''),
    'Starting Logistic Regression Model Fit... ',
    ifelse(is.null(suffix), NULL, paste0(' ', substr(
      suffix, 2, nchar(suffix)
    )))
  ))
  time_fit_start <- Sys.time()
  assign(
    paste0('fit_glm', suffix),
    train(
      x = train_set[, !names(train_set) %in% c(target)],
      y = train_set[, target],
      method = 'glm',
      trControl = trControl,
      tuneGrid = tuneGrid
    )
  , envir = .GlobalEnv) 
  time_fit_end <- Sys.time()
  stopCluster(cl)
  assign(paste0('time_fit_duration', suffix),
         time_fit_end - time_fit_start, envir = .GlobalEnv)
  saveRDS(get(paste0('fit_glm', suffix)), paste0('models/fit_glm', suffix, '.rds'))
  saveRDS(get(paste0('time_fit_duration', suffix)), paste0('models/time_fit_duration', suffix, '.rds'))
}

assign(paste0('fit_glm', suffix),
       readRDS(paste0('models/fit_glm', suffix, '.rds')), envir = .GlobalEnv)
assign(paste0('time_fit_duration', suffix),
       readRDS(paste0('models/time_fit_duration', suffix, '.rds')), envir = .GlobalEnv)

assign(paste0('pred_glm', suffix),
       predict(get(paste0('fit_glm', suffix)), valid_set), envir = .GlobalEnv)

assign(paste0('comp_glm', suffix),
       data.frame(obs = valid_set[,target],
                  pred = get(paste0('pred_glm', suffix))), envir = .GlobalEnv)

assign(paste0('results', suffix),
       as.data.frame(
         cbind(
           rbind(defaultSummary(get(paste0('comp_glm',suffix)))),
           'Accuracy' = Accuracy(y_pred = get(paste0('pred_glm', suffix)),
                                 y_true = valid_set[,target]),
           'Sensitivity' = Sensitivity(y_pred = get(paste0('pred_glm', suffix)),
                                 y_true = valid_set[,target]),
           'Precision' = Precision(y_pred = get(paste0('pred_glm', suffix)),
                                 y_true = valid_set[,target]),
           'Recall' = Recall(y_pred = get(paste0('pred_glm', suffix)),
                                 y_true = valid_set[,target]),
           'F1 Score' = F1_Score(y_pred = get(paste0('pred_glm', suffix)),
                                 y_true = valid_set[,target]),
           'Coefficients' = length(get(paste0('fit_glm', suffix))$finaglmodel$coefficients),
           'Train Time (min)' = round(as.numeric(get(paste0('time_fit_duration', suffix)), units = 'mins'), 1),
           'CV | Accuracy' = get_best_result(get(paste0('fit_glm', suffix)))[, 'Accuracy'],
           'CV | Kappa' = get_best_result(get(paste0('fit_glm', suffix)))[, 'Kappa'],
           'CV | AccuracySD' = get_best_result(get(paste0('fit_glm', suffix)))[, 'AccuracySD'],
           'CV | KappaSD' = get_best_result(get(paste0('fit_glm', suffix)))[, 'KappaSD']
         )
       ), envir = .GlobalEnv
)

results_title = paste0('Logistic Reg.', ifelse(is.null(suffix), NULL, paste0(' ', substr(suffix,2, nchar(suffix)))))

if (exists('all_results')){
  all_results <- rbind(all_results, results_title = get(paste0('results', suffix)))
} else{
  assign('all_results', rbind(results_title = get(paste0('results', suffix))), envir = .GlobalEnv)
}

# TO FIX - NOT SAVING PROPERLY...
png(
  paste0('plots/', ifelse(is.null(suffix), NULL, paste0(substr(suffix,2, nchar(suffix)), '_')), 'varImp.png'),
  width = 1500,
  height = 1000
)
p <- plot(varImp(get(paste0('fit_glm', suffix))), top = 30)
p
dev.off()

assign(paste0('pred_glm_test', suffix), predict(get(paste0('fit_glm', suffix)), test_set), envir = .GlobalEnv)

assign(paste0('submission_glm_test', suffix), as.data.frame(cbind(
  get(paste0('pred_glm_test', suffix)) # To adjust if target is transformed
)), envir = .GlobalEnv)

# NEED TO FIND THE WAY TO CHANGE THE COLUMN NAME HERE
# IF FIXED, NEED TO CHANGE HOW THE RESULTS ARE GET LATER
# print(class(get(paste0('submission_glm_test', suffix))))
# print(colnames(get(paste0('submission_glm_test', suffix))))
# print(class(colnames(get(paste0('submission_glm_test', suffix)))))
# colnames(get(paste0('submission_glm_test', suffix))) <- c(colnames(get(paste0('submission_glm_test', suffix))), target)
# print(head(get(paste0('submission_glm_test', suffix))))

write.csv(get(paste0('submission_glm_test', suffix)),
          paste0('submissions/submission_glm', suffix, '.csv'),
          row.names = FALSE)


# Results on Valid Set for untransformed target
assign(paste0('pred_glm_valid', suffix), predict(get(paste0('fit_glm', suffix)), valid_set), envir = .GlobalEnv)

assign(paste0('submission_glm_valid', suffix), cbind(
  target = get(paste0('pred_glm_valid', suffix)) # To adjust if target is transformed
), envir = .GlobalEnv)
print('Passed here')
assign(paste0('real_results', suffix), as.data.frame(cbind(
  'Accuracy' = Accuracy(y_pred = get(paste0('submission_glm_valid', suffix))[, 'target'], y_true = as.numeric(valid_set[, c(target)])),
  'Sensitivity' = Sensitivity(y_pred = get(paste0('submission_glm_valid', suffix))[, 'target'], y_true = as.numeric(valid_set[, c(target)])),
  'Precision' = Precision(y_pred = get(paste0('submission_glm_valid', suffix))[, 'target'], y_true = as.numeric(valid_set[, c(target)])),
  'Recall' = Recall(y_pred = get(paste0('submission_glm_valid', suffix))[, 'target'], y_true = as.numeric(valid_set[, c(target)])),
  'F1 Score' = F1_Score(y_pred = get(paste0('submission_glm_valid', suffix))[, 'target'], y_true = as.numeric(valid_set[, c(target)])),
  'Coefficients' = length(get(paste0('fit_glm', suffix))$finaglmodel$coefficients),
  'Train Time (min)' = round(as.numeric(get(paste0('time_fit_duration', suffix)), units = 'mins'), 1)
)), envir = .GlobalEnv)
print('Passed here too')
if (exists('all_real_results')){
  all_real_results <- rbind(all_real_results, results_title = get(paste0('real_results', suffix)))
} else{
  assign('all_real_results', rbind(results_title = get(paste0('real_results', suffix))), envir = .GlobalEnv)
}


print(paste0(
  ifelse(exists('start_time'), paste0('[', round(
    difftime(Sys.time(), start_time, units = 'mins'), 1
  ), 'm]: '), ''),
  'Logistic Regression is done!', ifelse(is.null(suffix), NULL, paste0(' ', substr(suffix,2, nchar(suffix))))))
}
