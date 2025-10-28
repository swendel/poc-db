# ---- Build stage ----
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /workspace

# Cache dependencies first
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Copy sources and build fat JAR
COPY src ./src
RUN mvn -q -DskipTests package

# ---- Runtime stage ----
FROM eclipse-temurin:21-jre-alpine

ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75 -XX:InitialRAMPercentage=50 -Djava.security.egd=file:/dev/./urandom"
ENV SPRING_PROFILES_ACTIVE=default

WORKDIR /app

# Copy the built Spring Boot fat JAR
COPY --from=builder /workspace/target/*-SNAPSHOT.jar /app/app.jar

EXPOSE 8080

# Run as non-root
RUN addgroup -S app && adduser -S app -G app
USER app

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
