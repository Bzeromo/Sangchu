from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
import data_load
import normalization

X = normalization.X
y = normalization.y

# 데이터를 학습 세트와 테스트 세트로 나눔
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 랜덤 포레스트 모델을 사용하여 테스트 세트에 대한 예측 수행
model = RandomForestRegressor()
model.fit(X_train, y_train)
y_pred = model.predict(X_test)

# 성능 지표 계산
print("====== 랜덤 포레스트 측정값 =====")
mse = mean_squared_error(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)
r_squared = r2_score(y_test, y_pred)

# 결과 출력
print("Mean Squared Error (MSE):", mse)
print("Mean Absolute Error (MAE):", mae)
print("R-squared:", r_squared)
import numpy as np

# 실제값과 예측값을 인자로 받아 MAPE를 계산하는 함수
def mape(y_true, y_pred):
    return np.mean(np.abs((y_true - y_pred) / y_true)) * 100

# 예측값과 실제값을 가지고 MAPE 계산
mape_value = mape(y_test, y_pred)
print("MAPE:", mape_value)