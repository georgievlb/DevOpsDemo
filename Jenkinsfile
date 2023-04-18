pipeline {
    options {
        timestamps()
        disableConcurrentBuilds()
    }

    agent { label 'ec2-buildnode' }

    triggers {
        pollSCM('H/5 * * * *')
    }

    tools{nodejs 'node'}
    stages {
        stage('Build the application') {
            steps {
                echo 'Building the react app...'
                    sh 'cd ./my-app-src && npm install && npm run test'
            }
        }
    }
}
