pipeline {
  agent {
    docker { 
      image 'ruby:2.5'
      image 'hashicorp/terraform:light'
      args '-i --entrypoint='
    }
  }

  stages {
    stage('Build') {
      steps {
        sh 'ruby -v'
        // bundle any newly added gems
        sh 'bundle install'
      }
    }
    stage('Test') {
      steps {
        sh 'rspec spec/'
      }
    }
    stage('Deploy') {
      steps {
        withAWS(credentials: 'jets_iam', region: 'sa-east-1') {
          sh 'jets movies_api:aws_deploy'
        }
      }
    }
  }
}