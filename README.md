# DevOpsDemo
This repository contains a sample containerized React application.

## Deployment

1. The application uses a Jenkins server, specially deployed for this task, located at this IP address: `http://3.82.248.215:8080/`. The code for the Jenkins groovy declarative pipeline is in the `Infrastructure` directory.
2. After a git commit is pushed to this repository the pipeline is triggered: http://3.82.248.215:8080/job/DevOpsDemo/job/master/ The Jenkins pipeline uses a scheduled cron expression as a trigger that polls the source control every 5 minutes.
    - The pipeline installs the react app, runs its unit tests and then builds it.
    - Next, it creates a docker image, scans it and pushes it to the Artifactory Container registry. For the purposes of this demo, I created a trial account in Artifactory and specially created a private container registry which I integrated with the pipeline.
3. Next, the pipeline Creates/Updates the EKS cluster in AWS.
4. Next, the EKS cluster configuration is updated.
5. The application artifact is deployed to the kubernetes cluster.
6. The build info is published.
7. The app can be accessed using the load balancer dns name: http://a4f33aaa44efe4468b66690fdc98c9f4-173778183.us-east-1.elb.amazonaws.com/

## IaC

This CI/CD approach uses the IaC methodology. The infrastructure code is in the `Infrastructure` directory and contains two files:
- `devopsdemo-app.yaml`:  The kubernetes deployment file
- `eks.yaml`: The cloudformation template for the EKS cluster
At root level, the `Jenkinsfile` contains the groovy pipeline code.

## Further improvements

Due to time constraints I designed the CI/CD pipeline as a proof of concept for the task I was given. Given more time I'd improve the following items:
1. Split the pipeline into multiple pipelines:
    - deploy aws resources in individual pipelines e.g. VPC and EKS
    - build and deploy artifact in a separate pipeline
2. Add a TerraForm cofiguration to stop relying on CloudFormation
3. Package the kubernetes resources using Helm
4. Update the cloudformation stack when there's a change to the yaml template
5. Improve code quality of the pipeline e.g. avoid code repetition, refactor longer methods
6. Break down pipeline into more granular steps
7. Add SSL termination to load balancer
8. Perform build and test operations inside a container
9. Test the pipeline more thoroughly
