pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:light'
            args '--entrypoint="" -u root'
        } 
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
    }
    parameters {
        choice(
            choices: ['preview', 'apply', 'show', 'preview-destroy', 'destroy'],
            description: 'Terraform action to apply',
            name: 'action')
    }
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