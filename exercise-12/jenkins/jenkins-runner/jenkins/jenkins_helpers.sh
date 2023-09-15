JENKINS_URL="http://localhost:8080"
PIPELINE_NAME="flask-app"

function wait_for_jenkins_to_be_ready() {
  until curl -s --fail "${JENKINS_URL}/login" > /dev/null
  do
    echo "Waiting for Jenkins server to be ready ..."
    sleep 1
  done
}

function initialize() {
  export JENKINS_PASSWORD=`docker compose exec executor cat /var/jenkins_home/secrets/initialAdminPassword`
  export JENKINS_CRUMB=`request_crumb`

  echo "Initialization completed"
  echo "  password: $JENKINS_PASSWORD"
  echo "     crumb: $(echo $JENKINS_CRUMB|cut -d: -f2)"
}

function request_crumb() {
  curl -s --fail "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)" \
    -u admin:$JENKINS_PASSWORD \
    --cookie-jar /tmp/cookies
}

function create_pipeline() {
  curl -s --fail -X POST "${JENKINS_URL}/createItem?name=${PIPELINE_NAME}" \
    -u admin:$JENKINS_PASSWORD \
    --data-binary @jenkins/config.xml \
    -H "Content-Type:text/xml" \
    -H "$JENKINS_CRUMB" \
    --cookie /tmp/cookies

  echo "Pipeline created"
}

function get_last_pipeline() {
  curl -s --fail "${JENKINS_URL}/job/${PIPELINE_NAME}/job/master/lastBuild/api/json" \
    -u admin:$JENKINS_PASSWORD \
    -H "$JENKINS_CRUMB" \
    --cookie /tmp/cookies
}

function wait_for_pipeline_job_created() {
  until get_last_pipeline
  do
    echo "Waiting for pipeline to create ..."
    sleep 3
  done
}

function wait_for_pipeline_job_completion() {
  until [ $(get_last_pipeline | jq -r ".inProgress") = "false" ]
  do
    echo "Waiting for pipeline to complete ..."
    sleep 3
  done
}