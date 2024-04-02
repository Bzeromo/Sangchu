from sklearn.manifold import MDS
from sklearn.preprocessing import StandardScaler
import numpy as np
import matplotlib.pyplot as plt

# 예시 데이터: 상권별 유동인구, 상주인구, 매출, 업종다양성, 집객시설, 직장인구
# 랜덤 시드 설정으로 재현 가능한 결과를 생성
np.random.seed(42)

# 1000개의 상권 데이터 생성
# 각 특성별로 랜덤한 값의 범위를 지정 (예시로 설정된 값은 변경 가능)
# 유동인구: 500 ~ 2000 사이의 값
# 상주인구: 300 ~ 700 사이의 값
# 매출: 8000 ~ 15000 사이의 값
# 업종다양성: 10 ~ 30 사이의 값
# 집객시설: 2 ~ 10 사이의 값
# 직장인구: 100 ~ 300 사이의 값
data = np.hstack((np.random.randint(10000, 200000, size=(1000, 1)),
                  np.random.randint(10000, 250000, size=(1000, 1)),
                  np.random.randint(1000000, 1500000000, size=(1000, 1)),
                  np.random.randint(1, 16, size=(1000, 1)),
                  np.random.randint(0, 50, size=(1000, 1)),
                  np.random.randint(10000, 120000, size=(1000, 1))))

# 예시 데이터 불러오기 및 정규화
# data: 상권 데이터 (각 행이 상권을 나타내고, 열이 특성을 나타냄)
scaler = StandardScaler()
data_normalized = scaler.fit_transform(data)

# MDS 적용
mds = MDS(n_components=2, random_state=42)
mds_result = mds.fit_transform(data_normalized)

# 특정 상권 선택 (예시로 0번 상권을 선택)
target = mds_result[0]

# 모든 상권과의 거리 계산
distances = np.sqrt(((mds_result - target)**2).sum(axis=1))

# 거리 기준으로 상권 정렬 및 상위 N개 추천
N = 5
recommended_indices = distances.argsort()[1:N+1] # 자기 자신을 제외한 상위 N개

# 추천 결과 출력
print("추천 상권 인덱스:", recommended_indices)

from matplotlib import font_manager, rc

# 한글 폰트 경로 설정
font_path = "C:/Windows/Fonts/malgun.ttf"  # Windows 사용자의 경우

font_name = font_manager.FontProperties(fname=font_path).get_name()
rc('font', family=font_name)

plt.rcParams['axes.unicode_minus'] = False  # 마이너스 기호도 정상 표시

# MDS 모델 생성, n_components는 축소할 차원 수, normalized_stress 값을 'auto'로 설정
mds = MDS(n_components=2, random_state=42, normalized_stress='auto')

# MDS를 사용하여 데이터를 2차원으로 축소
mds_result = mds.fit_transform(data_normalized)

# 2차원 공간에 상권 표시
plt.figure(figsize=(10, 8))
plt.scatter(mds_result[:,0], mds_result[:,1], color='blue', alpha=0.5)
for i, txt in enumerate(range(1, len(data)+1)):
    plt.annotate(txt, (mds_result[i,0], mds_result[i,1]))

plt.title('MDS를 이용한 상권 간 유사성 시각화')
plt.xlabel('MDS1')
plt.ylabel('MDS2')
plt.grid(True)
plt.show()
