pipeline {
  agent {
    docker { image 'ruby:2.5' }
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
        echo 'Deploying....'
      }
    }
  }
}