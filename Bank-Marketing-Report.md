Predicting Term Deposits
================
MBD | ADVANCED R | June 2019

</br>

-----

## Bank Marketing Dataset

The *Bank Marketing* dataset contains the **direct marketing campaigns
of a Portuguese banking institution**. The original dataset can be found
on [Kaggle](https://www.kaggle.com/henriqueyamahata/bank-marketing).

All the files of this project are saved in a [GitHub
repository](https://github.com/ashomah/Bank-Marketing).

The dataset consists in:

  - **Train Set** with 36168 observations with 16 features and the
    target `y`.  
  - **Test Set** with 9043 observations with 16 features. The `y` column
    will be added to the Test Set, with NAs, to ease the pre-processing
    stage.

This project aims to predict if a customer will subscribe to a bank term
deposit, based on its features and call history.

</br>

-----

## Packages

<span data-styling="font:&#39;red&#39;">This analysis requires these R
packages:</span>

  - Data Manipulation: `data.table`, `dplyr`, `tibble`, `tidyr`

  - Plotting: `corrplot`, `GGally`, `ggmap`, `ggplot2`, `grid`,
    `gridExtra`

  - Machine Learning: `caret`, `dbscan`, `glmnet`, `leaderCluster`,
    `MLmetrics`, `ranger`, `xgboost`

  - Multithreading: `doMC`, `doParallel`, `factoextra`, `foreach`,
    `parallel`

  - Reporting: `kableExtra`, `knitr`, `RColorBrewer`, `shiny`, and…
    `beepr`.

These packages are installed and loaded if necessary by the main script.

</br>

-----

## Data Preparation

The dataset is pretty clean…

</br>

-----

## Exploratory Data Analysis

The target of this analysis is…

</br>

-----

## Data Preparation

</br>

-----

## Cross-Validation Strategy

To validate the stability of our models, we will apply a 10-fold
cross-validation, repeated 3 times.

</br>

-----

## Baseline

</br>

-----

## Feature Engineering

</br>

-----

## Feature Selection with Lasso and RFE

</br>

-----

## Tuning

</br>

-----

## Final Model

The best model
for…

<br><br>

-----

###### *Nayla Fakhoury | Martin Hofbauer | Andres Llerena | Francesca Manoni | Paul Jacques-Mignault | Ashley O’Mahony | Stavros Tsentemeidis*

###### *O17 (Group G) | Master in Big Data and Business Analytics | Oct 2018 Intake | IE School of Human Sciences and Technology*

-----
