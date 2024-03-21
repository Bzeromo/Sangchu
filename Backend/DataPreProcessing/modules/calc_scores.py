import pandas as pd
from sklearn.preprocessing import MinMaxScaler
import matplotlib.pyplot as plt
import os

folder_path = 'files/chart/score'
os.makedirs(folder_path, exist_ok=True)

def draw_boxplot(target, title_name):
    # 박스플롯 그리기
    plt.figure(figsize=(8, 6))
    target.plot(kind='box')
    plt.title(title_name)

    # 파일로 저장
    plt.savefig(os.path.join(folder_path, title_name + '_boxplot'))
    plt.close()

def draw_hist(target, xlabel, title_name):
    # 히스토그램 그리기
    plt.hist(target, bins=20, color='skyblue', edgecolor='black')
    plt.title(title_name)
    plt.xlabel(xlabel)
    plt.ylabel('Frequency')

    # 파일로 저장
    plt.savefig(os.path.join(folder_path, title_name + '_boxplot'))
    plt.close()

def calc_scores(df_list, result_df, target_column_list):
    # 점수지표 뽑아야 하는 데이터 프레임, 타겟 컬럼 리스트로 받음
    for idx, df in enumerate(df_list):
        # 가장 최근 년분기 코드를 찾음
        max_year_quarter_code = df['year_quarter_code'].max()
        max_year_quarter_code_df = df[df['year_quarter_code'] == max_year_quarter_code][
            ['commercial_district_code', target_column_list[idx]]]

        draw_boxplot(df[target_column_list[idx]], str(max_year_quarter_code) + " boxplot of " + target_column_list[idx])

        # Q1(제1사분위수), Q3(제3사분위수) 계산
        Q1 = max_year_quarter_code_df[target_column_list[idx]].quantile(0.25)
        Q3 = max_year_quarter_code_df[target_column_list[idx]].quantile(0.75)
        IQR = Q3 - Q1

        # 이상치 기준 설정
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        # 이상치 탐지 및 total_resident_population_score 설정
        max_year_quarter_code_df[target_column_list[idx] + '_score'] = 100
        max_year_quarter_code_df.loc[
            max_year_quarter_code_df[target_column_list[idx]] < lower_bound, target_column_list[idx] + '_score'] = 0

        # 이상치 제거
        outliers_rm_df = max_year_quarter_code_df[(max_year_quarter_code_df[target_column_list[idx]] >= lower_bound) & (
                max_year_quarter_code_df[target_column_list[idx]] <= upper_bound)].copy()

        # MinMaxScaler 선언 및 Fitting
        mMscaler = MinMaxScaler()
        scaled_values = mMscaler.fit_transform(outliers_rm_df[[target_column_list[idx]]])

        # 스케일링된 값을 target_column_list[idx] 열에 대체
        max_year_quarter_code_df.loc[
            (max_year_quarter_code_df[target_column_list[idx]] >= lower_bound) & (max_year_quarter_code_df[
                                                                                      target_column_list[
                                                                                          idx]] <= upper_bound),
            target_column_list[idx] + '_score'] = scaled_values * 100

        # 히스토그램 그리기
        draw_hist(max_year_quarter_code_df[target_column_list[idx] + '_score'], target_column_list[idx] + '_score',
                  str(max_year_quarter_code) + ' histogram of ' + target_column_list[idx] + '_score')
        result_df = pd.merge(result_df, max_year_quarter_code_df[['commercial_district_code',target_column_list[idx] + '_score']], on=['commercial_district_code'], how='left')

    return result_df
