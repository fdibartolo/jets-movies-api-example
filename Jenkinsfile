pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile.agent'
      dir 'ci'
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
          sh 'terraform -v'
          sh 'jets movies_api:aws_deploy'
        }
      }
    }
  }
}