from sklearn.manifold import MDS
from sklearn.preprocessing import StandardScaler
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import font_manager, rc

# 가중 다차원 척도법 적용 예시

# 한글 폰트 경로 설정
font_path = "C:/Windows/Fonts/malgun.ttf"  # Windows 사용자의 경우
font_name = font_manager.FontProperties(fname=font_path).get_name()
rc('font', family=font_name)
plt.rcParams['axes.unicode_minus'] = False  # 마이너스 기호도 정상 표시

np.random.seed(42)

# 가상의 데이터 생성
data = np.hstack((np.random.randint(10000, 200000, size=(100, 1)),
                  np.random.randint(10000, 250000, size=(100, 1)),
                  np.random.randint(1000000, 1500000000, size=(100, 1)),
                  np.random.randint(1, 16, size=(100, 1)),
                  np.random.randint(0, 50, size=(100, 1)),
                  np.random.randint(10000, 120000, size=(100, 1))))

# 사용자로부터 가중치 입력 받음 (여기서는 예시로 직접 지정)
weights = np.array([60, 0, 20, 10, 5, 5])  # 각 변수에 대한 가중치

# 데이터에 가중치 적용
weighted_data = data * weights

# 가중치가 적용된 데이터를 정규화
scaler = StandardScaler()
weighted_data_normalized = scaler.fit_transform(weighted_data)

# MDS 적용
mds = MDS(n_components=2, random_state=42, normalized_stress='auto')
mds_result = mds.fit_transform(weighted_data_normalized)

target = mds_result[0]

# 모든 상권과의 거리 계산 (맨해튼 거리 사용)
distances = np.abs((mds_result - target)).sum(axis=1)

N = 5
recommended_indices = distances.argsort()[1:N+1]  # 자기 자신을 제외한 상위 N개
recommended_distances = distances[recommended_indices]  # 추천 상권들의 거리

# 추천 상권 인덱스와 거리 출력
for idx, dist in zip(recommended_indices, recommended_distances):
    print(f"추천 상권 인덱스: {idx}, 거리: {dist:.2f}")

plt.figure(figsize=(10, 8))
plt.scatter(mds_result[:,0], mds_result[:,1], color='blue', alpha=0.5)
for i, txt in enumerate(range(1, len(data)+1)):
    plt.annotate(txt, (mds_result[i,0], mds_result[i,1]))

plt.title('가중치를 적용한 MDS를 이용한 상권 간 유사성 시각화 (맨해튼 거리 사용)')
plt.xlabel('MDS1')
plt.ylabel('MDS2')
plt.grid(True)
plt.show()
