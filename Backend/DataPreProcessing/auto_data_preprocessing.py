import pandas as pd
from modules.major_and_middle_category_preprocessing import \
    categorization_into_major_and_medium_categories_by_service_industry_code_name
from modules.commercial_district_code_preprocessing import clean_commercial_district_codes
from modules.calculation import calc_scores, calc_sales_score, calc_total_score, calc_RDI, calc_sales_divide_store_count
from pyproj import Transformer
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
import redis
from dotenv import load_dotenv
import os
from sqlalchemy.types import BigInteger, Integer, Text, Float

# .env 파일에서 환경 변수 로드
load_dotenv()

# PostgreSQL 연결
engine = create_engine(
    f'postgresql://{os.getenv("POSTGRES_USER")}:{os.getenv("POSTGRES_PASSWORD")}@{os.getenv("POSTGRES_HOST")}:{os.getenv("POSTGRES_PORT")}/{os.getenv("POSTGRES_DB")}')

# Redis 연결
r = redis.Redis(host=os.getenv('REDIS_HOST'), port=os.getenv('REDIS_PORT'), password=os.getenv('REDIS_PASSWORD'),
                decode_responses=True)

# 각 데이터프레임과 테이블 이름을 반복하여 함수 호출
tables_info = {
    'area_with_commercial_district': ('commercial_district_tb', 'commercial_district_code', False),
    'store_with_commercial_district': ('comm_store_tb', None, True),
    'sales_commercial_district': ('comm_estimated_sales_tb', None, True),
    'income_consumption_with_commercial_district': ('comm_income_tb', None, True),
    'commercial_district_change_indicator_with_commercial_district': ('comm_indicator_change_tb', None, True),
    'foot_traffic_with_commercial_district': ('comm_floating_population_tb', None, True),
    'resident_population_with_commercial_district': ('comm_resident_population_tb', None, True),
    'facilities_with_commercial_district': ('comm_facilities_tb', None, True),
    'apartment_with_commercial_district': ('comm_apartment_tb', None, True),
    'working_population_with_commercial_district': ('comm_working_population_tb', None, True)
}

dtype_dict = {
    'commercial_district_code': BigInteger,
    'commercial_district_name': Text,
    'latitude': Float,
    'longitude': Float,
    'gu_code': BigInteger,
    'gu_name': Text,
    'dong_code': BigInteger,
    'dong_name': Text,
    'area_size': BigInteger,
    'commercial_district_total_score': Float,
    'store_count_mean_score': Float,
    'monthly_sales_mean_score': Float,
    'total_resident_population_score': Float,
    'total_foot_traffic_score': Float,
    'rdi_score': Float,
    'total_working_population_score': Float,
    'apartment_avg_price_score': Float,
    'facilities_score': Float,
    'monthly_average_income_amount_score': Float,
    'expenditure_total_amount_score': Float,
    'year_code': Integer,
    'quarter_code': Integer,
    'apartment_complexes': BigInteger,
    'household_under_20_pyeong': BigInteger,
    'household_20_to_30_pyeong': BigInteger,
    'household_30_to_40_pyeong': BigInteger,
    'household_40_to_50_pyeong': BigInteger,
    'household_over_50_pyeong': BigInteger,
    'household_less_than_100_million_price': BigInteger,
    'household_100_million_to_200_million_price': BigInteger,
    'household_200_million_to_300_million_price': BigInteger,
    'household_300_million_to_400_million_price': BigInteger,
    'household_400_million_to_500_million_price': BigInteger,
    'household_500_million_to_600_million_price': BigInteger,
    'household_over_than_600_million_price': BigInteger,
    'apartment_avg_area': BigInteger,
    'apartment_avg_price': BigInteger,
    'apartment_avg_price_by_area': Float,
    'service_code': Text,
    'service_name': Text,
    'major_category_code': Text,
    'major_category_name': Text,
    'middle_category_code': Text,
    'middle_category_name': Text,
    'franchise_store_count': BigInteger,
    'similar_store_count': BigInteger,
    'store_count': BigInteger,
    'store_count_score': Float,
    'commercial_district_change_indicator_code': Text,
    'commercial_district_change_indicator_name': Text,
    'rdi': Float,
    'store_density': Float,
    'monthly_sales': Float,
    'monthly_sales_count': Float,
    'week_days_sales': Float,
    'weekend_sales': Float,
    'mon_sales': Float,
    'tue_sales': Float,
    'wed_sales': Float,
    'thu_sales': Float,
    'fri_sales': Float,
    'sat_sales': Float,
    'sun_sales': Float,
    'time_00_to_06_sales': Float,
    'time_06_to_11_sales': Float,
    'time_11_to_14_sales': Float,
    'time_14_to_17_sales': Float,
    'time_17_to_21_sales': Float,
    'time_21_to_24_sales': Float,
    'man_sales': Float,
    'woman_sales': Float,
    'age_10_sales': Float,
    'age_20_sales': Float,
    'age_30_sales': Float,
    'age_40_sales': Float,
    'age_50_sales': Float,
    'age_over_60_sales': Float,
    'week_days_sales_count': Float,
    'weekend_sales_count': Float,
    'mon_sales_count': Float,
    'tue_sales_count': Float,
    'wed_sales_count': Float,
    'thu_sales_count': Float,
    'fri_sales_count': Float,
    'sat_sales_count': Float,
    'sun_sales_count': Float,
    'man_sales_count': Float,
    'woman_sales_count': Float,
    'age_10_sales_count': Float,
    'age_20_sales_count': Float,
    'age_30_sales_count': Float,
    'age_40_sales_count': Float,
    'age_50_sales_count': Float,
    'age_over_60_sales_count': Float,
    'time_00_to_06_sales_count': Float,
    'time_06_to_11_sales_count': Float,
    'time_11_to_14_sales_count': Float,
    'time_14_to_17_sales_count': Float,
    'time_17_to_21_sales_count': Float,
    'time_21_to_24_sales_count': Float,
    'monthly_sales_score': Float,
    'commercial_service_total_score': Float,
    'facilities': Integer,
    'bus': Float,
    'cultural/tourist_facilities': Float,
    'educational_facilities': Float,
    'train/subway': Float,
    'male_age_10_working_population': BigInteger,
    'male_age_20_working_population': BigInteger,
    'male_age_30_working_population': BigInteger,
    'male_age_40_working_population': BigInteger,
    'male_age_50_working_population': BigInteger,
    'male_age_over_60_working_population': BigInteger,
    'female_age_10_working_population': BigInteger,
    'female_age_20_working_population': BigInteger,
    'female_age_30_working_population': BigInteger,
    'female_age_40_working_population': BigInteger,
    'female_age_50_working_population': BigInteger,
    'female_age_over_60_working_population': BigInteger,
    'male_working_population': BigInteger,
    'female_working_population': BigInteger,
    'age_10_working_population': BigInteger,
    'age_20_working_population': BigInteger,
    'age_30_working_population': BigInteger,
    'age_40_working_population': BigInteger,
    'age_50_working_population': BigInteger,
    'age_over_60_working_population': BigInteger,
    'monthly_average_income_amount': BigInteger,
    'expenditure_total_amount': BigInteger,
    'total_foot_traffic': BigInteger,
    'female_foot_traffic': BigInteger,
    'male_foot_traffic': BigInteger,
    'age_10_foot_traffic': BigInteger,
    'age_20_foot_traffic': BigInteger,
    'age_30_foot_traffic': BigInteger,
    'age_40_foot_traffic': BigInteger,
    'age_50_foot_traffic': BigInteger,
    'age_over_60_foot_traffic': BigInteger,
    'time_00_to_06_foot_traffic': BigInteger,
    'time_06_to_11_foot_traffic': BigInteger,
    'time_11_to_14_foot_traffic': BigInteger,
    'time_14_to_17_foot_traffic': BigInteger,
    'time_17_to_21_foot_traffic': BigInteger,
    'time_21_to_24_foot_traffic': BigInteger,
    'mon_foot_traffic': BigInteger,
    'tue_foot_traffic': BigInteger,
    'wed_foot_traffic': BigInteger,
    'thu_foot_traffic': BigInteger,
    'fri_foot_traffic': BigInteger,
    'sat_foot_traffic': BigInteger,
    'sun_foot_traffic': BigInteger,
    'total_household': BigInteger,
    'total_resident_population': BigInteger,
    'male_age_10_resident_population': BigInteger,
    'male_age_20_resident_population': BigInteger,
    'male_age_30_resident_population': BigInteger,
    'male_age_40_resident_population': BigInteger,
    'male_age_50_resident_population': BigInteger,
    'male_age_over_60_resident_population': BigInteger,
    'female_age_10_resident_population': BigInteger,
    'female_age_20_resident_population': BigInteger,
    'female_age_30_resident_population': BigInteger,
    'female_age_40_resident_population': BigInteger,
    'female_age_50_resident_population': BigInteger,
    'female_age_over_60_resident_population': BigInteger,
    'female_resident_population': BigInteger,
    'male_resident_population': BigInteger,
    'age_10_resident_population': BigInteger,
    'age_20_resident_population': BigInteger,
    'age_30_resident_population': BigInteger,
    'age_40_resident_population': BigInteger,
    'age_50_resident_population': BigInteger,
    'age_over_60_resident_population': BigInteger,
}


# 데이터프레임을 SQL 테이블로 저장하고, 필요한 경우 기본 키를 설정하거나 ID 컬럼 추가
def save_df_to_sql(engine, dfs, tables_info, redis_client, dtype_dict):
    # 연결을 시작
    connection = engine.connect()
    # 트랜잭션 시작
    transaction = connection.begin()

    try:
        for df_name, info in tables_info.items():
            table_name, primary_key, add_id_column = info
            df = dfs[df_name]

            # 데이터프레임을 SQL로 저장
            df.to_sql(table_name, con=connection, if_exists='replace', index=False, dtype=dtype_dict)

            # 기본 키 설정
            if primary_key:
                connection.execute(text(f'ALTER TABLE {table_name} ADD PRIMARY KEY ({primary_key});'))

            # 새로운 ID 컬럼 추가 및 auto-increment 설정
            if add_id_column:
                connection.execute(text(f'ALTER TABLE {table_name} ADD COLUMN id SERIAL PRIMARY KEY;'))

        # 레디스 작업을 트랜잭션 커밋 전에 수행
        try:
            redis_client.flushdb()  # Redis에 저장된 모든 데이터 초기화
        except redis.RedisError as re:
            print(f"Redis operation failed: {re}")
            raise  # 현재 오류를 다시 발생시켜 상위로 전달

        # 레디스 작업이 성공적으로 완료되면, 모든 변경 사항을 데이터베이스에 커밋
        transaction.commit()
        print("Transaction and Redis operation success")
    except SQLAlchemyError as e:
        # 오류 발생 시 롤백
        transaction.rollback()
        print(f"Transaction failed and rolled back: {e}")
    finally:
        # 연결을 닫기
        connection.close()


# 데이터 로딩 및 전처리를 위한 일반화된 함수
def load_and_preprocess(df, filters=None, rename_cols=None, drop_cols=None, is_categorization=False,
                        is_null_to_zero=False, change_facility=False):
    if is_categorization:
        df = categorization_into_major_and_medium_categories_by_service_industry_code_name(df)
    if filters:
        for condition in filters:
            df = df.query(condition)
    if 'TRDAR_CD_NM' in df.columns:
        df.loc[:, 'TRDAR_CD_NM'] = df['TRDAR_CD_NM'].apply(lambda x: x.split('(')[0])
    if rename_cols:
        df = df.rename(columns=rename_cols)
    if change_facility:
        df['bus'] = df['BUS_TRMINL_CO'] + df['BUS_STTN_CO']
        df['cultural/tourist_facilities'] = df['DRTS_CO'] + df['THEAT_CO'] + df['STAYNG_FCLTY_CO']
        df['educational_facilities'] = df['KNDRGR_CO'] + df['ELESCH_CO'] + df['MSKUL_CO'] + df['HGSCHL_CO'] + df[
            'UNIV_CO']
        df['train/subway'] = df['SUBWAY_STATN_CO'] + df['RLROAD_STATN_CO']
    if drop_cols:
        df = df.drop(columns=drop_cols)
    if is_null_to_zero:
        df = df.fillna(0)
    return df


# 결측치 확인을 위한 함수 재사용
def check_null(df, message="결측치가 있습니다:"):
    missing_values = df.isna().sum()
    if missing_values.any():
        print(f"{message}")
        print(missing_values)


# 연도와 분기를 분리하는 일반화된 함수
def split_year_quarter(df):
    # year_quarter_code 컬럼을 문자열로 변환하여 임시 컬럼에 저장
    df['year_quarter_code'] = df['year_quarter_code'].astype(str)

    # 연도와 분기 코드 추출
    year_code = df['year_quarter_code'].str[:4].astype(int)
    quarter_code = df['year_quarter_code'].str[-1].astype(int)

    # year_quarter_code 컬럼의 위치 찾기
    position = df.columns.get_loc('year_quarter_code') + 1

    # year_code와 quarter_code 컬럼 위치에 삽입
    df.insert(position, 'year_code', year_code)
    df.insert(position + 1, 'quarter_code', quarter_code)

    # 임시로 생성한 문자열 컬럼 및 원래 컬럼 삭제
    return df.drop(columns=['year_quarter_code'])


# Transformer 인스턴스 생성
transformer = Transformer.from_crs("epsg:5181", "epsg:4326", always_xy=True)


def transform_coords(row):
    x_4326, y_4326 = transformer.transform(row['latitude'], row['longitude'])
    return pd.Series({'latitude': x_4326, 'longitude': y_4326})


def auto_data_pre_processing(dfs):
    # 영역-상권 데이터 로딩 및 전처리
    dfs['area_with_commercial_district'] = load_and_preprocess(
        dfs['area_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={'TRDAR_CD': 'commercial_district_code',
                     'TRDAR_CD_NM': 'commercial_district_name',
                     'XCNTS_VALUE': 'latitude',
                     'YDNTS_VALUE': 'longitude',
                     'SIGNGU_CD': 'gu_code',
                     'SIGNGU_CD_NM': 'gu_name',
                     'ADSTRD_CD': 'dong_code',
                     'ADSTRD_CD_NM': 'dong_name',
                     'RELM_AR': 'area_size'},
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM']
    )

    dfs['area_with_commercial_district'][['latitude', 'longitude']] = dfs['area_with_commercial_district'].apply(
        transform_coords,
        axis=1)

    # 점포-상권 데이터 로딩 및 전처리
    dfs['store_with_commercial_district'] = load_and_preprocess(
        dfs['store_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'SVC_INDUTY_CD': 'service_code',
            'SVC_INDUTY_CD_NM': 'service_name',
            'STOR_CO': 'store_count',
            'SIMILR_INDUTY_STOR_CO': 'similar_store_count',
            'FRC_STOR_CO': 'franchise_store_count'
        },
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM', 'OPBIZ_RT', 'OPBIZ_STOR_CO', 'CLSBIZ_RT',
                   'CLSBIZ_STOR_CO'],
        is_categorization=True
    )

    # 점포-서울시 데이터 로딩 및 전처리
    dfs['store_with_seoul'] = load_and_preprocess(
        dfs['store_with_seoul'],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'SVC_INDUTY_CD': 'service_code',
            'SVC_INDUTY_CD_NM': 'service_name',
            'STOR_CO': 'store_count',
            'FRC_STOR_CO': 'franchise_store_count'
        },
        drop_cols=['MEGA_CD', 'MEGA_CD_NM', 'SIMILR_INDUTY_STOR_CO', 'OPBIZ_RT', 'OPBIZ_STOR_CO', 'CLSBIZ_RT',
                   'CLSBIZ_STOR_CO'],
        is_categorization=True
    )

    # 매출-상권 데이터 로딩 및 전처리
    dfs['sales_commercial_district'] = load_and_preprocess(
        dfs['sales_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'", "major_category_code == 'C01'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'SVC_INDUTY_CD': 'service_code',
            'SVC_INDUTY_CD_NM': 'service_name',
            'THSMON_SELNG_AMT': 'monthly_sales',
            'THSMON_SELNG_CO': 'monthly_sales_count',
            'MDWK_SELNG_AMT': 'week_days_sales',
            'WKEND_SELNG_AMT': 'weekend_sales',
            'MON_SELNG_AMT': 'mon_sales',
            'TUES_SELNG_AMT': 'tue_sales',
            'WED_SELNG_AMT': 'wed_sales',
            'THUR_SELNG_AMT': 'thu_sales',
            'FRI_SELNG_AMT': 'fri_sales',
            'SAT_SELNG_AMT': 'sat_sales',
            'SUN_SELNG_AMT': 'sun_sales',
            'TMZON_00_06_SELNG_AMT': 'time_00_to_06_sales',
            'TMZON_06_11_SELNG_AMT': 'time_06_to_11_sales',
            'TMZON_11_14_SELNG_AMT': 'time_11_to_14_sales',
            'TMZON_14_17_SELNG_AMT': 'time_14_to_17_sales',
            'TMZON_17_21_SELNG_AMT': 'time_17_to_21_sales',
            'TMZON_21_24_SELNG_AMT': 'time_21_to_24_sales',
            'ML_SELNG_AMT': 'man_sales',
            'FML_SELNG_AMT': 'woman_sales',
            'AGRDE_10_SELNG_AMT': 'age_10_sales',
            'AGRDE_20_SELNG_AMT': 'age_20_sales',
            'AGRDE_30_SELNG_AMT': 'age_30_sales',
            'AGRDE_40_SELNG_AMT': 'age_40_sales',
            'AGRDE_50_SELNG_AMT': 'age_50_sales',
            'AGRDE_60_ABOVE_SELNG_AMT': 'age_over_60_sales',
            'MDWK_SELNG_CO': 'week_days_sales_count',
            'WKEND_SELNG_CO': 'weekend_sales_count',
            'MON_SELNG_CO': 'mon_sales_count',
            'TUES_SELNG_CO': 'tue_sales_count',
            'WED_SELNG_CO': 'wed_sales_count',
            'THUR_SELNG_CO': 'thu_sales_count',
            'FRI_SELNG_CO': 'fri_sales_count',
            'SAT_SELNG_CO': 'sat_sales_count',
            'SUN_SELNG_CO': 'sun_sales_count',
            'TMZON_00_06_SELNG_CO': 'time_00_to_06_sales_count',
            'TMZON_06_11_SELNG_CO': 'time_06_to_11_sales_count',
            'TMZON_11_14_SELNG_CO': 'time_11_to_14_sales_count',
            'TMZON_14_17_SELNG_CO': 'time_14_to_17_sales_count',
            'TMZON_17_21_SELNG_CO': 'time_17_to_21_sales_count',
            'TMZON_21_24_SELNG_CO': 'time_21_to_24_sales_count',
            'ML_SELNG_CO': 'man_sales_count',
            'FML_SELNG_CO': 'woman_sales_count',
            'AGRDE_10_SELNG_CO': 'age_10_sales_count',
            'AGRDE_20_SELNG_CO': 'age_20_sales_count',
            'AGRDE_30_SELNG_CO': 'age_30_sales_count',
            'AGRDE_40_SELNG_CO': 'age_40_sales_count',
            'AGRDE_50_SELNG_CO': 'age_50_sales_count',
            'AGRDE_60_ABOVE_SELNG_CO': 'age_over_60_sales_count'
        },
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM'],
        is_categorization=True
    )

    dfs['sales_commercial_district'] = calc_sales_divide_store_count(dfs['sales_commercial_district'],
                                                                     dfs['store_with_commercial_district'])

    # 소득-상권 데이터 로딩 및 전처리
    dfs['income_consumption_with_commercial_district'] = load_and_preprocess(
        dfs['income_consumption_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'MT_AVRG_INCOME_AMT': 'monthly_average_income_amount',
            'EXPNDTR_TOTAMT': 'expenditure_total_amount'
        },
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM', 'INCOME_SCTN_CD', 'FDSTFFS_EXPNDTR_TOTAMT',
                   'CLTHS_FTWR_EXPNDTR_TOTAMT',
                   'LVSPL_EXPNDTR_TOTAMT',
                   'MCP_EXPNDTR_TOTAMT', 'TRNSPORT_EXPNDTR_TOTAMT', 'LSR_EXPNDTR_TOTAMT', 'CLTUR_EXPNDTR_TOTAMT',
                   'EDC_EXPNDTR_TOTAMT', 'PLESR_EXPNDTR_TOTAMT']
    )

    # 상권변화지표-상권 데이터 로딩 및 전처리
    dfs['commercial_district_change_indicator_with_commercial_district'] = load_and_preprocess(
        dfs['commercial_district_change_indicator_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'TRDAR_CHNGE_IX': 'commercial_district_change_indicator_code',
            'TRDAR_CHNGE_IX_NM': 'commercial_district_change_indicator_name'
        },
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM', 'OPR_SALE_MT_AVRG', 'CLS_SALE_MT_AVRG', 'SU_OPR_SALE_MT_AVRG',
                   'SU_CLS_SALE_MT_AVRG']
    )

    # RDI 값 계산
    dfs['commercial_district_change_indicator_with_commercial_district'] = calc_RDI(dfs['store_with_seoul'],
                                                                                    dfs[
                                                                                        'store_with_commercial_district'],
                                                                                    dfs[
                                                                                        'area_with_commercial_district'],
                                                                                    dfs[
                                                                                        'commercial_district_change_indicator_with_commercial_district'])

    # 길단위인구-상권 데이터 로딩 및 전처리
    dfs['foot_traffic_with_commercial_district'] = load_and_preprocess(
        dfs['foot_traffic_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'TOT_FLPOP_CO': 'total_foot_traffic',
            'ML_FLPOP_CO': 'male_foot_traffic',
            'FML_FLPOP_CO': 'female_foot_traffic',
            'AGRDE_10_FLPOP_CO': 'age_10_foot_traffic',
            'AGRDE_20_FLPOP_CO': 'age_20_foot_traffic',
            'AGRDE_30_FLPOP_CO': 'age_30_foot_traffic',
            'AGRDE_40_FLPOP_CO': 'age_40_foot_traffic',
            'AGRDE_50_FLPOP_CO': 'age_50_foot_traffic',
            'AGRDE_60_ABOVE_FLPOP_CO': 'age_over_60_foot_traffic',
            'TMZON_00_06_FLPOP_CO': 'time_00_to_06_foot_traffic',
            'TMZON_06_11_FLPOP_CO': 'time_06_to_11_foot_traffic',
            'TMZON_11_14_FLPOP_CO': 'time_11_to_14_foot_traffic',
            'TMZON_14_17_FLPOP_CO': 'time_14_to_17_foot_traffic',
            'TMZON_17_21_FLPOP_CO': 'time_17_to_21_foot_traffic',
            'TMZON_21_24_FLPOP_CO': 'time_21_to_24_foot_traffic',
            'MON_FLPOP_CO': 'mon_foot_traffic',
            'TUES_FLPOP_CO': 'tue_foot_traffic',
            'WED_FLPOP_CO': 'wed_foot_traffic',
            'THUR_FLPOP_CO': 'thu_foot_traffic',
            'FRI_FLPOP_CO': 'fri_foot_traffic',
            'SAT_FLPOP_CO': 'sat_foot_traffic',
            'SUN_FLPOP_CO': 'sun_foot_traffic'
        },
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM']
    )

    # 상주인구-상권 데이터 로딩 및 전처리
    dfs['resident_population_with_commercial_district'] = load_and_preprocess(
        dfs['resident_population_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'TOT_HSHLD_CO': 'total_household',
            'TOT_REPOP_CO': 'total_resident_population',
            'ML_REPOP_CO': 'male_resident_population',
            'FML_REPOP_CO': 'female_resident_population',
            'AGRDE_10_REPOP_CO': 'age_10_resident_population',
            'AGRDE_20_REPOP_CO': 'age_20_resident_population',
            'AGRDE_30_REPOP_CO': 'age_30_resident_population',
            'AGRDE_40_REPOP_CO': 'age_40_resident_population',
            'AGRDE_50_REPOP_CO': 'age_50_resident_population',
            'AGRDE_60_ABOVE_REPOP_CO': 'age_over_60_resident_population',
            'MAG_10_REPOP_CO': 'male_age_10_resident_population',
            'MAG_20_REPOP_CO': 'male_age_20_resident_population',
            'MAG_30_REPOP_CO': 'male_age_30_resident_population',
            'MAG_40_REPOP_CO': 'male_age_40_resident_population',
            'MAG_50_REPOP_CO': 'male_age_50_resident_population',
            'MAG_60_ABOVE_REPOP_CO': 'male_age_over_60_resident_population',
            'FAG_10_REPOP_CO': 'female_age_10_resident_population',
            'FAG_20_REPOP_CO': 'female_age_20_resident_population',
            'FAG_30_REPOP_CO': 'female_age_30_resident_population',
            'FAG_40_REPOP_CO': 'female_age_40_resident_population',
            'FAG_50_REPOP_CO': 'female_age_50_resident_population',
            'FAG_60_ABOVE_REPOP_CO': 'female_age_over_60_resident_population'
        },
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM', 'APT_HSHLD_CO', 'NON_APT_HSHLD_CO']
    )

    # 아파트-상권 데이터 로딩 및 전처리
    dfs['apartment_with_commercial_district'] = load_and_preprocess(
        dfs['apartment_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'APT_HSMP_CO': 'apartment_complexes',
            'AE_66_SQMT_BELO_HSHLD_CO': 'household_under_20_pyeong',
            'AE_66_SQMT_HSHLD_CO': 'household_20_to_30_pyeong',
            'AE_99_SQMT_HSHLD_CO': 'household_30_to_40_pyeong',
            'AE_132_SQMT_HSHLD_CO': 'household_40_to_50_pyeong',
            'AE_165_SQMT_HSHLD_CO': 'household_over_50_pyeong',
            'PC_1_HDMIL_BELO_HSHLD_CO': 'household_less_than_100_million_price',
            'PC_1_HDMIL_HSHLD_CO': 'household_100_million_to_200_million_price',
            'PC_2_HDMIL_HSHLD_CO': 'household_200_million_to_300_million_price',
            'PC_3_HDMIL_HSHLD_CO': 'household_300_million_to_400_million_price',
            'PC_4_HDMIL_HSHLD_CO': 'household_400_million_to_500_million_price',
            'PC_5_HDMIL_HSHLD_CO': 'household_500_million_to_600_million_price',
            'PC_6_HDMIL_ABOVE_HSHLD_CO': 'household_over_than_600_million_price',
            'AVRG_AE': 'apartment_avg_area',
            'AVRG_MKTC': 'apartment_avg_price'
        },
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM'],
        is_null_to_zero=True
    )
    # 제곱미터 단위 평으로 변경
    dfs['apartment_with_commercial_district']['apartment_avg_area'] = dfs['apartment_with_commercial_district'].apply(
        lambda row: round(row['apartment_avg_area'] / 3.30579),
        axis=1
    )

    # 평당 아파트 금액 컬럼 만들기
    dfs['apartment_with_commercial_district']['apartment_avg_price_by_area'] = dfs[
        'apartment_with_commercial_district'].apply(
        lambda row: row['apartment_avg_price'] / row['apartment_avg_area'] if row['apartment_avg_area'] != 0 else 0,
        axis=1
    )

    # 집객시설-상권 데이터 로딩 및 전처리
    dfs['facilities_with_commercial_district'] = load_and_preprocess(
        dfs['facilities_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'VIATR_FCLTY_CO': 'facilities'
        },
        drop_cols=[
            'TRDAR_SE_CD', 'TRDAR_SE_CD_NM', 'PBLOFC_CO', 'BANK_CO', 'GEHSPT_CO',
            'GNRL_HSPTL_CO', 'PARMACY_CO', 'KNDRGR_CO', 'ELESCH_CO', 'MSKUL_CO',
            'HGSCHL_CO', 'UNIV_CO', 'DRTS_CO', 'SUPMK_CO', 'THEAT_CO',
            'STAYNG_FCLTY_CO', 'ARPRT_CO', 'RLROAD_STATN_CO', 'BUS_TRMINL_CO',
            'SUBWAY_STATN_CO', 'BUS_STTN_CO'
        ],
        is_null_to_zero=True,
        change_facility=True
    )

    # 직장인구-상권 데이터 로딩 및 전처리
    dfs['working_population_with_commercial_district'] = load_and_preprocess(
        dfs['working_population_with_commercial_district'],
        filters=["TRDAR_SE_CD == 'A'"],
        rename_cols={
            'STDR_YYQU_CD': 'year_quarter_code',
            'TRDAR_CD': 'commercial_district_code',
            'TRDAR_CD_NM': 'commercial_district_name',
            'TOT_WRC_POPLTN_CO': 'total_working_population',
            'MAG_10_WRC_POPLTN_CO': 'male_age_10_working_population',
            'MAG_20_WRC_POPLTN_CO': 'male_age_20_working_population',
            'MAG_30_WRC_POPLTN_CO': 'male_age_30_working_population',
            'MAG_40_WRC_POPLTN_CO': 'male_age_40_working_population',
            'MAG_50_WRC_POPLTN_CO': 'male_age_50_working_population',
            'MAG_60_ABOVE_WRC_POPLTN_CO': 'male_age_over_60_working_population',
            'FAG_10_WRC_POPLTN_CO': 'female_age_10_working_population',
            'FAG_20_WRC_POPLTN_CO': 'female_age_20_working_population',
            'FAG_30_WRC_POPLTN_CO': 'female_age_30_working_population',
            'FAG_40_WRC_POPLTN_CO': 'female_age_40_working_population',
            'FAG_50_WRC_POPLTN_CO': 'female_age_50_working_population',
            'FAG_60_ABOVE_WRC_POPLTN_CO': 'female_age_over_60_working_population',
            'ML_WRC_POPLTN_CO': 'male_working_population',
            'FML_WRC_POPLTN_CO': 'female_working_population',
            'AGRDE_10_WRC_POPLTN_CO': 'age_10_working_population',
            'AGRDE_20_WRC_POPLTN_CO': 'age_20_working_population',
            'AGRDE_30_WRC_POPLTN_CO': 'age_30_working_population',
            'AGRDE_40_WRC_POPLTN_CO': 'age_40_working_population',
            'AGRDE_50_WRC_POPLTN_CO': 'age_50_working_population',
            'AGRDE_60_ABOVE_WRC_POPLTN_CO': 'age_over_60_working_population'
        },
        drop_cols=['TRDAR_SE_CD', 'TRDAR_SE_CD_NM']
    )

    # 기준 1090개 상권코드와 비일치한 데이터셋의 상권코드 합집합을 구해 모든 데이터셋에서 해당 상권코드들에 관련된 내용 제거
    dfs = clean_commercial_district_codes(dfs)

    # 점수지표 추출
    dfs['area_with_commercial_district'] = calc_scores(
        [dfs['resident_population_with_commercial_district'], dfs['foot_traffic_with_commercial_district'],
         dfs['commercial_district_change_indicator_with_commercial_district'],
         dfs['working_population_with_commercial_district'], dfs['apartment_with_commercial_district'],
         dfs['facilities_with_commercial_district'], dfs['income_consumption_with_commercial_district']],
        dfs['area_with_commercial_district'],
        [['total_resident_population'], ['total_foot_traffic'], ['rdi'],
         ['total_working_population'], ['apartment_avg_price'], ['facilities'],
         ['monthly_average_income_amount', 'expenditure_total_amount']])

    # 업종별 매출, 점포수 점수지표 추출
    dfs['sales_commercial_district'], dfs['store_with_commercial_district'], dfs[
        'area_with_commercial_district'] = calc_sales_score(
        [dfs['sales_commercial_district'], dfs['store_with_commercial_district']], dfs['area_with_commercial_district'],
        ['monthly_sales', 'store_count'])

    # 총점수 추출
    dfs['area_with_commercial_district'], dfs['sales_commercial_district'] = calc_total_score(
        dfs['area_with_commercial_district'], dfs['sales_commercial_district'], dfs['store_with_commercial_district'])

    # 년분기 코드 -> 년 코드, 분기 코드로 분리
    for df_name in [
        "store_with_commercial_district",
        "sales_commercial_district",
        "income_consumption_with_commercial_district",
        "commercial_district_change_indicator_with_commercial_district",
        "foot_traffic_with_commercial_district",
        "resident_population_with_commercial_district",
        "facilities_with_commercial_district",
        "apartment_with_commercial_district",
        "working_population_with_commercial_district"
    ]:
        dfs[df_name] = split_year_quarter(dfs[df_name])

    save_df_to_sql(engine, dfs, tables_info, r, dtype_dict)
