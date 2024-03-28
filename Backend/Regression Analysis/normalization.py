import scipy.stats as stats
import data_load

merge_df = data_load.merged_data.dropna(axis=0)

for col in merge_df.select_dtypes(include=['number']).columns:
    if col not in ['year_code', 'quarter_code']:
        # 이상치 제거
        # Q1(제1사분위수), Q3(제3사분위수) 계산
        Q1 = merge_df[col].quantile(0.25)
        Q3 = merge_df[col].quantile(0.75)
        IQR = Q3 - Q1

        # 이상치 기준 설정
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        # 이상치 탐지
        outliers = merge_df[(merge_df[col] < lower_bound) | (merge_df[col] > upper_bound)]
        # print("이상치:\n", outliers)

        # 이상치 제거
        merge_df = merge_df[(merge_df[col] >= lower_bound) & (merge_df[col] <= upper_bound)]
        # print("\n이상치를 제거한 데이터:\n", df_cleaned)

        # 데이터에 박스-콕스 변환을 적용
        if (merge_df[col] <= 0).any():
            # 0이나 음수 값이 있는 경우
            # print(f"{col} 컬럼에 0이나 음수 값이 있습니다. 데이터를 조정해야 합니다.")
            pass
        else:
            transformed_data, best_lambda = stats.boxcox(merge_df[col])

            # 최적의 람다 값 확인
            # print(f"{col}의 최적의 람다:", best_lambda)

# 종속 변수 선택
y = merge_df['monthly_sales_now']
# # y = merge_df['sales_diff']

# 독립 변수 선택 
# X = merge_df[['monthly_sales_previous',
#                  'total_foot_traffic_previous', 'traffic_diff',
#                  'commercial_change_previous', 'rdi_previous',
#                  'store_density_previous', 'rdi_diff', 'store_density_diff',
#                  'commercial_change_diff', 'total_resident_population_previous',
#                  'resident_population_diff', 'monthly_average_income_amount_previous',
#                  'expenditure_total_amount_previous', 'income_diff', 'expend_diff',
#                  'apartment_avg_price_by_area_previous', 'apartment_avg_diff',
#                  'area_size', 'total_store_previous', 'store_count_diff',
#                  'total_working_population_previous',
#                  'total_facilities_previous']]
# 상주인구, 유동인구, 업종 다양성
X = merge_df[[
              'total_foot_traffic_previous',
              'rdi_previous',
              'total_resident_population_previous']]