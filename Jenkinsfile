pipeline {
    environment {
        imagenamePrefix = "luckymode"
    }

    agent any
    stages {
        stage('Build API') { 
            steps {
                sh 'docker build -f ./Dockerfile.api -t $imagenamePrefix/scheduler_api:${env.GIT_BRANCH} .'
            }
        }
        stage('Build Web') { 
            steps {
                sh 'docker build -f ./Dockerfile.web -t $imagenamePrefix/scheduler_web:${env.GIT_BRANCH} .'
            }
        }
//        stage('Test') { 
//            steps {
//                echo tesing
//            }
//        }
//        stage('Images registry login') {
//            steps {
//
//            }
//        }
//
//        stage('Delivary API') {
//            steps {
//                echo pushing
//            }
//        }
//        stage('Delivary API') {
//            steps {
//                echo pushing
//            }
//        }
    }
}
