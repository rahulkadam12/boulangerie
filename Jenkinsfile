pipeline {
    agent {
        label 'jenkins-slave'
    }

    parameters {
        choice(name: 'CLOUD_PROVIDER', choices: ['AWS', 'Azure'], description: 'Select the cloud provider')
        string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region where the AMI will be created')
    }
    environment {
        AWS_DEFAULT_REGION = 'params.AWS_REGION'
        AWS_CREDENTIALS = credentials('AWS_ACCESS')
        PACKER_VERSION = '1.7.4'
        AWS_CLI_VERSION = '2.3.4'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    // Install Packer
                    sh "curl -o packer.zip https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip"
                    sh "unzip -o packer.zip"
                    sh "sudo mv packer /usr/local/bin/"
                    sh "rm packer.zip"
                    sh "packer --version"
                    
                    // Install AWS CLI v2
                    sh "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${env.AWS_CLI_VERSION}.zip' -o 'awscliv2.zip'"
                    sh "unzip -o awscliv2.zip"
                    sh "sudo ./aws/install --update"
                    sh "rm -rf aws awscliv2.zip"
                }
            }
        }
        
        stage('Packer Init') {
            steps {
                script {
                    sh 'packer init config.pkr.hcl'
                }
            }
        }

        stage('Build AMI') {
            steps {
                script {
                    def packerTemplate = 'images/cloud/aws/rhel8-base/provisioning/packer.pkr.hcl'

                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'your-aws-credentials-id',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh "packer build -var 'aws_access_key=${AWS_ACCESS_KEY_ID}' -var 'aws_secret_key=${AWS_SECRET_ACCESS_KEY}' ${packerTemplate}"
                    }
                }
            }
        } 
    }
}
