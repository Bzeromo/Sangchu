import seaborn as sns
import matplotlib.pyplot as plt
import normalization

X = normalization.X
y = normalization.y

# 독립 변수(X) 리스트
independent_variables = X.columns

# 그래프 그릴 피규어 생성
plt.figure(figsize=(20, 15))

# 독립 변수별로 그래프 그리기
for i, column in enumerate(independent_variables, 1):
    plt.subplot(5, 5, i)  # 그래프 위치 지정
    sns.regplot(x=X[column], y=y)  # regplot 그리기
    plt.xlabel(column)  # x축 레이블 설정
    plt.ylabel('monthly_sales_now')  # y축 레이블 설정

plt.tight_layout()  # 그래프 간격 조정
plt.show()