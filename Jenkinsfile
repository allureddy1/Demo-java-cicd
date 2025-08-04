pipeline {
    agent any

    tools {
        maven 'maven3.9' // Ensure this is the exact name configured under "Global Tool Configuration"
    }

    environment {
        SONAR_PROJECT_KEY = 'demo'
        SONAR_HOST_URL = 'http://localhost:9000'
        IMAGE_NAME = 'allureddy/demo-java-cicd'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/allureddy1/Demo-java-cicd.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_TOKEN = credentials('sonar-token') // Must exist in Jenkins credentials
            }
            steps {
                withSonarQubeEnv('My SonarQube Server') {
                    sh """
                        mvn sonar:sonar \
                          -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                          -Dsonar.host.url=${SONAR_HOST_URL} \
                          -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds-id',
                    usernameVariable: 'DOCKERHUB_USERNAME',
                    passwordVariable: 'DOCKERHUB_PASSWORD')]) {

                    sh """
                        echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh """
                        # Stop and remove existing container (if any)
                        docker rm -f demo-java-container || true

                        # Run new container with the same image
                        docker run -d --name demo-java-container -p 8081:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
