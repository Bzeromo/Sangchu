import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib import style
import matplotlib
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import data_transform.sales as sales

##### 그래프 그리기 #####
style.use('seaborn-talk')

krfont = {'family' :'Malgun Gothic', 'weight':'bold', 'size': 10}
matplotlib.rc('font', **krfont)
matplotlib.rcParams['axes.unicode_minus'] = False

# 데이터 불러오기
df_X = sales.df_sales
df_Y = sales.df_sales
# merged_data = pd.merge(df_Y, df_X, on=['year_quarter_code', 'commercial_district_code'], how='left')
merged_data = df_X
# 결측값이 포함된 행 제거
merged_data.dropna(inplace=True)

X = merged_data['monthly_sales_previous']
y = merged_data['monthly_sales_now']

X = X.values.reshape(-1, 1)
y = y.values

# 데이터 분할
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# # print(X)
# 선형 회귀 모델 학습   
lr = LinearRegression()
lr.fit(X_train, y_train)

# 선형 회귀 모델을 사용하여 테스트 세트에 대한 예측 수행
y_lr_pred = lr.predict(X_test)

# 성능 지표 계산
mse = mean_squared_error(y_test, y_lr_pred)
mae = mean_absolute_error(y_test, y_lr_pred)
r_squared = r2_score(y_test, y_lr_pred)

# 결과 출력
print("========== 선형 회귀 성능 평가 ========")
print("Mean Squared Error (MSE):", mse)                     
print("Mean Absolute Error (MAE):", mae)
print("R-squared:", r_squared)
print()

# 다항 회귀 모델 학습 (2차 다항식)
poly = PolynomialFeatures(degree=2)
X_poly = poly.fit_transform(X_train)
lr_poly = LinearRegression()
lr_poly.fit(X_poly, y_train)

# 다항 회귀 모델을 사용하여 테스트 세트에 대한 예측 수행
X_test_poly = poly.transform(X_test)
y_poly_pred = lr_poly.predict(X_test_poly)

# 성능 지표 계산
mse = mean_squared_error(y_test, y_poly_pred)
mae = mean_absolute_error(y_test, y_poly_pred)
r_squared = r2_score(y_test, y_poly_pred)

# 결과 출력
print("========== 다항 회귀 성능 평가 ========")
print("Mean Squared Error (MSE):", mse)
print("Mean Absolute Error (MAE):", mae)
print("R-squared:", r_squared)

# 그래프 객체 및 서브플롯 생성
fig, axs = plt.subplots(1, 2, figsize=(15, 6))

# 선점도와 선형 회귀 직선 그리기
axs[0].scatter(X, y, color='blue', label='Scatter Plot')
axs[0].plot(X, lr.predict(X), color='red', label='Linear Regression')
axs[0].set_title('Scatter Plot with Linear Regression')
axs[0].set_xlabel('Monthly Sales (Previous)')
axs[0].set_ylabel('Monthly Sales (Now)')
axs[0].legend()
axs[0].grid(True)

# 다항 회귀 그래프 그리기
axs[1].scatter(X, y, color='blue', label='Scatter Plot')
X_fit = np.linspace(X.min(), X.max(), 100).reshape(-1, 1)
X_fit_poly = poly.transform(X_fit)
axs[1].plot(X_fit, lr_poly.predict(X_fit_poly), color='green', label='Polynomial Regression (degree=2)')
axs[1].set_title('Scatter Plot with Polynomial Regression')
axs[1].set_xlabel('Monthly Sales (Previous)')
axs[1].set_ylabel('Monthly Sales (Now)')
axs[1].legend()
axs[1].grid(True)

# 그래프 표시
plt.tight_layout()
plt.show()