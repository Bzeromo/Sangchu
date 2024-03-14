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

    working_population_with_commercial_district_df_set = set(
        df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['working_population_with_commercial_district_df']['commercial_district_code'])
    store_with_commercial_district_df_set = set(df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['store_with_commercial_district_df']['commercial_district_code'])
    sales_commercial_district_df_set = set(df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['sales_commercial_district_df']['commercial_district_code'])
    foot_traffic_with_commercial_district_df_set = set(
        df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['foot_traffic_with_commercial_district_df']['commercial_district_code'])
    resident_population_with_commercial_district_df_set = set(
        df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['resident_population_with_commercial_district_df']['commercial_district_code'])
    apartment_with_commercial_district_df_set = set(df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['apartment_with_commercial_district_df']['commercial_district_code'])
    facilities_with_commercial_district_df_set = set(
        df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['facilities_with_commercial_district_df']['commercial_district_code'])
    income_consumption_with_commercial_district_df_set = set(
        df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['income_consumption_with_commercial_district_df']['commercial_district_code'])
    commercial_district_change_indicator_with_commercial_district_df_set = set(
        df_dict['area_with_commercial_district_df']['commercial_district_code']) - set(
        df_dict['commercial_district_change_indicator_with_commercial_district_df']['commercial_district_code'])

    # 각각 몇개의 상권이 비었는지 체크
    print("working_population_with_commercial_district_df : ", working_population_with_commercial_district_df_set,
          len(working_population_with_commercial_district_df_set))
    print("store_with_commercial_district_df : ", store_with_commercial_district_df_set,
          len(store_with_commercial_district_df_set))
    print("sales_commercial_district_df : ", sales_commercial_district_df_set, len(sales_commercial_district_df_set))
    print("foot_traffic_with_commercial_district_df : ", foot_traffic_with_commercial_district_df_set,
          len(foot_traffic_with_commercial_district_df_set))
    print("resident_population_with_commercial_district_df : ", resident_population_with_commercial_district_df_set,
          len(resident_population_with_commercial_district_df_set))
    print("apartment_with_commercial_district_df : ", apartment_with_commercial_district_df_set,
          len(apartment_with_commercial_district_df_set))
    print("facilities_with_commercial_district_df : ", facilities_with_commercial_district_df_set,
          len(facilities_with_commercial_district_df_set))
    print("income_consumption_with_commercial_district_df : ", income_consumption_with_commercial_district_df_set,
          len(income_consumption_with_commercial_district_df_set))
    print("commercial_district_change_indicator_with_commercial_district_df : ",
          commercial_district_change_indicator_with_commercial_district_df_set,
          len(commercial_district_change_indicator_with_commercial_district_df_set))

    delete_codes = working_population_with_commercial_district_df_set.union(store_with_commercial_district_df_set,
                                                                            sales_commercial_district_df_set,
                                                                            foot_traffic_with_commercial_district_df_set,
                                                                            resident_population_with_commercial_district_df_set,
                                                                            apartment_with_commercial_district_df_set,
                                                                            facilities_with_commercial_district_df_set,
                                                                            income_consumption_with_commercial_district_df_set,
                                                                            commercial_district_change_indicator_with_commercial_district_df_set)
    print("제거할 상권코드 : ", delete_codes, len(delete_codes))



    return delete_them_do_not_have_commercial_district_code(delete_codes, df_dict)


# 제거할 상권코드 제거
def delete_them_do_not_have_commercial_district_code(delete_codes, df_dict):
    print("상권 코드 제거 진행")
    for key, df in tqdm(df_dict.items()):
        df_dict[key] = df[~df['commercial_district_code'].isin(delete_codes)]

    return df_dict
