pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        // bundle any newly added gems
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