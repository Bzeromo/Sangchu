import pandas as pd

# 데이터셋 불러오기
df_resident_population = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_set/상주인구-상권.csv', encoding='cp949')

# 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_resident_population_2021 = df_resident_population[df_resident_population['year_code'] == 2021][['year_code', 'quarter_code', 'commercial_district_code', 'total_resident_population']]
df_resident_population_2022 = df_resident_population[df_resident_population['year_code'] == 2022][['year_code', 'quarter_code', 'commercial_district_code', 'total_resident_population']]
df_resident_population_2023 = df_resident_population[df_resident_population['year_code'] == 2023][['year_code', 'quarter_code', 'commercial_district_code', 'total_resident_population']]

df_resident_population_2023 = pd.merge(df_resident_population_2023, df_resident_population_2022, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))
df_resident_population_2022 = pd.merge(df_resident_population_2022, df_resident_population_2021, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))

df_resident_population = pd.concat([df_resident_population_2022, df_resident_population_2023])
df_resident_population['resident_population_diff'] = df_resident_population['total_resident_population_now'] - df_resident_population['total_resident_population_previous']

# 컬럼명 변경
df_resident_population = df_resident_population.rename(columns={'year_code_now': 'year_code'})
df_resident_population.drop(columns=['year_code_previous'], inplace=True)

# # 결과 확인
print(df_resident_population)

# 새로운 CSV 파일 경로 지정
output_file_path = 'C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_transform/상주인구-상권.csv'

# 데이터프레임을 UTF-8 인코딩으로 CSV 파일로 저장
df_resident_population.to_csv(output_file_path, index=False, encoding='cp949')