pipeline {
    agent any

    environment {
        ECR_REPO = '396044748166.dkr.ecr.us-east-1.amazonaws.com/eks-deployment-hello-world'
        IMAGE_TAG = "latest"
        CLUSTER_NAME = "eks-deployment-cluster"
        AWS_REGION = "us-east-1"
        DOCKER_IMAGE = "helloworld-app:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {
            steps {
                // Checkout your GitHub repo
                git branch: 'main', url: 'https://github.com/fndongn/eks-ci-cd-app-deployment.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image from root or app folder
                sh """
                docker build -t ${DOCKER_IMAGE} .
                """
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${ECR_REPO}
                """
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh """
                docker tag ${DOCKER_IMAGE} ${ECR_REPO}:${IMAGE_TAG}
                docker push ${ECR_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                # Temporary kubeconfig to avoid permission issues
                export KUBECONFIG=/tmp/kubeconfig

                # Update kubeconfig for your cluster
                aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME} --kubeconfig $KUBECONFIG

                # Update deployment image
                kubectl set image deployment/helloworld-app helloworld-app=${ECR_REPO}:${IMAGE_TAG} --kubeconfig $KUBECONFIG

                # Wait for rollout to finish
                kubectl rollout status deployment/helloworld-app --kubeconfig $KUBECONFIG
                """
            }
        }

    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}
