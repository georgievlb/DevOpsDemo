pipeline {
    options {
        timestamps()
        disableConcurrentBuilds()
    }

    agent { label 'ec2-buildnode' }

    environment {
        DOCKER_IMAGE = "lbgeorgiev.jfrog.io/docker/devopsdemo:1.0.0"
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    tools {
        jfrog 'jfrog-cli'
    }

    parameters {
        string(
            name: 'EKS_STACK_NAME',
            defaultValue: 'devopsdemo',
            description: 'The AWS EKS CloudFormation stack name.'
        )
        string(
            name: 'EKS_AWS_REGION',
            defaultValue: 'us-east-1',
            description: 'The AWS region.'
        )
        booleanParam(
            name: 'DEPLOY_TO_AWS',
            defaultValue: false,
            description: 'Check this if you want to deploy to AWS.'
        )
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
        stage('Create/Update EKS cluster') {
            steps {
                sh """
                    CLUSTER_STATUS=$(aws eks --region us-east-1 describe-cluster --name DevOpsDemoEKS --query "cluster.status" --output text)
                    if [ "$CLUSTER_STATUS" != "ACTIVE" ]; then
                        echo "Deploying EKS Cluster."
                    fi
                """
            }
        }
    }
}
