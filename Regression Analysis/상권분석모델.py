import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
from sklearn import datasets
from sklearn.linear_model import LinearRegression

# 추정매출-상권 데이터 로드
df_sales = pd.read_csv('추정매출-상권.csv', encoding='cp949')

# 집객시설-상권 데이터 로드
df_facilities = pd.read_csv('집객시설-상권.csv', encoding='cp949')

# 직장인구-상권 데이터 로드
df_working_population = pd.read_csv('직장인구-상권.csv', encoding='cp949')

# 분기와 상권코드를 기준으로 데이터 병합
# merged_data = pd.merge(df_sales, df_facilities, df_working_population, on=['year_quarter_code', 'commercial_district_code'], how='inner')

# 필요한 경우 추가 전처리 작업 수행

# 독립 변수 선택
# X = merged_data[['facilities', 'total_working_population']]

# 종속 변수 선택
y = df_sales['monthly_sales']

print(y)