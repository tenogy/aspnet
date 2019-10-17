pipeline {
    agent any
     environment {
        version = 1.0
        sdkVersion = '3.0.100-alpine3.9'
        imageName = 'tenogy/aspnet'
    }
      stages {
        stage('Build') {
            steps {
                sh 'docker build -t ${imageName}:${version}.${BUILD_NUMBER} --build-arg VERSION=${sdkVersion} .'
            }
        }
        stage('Test') {
            steps {
                sh 'ls -a'
            }
        }
    }
    post {
        always {
            echo 'Clean up'
            sh 'docker rmi $(docker images ${imageName}1 -q) -f'
            sh 'docker container prune -f'
            sh 'docker image prune -f'
        }
    }
}