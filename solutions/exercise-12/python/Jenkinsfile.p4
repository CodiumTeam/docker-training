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
            }
            steps {
                sh '''
                    export COMMIT_SHORT_SHA=`git rev-parse --short HEAD`
                    docker login -u $REGISTRY_CREDENTIALS_USR -p $REGISTRY_CREDENTIALS_PSW registry.local
                    docker tag registry.local/my_flask_app registry.local/my_flask_app:$COMMIT_SHORT_SHA
                    docker push registry.local/my_flask_app:$COMMIT_SHORT_SHA
                    docker push registry.local/my_flask_app
                '''
            }
        }
    }
}
