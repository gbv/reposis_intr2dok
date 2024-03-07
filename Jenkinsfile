pipeline {
    agent any

    environment {
        SELENIUM_BROWSER = 'chrome'
    }

    stages {
        stage('Build and Test only') {
            when {
               not {
                   anyOf {
                        branch 'master'
                        branch 'main'
                        branch '2021.06'
                   }
               }
            }
            steps {
                withMaven (maven: 'mvn', jdk: 'OJDK11') {
                    sh 'mvn -U clean verify'
                }
            }
        }

        stage('Build, Test and Deploy') {
            when {
               anyOf {
                    branch 'master'
                    branch 'main'
                    branch '2021.06'
               }
            }
            steps {
                    withMaven (maven: 'mvn', jdk: 'OJDK11', mavenSettingsConfig: 'maven-deploy-settings') {
                        withCredentials([
                        usernamePassword(credentialsId: 'ossrhs01', passwordVariable: 'PASSWORD_VAR', usernameVariable: 'USERNAME_VAR')                        ])
                        {
                            sh 'mvn -U clean deploy -Dossrhs01.username=${USERNAME_VAR} -Dossrhs01.password=${PASSWORD_VAR}'
                        }
                    }
            }
        }
    }

}
