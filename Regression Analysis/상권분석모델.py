import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import data_transform.sales as sales
import data_transform.commercial_change
import data_transform.store
import data_transform.resident_population
import data_transform.foot_traffic
import data_transform.area
import data_transform.facilities
import data_transform.working_population
import data_transform.income
import data_transform.apartment as apartment

##### 데이터 조회 ######
# 추정매출-상권 데이터 로드
df_sales = sales.df_sales

# 점포-상권 데이터 로드
df_store = data_transform.store.df_store
merged_data = pd.merge(df_sales, df_store, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 상권변화지표-상권 데이터 로드
df_commercial_change = data_transform.commercial_change.df_commercial_change
merged_data = pd.merge(merged_data, df_commercial_change, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 상주인구-상권 데이터 로드
df_resident_population = data_transform.resident_population.df_resident_population
merged_data = pd.merge(merged_data, df_resident_population, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 길단위인구-상권 데이터 로드
df_foot_traffic = data_transform.foot_traffic.df_foot_traffic
merged_data = pd.merge(merged_data, df_foot_traffic, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 영역-상권 데이터 로드
df_area = data_transform.area.df_area
merged_data = pd.merge(merged_data, df_area, on='commercial_district_code', how='left')

# 집객시설-상권 데이터 로드
df_facilities = data_transform.facilities.df_facilities
merged_data = pd.merge(merged_data, df_facilities, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 직장인구-상권 데이터 로드
df_working_population = data_transform.working_population.df_working_population
merged_data = pd.merge(merged_data, df_working_population, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 소득-상권 데이터 로드
df_income = data_transform.income.df_income
merged_data = pd.merge(merged_data, df_income, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 아파트-상권 데이터 로드
df_apartment = data_transform.apartment.df_apartment
merged_data = pd.merge(merged_data, df_apartment, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 독립 변수 선택 
# X = merged_data[['monthly_sales_previous', 'total_store_previous', 'store_diff', 'rdi_previous', 'store_density_previous', 'rdi_diff', 'rdi_diff_square', 'density_diff', 'density_diff_square', 'total_resident_population_previous', 'resident_population_diff', 'total_foot_traffic_previous', 'foot_traffic_diff', 'foot_traffic_diff_square', 'area_size', 'facilities_previous', 'facilities_diff', 'total_working_population_previous', 'monthly_average_income_amount_previous', 'expenditure_total_amount_previous', 'apartment_avg_price_previous', 'total_household_previous', 'household_diff', 'apt_price_diff']].copy()
X = merged_data[['monthly_sales_previous', 'total_store_previous', 'store_diff', 'rdi_previous', 'store_density_previous', 'rdi_diff', 'density_diff', 'total_resident_population_previous', 'resident_population_diff', 'total_foot_traffic_previous', 'foot_traffic_diff', 'area_size', 'facilities_previous', 'facilities_diff', 'total_working_population_previous', 'working_population_diff', 'monthly_average_income_amount_previous', 'income_diff', 'expenditure_total_amount_previous', 'expend_diff', 'apartment_avg_price_previous', 'total_household_previous', 'household_diff', 'apt_price_diff']].copy()

# 종속 변수 선택
y = merged_data['monthly_sales_now']
# y = merged_data['sales_diff']

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

# # 결과 출력
# print("Mean Squared Error (MSE):", mse)
# print("Mean Absolute Error (MAE):", mae)
# print("R-squared:", r_squared)

# # Statsmodels를 사용한 선형 회귀 분석
# X = sm.add_constant(X)  # 상수항 추가
# results = sm.OLS(y, X).fit()
# print(results.summary())
# # print(merged_data)

# 독립 변수(X) 리스트
independent_variables = X.columns

# 그래프 그릴 피규어 생성
plt.figure(figsize=(20, 15))

# 독립 변수별로 그래프 그리기
for i, column in enumerate(independent_variables, 1):
    plt.subplot(5, 5, i)  # 그래프 위치 지정
    sns.regplot(x=X[column], y=y)  # regplot 그리기
    plt.xlabel(column)  # x축 레이블 설정
    plt.ylabel('monthly_sales_now')  # y축 레이블 설정

plt.tight_layout()  # 그래프 간격 조정
plt.show()