pipeline{
    agent any
    tools {
      nodejs 'node'
    }
    environment {
      DOCKER_TAG = getVersion()
      DOCKER_CRED= credentials('docker_hub1')
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
            }
        }
        
        stage('Docker Build'){
            steps{
                //sh "tar -xf Node.tar.gz"
                //sh "docker build . -t thoshinny/nodeapp:${DOCKER_TAG} "
                sshPublisher(publishers: [
    sshPublisherDesc(
        configName: 'dockerhost',
        transfers: [
            sshTransfer(
                cleanRemote: false,
                excludes: '',
                execCommand: """cd /opt/docker; 
                                tar -xf Node.tar.gz; 
                                docker build . -t thoshinny/nodeapp:latest;
                                docker login -u thoshinny -p $DOCKER_CRED ;
                                docker push thoshinny/nodeapp:latest""",
                execTimeout: 120000,
                flatten: false,
                makeEmptyDirs: false,
                noDefaultExcludes: false,
                patternSeparator: '[, ]+$',
                remoteDirectory: '//opt//docker',
                remoteDirectorySDF: false,
                removePrefix: '',
                sourceFiles: '**/*.gz'
            )
        ],
        usePromotionTimestamp: false,
        useWorkspaceInPromotion: false,
        verbose: true
    )
])

        }
        }
        
        //stage('DockerHub Push'){
          //  steps{
            //    withCredentials([string(credentialsId: 'docker_hub1', variable: 'dockerHubPwd')]) {
              //      sh "docker login -u thoshinny -p ${dockerHubPwd}"
                //}
                
                //sh "docker push thoshinny/nodeapp:${DOCKER_TAG} "
            //}
        //}
        
        stage('Docker Deploy'){
            steps{
              ansiblePlaybook credentialsId: 'dev-server', disableHostKeyChecking: true, extras: "-e DOCKER_TAG=latest", installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
    }
}

def getVersion(){
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
