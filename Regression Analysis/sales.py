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

# # 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_sales_2021 = df_sales[df_sales['년도'] == '2021'][['year_quarter_code', 'commercial_district_code', 'monthly_sales', '분기']]
df_sales_2022 = df_sales[df_sales['년도'] == '2022'][['year_quarter_code', 'commercial_district_code', 'monthly_sales', '분기']]
df_sales_2023 = df_sales[df_sales['년도'] == '2023'][['year_quarter_code', 'commercial_district_code', 'monthly_sales', '분기']]

df_sales_2023 = pd.merge(df_sales_2023, df_sales_2022, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))
df_sales_2022 = pd.merge(df_sales_2022, df_sales_2021, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))

df_sales = pd.concat([df_sales_2022, df_sales_2023])
df_sales['sales_diff'] = df_sales['monthly_sales_now'] - df_sales['monthly_sales_previous']

# # 매출변화가 0 이상인 경우는 1로, 그렇지 않은 경우는 0으로 설정
# df_sales['매출변화'] = np.where(df_sales['매출변화'] >= 0, 1, 0)

# 컬럼명 변경
df_sales = df_sales.rename(columns={'year_quarter_code_now': 'year_quarter_code'})
df_sales['year_quarter_code'] = df_sales['year_quarter_code'].astype(int)
df_sales.drop(columns=['분기'], inplace=True)

# # 결과 확인
print(df_sales)