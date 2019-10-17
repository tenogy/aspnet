pipeline {
    agent any
     environment {
        version = 1.0
        sdkVersion = '3.0.100-alpine3.9'
    }
      stages {
        stage('Build') {
            steps {
                sh 'docker build -t tenogy/aspnet:${version}.${BUILD_NUMBER} --build-arg VERSION=${sdkVersion} .'
            }
        }
        stage('Test') {
            steps {
                sh 'ls -a'
            }
        }
    }
}