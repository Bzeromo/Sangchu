package com.sc.sangchu.postgresql.service;

import com.sc.sangchu.dto.infra.CommAptDTO;
import com.sc.sangchu.dto.infra.CommFacilitiesDTO;
import com.sc.sangchu.dto.infra.CommIndicatorDTO;
import com.sc.sangchu.postgresql.entity.CommAptEntity;
import com.sc.sangchu.postgresql.entity.CommFacilitiesEntity;
import com.sc.sangchu.postgresql.entity.CommIndicatorChangeEntity;
import com.sc.sangchu.postgresql.repository.CommAptRepository;
import com.sc.sangchu.postgresql.repository.CommFacilitiesRepository;
import com.sc.sangchu.postgresql.repository.CommIndicatorChangeRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class CommInfraService {
    private final CommIndicatorChangeRepository commIndicatorChangeRepository;
    private final CommAptRepository commAptRepository;
    private final CommFacilitiesRepository commFacilitiesRepository;
    private final Integer year = 2023;
    private final Integer quarter = 3;

    @Autowired
    public CommInfraService(CommIndicatorChangeRepository commIndicatorChangeRepository,
                            CommAptRepository commAptRepository, CommFacilitiesRepository commFacilitiesRepository) {
        this.commIndicatorChangeRepository = commIndicatorChangeRepository;
        this.commAptRepository = commAptRepository;
        this.commFacilitiesRepository = commFacilitiesRepository;
    }

    // RDI 가져오기 (하, 중, 상, 최상)
    public CommIndicatorDTO getRDI (Long commCode) {
        try {
            List <CommIndicatorChangeEntity> rdiList = commIndicatorChangeRepository.findAll();

            // 사분위수 계산을 위한 리스트 정렬
            rdiList = rdiList.stream()
                    .sorted(Comparator.comparing(CommIndicatorChangeEntity::getRdi))
                    .toList();

            // 중앙값
            Double median = getMedianFromSortedRDIList(rdiList);

            // 중앙값을 기준으로 두 서브리스트로 나눕니다.
            List<CommIndicatorChangeEntity> lowerHalf = rdiList.stream()
                    .filter(rdi -> rdi.getRdi() < median)
                    .collect(Collectors.toList());
            List<CommIndicatorChangeEntity> upperHalf = rdiList.stream()
                    .filter(rdi -> rdi.getRdi() > median)
                    .collect(Collectors.toList());

            // 각 서브리스트의 중앙값을 계산합니다.
            Double lowerMedian = lowerHalf.isEmpty() ? null : getMedianFromSortedRDIList(lowerHalf);
            Double upperMedian = upperHalf.isEmpty() ? null : getMedianFromSortedRDIList(upperHalf);

            String quartileGrades = null;

            double value = commIndicatorChangeRepository
                    .findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode, year, quarter)
                    .getRdi();

            if (value < lowerMedian) {
                quartileGrades = "하";
            } else if (value < median) {
                quartileGrades = "중";
            } else if (value < upperMedian) {
                quartileGrades = "상";
            } else {
                quartileGrades = "최상";
            }

            return CommIndicatorDTO.builder().rdi(quartileGrades).build();
        } catch (Exception e) {
            log.error("getRDI error", e);
        }
        return null;
    }

    // 상권변화지표명 가져오기
    public CommIndicatorDTO getChangeIndicatorName (Long commCode){
        try {
            String indicator = commIndicatorChangeRepository
                    .findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode, year, quarter)
                    .getCommChangeIndicatorName();

            return CommIndicatorDTO.builder().indicator(indicator).build();
        } catch (Exception e) {
            log.error("getChangeIndicatorName error", e);
        }
        return null;
    }

    // 아파트 단지 수, 평균 면적, 평균 시가 가져오기
    public CommAptDTO getApt (Long commCode) {
        try {
            CommAptEntity commAptEntity = commAptRepository
                    .findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode, year, quarter);

            Long apartmentComplexes = commAptEntity
                    .getApartmentComplexes();
            Long aptAvgArea = commAptEntity
                    .getAptAvgArea();
            Long aptAvgPrice = commAptEntity
                    .getAptAvgPrice();

            return CommAptDTO.builder()
                    .apartmentComplexes(apartmentComplexes)
                    .aptAvgArea(aptAvgArea)
                    .aptAvgPrice(aptAvgPrice)
                    .build();
        } catch (Exception e) {
            log.error("getApt error", e);
        }
        return null;
    }

    // 집객 시설 수 가져오기
    public CommFacilitiesDTO getFacilities (Long commCode) {
        try {
            CommFacilitiesEntity commFacilitiesEntity = commFacilitiesRepository
                    .findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode, year, quarter);

            Long facilities = commFacilitiesEntity
                    .getFacilities();
            Double bus = commFacilitiesEntity
                    .getBus();
            Double culTouristFacilities = commFacilitiesEntity
                    .getCulTouristFacilities();
            Double educationalFacilities = commFacilitiesEntity
                    .getEducationalFacilities();
            Double trainSubway = commFacilitiesEntity
                    .getTrainSubway();

            return CommFacilitiesDTO.builder()
                    .facilities(facilities)
                    .bus(bus)
                    .culTouristFacilities(culTouristFacilities)
                    .educationalFacilities(educationalFacilities)
                    .trainSubway(trainSubway)
                    .build();

        } catch (Exception e) {
            log.error("getApt error", e);
        }
        return null;
    }

    // 리스트 중앙 값 메서드
    private double getMedianFromSortedRDIList(List<CommIndicatorChangeEntity> sortedList) {
        int size = sortedList.size();
        if (size % 2 == 1) {
            // 리스트의 크기가 홀수인 경우
            return sortedList.get(size / 2).getRdi();
        } else {
            // 리스트의 크기가 짝수인 경우
            return (sortedList.get(size / 2 - 1).getRdi() + sortedList.get(size / 2).getRdi()) / 2.0;
        }
    }
}
