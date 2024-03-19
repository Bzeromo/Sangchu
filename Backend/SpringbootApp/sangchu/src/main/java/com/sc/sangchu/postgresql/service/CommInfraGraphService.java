package com.sc.sangchu.postgresql.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.sc.sangchu.dto.CommStoreDTO;
import com.sc.sangchu.postgresql.entity.CommStoreEntity;
import com.sc.sangchu.postgresql.repository.CommStoreRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class CommInfraGraphService {
    private final CommStoreRepository commStoreRepository;
    private final ObjectMapper objectMapper;

    @Autowired
    public CommInfraGraphService(CommStoreRepository commStoreRepository, ObjectMapper objectMapper) {
        this.commStoreRepository = commStoreRepository;
        this.objectMapper = objectMapper;
    }

    public CommStoreDTO getStoreDataAsJson(Long commCode) {
        List<CommStoreEntity> stores = commStoreRepository.findByCommercialDistrictCode(commCode);
        ObjectNode chartData = objectMapper.createObjectNode();
        chartData.put("chartType", "bar");

        ObjectNode data = objectMapper.createObjectNode();
        ArrayNode categories = objectMapper.createArrayNode();
        ArrayNode series = objectMapper.createArrayNode();

        for (CommStoreEntity store : stores) {
            categories.add(store.getServiceName());
            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("ServiceCode", store.getServiceCode());
            seriesData.put("serviceName", store.getServiceName());
            seriesData.put("storeCount", store.getStoreCount());
            seriesData.put("franchiseStoreCount", store.getFranchiseStoreCount());
            series.add(seriesData);
        }

        data.set("categories", categories);
        data.set("series", series);
        chartData.set("data", data);

        return CommStoreDTO.builder()
                .storeGraph(chartData)
                .build();
    }

    /*
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
}
