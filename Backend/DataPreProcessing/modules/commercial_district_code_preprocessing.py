from tqdm import tqdm

def clean_commercial_district_codes(dfs):
    # 기준이 되는 상권 코드 추출
    all_area_codes = set(dfs['area_with_commercial_district']['commercial_district_code'])
    delete_codes = set()

    # 각 데이터프레임에 대한 상권 코드 탐색 및 제거할 상권코드 선정
    for key, df in dfs.items():
        current_codes = set(df['commercial_district_code'])
        if 'year_quarter_code' in df.columns:
            # 년분기별 상권 코드 차집합 계산
            grouped_codes = set().union(*[all_area_codes - set(group['commercial_district_code']) for _, group in df.groupby('year_quarter_code')])
            delete_codes.update(grouped_codes)
        else:
            # 단일 상권 코드 차집합 계산
            delete_codes.update(all_area_codes - current_codes)

    # 상권 코드 제거
    print(f"제거할 상권코드: {delete_codes}, 총 {len(delete_codes)}개")

    for key, df in tqdm(dfs.items(), desc="상권 코드 제거 진행"):
        dfs[key] = df[~df['commercial_district_code'].isin(delete_codes)]

    return dfs
