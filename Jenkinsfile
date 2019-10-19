pipeline {
    agent any
    
    environment {
        SDK_VERSION = '3.0.100-alpine3.9'
        RUNTIME_VERSION = '3.0.0-alpine3.9'
        IMAGE_NAME = 'tenogy/aspnet'
        IMAGE_VERTION = 'tenogy/aspnet:1.1'
        RELEASE_VERTION = '1.1'
        SSH_PASS = credentials('SSH_PASS')
        PUB_HOST = credentials('PUB_HOST')
        APP_DIR = '/app/aspnet'
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
        stage('Staging') {
            when { branch 'production' }
            steps {
                sh 'chmod +x ./scripts/deploy/production.sh'
                sh 'ssh-agent ./scripts/deploy/production.sh /home/.ssh/id_rsa'
            }
        }
        stage('Production') {
            when { 
                branch "production"
                expression {
                    IS_RELEASE = sh(returnStdout: true, script: 'git describe --tags --always').trim().startsWith("release-${RELEASE_VERTION}")
                    return (IS_RELEASE == true)
                }
            } 
            steps {
                input message: 'Publish release to production? (Click "Proceed" to continue)'
                sh 'echo Publishing release ${IMAGE_VERTION}.${BUILD_NUMBER} to prod...'
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