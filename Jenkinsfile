pipeline {
    agent any

    environment {
        KEY_PATH = "/var/lib/jenkins/jenkins.pem"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/satheeshm5465-aws/ci-cd-game'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get Server IP') {
            steps {
                dir('terraform') {
                    script {
                        env.SERVER_IP = sh(
                            script: "terraform output -raw public_ip",
                            returnStdout: true
                        ).trim()
                    }
                    echo "Server IP is ${SERVER_IP}"
                }
            }
        }

        stage('Wait for Server to be Ready') {
            steps {
                echo "Waiting for EC2 instance to finish booting..."
                sh 'sleep 60'
            }
        }

        stage('Deploy Website') {
            steps {
                sh """
                scp -r -i ${KEY_PATH} -o StrictHostKeyChecking=no website/* ubuntu@${SERVER_IP}:/tmp/
                """

                sh """
                ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no ubuntu@${SERVER_IP} "
                sudo rm -rf /var/www/html/* &&
                sudo mv /tmp/* /var/www/html/ &&
                sudo systemctl restart nginx"
                """
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment Successful! Visit: http://${SERVER_IP}"
        }
        failure {
            echo "❌ Pipeline Failed. Check logs above."
        }
    }
}
