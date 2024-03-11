import pandas as pd
import numpy as np

# 데이터 불러오기
df = pd.read_csv('files/dataset/서울시 상권분석서비스(점포-상권).csv', encoding='CP949')

# 서비스 업종 코드 확인
# print(set(df.서비스_업종_코드_명))
category_codes = dict()

category_codes['restaurant_industry'] = {
    'code': "C01",
    'name': "외식업",
    'restaurant': {
        'code': "C0101",
        'name': "음식(식사)"
    },
    'bakery_coffee': {
        'code': "C0102",
        'name': "제과/커피"
    },
    'hope_bar': {
        'code': "C0103",
        'name': "호프간이주점"
    }
}

category_codes['service_industry'] = {
    'code': "C02",
    'name': "서비스업",
    'educational_institute': {
        'code': "C0201",
        'name': "학원"
    },
    'hospital': {
        'code': "C0202",
        'name': "의원"
    },
    'leisure_beauty': {
        'code': "C0203",
        'name': "여가/미용"
    },
    'etc_service': {
        'code': "C0204",
        'name': "기타 서비스"
    }
}

category_codes['wholesale_and_retail'] = {
    'code': "C03",
    'name': "도소매업",
    'life_retail': {
        'code': "C0301",
        'name': "생활소매"
    },
    'electronic_retail': {
        'code': "C0302",
        'name': "전자소매"
    },
    'grocery_retail': {
        'code': "C0303",
        'name': "잡화소매"
    }
}

category_list = {
    'restaurant_industry': {
        'restaurant': ['한식음식점', '중식음식점', '일식음식점', '양식음식점', '패스트푸드점', '치킨전문점', '분식전문점'],
        'bakery_coffee': ['제과점', '커피-음료'],
        'hope_bar': ['호프-간이주점']
    },
    'service_industry': {
        'educational_institute': ['일반교습학원', '외국어학원', '예술학원', '컴퓨터학원', '스포츠 강습'],
        'hospital': ['한의원', '일반의원', '치과의원', '동물병원'],
        'leisure_beauty': ['당구장', '골프연습장', '볼링장', 'PC방', '전자게임장', '기타오락장', '미용실', '네일숍', '피부관리실', '노래방', 'DVD방', '스포츠클럽'],
        'etc_service': ['변호사사무소', '변리사사무소', '법무사사무소', '기타법무서비스', '회계사사무소', '세무사사무소', '복권방', '통신기기수리', '자동차수리', '자동차미용', '모터사이클수리', '세탁소', '가전제품수리', '부동산중개업', '여관', '게스트하우스', '고시원', '독서실', '녹음실', '사진관', '통번역서비스', '건축물청소', '여행사', '비디오/서적임대', '의류임대', '가정용품임대']
    },
    'wholesale_and_retail': {
        'life_retail': ['슈퍼마켓', '편의점', '미곡판매', '육류판매', '수산물판매', '청과상', '반찬가게', '주류도매'],
        'electronic_retail': ['컴퓨터및주변장치판매', '핸드폰', '가전제품', '전자상거래업', '모터사이클및부품', '자동차부품', '자전거 및 기타운송장비', '철물점'],
        'grocery_retail': ['일반의류', '한복점', '유아의류', '신발', '가방', '안경', '시계및귀금속', '의약품', '의료기기', '서적', '문구', '화장품', '미용재료', '운동/경기용품', '완구', '섬유제품', '화초', '애완동물', '중고가구', '가구', '악기', '인테리어', '조명용품', '중고차판매', '재생용품 판매점', '예술품', '주유소']
    }
}

# 라벨링 안된 업종명 찾기
# print(set(df.서비스_업종_코드_명)-set(restaurant+bakery_coffee+hope_bar+educational_institute+hospital+leisure_beauty+etc_service+life_retail+electronic_retail+grocery_retail))

# 컬럼 추가
df.insert(3,'대분류_코드', np.nan)
df.insert(4,'대분류_코드_명',np.nan)
df.insert(5,'중분류_코드',np.nan)
df.insert(6,'중분류_코드_명',np.nan)

# 서비스_업종_코드_명 열을 for문 돌며 대분류, 소분류 넣어주기
for idx, code_name in enumerate(list(df.서비스_업종_코드_명)):
    flag = False

    for main_category, sub_categories in category_list.items():
        if(flag):
            break
        for sub_category, code in sub_categories.items():
            if not flag and code_name in category_list[main_category][sub_category]:
                df.loc[idx, '대분류_코드'] = category_codes[main_category]['code']
                df.loc[idx, '대분류_코드_명'] = category_codes[main_category]['name']
                df.loc[idx, '중분류_코드'] = category_codes[main_category][sub_category]['code']
                df.loc[idx, '중분류_코드_명'] = category_codes[main_category][sub_category]['name']
                flag = True


print(df.대분류_코드)
df.to_csv("./files/check/서울시 상권분석서비스(점포-상권)_분류작업포함.csv", index=False, encoding="CP949") # csv 추출