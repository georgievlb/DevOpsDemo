pipeline {
    options {
        timestamps()
        disableConcurrentBuilds()
    }

    agent { label 'ec2-buildnode' }

    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Run unit tests') {
            steps {
                echo 'Building the react app...'
                sh 'cd ./my-app-src && npm install && npm run test'
            }
        }
        stage('Build application') {
            steps {
                echo 'Building the react app...'
                sh 'cd ./my-app-src && npm run build'
            }
        }
    }
}
