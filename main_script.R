####
#### THIS SCRIPT CALLS ALL SUB-SCRIPTS TO READ AND PREPARE THE DATASET,
#### RUN THE ANALYSIS AND OUTPUT RELEVANT DATA FILES
####

start_time <- Sys.time()
print(paste0('---START--- Starting at ', start_time))

options(warn = 0) # -1 to hide the warnings
seed <- 2019
set.seed(seed)

# Install Necessary Packages ----
source('scripts/install_packages.R')

# Read and Format Dataset ----
source('scripts/read_format_data.R')

# # Exploratory Data Analysis ----
# source('scripts/eda.R')
#
# # Parameters of Baseline ----
# source('scripts/param_baseline.R')
#
# # Baseline Linear Regression ----
# calculate <- FALSE
# source('scripts/model_baseline_lm.R')
#
# # Feature Engineering Renovation ----
# source('scripts/feateng_renovation.R')
#
# # XGBoost Feature Engineering ----
# calculate <- FALSE
# source('scripts/model_xgb_FE.R')
#
# # Feature Selection Lasso ----
# source('scripts/featsel_lasso.R')
#
# # Feature Selection RFE ----
# calculate <- FALSE
# source('scripts/featsel_rfe.R')
#
# # XGBoost Post RFE ----
# calculate <- FALSE
# source('scripts/model_xgb_rfe.R')
#
# # XGBoost Tuning ----
# calculate <- FALSE
# source('scripts/model_tuning_xgb.R')
#
# # Save RData for RMarkdown ----
# save(
#   list = c(
#     'raw_hp_train',
#     'raw_hp_test',
#     'hp_train',
#     'hp_test',
#     'hp_train_A',
#     'hp_train_A_FE2',
#     'hp_train_B',
#     'long_lat',
#     'houses_sold_multi_times_train',
#     'houses_train',
#     'houses_sold_multi_times_test',
#     'houses_test',
#     'all_results',
#     'all_real_results',
#     'varsSelected',
#     'varsNotSelected',
#     'dbscan_clusters_train_A',
#     'dbscan_clusters_train_B',
#     'cluster_plot_A',
#     'cluster_plot_B',
#     'hp_fit_baseline_xgb_log_all_fact',
#     'hp_fit_baseline_ranger_log',
#     'hp_fit_xgb_FE',
#     'hp_fit_baseline_ranger_log_all_fact',
#     'results_rfe',
#     'varImp_rfe',
#     'var_sel_rfe',
#     'hp_train_A_rfe',
#     'hp_train_B_rfe',
#     'hp_test_rfe',
#     'hp_fit_xgb_tuning',
#     'hp_fit_ranger_tuning',
#     'residuals_xgb_tuning',
#     'submission_xgb_tuning_train_B'
#   ),
#   file = 'data_output/RMarkdown_Objects.RData'
# )
#
# save.image(file = 'data_output/ALL.RData')

print(paste0('[', round(
  difftime(Sys.time(), start_time, units = 'mins'), 1
), 'm]: ',
'All operations are over!'))

# # Render RMarkdown Report ----
# if (is.null(webshot:::find_phantom())) {
#   webshot::install_phantomjs()
# }
# invisible(
#   rmarkdown::render(
#     'Bank-Marketing-Report.Rmd',
#     'github_document',
#     params = list(shiny = FALSE),
#     runtime = 'static'
#   )
# )
# invisible(
#   rmarkdown::render(
#     'Bank-Marketing-Report.Rmd',
#     'html_document',
#     params = list(shiny = FALSE)
#   )
# )
# # invisible(rmarkdown::run('Bank-Marketing-Report.Rmd'))

# beep(8)
#
# print(paste0('[', round(
#   difftime(Sys.time(), start_time, units = 'mins'), 1
# ), 'm]: ',
# 'Report generated! ---END---'))
