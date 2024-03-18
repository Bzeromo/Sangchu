import pandas as pd

# 데이터셋 불러오기
df_working_population = pd.read_csv('직장인구-상권.csv', encoding='cp949')

# year_quarter_code를 문자열로 변환
df_working_population['year_quarter_code'] = df_working_population['year_quarter_code'].astype(str)

# year_quarter_code를 연도와 분기로 분리
df_working_population['년도'] = df_working_population['year_quarter_code'].str.slice(stop=4)  # 처음 4글자: 년도
df_working_population['분기'] = df_working_population['year_quarter_code'].str.slice(start=4)  # 나머지: 분기

# 분기를 숫자 형식으로 변환
df_working_population['분기'] = df_working_population['분기'].astype(int)

# 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_working_population_2021 = df_working_population[df_working_population['년도'] == '2021'][['year_quarter_code', 'commercial_district_code', 'total_working_population', '분기']]
df_working_population_2022 = df_working_population[df_working_population['년도'] == '2022'][['year_quarter_code', 'commercial_district_code', 'total_working_population', '분기']]
df_working_population_2023 = df_working_population[df_working_population['년도'] == '2023'][['year_quarter_code', 'commercial_district_code', 'total_working_population', '분기']]

df_working_population_2023 = pd.merge(df_working_population_2023, df_working_population_2022, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))
df_working_population_2022 = pd.merge(df_working_population_2022, df_working_population_2021, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))

df_working_population = pd.concat([df_working_population_2022, df_working_population_2023])
df_working_population['직장인구변화'] = df_working_population['total_working_population_now'] - df_working_population['total_working_population_previous']
# 컬럼명 변경
df_working_population = df_working_population.rename(columns={'year_quarter_code_now': 'year_quarter_code'})
df_working_population['year_quarter_code'] = df_working_population['year_quarter_code'].astype(int)
df_working_population.drop(columns=['year_quarter_code_previous'], inplace=True)
df_working_population.drop(columns=['분기'], inplace=True)

# 결과 확인
# print(df_working_population)