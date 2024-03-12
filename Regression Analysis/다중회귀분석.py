import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
from sklearn import datasets
from sklearn.linear_model import LinearRegression

data = datasets.load_diabetes()

df = pd.DataFrame(data['data'], index = data['target'], columns = data['feature_names'])
lr = LinearRegression()

y= df.index.values
X = df.loc[:, ['bmi', 'age', 'sex']].values
lr.fit(X, y)

results = sm.OLS(y, sm.add_constant(X)).fit()
print(results.summary())