import pandas as pd

# 데이터셋 불러오기
df_resident_population = pd.read_csv('상주인구-상권.csv', encoding='cp949')

# year_quarter_code를 문자열로 변환
df_resident_population['year_quarter_code'] = df_resident_population['year_quarter_code'].astype(str)

# year_quarter_code를 연도와 분기로 분리
df_resident_population['년도'] = df_resident_population['year_quarter_code'].str.slice(stop=4)  # 처음 4글자: 년도
df_resident_population['분기'] = df_resident_population['year_quarter_code'].str.slice(start=4)  # 나머지: 분기

# 분기를 숫자 형식으로 변환
df_resident_population['분기'] = df_resident_population['분기'].astype(int)

# # 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_resident_population_2021 = df_resident_population[df_resident_population['년도'] == '2021'][['year_quarter_code', 'commercial_district_code', 'total_resident_population', '분기']]
df_resident_population_2022 = df_resident_population[df_resident_population['년도'] == '2022'][['year_quarter_code', 'commercial_district_code', 'total_resident_population', '분기']]
df_resident_population_2023 = df_resident_population[df_resident_population['년도'] == '2023'][['year_quarter_code', 'commercial_district_code', 'total_resident_population', '분기']]

df_resident_population_2023 = pd.merge(df_resident_population_2023, df_resident_population_2022, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))
df_resident_population_2022 = pd.merge(df_resident_population_2022, df_resident_population_2021, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))

df_resident_population = pd.concat([df_resident_population_2022, df_resident_population_2023])
df_resident_population['상주인구변화'] = df_resident_population['total_resident_population_now'] - df_resident_population['total_resident_population_previous']

# 컬럼명 변경
df_resident_population = df_resident_population.rename(columns={'year_quarter_code_now': 'year_quarter_code'})
df_resident_population['year_quarter_code'] = df_resident_population['year_quarter_code'].astype(int)
df_resident_population.drop(columns=['year_quarter_code_previous'], inplace=True)
df_resident_population.drop(columns=['분기'], inplace=True)

# 결과 확인
# print(df_resident_population)