pipeline {
    environment {
        imagenamePrefix = "luckymode"
        registryCredential = 'dockerhub-cred'
    }

    agent any

    stages {
//        stage('Launch infrastructure') {
//            steps {
//                script {
//                    sh 'terraform init'
//                    sh 'terraform apply -auto-approve'
//                }
//            }
//        }

        stage('Build API Image') { 
            steps {
                script {
                    apiImage = docker.build("${imagenamePrefix}/scheduler_api:${env.GIT_BRANCH}", "-f ./Dockerfile.api .")
                }
            }
        }

        stage('Build Web Image') { 
            steps {
                script {
                    webImage = docker.build("${imagenamePrefix}/scheduler_web:${env.GIT_BRANCH}", "-f ./Dockerfile.web .")
                }
            }
        }

        stage('Test') { 
            steps {
                echo 'Running tests...'
            }
        }

        stage('Push Images to Registry') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        apiImage.push("${env.GIT_BRANCH}")
                        webImage.push("${env.GIT_BRANCH}")
                    }
                }
            }
        }

        stage('Run Containers') {
            steps {
                script {
                    echo "Running API container..."
                    sh 'docker run --rm -d --name api-container ${imagenamePrefix}/scheduler_api:${env.GIT_BRANCH}'

//                    echo "Running Web container..."
//                    sh 'docker run --rm -d --name web-container ${imagenamePrefix}/scheduler_web:${env.GIT_BRANCH}'
                }
            }
        }

        stage('Extract Artifacts from Containers') {
            steps {
                script {
                    echo "Extracting artifacts from API container..."
                    sh 'docker cp api-container:/usr/local/tomcat/webapps/class_schedule.war ./api-artifacts'

//                    echo "Extracting artifacts from Web container..."
//                    sh 'docker cp web-container:/path/to/artifacts ./web-artifacts'

                    sh 'ls -lhR'
//                    archiveArtifacts artifacts: 'api-artifacts/**, web-artifacts/**', allowEmptyArchive: true
                }
            }
        }

//        stage('Run Ansible Playbook') {
//            steps {
//                script {
//                    echo 'Running Ansible playbook...'
//                    sh 'ansible-playbook ...'
//                }
//            }
//        }

//        stage('Destroy Infrastructure') {
//            steps {
//                script {
//                    echo 'Destroying infrastructure...'
//                    sh 'terraform destroy -auto-approve'
//                }
//            }
//        }
    }

    post {
        always {
            script {
                sh 'docker stop api-container || true'
                sh 'docker stop web-container || true'

                cleanWs()
            }
        }
    }
}
