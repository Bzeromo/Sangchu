package com.sc.sangchu.postgresql.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.sc.sangchu.dto.consumer.CommFloatingPopulationDTO;
import com.sc.sangchu.dto.consumer.CommResidentPopulationDTO;
import com.sc.sangchu.dto.consumer.CommWorkingPopulationDTO;
import com.sc.sangchu.postgresql.entity.CommFloatingPopulationEntity;
import com.sc.sangchu.postgresql.entity.CommResidentPopulationEntity;
import com.sc.sangchu.postgresql.entity.CommWorkingPopulationEntity;
import com.sc.sangchu.postgresql.repository.CommFloatingPopulationRepository;
import com.sc.sangchu.postgresql.repository.CommResidentPopulationRepository;
import com.sc.sangchu.postgresql.repository.CommWorkingPopulationRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;

@Service
@Slf4j
public class CommConsumerGraphService {
    private final CommFloatingPopulationRepository commFloatingPopulationRepository;
    private final CommResidentPopulationRepository commResidentPopulationRepository;
    private final CommWorkingPopulationRepository commWorkingPopulationRepository;
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private static final Integer YEAR_LIMIT = 2022;
    private static final Integer YEAR = 2023;
    private static final Integer QUARTER = 3;

    public CommConsumerGraphService(CommFloatingPopulationRepository commFloatingPopulationRepository,
                                    ObjectMapper objectMapper,
                                    CommResidentPopulationRepository commResidentPopulationRepository,
                                    CommWorkingPopulationRepository commWorkingPopulationRepository, RedisTemplate<String, Object> redisTemplate) {
        this.commFloatingPopulationRepository = commFloatingPopulationRepository;
        this.objectMapper = objectMapper;
        this.commResidentPopulationRepository = commResidentPopulationRepository;
        this.commWorkingPopulationRepository = commWorkingPopulationRepository;
        this.redisTemplate = redisTemplate;
    }

    // 연령별 유동인구 그래프
    public CommFloatingPopulationDTO getFloatingPopulationAgeGraph(Long commCode) {
        String cacheKey = "consumerGraph:floatingPopulationAgeGraph:" + commCode + ":" + YEAR + ":" + QUARTER;

        try {
            // Redis에서 캐시된 데이터 조회
            Object dataFromRedis = redisTemplate.opsForValue().get(cacheKey);

            if (dataFromRedis != null) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode cachedData = mapper.convertValue(dataFromRedis, JsonNode.class);
                return CommFloatingPopulationDTO.builder()
                        .age(cachedData)
                        .build();
            }
            CommFloatingPopulationEntity entity =
                    commFloatingPopulationRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode,
                        YEAR, QUARTER);

            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("10대");
            categories.add("20대");
            categories.add("30대");
            categories.add("40대");
            categories.add("50대");
            categories.add("60대 이상");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "유동인구 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");
            seriesDataNode.add(entity.getAge10FloatingPopulation());
            seriesDataNode.add(entity.getAge20FloatingPopulation());
            seriesDataNode.add(entity.getAge30FloatingPopulation());
            seriesDataNode.add(entity.getAge40FloatingPopulation());
            seriesDataNode.add(entity.getAge50FloatingPopulation());
            seriesDataNode.add(entity.getAgeOver60FloatingPopulation());
            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            // 차트 데이터 캐시
            redisTemplate.opsForValue().set(cacheKey, chartData);

            return CommFloatingPopulationDTO.builder()
                    .age(chartData)
                    .build();
        } catch (Exception e) {
            log.error("getFloatingPopulationAgeGraph error", e);
        }
        return null;
    }

    // 시간별 유동인구 그래프
    public CommFloatingPopulationDTO getFloatingPopulationTimeGraph(Long commCode) {
        String cacheKey = "consumerGraph:floatingPopulationTimeGraph:" + commCode + ":" + YEAR + ":" + QUARTER;

        try {
            // Redis에서 캐시된 데이터 조회
            Object dataFromRedis = redisTemplate.opsForValue().get(cacheKey);

            if (dataFromRedis != null) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode cachedData = mapper.convertValue(dataFromRedis, JsonNode.class);
                return CommFloatingPopulationDTO.builder()
                        .time(cachedData)
                        .build();
            }

            CommFloatingPopulationEntity entity =
                    commFloatingPopulationRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode,
                        YEAR, QUARTER);

            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("0-6시");
            categories.add("6-11시");
            categories.add("11-14시");
            categories.add("14-17시");
            categories.add("17-21시");
            categories.add("21-24시");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "유동인구 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");
            seriesDataNode.add(entity.getTime00To06FloatingPopulation());
            seriesDataNode.add(entity.getTime06To11FloatingPopulation());
            seriesDataNode.add(entity.getTime11To14FloatingPopulation());
            seriesDataNode.add(entity.getTime14To17FloatingPopulation());
            seriesDataNode.add(entity.getTime17To21FloatingPopulation());
            seriesDataNode.add(entity.getTime21To24FloatingPopulation());
            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            // 차트 데이터 캐시
            redisTemplate.opsForValue().set(cacheKey, chartData);

            return CommFloatingPopulationDTO.builder()
                    .time(chartData)
                    .build();
        } catch (Exception e) {
            log.error("getFloatingPopulationTimeGraph error", e);
        }
        return null;
    }

    // 요일별 유동인구 그래프
    public CommFloatingPopulationDTO getFloatingPopulationDayGraph(Long commCode) {
        String cacheKey = "consumerGraph:floatingPopulationDayGraph:" + commCode + ":" + YEAR + ":" + QUARTER;

        try {
            // Redis에서 캐시된 데이터 조회
            Object dataFromRedis = redisTemplate.opsForValue().get(cacheKey);

            if (dataFromRedis != null) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode cachedData = mapper.convertValue(dataFromRedis, JsonNode.class);
                return CommFloatingPopulationDTO.builder()
                        .time(cachedData)
                        .build();
            }

            CommFloatingPopulationEntity entity =
                    commFloatingPopulationRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode,
                        YEAR, QUARTER);

            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("월요일");
            categories.add("화요일");
            categories.add("수요일");
            categories.add("목요일");
            categories.add("금요일");
            categories.add("토요일");
            categories.add("일요일");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "유동인구 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");
            seriesDataNode.add(entity.getMonFloatingPopulation());
            seriesDataNode.add(entity.getTueFloatingPopulation());
            seriesDataNode.add(entity.getWedFloatingPopulation());
            seriesDataNode.add(entity.getThuFloatingPopulation());
            seriesDataNode.add(entity.getFriFloatingPopulation());
            seriesDataNode.add(entity.getSatFloatingPopulation());
            seriesDataNode.add(entity.getSunFloatingPopulation());
            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            // 차트 데이터 캐시
            redisTemplate.opsForValue().set(cacheKey, chartData);

            return CommFloatingPopulationDTO.builder()
                    .day(chartData)
                    .build();
        } catch (Exception e) {
            log.error("getFloatingPopulationDayGraph error", e);
        }
        return null;
    }

    // 총 유동인구 분기별 추이 그래프 (22~23년)
    public CommFloatingPopulationDTO getFloatingPopulationQuarterlyTrendsGraph(Long commCode) {
        String cacheKey = "consumerGraph:floatingPopulationQuarterlyTrendsGraph:" + commCode + ":" + YEAR
            + ":" + QUARTER;

        try {
            // Redis에서 캐시된 데이터 조회
            Object dataFromRedis = redisTemplate.opsForValue().get(cacheKey);

            if (dataFromRedis != null) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode cachedData = mapper.convertValue(dataFromRedis, JsonNode.class);
                return CommFloatingPopulationDTO.builder()
                        .time(cachedData)
                        .build();
            }

            List<CommFloatingPopulationEntity> entities =
                    commFloatingPopulationRepository.findAllByCommercialDistrictCode(commCode);

            List<CommFloatingPopulationEntity> sortedEntities = entities.stream()
                    .filter(entity -> entity.getYearCode() >= YEAR_LIMIT)
                    .sorted(Comparator.comparing(CommFloatingPopulationEntity::getYearCode)
                            .thenComparing(CommFloatingPopulationEntity::getQuarterCode))
                    .toList();

            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("2022 1분기");
            categories.add("2022 2분기");
            categories.add("2022 3분기");
            categories.add("2022 4분기");
            categories.add("2023 1분기");
            categories.add("2023 2분기");
            categories.add("2023 3분기");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "유동인구 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");

            for (CommFloatingPopulationEntity entity : sortedEntities)
                seriesDataNode.add(entity.getTotalFloatingPopulation());

            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            // 차트 데이터 캐시
            redisTemplate.opsForValue().set(cacheKey, chartData);

            return CommFloatingPopulationDTO.builder()
                    .quarterlyTrends(chartData)
                    .build();
        } catch (Exception e) {
            log.error("getFloatingPopulationQuarterlyTrendsGraph error", e);
        }
        return null;
    }

    // 성별 연령대별 상주인구 그래프
    public CommResidentPopulationDTO getResidentPopulationGenderAgeGraph(Long commCode) {
        String cacheKey = "consumerGraph:residentPopulationGenderAgeGraph:" + commCode + ":" + YEAR
            + ":" + QUARTER;

        try {
            // Redis에서 캐시된 데이터 조회
            Object dataFromRedis = redisTemplate.opsForValue().get(cacheKey);

            if (dataFromRedis != null) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode cachedData = mapper.convertValue(dataFromRedis, JsonNode.class);
                return CommResidentPopulationDTO.builder()
                        .genderAge(cachedData)
                        .build();
            }
            CommResidentPopulationEntity entity =
                    commResidentPopulationRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode,
                        YEAR, QUARTER);

            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("10대 남성");
            categories.add("20대 남성");
            categories.add("30대 남성");
            categories.add("40대 남성");
            categories.add("50대 남성");
            categories.add("60대 이상 남성");
            categories.add("10대 여성");
            categories.add("20대 여성");
            categories.add("30대 여성");
            categories.add("40대 여성");
            categories.add("50대 여성");
            categories.add("60대 이상 여성");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "상주인구 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");
            seriesDataNode.add(entity.getMaleAge10ResidentPopulation());
            seriesDataNode.add(entity.getMaleAge20ResidentPopulation());
            seriesDataNode.add(entity.getMaleAge30ResidentPopulation());
            seriesDataNode.add(entity.getMaleAge40ResidentPopulation());
            seriesDataNode.add(entity.getMaleAge50ResidentPopulation());
            seriesDataNode.add(entity.getMaleAgeOver60ResidentPopulation());
            seriesDataNode.add(entity.getFemaleAge10ResidentPopulation());
            seriesDataNode.add(entity.getFemaleAge20ResidentPopulation());
            seriesDataNode.add(entity.getFemaleAge30ResidentPopulation());
            seriesDataNode.add(entity.getFemaleAge40ResidentPopulation());
            seriesDataNode.add(entity.getFemaleAge50ResidentPopulation());
            seriesDataNode.add(entity.getFemaleAgeOver60ResidentPopulation());

            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            // 차트 데이터 캐시
            redisTemplate.opsForValue().set(cacheKey, chartData);

            return CommResidentPopulationDTO.builder()
                    .genderAge(chartData)
                    .build();
        } catch (Exception e) {
            log.error("getResidentPopulationGenderAgeGraph error", e);
        }
        return null;
    }

    // 총 상주인구 분기별 추이 그래프 (22~23년)
    public CommResidentPopulationDTO getResidentPopulationQuarterlyTrendsGraph(Long commCode) {
        String cacheKey = "consumerGraph:residentPopulationQuarterlyTrendsGraph:" + commCode + ":" + YEAR
            + ":" + QUARTER;

        try {
            // Redis에서 캐시된 데이터 조회
            Object dataFromRedis = redisTemplate.opsForValue().get(cacheKey);

            if (dataFromRedis != null) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode cachedData = mapper.convertValue(dataFromRedis, JsonNode.class);
                return CommResidentPopulationDTO.builder()
                        .genderAge(cachedData)
                        .build();
            }

            List<CommResidentPopulationEntity> entities =
                    commResidentPopulationRepository.findAllByCommercialDistrictCode(commCode);

            List<CommResidentPopulationEntity> sortedEntities = entities.stream()
                    .filter(entity -> entity.getYearCode() >= YEAR_LIMIT)
                    .sorted(Comparator.comparing(CommResidentPopulationEntity::getYearCode)
                            .thenComparing(CommResidentPopulationEntity::getQuarterCode))
                    .toList();

            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("2022 1분기");
            categories.add("2022 2분기");
            categories.add("2022 3분기");
            categories.add("2022 4분기");
            categories.add("2023 1분기");
            categories.add("2023 2분기");
            categories.add("2023 3분기");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "상주 인구 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");

            for (CommResidentPopulationEntity entity : sortedEntities)
                seriesDataNode.add(entity.getTotalResidentPopulation());

            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            // 차트 데이터 캐시
            redisTemplate.opsForValue().set(cacheKey, chartData);

            return CommResidentPopulationDTO.builder()
                    .quarterlyTrends(chartData)
                    .build();
        } catch (Exception e) {
            log.error("getResidentPopulationQuarterlyTrendsGraph error", e);
        }
        return null;
    }

    // 성별 연령대별 직장인구 그래프
    public CommWorkingPopulationDTO getWorkingPopulationGenderAgeGraph(Long commCode) {
        String cacheKey = "consumerGraph:workingPopulationGenderAgeGraph:" + commCode + ":" + YEAR + ":" + QUARTER;

        try {
            // Redis에서 캐시된 데이터 조회
            Object dataFromRedis = redisTemplate.opsForValue().get(cacheKey);

            if (dataFromRedis != null) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode cachedData = mapper.convertValue(dataFromRedis, JsonNode.class);
                return CommWorkingPopulationDTO.builder()
                        .genderAge(cachedData)
                        .build();
            }

            CommWorkingPopulationEntity entity =
                    commWorkingPopulationRepository.findByCommercialDistrictCodeAndYearCodeAndQuarterCode(commCode,
                        YEAR, QUARTER);

            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("10대 남성");
            categories.add("20대 남성");
            categories.add("30대 남성");
            categories.add("40대 남성");
            categories.add("50대 남성");
            categories.add("60대 이상 남성");
            categories.add("10대 여성");
            categories.add("20대 여성");
            categories.add("30대 여성");
            categories.add("40대 여성");
            categories.add("50대 여성");
            categories.add("60대 이상 여성");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "직장인구 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");
            seriesDataNode.add(entity.getMaleAge10WorkingPopulation());
            seriesDataNode.add(entity.getMaleAge20WorkingPopulation());
            seriesDataNode.add(entity.getMaleAge30WorkingPopulation());
            seriesDataNode.add(entity.getMaleAge40WorkingPopulation());
            seriesDataNode.add(entity.getMaleAge50WorkingPopulation());
            seriesDataNode.add(entity.getMaleAgeOver60WorkingPopulation());
            seriesDataNode.add(entity.getFemaleAge10WorkingPopulation());
            seriesDataNode.add(entity.getFemaleAge20WorkingPopulation());
            seriesDataNode.add(entity.getFemaleAge30WorkingPopulation());
            seriesDataNode.add(entity.getFemaleAge40WorkingPopulation());
            seriesDataNode.add(entity.getFemaleAge50WorkingPopulation());
            seriesDataNode.add(entity.getFemaleAgeOver60WorkingPopulation());

            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            // 차트 데이터 캐시
            redisTemplate.opsForValue().set(cacheKey, chartData);

            return CommWorkingPopulationDTO.builder()
                    .genderAge(chartData)
                    .build();
        } catch (Exception e) {
            log.error("getWorkingPopulationGenderAgeGraph error", e);
        }
        return null;
    }

    // 총 직장인구 분기별 추이 그래프 (22~23년)
    public CommWorkingPopulationDTO getWorkingPopulationQuarterlyTrendsGraph(Long commCode) {
        String cacheKey = "consumerGraph:workingPopulationQuarterlyTrendsGraph:" + commCode + ":" + YEAR
            + ":" + QUARTER;

        try {
            // Redis에서 캐시된 데이터 조회
            Object dataFromRedis = redisTemplate.opsForValue().get(cacheKey);

            if (dataFromRedis != null) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode cachedData = mapper.convertValue(dataFromRedis, JsonNode.class);
                return CommWorkingPopulationDTO.builder()
                        .genderAge(cachedData)
                        .build();
            }

            List<CommWorkingPopulationEntity> entities =
                    commWorkingPopulationRepository.findAllByCommercialDistrictCode(commCode);

            List<CommWorkingPopulationEntity> sortedEntities = entities.stream()
                    .filter(entity -> entity.getYearCode() >= YEAR_LIMIT)
                    .sorted(Comparator.comparing(CommWorkingPopulationEntity::getYearCode)
                            .thenComparing(CommWorkingPopulationEntity::getQuarterCode))
                    .toList();

            ObjectNode chartData = objectMapper.createObjectNode();
            chartData.put("chartType", "bar");

            ObjectNode data = objectMapper.createObjectNode();
            ArrayNode categories = objectMapper.createArrayNode();
            ArrayNode series = objectMapper.createArrayNode();

            categories.add("2022 1분기");
            categories.add("2022 2분기");
            categories.add("2022 3분기");
            categories.add("2022 4분기");
            categories.add("2023 1분기");
            categories.add("2023 2분기");
            categories.add("2023 3분기");

            ObjectNode seriesData = objectMapper.createObjectNode();
            seriesData.put("name", "직장 인구 수");

            ArrayNode seriesDataNode = seriesData.putArray("data");

            for (CommWorkingPopulationEntity entity : sortedEntities)
                seriesDataNode.add(entity.getTotalWorkingPopulation());

            series.add(seriesData);

            data.set("categories", categories);
            data.set("series", series);
            chartData.set("data", data);

            // 차트 데이터 캐시
            redisTemplate.opsForValue().set(cacheKey, chartData);

            return CommWorkingPopulationDTO.builder()
                    .quarterlyTrends(chartData)
                    .build();
        } catch (Exception e) {
            log.error("getWorkingPopulationQuarterlyTrendsGraph error", e);
        }
        return null;
    }
}
