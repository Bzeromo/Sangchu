package com.sc.sangchu.postgresql.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.sc.sangchu.dto.infra.CommAptDTO;
import com.sc.sangchu.dto.infra.CommStoreDTO;
import com.sc.sangchu.postgresql.entity.CommAptEntity;
import com.sc.sangchu.postgresql.entity.CommStoreEntity;
import com.sc.sangchu.postgresql.repository.CommAptRepository;
import com.sc.sangchu.postgresql.repository.CommStoreRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class CommInfraGraphService {
    private final CommStoreRepository commStoreRepository;
    private final CommAptRepository commAptRepository;
    private final ObjectMapper objectMapper;
    private final Integer year = 2023;
    private final Integer quarter = 3;

    @Autowired
    public CommInfraGraphService(CommStoreRepository commStoreRepository, ObjectMapper objectMapper,
                                 CommAptRepository commAptRepository) {
        this.commStoreRepository = commStoreRepository;
        this.objectMapper = objectMapper;
        this.commAptRepository = commAptRepository;
    }

    /* json 형태 예시
    {
      "chartType": "bar",
      "data": {
        "categories": ["한식음식점", "당구장" ...],
        "series": [
          {
            "ServiceCode": "blabla",
            "serviceName": "blabla",
            "storeCount":12,
            "franchiseStoreCount":3
          }
        ]
      }
    }
    */

    public CommStoreDTO getStoreDataAsJson(Long commCode) {
        try {
            List<CommStoreEntity> stores = commStoreRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode, year, quarter);
            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            ArrayNode storeCount = objectMapper.createArrayNode();
            ArrayNode franchiseStoreCount = objectMapper.createArrayNode();
            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "점포 수");

            for (CommStoreEntity store : stores) {
                categories.add(store.getServiceName());
                storeCount.add(store.getStoreCount());
                franchiseStoreCount.add(store.getFranchiseStoreCount());
            }
            seriesData.set("storeCount", storeCount);
            seriesData.set("franchiseStoreCount", franchiseStoreCount);
            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            return CommStoreDTO.builder()
                    .storeGraph(chartData)
                    .build();
        }catch (Exception e){
            log.error("getStoreDataAsJson error", e);
        }
        return null;
    }

    /* json 예시
    {
      "chartType": "bar",
      "data": {
        "categories": ["20평 미만", "20평~30평", "30평~40평", "40평~50평", "50평 이상"],
        "series": [
          {
            "name": "세대 수",
            "data": [100, 150, 200, 120, 80]
          }
        ]
      }
    }
    */

    public CommAptDTO getAptAreaDataAsJson(Long commCode) {
        try {
            CommAptEntity apts = commAptRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode, year, quarter);
            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("20평 미만");
            categories.add("20평~30평");
            categories.add("30평~40평");
            categories.add("40평~50평");
            categories.add("50평 이상");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "세대 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");
            seriesDataNode.add(apts.getHouseholdUnder20Pyeong());
            seriesDataNode.add(apts.getHousehold20To30Pyeong());
            seriesDataNode.add(apts.getHousehold30To40Pyeong());
            seriesDataNode.add(apts.getHousehold40To50Pyeong());
            seriesDataNode.add(apts.getHouseholdOver50Pyeong());
            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            return CommAptDTO.builder()
                    .areaGraph(chartData)
                    .build();
        }catch(Exception e){
            log.error("getAptAreaDataAsJson error", e);
        }
        return null;
    }

    /* json 예시
    {
      "chartType": "bar",
      "data": {
        "categories": ["1억 미만", "1억~2억", "2억~3억", "3억~4억", "4억~5억", "5억~6억", "6억 이상"],
        "series": [
          {
            "name": "세대 수",
            "data": [100, 150, 160, 80, 50, 20, 10]
          }
        ]
      }
    }
    */

    public CommAptDTO getAptPriceDataAsJson(Long commCode) {
        try {
            CommAptEntity apts = commAptRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode, year, quarter);
            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("1억 미만");
            categories.add("1억~2억");
            categories.add("2억~3억");
            categories.add("3억~4억");
            categories.add("4억~5억");
            categories.add("5억~6억");
            categories.add("6억 이상");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "세대 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");
            seriesDataNode.add(apts.getHouseholdLessThan100MillionPrice());
            seriesDataNode.add(apts.getHousehold100To200MillionPrice());
            seriesDataNode.add(apts.getHousehold200To300MillionPrice());
            seriesDataNode.add(apts.getHousehold300To400MillionPrice());
            seriesDataNode.add(apts.getHousehold400To500MillionPrice());
            seriesDataNode.add(apts.getHousehold500To600MillionPrice());
            seriesDataNode.add(apts.getHouseholdOverThan600MillionPrice());
            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            return CommAptDTO.builder()
                    .priceGraph(chartData)
                    .build();
        }catch(Exception e){
            log.error("getAptPriceDataAsJson error", e);
        }
        return null;
    }
}
