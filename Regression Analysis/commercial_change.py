import pandas as pd

# 데이터셋 불러오기
df_commercial_change = pd.read_csv('상권변화지표-상권.csv', encoding='cp949')

# year_quarter_code를 문자열로 변환
df_commercial_change['year_quarter_code'] = df_commercial_change['year_quarter_code'].astype(str)

# year_quarter_code를 연도와 분기로 분리
df_commercial_change['년도'] = df_commercial_change['year_quarter_code'].str.slice(stop=4)  # 처음 4글자: 년도
df_commercial_change['분기'] = df_commercial_change['year_quarter_code'].str.slice(start=4)  # 나머지: 분기

# 분기를 숫자 형식으로 변환
df_commercial_change['분기'] = df_commercial_change['분기'].astype(int)

# # 2021년 1분기부터 2023년 3분기까지의 데이터 추출
df_commercial_change_2021 = df_commercial_change[df_commercial_change['년도'] == '2021'][['year_quarter_code', 'commercial_district_code', 'rdi', 'store_density', '분기']]
df_commercial_change_2022 = df_commercial_change[df_commercial_change['년도'] == '2022'][['year_quarter_code', 'commercial_district_code', 'rdi', 'store_density', '분기']]
df_commercial_change_2023 = df_commercial_change[df_commercial_change['년도'] == '2023'][['year_quarter_code', 'commercial_district_code', 'rdi', 'store_density', '분기']]

df_commercial_change_2023 = pd.merge(df_commercial_change_2023, df_commercial_change_2022, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))
df_commercial_change_2022 = pd.merge(df_commercial_change_2022, df_commercial_change_2021, on=['commercial_district_code', '분기'], how='left', suffixes=('_now', '_previous'))

df_commercial_change = pd.concat([df_commercial_change_2022, df_commercial_change_2023])
df_commercial_change['rdi변화'] = df_commercial_change['rdi_now'] - df_commercial_change['rdi_previous']
df_commercial_change['rdi변화제곱'] = df_commercial_change['rdi변화']**2
df_commercial_change['점포밀도변화'] = df_commercial_change['store_density_now'] - df_commercial_change['store_density_previous']
df_commercial_change['점포밀도변화제곱'] = df_commercial_change['점포밀도변화']**2

# # 컬럼명 변경
df_commercial_change = df_commercial_change.rename(columns={'year_quarter_code_now': 'year_quarter_code'})
df_commercial_change['year_quarter_code'] = df_commercial_change['year_quarter_code'].astype(int)
df_commercial_change.drop(columns=['year_quarter_code_previous'], inplace=True)
df_commercial_change.drop(columns=['분기'], inplace=True)

# # 결과 확인
# print(df_commercial_change)