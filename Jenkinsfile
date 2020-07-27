pipeline{
    agent any
     environment{
           DOCKER_TAG = getDockerTag()
     }
     
     stages{
         stage('Build docker image'){
             steps{
                  sh 'docker build -t relventech/kubernates .'
             }
         }
         stage('Push Docker Image'){
             steps{
            withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
                sh "docker login -u relventech -p ${dockerHubPwd}"
                sh 'docker push relventech/kubernates'
             }
             }
        }
        stage('Deploy to k8s'){
            steps{
                sh 'chmod +x changeTag.sh'
                sh './changeTag.sh'
                sshagent(['main-server']) {
                sh "scp -o StrictHostKeyChecking=no services.yml pods.yml ec2-user@100.26.224.21:/home/ec2-user/"
                script{
                    try{
                        sh "ssh ec2-user@100.26.224.21 kubectl apply -f ."
                    }catch(error){
                        sh "ssh ec2-user@100.26.224.21 kubectl create -f ."
                    }
                }
            }
            }
        }
     }
}
def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
