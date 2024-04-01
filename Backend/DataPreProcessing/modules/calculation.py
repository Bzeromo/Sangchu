import pandas as pd
from sklearn.preprocessing import MinMaxScaler
import os

folder_path = 'files/chart/score'
os.makedirs(folder_path, exist_ok=True)

def calc_scores(df_list, result_df, target_column_list):
    # 점수지표 뽑아야 하는 데이터 프레임, 타겟 컬럼 리스트로 받음
    for idx, df in enumerate(df_list):
        # 가장 최근 년분기 코드를 찾음
        max_year_quarter_code = df['year_quarter_code'].max()
        max_year_quarter_code_df = df[df['year_quarter_code'] == max_year_quarter_code][
            ['commercial_district_code', target_column_list[idx]]].copy()

        # Q1(제1사분위수), Q3(제3사분위수) 계산
        Q1 = max_year_quarter_code_df[target_column_list[idx]].quantile(0.25)
        Q3 = max_year_quarter_code_df[target_column_list[idx]].quantile(0.75)

        # 이상치 기준 설정
        IQR = Q3 - Q1
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        score_column = target_column_list[idx] + '_score'
        max_year_quarter_code_df[score_column] = 100
        max_year_quarter_code_df.loc[max_year_quarter_code_df[target_column_list[idx]] < lower_bound, score_column] = 0

        valid_idx = (max_year_quarter_code_df[target_column_list[idx]] >= lower_bound) & (
                    max_year_quarter_code_df[target_column_list[idx]] <= upper_bound)
        # 이상치 제거
        outliers_rm_df = max_year_quarter_code_df[valid_idx].copy()

        if not outliers_rm_df.empty:
            # MinMaxScaler 선언 및 Fitting
            mMscaler = MinMaxScaler()
            scaled_values = mMscaler.fit_transform(outliers_rm_df[[target_column_list[idx]]])

            # 스케일링된 값을 target_column_list[idx] 열에 대체하기 전에, 해당 컬럼의 데이터 타입을 float으로 변환
            max_year_quarter_code_df[score_column] = max_year_quarter_code_df[score_column].astype(float)

            # 스케일링된 값을 할당
            max_year_quarter_code_df.loc[
                valid_idx, score_column
            ] = (scaled_values * 100).astype(float)

        result_df = pd.merge(result_df, max_year_quarter_code_df[['commercial_district_code', score_column]],
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

    # 서비스업종코드별로 이상치 찾기 및 대체
    merged_df = merged_df.groupby('service_code', as_index=False).apply(replace_outliers)

    # 'monthly_sales_score' 열을 sales_commercial_district_df에 넣기
    sales_commercial_district_df = sales_commercial_district_df.merge(
        merged_df[['year_quarter_code', 'commercial_district_code', 'service_code', 'monthly_sales_score']],
        on=['year_quarter_code', 'commercial_district_code', 'service_code'], how='left')

    # 'monthly_sales_score' 열의 null 값을 0으로 대체
    sales_commercial_district_df['monthly_sales_score'] = sales_commercial_district_df['monthly_sales_score'].fillna(0)

    # 상권코드에 따라 groupby 후, monthly_sales 합 구하기
    merged_df['monthly_sales_mean_score'] = merged_df.groupby('commercial_district_code')[
        'monthly_sales_score'].transform('mean')

    # 결과를 새로운 데이터프레임으로 저장합니다
    monthly_sales_mean_by_district_df = merged_df.reset_index()

    area_with_commercial_district_df = pd.merge(area_with_commercial_district_df, monthly_sales_mean_by_district_df[[
        'commercial_district_code', 'monthly_sales_mean_score']],
                                                on=['commercial_district_code'], how='left')
    # commercial_district_code 중복값 제거
    area_with_commercial_district_df = area_with_commercial_district_df.drop_duplicates(
        subset=['commercial_district_code'])

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

    merged_df['store_count'] = pd.to_numeric(merged_df['store_count'], errors='coerce')
    merged_df['area_size'] = pd.to_numeric(merged_df['area_size'], errors='coerce')

    merged_df['store_density'] = merged_df['store_count'] / merged_df['area_size']

    result_df = result_df.merge(merged_df, how='left', on=['year_quarter_code',
                                                           'commercial_district_code'])
    result_df = result_df.drop(columns=['store_count', 'area_size'])

    return result_df


def calc_sales_divide_store_count(sales_commercial_district_df, store_with_commercial_district_df):
    # sales 데이터셋의 모든 컬럼과 store 데이터셋과 병합
    merged_df = pd.merge(sales_commercial_district_df,
                         store_with_commercial_district_df[
                             ['year_quarter_code', 'commercial_district_code', 'service_code', 'similar_store_count']],
                         on=['year_quarter_code', 'commercial_district_code', 'service_code'], how='left')
    merged_df.to_csv("files/api/check_sales.csv", encoding='CP949', index=False)
    # 점포 수로 나누는 작업
    sales_columns = sales_commercial_district_df.columns.difference(
        ['year_quarter_code', 'commercial_district_code', 'commercial_district_name', 'service_code', 'service_name',
         'major_category_code', 'major_category_code_name', 'middle_category_code', 'middle_category_code_name'])

    for column in sales_columns:
        merged_df[column] = merged_df.apply(
            lambda x: x[column] / x['similar_store_count'] / 3, axis=1)

    # sales 데이터만 분리
    calc_sales_df = merged_df[
        ['year_quarter_code', 'commercial_district_code', 'commercial_district_name',
         'service_code', 'service_name', 'major_category_code', 'major_category_code_name',
         'middle_category_code', 'middle_category_code_name'] + list(sales_columns)]

    return calc_sales_df
