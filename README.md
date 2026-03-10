# 1. Project Overview
This project demonstrates an automated CI/CD pipeline for deploying containerized web applications to Amazon EKS.
Infrastructure is provisioned using Terraform, while Jenkins automates the build and deployment process, following modern DevOps best practices. 
The pipeline enables fully automated, scalable, and zero-downtime deployments of a Dockerized Flask application to Kubernetes.

# 2. Architecture Diagram
<img width="3151" height="1932" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/45bcd60f-bdb5-4358-a8dd-6db5c941c2ee" />

# 3. What It Does
This project demonstrates an automated CI/CD pipeline that deploys a containerized web application to Amazon EKS with built-in scalability and zero-downtime updates.

Infrastructure
* Amazon EKS Cluster
  - Hosts the Kubernetes environment where the application runs.
* Auto-Scaling Node Group
  - Worker nodes automatically scale between 1–4 EC2 instances based on workload demand.
* Application Load Balancer (ALB)
  - Routes external traffic and distributes requests across running application pods.
* Horizontal Pod Autoscaler (HPA)
  - Automatically scales the application pods between 1–3 per node when CPU or memory usage exceeds 50%.

Automation
When code is pushed to GitHub, the Jenkins CI/CD pipeline automatically:
* Builds a Docker image of the application
* Pushes the image to Amazon ECR
* Deploys the new version to Amazon EKS
The deployment uses Kubernetes rolling updates, ensuring the application remains available during releases with zero downtime.

# 4. How It Works
  Infrastructure Provisioning
  Terraform provisions the complete AWS environment, including:
  * VPC and networking
  * EKS cluster
  * Worker nodes
  * Security groups
  * IAM roles
  * Amazon ECR repository

  Containerization
  * The Flask application is packaged into a Docker container, ensuring consistent environments across development and production.

  Orchestration
  * Kubernetes (EKS) manages container scheduling, scaling, and self-healing across worker nodes.

  Auto Scaling
  * Node scaling: 1–4 EC2 nodes based on resource demand
  * Pod scaling: HPA increases pods when CPU or memory exceeds 50%

  Load Balancing
  An Application Load Balancer (ALB) routes external traffic to the running application pods.

# 5. CI/CD Workflow (Jenkins)
  The Jenkins pipeline automates the entire deployment lifecycle:
  * Checkout → Pull latest code from GitHub
  * Build → Create Docker image tagged with the Git commit hash
  * Authenticate → Login to Amazon ECR
  * Push Image → Upload versioned Docker image to ECR
  * Cluster Access → Configure kubectl to connect to EKS
  * Deploy → Perform rolling update to Kubernetes deployment
  Pipeline triggers automatically on push to main branch.
    
# 6. Tech stacks

  * AWS EKS - Managed Kubernetes service
  * Terraform - Infrastructure as Code
  * Docker - Application containerization
  * Jenkins - CI/CD automation
  * Kubernetes - Container orchestration
  * Amazon ECR - Container registry
  * Flask - Python web framework
  * ALB - Application Load Balancer
  * HPA - Horizontal Pod Autoscaler

# 7. Problem It Solves
  * Manual Deployment - Automates build and deployment, reducing errors and time
  * Scalability - Handles traffic spikes automatically without over-provisioning
  * Inconsistency - Ensures identical environments across development and production
  * Downtime - Rolling updates maintain availability during deployments
  * Resource Waste - Scales down during low traffic to reduce costs
  * Slow Releases - Reduces deployment from hours to minutes
  * Traceability - Git commit-based versioning enables easy rollbacks

# 8. Challenges and Lessons Learn
  Challenges
  * Configuring Jenkins to interact with AWS services securely
  * Setting up IAM roles and permissions for EKS, ECR, and Jenkins
  * Ensuring proper communication between Jenkins and the EKS cluster
  * Managing Kubernetes deployments and rolling updates without downtime
  * Integrating Terraform provisioning with the CI/CD workflow

  Lessons Learned
  * Infrastructure as Code simplifies reproducible cloud environments
  * Automated CI/CD pipelines significantly reduce deployment complexity
  * Containerization ensures consistent application behavior across environments
  * Kubernetes auto-scaling improves performance and cost efficiency
  * Tagging images with Git commits improves traceability and rollback capability

