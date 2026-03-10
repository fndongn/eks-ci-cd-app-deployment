# 1. Project Overview
Automated deployment pipeline for containerized web applications to AWS EKS using Jenkins. Infrastructure is       provisioned with Terraform, following modern DevOps practices including infrastructure as code, containerization, and   continuous deployment.

# 2. Architecture Diagram
<img width="3151" height="1932" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/45bcd60f-bdb5-4358-a8dd-6db5c941c2ee" />

# 3. What It Does
Application: Simple Flask app displaying "Hello, World!"

Infrastructure:

  - EKS cluster with 4 auto-scaling nodes (1-4 nodes)
  - Application Load Balancer for traffic distribution
  - Horizontal Pod Autoscaler (1-3 pods per node, 50% CPU/memory triggers)

Automation: Code pushed to GitHub triggers Jenkins to build Docker images, push to ECR, and deploy to EKS with zero downtime.

# 4. How It Works
  - Provisioning: Terraform creates VPC, EKS cluster, nodes, security groups, IAM roles, and ECR repository.
  - Containerization: Flask app packaged in Docker for portability and consistency.
  - Orchestration: Kubernetes manages containers across nodes with automatic failure recovery.
  - Scaling: Nodes scale based on resource demand; pods scale when CPU or memory exceeds 50%.
  - Load Balancing: ALB distributes traffic across application pods.

# 5. CI/CD Workflow (Jenkins)
  - Checkout → Pull latest code from GitHub
  - Build → Create Docker image tagged with Git commit hash
  - Login to ECR → Authenticate with AWS container registry
  - Push to ECR → Upload and version Docker image
  - Configure kubectl → Connect to EKS cluster
  - Deploy to EKS → Rolling update with new image
  - Pipeline triggers automatically on push to main branch.
    
# 6. Tech stacks

  - AWS EKS - Managed Kubernetes service
  - Terraform - Infrastructure as Code
  - Docker - Application containerization
  - Jenkins - CI/CD automation
  - Kubernetes - Container orchestration
  - Amazon ECR - Container registry
  - Flask - Python web framework
  - ALB - Application Load Balancer
  - HPA - Horizontal Pod Autoscaler

# 7. Problem It Solves
  - Manual Deployment - Automates build and deployment, reducing errors and time
  - Scalability - Handles traffic spikes automatically without over-provisioning
  - Inconsistency - Ensures identical environments across development and production
  - Downtime - Rolling updates maintain availability during deployments
  - Resource Waste - Scales down during low traffic to reduce costs
  - Slow Releases - Reduces deployment from hours to minutes
  - Traceability - Git commit-based versioning enables easy rollbacks



