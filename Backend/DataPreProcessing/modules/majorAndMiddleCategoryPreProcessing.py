import pandas as pd
import numpy as np
from tqdm import tqdm

category_mapping = {
    'CS100001': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0101',
        'middle_code_name': '음식(식사)'
    },
    'CS100002': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0101',
        'middle_code_name': '음식(식사)'
    },
    'CS100003': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0101',
        'middle_code_name': '음식(식사)'
    },
    'CS100004': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0101',
        'middle_code_name': '음식(식사)'
    },
    'CS100006': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0101',
        'middle_code_name': '음식(식사)'
    },
    'CS100007': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0101',
        'middle_code_name': '음식(식사)'
    },
    'CS100008': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0101',
        'middle_code_name': '음식(식사)'
    },
    'CS100005': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0102',
        'middle_code_name': '제과/커피'
    },
    'CS100010': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0102',
        'middle_code_name': '제과/커피'
    },
    'CS100009': {
        'major_code': 'C01',
        'major_code_name': '외식업',
        'middle_code': 'C0103',
        'middle_code_name': '호프간이주점'
    },
    'CS200001': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0201',
        'middle_code_name': '학원'
    },
    'CS200002': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0201',
        'middle_code_name': '학원'
    },
    'CS200003': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0201',
        'middle_code_name': '학원'
    },
    'CS200004': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0201',
        'middle_code_name': '학원'
    },
    'CS200005': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0201',
        'middle_code_name': '학원'
    },
    'CS200006': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0202',
        'middle_code_name': '의원'
    },
    'CS200007': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0202',
        'middle_code_name': '의원'
    },
    'CS200008': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0202',
        'middle_code_name': '의원'
    },
    'CS200009': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0202',
        'middle_code_name': '의원'
    },
    'CS200010': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200011': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200012': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200013': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200014': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200015': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200016': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200017': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200018': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200019': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200020': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200021': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200022': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200023': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200024': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200025': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200026': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200027': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200028': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200029': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200030': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200031': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200032': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200033': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200034': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200035': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200036': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200037': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200038': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200039': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0203',
        'middle_code_name': '여가/미용'
    },
    'CS200040': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200041': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200042': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200043': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200044': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200045': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200046': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS200047': {
        'major_code': 'C02',
        'major_code_name': '서비스업',
        'middle_code': 'C0204',
        'middle_code_name': '기타 서비스'
    },
    'CS300001': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0301',
        'middle_code_name': '생활소매'
    },
    'CS300002': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0301',
        'middle_code_name': '생활소매'
    },
    'CS300003': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0302',
        'middle_code_name': '전자소매'
    },
    'CS300004': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0302',
        'middle_code_name': '전자소매'
    },
    'CS300005': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0301',
        'middle_code_name': '생활소매'
    },
    'CS300006': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0301',
        'middle_code_name': '생활소매'
    },
    'CS300007': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0301',
        'middle_code_name': '생활소매'
    },
    'CS300008': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0301',
        'middle_code_name': '생활소매'
    },
    'CS300009': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0301',
        'middle_code_name': '생활소매'
    },
    'CS300010': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0301',
        'middle_code_name': '생활소매'
    },
    'CS300011': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300012': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300013': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300014': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300015': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300016': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300017': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300018': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300019': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300020': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300021': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300022': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300023': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300024': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300025': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0302',
        'middle_code_name': '전자소매'
    },
    'CS300026': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300027': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300028': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300029': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300030': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300031': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300032': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0302',
        'middle_code_name': '전자소매'
    },
    'CS300033': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0302',
        'middle_code_name': '전자소매'
    },
    'CS300034': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300035': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300036': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300037': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300038': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0302',
        'middle_code_name': '전자소매'
    },
    'CS300039': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0302',
        'middle_code_name': '전자소매'
    },
    'CS300040': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300041': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300042': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0303',
        'middle_code_name': '잡화소매'
    },
    'CS300043': {
        'major_code': 'C03',
        'major_code_name': '도소매업',
        'middle_code': 'C0302',
        'middle_code_name': '전자소매'
    },
}


def categorization_into_major_and_medium_categories_by_service_industry_code_name(df, save_path):
    # 상권코드명 컬럼 옆 컬럼으로 들어가게 할 것
    target_idx = df.columns.get_loc('상권_코드_명') + 1

    # 컬럼 추가
    df.insert(target_idx, '대분류_코드', np.nan)
    df.insert(target_idx + 1, '대분류_코드_명', np.nan)
    df.insert(target_idx + 2, '중분류_코드', np.nan)
    df.insert(target_idx + 3, '중분류_코드_명', np.nan)

    # 서비스_업종_코드_명 열을 for문 돌며 대분류, 소분류 넣어주기
    for idx, code_name in enumerate(tqdm(list(df.서비스_업종_코드))):
        df.loc[idx, '대분류_코드'] = category_mapping[code_name]['major_code']
        df.loc[idx, '대분류_코드_명'] = category_mapping[code_name]['major_code_name']
        df.loc[idx, '중분류_코드'] = category_mapping[code_name]['middle_code']
        df.loc[idx, '중분류_코드_명'] = category_mapping[code_name]['middle_code_name']
    df.to_csv(save_path, index=False, encoding="CP949")  # csv 추출
    return df
