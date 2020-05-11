pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile.agent'
      dir 'ci'
    }
  }

  environment {
    JETS_AGREE = 'yes'
    FORCE_DESTROY = 'true'
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
    stage('Destroy') {
      steps {
        withAWS(credentials: 'jets_iam_user', region: 'sa-east-1') {
          input message: 'Finished using the site? (click "Proceed" to destroy infra resources)'
          sh 'jets movies_api:aws_destroy'
        }
      }
    }
  }
}