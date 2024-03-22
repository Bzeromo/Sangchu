import statsmodels.api as sm
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.linear_model import LinearRegression
import data_load
import normalization

X = normalization.X
y = normalization.y

# 데이터를 학습 세트와 테스트 세트로 나눔
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)


# 선형 회귀 모델을 사용하여 테스트 세트에 대한 예측 수행
lr = LinearRegression()
lr.fit(X_train, y_train)
y_pred = lr.predict(X_test)

# 성능 지표 계산
mse = mean_squared_error(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)
r_squared = r2_score(y_test, y_pred)

# 결과 출력
print("====== 선형 회귀 측정값 =====")
print("Mean Squared Error (MSE):", mse)
print("RMSE:", mse**0.5)
print("Mean Absolute Error (MAE):", mae)
print("R-squared:", r_squared)
import numpy as np

# 실제값과 예측값을 인자로 받아 MAPE를 계산하는 함수
def mape(y_true, y_pred):
    return np.mean(np.abs((y_true - y_pred) / y_true)) * 100

# 예측값과 실제값을 가지고 MAPE 계산
mape_value = mape(y_test, y_pred)
print("MAPE:", mape_value)

# # Statsmodels를 사용한 선형 회귀 분석
# X = sm.add_constant(X)  # 상수항 추가
# results = sm.OLS(y, X).fit()
# print(results.summary())
# print(merged_data)