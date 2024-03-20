import pandas as pd

# 데이터셋 불러오기
df_sales = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_set/추정매출-상권.csv', encoding='cp949')
df_sales = df_sales.groupby(['year_code', 'quarter_code', 'commercial_district_code', 'commercial_district_name'])['monthly_sales'].sum().reset_index()

# 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_sales_2021 = df_sales[df_sales['year_code'] == 2021][['year_code', 'quarter_code', 'commercial_district_code', 'commercial_district_name', 'monthly_sales']]
df_sales_2022 = df_sales[df_sales['year_code'] == 2022][['year_code', 'quarter_code', 'commercial_district_code', 'commercial_district_name', 'monthly_sales']]
df_sales_2023 = df_sales[df_sales['year_code'] == 2023][['year_code', 'quarter_code', 'commercial_district_code', 'commercial_district_name', 'monthly_sales']]

df_sales_2023 = pd.merge(df_sales_2023, df_sales_2022, on=['quarter_code', 'commercial_district_code', 'commercial_district_name'], how='left', suffixes=('_now', '_previous'))
df_sales_2022 = pd.merge(df_sales_2022, df_sales_2021, on=['quarter_code', 'commercial_district_code', 'commercial_district_name'], how='left', suffixes=('_now', '_previous'))

df_sales = pd.concat([df_sales_2022, df_sales_2023])
df_sales['sales_diff'] = df_sales['monthly_sales_now'] - df_sales['monthly_sales_previous']
# # 매출변화가 0 이상인 경우는 1로, 그렇지 않은 경우는 0으로 설정
# df_sales['매출변화'] = np.where(df_sales['매출변화'] >= 0, 1, 0)

# 컬럼명 변경
df_sales = df_sales.rename(columns={'year_code_now': 'year_code'})
df_sales.drop(columns=['year_code_previous'], inplace=True)

# # 결과 확인
print(df_sales)

# 새로운 CSV 파일 경로 지정
output_file_path = 'C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_transform/추정매출-상권.csv'

# 데이터프레임을 UTF-8 인코딩으로 CSV 파일로 저장
df_sales.to_csv(output_file_path, index=False, encoding='utf-8-sig')