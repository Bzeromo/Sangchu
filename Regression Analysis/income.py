import pandas as pd

# 데이터셋 불러오기
df_income = pd.read_csv('소득-상권.csv', encoding='cp949')

# year_quarter_code를 문자열로 변환
df_income['year_quarter_code'] = df_income['year_quarter_code'].astype(str)

# year_quarter_code를 연도와 분기로 분리
df_income['년도'] = df_income['year_quarter_code'].str.slice(stop=4)  # 처음 4글자: 년도
df_income['분기'] = df_income['year_quarter_code'].str.slice(start=4)  # 나머지: 분기

# 분기를 숫자 형식으로 변환
df_income['분기'] = df_income['분기'].astype(int)

# # 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_income_2021 = df_income[df_income['년도'] == '2021'][['year_quarter_code', 'commercial_district_code', 'monthly_average_income_amount', 'expenditure_total_amount', '분기']]
df_income_2022 = df_income[df_income['년도'] == '2022'][['year_quarter_code', 'commercial_district_code', 'monthly_average_income_amount', 'expenditure_total_amount', '분기']]
df_income_2023 = df_income[df_income['년도'] == '2023'][['year_quarter_code', 'commercial_district_code', 'monthly_average_income_amount', 'expenditure_total_amount', '분기']]

df_income_2023 = pd.merge(df_income_2023, df_income_2022, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))
df_income_2022 = pd.merge(df_income_2022, df_income_2021, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))

df_income = pd.concat([df_income_2022, df_income_2023])
df_income['income_diff'] = df_income['monthly_average_income_amount_now'] - df_income['monthly_average_income_amount_previous']
df_income['expend_diff'] = df_income['expenditure_total_amount_now'] - df_income['expenditure_total_amount_previous']

# # 컬럼명 변경
df_income = df_income.rename(columns={'year_quarter_code_now': 'year_quarter_code'})
df_income['year_quarter_code'] = df_income['year_quarter_code'].astype(int)
df_income.drop(columns=['year_quarter_code_previous'], inplace=True)
df_income.drop(columns=['분기'], inplace=True)

# # 결과 확인
# print(df_income)