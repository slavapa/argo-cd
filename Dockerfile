# Phase 1 
FROM newtmitch/sonar-scanner
WORKDIR /usr/src
COPY ./sonar-runner.properties /usr/lib/sonar-scanner/conf/sonar-scanner.properties
COPY ./sonar-runner.properties ./
COPY ./gradle ./api
#COPY ./src ./api
RUN sonar-scanner  -Dsonar.projectBaseDir=/usr/src


# Phase 2
FROM openjdk:19-jdk-alpine3.14 as builder
WORKDIR /app
COPY .mvn/ .mvn
COPY ./mvnw  ./
COPY ./pom.xml ./
COPY src ./src
COPY ./healthy .
RUN ./mvnw package

# Phase 3
FROM openjdk:19-jdk-alpine3.14
#FROM openjdk:8-jre-alpine
WORKDIR /code
COPY --from=builder /app/target/*.jar .
EXPOSE 8080
CMD ["java","-jar","spring-petclinic-2.6.0-SNAPSHOT.jar"]


