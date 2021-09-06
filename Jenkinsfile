pipeline {
    agent any
    environment {
        ENV_SELENIUM_BROWSER = 'chrome'
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
}
