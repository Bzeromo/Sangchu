import pandas as pd

# 데이터셋 불러오기
df_area = pd.read_csv('C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_set/영역-상권.csv', encoding='cp949')

df_area = df_area[['commercial_district_code', 'area_size']]

# 결과 확인
print(df_area)

# 새로운 CSV 파일 경로 지정
output_file_path = 'C:/Users/SSAFY/Desktop/S10P22B206/Regression Analysis/data_transform/영역-상권.csv'

# 데이터프레임을 UTF-8 인코딩으로 CSV 파일로 저장
df_area.to_csv(output_file_path, index=False, encoding='cp949')