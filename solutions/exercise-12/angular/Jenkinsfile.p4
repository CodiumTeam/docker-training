pipeline {
    agent any
    options {
        parallelsAlwaysFailFast()
    }   
    environment {
        COMPOSE_DOCKER_CLI_BUILD = 1
        DOCKER_BUILDKIT          = 1
        REGISTRY		         = 'registry.local'
    }
    stages {
        stage('build and test') {
            parallel {
                stage('build') {
                    environment {
                       SNYK_TOKEN  = credentials('snyk-token')
                    }
                    steps {
                        sh '''
                            curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --
                            docker login -u $REGISTRY_CREDENTIALS_USR -p $REGISTRY_CREDENTIALS_PSW $REGISTRY
                            docker build -t $REGISTRY/my-angular-app:latest .
                        '''
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            sh 'docker scout quickview $REGISTRY/my-angular-app:latest'
                        }
                    }
                }
                stage('test') {
                    steps {
                        sh '''
                            docker build -t my-angular-app:test-latest --target test .
                            docker run --rm -v ${PWD}/karma-tests:/app/karma-tests my-angular-app:test-latest
                        '''
                        junit 'karma-tests/results.xml'
                    }
                }
            }
        }

        stage('release') {
            environment {
                REGISTRY_CREDENTIALS = credentials('docker-registry-local')
                COMMIT_SHORT_SHA     = sh('git rev-parse --short HEAD')
            }
            steps {
                sh '''
                    docker login -u $REGISTRY_CREDENTIALS_USR -p $REGISTRY_CREDENTIALS_PSW $REGISTRY
                    docker tag $REGISTRY/my-angular-app $REGISTRY/my-angular-app:$COMMIT_SHORT_SHA
                    docker push $REGISTRY/my-angular-app:$COMMIT_SHORT_SHA
                    docker push $REGISTRY/my-angular-app
                '''
            }
        }
    }
}