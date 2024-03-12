import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
from sklearn import datasets
from sklearn.linear_model import LinearRegression

data = datasets.load_diabetes()

df = pd.DataFrame(data['data'], index = data['target'], columns = data['feature_names'])
lr = LinearRegression()

y= df.index.values.reshape(-1, 1)
X = df.bmi.values.reshape(-1, 1)
lr.fit(X, y)

results = sm.OLS(y, sm.add_constant(X)).fit()
print(results.summary())

plt.scatter(X, y)
plt.plot(X, lr.predict(X), color='red')
plt.title('y = {}*x + {}'.format(lr.coef_[0], lr.intercept_))
plt.show()