import pandas as pd
import math
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

def calc_RDI(seoul_df, store_df):
    df = pd.DataFrame(columns=['기준_년분기_코드', '중분류_코드', '서울_중분류_코드_합', '서울_전체_업종_대비_중분류_코드_비율'])
    quater_codes = set(seoul_df['기준_년분기_코드'])

    for quater_code in quater_codes:
        # 중분류 코드 별 합 구하기
        groupby_quater = seoul_df.loc[seoul_df['기준_년분기_코드'] == quater_code].groupby('중분류_코드').sum()

        # 서울시 분기별 점포수 합
        seoul_all_stores = sum(seoul_df.loc[seoul_df['기준_년분기_코드'] == quater_code]['점포_수'])

        for idx, code in enumerate(groupby_quater.index):
            row = {
                '기준_년분기_코드': quater_code,
                '중분류_코드': code,
                '서울_중분류_코드_합': groupby_quater.loc[code, '점포_수'],
                '서울_전체_업종_대비_중분류_코드_비율': groupby_quater.loc[code, '점포_수'] / seoul_all_stores
            }
            df = pd.concat([df, pd.DataFrame(row, index=[0])], ignore_index=True)

    df.to_csv("./files/check/Sj.csv", index=False, encoding="CP949") # csv 추출

    # -----------------
    quater_codes2 = set(store_df['기준_년분기_코드'])-{20191,20192,20193,20194,20201,20202,20203,20204}
    # print("총 기준년도: ",len(quater_codes2))
    df2 = pd.DataFrame(columns=['기준_년분기_코드','상권_코드', '중분류_코드', '중분류_코드_합', '전체_업종_대비_중분류_코드_비율'])
    # total=0
    for quater_code2 in quater_codes2:
        print(quater_code2,"분기 시작")
        for store_code in set(store_df.loc[store_df['기준_년분기_코드'] == quater_code2]['상권_코드']):
            # 중분류 코드 별 합 구하기
            groupby_quater2 = store_df.loc[(store_df['기준_년분기_코드'] == quater_code2) & (store_df['상권_코드'] == store_code)].groupby('중분류_코드').sum()
            # 해당 상권에 없는 중분류 코드
            empty_datas = set(category_codes.keys()) - set(store_df.loc[(store_df['기준_년분기_코드'] == quater_code2) & (store_df['상권_코드'] == store_code)]['중분류_코드'])

            # 상권, 분기별 점포수 합
            all_stores = sum(store_df.loc[(store_df['기준_년분기_코드'] == quater_code2) & (store_df['상권_코드'] == store_code)]['점포_수'])

            for idx, code in enumerate(groupby_quater2.index):
                row = {
                    '기준_년분기_코드': quater_code2,
                    '상권_코드': store_code,
                    '중분류_코드': code,
                    '중분류_코드_합': groupby_quater2.loc[code, '점포_수'],
                    '전체_업종_대비_중분류_코드_비율': groupby_quater2.loc[code, '점포_수'] / all_stores,
                }
                df2 = pd.concat([df2, pd.DataFrame(row, index=[0])], ignore_index=True)

            for empty_code in empty_datas:
                row = {
                    '기준_년분기_코드': quater_code2,
                    '상권_코드': store_code,
                    '중분류_코드': empty_code,
                    '중분류_코드_합': 0,
                    '전체_업종_대비_중분류_코드_비율': 0,
                }
                df2 = pd.concat([df2, pd.DataFrame(row, index=[0])], ignore_index=True)

    df2.to_csv("./files/check/Sij.csv", index=False, encoding="CP949") # csv 추출

    # --------------
    df = pd.read_csv('files/check/Sj.csv', encoding='CP949')
    df2 = pd.read_csv('files/check/Sij.csv', encoding='CP949')

    # 서울시 상권분석서비스(영역-상권) 데이터셋 불러오기
    area_df = pd.read_csv('files/서울시 상권분석서비스(영역-상권).csv', encoding='CP949')

    # '상권_구분_코드'= 'A' (골목상권)인 데이터만 선택
    area_df = area_df[area_df['상권_구분_코드']=='A']

    # 필요한 영역 컬럼들만 가져오기
    area_df = area_df[['상권_코드','영역_면적']]

    # --------------
    rdi_quater_codes = set(df2['기준_년분기_코드'])-{20191,20192,20193,20194,20201,20202,20203,20204}
    df_RDI = pd.DataFrame(columns=['기준_년분기_코드','상권_코드', 'rdi','영역_면적','전체_점포수','점포_밀도'])

    for rdi_quater_code in rdi_quater_codes:
        cnt=0
        # 분기별 상권코드로 groupby
        groupby_store_code = df2.loc[(df2['기준_년분기_코드'] == rdi_quater_code)].groupby('상권_코드')

        sj_list = df.loc[df['기준_년분기_코드'] == rdi_quater_code][['중분류_코드', '서울_전체_업종_대비_중분류_코드_비율']]

        for store_code, group in groupby_store_code:
            total = 0

            # 분기별 상권코드로 groupby 후 중분류_코드, 전체_업종_대비_중분류_코드_비율 컬럼만 추출
            sij_list = group[['중분류_코드', '중분류_코드_합', '전체_업종_대비_중분류_코드_비율']]

            # 분기별 상퀀코드별 점포수 합
            store_total = sij_list['중분류_코드_합'].sum()

            for index, sij in sij_list.iterrows():
                sj_total = sj_list[sj_list['중분류_코드'] == sij['중분류_코드']]['서울_전체_업종_대비_중분류_코드_비율']
                if not sj_total.empty:
                    total += abs(sij['전체_업종_대비_중분류_코드_비율'] - sj_total.iloc[0])

            # 업종다양성 rdi 계산
            rdi = math.pow(total,-1)

            area = area_df[area_df['상권_코드']==store_code]['영역_면적']
            area_value = area.iloc[0] if not area.empty else 0

            row = {
                '기준_년분기_코드': rdi_quater_code,
                '상권_코드': store_code,
                'rdi': rdi,
                '영역_면적': area_value,
                '전체_점포수': store_total,
                '점포_밀도': store_total / area_value if area_value != 0 else 0
            }

            df_RDI = pd.concat([df_RDI, pd.DataFrame(row, index=[0])], ignore_index=True)

            cnt+=1
            print(rdi_quater_code, "분기 총 1090개 상권 중 ",cnt,"개 진행중! ",store_code," 상권")

    df_RDI.to_csv("./files/check/rdi.csv", index=False, encoding="CP949") # csv 추출
