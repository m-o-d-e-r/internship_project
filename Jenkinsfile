pipeline {
    agent any
    stages {
        stage('Build API') { 
            steps {
                sh'''
                    echo $USER
                    echo `ip a`
                    make build_api
                '''
            }
        }
        stage('Build Web') { 
            steps {
                sh 'make build_web'
            }
        }
//        stage('Test') { 
//            steps {
//                echo tesing
//            }
//        }
//        stage('Deploy') { 
//            steps {
//                echo pushing
//            }
//        }
    }
}
