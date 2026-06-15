pipeline {
agent any

```
environment {
    DOCKER_IMAGE = "chiragvaze/campusfit-app"
    DOCKER_CREDENTIALS_ID = "dockerhub-credentials"
}

stages {

    stage('Checkout') {
        steps {
            checkout scm
        }
    }

    stage('Build Image') {
        steps {
            script {
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
            }
        }
    }

    stage('Push Image') {
        steps {
            script {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDENTIALS_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
    }

    stage('Deploy to Kubernetes') {
        steps {
            sh '''
            kubectl set image deployment/campusfit-app \
            campusfit-app=${DOCKER_IMAGE}:${BUILD_NUMBER}

            kubectl rollout status deployment/campusfit-app
            '''
        }
    }

    stage('Verify Deployment') {
        steps {
            sh '''
            kubectl get pods
            kubectl get deployments
            '''
        }
    }
}

post {
    success {
        echo 'Deployment Successful'
    }

    failure {
        echo 'Deployment Failed'
    }
}
```

}

