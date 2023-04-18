pipeline {
    options {
        timestamps()
        disableConcurrentBuilds()
    }

    agent { label 'ec2-buildnode' }

    environment {
        DOCKER_IMAGE = "lbgeorgiev.jfrog.io/devopsdemo/devopsdemo:latest"
    }

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
                    docker.build("$DOCKER_IMAGE", "-f ./Dockerfile .")
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
