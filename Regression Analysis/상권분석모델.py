import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
from sklearn.linear_model import LinearRegression

##### 데이터 조회 ######
# 추정매출-상권 데이터 로드
df_sales = pd.read_csv('추정매출-상권.csv', encoding='cp949')
df_sales = df_sales.groupby(['year_quarter_code', 'commercial_district_code'])['monthly_sales'].sum().reset_index()

# 집객시설-상권 데이터 로드
df_facilities = pd.read_csv('집객시설-상권.csv', encoding='cp949')

# 직장인구-상권 데이터 로드
df_working_population = pd.read_csv('직장인구-상권.csv', encoding='cp949')

# 영역-상권 데이터 로드
df_area = pd.read_csv('영역-상권.csv', encoding='cp949')

# 아파트-상권 데이터 로드
df_apartment = pd.read_csv('아파트-상권.csv', encoding='cp949')

# 소득-상권 데이터 로드
df_income = pd.read_csv('소득-상권.csv', encoding='cp949')

# 상주인구-상권 데이터 로드
df_resident_population = pd.read_csv('상주인구-상권.csv', encoding='cp949')

# 상권변화지표-상권 데이터 로드
df_commercial_change = pd.read_csv('상권변화지표-상권.csv', encoding='cp949')

# 길단위인구-상권 데이터 로드
df_foot_traffic = pd.read_csv('길단위인구-상권.csv', encoding='cp949')

##### 데이터 병합 #####
# 추정매출-상권과 집객시설-상권 데이터 병합
merged_data = pd.merge(df_sales, df_facilities, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 병합된 데이터와 직장인구-상권 데이터 병합
df_working_population.drop(columns=['commercial_district_name'], inplace=True)
merged_data = pd.merge(merged_data, df_working_population, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 병합된 데이터와 영역-상권 데이터 병합
df_area.drop(columns=['commercial_district_name'], inplace=True)
merged_data = pd.merge(merged_data, df_area, on='commercial_district_code', how='left')

# 병합된 데이터와 아파트-상권 데이터 병합
df_apartment.drop(columns=['commercial_district_name'], inplace=True)
merged_data = pd.merge(merged_data, df_apartment, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 병합된 데이터와 소득-상권 데이터 병합
df_income.drop(columns=['commercial_district_name'], inplace=True)
merged_data = pd.merge(merged_data, df_income, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 병합된 데이터와 상주인구-상권 데이터 병합
df_resident_population.drop(columns=['commercial_district_name'], inplace=True)
merged_data = pd.merge(merged_data, df_resident_population, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 병합된 데이터와 상권변화지표-상권 데이터 병합
df_commercial_change.drop(columns=['commercial_district_name'], inplace=True)
merged_data = pd.merge(merged_data, df_commercial_change, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 병합된 데이터와 길단위인구-상권 데이터 병합
df_foot_traffic.drop(columns=['commercial_district_name'], inplace=True)
merged_data = pd.merge(merged_data, df_foot_traffic, on=['year_quarter_code', 'commercial_district_code'], how='left')

# 독립 변수 선택
X = merged_data[['facilities', 'total_working_population', 'area_size', 'apartment_avg_price', 'monthly_average_income_amount', 'total_resident_population', 'rdi', 'store_density' , 'total_foot_traffic']]

# 종속 변수 선택
y = merged_data['monthly_sales']

# 결측값이 포함된 행 제거
X.dropna(inplace=True)

# 종속 변수도 동일한 행을 제거
y = y.loc[X.index]
lr = LinearRegression()
lr.fit(X, y)
         
# Statsmodels를 사용한 선형 회귀 분석
X = sm.add_constant(X)  # 상수항 추가
results = sm.OLS(y, X).fit()
print(results.summary())
# print(merged_data)