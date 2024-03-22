#FROM ubuntu:latest
#LABEL authors="SSAFY"

# 베이스 이미지 지정
FROM openjdk:latest

# 포트 지정
EXPOSE 8080

# JAR 파일을 이미지 내부로 복사
COPY build/libs/sangchu-springboot-app-0.1.0.jar /sangchu-springboot-app.jar

# 도커 컨테이너에서 실행할 명령어
ENTRYPOINT ["java","-jar","/sangchu-springboot-app.jar"]