import pandas as pd

# 데이터셋 불러오기
df_commercial_change = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_set/상권변화지표-상권.csv', encoding='cp949')

# 값 변경
df_commercial_change = df_commercial_change.rename(columns={'commercial_district_change_indicator_code': 'commercial_change'})
df_commercial_change['commercial_change'] = df_commercial_change['commercial_change'].map({'HL' : 0, 'HH' : 1, 'LL' : 2, 'LH' : 3})

# 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_commercial_change_2021 = df_commercial_change[df_commercial_change['year_code'] == 2021][['year_code', 'quarter_code', 'commercial_district_code', 'commercial_change', 'rdi', 'store_density']]
df_commercial_change_2022 = df_commercial_change[df_commercial_change['year_code'] == 2022][['year_code', 'quarter_code', 'commercial_district_code', 'commercial_change', 'rdi', 'store_density']]
df_commercial_change_2023 = df_commercial_change[df_commercial_change['year_code'] == 2023][['year_code', 'quarter_code', 'commercial_district_code', 'commercial_change', 'rdi', 'store_density']]

df_commercial_change_2023 = pd.merge(df_commercial_change_2023, df_commercial_change_2022, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))
df_commercial_change_2022 = pd.merge(df_commercial_change_2022, df_commercial_change_2021, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))

df_commercial_change = pd.concat([df_commercial_change_2022, df_commercial_change_2023])
df_commercial_change['rdi_diff'] = df_commercial_change['rdi_now'] - df_commercial_change['rdi_previous']
df_commercial_change['store_density_diff'] = df_commercial_change['store_density_now'] - df_commercial_change['store_density_previous']
df_commercial_change['commercial_change_diff'] = df_commercial_change['commercial_change_now'] - df_commercial_change['commercial_change_previous']

# 컬럼명 변경
df_commercial_change = df_commercial_change.rename(columns={'year_code_now': 'year_code'})
df_commercial_change.drop(columns=['year_code_previous'], inplace=True)

# 결과 확인
print(df_commercial_change)

# 새로운 CSV 파일 경로 지정
output_file_path = 'C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_transform/상권변화지표-상권.csv'

# 데이터프레임을 UTF-8 인코딩으로 CSV 파일로 저장
df_commercial_change.to_csv(output_file_path, index=False, encoding='cp949')