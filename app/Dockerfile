# Stage 1: Build con Maven (Actualizado a Java 21)
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /build

# Copiar archivos desde el contexto (que será ./app)
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Imagen final ligera (Actualizado a Java 21)
FROM eclipse-temurin:21-jre-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /application

# Copiar el .jar generado en la etapa anterior
COPY --from=builder /build/target/*.jar app.jar
USER appuser
EXPOSE 8080

# Mantenemos tu excelente HEALTHCHECK conectado al Actuator
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]