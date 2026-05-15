# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Producción
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# Propiedad del archivo al usuario no root [cite: 95]
COPY --chown=appuser:appgroup --from=builder /build/target/*.jar app.jar
USER appuser
EXPOSE 8080 
ENTRYPOINT ["java", "-jar", "app.jar"]