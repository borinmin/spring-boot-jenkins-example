pipeline {
    agent any

    environment {
        IMAGE_NAME = "springboot-demo"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Detect Tag') {
            steps {
                script {
                    // Force fetch tags
                    sh 'git fetch --tags'

                    // Detect tag from commit
                    def tag = sh(
                        script: "git describe --tags --exact-match 2>/dev/null || echo ''",
                        returnStdout: true
                    ).trim()

                    if (!tag) {
                        error("❌ This is not a tag build. Stopping pipeline.")
                    }

                    env.GIT_TAG = tag
                    echo "✅ Building tag: ${tag}"
                }
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${GIT_TAG} .
                """
            }
        }

        stage('Deploy') {
            steps {
                sh """
                docker stop springboot-demo || true
                docker rm springboot-demo || true

                docker run -d -p 8081:8080 \
                    -e APP_VERSION=${GIT_TAG} \
                    --name springboot-demo \
                    ${IMAGE_NAME}:${GIT_TAG}
                """
            }
        }
    }
}