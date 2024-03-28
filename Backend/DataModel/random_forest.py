import pandas as pd
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
import normalization

X = normalization.X
y = normalization.y

# 데이터를 학습 세트와 테스트 세트로 나눔
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 랜덤 포레스트 모델을 사용하여 테스트 세트에 대한 예측 수행
# 하이퍼 파라미터 적용
model = RandomForestRegressor(n_estimators=100, max_depth=20, random_state=42)
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

# 각 독립 변수의 중요도와 이름 출력
importances = model.feature_importances_
feature_names = X_train.columns
df_feature_importance = pd.DataFrame({'Feature': feature_names, 'Importance': importances})

for name, importance in zip(feature_names, importances):
    print(f"Feature '{name}': Importance = {importance}")

# CSV 파일로 저장
df_feature_importance.to_csv('feature_importance.csv', index=False)