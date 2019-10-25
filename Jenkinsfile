pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:light'
            args '--entrypoint="" -u root'
        } 
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('DEV_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('DEV_AWS_SECRET_ACCESS_KEY')
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
                echo "AWS_ACCESS_KEY_ID is ${AWS_ACCESS_KEY_ID}"
                sh 'terraform init'
            }
        }
        stage('validate') {
            when {
                expression { params.action == 'preview' || params.action == 'apply' || params.action == 'destroy' }
            }
            steps {
                sh 'terraform validate'
            }
        }
    }
}