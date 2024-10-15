pipeline {
    environment {
        imagenamePrefix = "luckymode"
        registryCredential = 'dockerhub-cred'
        artifactsDestFolder = "./terraform/aws_with_ansible/playbooks/files"
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
                        terraform output
                    """
                }
            }
        }

        stage('Build API Image') {
            steps {
                script {
                    apiImage = docker.build(
                        "${env.imagenamePrefix}/scheduler_api:${env.GIT_BRANCH}",
                        "-f ./Dockerfile.api ."
                    )
                }
            }
        }

        stage('Build Web Image') {
            steps {
                script {
                    def apiHost = sh(script: 'cd terraform/aws_with_ansible && terraform output -raw schedule_api', returnStdout: true).trim()

                    echo "API_BASE_URL will be set to ${apiHost}"

                    webImage = docker.build(
                        "${env.imagenamePrefix}/scheduler_web:${env.GIT_BRANCH}",
                        "--build-arg API_BASE_URL=http://${apiHost}:${env.apiPort}/class_schedule -f ./Dockerfile.web ."
                    )
                }
            }
        }

        stage('Run Containers') {
            steps {
                script {
                    echo "Running API container..."
                    sh "docker run --rm -d --name api-container ${env.imagenamePrefix}/scheduler_api:${env.GIT_BRANCH}"

                    echo "Running web container..."
                    sh "docker run --rm -d --name web-container ${env.imagenamePrefix}/scheduler_web:${env.GIT_BRANCH}"
                }
            }
        }

        stage('Extract Artifacts from Containers') {
            steps {
                script {
                    echo "Extracting artifacts from API container..."
                    sh "docker cp api-container:/usr/local/tomcat/webapps/class_schedule.war ${env.artifactsDestFolder}/api-artifact"

                    echo "Extracting artifacts from Web container..."
                    sh "docker cp web-container:/usr/share/nginx/html ${env.artifactsDestFolder}/web-artifact"
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    echo 'Running Ansible playbooks...'

                    def scheduleApisHost = sh(script: 'cd terraform/aws_with_ansible && terraform output -raw schedule_api', returnStdout: true).trim()
                    def scheduleDbsHost = sh(script: 'cd terraform/aws_with_ansible && terraform output -raw schedule_dbs', returnStdout: true).trim()
                    def scheduleWebHost = sh(script: 'cd terraform/aws_with_ansible && terraform output -raw schedule_web', returnStdout: true).trim()
                    def schedulePrometheusHost = sh(script: 'cd terraform/aws_with_ansible && terraform output -raw schedule_prometheus', returnStdout: true).trim()

                    sh """
                        cd terraform/aws_with_ansible

                        export ANSIBLE_HOST_KEY_CHECKING=False

                        ansible-playbook playbooks/python_playbook.yaml -i inventory/aws_ec2.yaml
                        ansible-playbook playbooks/node_exporter.yaml -i inventory/aws_ec2.yaml
                        ansible-playbook playbooks/dbs_playbook.yaml -i inventory/aws_ec2.yaml
                        ansible-playbook playbooks/api_playbook.yaml \
                            -i inventory/aws_ec2.yaml \
                            -e "update_hosts_arg='${scheduleDbsHost}=schedule-db ${scheduleDbsHost}=schedule-mongo ${scheduleDbsHost}=schedule-redis'"
                        ansible-playbook playbooks/web_playbook.yaml -i inventory/aws_ec2.yaml
                        ansible-playbook playbooks/prometheus_playbook.yaml \
                            -i inventory/aws_ec2.yaml \
                            -e "web_nginx_exporter_host=${scheduleWebHost} dbs_postgres_exporter_host=${scheduleDbsHost} dbs_mongo_exporter_host=${scheduleDbsHost} node_exporter_targets='${scheduleApisHost}:9100,${scheduleDbsHost}:9100,${scheduleWebHost}:9100,${schedulePrometheusHost}:9100'"
                        ansible-playbook playbooks/grafana_playbook.yaml \
                            -i inventory/aws_ec2.yaml \
                            -e "prometheus_ds_host=${schedulePrometheusHost} redis_ds_host=${scheduleDbsHost}"
                    """
                }
            }
        }

        stage('Get user input') {
            steps {
                script {
                    input message: 'Do you want to continue?', ok: 'Yes'
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'docker stop api-container || true'
                sh 'docker stop web-container || true'

                echo 'Destroying infrastructure...'
                sh """
                    cd terraform/aws_with_ansible
                    terraform destroy -auto-approve
                """

                cleanWs()
            }
        }
    }
}
