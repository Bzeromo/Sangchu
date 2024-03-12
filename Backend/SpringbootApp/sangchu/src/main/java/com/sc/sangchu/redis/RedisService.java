package com.sc.sangchu.redis;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sc.sangchu.dto.CommDistDTO;
import com.sc.sangchu.postgresql.service.CommDistService;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class RedisService {

    private final RedisTemplate<String,Object> redisTemplate;
    private final CommDistService commDistService;

    @Autowired
    public RedisService(RedisTemplate<String, Object> redisTemplate, CommDistService commDistService) {
        this.redisTemplate = redisTemplate;
        this.commDistService = commDistService;
    }

//    public void saveData(CommDistDTO data) throws JsonProcessingException {
//        ObjectMapper objectMapper = new ObjectMapper();
//        Integer coId = data.getCoId();
//        String key = data.getCoId() + "-" + data.getBigCateId() + data.getMidCateId();
//        ListOperations<String, Object> listOps = redisTemplate.opsForList();
//
//        Map<String,Object> combinedData = new HashMap<>();
//        combinedData.put("coId", data.getCoId());
//        String jsonData = objectMapper.writeValueAsString(combinedData);
//
//        listOps.rightPush(key, jsonData);
//        log.info("Save data - Redis");
//        Long size = listOps.size(key);
//    }

    public Object getLastProjectData(Long coId, String userEmail) { // 되돌리기에서 사용
        String key = coId + ":" + userEmail;
        if(Boolean.TRUE.equals(redisTemplate.hasKey(key))){
            log.info("Get last data - Redis");
            redisTemplate.opsForList().rightPop(key);
            return redisTemplate.opsForList().rightPop(key);

        }
        return null;
    }

    // 영역코드가 일치하는 곳에서 상권 점수 기준으로 정렬 후 리턴
    public List <CommDistDTO> getAllDataProject(Integer areaCode)
            throws JsonProcessingException {
        List<CommDistDTO> results = new ArrayList<>();
        ObjectMapper objectMapper = new ObjectMapper();

        Set<String> keys = redisTemplate.keys(areaCode + ":*");

        assert keys != null;
        for (String key : keys) {
            List<Object> data = redisTemplate.opsForList().range(key, 0, -1);
            assert data != null;
            for (Object o : data) {
                CommDistDTO commDistDTO = objectMapper.readValue((String) o,
                        CommDistDTO.class);
                results.add(commDistDTO);
            }

            int currentSize = data.size();

            int remainSize = 5;
            if (currentSize > remainSize) {
                int excessData = currentSize - remainSize;
                // 초과하는 데이터를 삭제
                for (int i = 0; i < excessData; i++) {
                    redisTemplate.opsForList().leftPop(key);
                }
            }
        }
        log.info("Get all data - Redis");
        results.sort(Comparator.comparing(CommDistDTO::getCoScore));
        return results;
    }

    // coId 기준으로 어떤 사용자가 프로젝트를 종료했을때 호출하여 기록 삭제
    public boolean deleteData(Integer coId, Integer bigCateId, Integer midCateId) {
        String key= coId + "-" + bigCateId + midCateId;
        redisTemplate.delete(key);
        return true;
    }
}
