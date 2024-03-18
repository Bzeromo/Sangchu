import pandas as pd

# 데이터셋 불러오기
df_area = pd.read_csv('영역-상권.csv', encoding='cp949')
df_area = df_area[['commercial_district_code', 'area_size']]

# 결과 확인
# print(df_area)