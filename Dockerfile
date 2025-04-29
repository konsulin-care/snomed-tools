# Stage 1: Buld JAR files with Clojure tools

# Initialize Clojure builder
FROM clojure:temurin-17-tools-deps-bullseye-slim AS builder
WORKDIR /build

# Copy source code
COPY hermes /build/hermes
COPY hades /build/hades

# Build Hermes
WORKDIR /build/hermes
RUN clojure -T:build uber && \
    cp target/*.jar /build/hermes.jar

# Build Hades
WORKDIR /build/hades
RUN clojure -T:build uber && \
    cp target/*.jar /build/hades.jar

# Stage 2: Build a minimal runtime image

# Use Alpine linux as the base image
FROM eclipse-temurin:17-jre-noble
WORKDIR /app

# Copy the compiled JAR files
COPY --from=builder /build/hermes.jar ./hermes.jar
COPY --from=builder /build/hades.jar ./hades.jar

# Prepare the start up script
COPY build-db.sh ./build-db.sh
RUN chmod +x ./build-db.sh

# Create a persistent volume to store SNOMED CT
VOLUME /data
