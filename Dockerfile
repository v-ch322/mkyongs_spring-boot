FROM maven:3.8.1-openjdk-17-slim as BUILD
WORKDIR /build
RUN apt update
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ /build/src/
RUN mvn clean package
FROM openjdk:11.0.4-jre-slim
EXPOSE 8080
ARG JARFILE=target/spring-boot-web.jar
WORKDIR /opt/app
COPY --from=0 /build/$JARFILE app.jar
# COPY --from=BUILD /build/$JARFILE /app.jar
ENTRYPOINT ["java","-jar","app.jar"]
