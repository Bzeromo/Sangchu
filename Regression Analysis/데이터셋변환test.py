import pandas as pd

# 데이터셋 불러오기
df_sales = pd.read_csv('추정매출-상권.csv', encoding='cp949')
df_sales = df_sales.groupby(['year_quarter_code', 'commercial_district_code'])['monthly_sales'].sum().reset_index()

# year_quarter_code를 문자열로 변환
df_sales['year_quarter_code'] = df_sales['year_quarter_code'].astype(str)

# year_quarter_code를 연도와 분기로 분리
df_sales['년도'] = df_sales['year_quarter_code'].str.slice(stop=4)  # 처음 4글자: 년도
df_sales['분기'] = df_sales['year_quarter_code'].str.slice(start=4)  # 나머지: 분기

# 분기를 숫자 형식으로 변환
df_sales['분기'] = df_sales['분기'].astype(int)

# # 2022년 1분기부터 2023년 4분기까지의 데이터 추출
# filtered_data = df_sales[(df_sales['년도'] == '2022') & (df_sales['분기'].isin([1, 2, 3, 4])) | (df_sales['년도'] == '2023') & (df_sales['분기'].isin([1, 2, 3, 4]))]
df_sales_2021 = df_sales[df_sales['년도'] == '2021'][['year_quarter_code', 'commercial_district_code', 'monthly_sales', '분기']]
df_sales_2022 = df_sales[df_sales['년도'] == '2022'][['year_quarter_code', 'commercial_district_code', 'monthly_sales']]
df_sales_2023 = df_sales[df_sales['년도'] == '2023'][['year_quarter_code', 'commercial_district_code', 'monthly_sales']]
# # 결과 확인
# print(df_sales_2021)
# print(df_sales_2022)
# print(df_sales_2023)