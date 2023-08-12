parameters {
    choice(name: 'CLOUD_PROVIDER', choices: ['AWS', 'Azure'], description: 'Select the cloud provider')
    string(name: 'AWS_REGION', defaultValue: 'eu-central-1', description: 'AWS region where the AMI will be created')
    string(name: 'AWS_ACCESS_KEY_ID', defaultValue: '', description: 'AWS Access Key ID')
    string(name: 'AWS_SECRET_ACCESS_KEY', defaultValue: '', description: 'AWS Secret Access Key')
    string(name: 'AZURE_SUBSCRIPTION_ID', defaultValue: '', description: 'Azure Subscription ID')
    string(name: 'AZURE_CLIENT_ID', defaultValue: '', description: 'Azure Client ID')
    string(name: 'AZURE_CLIENT_SECRET', defaultValue: '', description: 'Azure Client Secret')
    string(name: 'AZURE_TENANT_ID', defaultValue: '', description: 'Azure Tenant ID')
    credentials(name: 'terraform_user', description: 'Git credentials for repository access', defaultValue: '', type: 'UsernamePassword')
}

pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = params.AWS_REGION
        AWS_ACCESS_KEY_ID = params.AWS_ACCESS_KEY_ID
        AWS_SECRET_ACCESS_KEY = params.AWS_SECRET_ACCESS_KEY
    }

    stages {
        stage('Install Packer') {
            steps {
                script {
                    // Install Packer based on the agent's OS
                    if (isUnix()) {
                        sh "curl -o packer.zip https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip && unzip packer.zip && chmod +x packer && mv packer /usr/local/bin/"
                    } else {
                        bat "curl -o packer.zip https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_windows_amd64.zip && Expand-Archive -Path packer.zip -DestinationPath . && Move-Item -Path packer.exe -Destination C:\\Windows\\System32\\"
                    }
                }
            }
        }
        stage('Install AWS-CLI') {
            steps {
                script {
                    // Install AWSCLI based on the agent's OS
                    if (isUnix()) {
                        sh "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && unzip awscliv2.zip && sudo ./aws/install"
                    } else {
                        bat "curl -o packer.zip https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_windows_amd64.zip && Expand-Archive -Path packer.zip -DestinationPath . && Move-Item -Path packer.exe -Destination C:\\Windows\\System32\\"
                    }
                }
            }
        }
        stage('Build Image') {
            steps {
                script {
                    def packerCommand = ''
                    def provider = params.CLOUD_PROVIDER

                    if (provider == 'AWS') {
                        packerCommand = "packer init config.pkr.hcl \
                                        packer build -var 'aws_access_key=${env.AWS_ACCESS_KEY_ID}' -var 'aws_secret_key=${env.AWS_SECRET_ACCESS_KEY}' -var 'region=${env.AWS_DEFAULT_REGION}' -var-file variables/cloud/aws/eu-central-1/common.pkr.hcl \
		                                -var-file variables/cloud/aws/eu-central-1/dev-ce-2.pkr.hcl \
		                                images/cloud/aws/rhel8-base/packer.pkr.hcl"
                    } else if (provider == 'Azure') {
                        packerCommand = "packer build -var 'azure_subscription_id=${params.AZURE_SUBSCRIPTION_ID}' -var 'azure_client_id=${params.AZURE_CLIENT_ID}' -var 'azure_client_secret=${params.AZURE_CLIENT_SECRET}' -var 'azure_tenant_id=${params.AZURE_TENANT_ID}' -var 'image_name=${params.IMAGE_NAME}' azure_packer_template.json"
                    }

                    def packerBuild = bat(returnStatus: true, script: packerCommand)

                    if (packerBuild != 0) {
                        error("Packer build failed with exit code ${packerBuild}")
                    } esle {
                        def amiId = packerBuild.split('artifact,')[1].split(',')[2]
                        echo "AMI ID: ${amiId}"
                    }
                }
            }
        }
    }
        
    post {
        always {
            deleteDir()
        }
    }
}

def isUnix() {
    return !isWindows()
}

def isWindows() {
    return System.properties['os.name'].toLowerCase().contains('win')
}
