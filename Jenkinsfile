pipeline {
    agent any
     environment {
        version = 1.0
        sdkVersion = '3.0.100-alpine3.9'
        imageName = 'tenogy/aspnet'
        SSH_PASS = credentials('SSH_PASS')
        PUB_HOST = credentials('PUB_HOST')
        PUB_IMAGE= ('${env.imageName}:${env.version}.${env.BUILD_NUMBER}')
    }
      stages {
        stage('Build') {
            steps {
                sh 'docker build -t ${PUB_IMAGE} --build-arg VERSION=${sdkVersion} .'
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
            sh 'docker rmi $(docker images ${imageName} -q) -f'
            sh 'docker container prune -f'
            sh 'docker image prune -f'
        }
    }
}