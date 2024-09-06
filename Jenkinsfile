pipeline {
    environment {
        imagenamePrefix = "luckymode"
        registryCredential = 'dockerhub-cred'
    }

    agent any

    stages {
        stage('Build API') { 
            steps {
                script {
                    apiImage = docker.build("$imagenamePrefix/scheduler_api:${env.GIT_BRANCH}", "-f ./Dockerfile.api .")
                }
            }
        }
        stage('Build Web') { 
            steps {
                script {
                    webImage = docker.build("$imagenamePrefix/scheduler_web:${env.GIT_BRANCH}", "-f ./Dockerfile.web .")
                }
            }
        }
        stage('Test') { 
            steps {
                echo 'Running tests...'
            }
        }
        stage('Delivery images') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        apiImage.push("${env.GIT_BRANCH}")
                        webImage.push("${env.GIT_BRANCH}")
                    }
                }
            }
        }
    }
}
