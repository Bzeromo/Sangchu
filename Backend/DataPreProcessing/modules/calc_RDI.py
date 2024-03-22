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
    df['rdi'] = abs(df['store_count_x'] - df[
        'store_count_y'])

    result = ((df.groupby(['year_quarter_code', 'commercial_district_code'])['rdi'].sum()) ** -1).reset_index()

    result_df = result_df.merge(result, how='left', on=['year_quarter_code',
                                                        'commercial_district_code'])
    # 점포 밀도 계산
    area = area_df.groupby('commercial_district_code')[
        'area_size'].sum().reset_index()
    merged_df = year_quarter_code_and_commercial_district_code_groupby_all_store_counts.reset_index().merge(area,
                                                                                                            how='left',
                                                                                                            on='commercial_district_code')
    merged_df['store_density'] = merged_df['store_count'] / merged_df[
        'area_size']

    result_df = result_df.merge(merged_df, how='left', on=['year_quarter_code',
                                                           'commercial_district_code'])
    result_df = result_df.drop(columns=['store_count', 'area_size'])

    return result_df
