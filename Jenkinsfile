pipeline {
    agent any

    environment {
        AWS_REGION   = "us-east-1"
        CLUSTER_NAME = "eks-deployment-cluster"
        ECR_REPO     = "396044748166.dkr.ecr.us-east-1.amazonaws.com/eks-deployment-hello-world"
        IMAGE_TAG    = "${env.GIT_COMMIT.take(7)}"
        DOCKER_IMAGE = "helloworld-app:${IMAGE_TAG}"
        KUBECONFIG   = "/tmp/kubeconfig"
    }

    stages {

        // No checkout stage needed: Jenkins handles SCM checkout automatically
        // when using "Pipeline script from SCM"

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh """
                    docker build -t ${DOCKER_IMAGE} .
                    """
                }
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ECR_REPO}
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

        stage('Configure kubeconfig') {
            steps {
                sh """
                aws eks update-kubeconfig \
                    --region ${AWS_REGION} \
                    --name ${CLUSTER_NAME} \
                    --kubeconfig ${KUBECONFIG}
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                # Apply manifests
                kubectl apply -f k8s/ --kubeconfig ${KUBECONFIG}

                # Update deployment image
                kubectl set image deployment/helloworld-app \
                    helloworld-app=${ECR_REPO}:${IMAGE_TAG} \
                    --kubeconfig ${KUBECONFIG}

                # Wait for rollout to complete
                kubectl rollout status deployment/helloworld-app \
                    --kubeconfig ${KUBECONFIG}
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
