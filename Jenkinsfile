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
            choices: ['apply', 'destroy'],
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
                    sh 'terraform init -no-color -backend-config="bucket=${ASI}-${ENVIRONMENT}-tfstate" -backend-config="key=${ASI}-${GIT_LOCAL_BRANCH}/terraform.tfstate" -backend-config="region=${AWS_REGION}"'
                }
            }
        }
        stage('validate') {
            steps {
                sh 'terraform validate -no-color'
            }
        }
        stage('plan') {
            when {
                expression { params.action == 'apply' }
            }
            steps {
                sh 'terraform plan -no-color -input=false -out=tfplan -var "aws_region=${AWS_REGION}" --var-file=environments/${GIT_LOCAL_BRANCH}.vars'
            }
        }
        stage('approval') {
            when {
                allOf {
                    branch 'master'
                    expression { params.action == 'apply'}
                }
            }
            steps {
                sh 'terraform show -no-color tfplan > tfplan.txt'
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
                withAWS(region: "${AWS_REGION}", credentials: 'dev_environment') {
                    s3Upload(file: 'tfplan.txt', bucket: "${ASI}-${ENVIRONMENT}-${AWS_REGION}-tfbuilds", path: "Jenkins/builds/${GIT_LOCAL_BRANCH}/${BUILD_TAG}-tfplan.txt")
                }
            }
        }
        stage('apply') {
            when {
                expression { params.action == 'apply' }
            }
            steps {
                sh 'terraform apply -no-color -input=false tfplan'
            }
        }
        stage('test') {
            when {
                expression { params.action == 'apply' }
            }
            steps {
                sh 'terraform output'
                sh './tests/snsTest.sh'
            }
        }
        stage('destroy - development') {
            when {
                allOf {
                    branch 'development'
                }
            }
            steps {
                sh 'terraform plan -no-color -destroy -out=tfplan -var "aws_region=${AWS_REGION}" --var-file=environments/${GIT_LOCAL_BRANCH}.vars'
                sh 'terraform show -no-color tfplan > tfplan.txt'
                sh 'terraform destroy -no-color -force -var "aws_region=${AWS_REGION}" --var-file=environments/${GIT_LOCAL_BRANCH}.vars'
                withAWS(region: "${AWS_REGION}", credentials: 'dev_environment') {
                    s3Upload(file: 'tfplan.txt', bucket: "${ASI}-${ENVIRONMENT}-${AWS_REGION}-tfbuilds", path: "Jenkins/builds/${GIT_LOCAL_BRANCH}/${BUILD_TAG}-tfplan.txt")
                }
            }
        }
        stage('destroy - production') {
            when {
                allOf {
                    branch 'master'
                    expression { params.action == 'destroy' }
                }
            }
            steps {
                sh 'terraform plan -no-color -destroy -out=tfplan -var "aws_region=${AWS_REGION}" --var-file=environments/${GIT_LOCAL_BRANCH}.vars'
                sh 'terraform show -no-color tfplan > tfplan.txt'
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Delete the stack?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
                sh 'terraform destroy -no-color -force -var "aws_region=${AWS_REGION}" --var-file=environments/${GIT_LOCAL_BRANCH}.vars'
                withAWS(region: "${AWS_REGION}", credentials: 'dev_environment') {
                    s3Upload(file: 'tfplan.txt', bucket: "${ASI}-${ENVIRONMENT}-${AWS_REGION}-tfbuilds", path: "Jenkins/builds/${GIT_LOCAL_BRANCH}/${BUILD_TAG}-tfplan.txt")
                }
            }
        }
    }
}