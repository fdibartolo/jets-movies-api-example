pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile.agent'
      dir 'ci'
    }
  }

  environment {
    JETS_AGREE = 'yes'
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
          sh 'terraform init -input=false ./infra'
          sh 'jets movies_api:aws_deploy'
        }
      }
    }
  }
}