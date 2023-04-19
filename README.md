# DevOpsDemo
This repository contains a sample containerized React application.

# Deployment

1. The application uses a specially deployed Jenkins server located at this IP address: `http://3.82.248.215:8080/`. The code for the Jenkins groovy declarative pipeline is in the `Infrastructure` directory.
2. After a git commit is pushed to this repository the pipeline is triggered: `http://3.82.248.215:8080/job/DevOpsDemo/job/master/`. The Jenkins pipeline uses a scheduled cron job as a trigger that polls the source control every 5 minutes.
    - The pipeline installs the react app, runs its unit tests and then builds it.
    - Next, it creates a docker image, scans it and pushes it to the Artifactory Container registry. For the purposes of this demo, I created a trial account in Artifactory and specially created a private container registry which I integrated with the pipeline.
3. Next, the pipeline Creates/Updates the EKS cluster in AWS.
4. Next, the EKS cluster configuration is updated.
5. The application artifact is deployed to the kubernetes cluster.
6. The build info is published.
7. The app can be accessed using the load balancer url here: http://accc39234df6e479f8206f755158e38a-1902106198.us-east-1.elb.amazonaws.com/

## IaC

This CI/CD approach uses the IaC methodology. The infrastructure code is in the `Infrastructure` directory and contains two files:
- `devopsdemo-app.yaml`:  The kubernetes deployment file
- `eks.yaml`: The cloudformation template for the EKS cluster
At root level, the `Jenkinsfile` contains the groovy pipeline code.

## Further improvements

Due to time constraints I designed the CI/CD pipeline as a proof of concept for the task I was given. Given more time I'd improve the following items:
1. Split the pipeline into multiple pipelines:
    - deploy aws resources individually e.g. VPC and EKS
    - build and deploy artifact separately
2. Add a TerraForm cofiguration to stop relying on CloudFormation
3. Package the kubernetes resources using Helm
4. Update the cloudformation stack if there's a change to the infrastructure
5. Avoid code repetition in pipeline
6. Add SSL termination to load balancer
7. Perform build and test operations inside a container