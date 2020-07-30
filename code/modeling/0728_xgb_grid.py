import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import mean_squared_error
from xgboost import XGBRegressor
from math import sqrt

print("\nNEW")
print("START!!")
data=pd.read_csv('../april_add_merge_with_homeproportion.csv', encoding ='CP949')

cat_features = ['CARD_SIDO_NM', 'STD_CLSS_NM', 'HOM_SIDO_NM','AGE']
for cat in cat_features:
    data[cat] = data[cat].astype('category')

data = pd.get_dummies(data)

X = data.drop(columns=['AMT', "CNT", "CSTMR_CNT", "Unnamed: 0"])
y = np.log1p(data['AMT'])
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, shuffle=False, random_state=2020)

X_train.columns = ["".join (c if c.isalnum() else "_" for c in str(x)) for x in X_train.columns]
X_test.columns = ["".join (c if c.isalnum() else "_" for c in str(x)) for x in X_test.columns]

colsample_bytree = [0.5, 0.7, 1]
subsample = [0, 0.5, 1]
gamma = [0, 2]
learning_rate = [0.01, 0.05, 0.1]
n_estimators = [200, 300, 400, 500]

param_grid = dict(learning_rate = learning_rate,
                  n_estimators=n_estimators, colsample_bytree = colsample_bytree, subsample = subsample, gamma = gamma)

xgb_greedy_model = XGBRegressor(gpu_id = 3, tree_method = 'gpu_hist')

print("GRID SEARCH START")
grid_search = GridSearchCV(xgb_greedy_model, param_grid, scoring= "neg_mean_squared_error")
grid_result = grid_search.fit(X_train, y_train)

print("\nBest: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
means = -grid_result.cv_results_['mean_test_score']
stds = grid_result.cv_results_['std_test_score']
params = grid_result.cv_results_['params']
for mean, stdev, param in zip(means, stds, params):
    print("\n%f (%f) with: %r" % (mean, stdev, param))


real_pred = grid_search.predict(X_test)
xgb_rmse = sqrt(mean_squared_error(y_test, real_pred))
print("XGB RMSE : ", xgb_rmse)

xgb_feature_importance = grid_search.best_estimator_.feature_importances_
print("XGB FEATURE IMPORTANCE : ")

indices = np.argsort(xgb_feature_importance)[::-1]
for f in range(X.shape[1]):
    print(X.columns[indices[f]] ," : ", xgb_feature_importance[indices[f]])

