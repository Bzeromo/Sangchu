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
        selected_columns = ['commercial_district_code'] + target_column_list[idx]
        max_year_quarter_code_df = df[df['year_quarter_code'] == max_year_quarter_code][selected_columns].copy()

        # target_column_list[idx]의 각 컬럼에 대한 처리
        for col in target_column_list[idx]:
            # Q1(제1사분위수), Q3(제3사분위수) 계산
            Q1 = max_year_quarter_code_df[col].quantile(0.25)
            Q3 = max_year_quarter_code_df[col].quantile(0.75)

            # 이상치 기준 설정
            IQR = Q3 - Q1
            lower_bound = Q1 - 1.5 * IQR
            upper_bound = Q3 + 1.5 * IQR

            # 이상치를 제외한 데이터에 대한 점수 계산
            score_column = col + '_score'
            max_year_quarter_code_df[score_column] = 100.0
            max_year_quarter_code_df.loc[max_year_quarter_code_df[col] < lower_bound, score_column] = 0

            # 이상치가 아닌 데이터의 인덱스
            valid_idx = (max_year_quarter_code_df[col] >= lower_bound) & (max_year_quarter_code_df[col] <= upper_bound)

            # 이상치 제거
            outliers_rm_df = max_year_quarter_code_df[valid_idx].copy()

            if not outliers_rm_df.empty:
                # MinMaxScaler 선언 및 Fitting
                mMscaler = MinMaxScaler()
                scaled_values = mMscaler.fit_transform(outliers_rm_df[[col]])  # 스케일링

                # 스케일링된 값을 점수 컬럼에 할당
                max_year_quarter_code_df.loc[valid_idx, score_column] = (scaled_values * 100).astype(float)

        # 계산된 점수 컬럼을 결과 데이터프레임에 병합
        for col in target_column_list[idx]:
            score_column = col + '_score'
            result_df = pd.merge(result_df, max_year_quarter_code_df[['commercial_district_code', score_column]],
                                 on=['commercial_district_code'], how='left')

    return result_df


# 이상치 찾기 및 대체
def replace_outliers(group, target_column):
    Q1 = group[target_column].quantile(0.25)
    Q3 = group[target_column].quantile(0.75)
    IQR = Q3 - Q1
    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR
    group.loc[group[target_column] < lower_bound, target_column + '_score'] = 0
    group.loc[group[target_column] > upper_bound, target_column + '_score'] = 100
    outliers_rm_group = group.loc[(group[target_column] <= upper_bound) & (group[target_column] >= lower_bound)]

    # MinMaxScaler 선언 및 Fitting
    mMscaler = MinMaxScaler()
    scaled_values = mMscaler.fit_transform(outliers_rm_group[[target_column]])

    # 스케일링된 값을 'monthly_sales_score' 열에 대체
    group.loc[
        (group[target_column] <= upper_bound) & (
                group[target_column] >= lower_bound), target_column + '_score'] = scaled_values * 100
    return group


def calc_sales_score(df_list, area_with_commercial_district_df, target_column_list):
    result_df = []
    for idx, df in enumerate(df_list):
        # 가장 최근 년분기 코드 찾기
        max_year_quarter_code = df['year_quarter_code'].max()

        # 가장 최근 년분기 코드에 해당하는 데이터셋 필터링 및 서비스 업종 코드 별 이상치 찾기 및 대체
        filtered_df = df[
            df['year_quarter_code'] == max_year_quarter_code].groupby('service_code').apply(
            lambda x: replace_outliers(x, target_column_list[idx])).reset_index(drop=True)

        # 'monthly_sales_score' 열을 df에 넣기
        df = df.merge(
            filtered_df[
                ['year_quarter_code', 'commercial_district_code', 'service_code', target_column_list[idx] + '_score']],
            on=['year_quarter_code', 'commercial_district_code', 'service_code'], how='left')

        # 'monthly_sales_score' 열의 null 값을 0으로 대체
        # df[target_column_list[idx] + '_score'] = df[target_column_list[idx] + '_score'].fillna(0)

        # 상권코드에 따라 groupby 후, monthly_sales 합 구하기
        filtered_df[target_column_list[idx] + '_mean_score'] = filtered_df.groupby('commercial_district_code')[
            target_column_list[idx] + '_score'].transform('mean')

        # 결과를 새로운 데이터프레임으로 저장합니다
        mean_by_district_df = filtered_df.reset_index()

        area_with_commercial_district_df = pd.merge(area_with_commercial_district_df,
                                                    mean_by_district_df[[
                                                        'commercial_district_code',
                                                        target_column_list[idx] + '_mean_score']],
                                                    on=['commercial_district_code'], how='left')
        # commercial_district_code 중복값 제거
        area_with_commercial_district_df = area_with_commercial_district_df.drop_duplicates(
            subset=['commercial_district_code'])

        result_df.append(df)
    return *result_df, area_with_commercial_district_df


# 각 상권의 총 점수 계산하는 함수
def calc_total_score(area_with_commercial_district_df, sales_commercial_district_df, store_with_commercial_district_df):
    score_columns = [
        'total_resident_population_score',
        'total_foot_traffic_score',
        'rdi_score',
        'total_working_population_score',
        'apartment_avg_price_score',
        'facilities_score',
        'monthly_average_income_amount_score',
        'expenditure_total_amount_score'
    ]

    area_score_columns = ['monthly_sales_mean_score', 'store_count_mean_score']
    service_score_columns = ['monthly_sales_score', 'store_count_score']

    weights = [
        0.00458549459238878, 0.00752792787216622, 0.008872766, 0.00663659,
        0.006537721, 0.005026187, 0.005673911, 0.004903813
    ]

    sales_and_store_score_weight = [0.94228724327493, 0.00794834653626661]

    # 각 점수에 해당하는 가중치를 곱하고 합산하여 총점 계산
    area_with_commercial_district_df['commercial_district_total_score'] = area_with_commercial_district_df[
        area_score_columns + score_columns].mul(sales_and_store_score_weight + weights, axis=1).sum(axis=1)

    # 서비스 업종별 총점을 계산하기 위해 merge 작업 진행
    merged_sales_store_df = pd.merge(
        sales_commercial_district_df,
        store_with_commercial_district_df[
            ['commercial_district_code', 'year_quarter_code', 'service_code', 'store_count_score']],
        on=['commercial_district_code', 'year_quarter_code', 'service_code'],
        how='left'
    )

    merged_sales_store_area_df = pd.merge(
        merged_sales_store_df,
        area_with_commercial_district_df[['commercial_district_code'] + score_columns],
        on=['commercial_district_code'],
        how='left'
    )

    merged_sales_store_area_df['commercial_service_total_score'] = merged_sales_store_area_df[
        service_score_columns + score_columns].mul(sales_and_store_score_weight + weights, axis=1).sum(axis=1,
                                                                                                       skipna=False)

    return area_with_commercial_district_df, merged_sales_store_area_df.drop(
        columns=score_columns + ['store_count_score'])


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
