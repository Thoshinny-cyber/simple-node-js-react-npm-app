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
                 deleteDir()
                git 'https://github.com/Thoshinny-cyber/simple-node-js-react-npm-app.git'
            }
        }
          stage('Build') {
            steps {
                sh 'tar czf Node.tar.gz package.json public src'
            }
        }

 

        stage('Docker Build'){
    steps{
        sh "echo ${DOCKER_TAG}"
        sshPublisher(publishers: [
            sshPublisherDesc(
                configName: 'docker',
                transfers: [
                    sshTransfer(
                        cleanRemote: false,
                        excludes: '',
                        execCommand: """cd /opt/docker; 
                                        tar -xf Node.tar.gz; 
                                        docker build . -t thoshinny/nodeapp:${DOCKER_TAG}
                                        docker push thoshinny/nodeapp:${DOCKER_TAG}
                                        """,
                        execTimeout: 200000,
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

        stage('Docker Deploy') {
            steps {
                script {
                    def ansiblePlaybookContent = '''
                    - hosts: dev
                      become: True

 

                      tasks:
                        - name: Install python pip
                          yum:
                            name: python-pip
                            state: present

 

                        - name: Install docker-py python module
                          pip:
                            name: docker-py
                            state: present

 

                        - name: Start the container
                          docker_container:
                            name: nodecontainer
                            image: "thoshinny/nodeapp:{{ DOCKER_TAG }}"
                            state: started
                            published_ports:
                              - 0.0.0.0:8081:3000
                    '''

 

                    writeFile(file: 'inline_playbook.yml', text: ansiblePlaybookContent)

 

                   def ansibleInventoryContent = '''[dev]
                    172.31.43.130 ansible_user=ec2-user
                    '''

 

                    writeFile(file: 'dev.inv', text: ansibleInventoryContent)

 

   
                    ansiblePlaybook(
                        inventory: 'dev.inv',
                        playbook: 'inline_playbook.yml',
                        extras: "-e DOCKER_TAG=${DOCKER_TAG}",
                        credentialsId: 'dev-server',
                        installation: 'ansible'
                    )

              }
            }
        }

 

    }

 

post {
    always {

 

 

        emailext(
           body: """
               Build ${env.BUILD_NUMBER} of ${env.JOB_NAME} has completed.
                SCM revision: ${env.GIT_COMMIT}
                Docker tag: ${env.DOCKER_TAG}
            """,
            subject: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} completed",
            to: "thoshlearn@gmail.com",
            recipientProviders: [developers()],
            mimeType: 'text/html',


        )  

 

 

    }
}

 

 

}

 

 

def getVersion(){
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}