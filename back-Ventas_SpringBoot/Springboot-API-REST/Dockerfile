# Multistage
# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runner
FROM eclipse-temurin:21-jdk AS runner
WORKDIR /app

# Crear grupo y usuario no root
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY --from=builder /build/target/*.jar app.jar
COPY entrypoint.sh /entrypoint.sh

# Asignar permisos de la carpeta al nuevo usuario y cambiar a ese usuario
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]