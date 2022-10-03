pipeline {
    agent any
    environment {
        COMPOSE_DOCKER_CLI_BUILD = 1
        DOCKER_BUILDKIT          = 1
    }
    stages {
        stage('build') {
            steps {
                sh 'docker build -t registry.local/my_flask_app flask'
            }
        }
        stage('test') {
           steps {
                sh '''
                    docker compose up -d --wait
                    export MSG=`curl -s http://docker:8000`
                    [ "$MSG" = "Hello from the MongoDB client!" ]
                '''
            }
            post {
                always {
                    sh 'docker compose down -v'
                }
            }
        }
        stage('release') {
            environment {
                REGISTRY_CREDENTIALS = credentials('docker-registry-local')
        	    REGISTRY		     = 'registry.local'
                COMMIT_SHORT_SHA     = sh('git rev-parse --short HEAD')
            }
            steps {
                sh '''
                    docker login -u $REGISTRY_CREDENTIALS_USR -p $REGISTRY_CREDENTIALS_PSW $REGISTRY
                    docker tag $REGISTRY/my_flask_app $REGISTRY/my_flask_app:$COMMIT_SHORT_SHA
                    docker push $REGISTRY/my_flask_app:$COMMIT_SHORT_SHA
                    docker push $REGISTRY/my_flask_app
                '''
            }
        }
    }
}
