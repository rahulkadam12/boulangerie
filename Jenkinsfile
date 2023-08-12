pipeline {
    agent any

    parameters {
    choice(name: 'CLOUD_PROVIDER', choices: ['AWS', 'Azure'], description: 'Select the cloud provider')
    string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region where the AMI will be created')
    string(name: 'AWS_ACCESS_KEY_ID', defaultValue: '', description: 'AWS Access Key ID')
    string(name: 'AWS_SECRET_ACCESS_KEY', defaultValue: '', description: 'AWS Secret Access Key')
    }
    environment {
        AWS_DEFAULT_REGION = params.AWS_REGION
        AWS_ACCESS_KEY_ID = params.AWS_ACCESS_KEY_ID
        AWS_SECRET_ACCESS_KEY = params.AWS_SECRET_ACCESS_KEY
        PACKER_VERSION = '1.7.4'
        AWS_CLI_VERSION = '2.3.4'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    // Install Packer
                    sh "wget https://releases.hashicorp.com/packer/${env.PACKER_VERSION}/packer_${env.PACKER_VERSION}_linux_amd64.zip"
                    sh "unzip packer_${env.PACKER_VERSION}_linux_amd64.zip"
                    sh "mv packer /usr/local/bin/"
                    sh "rm packer_${env.PACKER_VERSION}_linux_amd64.zip"
                    
                    // Install AWS CLI v2
                    sh "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${env.AWS_CLI_VERSION}.zip' -o 'awscliv2.zip'"
                    sh "unzip awscliv2.zip"
                    sh "./aws/install"
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
                    def packerCmd = "packer build -var 'aws_access_key=${params.AWS_ACCESS_KEY}' -var 'aws_secret_key=${params.AWS_SECRET_KEY}' images/cloud/aws/rhel8-base/packer.pkr.hcl"
                    def amiId = sh(script: packerCmd + " | tee /dev/tty | grep 'amazon-ebs: AMI:' | awk '{print $5}'", returnStdout: true).trim()
                    echo "AMI ID: $amiId"
                }
            }
        }
}
