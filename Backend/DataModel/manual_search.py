from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
import data_load
import normalization

X = normalization.X
y = normalization.y

# 데이터 분할
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

best_mae = float('inf')
best_params = {}

# 하이퍼파라미터 탐색 범위 설정
n_estimators_range = [50, 100, 150]  # 트리의 개수
max_depth_range = [None, 5, 10, 20]   # 각 트리의 최대 깊이

# 수동 탐색
for n_estimators in n_estimators_range:
    for max_depth in max_depth_range:
        # 랜덤 포레스트 모델 초기화
        model = RandomForestRegressor(n_estimators=n_estimators, max_depth=max_depth, random_state=42)
        
        # 모델을 훈련 데이터로 훈련시킴
        model.fit(X_train, y_train)
        
        # 테스트 데이터에 대해 예측을 수행하고 MAE 계산
        y_pred = model.predict(X_test)
        mae = mean_absolute_error(y_test, y_pred)
        
        # 현재 하이퍼파라미터 조합의 성능 출력
        print(f"n_estimators: {n_estimators}, max_depth: {max_depth}, MAE: {mae}")
        
        # 현재 하이퍼파라미터 조합이 더 나은지 확인하고 갱신
        if mae < best_mae:
            best_mae = mae
            best_params = {'n_estimators': n_estimators, 'max_depth': max_depth}

print("Best Parameters:", best_params)
print("Best MAE:", best_mae)

import numpy as np

# 실제값과 예측값을 인자로 받아 MAPE를 계산하는 함수
def mape(y_true, y_pred):
    return np.mean(np.abs((y_true - y_pred) / y_true)) * 100

# 예측값과 실제값을 가지고 MAPE 계산
mape_value = mape(y_test, y_pred)
print("MAPE:", mape_value)
