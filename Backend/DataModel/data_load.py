import pandas as pd

##### 데이터 조회 ######
# 추정매출-상권 데이터 로드
df_sales = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/추정매출-상권.csv', encoding='cp949')

# 점포-상권 데이터 로드
df_store = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/점포-상권.csv', encoding='cp949')
merged_data = pd.merge(df_sales, df_store, on=['year_code', 'quarter_code', 'commercial_district_code'], how='left')

# 상권변화지표-상권 데이터 로드
df_commercial_change = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/상권변화지표-상권.csv', encoding='cp949')
merged_data = pd.merge(merged_data, df_commercial_change, on=['year_code', 'quarter_code', 'commercial_district_code'], how='left')

# 상주인구-상권 데이터 로드
df_resident_population = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/상주인구-상권.csv', encoding='cp949')
merged_data = pd.merge(merged_data, df_resident_population, on=['year_code', 'quarter_code', 'commercial_district_code'], how='left')

# 길단위인구-상권 데이터 로드
df_foot_traffic = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/길단위인구-상권.csv', encoding='cp949')
merged_data = pd.merge(merged_data, df_foot_traffic, on=['year_code', 'quarter_code', 'commercial_district_code'], how='left')

# 영역-상권 데이터 로드
df_area = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/영역-상권.csv', encoding='cp949')
merged_data = pd.merge(merged_data, df_area, on='commercial_district_code', how='left')

# 집객시설-상권 데이터 로드
df_facilities = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/집객시설-상권.csv', encoding='cp949')
merged_data = pd.merge(merged_data, df_facilities, on=['year_code', 'quarter_code', 'commercial_district_code'], how='left')

# 직장인구-상권 데이터 로드
df_working_population = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/직장인구-상권.csv', encoding='cp949')
merged_data = pd.merge(merged_data, df_working_population, on=['year_code', 'quarter_code', 'commercial_district_code'], how='left')

# 소득-상권 데이터 로드
df_income = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/소득-상권.csv', encoding='cp949')
merged_data = pd.merge(merged_data, df_income, on=['year_code', 'quarter_code', 'commercial_district_code'], how='left')

# 아파트-상권 데이터 로드
df_apartment = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Backend/DataModel/data_transform/아파트-상권.csv', encoding='cp949')
merged_data = pd.merge(merged_data, df_apartment, on=['year_code', 'quarter_code', 'commercial_district_code'], how='left')

merged_data.dropna(inplace=True)
merged_data['monthly_sales_now'] = merged_data['monthly_sales_now'] / merged_data['total_store_now']
merged_data['monthly_sales_previous'] = merged_data['monthly_sales_previous'] / merged_data['total_store_previous']
merged_data['sales_diff'] = merged_data['monthly_sales_now'] - merged_data['monthly_sales_previous']

# 종속 변수 선택
y = merged_data['monthly_sales_now']
# # y = merged_data['sales_diff']

# 독립 변수 선택 
X = merged_data[['monthly_sales_previous',
                 'total_foot_traffic_previous', 'traffic_diff',
                 'commercial_change_previous', 'rdi_previous',
                 'store_density_previous', 'rdi_diff', 'store_density_diff',
                 'commercial_change_diff', 'total_resident_population_previous',
                 'resident_population_diff', 'monthly_average_income_amount_previous',
                 'expenditure_total_amount_previous', 'income_diff', 'expend_diff',
                 'apartment_avg_price_by_area_previous', 'apartment_avg_diff',
                 'area_size', 'total_store_previous', 'store_count_diff',
                 'total_working_population_previous',
                 'total_facilities_previous']]

# X = merged_data[['total_foot_traffic_now', 'commercial_change_now',
#                  'rdi_now', 'store_density_now', 'total_resident_population_now',
#                  'monthly_average_income_amount_now', 'expenditure_total_amount_now',
#                  'apartment_avg_price_by_area_now', 'area_size', 'total_store_now',
#                  'total_working_population_now', 'total_facilities_now']]
# print(merged_data)