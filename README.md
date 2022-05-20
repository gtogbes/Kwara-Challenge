# Kwara-Challenge
A custom-build terraform module, leveraging terraform-aws-eks to create a managed Kubernetes cluster on AWS EKS. In addition to provisioning simply an EKS cluster, this module alongside additional components to complete an entire end-to-end base stack for a functional kubernetes cluster, including a base set of resources that should be commonly used across all clusters. 

STEPS TO DEPLOYMENT
1 Edit Backend and input your S3 name and region to store the terraform state 

2 Add AWS Secret to Your github secret

3 To reuse the workflow manifest, specify on dispactch or any action that suites your demand to trigger the infra workflow
  the Infra workflow will
     1 Initalize
     2 Plan
     3 Apply 
  your IAC specification. 
  my specification here will build Kubernetes cluster on AWS as well as the underlining resources, such as: VPC, AZs, Node group, IAM, Autoscaling group, IGW etc.
  
 4 run the Terraform Destroy to CLean up the infrastructure created.
 
 
 
 Deploying the Apps
  In the K8 folder, there exist the manifest to Deploy the Hello Backend and sample Nginx frontend.
  also there is manifest to deploy the ELK stack for logging the cluster and its resources.
  TO deploy, 
  run 
  Kubectl apply -f
  
To use the deploy workflow, add your cluster kubeconfig file as secret to your repo, and run the workflow on either Push, merge, or on d
  
  to view the Kibana dashbord
  run
  kubectl port-forward <kibana-pod-name> 5601:5601
  
  Login to the kibana dashboard to view the logs
