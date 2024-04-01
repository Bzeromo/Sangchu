package com.sc.sangchu.postgresql.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Entity
@Table(name = "comm_estimated_sales_tb")
public class CommEstimatedSalesEntity {

    @Id
    @Column(name = "id")
    private Integer id;

    //년도
    @Column(name = "year_code")
    private Integer yearCode;

    //분기
    @Column(name = "quarter_code")
    private Integer quarterCode;

    //상권 코드
    @Column(name = "commercial_district_code")
    private Long commercialDistrictCode;

    //상권 코드 명
    @Column(name = "commercial_district_name")
    private String commercialDistrictName;

    //서비스 업종 코드
    @Column(name = "service_code")
    private String serviceCode;

    //서비스 업종 코드 명
    @Column(name = "service_name")
    private String serviceName;

    //대분류 코드
    @Column(name = "major_category_code")
    private String majorCategoryCode;

    //대분류 코드 명
    @Column(name = "major_category_code_name")
    private String majorCategoryName;

    //중분류 코드
    @Column(name = "middle_category_code")
    private String middleCategoryCode;

    //중분류 코드 명
    @Column(name = "middle_category_code_name")
    private String middleCategoryName;

    //월별 매출
    @Column(name = "monthly_sales")
    private Double monthlySales;

    //월별 매출 건수
    @Column(name = "monthly_sales_count")
    private Long monthlySalesCount;

    //주중 매출
    @Column(name = "week_days_sales")
    private Double weekDaysSales;

    //주말 매출
    @Column(name = "weekend_sales")
    private Double weekendSales;

    //월요일 매출
    @Column(name = "mon_sales")
    private Double monSales;

    //화요일 매출
    @Column(name = "tue_sales")
    private Double tueSales;

    //수요일 매출
    @Column(name = "wed_sales")
    private Double wedSales;

    //목요일 매출
    @Column(name = "thu_sales")
    private Double thuSales;

    //금요일 매출
    @Column(name = "fri_sales")
    private Double friSales;

    //토요일 매출
    @Column(name = "sat_sales")
    private Double satSales;

    //일요일 매출
    @Column(name = "sun_sales")
    private Double sunSales;

    //00~06시 매출
    @Column(name = "time_00_to_06_sales")
    private Double time00To06Sales;

    //06~11시 매출
    @Column(name = "time_06_to_11_sales")
    private Double time06To11Sales;

    //11~14시 매출
    @Column(name = "time_11_to_14_sales")
    private Double time11To14Sales;

    //14~17시 매출
    @Column(name = "time_14_to_17_sales")
    private Double time14To17Sales;

    //17~21시 매출
    @Column(name = "time_17_to_21_sales")
    private Double time17To21Sales;

    //21~24시 매출
    @Column(name = "time_21_to_24_sales")
    private Double time21To24Sales;

    //남성별 매출
    @Column(name = "man_sales")
    private Double manSales;

    //여성별 매출
    @Column(name = "woman_sales")
    private Double womanSales;

    //10대별 매출
    @Column(name = "age_10_sales")
    private Double age10Sales;

    //20대별 매출
    @Column(name = "age_20_sales")
    private Double age20Sales;

    //30대별 매출
    @Column(name = "age_30_sales")
    private Double age30Sales;

    //40대별 매출
    @Column(name = "age_40_sales")
    private Double age40Sales;

    //50대별 매출
    @Column(name = "age_50_sales")
    private Double age50Sales;

    //60대 이상 매출
    @Column(name = "age_over_60_sales")
    private Double ageOver60Sales;

    //주중 매출 건수
    @Column(name = "week_days_sales_count")
    private Long weekDaysSalesCount;

    //주말 매출 건수
    @Column(name = "weekend_sales_count")
    private Long weekendSalesCount;

    //월요일 매출 건수
    @Column(name = "mon_sales_count")
    private Long monSalesCount;

    //화요일 매출 건수
    @Column(name = "tue_sales_count")
    private Long tueSalesCount;

    //수요일 매출 건수
    @Column(name = "wed_sales_count")
    private Long wedSalesCount;

    //목요일 매출 건수
    @Column(name = "thu_sales_count")
    private Long thuSalesCount;

    //금요일 매출 건수
    @Column(name = "fri_sales_count")
    private Long friSalesCount;

    //토요일 매출 건수
    @Column(name = "sat_sales_count")
    private Long satSalesCount;

    //일요일 매출 건수
    @Column(name = "sun_sales_count")
    private Long sunSalesCount;

    //00~06시 매출 건수
    @Column(name = "time_00_to_06_sales_count")
    private Long time00To06SalesCount;

    //06~11시 매출 건수
    @Column(name = "time_06_to_11_sales_count")
    private Long time06To11SalesCount;

    //11~14시 매출 건수
    @Column(name = "time_11_to_14_sales_count")
    private Long time11To14SalesCount;

    //14~17시 매출 건수
    @Column(name = "time_14_to_17_sales_count")
    private Long time14To17SalesCount;

    //17~21시 매출 건수
    @Column(name = "time_17_to_21_sales_count")
    private Long time17To21SalesCount;

    //21~24시 매출 건수
    @Column(name = "time_21_to_24_sales_count")
    private Long time21To24SalesCount;

    //남성별 매출 건수
    @Column(name = "man_sales_count")
    private Long manSalesCount;

    //여성별 매출 건수
    @Column(name = "woman_sales_count")
    private Long womanSalesCount;

    //10대별 매출 건수
    @Column(name = "age_10_sales_count")
    private Long age10SalesCount;

    //20대별 매출 건수
    @Column(name = "age_20_sales_count")
    private Long age20SalesCount;

    //30대별 매출 건수
    @Column(name = "age_30_sales_count")
    private Long age30SalesCount;

    //40대별 매출 건수
    @Column(name = "age_40_sales_count")
    private Long age40SalesCount;

    //50대별 매출 건수
    @Column(name = "age_50_sales_count")
    private Long age50SalesCount;

    //60대 이상 매출 건수
    @Column(name = "age_over_60_sales_count")
    private Long ageOver60SalesCount;

    //해당업종 매출점수
    @Column(name = "monthly_sales_score")
    private Double salesScore;

    //해당업종 총 점수
    @Column(name = "commercial_service_total_score")
    private Double commercialServiceTotalScore;
}
