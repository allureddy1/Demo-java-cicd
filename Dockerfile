FROM openjdk:17
COPY /var/lib/jenkins/workspace/pipeline/target/java-cicd-demo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
