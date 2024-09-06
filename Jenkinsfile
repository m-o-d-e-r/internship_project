pipeline {
    agent any
    stages {
        stage('Build API') { 
            steps {
                docker build -f ./Dockerfile.api -t scheduler_api .
            }
        }
        stage('Build Web') { 
            steps {
                docker build -f ./Dockerfile.web -t scheduler_web .
            }
        }
        stage('Test') { 
            steps {
                echo tesing
            }
        }
        stage('Deploy') { 
            steps {
                echo pushing
            }
        }
    }
}
