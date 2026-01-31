pipeline {
    agent any

    environment {
        AWS_REGION     = "us-east-1"
        AWS_ACCOUNT_ID = "396044748166"
        ECR_REPO       = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eks-deployment-hello-world"
        CLUSTER_NAME   = "eks-deployment-cluster"
        IMAGE_TAG      = "latest"
    }

    stages {

        stage('Build Docker Image') {
  steps {
    sh '''
      cd app
      docker build -t helloworld-app:${IMAGE_TAG} .
    '''
  }
}


        stage('Login to Amazon ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 \
                | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
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
              
  aws eks update-kubeconfig --region us-east-1 --name ${CLUSTER_NAME}
                kubectl set image deployment/helloworld-app \
                  helloworld-app=${ECR_REPO}:${IMAGE_TAG}
                kubectl rollout status deployment/helloworld-app
                '''
            }
        }
    }
}
