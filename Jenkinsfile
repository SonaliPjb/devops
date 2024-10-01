pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'benakepj/fe_new_img'
        K8S_NAMESPACE = 'default' // Change this if necessary
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/SonaliPjb/devops.git',
                branch: 'main'
                echo 'checkout done'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                    echo 'build done'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to your Docker registry if needed
                    sh 'docker login -u benakepj -p Benakepj@123'
                    //sh 'docker tag $benakepj/fe_new_img <YOUR_DOCKER_REGISTRY>/$DOCKER_IMAGE'
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                }
            }
        }
    }
}
