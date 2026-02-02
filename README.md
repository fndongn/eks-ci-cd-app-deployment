EKS CI/CD Application Deployment
# 1. Project Overview
  This project automates the deployment of a containerized web application to Amazon EKS (Elastic Kubernetes Service) using a Jenkins CI/CD pipeline. It demonstrates how to build, test, and deploy applications automatically to a scalable cloud infrastructure whenever code changes are pushed to GitHub.
  The entire infrastructure is provisioned using Terraform, ensuring that all AWS resources are created consistently and can be easily replicated or destroyed. The solution follows modern DevOps practices with infrastructure as code, containerization, and continuous deployment.
# 2. What It Does
  Application: A simple Flask web application that displays "Hello, World!" to users.
  Infrastructure: Creates and manages a complete AWS EKS cluster with:

  4 worker nodes (t3.small instances) that auto-scale from 1 to 4 based on demand
  An Application Load Balancer that distributes incoming traffic
  Horizontal Pod Autoscaler that creates 1-3 application pods per node based on CPU and memory usage

  Automation: Every time you push code to GitHub, Jenkins automatically:

  Builds a new Docker image of your application
  Pushes the image to Amazon ECR (container registry)
  Deploys the updated application to the EKS cluster
  Ensures zero downtime during updates

# 3. How It Works
  Infrastructure Provisioning: Terraform creates all necessary AWS resources including the VPC, EKS cluster, worker nodes, security groups, IAM roles, and ECR repository.
  Containerization: The Flask application is packaged into a Docker container, making it portable and consistent across all environments.
  Orchestration: Kubernetes manages the application containers across multiple nodes, ensuring high availability and automatic recovery from failures.
  Auto-Scaling:

  Node-level scaling adds or removes EC2 instances based on resource demands
  Pod-level scaling increases or decreases application replicas when CPU or memory exceeds 50% utilization

  Load Balancing: An AWS Application Load Balancer distributes user traffic evenly across all running application pods.
  
# 4. CI/CD Workflow (Jenkins)
  The Jenkins pipeline automates the entire deployment process through these stages:
  Stage 1 - Checkout: Jenkins pulls the latest code from the GitHub repository to ensure it's working with the most recent version.
  
  Stage 2 - Build: A Docker image is created from the application code and tagged with the Git commit hash for version tracking.
  
  Stage 3 - Login to ECR: Jenkins authenticates with Amazon's container registry using AWS credentials.
  
  Stage 4 - Push to ECR: The newly built Docker image is uploaded to ECR where it's stored and versioned.
  
  Stage 5 - Configure kubectl: Jenkins configures access to the EKS cluster so it can manage Kubernetes resources.
  
  Stage 6 - Deploy to EKS: The application deployment is updated with the new Docker image, and Kubernetes performs a rolling update to avoid downtime.
  Trigger: The pipeline runs automatically whenever code is pushed to the main branch, eliminating manual deployment steps.

# 5. Key Technologies
  AWS EKS - Managed Kubernetes service that handles cluster operations and scaling
  
  Terraform - Infrastructure as Code tool that provisions all AWS resources consistently
  
  Docker - Containerization platform that packages the application with all its dependencies
  
  Jenkins - Automation server that orchestrates the CI/CD pipeline
  
  Kubernetes - Container orchestration system that manages application deployment and scaling
  
  Amazon ECR - Container registry for storing and versioning Docker images
  
  Flask - Lightweight Python web framework for the application
  
  Application Load Balancer - Distributes traffic and provides high availability
  
  Horizontal Pod Autoscaler - Automatically scales pods based on resource utilization
  
# 6. Problem It Solves
  Manual Deployment Burden: Eliminates the need for developers to manually build, test, and deploy applications, reducing human error and saving time.
  
  Scalability Challenges: Automatically handles traffic spikes by scaling resources up or down, ensuring the application remains responsive without over-provisioning.
  I
  nfrastructure Inconsistency: Uses Infrastructure as Code to ensure development, staging, and production environments are identical, preventing "works on my machine" issues.
  
  Downtime During Updates: Implements rolling updates so new versions deploy without taking the application offline, maintaining continuous availability.
  
  Resource Waste: Auto-scaling prevents paying for unused infrastructure by scaling down during low-traffic periods and scaling up only when needed.
  
  Slow Release Cycles: Reduces deployment time from hours to minutes, enabling faster feature delivery and bug fixes.
  
  Lack of Traceability: Every deployment is tied to a specific Git commit, making it easy to track what code is running in production and rollback if nee
