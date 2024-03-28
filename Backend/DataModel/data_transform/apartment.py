import pandas as pd

# 데이터셋 불러오기
df_apartment = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_set/아파트-상권.csv', encoding='cp949')
df_apartment['apartment_avg_price_by_area'] = df_apartment['apartment_avg_price'] / df_apartment['apartment_avg_area']

# 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_apartment_2021 = df_apartment[df_apartment['year_code'] == 2021][['year_code', 'quarter_code', 'commercial_district_code', 'apartment_avg_price_by_area']]
df_apartment_2022 = df_apartment[df_apartment['year_code'] == 2022][['year_code', 'quarter_code', 'commercial_district_code', 'apartment_avg_price_by_area']]
df_apartment_2023 = df_apartment[df_apartment['year_code'] == 2023][['year_code', 'quarter_code', 'commercial_district_code', 'apartment_avg_price_by_area']]

df_apartment_2023 = pd.merge(df_apartment_2023, df_apartment_2022, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))
df_apartment_2022 = pd.merge(df_apartment_2022, df_apartment_2021, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))

df_apartment = pd.concat([df_apartment_2022, df_apartment_2023])
df_apartment['apartment_avg_diff'] = df_apartment['apartment_avg_price_by_area_now'] - df_apartment['apartment_avg_price_by_area_previous']

# 컬럼명 변경
df_apartment = df_apartment.rename(columns={'year_code_now': 'year_code'})
df_apartment.drop(columns=['year_code_previous'], inplace=True)

# 결과 확인
print(df_apartment)

# 새로운 CSV 파일 경로 지정
output_file_path = 'C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_transform/아파트-상권.csv'

# 데이터프레임을 UTF-8 인코딩으로 CSV 파일로 저장
df_apartment.to_csv(output_file_path, index=False, encoding='cp949')