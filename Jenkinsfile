pipeline{
    agent any
    tools {
      nodejs 'node'
    }
    environment {
      DOCKER_TAG = getVersion()
    }
    stages{
        stage('SCM'){
            steps{
                git credentialsId: 'github', 
                    url: 'https://github.com/Thoshinny-cyber/simple-node-js-react-npm-app.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'tar czf Node.tar.gz package.json public src'
                 sh "npm install"
            }
        }
        
        stage('Docker Build'){
            steps{
                sh "tar -xf Node.tar.gz"
                sh "docker build . -t thoshinny/nodeapp:${DOCKER_TAG} "
            }
        }
        
        stage('DockerHub Push'){
            steps{
                withCredentials([string(credentialsId: 'docker_hub1', variable: 'dockerHubPwd')]) {
                    sh "docker login -u thoshinny -p ${dockerHubPwd}"
                }
                
                sh "docker push thoshinny/nodeapp:${DOCKER_TAG} "
            }
        }
        
        stage('Docker Deploy'){
            steps{
              ansiblePlaybook credentialsId: 'dev-server', disableHostKeyChecking: true, extras: "-e DOCKER_TAG=${DOCKER_TAG}", installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
    }
}

def getVersion(){
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
