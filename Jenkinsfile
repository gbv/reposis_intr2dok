pipeline {
    agent any

    environment {
        SELENIUM_BROWSER = 'chrome'
    }

    stages {
        stage('Build') {
            steps {
                    withMaven (maven: 'mvn', jdk: 'OJDK11', mavenLocalRepo: '.repository') {
                      sh "mvn clean verify"
                    }
            }
        }

        stage('Clean') {
            steps {
                cleanWs()
            }
        }
    }

    post {
      success {
          setBuildStatus("Build succeeded", "SUCCESS");
      }
      failure {
          setBuildStatus("Build failed", "FAILURE");
      }
    }
}
