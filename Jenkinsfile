pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile.agent'
      dir 'ci'
      args '-v /volumes:/var/jenkins_home'
    }
  }

  environment {
    JETS_AGREE = 'yes'
  }

  stages {
    stage('Build') {
      steps {
        sh 'ruby -v'
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
        withAWS(credentials: 'jets_iam_user', region: 'sa-east-1') {
          sh 'terraform -v'
          sh 'jets movies_api:deploy_init'
          sh 'jets movies_api:aws_deploy'
        }
      }
    }
  }
}