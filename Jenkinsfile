pipeline {
    options {
        timestamps()
        disableConcurrentBuilds()
    }

    agent { label 'ec2-buildnode' }

    environment {
        ARTIFACTORY = credentials('JFrog')    
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
                    dockerImage = docker.build("devopsdemo/devopsdemo:latest", "-f ./Dockerfile .")
                }
            }
        }
        stage('Scan and push docker image') {
            steps {
                jf 'docker scan ${dockerImage}'
                jf 'docker push ${dockerImage}'
            }
        }
    }
}
