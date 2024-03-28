import pandas as pd

# 데이터셋 불러오기
df_facilities = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_set/집객시설-상권.csv', encoding='cp949')
df_facilities['total_facilities'] = df_facilities['facilities'] + df_facilities['bus'] + df_facilities['cultural/tourist_facilities'] + df_facilities['educational_facilities'] + df_facilities['train/subway']

# 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_facilities_2021 = df_facilities[df_facilities['year_code'] == 2021][['year_code', 'quarter_code', 'commercial_district_code', 'total_facilities']]
df_facilities_2022 = df_facilities[df_facilities['year_code'] == 2022][['year_code', 'quarter_code', 'commercial_district_code', 'total_facilities']]
df_facilities_2023 = df_facilities[df_facilities['year_code'] == 2023][['year_code', 'quarter_code', 'commercial_district_code', 'total_facilities']]

df_facilities_2023 = pd.merge(df_facilities_2023, df_facilities_2022, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))
df_facilities_2022 = pd.merge(df_facilities_2022, df_facilities_2021, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))

df_facilities = pd.concat([df_facilities_2022, df_facilities_2023])
df_facilities['facilities_diff'] = df_facilities['total_facilities_now'] - df_facilities['total_facilities_previous']

# 컬럼명 변경
df_facilities = df_facilities.rename(columns={'year_code_now': 'year_code'})
df_facilities.drop(columns=['year_code_previous'], inplace=True)

# # 결과 확인
print(df_facilities)

# 새로운 CSV 파일 경로 지정
output_file_path = 'C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_transform/집객시설-상권.csv'

# 데이터프레임을 UTF-8 인코딩으로 CSV 파일로 저장
df_facilities.to_csv(output_file_path, index=False, encoding='cp949')