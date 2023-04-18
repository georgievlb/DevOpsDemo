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
                echo 'Building the react app...'
                nodejs(nodeJSInstallationName: 'Node 6.x') {
                    sh 'cd ./my-app-src && npm install && npm run test'
                }
            }
        }
    }
}
