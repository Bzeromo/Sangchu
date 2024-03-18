import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import sales
import commercial_change
import store
import resident_population
import foot_traffic
import area
import facilities
import working_population

##### 데이터 조회 ######
# 추정매출-상권 데이터 로드
df_sales = sales.df_sales

# 상권변화지표-상권 데이터 로드
df_commercial_change = commercial_change.df_commercial_change
merged_data = pd.merge(df_sales, df_commercial_change, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 점포-상권 데이터 로드
df_store = store.df_store
merged_data = pd.merge(merged_data, df_store, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 상주인구-상권 데이터 로드
df_resident_population = resident_population.df_resident_population
merged_data = pd.merge(merged_data, df_resident_population, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 길단위인구-상권 데이터 로드
df_foot_traffic = foot_traffic.df_foot_traffic
merged_data = pd.merge(merged_data, df_foot_traffic, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 영역-상권 데이터 로드
df_area = area.df_area
merged_data = pd.merge(merged_data, df_area, on='commercial_district_code', how='left')

# 집객시설-상권 데이터 로드
df_facilities = facilities.df_facilities
merged_data = pd.merge(merged_data, df_facilities, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 직장인구-상권 데이터 로드
df_working_population = working_population.df_working_population
merged_data = pd.merge(merged_data, df_working_population, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 아파트-상권 데이터 로드
df_apartment = pd.read_csv('아파트-상권.csv', encoding='cp949')

# 소득-상권 데이터 로드
df_income = pd.read_csv('소득-상권.csv', encoding='cp949')

# 독립 변수 선택
# X = merged_data[['monthly_sales_previous', 'rdi_previous', '점포수_previous', 'total_resident_population_previous', 'total_foot_traffic_previous', 'store_density_previous', 'area_size', 'rdi변화', '유동인구변화', '점포밀도변화', '상주인구변화', '점포밀도변화제곱', '유동인구변화제곱', 'rdi변화제곱']]
X = merged_data[['monthly_sales_previous', 'rdi_previous', '점포수_previous', 'total_resident_population_previous', 'total_foot_traffic_previous', 'store_density_previous', 'area_size', 'facilities_previous', 'total_working_population_previous', 'rdi변화', '유동인구변화', '점포밀도변화', '상주인구변화', '집객시설변화', '직장인구변화']].copy()

# 종속 변수 선택
y = merged_data['매출변화']

# 결측값이 포함된 행 제거
X.dropna(inplace=True)

# 종속 변수도 동일한 행을 제거
y = y.loc[X.index]

# 데이터를 학습 세트와 테스트 세트로 나눔
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

lr = LinearRegression()
lr.fit(X_train, y_train)
# 선형 회귀 모델을 사용하여 테스트 세트에 대한 예측 수행
y_pred = lr.predict(X_test)

# 성능 지표 계산
mse = mean_squared_error(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)
r_squared = r2_score(y_test, y_pred)

# 결과 출력
print("Mean Squared Error (MSE):", mse)
print("Mean Absolute Error (MAE):", mae)
print("R-squared:", r_squared)
# lr = LinearRegression()
# lr.fit(X, y)
         
# Statsmodels를 사용한 선형 회귀 분석
X = sm.add_constant(X)  # 상수항 추가
results = sm.OLS(y, X).fit()
print(results.summary())
# print(merged_data)