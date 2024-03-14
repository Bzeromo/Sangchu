import pandas as pd
import math
from tqdm import tqdm

# 논문 1번 업종 다양성 구하기 위해
# Sj = j 업종 점포 개수/서울시 총 업종 점포 개수 -> 서울시 전체에서 업종 j가 차지하는 비율
# Sij = i 상권 내 j 업종 점포 개수 / i 상권의 총 점포 개수

category_codes = {
    'C0101' : "음식(식사)",
    'C0102' : "제과/커피",
    'C0103' : "호프간이주점",
    'C0201' : "학원",
    'C0202' : "의원",
    'C0203' : "여가/미용",
    'C0204' : "기타 서비스",
    'C0301' : "생활소매",
    'C0302' : "전자소매",
    'C0303' : "잡화소매"
}

def calc_RDI(seoul_df, store_df, area_df, result_df):
    # ['기준_년분기_코드', '중분류_코드', '서울_중분류_코드_합', '서울_seoul_middle_category_code_ratio_to_the_entire_industry_ratio']
    df = pd.DataFrame(columns=['year_quarter_code', 'middle_category_code', 'seoul_middle_category_code_store_total', 'seoul_middle_category_code_ratio_to_the_entire_industry_ratio'])
    quater_codes = set(seoul_df['year_quarter_code'])

    for quater_code in quater_codes:
        # 중분류 코드 별 합 구하기
        groupby_quater = seoul_df.loc[seoul_df['year_quarter_code'] == quater_code].groupby('middle_category_code').sum()

        # 서울시 분기별 점포수 합
        seoul_all_stores = sum(seoul_df.loc[seoul_df['year_quarter_code'] == quater_code]['store_count'])

        for idx, code in enumerate(groupby_quater.index):
            row = {
                'year_quarter_code': quater_code,
                'middle_category_code': code,
                'seoul_middle_category_code_store_total': groupby_quater.loc[code, 'store_count'],
                'seoul_middle_category_code_ratio_to_the_entire_industry_ratio': groupby_quater.loc[code, 'store_count'] / seoul_all_stores
            }
            df = pd.concat([df, pd.DataFrame(row, index=[0])], ignore_index=True)

    # -----------------
    quater_codes2 = set(store_df['year_quarter_code'])
    df2 = pd.DataFrame(columns=['year_quarter_code','commercial_district_code', 'middle_category_code', 'middle_category_code_store_total', 'middle_category_code_ratio_to_the_entire_industry_ratio'])
    for quater_code2 in quater_codes2:
        print(quater_code2,"분기 시작")
        for store_code in set(store_df.loc[store_df['year_quarter_code'] == quater_code2]['commercial_district_code']):
            # 중분류 코드 별 합 구하기
            groupby_quater2 = store_df.loc[(store_df['year_quarter_code'] == quater_code2) & (store_df['commercial_district_code'] == store_code)].groupby('middle_category_code').sum()
            # 해당 상권에 없는 중분류 코드
            empty_datas = set(category_codes.keys()) - set(store_df.loc[(store_df['year_quarter_code'] == quater_code2) & (store_df['commercial_district_code'] == store_code)]['middle_category_code'])

            # 상권, 분기별 점포수 합
            all_stores = sum(store_df.loc[(store_df['year_quarter_code'] == quater_code2) & (store_df['commercial_district_code'] == store_code)]['store_count'])

            for idx, code in enumerate(groupby_quater2.index):
                row = {
                    'year_quarter_code': quater_code2,
                    'commercial_district_code': store_code,
                    'middle_category_code': code,
                    'middle_category_code_store_total': groupby_quater2.loc[code, 'store_count'],
                    'middle_category_code_ratio_to_the_entire_industry_ratio': groupby_quater2.loc[code, 'store_count'] / all_stores,
                }
                df2 = pd.concat([df2, pd.DataFrame(row, index=[0])], ignore_index=True)

            for empty_code in empty_datas:
                row = {
                    'year_quarter_code': quater_code2,
                    'commercial_district_code': store_code,
                    'middle_category_code': empty_code,
                    'middle_category_code_store_total': 0,
                    'middle_category_code_ratio_to_the_entire_industry_ratio': 0,
                }
                df2 = pd.concat([df2, pd.DataFrame(row, index=[0])], ignore_index=True)

    # --------------

    # 필요한 영역 컬럼들만 가져오기
    area_df = area_df[['commercial_district_code','area_size']]

    # --------------
    quater_codes = set(store_df['year_quarter_code'])
    for rdi_quater_code in tqdm(quater_codes):
        # 분기별 상권코드로 groupby
        groupby_store_code = df2.loc[(df2['year_quarter_code'] == rdi_quater_code)].groupby('commercial_district_code')

        sj_list = df.loc[df['year_quarter_code'] == rdi_quater_code][['middle_category_code', 'seoul_middle_category_code_ratio_to_the_entire_industry_ratio']]

        for store_code, group in groupby_store_code:
            total = 0
            # 분기별 상권코드로 groupby 후 중분류_코드, seoul_middle_category_code_ratio_to_the_entire_industry_ratio 컬럼만 추출
            sij_list = group[['middle_category_code', 'middle_category_code_store_total', 'middle_category_code_ratio_to_the_entire_industry_ratio']]

            # 분기별 상퀀코드별 점포수 합
            store_total = sij_list['middle_category_code_store_total'].sum()

            for index, sij in sij_list.iterrows():
                sj_total = sj_list[sj_list['middle_category_code'] == sij['middle_category_code']]['seoul_middle_category_code_ratio_to_the_entire_industry_ratio']
                if not sj_total.empty:
                    total += abs(sij['middle_category_code_ratio_to_the_entire_industry_ratio'] - sj_total.iloc[0])

            # 업종다양성 rdi 계산
            rdi = math.pow(total,-1)

            area = area_df[area_df['commercial_district_code']==store_code]['area_size']
            area_value = area.iloc[0] if not area.empty else 0

            target_row_idx = result_df.index[(result_df['year_quarter_code'] == rdi_quater_code) & (result_df['commercial_district_code'] == store_code)]
            result_df.loc[target_row_idx, 'rdi'] = rdi
            # result_df.loc[target_row_idx, 'area_size'] = area_value
            # result_df.loc[target_row_idx, 'total_store_count'] = store_total
            result_df.loc[target_row_idx, 'store_density'] = store_total / area_value if area_value != 0 else 0

    return result_df
