# ==============================
# Stage 1: Build the Application
# ==============================
FROM --platform=$BUILDPLATFORM maven:3.9-amazoncorretto-17 AS build-base
# Set Maven Default ARGS
ENV MAVEN_ARGS="--batch-mode --no-transfer-progress -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=\"yyyy-MM-dd'T'HH:mm:ss\" -Dorg.slf4j.simpleLogger.defaultLogLevel=warn"
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:go-offline
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 \
    mvn clean package -DskipTests

# ==============================
# Stage 2: Run the Application
# ==============================
FROM amazoncorretto:17-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup 
USER appuser

WORKDIR /app
COPY --from=build-base /app/target/*.jar app.jar
EXPOSE 8080
# enable limits and limit memory to 75%
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75"
CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]