pipeline {
    agent { docker { image 'hashicorp/terraform:light'} }
    stages {
        stage('init') {
            steps {
                sh 'terraform version'
                sh 'echo $AWS_ACCESS_KEY_ID'
                sh 'terraform init'
            }
        }
    }
}