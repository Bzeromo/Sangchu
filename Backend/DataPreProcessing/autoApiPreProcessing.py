import asyncio
import aiohttp
import pandas as pd
from dotenv import load_dotenv
import os
from autoDataPreProcessing import auto_data_pre_processing

# 데이터프레임으로 만들어야 할 데이터셋 코드 매핑
dataset_codes_dict = {
    'VwsmTrdarFcltyQq': 'facilities_with_commercial_district',
    'trdarNcmCnsmp': 'income_consumption_with_commercial_district',
    'VwsmTrdarWrcPopltnQq': 'working_population_with_commercial_district',
    'TbgisTrdarRelm': 'area_with_commercial_district', 'InfoTrdarAptQq': 'apartment_with_commercial_district',
    'VwsmTrdarRepopQq': 'resident_population_with_commercial_district',
    'VwsmTrdarIxQq': 'commercial_district_change_indicator_with_commercial_district',
    'VwsmTrdarFlpopQq': 'foot_traffic_with_commercial_district', 'VwsmTrdarStorQq': 'store_with_commercial_district',
    'VwsmMegaStorW': 'store_with_seoul', 'VwsmTrdarSelngQq': 'sales_commercial_district'
}

# .env 파일에서 환경 변수 로드
load_dotenv()

SERVICEKEY = os.getenv('OPENAPI_SERVICE_KEY')  # service key
DATATYPE = os.getenv('OPENAPI_DATATYPE')  # datatype


async def fetch_all_indexes(dataset_code, max_range=1000):
    all_data = []
    start_index = 1
    end_index = max_range

    async with aiohttp.ClientSession() as session:
        while True:
            data = await send_api_request_async(dataset_code, start_index, end_index, session)
            if not data or 'RESULT' not in data.get(dataset_code, {}):
                break

            result_code = data[dataset_code]['RESULT']['CODE']
            if result_code == "INFO-000":
                rows = data[dataset_code].get("row", [])
                if rows:
                    all_data.extend(rows)
                else:
                    break
            else:
                break

            start_index += max_range
            end_index += max_range

    return pd.DataFrame(all_data)


async def send_api_request_async(service_name, start_index, end_index, session):
    api_url = f"http://openapi.seoul.go.kr:8088/{SERVICEKEY}/{DATATYPE}/{service_name}/{start_index}/{end_index}/"
    async with session.get(api_url) as response:
        response.raise_for_status()
        return await response.json()


async def make_dataset_dfs():
    tasks = [fetch_all_indexes(code) for code in dataset_codes_dict.keys()]
    dataframes = await asyncio.gather(*tasks)
    dfs = {dataset_codes_dict[code]: df for code, df in zip(dataset_codes_dict.keys(), dataframes)}
    return dfs


if __name__ == "__main__":
    auto_data_pre_processing(asyncio.run(make_dataset_dfs()))
