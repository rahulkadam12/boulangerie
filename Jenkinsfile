pipeline {
    agent {
        label 'jenkins-slave'
    }

    parameters {
        choice(name: 'CLOUD_PROVIDER', choices: ['AWS', 'Azure'], description: 'Select the cloud provider')
        string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region where the AMI will be created')
        string(name: 'AWS_ACCESS_KEY_ID', defaultValue: '', description: 'AWS Access Key ID')
        string(name: 'AWS_SECRET_ACCESS_KEY', defaultValue: '', description: 'AWS Secret Access Key')
    }
    environment {
        AWS_DEFAULT_REGION = 'params.AWS_REGION'
        AWS_ACCESS_KEY_ID = 'params.AWS_ACCESS_KEY_ID'
        AWS_SECRET_ACCESS_KEY = 'params.AWS_SECRET_ACCESS_KEY'
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
                    sh "packer build images/cloud/aws/rhel8-base/provisioning/packer.pkr.hcl"
                }
            }
        } 
    }
}
