from tqdm import tqdm
def check_do_not_have_commercial_district_code(df_list):
    print("제거할 상권코드 탐색")
    df_names = [
        "area_with_commercial_district_df",
        "store_with_commercial_district_df",
        "sales_commercial_district_df",
        "income_consumption_with_commercial_district_df",
        "commercial_district_change_indicator_with_commercial_district_df",
        "foot_traffic_with_commercial_district_df",
        "resident_population_with_commercial_district_df",
        "facilities_with_commercial_district_df",
        "apartment_with_commercial_district_df",
        "working_population_with_commercial_district_df"
    ]

    # 데이터프레임 이름을 키로 갖고, 데이터프레임을 값으로 갖는 딕셔너리 생성
    df_dict = dict(zip(df_names, df_list))

    # area_with_commercial_district_df의 상권 코드를 하나의 set으로 만듦
    all_area_codes = set(df_dict['area_with_commercial_district_df']['commercial_district_code'])

    # 각 년분기별로 상권 코드의 set을 구하고, 차집합을 구한 뒤 합집합을 구하기
    delete_codes = set()

    for key, df in df_dict.items():
        if key == 'area_with_commercial_district_df':
            continue
        elif key == 'commercial_district_change_indicator_with_commercial_district_df':
            delete_codes.update(all_area_codes - set(df['commercial_district_code']))
        else:
            delete_codes.update(set().union(*[all_area_codes - set(group['commercial_district_code']) for name, group in
                                             df.groupby('year_quarter_code')]))
        print(delete_codes)

    print("제거할 상권코드 : ", delete_codes, len(delete_codes))

    return delete_them_do_not_have_commercial_district_code(delete_codes, df_dict)


# 제거할 상권코드 제거
def delete_them_do_not_have_commercial_district_code(delete_codes, df_dict):
    print("상권 코드 제거 진행")
    for key, df in tqdm(df_dict.items()):
        df_dict[key] = df[~df['commercial_district_code'].isin(delete_codes)]

    return df_dict
