import pandas as pd
from sklearn.preprocessing import MinMaxScaler
import matplotlib.pyplot as plt
import os

folder_path = 'files/chart/score'
os.makedirs(folder_path, exist_ok=True)

def draw_boxplot(target, title_name):
    # 박스플롯 그리기
    plt.figure(figsize=(8, 6))
    target.plot(kind='box')
    plt.title(title_name)

    # 파일로 저장
    plt.savefig(os.path.join(folder_path, title_name + '_boxplot'))
    plt.close()

def draw_hist(target, xlabel, title_name):
    # 히스토그램 그리기
    plt.hist(target, bins=20, color='skyblue', edgecolor='black')
    plt.title(title_name)
    plt.xlabel(xlabel)
    plt.ylabel('Frequency')

    # 파일로 저장
    plt.savefig(os.path.join(folder_path, title_name + '_boxplot'))
    plt.close()

def calc_scores(df_list, result_df, target_column_list):
    # 점수지표 뽑아야 하는 데이터 프레임, 타겟 컬럼 리스트로 받음
    for idx, df in enumerate(df_list):
        # 가장 최근 년분기 코드를 찾음
        max_year_quarter_code = df['year_quarter_code'].max()
        max_year_quarter_code_df = df[df['year_quarter_code'] == max_year_quarter_code][
            ['commercial_district_code', target_column_list[idx]]]

        draw_boxplot(df[target_column_list[idx]], str(max_year_quarter_code) + " boxplot of " + target_column_list[idx])

        # Q1(제1사분위수), Q3(제3사분위수) 계산
        Q1 = max_year_quarter_code_df[target_column_list[idx]].quantile(0.25)
        Q3 = max_year_quarter_code_df[target_column_list[idx]].quantile(0.75)
        IQR = Q3 - Q1

        # 이상치 기준 설정
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        # 이상치 탐지 및 total_resident_population_score 설정
        max_year_quarter_code_df[target_column_list[idx] + '_score'] = 100
        max_year_quarter_code_df.loc[
            max_year_quarter_code_df[target_column_list[idx]] < lower_bound, target_column_list[idx] + '_score'] = 0

        # 이상치 제거
        outliers_rm_df = max_year_quarter_code_df[(max_year_quarter_code_df[target_column_list[idx]] >= lower_bound) & (
                max_year_quarter_code_df[target_column_list[idx]] <= upper_bound)].copy()

        # MinMaxScaler 선언 및 Fitting
        mMscaler = MinMaxScaler()
        scaled_values = mMscaler.fit_transform(outliers_rm_df[[target_column_list[idx]]])

        # 스케일링된 값을 target_column_list[idx] 열에 대체
        max_year_quarter_code_df.loc[
            (max_year_quarter_code_df[target_column_list[idx]] >= lower_bound) & (max_year_quarter_code_df[
                                                                                      target_column_list[
                                                                                          idx]] <= upper_bound),
            target_column_list[idx] + '_score'] = scaled_values * 100

        # 히스토그램 그리기
        draw_hist(max_year_quarter_code_df[target_column_list[idx] + '_score'], target_column_list[idx] + '_score',
                  str(max_year_quarter_code) + ' histogram of ' + target_column_list[idx] + '_score')
        result_df = pd.merge(result_df,
                             max_year_quarter_code_df[['commercial_district_code', target_column_list[idx] + '_score']],
                             on=['commercial_district_code'], how='left')

    return result_df

# 이상치 찾기 및 대체
def replace_outliers(group):
    Q1 = group['monthly_sales'].quantile(0.25)
    Q3 = group['monthly_sales'].quantile(0.75)
    IQR = Q3 - Q1
    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR
    group.loc[group['monthly_sales'] < lower_bound, 'monthly_sales_score'] = 0
    group.loc[group['monthly_sales'] > upper_bound, 'monthly_sales_score'] = 100
    outliers_rm_group = group.loc[(group['monthly_sales'] <= upper_bound) & (group['monthly_sales'] >= lower_bound)]

    # MinMaxScaler 선언 및 Fitting
    mMscaler = MinMaxScaler()
    scaled_values = mMscaler.fit_transform(outliers_rm_group[['monthly_sales']])

    # 스케일링된 값을 'monthly_sales_score' 열에 대체
    group.loc[
        (group['monthly_sales'] <= upper_bound) & (group['monthly_sales'] >= lower_bound),
        'monthly_sales_score'] = scaled_values * 100

    return group

def calc_sales_score(sales_commercial_district_df, store_with_commercial_district_df, area_with_commercial_district_df):
    # 가장 최근 년분기 코드 찾기
    max_year_quarter_code = sales_commercial_district_df['year_quarter_code'].max()

    # 가장 최근 년분기 코드에 해당하는 데이터셋 필터링
    filtered_sales_commercial_district_df = sales_commercial_district_df[
        sales_commercial_district_df['year_quarter_code'] == max_year_quarter_code]
    filtered_store_with_commercial_district_df = store_with_commercial_district_df[
        store_with_commercial_district_df['year_quarter_code'] == max_year_quarter_code]
    merged_df = pd.merge(filtered_sales_commercial_district_df[
                             ['year_quarter_code', 'commercial_district_code', 'service_code', 'monthly_sales']],
                         filtered_store_with_commercial_district_df[
                             ['year_quarter_code', 'commercial_district_code', 'service_code', 'store_count']],
                         on=['year_quarter_code', 'commercial_district_code', 'service_code'], how='left')

    # 점포당 평균 월 매출 계산 작업
    merged_df["monthly_sales"] = merged_df.apply(
        lambda row: row["monthly_sales"] / row['store_count'] / 3 if row['store_count'] != 0 else row["monthly_sales"],
        axis=1)

    # 서비스업종코드별로 이상치 찾기 및 대체
    merged_df = merged_df.groupby('service_code', as_index=False).apply(replace_outliers)

    # 점포당 평균 월 매출 박스플롯 그리기
    draw_boxplot(merged_df["monthly_sales"], str(max_year_quarter_code) + " boxplot of monthly_sales")

    # 히스토그램 그리기
    draw_hist(merged_df['monthly_sales'], 'monthly_sales',
              str(max_year_quarter_code) + ' histogram of monthly_sales')

    # 히스토그램 그리기
    draw_hist(merged_df['monthly_sales_score'], 'monthly_sales_score',
              str(max_year_quarter_code) + ' histogram of monthly_sales_score')

    # 'monthly_sales_score' 열을 sales_commercial_district_df에 넣기
    sales_commercial_district_df = sales_commercial_district_df.merge(
        merged_df[['year_quarter_code', 'commercial_district_code', 'service_code', 'monthly_sales_score']],
        on=['year_quarter_code', 'commercial_district_code', 'service_code'], how='left')

    # 'monthly_sales_score' 열의 null 값을 0으로 대체
    sales_commercial_district_df['monthly_sales_score'].fillna(0, inplace=True)

    # 상권코드에 따라 groupby 후, monthly_sales 합 구하기
    merged_df['monthly_sales_mean_score'] = merged_df.groupby('commercial_district_code')[
        'monthly_sales_score'].transform('mean')

    # 결과를 새로운 데이터프레임으로 저장합니다
    monthly_sales_mean_by_district_df = merged_df.reset_index()

    area_with_commercial_district_df = pd.merge(area_with_commercial_district_df, monthly_sales_mean_by_district_df[[
        'commercial_district_code', 'monthly_sales_mean_score']],
                                                on=['commercial_district_code'], how='left')
    # commercial_district_code 중복값 제거
    area_with_commercial_district_df = area_with_commercial_district_df.drop_duplicates(subset=['commercial_district_code'])

    return sales_commercial_district_df, area_with_commercial_district_df

# 각 상권의 총 점수 계산하는 함수
def calc_total_score(area_with_commercial_district_df):
    area_with_commercial_district_df['commercial_district_total_score'] = area_with_commercial_district_df[
                                                                              'monthly_sales_mean_score'] + \
                                                                          area_with_commercial_district_df[
                                                                              'total_resident_population_score'] + \
                                                                          area_with_commercial_district_df[
                                                                              'total_foot_traffic_score'] + \
                                                                          area_with_commercial_district_df['rdi_score']
    return area_with_commercial_district_df

def calc_RDI(seoul_df, store_df, area_df, result_df):
    # 서울 년분기별 총 점포수
    year_quarter_code_groupby_all_store_counts = \
        seoul_df.groupby('year_quarter_code')['store_count'].sum()

    # 서울 년분기, 중분류 별 총 점포수
    year_quarter_code_and_middle_category_code_groupby_sum_store_count = \
        seoul_df.groupby(['year_quarter_code', 'middle_category_code'])['store_count'].sum()

    # sj :  j 업종 점포 개수/서울시 총 업종 점포 개수 → 업종의 종류만큼 도출
    seoul_middle_category_code_ratio_to_the_entire_industry_ratio = year_quarter_code_and_middle_category_code_groupby_sum_store_count / year_quarter_code_groupby_all_store_counts

    # 년분기, 상권코드 별 총 점포수
    year_quarter_code_and_commercial_district_code_groupby_all_store_counts = \
        store_df.groupby(['year_quarter_code', 'commercial_district_code'])['store_count'].sum()

    # 년분기, 상권코드, 중분류 별 총 점포수
    year_quarter_code_and_commercial_district_code_and_middle_category_code_groupby_sum_store_count = \
        store_df.groupby(['year_quarter_code', 'commercial_district_code', 'middle_category_code'])['store_count'].sum()

    # Sij : i 상권 내 j 업종 점포 개수 / i 상권의 총 점포 개수 → 업종의 종류 * 상권의 개수만큼 도출
    commercial_district_code_middle_category_code_ratio_to_the_entire_industry_ratio = year_quarter_code_and_commercial_district_code_and_middle_category_code_groupby_sum_store_count / year_quarter_code_and_commercial_district_code_groupby_all_store_counts

    df1 = commercial_district_code_middle_category_code_ratio_to_the_entire_industry_ratio.reset_index()
    df2 = seoul_middle_category_code_ratio_to_the_entire_industry_ratio.reset_index()

    df = df1.merge(df2, how='left', on=['year_quarter_code', 'middle_category_code'])
    df['rdi'] = abs(df['store_count_x'] - df['store_count_y'])

    result = ((df.groupby(['year_quarter_code', 'commercial_district_code'])['rdi'].sum()) ** -1).reset_index()

    result_df = result_df.merge(result, how='left', on=['year_quarter_code', 'commercial_district_code'])

    # 점포 밀도 계산
    area = area_df.groupby('commercial_district_code')[
        'area_size'].sum().reset_index()
    merged_df = year_quarter_code_and_commercial_district_code_groupby_all_store_counts.reset_index().merge(area,
                                                                                                            how='left',
                                                                                                            on='commercial_district_code')
    merged_df['store_density'] = merged_df['store_count'] / merged_df['area_size']

    result_df = result_df.merge(merged_df, how='left', on=['year_quarter_code',
                                                           'commercial_district_code'])
    result_df = result_df.drop(columns=['store_count', 'area_size'])

    return result_df
