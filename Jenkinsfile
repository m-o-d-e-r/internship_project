pipeline {
    agent any
    stages {
        stage('Build API') { 
            steps {
                echo 'build api'
//                sh 'make build_api'
            }
        }
        stage('Build Web') { 
            steps {
//                sh 'make build_web'
                echo 'build web'
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
