####
#### THIS SCRIPT FITS A XGBOOST MODEL AND MAKE PREDICTIONS
####

# Set seed
seed <- ifelse(exists('seed'), seed, 2019)
set.seed(seed)


pipeline_xgbTree <- function(target, train_set, valid_set, test_set,
                         trControl = NULL, tuneGrid = NULL,
                         suffix = NULL, calculate = FALSE, seed = 2019,
                         n_cores = 1){
  
  # Define objects suffix
  suffix <- ifelse(is.null(suffix), NULL, paste0('_', suffix))  
  
  # Default trControl if input is NULL
  if (is.null(trControl)){
    trControl <- trainControl()
  }

  # Dummify the datasets
  dummy_train <- dummyVars(formula = '~.', data = train_set[, !names(train_set) %in% c(target)])
  assign('train_dum', as.data.frame(cbind(
    predict(dummy_train, train_set[, !names(train_set) %in% c(target)]),
    train_set[, target]
  )))
  colnames(train_dum) <- c(colnames(train_dum)[-length(colnames(train_dum))], target)
  train_dum[,target] <- as.factor(train_dum[,target])

  dummy_valid <- dummyVars(formula = '~.', data = valid_set[, !names(valid_set) %in% c(target)])
  assign('valid_dum', as.data.frame(cbind(
    predict(dummy_valid, valid_set[, !names(valid_set) %in% c(target)]),
    valid_set[, target]
  )))
  colnames(valid_dum) <- c(colnames(valid_dum)[-length(colnames(valid_dum))], target)
  valid_dum[,target] <- as.factor(valid_dum[,target])
  
  dummy_test <- dummyVars(formula = '~.', data = test_set[, !names(test_set) %in% c(target)])
  assign('test_dum', as.data.frame(cbind(
    predict(dummy_test, test_set[, !names(test_set) %in% c(target)]),
    test_set[, target]
  )))
  colnames(test_dum) <- c(colnames(test_dum)[-length(colnames(test_dum))], target)
  test_dum[,target] <- as.factor(test_dum[,target])
  
  
    # XGBoost ----
  if (calculate == TRUE) {
    
    # Set up Multithreading
    library(doParallel)
    cl <- makePSOCKcluster(n_cores)
    clusterEvalQ(cl, library(foreach))
    registerDoParallel(cl)
    
    print(paste0(
      ifelse(exists('start_time'), paste0('[', round(
        difftime(Sys.time(), start_time, units = 'mins'), 1
      ),
      'm]: '), ''),
      'Starting XGBoost Model Fit... ',
      ifelse(is.null(suffix), NULL, paste0(' ', substr(
        suffix, 2, nchar(suffix)
      )))
    ))
    
    # Model Training
    time_fit_start <- Sys.time()
    assign(
      paste0('fit_xgbTree', suffix),
      train(
        x = train_dum[, !names(train_dum) %in% c(target)],
        y = train_dum[, target],
        method = 'xgbTree',
        trControl = trControl,
        tuneGrid = tuneGrid,
        metric = 'Accuracy',
        nthread = 1
      )
      , envir = .GlobalEnv) 
    time_fit_end <- Sys.time()
    
    # Stop Multithreading
    stopCluster(cl)
    
    # Save model
    assign(paste0('time_fit_xgbTree', suffix),
           time_fit_end - time_fit_start, envir = .GlobalEnv)
    saveRDS(get(paste0('fit_xgbTree', suffix)), paste0('models/fit_xgbTree', suffix, '.rds'))
    saveRDS(get(paste0('time_fit_xgbTree', suffix)), paste0('models/time_fit_xgbTree', suffix, '.rds'))
  }
  
  # Load Model
  assign(paste0('fit_xgbTree', suffix),
         readRDS(paste0('models/fit_xgbTree', suffix, '.rds')), envir = .GlobalEnv)
  assign(paste0('time_fit_xgbTree', suffix),
         readRDS(paste0('models/time_fit_xgbTree', suffix, '.rds')), envir = .GlobalEnv)
  
  # Predicting against Valid Set with transformed target
  assign(paste0('pred_xgbTree', suffix),
         predict(get(paste0('fit_xgbTree', suffix)), valid_dum), envir = .GlobalEnv)
  
  # Compare Predictions and Valid Set
  assign(paste0('comp_xgbTree', suffix),
         data.frame(obs = valid_dum[,target],
                    pred = get(paste0('pred_xgbTree', suffix))), envir = .GlobalEnv)
  
  # Generate results with transformed target
  assign(paste0('results', suffix),
         as.data.frame(
           cbind(
             rbind(defaultSummary(get(paste0('comp_xgbTree',suffix)))[1]),
             'Sensitivity' = Sensitivity(y_pred = get(paste0('pred_xgbTree', suffix)),
                                         y_true = valid_dum[,target]),
             'Precision' = Precision(y_pred = get(paste0('pred_xgbTree', suffix)),
                                     y_true = valid_dum[,target]),
             'Recall' = Recall(y_pred = get(paste0('pred_xgbTree', suffix)),
                               y_true = valid_dum[,target]),
             'F1 Score' = F1_Score(y_pred = get(paste0('pred_xgbTree', suffix)),
                                   y_true = valid_dum[,target]),
             'Coefficients' = get(paste0('fit_xgbTree', suffix))$finalModel$nfeatures,
             'Train Time (min)' = round(as.numeric(get(paste0('time_fit_xgbTree', suffix)), units = 'mins'), 1),
             'CV | Accuracy' = get_best_result(get(paste0('fit_xgbTree', suffix)))[, 'Accuracy'],
             'CV | Kappa' = get_best_result(get(paste0('fit_xgbTree', suffix)))[, 'Kappa'],
             'CV | AccuracySD' = get_best_result(get(paste0('fit_xgbTree', suffix)))[, 'AccuracySD'],
             'CV | KappaSD' = get_best_result(get(paste0('fit_xgbTree', suffix)))[, 'KappaSD']
           )
         ), envir = .GlobalEnv
  )
  
  # Generate all_results table | with CV and transformed target
  results_title = paste0('XGBoost', ifelse(is.null(suffix), NULL, paste0(' ', substr(suffix,2, nchar(suffix)))))
  
  if (exists('all_results')){
    assign('all_results', rbind(all_results, get(paste0('results', suffix))), envir = .GlobalEnv)
    rownames(all_results) <- c(rownames(all_results)[-length(rownames(all_results))], results_title)
    assign('all_results', all_results, envir = .GlobalEnv)
  } else{
    assign('all_results', rbind(get(paste0('results', suffix))), envir = .GlobalEnv)
    rownames(all_results) <- c(rownames(all_results)[-length(rownames(all_results))], results_title)
    assign('all_results', all_results, envir = .GlobalEnv)
  }
  
  # TO FIX - NOT SAVING PROPERLY...
  # Save Variables Importance plot
  png(
    paste0('plots/', ifelse(is.null(suffix), NULL, paste0(substr(suffix,2, nchar(suffix)), '_')), 'varImp.png'),
    width = 1500,
    height = 1000
  )
  p <- plot(varImp(get(paste0('fit_xgbTree', suffix))), top = 30)
  p
  dev.off()
  
  # Predicting against Test Set
  assign(paste0('pred_xgbTree_test', suffix), predict(get(paste0('fit_xgbTree', suffix)), test_dum), envir = .GlobalEnv)
  
  submissions_test <- as.data.frame(cbind(
    get(paste0('pred_xgbTree_test', suffix)) # To adjust if target is transformed
  ))
  colnames(submissions_test) <- c(target)
  assign(paste0('submission_xgbTree_test', suffix), submissions_test, envir = .GlobalEnv)
  
  # Generating submissions file
  write.csv(get(paste0('submission_xgbTree_test', suffix)),
            paste0('submissions/submission_xgbTree', suffix, '.csv'),
            row.names = FALSE)
  
  
  # Predicting against Valid Set with original target
  assign(paste0('pred_xgbTree_valid', suffix), predict(get(paste0('fit_xgbTree', suffix)), valid_dum), envir = .GlobalEnv)
  
  # Generate real_results with original target
  submissions_valid <- as.data.frame(cbind(
    get(paste0('pred_xgbTree_valid', suffix)) # To adjust if target is transformed
  ))
  colnames(submissions_valid) <- c(target)
  assign(paste0('submission_xgbTree_valid', suffix), submissions_valid, envir = .GlobalEnv)
  
  assign(paste0('real_results', suffix), as.data.frame(cbind(
    'Accuracy' = Accuracy(y_pred = get(paste0('submission_xgbTree_valid', suffix))[, target], y_true = as.numeric(valid_dum[, c(target)])),
    'Sensitivity' = Sensitivity(y_pred = get(paste0('submission_xgbTree_valid', suffix))[, target], y_true = as.numeric(valid_dum[, c(target)])),
    'Precision' = Precision(y_pred = get(paste0('submission_xgbTree_valid', suffix))[, target], y_true = as.numeric(valid_dum[, c(target)])),
    'Recall' = Recall(y_pred = get(paste0('submission_xgbTree_valid', suffix))[, target], y_true = as.numeric(valid_dum[, c(target)])),
    'F1 Score' = F1_Score(y_pred = get(paste0('submission_xgbTree_valid', suffix))[, target], y_true = as.numeric(valid_dum[, c(target)])),
    'Coefficients' = get(paste0('fit_xgbTree', suffix))$finalModel$nfeatures,
    'Train Time (min)' = round(as.numeric(get(paste0('time_fit_xgbTree', suffix)), units = 'mins'), 1)
  )), envir = .GlobalEnv)
  
  # Generate all_real_results table with original target
  if (exists('all_real_results')){
    assign('all_real_results', rbind(all_real_results, results_title = get(paste0('real_results', suffix))), envir = .GlobalEnv)
    rownames(all_real_results) <- c(rownames(all_real_results)[-length(rownames(all_real_results))], results_title)
    assign('all_real_results', all_real_results, envir = .GlobalEnv)
  } else{
    assign('all_real_results', rbind(results_title = get(paste0('real_results', suffix))), envir = .GlobalEnv)
    rownames(all_real_results) <- c(rownames(all_real_results)[-length(rownames(all_real_results))], results_title)
    assign('all_real_results', all_real_results, envir = .GlobalEnv)
  }
  
  
  print(paste0(
    ifelse(exists('start_time'), paste0('[', round(
      difftime(Sys.time(), start_time, units = 'mins'), 1
    ), 'm]: '), ''),
    'XGBoost is done!', ifelse(is.null(suffix), NULL, paste0(' ', substr(suffix,2, nchar(suffix))))))
}
