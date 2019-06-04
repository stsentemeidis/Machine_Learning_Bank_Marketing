####
#### THIS SCRIPT FITS A LOGISTIC REGRESSION MODEL AND MAKE PREDICTIONS
####

# Set seed
seed <- ifelse(exists('seed'), seed, 2019)
set.seed(seed)


pipeline_glm <- function(target, train_set, valid_set, test_set,
                         trControl = NULL, tuneGrid = NULL,
                         suffix = NULL, calculate = FALSE, seed = 2019,
                         n_cores = 1){
  
  # Define objects suffix
  suffix <- ifelse(is.null(suffix), NULL, paste0('_', suffix))  
  
  # Default trControl if input is NULL
  if (is.null(trControl)){
    trControl <- trainControl()
  }
  
  # Logistic Regression ----
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
      'Starting Logistic Regression Model Fit... ',
      ifelse(is.null(suffix), NULL, paste0(' ', substr(
        suffix, 2, nchar(suffix)
      )))
    ))
    
    # Model Training
    time_fit_start <- Sys.time()
    assign(
      paste0('fit_glm', suffix),
      train(
        x = train_set[, !names(train_set) %in% c(target)],
        y = train_set[, target],
        method = 'glm',
        trControl = trControl,
        tuneGrid = tuneGrid,
        metric = 'Accuracy'
      )
      , envir = .GlobalEnv) 
    time_fit_end <- Sys.time()
    
    # Stop Multithreading
    stopCluster(cl)
    
    # Save model
    assign(paste0('time_fit_glm', suffix),
           time_fit_end - time_fit_start, envir = .GlobalEnv)
    saveRDS(get(paste0('fit_glm', suffix)), paste0('models/fit_glm', suffix, '.rds'))
    saveRDS(get(paste0('time_fit_glm', suffix)), paste0('models/time_fit_glm', suffix, '.rds'))
  }
  
  # Load Model
  assign(paste0('fit_glm', suffix),
         readRDS(paste0('models/fit_glm', suffix, '.rds')), envir = .GlobalEnv)
  assign(paste0('time_fit_glm', suffix),
         readRDS(paste0('models/time_fit_glm', suffix, '.rds')), envir = .GlobalEnv)
  
  # Predicting against Valid Set with transformed target
  assign(paste0('pred_glm', suffix),
         predict(get(paste0('fit_glm', suffix)), valid_set, type = 'prob'), envir = .GlobalEnv)
  assign(paste0('pred_glm_prob', suffix), get(paste0('pred_glm', suffix)), envir = .GlobalEnv)
  assign(paste0('pred_glm', suffix), get(paste0('pred_glm_prob', suffix))$No, envir = .GlobalEnv)
  assign(paste0('pred_glm', suffix), ifelse(get(paste0('pred_glm', suffix)) > 0.5, 0, 1), envir = .GlobalEnv)
  
  # Compare Predictions and Valid Set
  valid_set[,target] <- ifelse(valid_set[,target]=='No',0,1)
  assign(paste0('comp_glm', suffix),
         data.frame(obs = valid_set[,target],
                    pred = get(paste0('pred_glm', suffix))), envir = .GlobalEnv)
  
  # Generate results with transformed target
  assign(paste0('results', suffix),
         as.data.frame(
           rbind(
             cbind('Accuracy' = Accuracy(y_pred = get(paste0('pred_glm', suffix)),
                                         y_true = valid_set[,target]),
             'Sensitivity' = Sensitivity(y_pred = get(paste0('pred_glm', suffix)),
                                         y_true = valid_set[,target]),
             'Precision' = Precision(y_pred = get(paste0('pred_glm', suffix)),
                                     y_true = valid_set[,target]),
             'Recall' = Recall(y_pred = get(paste0('pred_glm', suffix)),
                               y_true = valid_set[,target]),
             'F1 Score' = F1_Score(y_pred = get(paste0('pred_glm', suffix)),
                                   y_true = valid_set[,target]),
             'AUC'      = AUC::auc(AUC::roc(as.numeric(valid_set[,target]), as.factor(get(paste0('pred_glm', suffix))))),
             'Coefficients' = length(get(paste0('fit_glm', suffix))$finalModel$coefficients),
             'Train Time (min)' = round(as.numeric(get(paste0('time_fit_glm', suffix)), units = 'mins'), 1),
             'CV | Accuracy' = get_best_result(get(paste0('fit_glm', suffix)))[, 'Accuracy'],
             'CV | Kappa' = get_best_result(get(paste0('fit_glm', suffix)))[, 'Kappa'],
             'CV | AccuracySD' = get_best_result(get(paste0('fit_glm', suffix)))[, 'AccuracySD'],
             'CV | KappaSD' = get_best_result(get(paste0('fit_glm', suffix)))[, 'KappaSD']
           )
         ), envir = .GlobalEnv
    )
  )
  
  # Generate all_results table | with CV and transformed target
  results_title = paste0('Logistic Reg.', ifelse(is.null(suffix), NULL, paste0(' ', substr(suffix,2, nchar(suffix)))))
  
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
    paste0('plots/fit_glm_', ifelse(is.null(suffix), NULL, paste0(substr(suffix,2, nchar(suffix)), '_')), 'varImp.png'),
    width = 1500,
    height = 1000
  )
  p <- plot(varImp(get(paste0('fit_glm', suffix))), top = 30)
  p
  dev.off()
  
  # Predicting against Test Set
  assign(paste0('pred_glm_test', suffix), predict(get(paste0('fit_glm', suffix)), test_set), envir = .GlobalEnv)
  
  submissions_test <- as.data.frame(cbind(
    get(paste0('pred_glm_test', suffix)) # To adjust if target is transformed
  ))
  colnames(submissions_test) <- c(target)
  assign(paste0('submission_glm_test', suffix), submissions_test, envir = .GlobalEnv)
  
  # Generating submissions file
  write.csv(get(paste0('submission_glm_test', suffix)),
            paste0('submissions/submission_glm', suffix, '.csv'),
            row.names = FALSE)
  
  
  # Predicting against Valid Set with original target
  assign(paste0('pred_glm_valid', suffix), predict(get(paste0('fit_glm', suffix)), valid_set), envir = .GlobalEnv)
  
  # Generate real_results with original target
  submissions_valid <- as.data.frame(cbind(
    get(paste0('pred_glm_valid', suffix)) # To adjust if target is transformed
  ))
  colnames(submissions_valid) <- c(target)
  submissions_valid[,'y'] <- ifelse(submissions_valid[,'y']=='1',0,1)
  assign(paste0('submission_glm_valid', suffix), submissions_valid, envir = .GlobalEnv)
  
  assign(paste0('real_results', suffix), as.data.frame(cbind(
    'Accuracy' = Accuracy(y_pred = get(paste0('submission_glm_valid', suffix))[, target], y_true = as.numeric(valid_set[, c(target)])),
    'Sensitivity' = Sensitivity(y_pred = get(paste0('submission_glm_valid', suffix))[, target], y_true = as.numeric(valid_set[, c(target)])),
    'Precision' = Precision(y_pred = get(paste0('submission_glm_valid', suffix))[, target], y_true = as.numeric(valid_set[, c(target)])),
    'Recall' = Recall(y_pred = get(paste0('submission_glm_valid', suffix))[, target], y_true = as.numeric(valid_set[, c(target)])),
    'F1 Score' = F1_Score(y_pred = get(paste0('submission_glm_valid', suffix))[, target], y_true = as.numeric(valid_set[, c(target)])),
    'AUC'      = AUC::auc(AUC::roc(as.numeric(valid_set[, c(target)]), as.factor(get(paste0('submission_glm_valid', suffix))[, target]))),
    'Coefficients' = length(get(paste0('fit_glm', suffix))$finalModel$coefficients),
    'Train Time (min)' = round(as.numeric(get(paste0('time_fit_glm', suffix)), units = 'mins'), 1)
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
  
  # PLOT ROC
  roc_glm <- roc(as.numeric(valid_set[, c(target)]), as.numeric(get(paste0('submission_glm_valid', suffix))[, target]))
  assign(paste0('roc_object_glm', suffix), roc_glm,  envir = .GlobalEnv)
  plot(get(paste0('roc_object_glm', suffix)), col=color4, lwd=4, main="ROC Curve GLM")
  
  # Density Plot
  prob_glm <- get(paste0('pred_glm_prob', suffix))
  prob_glm<- melt(prob_glm)
  assign(paste0('density_plot_glm', suffix), ggplot(prob_glm,aes(x=value, fill=variable)) + geom_density(alpha=0.25)+
    theme_tufte(base_size = 5, ticks=F)+ 
    ggtitle(paste0('Density Plot glm', suffix))+
    theme(plot.margin = unit(c(10,10,10,10),'pt'),
          axis.title=element_blank(),
          axis.text = element_text(colour = color2, size = 9, family = font2),
          axis.text.x = element_text(hjust = 1, size = 9, family = font2),
          plot.title = element_text(size = 15, face = "bold", hjust = 0.5), 
          plot.background = element_rect(fill = color1)), envir = .GlobalEnv)
  
  get(paste0('density_plot_glm', suffix))
  
  # Confusion Matrix
  cm_glm <- confusionMatrix(as.factor(get(paste0('submission_glm_valid', suffix))[, target]), as.factor(valid_set[, c(target)]))
  cm_plot_glm <- fourfoldplot(cm_glm$table)
  assign(paste0('cm_plot_glm', suffix), cm_plot_glm, envir = .GlobalEnv)
  get(paste0('cm_plot_glm', suffix))

  print(paste0(
    ifelse(exists('start_time'), paste0('[', round(
      difftime(Sys.time(), start_time, units = 'mins'), 1
    ), 'm]: '), ''),
    'Logistic Regression is done!', ifelse(is.null(suffix), NULL, paste0(' ', substr(suffix,2, nchar(suffix))))))
}
