FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY target/*.jar app.jar

ENV APP_VERSION=local

ENTRYPOINT ["java", "-jar", "/app/app.jar"]