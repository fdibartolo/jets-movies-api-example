pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile.agent'
      dir 'ci'
      args '-v volumes/bundle:/usr/local/bundle -v volumnes/ruby:/root/.gem/ruby -v volumes/gems:/usr/local/lib/ruby/gems'
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