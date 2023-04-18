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
        stage('Build the application') {
            steps {
                script {
                    echo 'Building the react app...'
                    npm install
                }
            }
        }
        stage('Run unit tests') {
            steps {
                script {
                    npm run test
                }
            }
        }

    }
}
