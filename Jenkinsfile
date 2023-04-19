/* groovylint-disable DuplicateMapLiteral, LineLength, NestedBlockDepth */
pipeline {
    options {
        timestamps()
        disableConcurrentBuilds()
    }

    agent { label 'ec2-buildnode' }

    environment {
        DOCKER_IMAGE = "lbgeorgiev.jfrog.io/docker/devopsdemo:1.0.0"
        EKS_CLUSTER_NAME = "DevOpsDemoEKS"
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
        stage('Create/Update EKS cluster') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                        def stackExists = sh(returnStatus: true, script: """
                            aws cloudformation describe-stacks --stack-name ${EKS_STACK_NAME} --region ${EKS_AWS_REGION}
                        """)
                        if (stackExists != 0) {
                            echo "Deploying EKS Cluster."
                            sh """
                                aws cloudformation create-stack --stack-name ${EKS_STACK_NAME} \\
                                --region ${EKS_AWS_REGION} \\
                                --template-body 'file://${WORKSPACE}/Infrastructure/eks.yaml' \\
                                --capabilities CAPABILITY_NAMED_IAM
                                aws cloudformation wait stack-create-complete --stack-name ${EKS_STACK_NAME}
                            """
                        } else {
                            echo "Cluster is already active or stack '${EKS_STACK_NAME}' already exists. Attempting to update stack."
                        }
                    }
                }
            }
        }
        stage('Updaete EKS configuration') {
            steps {
                script {
                    withCredentials([
                        usernamePassword(credentialsId: 'aws-key', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY'),
                        string(credentialsId: 'artifactorycred.dockerServer', variable: 'DOCKER_SERVER'),
                        string(credentialsId: 'artifactorycred.dockerUsername', variable: 'DOCKER_USERNAME'),
                        string(credentialsId: 'artifactorycred.dockerPassword', variable: 'DOCKER_PASSWORD'),
                        string(credentialsId: 'artifactorycred.dockerEmail', variable: 'DOCKER_EMAIL')
                        ]) {
                        sh "aws eks --region ${params.EKS_AWS_REGION} update-kubeconfig --name ${env.EKS_CLUSTER_NAME}"

                        def dockerServer = env.DOCKER_SERVER
                        def dockerUsername = env.DOCKER_USERNAME
                        def dockerPassword = env.DOCKER_PASSWORD
                        def dockerEmail = env.DOCKER_EMAIL
                        sh """
                            kubectl create secret docker-registry artifactorycred \
                            --docker-server=${dockerServer} \
                            --docker-username=${dockerUsername} \
                            --docker-password=${dockerPassword} \
                            --docker-email=${dockerEmail}
                        """
                    }
                }

            }
        }
        stage('Deploy artifact') {
            steps {
                script {
                    sh "kubectl create -f 'file://${WORKSPACE}/Infrastructure/devopsdemo-app.yaml'"
                }
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
