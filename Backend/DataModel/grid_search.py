from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestRegressor
import normalization

X = normalization.X
y = normalization.y

# 탐색할 하이퍼파라미터 그리드 생성
param_grid = {
    'n_estimators': [50, 100, 150],
    'criterion': ['mse', 'mae'],
    'max_depth': [None, 5, 10, 20],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4],
    'max_features': ['auto', 'sqrt', 'log2', None],
    'bootstrap': [True, False],
}

# 그리드 탐색 객체 생성
grid_search = GridSearchCV(RandomForestRegressor(), param_grid, cv=5, scoring='neg_mean_absolute_error', verbose=2)

# 그리드 탐색 실행
grid_search.fit(X, y)

# 최적의 하이퍼파라미터와 최적의 성능 출력
print("Best Parameters:", grid_search.best_params_)
print("Best MAE:", -grid_search.best_score_)  # negative mean absolute error 사용