import pandas as pd

# 데이터셋 불러오기
df_apartment = pd.read_csv('아파트-상권.csv', encoding='cp949')

# year_quarter_code를 문자열로 변환
df_apartment['year_quarter_code'] = df_apartment['year_quarter_code'].astype(str)

# year_quarter_code를 연도와 분기로 분리
df_apartment['년도'] = df_apartment['year_quarter_code'].str.slice(stop=4)  # 처음 4글자: 년도
df_apartment['분기'] = df_apartment['year_quarter_code'].str.slice(start=4)  # 나머지: 분기

# 분기를 숫자 형식으로 변환
df_apartment['분기'] = df_apartment['분기'].astype(int)

# # 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_apartment_2021 = df_apartment[df_apartment['년도'] == '2021'][['year_quarter_code', 'commercial_district_code', 'total_household', 'apartment_avg_price', '분기']]
df_apartment_2022 = df_apartment[df_apartment['년도'] == '2022'][['year_quarter_code', 'commercial_district_code', 'total_household', 'apartment_avg_price', '분기']]
df_apartment_2023 = df_apartment[df_apartment['년도'] == '2023'][['year_quarter_code', 'commercial_district_code', 'total_household', 'apartment_avg_price', '분기']]

df_apartment_2023 = pd.merge(df_apartment_2023, df_apartment_2022, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))
df_apartment_2022 = pd.merge(df_apartment_2022, df_apartment_2021, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))

df_apartment = pd.concat([df_apartment_2022, df_apartment_2023])
df_apartment['household_diff'] = df_apartment['total_household_now'] - df_apartment['total_household_previous']
df_apartment['apt_price_diff'] = df_apartment['apartment_avg_price_now'] - df_apartment['apartment_avg_price_previous']

# # 컬럼명 변경
df_apartment = df_apartment.rename(columns={'year_quarter_code_now': 'year_quarter_code'})
df_apartment['year_quarter_code'] = df_apartment['year_quarter_code'].astype(int)
df_apartment.drop(columns=['year_quarter_code_previous'], inplace=True)
df_apartment.drop(columns=['분기'], inplace=True)

# # 결과 확인
# print(df_apartment)