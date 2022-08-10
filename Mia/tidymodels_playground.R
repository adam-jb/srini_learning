

# hierarchical linear models; perhaps in time series
# statistic test for whether data has any time clustering

# multilevel regression: https://www.coursera.org/lecture/mlm/multilevel-regression-in-r-hAIUy





# make model on all data
# feature engineering
# scaling data so centred around each individual


# fixed effects
# sensitivity metric for model


# step_zv



library(tidymodels)
library(dplyr)
library(ggplot2)


# time series, binary sequence





### imputation options beyond step_impute_linear():
# step_impute_bag     bagged tree models
step_impute_knn
step_impute_median

# ideographic models



# imputing data
data(ames, package = "modeldata")

ames_missing <- ames
ames_missing$Longitude[sample(1:nrow(ames), 200)] <- NA

imputed_ames <-
  recipe(Sale_Price ~ ., data = ames_missing) %>%
  step_impute_linear(
    Longitude,
    impute_with = imp_vars(Latitude, Neighborhood, MS_Zoning, Alley)
  ) %>%
  prep(ames_missing)

# automatically populates NA values with imputed values
imputed <- bake(imputed_ames, new_data = ames_missing)
sum(is.na(imputed$Longitude))


# join to original data to compare
imputed_to_compare <- imputed %>%
  dplyr::rename(imputed = Longitude) %>%
  bind_cols(ames %>% dplyr::select(original = Longitude)) %>%
  bind_cols(ames_missing %>% dplyr::select(Longitude)) %>%
  dplyr::filter(is.na(Longitude))


ggplot(imputed_to_compare, aes(x = original, y = imputed)) +
  geom_abline(col = "green") +
  geom_point(alpha = .3) +
  coord_equal() +
  labs(title = "Imputed Values")







# Recipe ------------------------------------------------------------------

mod_recipe <- recipe(
  Sepal.Length  ~ .
  , data = iris
) %>%
  step_dummy(Species, -all_outcomes())


tune_spec <- 
  linear_reg(
    penalty = tune()   # uses MAE to tune hyperparams
    , mixture = tune()
  )

lr_wf <- workflow() %>%
  add_model(tune_spec) %>%
  add_recipe(mod_recipe)


# train workflow, make prediction, extract pred column, and plot against original
fit(lr_wf, data=iris[1:100,]) %>%
  predict(iris[101:150,]) %>%
  pluck('.pred') %>%
  plot(iris$Sepal.Length[101:150])





# Making train test split -------------------------------------------------

split_iris <- initial_split(iris, prop = 0.8, strata = 'Sepal.Length')
train_set <- training(split_iris)
test_set <- testing(split_iris)







# VIF ---------------------------------------------------------------------

library(car)
lm(Sepal.Length ~ ., iris %>% select(-Species)) %>%
  vif() %>%
  barplot(main = "VIF Values", horiz = F, col = "steelblue")
abline(h = 5, lwd = 3, lty = 2)x





# iris median impute all cols ---------------------------------------------

iris_for_impute <- iris
iris_for_impute[c(1, 51, 101),1:4] <- NA_real_  # make a row NA for each category

imputed_ames <-
  recipe(Sepal.Length ~ ., data = iris_for_impute) %>%
  step_impute_linear(
    Sepal.Width,
    #all_numeric_predictors(),   # doesnt impute Sepal.Length as its target in recipe
    impute_with = imp_vars(Species)
  ) %>%
  prep(iris_for_impute)

imputed <- bake(imputed_ames, new_data = iris_for_impute) %>% head()

imputed[1:10,]
imputed[49:53,]




# BMLM --------------------------------------------------------------------


library(bmlm)












