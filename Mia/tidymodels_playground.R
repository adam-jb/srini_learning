
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










