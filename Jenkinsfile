pipeline {
    agent any

    environment {
        SELENIUM_BROWSER = 'chrome'
    }

    stages {
        stage('Build') {
            steps {
                    withMaven (maven: 'mvn', jdk: 'OJDK11', mavenLocalRepo: '~/.m2/repository') {
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
