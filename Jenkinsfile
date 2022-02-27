/* import shared library */
@Library('chocoapp-slack-share-library')_

pipeline {
    environment {
        IMAGE_NAME = "staticwebsite"
        APP_CONTAINER_PORT = "5000"
        APP_EXPOSED_PORT = "80"
        IMAGE_TAG = "latest"
        STAGING = "henrypoms-staging"
        PRODUCTION = "henrypoms-prod"
        DOCKERHUB_ID = "henrypoms"
        DOCKERHUB_PASSWORD = credentials('dockerhub_password')
     }

    agent none
    stages {
       stage('Build image') {
           agent any
           steps {
              script {
                sh 'docker build -t henrypoms/$IMAGE_NAME:$IMAGE_TAG .'
              }
           }
       }
       stage('Run container based on builded image') {
          agent any
          steps {
            script {
              sh '''
                  docker run --name $IMAGE_NAME -d -p 80:5000 -e PORT=5000 henrypoms/$IMAGE_NAME:$IMAGE_TAG
                  sleep 5
              '''
             }
          }
       }
       stage('Test image') {
           agent any
           steps {
              script {
                sh '''
                   curl localhost | echo "Hello world!"
                '''
              }
           }
       }
       stage('Clean container') {
          agent any
          steps {
             script {
               sh '''
                   docker stop $IMAGE_NAME
                   docker rm $IMAGE_NAME
               '''
             }
          }
      }
      stage('Push image in staging and deploy it') {
        when {
            expression { GIT_BRANCH == 'origin/main' }
        }
        agent any
        environment {
            HEROKU_API_KEY = credentials('heroku_api_key')
        }
        steps {
           script {
             sh '''
                heroku container:login
                heroku create $STAGING || echo "projets already exist"
                heroku container:push -a $STAGING web
                heroku container:release -a $STAGING web
             '''
           }
        }
     }
     stage('Push image in production and deploy it') {
       when {
           expression { GIT_BRANCH == 'origin/main' }
       }
       agent any
       environment {
           HEROKU_API_KEY = credentials('heroku_api_key')
       }
       steps {
          script {
            sh '''
               heroku container:login
               heroku create $PRODUCTION || echo "projets already exist"
               heroku container:push -a $PRODUCTION web
               heroku container:release -a $PRODUCTION web
            '''
          }
       }
     }
  }
  post {
     always {
       script {
         slackNotifier currentBuild.result
     }
    }
  }
}
