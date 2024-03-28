import pandas as pd

# 데이터셋 불러오기
df_store = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_set/점포-상권.csv', encoding='cp949')
df_store['total_store'] = df_store['store_count'] + df_store['franchise_store_count']
df_store = df_store.groupby(['year_code', 'quarter_code', 'commercial_district_code'])['total_store'].sum().reset_index()

# 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_store_2021 = df_store[df_store['year_code'] == 2021][['year_code', 'quarter_code', 'commercial_district_code', 'total_store']]
df_store_2022 = df_store[df_store['year_code'] == 2022][['year_code', 'quarter_code', 'commercial_district_code', 'total_store']]
df_store_2023 = df_store[df_store['year_code'] == 2023][['year_code', 'quarter_code', 'commercial_district_code', 'total_store']]

df_store_2023 = pd.merge(df_store_2023, df_store_2022, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))
df_store_2022 = pd.merge(df_store_2022, df_store_2021, on=['quarter_code', 'commercial_district_code'], how='left', suffixes=('_now', '_previous'))

df_store = pd.concat([df_store_2022, df_store_2023])
df_store['store_count_diff'] = df_store['total_store_now'] - df_store['total_store_previous']

# 컬럼명 변경
df_store = df_store.rename(columns={'year_code_now': 'year_code'})
df_store.drop(columns=['year_code_previous'], inplace=True)

# # 결과 확인
print(df_store)

# 새로운 CSV 파일 경로 지정
output_file_path = 'C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_transform/점포-상권.csv'

# 데이터프레임을 UTF-8 인코딩으로 CSV 파일로 저장
df_store.to_csv(output_file_path, index=False, encoding='cp949')