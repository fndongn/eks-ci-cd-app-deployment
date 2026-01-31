pipeline {
    agent any

    environment {
        ECR_REPO = '396044748166.dkr.ecr.us-east-1.amazonaws.com/eks-deployment-hello-world'
        IMAGE_TAG = "latest"
        CLUSTER_NAME = "eks-deployment-cluster"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your GitHub repo using your credentials
                git branch: 'main', url: 'https://github.com/fndongn/eks-ci-cd-app-deployment.git', credentialsId: 'github-PAT'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Move into the app folder where Dockerfile exists
                dir('app') {
                    sh 'docker build -t helloworld-app:${IMAGE_TAG} .'
                }
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 | \
                docker login --username AWS --password-stdin ${ECR_REPO}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker tag helloworld-app:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
                docker push ${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                # Use a temporary kubeconfig to avoid permission issues
                export KUBECONFIG=/tmp/kubeconfig

                # Update kubeconfig for your cluster
                aws eks update-kubeconfig --region us-east-1 --name ${CLUSTER_NAME} --kubeconfig $KUBECONFIG

                # Update the deployment image
                kubectl set image deployment/helloworld-app helloworld-app=${ECR_REPO}:${IMAGE_TAG} --kubeconfig $KUBECONFIG

                # Wait for rollout to finish
                kubectl rollout status deployment/helloworld-app --kubeconfig $KUBECONFIG
                '''
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
