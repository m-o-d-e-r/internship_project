pipeline {
    environment {
        imagenamePrefix = "luckymode"
        registryCredential = 'dockerhub-cred'
        artifactsDestFolder = "./terraform/aws_with_ansible/playbooks/files"
        apiHost = "localhost"
        apiPort = 8080
    }

    agent any

    stages {
        stage('Launch infrastructure') {
            steps {
                script {
                    sh """
                        cd terraform/aws_with_ansible
                        terraform init
                        terraform apply -auto-approve
                    """
                }

                script {
                    env.apiHost = sh(script: 'cd terraform/aws_with_ansible && terraform output -raw schedule_api', returnStdout: true).trim()
                }
            }
        }

        stage('Build API Image') {
            steps {
                script {
                    apiImage = docker.build("${env.imagenamePrefix}/scheduler_api:${env.GIT_BRANCH}", "-f ./Dockerfile.api .")
                }
            }
        }

//        stage('Build Web Image') {
//            steps {
//                script {
//                    def imageTag = "${env.imagenamePrefix}/scheduler_web:${env.GIT_BRANCH}"
//
//                    webImage = docker.build(imageTag, [
//                        "--build-arg API_BASE_URL=http://${env.apiHost}:${env.apiPort}/class_schedule",
//                        "-f ./Dockerfile.web",
//                        "."
//                    ])
//                }
//            }
//        }

        stage('Push Images to Registry') {
            steps {
                script {
                    docker.withRegistry('', env.registryCredential) {
                        apiImage.push("${env.GIT_BRANCH}")
//                        webImage.push("${env.GIT_BRANCH}")
                    }
                }
            }
        }

        stage('Run Containers') {
            steps {
                script {
                    echo "Running API container..."
                    sh "docker run --rm -d --name api-container ${env.imagenamePrefix}/scheduler_api:${env.GIT_BRANCH}"

//                    echo "Running web container..."
//                    sh "docker run --rm -d --name web-container ${env.imagenamePrefix}/scheduler_web:${env.GIT_BRANCH}"
                }
            }
        }

        stage('Extract Artifacts from Containers') {
            steps {
                script {
                    echo "Extracting artifacts from API container..."
                    sh "docker cp api-container:/usr/local/tomcat/webapps/class_schedule.war ${env.artifactsDestFolder}/api-artifact"

//                    echo "Extracting artifacts from Web container..."
//                    sh "docker cp web-container:/usr/share/nginx/html ${env.artifactsDestFolder}/web-artifact"

                    sh "ls -lh ${env.artifactsDestFolder}"
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    echo 'Running Ansible playbooks...'
                    sh """
                        cd terraform/aws_with_ansible

                        export ANSIBLE_HOST_KEY_CHECKING=False

                        ansible-playbook playbooks/python_playbook.yaml  -i inventory/aws_ec2.yaml
                        ansible-playbook playbooks/dbs_playbook.yaml  -i inventory/aws_ec2.yaml
                        ansible-playbook playbooks/api_playbook.yaml  -i inventory/aws_ec2.yaml
                        #ansible-playbook playbooks/web_playbook.yaml  -i inventory/aws_ec2.yaml
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'docker stop api-container || true'
                sh 'docker stop web-container || true'


                def userResponse = input message: 'Do you want to destroy the infrastructure?', ok: 'Yes, destroy', parameters: [
                    booleanParam(defaultValue: true, description: 'Check to confirm destruction', name: 'confirmDestroy')
                ]

                if (userResponse.confirmDestroy) {
                    echo 'Destroying infrastructure...'
                    sh """
                        cd terraform/aws_with_ansible
                        terraform destroy -auto-approve
                    """
                } else {
                    echo 'Skipping infrastructure destruction.'
                }

                cleanWs()
            }
        }
    }
}
