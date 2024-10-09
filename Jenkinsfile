pipeline{
agent any

environment{
    DOCKER_IMAGE = 'benakepj/ultimate-cicd:${BUILD_NUMBER}'
}

stages{

stage('checkout'){
    steps{
        git url = 'https://github.com/SonaliPjb/devops.git',
        branch = 'main'
        echo 'checkout is completed'    
    }

}

stage('build and test'){
    steps{
        sh 'devops && npm install && npm run build'
    }

}

stage('sonarQube'){
    environment{}
    steps{
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')])
        {
        sh '''
            cd devops
            sonar-scanner -Dsonar.projectKey=vite-project:0.0.0 \  # Define your project key
                  -Dsonar.sources=. \                     # Analyze the current directory
                  -Dsonar.host.url=${SONAR_URL} \        # Set the SonarQube server URL
                  -Dsonar.login=$SONAR_AUTH_TOKEN         # Use the auth token
            '''
        }
        }
}

stage('docker build and push'){
    steps{
        script {
                sh 'docker build -t ${DOCKER_IMAGE} .'
                echo 'docker build done'
                // Log in to your Docker registry if needed
                   sh 'docker login -u benakepj -p Benakepj@123'
                //sh 'docker tag $benakepj/fe_new_img <YOUR_DOCKER_REGISTRY>/$DOCKER_IMAGE'
                 sh 'docker push ${DOCKER_IMAGE}'
              }
    }

}

stage('deploy to k8s'){
    environment{
        GIT_REPO_NAME = 'devops'
        GIT_USER_NAME = 'SonaliPjb'
    }

    steps{
        withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]){
        
        sh '''
        BUILD_NUMBER = ${BUILD_NUMBER}
        sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" devops/k8s/deployment.yml
        git add jdevops/k8s/deployment.yml
        git commit -m "Update deployment image to version ${BUILD_NUMBER}"
        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main

        '''
        }
    }

}

}
}