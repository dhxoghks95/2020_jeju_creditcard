#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
from xgboost import XGBRegressor
from lightgbm import LGBMRegressor
from math import sqrt


# In[5]:


data=pd.read_csv('C:/Users/USER/Desktop/2020 summer dacon/2020_jeju_credit card/data/20200722 이후/april_add_merge_with_homeproportion.csv',encoding = 'CP949')


# In[6]:


data.shape


# In[7]:


data.head(10)


# In[11]:


# DataFrame.dtypes for data must be int, float or bool.
# Did not expect the data types in the following fields
# : CARD_SIDO_NM, STD_CLSS_NM, HOM_SIDO_NM, AGE
cat_features = ['CARD_SIDO_NM', 'STD_CLSS_NM', 'HOM_SIDO_NM','AGE']
for i in enumerate (cat_features) : 
    ca = i[1] 
    data[ca] = data[ca].astype('category') 


# In[14]:


X = data.drop(columns=['AMT'])
y = data['AMT']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, shuffle=False,random_state=2020)
X_train.shape


# In[15]:


X_train.columns = ["".join (c if c.isalnum() else "_" for c in str(x)) for x in X_train.columns]
X_test.columns = ["".join (c if c.isalnum() else "_" for c in str(x)) for x in X_test.columns]


# lightgbm

# In[ ]:


params_grid = {
    'num_leaves': [31, 127],
    'reg_alpha': [0.1, 0.5],
    'min_data_in_leaf': [30, 50, 100, 300, 400],
    'lambda_l1': [0, 1, 1.5],
    'lambda_l2': [0, 1]
    }
lgb = LGBMRegressor(boosting_type='gbdt', num_boost_round=2000, learning_rate=0.01)
lgb_grid = GridSearchCV(estimator=lgb,
                        param_grid=params_grid,
                        n_jobs=10,
                        verbose=3)
lgb_grid.fit(X_train,y_train)


# In[ ]:


lgb_grid.best_params_


# In[ ]:


y_pred4 = lgb_grid.predict(X_test)
lgb_rmse = sqrt(mean_squared_error(y_test, y_pred4))
lgb_rmse


# In[ ]:


lgb_feature_importance = lgb_grid.best_estimator_.feature_importances_
lgb_feature_imp = pd.Series(lgb_feature_importance,index=X_train.columns).sort_values(ascending=False)
lgb_feature_imp


# In[ ]:


plt.figure(figsize=(12,10))
plt.title("LGB feature Importance")
sns.barplot(x=lgb_feature_imp[0:30], y=lgb_feature_imp.index[0:30])

