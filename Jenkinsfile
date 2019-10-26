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
            choices: ['plan', 'apply', 'show', 'preview-destroy', 'destroy'],
            description: 'Terraform action to apply',
            name: 'action')
        choice(
            choices: ['dev', 'test', 'prod'],
            description: 'deployment environment',
            name: 'ENVIRONMENT')
        string(defaultValue: "us-east-1", description: 'aws region', name: 'AWS_REGION')
        string(defaultValue: "fcz", description: 'application system identifier', name: 'ASI')
    }
    stages {
        stage('init') {
            steps {
                withCredentials([string(credentialsId: 'DEV_AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'DEV_AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                sh 'terraform init -backend-config="bucket=${ASI}-${ENVIRONMENT}-tfstate" -backend-config="key=${ASI}-${ENVIRONMENT}/terraform.tfstate" -backend-config="${AWS_REGION}"'
                }
            }
        }
        stage('validate') {
            when {
                expression { params.action == 'plan' || params.action == 'apply' || params.action == 'destroy' }
            }
            steps {
                sh 'terraform validate'
            }
        }
        stage('plan') {
            when {
                expression { params.action == 'plan' }
            }
            steps {
                sh "terraform plan -input=false -var 'aws_region=${AWS_REGION}' --var-file=environments/${ENVIRONMENT}.vars"
            }
        }
    }
}