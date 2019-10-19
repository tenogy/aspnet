pipeline {
    agent any
     envversion = 1.0
        SDK_VERSION = '3.0.100-alpine3.9'
        IMAGE_NAME = 'tenogy/aspnet'
        IMAGE_VERTION = 'tenogy/aspnet:1.0'
        SSH_PASS = credentials('SSH_PASS')
        PUB_HOST = credentials('PUB_HOST')
    }
      stages {
        stage('Build') {
            steps {
                sh 'docker build -t ${IMAGE_VERTION}.${BUILD_NUMBER} --build-arg VERSION=${SDK_VERSION} .'
            }
        }
        stage('Test') {
            steps {
                sh 'ls -a'
            }
        }
        stage('Deployment') {
            steps {
                sh 'chmod +x ./scripts/deploy/production.sh'
                sh 'ssh-agent ./scripts/deploy/production.sh /home/.ssh/id_rsa'
            }
        }
    }
    post {
        always {
            echo 'Clean up'
            sh 'docker rmi $(docker images ${IMAGE_NAME} -q) -f'
            sh 'docker container prune -f'
            sh 'docker image prune -f'
        }
    }
}