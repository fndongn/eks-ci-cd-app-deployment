pipeline {
    agent any

    environment {
        AWS_REGION   = "us-east-1"
        CLUSTER_NAME = "eks-deployment-cluster"
        ECR_REPO     = "396044748166.dkr.ecr.us-east-1.amazonaws.com/eks-deployment-hello-world"
        IMAGE_TAG    = "latest"
        DOCKER_IMAGE = "helloworld-app:${IMAGE_TAG}"
        KUBECONFIG   = "/root/.kube/config"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/fndongn/eks-ci-cd-app-deployment.git',
                    credentialsId: 'github-PAT'
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ECR_REPO}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker tag ${DOCKER_IMAGE} ${ECR_REPO}:${IMAGE_TAG}
                docker push ${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Configure kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig \
                  --region ${AWS_REGION} \
                  --name ${CLUSTER_NAME}
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                # Apply manifests (safe to run multiple times)
                kubectl apply -f k8s/

                # Update image
                kubectl set image deployment/helloworld-app \
                  helloworld-app=${ECR_REPO}:${IMAGE_TAG}

                # Wait for rollout
                kubectl rollout status deployment/helloworld-app
                '''
            }
        }
    }

    post {
        success {
            echo " Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
