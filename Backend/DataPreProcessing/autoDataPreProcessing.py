from modules.majorAndMiddleCategoryPreProcessing import \
    categorization_into_major_and_medium_categories_by_service_industry_code_name
from modules.calc_RDI import calc_RDI
from modules.commercialDistrictCodePreProcessing import check_do_not_have_commercial_district_code
import pandas as pd
from pyproj import Transformer
from sqlalchemy import create_engine
import json
import time

# 시작
start = time.time()

# 영역-상권 전처리
area_with_commercial_district_df = pd.read_csv(
    'files/dataset/서울시 상권분석서비스(영역-상권).csv', encoding='CP949')

# 2021년 1분기 이상 컬럼은 ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
area_with_commercial_district_df = area_with_commercial_district_df[area_with_commercial_district_df['상권_구분_코드'] == 'A']

# 필요 없는 컬럼 삭제
area_with_commercial_district_df = area_with_commercial_district_df.drop(
    columns=['상권_구분_코드', '상권_구분_코드_명'])

# 결측치 확인 및 출력
missing_values = area_with_commercial_district_df.isna().sum()

if missing_values.any():
    print("영역-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("영역-상권 결측치가 없습니다.")

# Transformer 인스턴스 생성
transformer = Transformer.from_crs("epsg:5181", "epsg:4326", always_xy=True)


# 좌표 변환 함수, 기존 열을 업데이트
def transform_coords(row):
    x_4326, y_4326 = transformer.transform(row['엑스좌표_값'], row['와이좌표_값'])
    return pd.Series({'엑스좌표_값': x_4326, '와이좌표_값': y_4326})


# 좌표 변환 적용 및 기존 열 업데이트
area_with_commercial_district_df[['엑스좌표_값', '와이좌표_값']] = area_with_commercial_district_df.apply(transform_coords,
                                                                                                axis=1)

# 각 컬럼들 이름 변경 필요
area_with_commercial_district_df = area_with_commercial_district_df.rename(columns={
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '엑스좌표_값': 'latitude',
    '와이좌표_값': 'longitude',
    '자치구_코드': 'gu_code',
    '자치구_코드_명': 'gu_name',
    '행정동_코드': 'dong_code',
    '행정동_코드_명': 'dong_name',
    '영역_면적': 'area_size'
})

# 점포-상권 전처리
# csv 파일 읽어오기
store_with_commercial_district_df = pd.read_csv('files/dataset/서울시 상권분석서비스(점포-상권).csv', encoding='CP949')

# 2021년 1분기 이상, 골목상권만 컬럼은 ['기준_년분기_코드', '상권_코드', '상권_코드_명', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
store_with_commercial_district_df = store_with_commercial_district_df[
    (store_with_commercial_district_df['기준_년분기_코드'] >= 20211) & (store_with_commercial_district_df['상권_구분_코드'] == 'A')][
    ['기준_년분기_코드', '상권_코드', '상권_코드_명', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']]

# 결측치 확인 및 출력
missing_values = store_with_commercial_district_df.isna().sum()

if missing_values.any():
    print("점포-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("점포-상권 결측치가 없습니다.")

# 대분류,중분류 컬럼 생성하여 분류 작업 진행
store_with_commercial_district_df = categorization_into_major_and_medium_categories_by_service_industry_code_name(
    store_with_commercial_district_df)

# 각 컬럼들 이름 변경
store_with_commercial_district_df = store_with_commercial_district_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '대분류_코드': 'major_category_code',
    '대분류_코드명': 'major_category_name',
    '중분류_코드': 'middle_category_code',
    '중분류_코드_명': 'middle_category_name',
    '서비스_업종_코드': 'service_code',
    '서비스_업종_코드_명': 'service_name',
    '점포_수': 'store_count',
    '프랜차이즈_점포_수': 'franchise_store_count'
})

# -----------------------

# 점포-서울시 전처리
store_with_seoul_df = pd.read_csv('files/dataset/서울시 상권분석서비스(점포-서울시).csv', encoding='CP949')

# 2021년 1분기 이상 컬럼은 ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
store_with_seoul_df = store_with_seoul_df[store_with_seoul_df['기준_년분기_코드'] >= 20211][
    ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']]

# 결측치 확인 및 출력
missing_values = store_with_seoul_df.isna().sum()

if missing_values.any():
    print("점포-서울시 결측치가 있습니다:")
    print(missing_values)
else:
    print("점포-서울시 결측치가 없습니다.")

# 대분류,중분류 컬럼 생성하여 분류 작업 진행
store_with_seoul_df = categorization_into_major_and_medium_categories_by_service_industry_code_name(store_with_seoul_df)

# 각 컬럼들 이름 변경
store_with_seoul_df = store_with_seoul_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '대분류_코드': 'major_category_code',
    '대분류_코드명': 'major_category_name',
    '중분류_코드': 'middle_category_code',
    '중분류_코드_명': 'middle_category_name',
    '서비스_업종_코드': 'service_code',
    '서비스_업종_코드_명': 'service_name',
    '점포_수': 'store_count',
    '프랜차이즈_점포_수': 'franchise_store_count'
})

# 매출-상권 전처리
# csv 파일 읽어오기
sales_commercial_district_df = pd.read_csv('files/dataset/서울시 상권분석서비스(추정매출-상권).csv', encoding='CP949')

# 2021년 1분기 이상, 골목상권만 채택
sales_commercial_district_df = sales_commercial_district_df[
    (sales_commercial_district_df['기준_년분기_코드'] >= 20211) & (sales_commercial_district_df['상권_구분_코드'] == 'A')]

# 상권_구분_코드, 상권_구분_코드_명 컬럼 삭제
sales_commercial_district_df = sales_commercial_district_df.drop(columns=['상권_구분_코드', '상권_구분_코드_명'])

# 결측치 확인 및 출력
missing_values = sales_commercial_district_df.isna().sum()

if missing_values.any():
    print("매출-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("매출-상권 결측치가 없습니다.")

# 대분류,중분류 컬럼 생성하여 분류 작업 진행
sales_commercial_district_df = categorization_into_major_and_medium_categories_by_service_industry_code_name(
    sales_commercial_district_df)

# 각 컬럼들 이름 변경 필요 ***********
sales_commercial_district_df = sales_commercial_district_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '대분류_코드': 'major_category_code',
    '대분류_코드명': 'major_category_name',
    '중분류_코드': 'middle_category_code',
    '중분류_코드_명': 'middle_category_name',
    '서비스_업종_코드': 'service_code',
    '서비스_업종_코드_명': 'service_name',
    '당월_매출_금액': 'monthly_sales',
    '당월_매출_건수': 'monthly_sales_count',
    '주중_매출_금액': 'week_days_sales',
    '주말_매출_금액': 'weekend_sales',
    '월요일_매출_금액': 'mon_sales',
    '화요일_매출_금액': 'tue_sales',
    '수요일_매출_금액': 'wed_sales',
    '목요일_매출_금액': 'thu_sales',
    '금요일_매출_금액': 'fri_sales',
    '토요일_매출_금액': 'sat_sales',
    '일요일_매출_금액': 'sun_sales',
    '시간대_00~06_매출_금액': 'time_00_to_06_sales',
    '시간대_06~11_매출_금액': 'time_06_to_11_sales',
    '시간대_11~14_매출_금액': 'time_11_to_14_sales',
    '시간대_14~17_매출_금액': 'time_14_to_17_sales',
    '시간대_17~21_매출_금액': 'time_17_to_21_sales',
    '시간대_21~24_매출_금액': 'time_21_to_24_sales',
    '남성_매출_금액': 'man_sales',
    '여성_매출_금액': 'woman_sales',
    '연령대_10_매출_금액': 'age_10_sales',
    '연령대_20_매출_금액': 'age_20_sales',
    '연령대_30_매출_금액': 'age_30_sales',
    '연령대_40_매출_금액': 'age_40_sales',
    '연령대_50_매출_금액': 'age_50_sales',
    '연령대_60_이상_매출_금액': 'age_over_60_sales',
    '주중_매출_건수': 'week_days_sales_count',
    '주말_매출_건수': 'weekend_sales_count',
    '월요일_매출_건수': 'mon_sales_count',
    '화요일_매출_건수': 'tue_sales_count',
    '수요일_매출_건수': 'wed_sales_count',
    '목요일_매출_건수': 'thu_sales_count',
    '금요일_매출_건수': 'fri_sales_count',
    '토요일_매출_건수': 'sat_sales_count',
    '일요일_매출_건수': 'sun_sales_count',
    '남성_매출_건수': 'man_sales_count',
    '여성_매출_건수': 'woman_sales_count',
    '시간대_건수~06_매출_건수': 'time_00_to_06_sales_count',
    '시간대_건수~11_매출_건수': 'time_06_to_11_sales_count',
    '시간대_건수~14_매출_건수': 'time_11_to_14_sales_count',
    '시간대_건수~17_매출_건수': 'time_14_to_17_sales_count',
    '시간대_건수~21_매출_건수': 'time_17_to_21_sales_count',
    '시간대_건수~24_매출_건수': 'time_21_to_24_sales_count',
    '연령대_10_매출_건수': 'age_10_sales_count',
    '연령대_20_매출_건수': 'age_20_sales_count',
    '연령대_30_매출_건수': 'age_30_sales_count',
    '연령대_40_매출_건수': 'age_40_sales_count',
    '연령대_50_매출_건수': 'age_50_sales_count',
    '연령대_60_이상_매출_건수': 'age_over_60_sales_count'
})

# ------------

# 소득-상권 전처리
income_consumption_with_commercial_district_df = pd.read_csv('files/dataset/서울시 상권분석서비스(소득소비-상권).csv', encoding='CP949')

# 2021년 1분기 이상 컬럼은 ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
income_consumption_with_commercial_district_df = income_consumption_with_commercial_district_df[
    (income_consumption_with_commercial_district_df['기준_년분기_코드'] >= 20211) & (
            income_consumption_with_commercial_district_df['상권_구분_코드'] == 'A')][
    ['기준_년분기_코드', '상권_코드', '상권_코드_명', '월_평균_소득_금액', '지출_총금액']]

# 결측치 확인 및 출력
missing_values = income_consumption_with_commercial_district_df.isna().sum()

if missing_values.any():
    print("소득-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("소득-상권 결측치가 없습니다.")

# 각 컬럼들 이름 변경
income_consumption_with_commercial_district_df = income_consumption_with_commercial_district_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '월_평균_소득_금액': 'monthly_average_income_amount',
    '지출_총금액': 'expenditure_total_amount',
})

# --------------------------

# 상권변화지표-상권 전처리
commercial_district_change_indicator_with_commercial_district_df = pd.read_csv(
    'files/dataset/서울시 상권분석서비스(상권변화지표-상권).csv', encoding='CP949')

# 2021년 1분기 이상 컬럼은 ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
commercial_district_change_indicator_with_commercial_district_df = \
    commercial_district_change_indicator_with_commercial_district_df[
        (commercial_district_change_indicator_with_commercial_district_df['기준_년분기_코드'] >= 20211) & (
                commercial_district_change_indicator_with_commercial_district_df['상권_구분_코드'] == 'A')][
        ['기준_년분기_코드', '상권_코드', '상권_코드_명', '상권_변화_지표', '상권_변화_지표_명']]

# 결측치 확인 및 출력
missing_values = commercial_district_change_indicator_with_commercial_district_df.isna().sum()

if missing_values.any():
    print("상권변화지표-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("상권변화지표-상권 결측치가 없습니다.")

# 각 컬럼들 이름 변경
commercial_district_change_indicator_with_commercial_district_df = commercial_district_change_indicator_with_commercial_district_df.rename(
    columns={
        '기준_년분기_코드': 'year_quarter_code',
        '상권_코드': 'commercial_district_code',
        '상권_코드_명': 'commercial_district_name',
        '상권_변화_지표': 'commercial_district_change_indicator_code',
        '상권_변화_지표_명': 'commercial_district_change_indicator_name',
    })

commercial_district_change_indicator_with_commercial_district_df = calc_RDI(store_with_seoul_df,
                                                                            store_with_commercial_district_df,
                                                                            area_with_commercial_district_df,
                                                                            commercial_district_change_indicator_with_commercial_district_df)

# ------------------------

# 길단위인구-상권 전처리
foot_traffic_with_commercial_district_df = pd.read_csv(
    'files/dataset/서울시 상권분석서비스(길단위인구-상권).csv', encoding='CP949')

# 2021년 1분기 이상 컬럼은 ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
foot_traffic_with_commercial_district_df = \
    foot_traffic_with_commercial_district_df[
        (foot_traffic_with_commercial_district_df['기준_년분기_코드'] >= 20211) & (
                foot_traffic_with_commercial_district_df['상권_구분_코드'] == 'A')]

# 상권_코드_명 컬럼 삭제
foot_traffic_with_commercial_district_df = foot_traffic_with_commercial_district_df.drop(
    columns=['상권_구분_코드', '상권_구분_코드_명', '남성_유동인구_수', '여성_유동인구_수'])

# 결측치 확인 및 출력
missing_values = foot_traffic_with_commercial_district_df.isna().sum()

if missing_values.any():
    print("길단위인구-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("길단위인구-상권 결측치가 없습니다.")

# 각 컬럼들 이름 변경
foot_traffic_with_commercial_district_df = foot_traffic_with_commercial_district_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '총_유동인구_수': 'total_foot_traffic',
    '연령대_10_유동인구_수': 'age_10_foot_traffic',
    '연령대_20_유동인구_수': 'age_20_foot_traffic',
    '연령대_30_유동인구_수': 'age_30_foot_traffic',
    '연령대_40_유동인구_수': 'age_40_foot_traffic',
    '연령대_50_유동인구_수': 'age_50_foot_traffic',
    '연령대_60_이상_유동인구_수': 'age_over_60_foot_traffic',
    '시간대_00_06_유동인구_수': 'time_00_to_06_foot_traffic',
    '시간대_06_11_유동인구_수': 'time_06_to_11_foot_traffic',
    '시간대_11_14_유동인구_수': 'time_11_to_14_foot_traffic',
    '시간대_14_17_유동인구_수': 'time_14_to_17_foot_traffic',
    '시간대_17_21_유동인구_수': 'time_17_to_21_foot_traffic',
    '시간대_21_24_유동인구_수': 'time_21_to_24_foot_traffic',
    '월요일_유동인구_수': 'mon_foot_traffic',
    '화요일_유동인구_수': 'tue_foot_traffic',
    '수요일_유동인구_수': 'wed_foot_traffic',
    '목요일_유동인구_수': 'thu_foot_traffic',
    '금요일_유동인구_수': 'fri_foot_traffic',
    '토요일_유동인구_수': 'sat_foot_traffic',
    '일요일_유동인구_수': 'sun_foot_traffic'
})

# 상주인구-상권 전처리
resident_population_with_commercial_district_df = pd.read_csv(
    'files/dataset/서울시 상권분석서비스(상주인구-상권).csv', encoding='CP949')

# 2021년 1분기 이상 컬럼은 ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
resident_population_with_commercial_district_df = \
    resident_population_with_commercial_district_df[
        (resident_population_with_commercial_district_df['기준_년분기_코드'] >= 20211) & (
                resident_population_with_commercial_district_df['상권_구분_코드'] == 'A')][[
        '기준_년분기_코드', '상권_코드', '상권_코드_명', '총_상주인구_수', '총_가구_수', '남성연령대_10_상주인구_수', '남성연령대_20_상주인구_수', '남성연령대_30_상주인구_수',
        '남성연령대_40_상주인구_수', '남성연령대_50_상주인구_수', '남성연령대_60_이상_상주인구_수', '여성연령대_10_상주인구_수', '여성연령대_20_상주인구_수',
        '여성연령대_30_상주인구_수', '여성연령대_40_상주인구_수', '여성연령대_50_상주인구_수', '여성연령대_60_이상_상주인구_수']]

# 결측치 확인 및 출력
missing_values = resident_population_with_commercial_district_df.isna().sum()

if missing_values.any():
    print("상주인구-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("상주인구-상권 결측치가 없습니다.")

# 각 컬럼들 이름 변경 필요
resident_population_with_commercial_district_df = resident_population_with_commercial_district_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '총_가구_수': 'total_household',
    '총_상주인구_수': 'total_resident_population',
    '남성연령대_10_상주인구_수': 'male_age_10_resident_population',
    '남성연령대_20_상주인구_수': 'male_age_20_resident_population',
    '남성연령대_30_상주인구_수': 'male_age_30_resident_population',
    '남성연령대_40_상주인구_수': 'male_age_40_resident_population',
    '남성연령대_50_상주인구_수': 'male_age_50_resident_population',
    '남성연령대_60_이상_상주인구_수': 'male_age_over_60_resident_population',
    '여성연령대_10_상주인구_수': 'female_age_10_resident_population',
    '여성연령대_20_상주인구_수': 'female_age_20_resident_population',
    '여성연령대_30_상주인구_수': 'female_age_30_resident_population',
    '여성연령대_40_상주인구_수': 'female_age_40_resident_population',
    '여성연령대_50_상주인구_수': 'female_age_50_resident_population',
    '여성연령대_60_이상_상주인구_수': 'female_age_over_60_resident_population'
})

# 아파트-상권 전처리
apartment_with_commercial_district_df = pd.read_csv(
    'files/dataset/서울시 상권분석서비스(아파트-상권).csv', encoding='CP949')

# 2021년 1분기 이상 컬럼은 ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
apartment_with_commercial_district_df = \
    apartment_with_commercial_district_df[
        (apartment_with_commercial_district_df['기준_년분기_코드'] >= 20211) & (
                apartment_with_commercial_district_df['상권_구분_코드'] == 'A')][[
        '기준_년분기_코드', '상권_코드', '상권_코드_명', '아파트_단지_수', '아파트_면적_66_제곱미터_미만_세대_수', '아파트_면적_66_제곱미터_세대_수',
        '아파트_면적_99_제곱미터_세대_수', '아파트_면적_132_제곱미터_세대_수', '아파트_면적_165_제곱미터_세대_수', '아파트_가격_1_억_미만_세대_수', '아파트_가격_1_억_세대_수',
        '아파트_가격_2_억_세대_수', '아파트_가격_3_억_세대_수', '아파트_가격_4_억_세대_수', '아파트_가격_5_억_세대_수', '아파트_가격_6_억_이상_세대_수', '아파트_평균_면적',
        '아파트_평균_시가']]

apartment_with_commercial_district_df = apartment_with_commercial_district_df.fillna(0)
# 결측치 확인 및 출력
missing_values = apartment_with_commercial_district_df.isna().sum()

if missing_values.any():
    print("상주인구-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("상주인구-상권 결측치가 없습니다.")

# 각 컬럼들 이름 변경 필요
apartment_with_commercial_district_df = apartment_with_commercial_district_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '아파트_단지_수': 'total_household',
    '아파트_면적_66_제곱미터_미만_세대_수': 'household_under_20_pyeong',
    '아파트_면적_66_제곱미터_세대_수': 'household_20_to_30_pyeong',
    '아파트_면적_99_제곱미터_세대_수': 'household_30_to_40_pyeong',
    '아파트_면적_132_제곱미터_세대_수': 'household_40_to_50_pyeong',
    '아파트_면적_165_제곱미터_세대_수': 'household_over_50_pyeong',
    '아파트_가격_1_억_미만_세대_수': 'household_less_than_100_million_price',
    '아파트_가격_1_억_세대_수': 'household_100_million_to_200_million_price',
    '아파트_가격_2_억_세대_수': 'household_200_million_to_300_million_price',
    '아파트_가격_3_억_세대_수': 'household_300_million_to_400_million_price',
    '아파트_가격_4_억_세대_수': 'household_400_million_to_500_million_price',
    '아파트_가격_5_억_세대_수': 'household_500_million_to_600_million_price',
    '아파트_가격_6_억_이상_세대_수': 'household_over_than_600_million_price',
    '아파트_평균_면적': 'apartment_avg_area',
    '아파트_평균_시가': 'apartment_avg_price'
})

# 집객시설-상권 전처리
facilities_with_commercial_district_df = pd.read_csv(
    'files/dataset/서울시 상권분석서비스(집객시설-상권).csv', encoding='CP949')

# 2021년 1분기 이상 컬럼은 ['기준_년분기_코드', '서비스_업종_코드', '서비스_업종_코드_명', '점포_수', '프랜차이즈_점포_수']로 데이터프레임 갱신
facilities_with_commercial_district_df = \
    facilities_with_commercial_district_df[
        (facilities_with_commercial_district_df['기준_년분기_코드'] >= 20211) & (
                facilities_with_commercial_district_df['상권_구분_코드'] == 'A')]

# 결측치 0 처리
facilities_with_commercial_district_df = facilities_with_commercial_district_df.fillna(0)

# 수치계산
facilities_with_commercial_district_df['bus'] = facilities_with_commercial_district_df['버스_터미널_수'] + \
                                                facilities_with_commercial_district_df['버스_정거장_수']
facilities_with_commercial_district_df['cultural/tourist_facilities'] = facilities_with_commercial_district_df[
                                                                            '백화점_수'] + \
                                                                        facilities_with_commercial_district_df['극장_수'] + \
                                                                        facilities_with_commercial_district_df[
                                                                            '숙박_시설_수']
facilities_with_commercial_district_df['educational_facilities'] = facilities_with_commercial_district_df['유치원_수'] + \
                                                                   facilities_with_commercial_district_df['초등학교_수'] + \
                                                                   facilities_with_commercial_district_df['중학교_수'] + \
                                                                   facilities_with_commercial_district_df['고등학교_수'] + \
                                                                   facilities_with_commercial_district_df['대학교_수']
facilities_with_commercial_district_df['train/subway'] = facilities_with_commercial_district_df['지하철_역_수'] + \
                                                         facilities_with_commercial_district_df['철도_역_수']

# 상권_코드_명 컬럼 삭제
facilities_with_commercial_district_df = facilities_with_commercial_district_df.drop(
    columns=['상권_구분_코드', '상권_구분_코드_명', '관공서_수', '은행_수', '종합병원_수', '일반_병원_수', '약국_수', '유치원_수', '초등학교_수',
             '중학교_수', '고등학교_수', '대학교_수', '백화점_수', '슈퍼마켓_수', '극장_수', '숙박_시설_수', '공항_수', '철도_역_수', '버스_터미널_수', '지하철_역_수',
             '버스_정거장_수'
             ])

# 각 컬럼들 이름 변경 필요
facilities_with_commercial_district_df = facilities_with_commercial_district_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '집객시설_수': 'facilities'
})

# 직장인구-상권 전처리
working_population_with_commercial_district_df = pd.read_csv(
    'files/dataset/서울시 상권분석서비스(직장인구-상권).csv', encoding='CP949')

# 2021년 1분기 이상, 골목상권
working_population_with_commercial_district_df = \
    working_population_with_commercial_district_df[
        (working_population_with_commercial_district_df['기준_년분기_코드'] >= 20211) & (
                working_population_with_commercial_district_df['상권_구분_코드'] == 'A')][
        ['기준_년분기_코드', '상권_코드', '상권_코드_명', '총_직장_인구_수', '남성연령대_10_직장_인구_수', '남성연령대_20_직장_인구_수', '남성연령대_30_직장_인구_수',
         '남성연령대_40_직장_인구_수', '남성연령대_50_직장_인구_수', '남성연령대_60_이상_직장_인구_수', '여성연령대_10_직장_인구_수', '여성연령대_20_직장_인구_수',
         '여성연령대_30_직장_인구_수', '여성연령대_40_직장_인구_수', '여성연령대_50_직장_인구_수', '여성연령대_60_이상_직장_인구_수']]

# 결측치 확인 및 출력
missing_values = working_population_with_commercial_district_df.isna().sum()

if missing_values.any():
    print("직장인구-상권 결측치가 있습니다:")
    print(missing_values)
else:
    print("직장인구-상권 결측치가 없습니다.")

# 각 컬럼들 이름 변경
working_population_with_commercial_district_df = working_population_with_commercial_district_df.rename(columns={
    '기준_년분기_코드': 'year_quarter_code',
    '상권_코드': 'commercial_district_code',
    '상권_코드_명': 'commercial_district_name',
    '총_직장_인구_수': 'total_working_population',
    '남성연령대_10_직장_인구_수': 'male_age_10_working_population',
    '남성연령대_20_직장_인구_수': 'male_age_20_working_population',
    '남성연령대_30_직장_인구_수': 'male_age_30_working_population',
    '남성연령대_40_직장_인구_수': 'male_age_40_working_population',
    '남성연령대_50_직장_인구_수': 'male_age_50_working_population',
    '남성연령대_60_이상_직장_인구_수': 'male_age_over_60_working_population',
    '여성연령대_10_직장_인구_수': 'female_age_10_working_population',
    '여성연령대_20_직장_인구_수': 'female_age_20_working_population',
    '여성연령대_30_직장_인구_수': 'female_age_30_working_population',
    '여성연령대_40_직장_인구_수': 'female_age_40_working_population',
    '여성연령대_50_직장_인구_수': 'female_age_50_working_population',
    '여성연령대_60_이상_직장_인구_수': 'female_age_over_60_working_population',
})

# 기준 1090개 상권코드와 비일치한 데이터셋의 상권코드 합집합을 구해 모든 데이터셋에서 해당 상권코드들에 관련된 내용 제거
df_dict = check_do_not_have_commercial_district_code([
    area_with_commercial_district_df,
    store_with_commercial_district_df,
    sales_commercial_district_df,
    income_consumption_with_commercial_district_df,
    commercial_district_change_indicator_with_commercial_district_df,
    foot_traffic_with_commercial_district_df,
    resident_population_with_commercial_district_df,
    facilities_with_commercial_district_df,
    apartment_with_commercial_district_df,
    working_population_with_commercial_district_df
])

# CSV 파일로 저장
# df_dict['area_with_commercial_district_df'].to_csv('files/check/영역-상권.csv', encoding='CP949', index=False)
# df_dict['store_with_commercial_district_df'].to_csv('files/check/점포-상권.csv', index=False, encoding="CP949")
# store_with_seoul_df.to_csv('files/check/점포-서울시.csv', encoding='CP949', index=False)
# df_dict['sales_commercial_district_df'].to_csv('files/check/추정매출-상권.csv', encoding='CP949', index=False)
# df_dict['income_consumption_with_commercial_district_df'].to_csv('files/check/소득-상권.csv', encoding='CP949', index=False)
# df_dict['commercial_district_change_indicator_with_commercial_district_df'].to_csv('files/check/상권변화지표-상권.csv', encoding='CP949',
#                                                                         index=False)
# df_dict['foot_traffic_with_commercial_district_df'].to_csv('files/check/길단위인구-상권.csv', encoding='CP949', index=False)
# df_dict['resident_population_with_commercial_district_df'].to_csv('files/check/상주인구-상권.csv', encoding='CP949', index=False)
# df_dict['facilities_with_commercial_district_df'].to_csv('files/check/집객시설-상권.csv', encoding='CP949', index=False)
# df_dict['apartment_with_commercial_district_df'].to_csv('files/check/아파트-상권.csv', encoding='CP949', index=False)
# df_dict['working_population_with_commercial_district_df'].to_csv('files/check/직장인구-상권.csv', encoding='CP949', index=False)

# 설정 파일 불러오기
with open('config.json', 'r') as f:
    config = json.load(f)

# PostgreSQL 연결 정보
db_config = config['postgresql']

engine = create_engine('postgresql://{user}:{password}@{host}:{port}/{database}'.format(**db_config))

df_dict['area_with_commercial_district_df'].to_sql('commercial_district_tb', engine, if_exists='replace', index=False)
# 기본 키 설정
with engine.connect() as con:
    con.execute('ALTER TABLE commercial_district_tb ADD PRIMARY KEY (commercial_district_code);')

df_dict['store_with_commercial_district_df'].to_sql('comm_store_tb', engine, if_exists='replace', index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_store_tb ADD COLUMN id SERIAL PRIMARY KEY;')

df_dict['sales_commercial_district_df'].to_sql('comm_estimated_sales_tb', engine, if_exists='replace', index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_estimated_sales_tb ADD COLUMN id SERIAL PRIMARY KEY;')

df_dict['income_consumption_with_commercial_district_df'].to_sql('comm_income_tb', engine, if_exists='replace',
                                                                 index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_income_tb ADD COLUMN id SERIAL PRIMARY KEY;')

df_dict['commercial_district_change_indicator_with_commercial_district_df'].to_sql('comm_indicator_change_tb', engine,
                                                                                   if_exists='replace', index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_indicator_change_tb ADD COLUMN id SERIAL PRIMARY KEY;')

df_dict['foot_traffic_with_commercial_district_df'].to_sql('comm_floating_population_tb', engine, if_exists='replace',
                                                           index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_floating_population_tb ADD COLUMN id SERIAL PRIMARY KEY;')

df_dict['resident_population_with_commercial_district_df'].to_sql('comm_resident_population_tb', engine,
                                                                  if_exists='replace', index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_resident_population_tb ADD COLUMN id SERIAL PRIMARY KEY;')

df_dict['facilities_with_commercial_district_df'].to_sql('comm_facilities_tb', engine, if_exists='replace', index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_facilities_tb ADD COLUMN id SERIAL PRIMARY KEY;')

df_dict['apartment_with_commercial_district_df'].to_sql('comm_apartment_tb', engine, if_exists='replace', index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_apartment_tb ADD COLUMN id SERIAL PRIMARY KEY;')

df_dict['working_population_with_commercial_district_df'].to_sql('comm_working_population_tb', engine,
                                                                 if_exists='replace', index=False)
# 새로운 ID 컬럼 추가 및 auto-increment 설정
with engine.connect() as con:
    con.execute('ALTER TABLE comm_working_population_tb ADD COLUMN id SERIAL PRIMARY KEY;')

end = time.time()

print(f"{end - start:.5f} sec")
