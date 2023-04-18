pipeline {
    options {
        timestamps()
        disableConcurrentBuilds()
    }

    agent { label 'ec2-buildnode' }

    triggers {
        pollSCM('H/5 * * * *')
    }
    
    tools {
        jfrog 'jfrog-cli'
    }

    stages {
        stage('Run unit tests') {
            steps {
                sh 'cd ./my-app-src && npm install && npm run test'
            }
        }
        stage('Build application') {
            steps {
                sh 'cd ./my-app-src && npm run build'
            }
        }
        stage('Build docker image') {
            steps {
                script {
                    DOCKER_IMAGE = docker.build("devopsdemo/devopsdemo:latest", "-f ./Dockerfile .")
                }
            }
        }
        stage('Scan and push docker image') {
            steps {
                jf 'docker scan $DOCKER_IMAGE'
                jf 'docker push $DOCKER_IMAGE'
            }
        }
    }
}
