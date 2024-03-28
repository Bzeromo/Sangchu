from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
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
    'min_weight_fraction_leaf': [0.0, 0.1, 0.2],
    'max_features': ['auto', 'sqrt', 'log2', None],
    'max_leaf_nodes': [None, 10, 20, 50],
    'min_impurity_decrease': [0.0, 0.1, 0.2],
    'bootstrap': [True, False],
    'oob_score': [True, False],
    'n_jobs': [None, -1],
    'random_state': [None, 42],
    'verbose': [0, 1, 2],
    'warm_start': [True, False],
    'ccp_alpha': [0.0, 0.1, 0.2]
}

# 그리드 탐색 객체 생성
grid_search = GridSearchCV(RandomForestRegressor(), param_grid, cv=5, scoring='neg_mean_absolute_error', verbose=2)

# 그리드 탐색 실행
grid_search.fit(X, y)

# 최적의 하이퍼파라미터와 최적의 성능 출력
print("Best Parameters:", grid_search.best_params_)
print("Best MAE:", -grid_search.best_score_)  # negative mean absolute error 사용