pipeline {
    options {
        timestamps()
        disableConcurrentBuilds()
    }

    agent { label 'ec2-buildnode' }

    triggers {
        pollSCM('H/1 * * * *')
    }

    stages {
        stage('Build the application') {
            steps {
                script {
                    echo 'Building the react app...'
                }
            }
        }
    }
}
