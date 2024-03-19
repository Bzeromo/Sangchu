import pandas as pd

# 데이터셋 불러오기
df_store = pd.read_csv('점포-상권.csv', encoding='cp949')
df_store['total_store'] = df_store['store_count'] + df_store['franchise_store_count']
df_store = df_store.groupby(['year_quarter_code', 'commercial_district_code'])['total_store'].sum().reset_index()

# year_quarter_code를 문자열로 변환
df_store['year_quarter_code'] = df_store['year_quarter_code'].astype(str)

# year_quarter_code를 연도와 분기로 분리
df_store['년도'] = df_store['year_quarter_code'].str.slice(stop=4)  # 처음 4글자: 년도
df_store['분기'] = df_store['year_quarter_code'].str.slice(start=4)  # 나머지: 분기

# 분기를 숫자 형식으로 변환
df_store['분기'] = df_store['분기'].astype(int)

# # 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_store_2021 = df_store[df_store['년도'] == '2021'][['year_quarter_code', 'commercial_district_code', 'total_store', '분기']]
df_store_2022 = df_store[df_store['년도'] == '2022'][['year_quarter_code', 'commercial_district_code', 'total_store', '분기']]
df_store_2023 = df_store[df_store['년도'] == '2023'][['year_quarter_code', 'commercial_district_code', 'total_store', '분기']]

df_store_2023 = pd.merge(df_store_2023, df_store_2022, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))
df_store_2022 = pd.merge(df_store_2022, df_store_2021, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))

df_store = pd.concat([df_store_2022, df_store_2023])
df_store['store_diff'] = df_store['total_store_now'] - df_store['total_store_previous']

# 컬럼명 변경
df_store = df_store.rename(columns={'year_quarter_code_now': 'year_quarter_code'})
df_store['year_quarter_code'] = df_store['year_quarter_code'].astype(int)
df_store.drop(columns=['year_quarter_code_previous'], inplace=True)
df_store.drop(columns=['분기'], inplace=True)

# 결과 확인
# print(df_store)