pipeline {
  agent {
    docker { image 'ruby:2.5-alpine' }
  }

  stages {
    stage('Build') {
      steps {
        // bundle any newly added gems
        sh 'ruby -v'
        sh 'gem list'
        sh 'bundle install'
      }
    }
    stage('Test') {
      steps {
        echo 'Testing..'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying....'
      }
    }
  }
}