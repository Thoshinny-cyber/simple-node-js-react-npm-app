pipeline{
    agent any
    tools {
      nodejs 'node'
    }
    environment {
      DOCKER_TAG = getVersion()
      DOCKER_CRED= credentials('docker_hub1')
      ANSIBLE_EXTRAS="-e DOCKER_TAG=latest"
      ANSIBLE_CREDENTIALS= credentials('dev-server')
      ANSIBLE_INVENTORY='dev.inv'
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
              script {
                    def ansibleCode = """
            ---
            - hosts: dev
              become: True
              tasks:
                - name: Install python pip
                  yum:
                    name: python-pip
                    state: present
                - name: Install docker
                  yum:
                    name: docker
                    state: present
                - name: start docker
                  service:
                    name: docker
                    state: started
                    enabled: yes
                - name: Install docker-py python module
                  pip:
                    name: docker-py
                    state: present
                - name: Start the container
                  docker_container:
                    name: javaapp
                    image: "thoshinny/nodeapp:latest"
                    state: started
                    published_ports:
                      - 0.0.0.0:8081:3000
            """
                //     def playbookFile = writeFile file: 'ansible-playbook.yml', text: ansibleCode
                //     sh "ansible-playbook ${playbookFile} --inventory-file=${env.ANSIBLE_INVENTORY} --extra-vars='${env.ANSIBLE_EXTRAS}'"
                def playbookFile = writeFile file: 'ansible-temp.yaml', text: ansibleCode

sh """
ansible-playbook -i $ANSIBLE_INVENTORY ansible-temp.yaml
"""

                }
              //ansiblePlaybook credentialsId: 'dev-server', disableHostKeyChecking: true, extras: "-e DOCKER_TAG=latest", installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
               
            }
        }
    }
}

def getVersion(){
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
