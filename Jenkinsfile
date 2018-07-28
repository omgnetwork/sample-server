podTemplate(
    label: 'sample-server',
    containers: [
        containerTemplate(name: 'jnlp', image: 'gcr.io/omise-go/jenkins-slave', args: '${computer.jnlpmac} ${computer.name}'),
        containerTemplate(name: 'postgresql', image: 'postgres:9.6'),
    ],
    volumes: [
        hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
        hostPathVolume(mountPath: '/usr/bin/docker', hostPath: '/usr/bin/docker'),
    ]
) {
    node('sample-server') {
        Random random = new Random()
        def tmpDir = pwd(tmp: true)

        def project = 'omise-go'
        def appName = 'omgshop'
        def imageName = "gcr.io/${project}/${appName}"

        def nodeIP = getNodeIP()
        def gitCommit

        stage('Checkout') {
            checkout scm
        }

        stage('Build') {
            gitCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()

            dir(tmpDir) {
                writeFile(
                    file: "ssh_config",
                    text: """
                    Host github.com
                        User git
                        IdentityFile ~/.ssh/key
                        PreferredAuthentications publickey
                        StrictHostKeyChecking no
                        UserKnownHostsFile /dev/null
                    """.stripIndent()
                )
            }

            withCredentials([[$class: 'SSHUserPrivateKeyBinding', credentialsId: 'github', keyFileVariable: 'GIT_SSH_KEY']]) {
                withEnv(["GIT_SSH_CONFIG=${tmpDir}/ssh_config", "IMAGE=${imageName}", "TAG=${gitCommit}"]) {
                    sh("docker build ${imageName}:${gitCommit}")
                }
            }
        }

        stage('Test') {
            container('postgresql') {
                sh('pg_isready -t 60 -h localhost -p 5432')
            }

            sh(
               """
               docker run --rm \
                   -e DATABASE_URL="postgresql://postgres@${nodeIP}:5432/omgshop_${gitCommit}" \
                   ${imageName}:${gitCommit} \
                   sh -c "cd /app && bundle exec rake db:create && bundle exec rspec"
               """.stripIndent()
            )
        }

        if (env.BRANCH_NAME == 'master') {
            stage('Push') {
                sh("gcloud docker -- push ${imageName}:${gitCommit}")
                sh("gcloud container images add-tag ${imageName}:${gitCommit} ${imageName}:latest")
            }

            stage('Deploy') {
                dir("${tmpDir}/deploy") {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/master']],
                        userRemoteConfigs: [
                            [
                                url: 'ssh://git@github.com/omisego/kube.git',
                                credentialsId: 'github',
                            ],
                        ]
                    ])

                    sh("sed -i.bak 's#${imageName}:latest#${imageName}:${gitCommit}#' staging/k8s/sample/deployment.yaml")
                    sh("kubectl apply -f staging/k8s/sample/deployment.yaml")
                    sh("kubectl rollout status --namespace=staging deployment/sample")

                    def podID = getPodID('--namespace=staging -l app=sample')
                    sh("kubectl exec ${podID} --namespace=staging bundle exec rake db:migrate")
                }
            }
        }
    }
}

String getNodeIP() {
    def rawNodeIP = sh(script: 'ip -4 -o addr show scope global', returnStdout: true).trim()
    def matched = (rawNodeIP =~ /inet (\d+\.\d+\.\d+\.\d+)/)
    return "" + matched[0].getAt(1)
}

String getPodID(String opts) {
    def pods = sh(script: "kubectl get pods ${opts} -o name", returnStdout: true).trim()
    def matched = (pods.split()[0] =~ /pods\/(.+)/)
    return "" + matched[0].getAt(1)
}
